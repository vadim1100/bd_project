CREATE TABLE клиент (
    id_клиента INT PRIMARY KEY,
    фио VARCHAR(150) NOT NULL,
    телефон VARCHAR(20) NOT NULL,
    email VARCHAR(250),
    дата_регистрации DATE NOT NULL,
    бонусный_баланс INT NOT NULL CHECK (бонусный_баланс >= 0)
);

CREATE TABLE ресторан (
    id_ресторана INT PRIMARY KEY,
    название VARCHAR(150) NOT NULL,
    адрес_ресторана VARCHAR(250) NOT NULL,
    телефон VARCHAR(20) NOT NULL,
    рейтинг_ресторана NUMERIC(3,2) CHECK (рейтинг_ресторана BETWEEN 1 AND 5),
    время_открытия TIME NOT NULL,
    время_закрытия TIME NOT NULL,
    принимает_заказы BOOLEAN NOT NULL
);

CREATE TABLE категория (
    id_категории INT PRIMARY KEY,
    название_категории VARCHAR(100) NOT NULL,
    описание_категории VARCHAR(500),
    порядок_отображения INT NOT NULL CHECK (порядок_отображения > 0)
);

CREATE TABLE курьер (
    id_курьера INT PRIMARY KEY,
    фио VARCHAR(150) NOT NULL,
    телефон VARCHAR(20) NOT NULL,
    тип_транспорта VARCHAR(50) NOT NULL,
    рейтинг_курьера NUMERIC(3,2) CHECK (рейтинг_курьера BETWEEN 1 AND 5),
    статус_на_смене BOOLEAN NOT NULL,
    дата_найма DATE NOT NULL
);

CREATE TABLE адрес (
    id_адреса INT PRIMARY KEY,
    id_клиента INT NOT NULL REFERENCES клиент (id_клиента) ON DELETE NO ACTION,
    город VARCHAR(100) NOT NULL,
    улица VARCHAR(150) NOT NULL,
    дом VARCHAR(30) NOT NULL,
    квартира VARCHAR(12),
    подъезд VARCHAR(12),
    этаж INT,
    код_домофона VARCHAR(30)
);

CREATE TABLE отзыв (
    id_отзыва INT PRIMARY KEY,
    id_клиента INT NOT NULL REFERENCES клиент (id_клиента) ON DELETE NO ACTION,
    id_ресторана INT NOT NULL REFERENCES ресторан (id_ресторана) ON DELETE NO ACTION,
    оценка INT NOT NULL CHECK (оценка BETWEEN 1 AND 5),
    текст_отзыва VARCHAR(2000),
    дата_публикации TIMESTAMP NOT NULL
);

CREATE TABLE акция (
    id_акции INT PRIMARY KEY,
    id_ресторана INT NOT NULL REFERENCES ресторан (id_ресторана) ON DELETE NO ACTION,
    название_акции VARCHAR(150) NOT NULL,
    описание_условий VARCHAR(1000) NOT NULL,
    процент_скидки NUMERIC(5,2) NOT NULL CHECK (процент_скидки > 0 AND процент_скидки <= 100),
    мин_сумма_заказа NUMERIC(10,2) NOT NULL CHECK (мин_сумма_заказа >= 0),
    дата_начала DATE NOT NULL,
    дата_окончания DATE NOT NULL CHECK (дата_окончания >= дата_начала),
    активна BOOLEAN NOT NULL
);

CREATE TABLE заказ (
    id_заказа INT PRIMARY KEY,
    id_клиента INT NOT NULL REFERENCES клиент (id_клиента) ON DELETE NO ACTION,
    id_ресторана INT NOT NULL REFERENCES ресторан (id_ресторана) ON DELETE NO ACTION,
    дата_оформления TIMESTAMP NOT NULL,
    статус_заказа VARCHAR(30) NOT NULL,
    стоимость_блюд NUMERIC(10,2) NOT NULL CHECK (стоимость_блюд >= 0),
    размер_скидки NUMERIC(10,2) NOT NULL CHECK (размер_скидки BETWEEN 0 AND стоимость_блюд),
    итоговая_сумма NUMERIC(10,2) NOT NULL CHECK (итоговая_сумма >= 0),
    количество_приборов INT NOT NULL CHECK (количество_приборов >= 0)
);

CREATE TABLE блюдо (
    id_блюда INT PRIMARY KEY,
    id_ресторана INT NOT NULL REFERENCES ресторан (id_ресторана) ON DELETE NO ACTION,
    id_категории INT NOT NULL REFERENCES категория (id_категории) ON DELETE NO ACTION,
    название_блюда VARCHAR(150) NOT NULL,
    описание_состава VARCHAR(1000),
    вес_грамм INT NOT NULL CHECK (вес_грамм > 0),
    калорийность INT CHECK (калорийность >= 0),
    текущая_цена NUMERIC(10,2) NOT NULL CHECK (текущая_цена >= 0),
    предыдущая_цена NUMERIC(10,2) CHECK (предыдущая_цена >= 0),
    дата_изменения_цены DATE,
    доступно BOOLEAN NOT NULL
);

CREATE TABLE состав_заказа (
    id_позиции INT PRIMARY KEY,
    id_заказа INT NOT NULL REFERENCES заказ (id_заказа) ON DELETE NO ACTION,
    id_блюда INT NOT NULL REFERENCES блюдо (id_блюда) ON DELETE NO ACTION,
    количество INT NOT NULL CHECK (количество > 0),
    цена_на_момент_заказа NUMERIC(10,2) NOT NULL CHECK (цена_на_момент_заказа >= 0)
);

CREATE TABLE доставка (
    id_доставки INT PRIMARY KEY,
    id_заказа INT NOT NULL UNIQUE REFERENCES заказ (id_заказа) ON DELETE NO ACTION,
    id_курьера INT REFERENCES курьер (id_курьера) ON DELETE NO ACTION,
    id_адреса INT NOT NULL REFERENCES адрес (id_адреса) ON DELETE NO ACTION,
    статус_доставки VARCHAR(30) NOT NULL,
    стоимость_доставки NUMERIC(10,2) NOT NULL CHECK (стоимость_доставки >= 0),
    время_назначения TIMESTAMP,
    время_доставки TIMESTAMP CHECK (время_доставки >= время_назначения),
    комментарий_курьеру VARCHAR(500)
);

CREATE TABLE оплата (
    id_оплаты INT PRIMARY KEY,
    id_заказа INT NOT NULL UNIQUE REFERENCES заказ (id_заказа) ON DELETE NO ACTION,
    способ_оплаты VARCHAR(30) NOT NULL,
    сумма_оплаты NUMERIC(10,2) NOT NULL CHECK (сумма_оплаты >= 0),
    статус_оплаты VARCHAR(30) NOT NULL,
    дата_и_время_оплаты TIMESTAMP,
    номер_транзакции VARCHAR(100)
);