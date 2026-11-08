-- Зміна типів текстових стовпців після імпорту
ALTER TABLE public.consumer_prices_working
ALTER COLUMN "Тип товарів і послуг" TYPE VARCHAR(255),
ALTER COLUMN "Спеціальне значення даних" TYPE VARCHAR(255),
ALTER COLUMN "Категорія" TYPE VARCHAR(255),
ALTER COLUMN "Підкатегорія " TYPE VARCHAR(255);

-- Перевірка кількості записів
SELECT COUNT(*)
FROM public.consumer_prices_working;

-- Перегляд перших 10 записів
SELECT *
FROM public.consumer_prices_working
LIMIT 10;

-- Створення таблиці для індексу споживчих цін
CREATE TABLE public.cpi_index_working (
    "Базисний період" VARCHAR(255),
    "Тип товарів і послуг" VARCHAR(255),
    "Місяць" VARCHAR(20),
    "Значення ІСЦ" NUMERIC(10,2),
    "Спеціальне значення даних" VARCHAR(255)
);

-- Перевірка кількості записів після імпорту
SELECT COUNT(*)
FROM public.cpi_index_working;

-- Перевірка кількості записів після імпорту
SELECT *
FROM public.cpi_index_working
LIMIT 5;

-- Перевірка кількості записів за базисним періодом
SELECT
    "Базисний період",
    COUNT(*) AS rows_count
FROM public.cpi_index_working
GROUP BY "Базисний період";

--Створення таблиці для середньомісячної заробітної плати
CREATE TABLE public.average_wage_working (
    "Показник" VARCHAR(255),
    "Місяць" VARCHAR(20),
    "Заробітна плата" NUMERIC(12,2),
    "Спеціальне значення даних" VARCHAR(255)
);

-- Перевірка кількості записів після імпорту
SELECT COUNT(*)
FROM public.average_wage_working;

-- Перегляд перших 10 записів
SELECT *
FROM public.average_wage_working
ORDER BY "Місяць"
LIMIT 10;

--Перевірка кількості записів у таблиці зарплат 
SELECT
    COUNT(*) AS total_rows, -- Загальна кількість місячних записів
    COUNT("Заробітна плата") AS filled_wages, -- Кількість заповнених значень зарплати
    COUNT(*) - COUNT("Заробітна плата") AS missing_wages -- Кількість пропусків
FROM public.average_wage_working;

-- Визначаємо перший і останній місяць, а також кількість унікальних місяців у таблиці
SELECT
    MIN("Місяць") AS first_month,
    MAX("Місяць") AS last_month,
    COUNT(DISTINCT "Місяць") AS total_months
FROM public.consumer_prices_working;

-- Шукаємо товари, які мають більше одного запису за місяць
SELECT
    "Тип товарів і послуг",
    "Місяць",
    COUNT(*) AS records_count
FROM public.consumer_prices_working
GROUP BY
    "Тип товарів і послуг",
    "Місяць"
HAVING COUNT(*) > 1
ORDER BY
    "Тип товарів і послуг",
    "Місяць";

-- Підраховуємо загальну кількість записів,  заповнених цін, пропусків, нульових та від'ємних значень
SELECT
    COUNT(*) AS total_rows,
    COUNT("Ціна") AS filled_prices,
    COUNT(*) - COUNT("Ціна") AS missing_prices,
    COUNT(*) FILTER (WHERE "Ціна" = 0) AS zero_prices,
    COUNT(*) FILTER (WHERE "Ціна" < 0) AS negative_prices
FROM public.consumer_prices_working;

-- Перевіряємо наявність спеціальних статистичних позначок
SELECT
    "Тип товарів і послуг",
    "Спеціальне значення даних",
    COUNT(*) AS records_count
FROM public.consumer_prices_working
WHERE "Спеціальне значення даних" IS NOT NULL
  AND TRIM("Спеціальне значення даних") <> ''
GROUP BY
    "Тип товарів і послуг",
    "Спеціальне значення даних"
ORDER BY
    "Тип товарів і послуг";

-- Підраховуємо кількість різних товарів і послуг у таблиці
SELECT
    COUNT(DISTINCT "Тип товарів і послуг") AS unique_items
FROM public.consumer_prices_working;

-- Перевіряємо кількість записів за кожним базисним періодом
SELECT
    "Базисний період",
    COUNT(*) AS records_count
FROM public.cpi_index_working
GROUP BY "Базисний період"
ORDER BY "Базисний період";

-- Визначаємо перший і останній місяць та кількість унікальних місяців у таблиці ІСЦ
SELECT
    MIN("Місяць") AS first_month,
    MAX("Місяць") AS last_month,
    COUNT(DISTINCT "Місяць") AS total_months
FROM public.cpi_index_working;

-- Підраховуємо загальну кількість записів, заповнені значення ІСЦ та пропуски
SELECT
    COUNT(*) AS total_rows,
    COUNT("Значення ІСЦ") AS filled_values,
    COUNT(*) - COUNT("Значення ІСЦ") AS missing_values
FROM public.cpi_index_working;

-- Перевіряємо наявність нульових та від'ємних значень індексу
SELECT
    COUNT(*) FILTER (WHERE "Значення ІСЦ" = 0) AS zero_values,
    COUNT(*) FILTER (WHERE "Значення ІСЦ" < 0) AS negative_values
FROM public.cpi_index_working;

-- Знаходимо спеціальні статистичні позначки та підраховуємо кількість записів для кожної
SELECT
    "Тип товарів і послуг",
    "Спеціальне значення даних",
    COUNT(*) AS records_count
FROM public.cpi_index_working
WHERE "Спеціальне значення даних" IS NOT NULL
  AND TRIM("Спеціальне значення даних") <> ''
GROUP BY
    "Тип товарів і послуг",
    "Спеціальне значення даних"
ORDER BY
    "Тип товарів і послуг";

-- Перевіряємо, чи немає повторних записів для одного показника, місяця та базисного періоду
SELECT
    "Базисний період",
    "Тип товарів і послуг",
    "Місяць",
    COUNT(*) AS records_count
FROM public.cpi_index_working
GROUP BY
    "Базисний період",
    "Тип товарів і послуг",
    "Місяць"
HAVING COUNT(*) > 1;

-- Підраховуємо кількість різних показників у таблиці ІСЦ
SELECT
    COUNT(DISTINCT "Тип товарів і послуг") AS unique_indicators
FROM public.cpi_index_working;

-- Визначаємо перший і останній місяць та кількість унікальних місяців у таблиці зарплат
SELECT
    MIN("Місяць") AS first_month,
    MAX("Місяць") AS last_month,
    COUNT(DISTINCT "Місяць") AS total_months
FROM public.average_wage_working;

-- Підраховуємо загальну кількість місяців, заповнені значення зарплати та пропуски
SELECT
    COUNT(*) AS total_rows,
    COUNT("Заробітна плата") AS filled_wages,
    COUNT(*) - COUNT("Заробітна плата") AS missing_wages
FROM public.average_wage_working;

-- Перевіряємо наявність нульових та від'ємних значень
SELECT
    COUNT(*) FILTER (WHERE "Заробітна плата" = 0) AS zero_wages,
    COUNT(*) FILTER (WHERE "Заробітна плата" < 0) AS negative_wages
FROM public.average_wage_working;

-- Шукаємо місяці, які повторюються більше одного разу
SELECT
    "Місяць",
    COUNT(*) AS records_count
FROM public.average_wage_working
GROUP BY "Місяць"
HAVING COUNT(*) > 1
ORDER BY "Місяць";

-- Створюємо представлення з датою першого дня кожного місяця
CREATE OR REPLACE VIEW public.consumer_prices_prepared AS
SELECT
    "Тип товарів і послуг",
    TO_DATE(
        REPLACE("Місяць", '-M', '-'),
        'YYYY-MM'
    ) AS month_date,
    "Ціна",
    "Спеціальне значення даних",
    "Категорія",
    "Підкатегорія "
FROM public.consumer_prices_working;

-- Перевіряємо перші 10 записів підготовленого представлення
SELECT *
FROM public.consumer_prices_prepared
ORDER BY month_date
LIMIT 10;

-- Перевіряємо кількість записів, пропуски дат та часовий діапазон
SELECT
    COUNT(*) AS total_rows,
    COUNT(month_date) AS filled_dates,
    COUNT(*) - COUNT(month_date) AS missing_dates,
    MIN(month_date) AS first_date,
    MAX(month_date) AS last_date
FROM public.consumer_prices_prepared;

-- Створюємо нове представлення з календарними полями на основі вже підготовленого представлення
CREATE OR REPLACE VIEW public.consumer_prices_analysis AS
SELECT
    "Тип товарів і послуг",
    month_date,
    EXTRACT(YEAR FROM month_date)::INTEGER AS calendar_year,
    EXTRACT(MONTH FROM month_date)::INTEGER AS month_number,
    "Ціна",
    "Спеціальне значення даних",
    "Категорія",
    "Підкатегорія "
FROM public.consumer_prices_prepared;

-- Перевіряємо календарні поля у підготовлених даних
SELECT
    "Тип товарів і послуг",
    month_date,
    calendar_year,
    month_number,
    "Ціна"
FROM public.consumer_prices_analysis
ORDER BY month_date
LIMIT 10;

-- Створюємо представлення з датою першого дня кожного місяця
CREATE OR REPLACE VIEW public.cpi_index_prepared AS
SELECT
    "Базисний період",
    "Тип товарів і послуг",
    TO_DATE(
        REPLACE("Місяць", '-M', '-'),
        'YYYY-MM'
    ) AS month_date,
    "Значення ІСЦ",
    "Спеціальне значення даних"
FROM public.cpi_index_working;

-- Перевіряємо перші 10 записів підготовленого представлення ІСЦ
SELECT *
FROM public.cpi_index_prepared
ORDER BY month_date
LIMIT 10;

-- Створюємо розширене представлення з роком і номером місяця
CREATE OR REPLACE VIEW public.cpi_index_analysis AS
SELECT
    "Базисний період",
    "Тип товарів і послуг",
    month_date,
    EXTRACT(YEAR FROM month_date)::INTEGER AS calendar_year,
    EXTRACT(MONTH FROM month_date)::INTEGER AS month_number,
    "Значення ІСЦ",
    "Спеціальне значення даних"
FROM public.cpi_index_prepared;

-- Зміна типів текстових стовпців після імпорту
ALTER TABLE public.consumer_prices_working
ALTER COLUMN "Тип товарів і послуг" TYPE VARCHAR(255),
ALTER COLUMN "Спеціальне значення даних" TYPE VARCHAR(255),
ALTER COLUMN "Категорія" TYPE VARCHAR(255),
ALTER COLUMN "Підкатегорія " TYPE VARCHAR(255);

-- Перевірка кількості записів
SELECT COUNT(*)
FROM public.consumer_prices_working;

-- Перегляд перших 10 записів
SELECT *
FROM public.consumer_prices_working
LIMIT 10;

-- Створення таблиці для індексу споживчих цін
CREATE TABLE public.cpi_index_working (
    "Базисний період" VARCHAR(255),
    "Тип товарів і послуг" VARCHAR(255),
    "Місяць" VARCHAR(20),
    "Значення ІСЦ" NUMERIC(10,2),
    "Спеціальне значення даних" VARCHAR(255)
);

-- Перевірка кількості записів після імпорту
SELECT COUNT(*)
FROM public.cpi_index_working;

-- Перевірка кількості записів після імпорту
SELECT *
FROM public.cpi_index_working
LIMIT 5;

-- Перевірка кількості записів за базисним періодом
SELECT
    "Базисний період",
    COUNT(*) AS rows_count
FROM public.cpi_index_working
GROUP BY "Базисний період";

--Створення таблиці для середньомісячної заробітної плати
CREATE TABLE public.average_wage_working (
    "Показник" VARCHAR(255),
    "Місяць" VARCHAR(20),
    "Заробітна плата" NUMERIC(12,2),
    "Спеціальне значення даних" VARCHAR(255)
);

-- Перевірка кількості записів після імпорту
SELECT COUNT(*)
FROM public.average_wage_working;

-- Перегляд перших 10 записів
SELECT *
FROM public.average_wage_working
ORDER BY "Місяць"
LIMIT 10;

--Перевірка кількості записів у таблиці зарплат 
SELECT
    COUNT(*) AS total_rows, -- Загальна кількість місячних записів
    COUNT("Заробітна плата") AS filled_wages, -- Кількість заповнених значень зарплати
    COUNT(*) - COUNT("Заробітна плата") AS missing_wages -- Кількість пропусків
FROM public.average_wage_working;

-- Визначаємо перший і останній місяць, а також кількість унікальних місяців у таблиці
SELECT
    MIN("Місяць") AS first_month,
    MAX("Місяць") AS last_month,
    COUNT(DISTINCT "Місяць") AS total_months
FROM public.consumer_prices_working;

-- Шукаємо товари, які мають більше одного запису за місяць
SELECT
    "Тип товарів і послуг",
    "Місяць",
    COUNT(*) AS records_count
FROM public.consumer_prices_working
GROUP BY
    "Тип товарів і послуг",
    "Місяць"
HAVING COUNT(*) > 1
ORDER BY
    "Тип товарів і послуг",
    "Місяць";

-- Підраховуємо загальну кількість записів,  заповнених цін, пропусків, нульових та від'ємних значень
SELECT
    COUNT(*) AS total_rows,
    COUNT("Ціна") AS filled_prices,
    COUNT(*) - COUNT("Ціна") AS missing_prices,
    COUNT(*) FILTER (WHERE "Ціна" = 0) AS zero_prices,
    COUNT(*) FILTER (WHERE "Ціна" < 0) AS negative_prices
FROM public.consumer_prices_working;

-- Перевіряємо наявність спеціальних статистичних позначок
SELECT
    "Тип товарів і послуг",
    "Спеціальне значення даних",
    COUNT(*) AS records_count
FROM public.consumer_prices_working
WHERE "Спеціальне значення даних" IS NOT NULL
  AND TRIM("Спеціальне значення даних") <> ''
GROUP BY
    "Тип товарів і послуг",
    "Спеціальне значення даних"
ORDER BY
    "Тип товарів і послуг";

-- Підраховуємо кількість різних товарів і послуг у таблиці
SELECT
    COUNT(DISTINCT "Тип товарів і послуг") AS unique_items
FROM public.consumer_prices_working;

-- Перевіряємо кількість записів за кожним базисним періодом
SELECT
    "Базисний період",
    COUNT(*) AS records_count
FROM public.cpi_index_working
GROUP BY "Базисний період"
ORDER BY "Базисний період";

-- Визначаємо перший і останній місяць та кількість унікальних місяців у таблиці ІСЦ
SELECT
    MIN("Місяць") AS first_month,
    MAX("Місяць") AS last_month,
    COUNT(DISTINCT "Місяць") AS total_months
FROM public.cpi_index_working;

-- Підраховуємо загальну кількість записів, заповнені значення ІСЦ та пропуски
SELECT
    COUNT(*) AS total_rows,
    COUNT("Значення ІСЦ") AS filled_values,
    COUNT(*) - COUNT("Значення ІСЦ") AS missing_values
FROM public.cpi_index_working;

-- Перевіряємо наявність нульових та від'ємних значень індексу
SELECT
    COUNT(*) FILTER (WHERE "Значення ІСЦ" = 0) AS zero_values,
    COUNT(*) FILTER (WHERE "Значення ІСЦ" < 0) AS negative_values
FROM public.cpi_index_working;

-- Знаходимо спеціальні статистичні позначки та підраховуємо кількість записів для кожної
SELECT
    "Тип товарів і послуг",
    "Спеціальне значення даних",
    COUNT(*) AS records_count
FROM public.cpi_index_working
WHERE "Спеціальне значення даних" IS NOT NULL
  AND TRIM("Спеціальне значення даних") <> ''
GROUP BY
    "Тип товарів і послуг",
    "Спеціальне значення даних"
ORDER BY
    "Тип товарів і послуг";

-- Перевіряємо, чи немає повторних записів для одного показника, місяця та базисного періоду
SELECT
    "Базисний період",
    "Тип товарів і послуг",
    "Місяць",
    COUNT(*) AS records_count
FROM public.cpi_index_working
GROUP BY
    "Базисний період",
    "Тип товарів і послуг",
    "Місяць"
HAVING COUNT(*) > 1;

-- Підраховуємо кількість різних показників у таблиці ІСЦ
SELECT
    COUNT(DISTINCT "Тип товарів і послуг") AS unique_indicators
FROM public.cpi_index_working;

-- Визначаємо перший і останній місяць та кількість унікальних місяців у таблиці зарплат
SELECT
    MIN("Місяць") AS first_month,
    MAX("Місяць") AS last_month,
    COUNT(DISTINCT "Місяць") AS total_months
FROM public.average_wage_working;

-- Підраховуємо загальну кількість місяців, заповнені значення зарплати та пропуски
SELECT
    COUNT(*) AS total_rows,
    COUNT("Заробітна плата") AS filled_wages,
    COUNT(*) - COUNT("Заробітна плата") AS missing_wages
FROM public.average_wage_working;

-- Перевіряємо наявність нульових та від'ємних значень
SELECT
    COUNT(*) FILTER (WHERE "Заробітна плата" = 0) AS zero_wages,
    COUNT(*) FILTER (WHERE "Заробітна плата" < 0) AS negative_wages
FROM public.average_wage_working;

-- Шукаємо місяці, які повторюються більше одного разу
SELECT
    "Місяць",
    COUNT(*) AS records_count
FROM public.average_wage_working
GROUP BY "Місяць"
HAVING COUNT(*) > 1
ORDER BY "Місяць";

-- Створюємо представлення з датою першого дня кожного місяця
CREATE OR REPLACE VIEW public.consumer_prices_prepared AS
SELECT
    "Тип товарів і послуг",
    TO_DATE(
        REPLACE("Місяць", '-M', '-'),
        'YYYY-MM'
    ) AS month_date,
    "Ціна",
    "Спеціальне значення даних",
    "Категорія",
    "Підкатегорія "
FROM public.consumer_prices_working;

-- Перевіряємо перші 10 записів підготовленого представлення
SELECT *
FROM public.consumer_prices_prepared
ORDER BY month_date
LIMIT 10;

-- Перевіряємо кількість записів, пропуски дат та часовий діапазон
SELECT
    COUNT(*) AS total_rows,
    COUNT(month_date) AS filled_dates,
    COUNT(*) - COUNT(month_date) AS missing_dates,
    MIN(month_date) AS first_date,
    MAX(month_date) AS last_date
FROM public.consumer_prices_prepared;

-- Створюємо нове представлення з календарними полями на основі вже підготовленого представлення
CREATE OR REPLACE VIEW public.consumer_prices_analysis AS
SELECT
    "Тип товарів і послуг",
    month_date,
    EXTRACT(YEAR FROM month_date)::INTEGER AS calendar_year,
    EXTRACT(MONTH FROM month_date)::INTEGER AS month_number,
    "Ціна",
    "Спеціальне значення даних",
    "Категорія",
    "Підкатегорія "
FROM public.consumer_prices_prepared;

-- Перевіряємо календарні поля у підготовлених даних
SELECT
    "Тип товарів і послуг",
    month_date,
    calendar_year,
    month_number,
    "Ціна"
FROM public.consumer_prices_analysis
ORDER BY month_date
LIMIT 10;

-- Створюємо представлення з датою першого дня кожного місяця
CREATE OR REPLACE VIEW public.cpi_index_prepared AS
SELECT
    "Базисний період",
    "Тип товарів і послуг",
    TO_DATE(
        REPLACE("Місяць", '-M', '-'),
        'YYYY-MM'
    ) AS month_date,
    "Значення ІСЦ",
    "Спеціальне значення даних"
FROM public.cpi_index_working;

-- Перевіряємо перші 10 записів підготовленого представлення ІСЦ
SELECT *
FROM public.cpi_index_prepared
ORDER BY month_date
LIMIT 10;

-- Створюємо розширене представлення з роком і номером місяця
CREATE OR REPLACE VIEW public.cpi_index_analysis AS
SELECT
    "Базисний період",
    "Тип товарів і послуг",
    month_date,
    EXTRACT(YEAR FROM month_date)::INTEGER AS calendar_year,
    EXTRACT(MONTH FROM month_date)::INTEGER AS month_number,
    "Значення ІСЦ",
    "Спеціальне значення даних"
FROM public.cpi_index_prepared;

CREATE OR REPLACE VIEW public.average_wage_prepared AS
SELECT
    "Показник",
    TO_DATE(
        REPLACE("Місяць", '-M', '-'),
        'YYYY-MM'
    ) AS month_date,
    "Заробітна плата",
    "Спеціальне значення даних"
FROM public.average_wage_working;

-- Перевіряємо перші 10 записів підготовленого представлення зарплат
SELECT *
FROM public.average_wage_prepared
ORDER BY month_date
LIMIT 10;

-- Додаємо календарний рік і номер місяця для подальшого аналізу
CREATE OR REPLACE VIEW public.average_wage_analysis AS
SELECT
    "Показник",
    month_date,
    EXTRACT(YEAR FROM month_date)::INTEGER AS calendar_year,
    EXTRACT(MONTH FROM month_date)::INTEGER AS month_number,
    "Заробітна плата",
    "Спеціальне значення даних"
FROM public.average_wage_prepared;

-- Перевіряємо перші 10 записів розширеного представлення зарплат
SELECT *
FROM public.average_wage_analysis
ORDER BY month_date
LIMIT 10;

-- Перевіряємо наявність цін за січень 2021 та вересень 2026 року
SELECT
    "Тип товарів і послуг",
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) AS price_january_2021,
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) AS price_september_2026
FROM public.consumer_prices_analysis
GROUP BY "Тип товарів і послуг"
ORDER BY "Тип товарів і послуг";

-- Залишаємо тільки товари, для яких бракує хоча б однієї ціни
SELECT
    "Тип товарів і послуг",
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) AS price_january_2021,
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) AS price_september_2026
FROM public.consumer_prices_analysis
GROUP BY "Тип товарів і послуг"
HAVING
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) IS NULL
    OR
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) IS NULL
ORDER BY "Тип товарів і послуг";

-- Порівнюємо ціни за січень 2021 та вересень 2026 року
-- Перетворюємо результат розрахунку на NUMERIC для округлення
SELECT
    "Тип товарів і послуг",
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) AS price_2021,
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) AS price_2026,
    ROUND(
        (
            (
                MAX(CASE
                    WHEN month_date = DATE '2026-09-01'
                    THEN "Ціна"
                END)
                /
                MAX(CASE
                    WHEN month_date = DATE '2021-01-01'
                    THEN "Ціна"
                END)
                - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS price_change_percent
FROM public.consumer_prices_analysis
GROUP BY "Тип товарів і послуг"
HAVING
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) IS NOT NULL
    AND
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) IS NOT NULL
ORDER BY price_change_percent DESC;

-- Створюємо представлення зі зміною цін за січень 2021 – вересень 2026 року
CREATE OR REPLACE VIEW public.consumer_price_change_period AS
SELECT
    "Тип товарів і послуг",
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) AS price_2021,
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) AS price_2026,
    ROUND(
        (
            (
                MAX(CASE
                    WHEN month_date = DATE '2026-09-01'
                    THEN "Ціна"
                END)
                /
                MAX(CASE
                    WHEN month_date = DATE '2021-01-01'
                    THEN "Ціна"
                END)
                - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS price_change_percent
FROM public.consumer_prices_analysis
GROUP BY "Тип товарів і послуг"
HAVING
    MAX(CASE
        WHEN month_date = DATE '2021-01-01'
        THEN "Ціна"
    END) IS NOT NULL
    AND
    MAX(CASE
        WHEN month_date = DATE '2026-09-01'
        THEN "Ціна"
    END) IS NOT NULL;

-- Виводимо 10 позицій із найбільшим зростанням цін
SELECT *
FROM public.consumer_price_change_period
ORDER BY price_change_percent DESC
LIMIT 10;

-- Розраховуємо середнє відсоткове зростання цін для кожної категорії товарів і послуг
SELECT
    cp."Категорія",
    COUNT(*) AS number_of_items,
    ROUND(AVG(pc.price_change_percent), 2) AS average_price_change_percent
FROM public.consumer_price_change_period pc
JOIN public.consumer_prices_analysis cp
    ON pc."Тип товарів і послуг" = cp."Тип товарів і послуг"
GROUP BY cp."Категорія"
ORDER BY average_price_change_percent DESC;

-- Формуємо довідник унікальних товарів та їхніх категорій
-- Розраховуємо середнє зростання цін за категоріями
SELECT
    categories."Категорія",
    COUNT(*) AS number_of_items,
    ROUND(AVG(pc.price_change_percent), 2) AS average_price_change_percent
FROM public.consumer_price_change_period pc
JOIN (
    SELECT DISTINCT
        "Тип товарів і послуг",
        "Категорія"
    FROM public.consumer_prices_analysis
) AS categories
    ON pc."Тип товарів і послуг" = categories."Тип товарів і послуг"
GROUP BY categories."Категорія"
ORDER BY average_price_change_percent DESC;

-- Сортуємо товари та послуги від найменшого зростання до найбільшого
SELECT
    "Тип товарів і послуг",
    price_2021,
    price_2026,
    price_change_percent
FROM public.consumer_price_change_period
ORDER BY price_change_percent ASC
LIMIT 5;

-- Розраховуємо середню ціну кожного товару або послуги за рік
-- 2026 рік охоплює лише січень–вересень
SELECT
    "Тип товарів і послуг",
    calendar_year,
    ROUND(AVG("Ціна")::NUMERIC, 2) AS average_price,
    COUNT("Ціна") AS months_with_data
FROM public.consumer_prices_analysis
GROUP BY
    "Тип товарів і послуг",
    calendar_year
ORDER BY
    "Тип товарів і послуг",
    calendar_year;

-- Переглядаємо середні ціни на білокачанну капусту за роками
SELECT
    calendar_year,
    ROUND(AVG("Ціна")::NUMERIC, 2) AS average_price,
    COUNT("Ціна") AS months_with_data
FROM public.consumer_prices_analysis
WHERE "Тип товарів і послуг" = 'Капуста білокачанна'
GROUP BY calendar_year
ORDER BY calendar_year;

-- Створюємо представлення із середніми річними цін для всіх товарів і послуг
CREATE OR REPLACE VIEW public.consumer_prices_yearly AS
SELECT
    "Тип товарів і послуг",
    calendar_year,
    ROUND(AVG("Ціна")::NUMERIC, 2) AS average_price,
    COUNT("Ціна") AS months_with_data
FROM public.consumer_prices_analysis
GROUP BY
    "Тип товарів і послуг",
    calendar_year;

-- Переглядаємо середні ціни на всі товари за роками
SELECT *
FROM public.consumer_prices_yearly
WHERE "Тип товарів і послуг" = 'Капуста білокачанна'
ORDER BY calendar_year;

-- Перевіряємо кількість позицій, років і місяців із даними
SELECT
    calendar_year,
    COUNT(*) AS number_of_items,
    SUM(months_with_data) AS total_months_with_data,
    MIN(months_with_data) AS min_months_per_item,
    MAX(months_with_data) AS max_months_per_item
FROM public.consumer_prices_yearly
GROUP BY calendar_year
ORDER BY calendar_year;

-- Знаходимо товари та послуги, для яких немає жодного місячного значення ціни протягом року
SELECT
    "Тип товарів і послуг",
    calendar_year,
    months_with_data
FROM public.consumer_prices_yearly
WHERE months_with_data = 0
ORDER BY calendar_year, "Тип товарів і послуг";

-- Рахуємо кількість товарів із повним набором місячних даних
SELECT
    calendar_year,
    COUNT(*) AS total_items,
    COUNT(*) FILTER (
        WHERE months_with_data = CASE
            WHEN calendar_year = 2026 THEN 9
            ELSE 12
        END
    ) AS items_with_full_data,
    COUNT(*) FILTER (
        WHERE months_with_data < CASE
            WHEN calendar_year = 2026 THEN 9
            ELSE 12
        END
    ) AS items_with_missing_data
FROM public.consumer_prices_yearly
GROUP BY calendar_year
ORDER BY calendar_year;

-- Порівнюємо середні ціни кожного товару з попереднім календарним роком
SELECT
    current_year."Тип товарів і послуг",
    current_year.calendar_year,
    previous_year.average_price AS previous_average_price,
    current_year.average_price AS current_average_price,
    ROUND(
        (
            (
                current_year.average_price
                / previous_year.average_price
                - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS yearly_price_change_percent
FROM public.consumer_prices_yearly AS current_year
JOIN public.consumer_prices_yearly AS previous_year
    ON current_year."Тип товарів і послуг" =
       previous_year."Тип товарів і послуг"
    AND current_year.calendar_year =
        previous_year.calendar_year + 1
WHERE
    current_year.months_with_data = 12
    AND previous_year.months_with_data = 12
    AND previous_year.average_price > 0
ORDER BY
    current_year.calendar_year,
    yearly_price_change_percent DESC;

-- Переглядаємо ціни на страхування особистого транспорту за кожен місяць 2024 та 2025 років
SELECT
    month_date,
    "Ціна"
FROM public.consumer_prices_analysis
WHERE
    "Тип товарів і послуг" = 'Послуги у сфері страхування особистого транспорту'
    AND calendar_year IN (2024, 2025)
ORDER BY month_date;

-- Створюємо представлення для порівняння середніх цін кожного товару з попереднім календарним роком
CREATE OR REPLACE VIEW public.consumer_prices_yearly_change AS
SELECT
    current_year."Тип товарів і послуг",
    current_year.calendar_year,
    previous_year.average_price AS previous_average_price,
    current_year.average_price AS current_average_price,
    ROUND(
        (
            (
                current_year.average_price
                / previous_year.average_price
                - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS yearly_price_change_percent
FROM public.consumer_prices_yearly AS current_year
JOIN public.consumer_prices_yearly AS previous_year
    ON current_year."Тип товарів і послуг" =
       previous_year."Тип товарів і послуг"
    AND current_year.calendar_year =
        previous_year.calendar_year + 1
WHERE
    current_year.months_with_data = 12
    AND previous_year.months_with_data = 12
    AND previous_year.average_price > 0;

-- Виводимо 10 позицій із найбільшим зростанням середньої річної ціни у 2025 році
SELECT
    "Тип товарів і послуг",
    previous_average_price,
    current_average_price,
    yearly_price_change_percent
FROM public.consumer_prices_yearly_change
WHERE calendar_year = 2025
  AND "Тип товарів і послуг"
      <> 'Послуги у сфері страхування особистого транспорту'
ORDER BY yearly_price_change_percent DESC
LIMIT 10;

-- Отримуємо загальний ІСЦ для Українимпорівняно з відповідним місяцем попереднього року
SELECT
    month_date,
    "Значення ІСЦ"
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін'
ORDER BY month_date;

-- Узагальнюємо річний ІСЦ за календарними роками
SELECT
    calendar_year,
    COUNT("Значення ІСЦ") AS months_with_data,
    ROUND(
        AVG("Значення ІСЦ"),
        2
    ) AS average_annual_cpi,
    MIN("Значення ІСЦ") AS minimum_cpi,
    MAX("Значення ІСЦ") AS maximum_cpi,
    MAX("Значення ІСЦ") FILTER (
        WHERE month_number = 12
    ) AS december_cpi,
    MAX("Значення ІСЦ") FILTER (
        WHERE month_number = 9
    ) AS september_cpi
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін'
GROUP BY calendar_year
ORDER BY calendar_year;

-- Отримуємо зміну цін порівняно з попереднім місяцем
SELECT
    month_date,
    "Значення ІСЦ"
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін'
ORDER BY month_date;

-- Виводимо 10 найбільших місячних значень ІСЦ
-- Значення понад 100 означає зростання цін
SELECT
    month_date,
    "Значення ІСЦ",
    ROUND(
        ("Значення ІСЦ" - 100)::NUMERIC,
        2
    ) AS monthly_inflation_percent
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін'
    AND "Значення ІСЦ" IS NOT NULL
ORDER BY "Значення ІСЦ" DESC
LIMIT 10;

-- Знаходимо місяці, коли загальний рівень споживчих цін був нижчим, ніж у попередньому місяці
SELECT
    month_date,
    "Значення ІСЦ",
    ROUND(
        ("Значення ІСЦ" - 100)::NUMERIC,
        2
    ) AS monthly_price_change_percent
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін'
    AND "Значення ІСЦ" < 100
ORDER BY "Значення ІСЦ" ASC;

-- Створюємо представлення з місячною динамікою річного індексу споживчих цін
CREATE OR REPLACE VIEW public.cpi_annual_analysis AS
SELECT
    month_date,
    calendar_year,
    month_number,
    "Значення ІСЦ",
    ROUND(
        ("Значення ІСЦ" - 100)::NUMERIC,
        2
    ) AS annual_inflation_percent
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін';

-- Отримуємо перелік усіх показників ІСЦ за базою порівняння з відповідним місяцем попереднього року
SELECT DISTINCT
    "Тип товарів і послуг"
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
ORDER BY
    "Тип товарів і послуг";

-- Перевіряємо кількість місяців із даними для кожної основної категорії ІСЦ
SELECT
    "Тип товарів і послуг",
    COUNT("Значення ІСЦ") AS months_with_data,
    MIN(month_date) AS first_month,
    MAX(month_date) AS last_month
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг"
ORDER BY
    "Тип товарів і послуг";

-- Розраховуємо середній, мінімальний і максимальний ІСЦ за кожною категорією в межах календарного року
SELECT
    "Тип товарів і послуг",
    calendar_year,
    COUNT("Значення ІСЦ") AS months_with_data,
    ROUND(
        AVG("Значення ІСЦ"),
        2
    ) AS average_annual_cpi,
    MIN("Значення ІСЦ") AS minimum_cpi,
    MAX("Значення ІСЦ") AS maximum_cpi,
    MAX("Значення ІСЦ") FILTER (
        WHERE month_number = 12
    ) AS december_cpi,
    MAX("Значення ІСЦ") FILTER (
        WHERE month_number = 9
    ) AS september_cpi
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг",
    calendar_year
ORDER BY
    "Тип товарів і послуг",
    calendar_year;

-- Створюємо представлення для порівняння інфляції за основними категоріями товарів і послуг
CREATE OR REPLACE VIEW public.cpi_category_annual AS
SELECT
    "Тип товарів і послуг",
    calendar_year,
    COUNT("Значення ІСЦ") AS months_with_data,
    ROUND(
        AVG("Значення ІСЦ"),
        2
    ) AS average_annual_cpi,
    ROUND(
        (AVG("Значення ІСЦ") - 100)::NUMERIC,
        2
    ) AS average_annual_inflation_percent,
    MIN("Значення ІСЦ") AS minimum_cpi,
    MAX("Значення ІСЦ") AS maximum_cpi,
    MAX("Значення ІСЦ") FILTER (
        WHERE month_number = 12
    ) AS december_cpi,
    MAX("Значення ІСЦ") FILTER (
        WHERE month_number = 9
    ) AS september_cpi
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До відповідного місяця попереднього року'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг",
    calendar_year;

-- Визначаємо категорії з найвищою та найнижчою середньою річною інфляцією у 2025 році
SELECT
    "Тип товарів і послуг",
    months_with_data,
    average_annual_cpi,
    average_annual_inflation_percent
FROM public.cpi_category_annual
WHERE calendar_year = 2025
ORDER BY
    average_annual_inflation_percent DESC;

-- Виводимо середню річну інфляцію за всіма категоріями у хронологічному порядку від 2021 до 2026 року
SELECT
    calendar_year,
    "Тип товарів і послуг",
    months_with_data,
    average_annual_inflation_percent
FROM public.cpi_category_annual
ORDER BY
    calendar_year,
    average_annual_inflation_percent DESC;

-- Перевіряємо наявність усіх місячних індексів для розрахунку накопиченої інфляції за весь період
SELECT
    "Тип товарів і послуг",
    COUNT("Значення ІСЦ") AS months_with_data,
    MIN(month_date) AS first_month,
    MAX(month_date) AS last_month
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг"
ORDER BY
    "Тип товарів і послуг";

-- Розраховуємо загальну зміну цін за січень 2021 – вересень 2026 року на основі місячних індексів ІСЦ
SELECT
    "Тип товарів і послуг",
    COUNT("Значення ІСЦ") AS months_with_data,
    ROUND(
        (
            (
                EXP(
                    SUM(
                        LN("Значення ІСЦ" / 100.0)
                    )
                ) - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS cumulative_inflation_percent
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг"
ORDER BY
    cumulative_inflation_percent DESC;

-- Виключаємо січень 2021 року, оскільки його індекс порівнює ціни з груднем 2020 року
-- Розраховуємо зміну від рівня цін січня 2021 року
SELECT
    "Тип товарів і послуг",
    COUNT("Значення ІСЦ") AS months_with_data,
    ROUND(
        (
            (
                EXP(
                    SUM(
                        LN("Значення ІСЦ" / 100.0)
                    )
                ) - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS cumulative_inflation_percent
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND month_date > DATE '2021-01-01'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг"
ORDER BY
    cumulative_inflation_percent DESC;

-- Створюємо представлення з накопиченою зміною цін за категоріями за період січень 2021 – вересень 2026
CREATE OR REPLACE VIEW public.cpi_category_cumulative AS
SELECT
    "Тип товарів і послуг",
    COUNT("Значення ІСЦ") AS months_with_data,
    ROUND(
        (
            (
                EXP(
                    SUM(
                        LN("Значення ІСЦ" / 100.0)
                    )
                ) - 1
            ) * 100
        )::NUMERIC,
        2
    ) AS cumulative_inflation_percent
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND month_date > DATE '2021-01-01'
    AND "Тип товарів і послуг" IN (
        'Продукти харчування та безалкогольні напої',
        'Алкогольні напої, тютюнові вироби',
        'Одяг і взуття',
        'Житло, вода, електроенергія, газ та інші види палива',
        'Предмети домашнього вжитку, побутова техніка та поточне утримання житла',
        'Охорона здоров’я',
        'Транспорт',
        'Зв’язок',
        'Відпочинок і культура',
        'Освіта',
        'Ресторани та готелі',
        'Різні товари та послуги'
    )
GROUP BY
    "Тип товарів і послуг";

-- Перевіряємо, скільки місяців мають обидва показники: середню номінальну зарплату та загальний місячний ІСЦ
SELECT
    COUNT(*) AS matched_months,
    MIN(w.month_date) AS first_month,
    MAX(w.month_date) AS last_month,
    COUNT(w."Заробітна плата") AS months_with_wage,
    COUNT(c."Значення ІСЦ") AS months_with_cpi
FROM public.average_wage_analysis w
LEFT JOIN public.cpi_index_analysis c
    ON w.month_date = c.month_date
    AND c."Базисний період" = 'До попереднього місяця'
    AND c."Тип товарів і послуг" = 'Індекс споживчих цін'
WHERE
    w."Заробітна плата" IS NOT NULL;

-- Розраховуємо середню зарплату за календарними роками
-- Враховуємо лише місяці, у яких є фактичні дані
SELECT
    calendar_year,
    COUNT("Заробітна плата") AS months_with_data,
    ROUND(
        AVG("Заробітна плата"),
        2
    ) AS average_monthly_wage,
    MIN("Заробітна плата") AS minimum_wage,
    MAX("Заробітна плата") AS maximum_wage
FROM public.average_wage_analysis
WHERE
    "Заробітна плата" IS NOT NULL
GROUP BY
    calendar_year
ORDER BY
    calendar_year;

-- Порівнюємо середню зарплату повних календарних років
-- Не включаємо неповні 2023 та 2026 роки
WITH yearly_wage AS (
    SELECT
        calendar_year,
        AVG("Заробітна плата") AS average_wage,
        COUNT("Заробітна плата") AS months_with_data
    FROM public.average_wage_analysis
    WHERE "Заробітна плата" IS NOT NULL
    GROUP BY calendar_year
)
SELECT
    current_year.calendar_year,
    ROUND(previous_year.average_wage, 2) AS previous_year_wage,
    ROUND(current_year.average_wage, 2) AS current_year_wage,
    ROUND(
        (
            current_year.average_wage
            / previous_year.average_wage - 1
        ) * 100,
        2
    ) AS wage_growth_percent
FROM yearly_wage current_year
JOIN yearly_wage previous_year
    ON current_year.calendar_year = previous_year.calendar_year + 1
WHERE
    current_year.months_with_data = 12
    AND previous_year.months_with_data = 12
ORDER BY current_year.calendar_year;

-- Порівнюємо середні рівні цін 2025 року з 2024 роком
-- Використовуємо загальний ІСЦ до відповідного місяця попереднього року
WITH yearly_cpi AS (
    SELECT
        calendar_year,
        AVG("Значення ІСЦ") AS average_cpi
    FROM public.cpi_index_analysis
    WHERE
        "Базисний період" = 'До відповідного місяця попереднього року'
        AND "Тип товарів і послуг" = 'Індекс споживчих цін'
        AND calendar_year IN (2024, 2025)
    GROUP BY calendar_year
)
SELECT
    ROUND(
        (
            MAX(average_cpi) FILTER (WHERE calendar_year = 2025)
            /
            MAX(average_cpi) FILTER (WHERE calendar_year = 2024)
            - 1
        ) * 100,
        2
    ) AS approximate_price_level_change_percent
FROM yearly_cpi;

-- Формуємо індекс цін із базою 100 у січні 2021 року
-- Січень 2021 не включаємо, оскільки він порівнюється з груднем 2020 року
CREATE OR REPLACE VIEW public.cpi_overall_cumulative AS
SELECT
    month_date,
    calendar_year,
    month_number,
    ROUND(
        (
            EXP(
                SUM(
                    LN("Значення ІСЦ" / 100.0)
                ) OVER (
                    ORDER BY month_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                )
            ) * 100
        )::NUMERIC,
        4
    ) AS price_index
FROM public.cpi_index_analysis
WHERE
    "Базисний період" = 'До попереднього місяця'
    AND "Тип товарів і послуг" = 'Індекс споживчих цін'
    AND month_date > DATE '2021-01-01';

-- Перевіряємо початкові та кінцеві місяці
-- Базовий рівень цін у січні 2021 року дорівнює 100
SELECT
    month_date,
    price_index
FROM public.cpi_overall_cumulative
WHERE
    month_date IN (
        DATE '2021-02-01',
        DATE '2021-03-01',
        DATE '2024-01-01',
        DATE '2024-12-01',
        DATE '2025-01-01',
        DATE '2025-12-01',
        DATE '2026-09-01'
    )
ORDER BY month_date;

-- Розраховуємо середній рівень цін за повні календарні роки
-- Використовуємо накопичений індекс із базою 100 у січні 2021 року
SELECT
    calendar_year,
    COUNT(price_index) AS months_with_data,
    ROUND(
        AVG(price_index),
        4
    ) AS average_price_index
FROM public.cpi_overall_cumulative
WHERE calendar_year IN (2024, 2025)
GROUP BY calendar_year
ORDER BY calendar_year;

-- Порівнюємо середні накопичені індекси цін
-- за два повні календарні роки
WITH yearly_prices AS (
    SELECT
        calendar_year,
        AVG(price_index) AS average_price_index
    FROM public.cpi_overall_cumulative
    WHERE calendar_year IN (2024, 2025)
    GROUP BY calendar_year
)
SELECT
    ROUND(
        MAX(average_price_index) FILTER (
            WHERE calendar_year = 2024
        ),
        4
    ) AS price_index_2024,
    ROUND(
        MAX(average_price_index) FILTER (
            WHERE calendar_year = 2025
        ),
        4
    ) AS price_index_2025,
    ROUND(
        (
            MAX(average_price_index) FILTER (
                WHERE calendar_year = 2025
            )
            /
            MAX(average_price_index) FILTER (
                WHERE calendar_year = 2024
            )
            - 1
        ) * 100,
        2
    ) AS price_growth_percent
FROM yearly_prices;

-- Порівнюємо зростання номінальної зарплати зі зміною середнього рівня споживчих цін
WITH yearly_wage AS (
    SELECT
        calendar_year,
        AVG("Заробітна плата") AS average_wage
    FROM public.average_wage_analysis
    WHERE
        calendar_year IN (2024, 2025)
        AND "Заробітна плата" IS NOT NULL
    GROUP BY calendar_year
),
yearly_prices AS (
    SELECT
        calendar_year,
        AVG(price_index) AS average_price_index
    FROM public.cpi_overall_cumulative
    WHERE calendar_year IN (2024, 2025)
    GROUP BY calendar_year
)
SELECT
    ROUND(
        (
            MAX(w.average_wage) FILTER (WHERE w.calendar_year = 2024)
        )::NUMERIC,
        2
    ) AS wage_2024,
    ROUND(
        (
            MAX(w.average_wage) FILTER (WHERE w.calendar_year = 2025)
        )::NUMERIC,
        2
    ) AS wage_2025,
    ROUND(
        (
            (
                MAX(w.average_wage) FILTER (WHERE w.calendar_year = 2025)
                /
                MAX(w.average_wage) FILTER (WHERE w.calendar_year = 2024)
            )
            /
            (
                MAX(p.average_price_index) FILTER (WHERE p.calendar_year = 2025)
                /
                MAX(p.average_price_index) FILTER (WHERE p.calendar_year = 2024)
            )
            - 1
        ) * 100,
        2
    ) AS real_wage_change_percent
FROM yearly_wage w
CROSS JOIN yearly_prices p;

-- Створюємо представлення для порівняння номінальної зарплати, інфляції та реальної зарплати
CREATE OR REPLACE VIEW public.wage_inflation_comparison AS
WITH yearly_wage AS (
    SELECT
        calendar_year,
        AVG("Заробітна плата") AS average_wage,
        COUNT("Заробітна плата") AS months_with_data
    FROM public.average_wage_analysis
    WHERE "Заробітна плата" IS NOT NULL
    GROUP BY calendar_year
),
yearly_prices AS (
    SELECT
        calendar_year,
        AVG(price_index) AS average_price_index
    FROM public.cpi_overall_cumulative
    GROUP BY calendar_year
)
SELECT
    current_wage.calendar_year,
    ROUND(previous_wage.average_wage::NUMERIC, 2)
        AS previous_year_wage,
    ROUND(current_wage.average_wage::NUMERIC, 2)
        AS current_year_wage,
    ROUND(
        (
            current_wage.average_wage
            / previous_wage.average_wage - 1
        ) * 100,
        2
    ) AS nominal_wage_growth_percent,
    ROUND(
        (
            current_prices.average_price_index
            / previous_prices.average_price_index - 1
        ) * 100,
        2
    ) AS price_growth_percent,
    ROUND(
        (
            (
                current_wage.average_wage
                / previous_wage.average_wage
            )
            /
            (
                current_prices.average_price_index
                / previous_prices.average_price_index
            ) - 1
        ) * 100,
        2
    ) AS real_wage_change_percent
FROM yearly_wage current_wage
JOIN yearly_wage previous_wage
    ON current_wage.calendar_year = previous_wage.calendar_year + 1
JOIN yearly_prices current_prices
    ON current_wage.calendar_year = current_prices.calendar_year
JOIN yearly_prices previous_prices
    ON previous_wage.calendar_year = previous_prices.calendar_year
WHERE
    current_wage.months_with_data = 12
    AND previous_wage.months_with_data = 12;

-- Переглядаємо збережені показники номінального зростання зарплати, цін і реальної зарплати
SELECT *
FROM public.wage_inflation_comparison
ORDER BY calendar_year;

-- Порівнюємо зарплату та накопичений індекс цін із базовим місяцем січнем 2021 року
WITH base_wage AS (
    SELECT
        "Заробітна плата" AS wage_2021
    FROM public.average_wage_analysis
    WHERE month_date = DATE '2021-01-01'
),
monthly_comparison AS (
    SELECT
        w.month_date,
        w.calendar_year,
        w.month_number,
        w."Заробітна плата",
        c.price_index,
        b.wage_2021
    FROM public.average_wage_analysis w
    JOIN public.cpi_overall_cumulative c
        ON w.month_date = c.month_date
    CROSS JOIN base_wage b
    WHERE w."Заробітна плата" IS NOT NULL
)
SELECT
    month_date,
    ROUND(
        (
            "Заробітна плата" / wage_2021 * 100
        )::NUMERIC,
        2
    ) AS nominal_wage_index,
    ROUND(
        (
            "Заробітна плата" / wage_2021
            / (price_index / 100) * 100
        )::NUMERIC,
        2
    ) AS real_wage_index
FROM monthly_comparison
ORDER BY month_date;

-- Створюємо представлення для аналізу номінальної та реальної зарплати з базою січень 2021 = 100
CREATE OR REPLACE VIEW public.wage_real_index AS
WITH base_wage AS (
    SELECT
        "Заробітна плата" AS wage_2021
    FROM public.average_wage_analysis
    WHERE month_date = DATE '2021-01-01'
),
monthly_comparison AS (
    SELECT
        w.month_date,
        w.calendar_year,
        w.month_number,
        w."Заробітна плата",
        c.price_index,
        b.wage_2021
    FROM public.average_wage_analysis w
    JOIN public.cpi_overall_cumulative c
        ON w.month_date = c.month_date
    CROSS JOIN base_wage b
    WHERE
        w."Заробітна плата" IS NOT NULL
)
SELECT
    month_date,
    calendar_year,
    month_number,
    "Заробітна плата",
    price_index,
    ROUND(
        (
            "Заробітна плата" / wage_2021 * 100
        )::NUMERIC,
        2
    ) AS nominal_wage_index,
    ROUND(
        (
            "Заробітна плата" / wage_2021
            / (price_index / 100) * 100
        )::NUMERIC,
        2
    ) AS real_wage_index
FROM monthly_comparison;

-- Перевіряємо кількість записів і крайні дати
-- Переглядаємо останні 5 місяців доступних даних
SELECT
    COUNT(*) AS total_records,
    MIN(month_date) AS first_month,
    MAX(month_date) AS last_month
FROM public.wage_real_index;

-- Переглядаємо останні 5 місяців
SELECT
    month_date,
    nominal_wage_index,
    real_wage_index
FROM public.wage_real_index
ORDER BY month_date DESC
LIMIT 5;

-- Додаємо січень 2021 року як базовий місяць
-- Для нього індекс цін дорівнює 100
CREATE OR REPLACE VIEW public.wage_real_index AS
WITH base_wage AS (
    SELECT
        "Заробітна плата" AS wage_2021
    FROM public.average_wage_analysis
    WHERE month_date = DATE '2021-01-01'
),
monthly_comparison AS (
    SELECT
        w.month_date,
        w.calendar_year,
        w.month_number,
        w."Заробітна плата",
        CASE
            WHEN w.month_date = DATE '2021-01-01'
                THEN 100.0
            ELSE c.price_index
        END AS price_index,
        b.wage_2021
    FROM public.average_wage_analysis w
    LEFT JOIN public.cpi_overall_cumulative c
        ON w.month_date = c.month_date
    CROSS JOIN base_wage b
    WHERE w."Заробітна плата" IS NOT NULL
)
SELECT
    month_date,
    calendar_year,
    month_number,
    "Заробітна плата",
    price_index,
    ROUND(
        (
            "Заробітна плата" / wage_2021 * 100
        )::NUMERIC,
        2
    ) AS nominal_wage_index,
    ROUND(
        (
            "Заробітна плата" / wage_2021
            / (price_index / 100) * 100
        )::NUMERIC,
        2
    ) AS real_wage_index
FROM monthly_comparison;

-- Перевіряємо кількість записів, перший і останній місяці
-- Переконуємося, що січень 2021 року присутній
SELECT
    COUNT(*) AS total_records,
    MIN(month_date) AS first_month,
    MAX(month_date) AS last_month
FROM public.wage_real_index;

-- Перевіряємо базовий місяць і останній доступний місяць
SELECT
    month_date,
    price_index,
    nominal_wage_index,
    real_wage_index
FROM public.wage_real_index
WHERE month_date IN (
    DATE '2021-01-01',
    DATE '2026-09-01'
)
ORDER BY month_date;

-- Отримуємо список усіх представлень у схемі public
-- Перевіряємо, які аналітичні об'єкти створені
SELECT
    table_name AS view_name
FROM information_schema.views
WHERE
    table_schema = 'public'
ORDER BY table_name;

-- Виводимо лише представлення, які належать до дослідження про вартість життя в Україні
SELECT
    table_name AS view_name
FROM information_schema.views
WHERE
    table_schema = 'public'
    AND (
        table_name LIKE 'consumer_price%'
        OR table_name LIKE 'consumer_prices%'
        OR table_name LIKE 'cpi_%'
        OR table_name LIKE 'average_wage_%'
        OR table_name LIKE 'wage_%'
    )
ORDER BY table_name;

-- Перевіряємо кількість записів у ключових представленнях
SELECT
    'consumer_price_change_period' AS view_name,
    COUNT(*) AS records
FROM public.consumer_price_change_period
UNION ALL
SELECT
    'consumer_prices_yearly',
    COUNT(*)
FROM public.consumer_prices_yearly
UNION ALL
SELECT
    'cpi_annual_analysis',
    COUNT(*)
FROM public.cpi_annual_analysis
UNION ALL
SELECT
    'cpi_category_annual',
    COUNT(*)
FROM public.cpi_category_annual
UNION ALL
SELECT
    'cpi_category_cumulative',
    COUNT(*)
FROM public.cpi_category_cumulative
UNION ALL
SELECT
    'wage_inflation_comparison',
    COUNT(*)
FROM public.wage_inflation_comparison
UNION ALL
SELECT
    'wage_real_index',
    COUNT(*)
FROM public.wage_real_index;

-- Виводимо 10 товарів і послуг із найбільшим зростанням середньої річної ціни у 2025 році
SELECT
    "Тип товарів і послуг",
    previous_average_price,
    current_average_price,
    yearly_price_change_percent
FROM public.consumer_prices_yearly_change
WHERE calendar_year = 2025
ORDER BY yearly_price_change_percent DESC
LIMIT 10;

-- Отримуємо річні середні ціни для експорту в Tableau Public
SELECT *
FROM public.consumer_prices_yearly
ORDER BY "Тип товарів і послуг", calendar_year;

-- Отримуємо 10 товарів і послуг із найбільшим зростанням цін із січня 2021 до вересня 2026 року
SELECT
    "Тип товарів і послуг",
    price_2021,
    price_2026,
    price_change_percent
FROM public.consumer_price_change_period
ORDER BY price_change_percent DESC
LIMIT 10;

-- Відбираємо помісячну річну інфляцію за 2021–2026 роки
SELECT
    month_date,
    calendar_year,
    month_number,
    annual_inflation_percent
FROM public.cpi_annual_analysis
ORDER BY month_date;

-- Відбираємо категорії та накопичене зростання цін
SELECT
    "Тип товарів і послуг",
    months_with_data,
    cumulative_inflation_percent
FROM public.cpi_category_cumulative
ORDER BY cumulative_inflation_percent DESC;

-- Переглядаємо індекси зарплат, цін і реальної зарплати
SELECT *
FROM public.wage_real_index
LIMIT 10;

-- Відбираємо індекси зарплати та цін для порівняння
SELECT
    month_date,
    calendar_year,
    month_number,
    price_index,
    nominal_wage_index,
    real_wage_index
FROM public.wage_real_index
ORDER BY month_date;

-- Перевіряємо загальну накопичену зміну індексу споживчих цін
SELECT *
FROM public.cpi_overall_cumulative;

-- Отримуємо останній накопичений індекс споживчих цін
SELECT *
FROM public.cpi_overall_cumulative
ORDER BY month_date DESC
LIMIT 1;

-- Розраховуємо накопичене зростання цін для KPI-картки
SELECT
    ROUND((price_index - 100)::numeric, 2) AS cumulative_inflation_percent
FROM public.cpi_overall_cumulative
ORDER BY calendar_year DESC, month_number DESC
LIMIT 1;

-- Отримуємо приріст реальної зарплати за останній доступний місяць
SELECT
    month_date,
    ROUND((real_wage_index - 100)::numeric, 2)
        AS real_wage_growth_percent
FROM public.wage_real_index
ORDER BY month_date DESC
LIMIT 1;

-- Розраховуємо середню номінальну зарплату за січень–вересень 2026 року
SELECT
    ROUND(AVG("Заробітна плата")::numeric, 2) AS average_wage_uah
FROM public.average_wage_analysis
WHERE calendar_year = 2026;