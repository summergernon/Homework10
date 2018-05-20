-- Select our database to use
USE sakila;

-- 1a. Display first and last names of all actors from the 'actor' table
SELECT first_name, last_name FROM actor;

-- 1b. Display first and last name of each actor in a column in upper case and name the column 'Actor Name'
SELECT CONCAT (first_name, ' ', last_name) AS 'Actor Name'
FROM actor;

-- 2a. Find ID, first name, and last name of actor with the first name "Joe"
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last names contain the letters 'gen'
SELECT *
FROM actor
WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters 'li' and order by last name and first name
SELECT *
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name;

-- 2d. display 'country_id' and 'country' columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a 'middle_name' column to the actor table
ALTER TABLE actor
ADD middle_name VARCHAR(15)
AFTER first_name;

-- 3b. Change the data type of 'middle_name' to blobs
ALTER TABLE actor
MODIFY middle_name blob;

-- 3c. Delete the 'middle_name' column
ALTER TABLE actor
DROP middle_name;

-- 4a. List the last names of actors and how many actors have that name
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c. Fix 'GROUCHO WILLIAMS' record
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Change 'HARPO' back to 'GROUCHO'
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'

-- 5a. Locate schema of the address table
SHOW CREATE TABLE address;


-- 6a. Use 'JOIN' to display the first and last names, address of each staff member
SELECT	staff.first_name, staff.last_name, address.address
FROM staff
JOIN address
ON address.address_id = staff.address_id;

-- 6b. Use 'JOIN' to display the total amount by each staff member in Aug 2005
SELECT SUM(payment.amount), staff.first_name, staff.last_name
FROM payment
JOIN staff
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date  = '2005-08-01';

-- 6c. List each film and the number of actors who are listed for that film
SELECT film.title, COUNT(film_actor.actor_id)
FROM film_actor
INNER JOIN film
ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. Copies of 'Hunchback Impossible'
SELECT inventory.film_id
FROM inventory
JOIN film
ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- 6e. Use payment and customer to list the total paid by each customer
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM payment
JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;

-- 7a. Display titles of movies starting with 'K' and 'Q'
SELECT *
FROM language
WHERE language_id IN
	(
		SELECT language_id
		FROM language
		WHERE name = 'English' IN
			(
				SELECT title
                FROM film
                WHERE title LIKE 'K%' OR title LIKE 'Q%')
	);

SELECT title
FROM film
WHERE title IN
	(
		SELECT title
        FROM film
        WHERE title LIKE 'K%' OR title LIKE 'Q%' IN
		(
			SELECT language_id
            FROM language
            WHERE name = 'English')
	);

-- 7b. Display actors who were in 'Alone Trip'
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
		SELECT actor_id
        FROM film_actor
        WHERE film_id IN
			(
				SELECT film_id
                FROM film
                WHERE title = 'Alone Trip')
	);

-- 7c.
SELECT first_name, last_name, email, customer_id, country.country
FROM customer
JOIN address
ON address.address_id = customer.address_id
JOIN city
ON city.city_id = address.city_id
JOIN country
ON country.country_id = city.country_id
WHERE country = 'Canada';

-- 7d. 
SELECT family.title, category.cateogory_id
FROM film
LEFT JOIN film_category
ON film.film_id = film_category.film_id
LEFT JOIN category
ON category.category_id = film_category.category_id
WHERE category.category_id = 8;

-- 7e. 
SELECT MAX(rental_duration)
FROM film;
SELECT title
FROM film
WHERE rental_duration = 7
ORDER BY title DESC
LIMIT 10;

