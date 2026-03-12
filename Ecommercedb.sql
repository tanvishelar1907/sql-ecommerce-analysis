use ecommercedb;
create table Categories(
	categoryid int auto_increment primary key,
    categoryname varchar(100)
    );
desc categories;
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
) ENGINE=InnoDB;

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name Varchar(100) not null,
    Price DECIMAL(10,2),
    StockQantity int not null,
    categoryid int ,
    foreign key (categoryid) references Categories(categoryid)
    ) engine=InnoDB;

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
) ENGINE=InnoDB;

CREATE TABLE OrderDetails (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating INT,
    Comment TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
) ENGINE=InnoDB;

CREATE TABLE Discounts (
    DiscountID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    CategoryID INT,
    DiscountPercent DECIMAL(5,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
) ENGINE=InnoDB;

CREATE TABLE Coupons (
    CouponID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Code VARCHAR(50) UNIQUE,
    DiscountAmount DECIMAL(10,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ENGINE=InnoDB;

CREATE TABLE Shipping (
    ShippingID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ShippingDate date,
    DeliveryDate date,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
) ENGINE=InnoDB;




use ecommercedb;
select o.OrderID, o.CustomerID, c.CName, p.PName, od.Quantity, p.price from orders o join customers c on c.CustomerID = o.CustomerID join orderdetails od on o.OrderID = od.OrderID join products p on od.ProductID = p.ProductID;
select o.OrderID, o.CustomerID, c.CName, p.PName, od.Quantity, p.price from orders o join customers c on c.CustomerID = o.CustomerID join orderdetails od on o.OrderID = od.OrderID join products p on od.ProductID = p.ProductID;
select p.PName, c.CategoryName from products p join categories c on p.categoryid = c.categoryid;
select distinct c.CName from customers c join orders o join orderdetails od on c.customerid=o.customerid;
select productid,avg(rating) as Avg_rating from reviews group by productid;
select distinct p.productid from products p join reviews r on p.productid=r.productid;
select p.productid, od.detailid, o.orderid, avg(p.price) as price  from products p join orderdetails od join orders o on  p.productid=od.productid and o.orderid=od.orderid;
select productid, sum(quantity) as totalquantity from orderdetails group by productid order by totalquantity desc; 
select o.orderid, c.cname, s.shippingid , s.ShippingDate from orders o join shipping s join customers c on o.OrderID=s.OrderID and o.CustomerID=c.CustomerID; 
select PName from products where productid not in (select ProductID from reviews); 
select distinct C.CName from customers c join orderdetails od join orders o on o.customerid=c.CustomerID and o.orderid=od.orderid where od.productid=24;
select p.pname, p.price, d.discountamt, (p.price - d.discountamt) as Priceafterdis from products p join discounts d on p.productid=d.productid; 
select Cname from customers where customerid not in (select customerid from orders); 
select customerid, count(*) as ordercount from orders group by customerid; 
select productid, sum(quantity) as totalsold from orderdetails group by productid; 
select orderid from orderdetails group by orderid having count(*)>1; 
select distinct c.cname from reviews r join customers c on r.customerid=c.customerid where r.rating=5;
select productid from reviews group by productid having count(*)>1; 
select  avg(discountamt) as AvgDiscount from Discounts; 
select * from coupons  where couponid is null; 
select p.productid, p.pname, p.price, c.categoryname from products p join categories c on p.categoryid=c.categoryid where p.price=(select max(p2.price) from products p2 where p2.categoryid=p.categoryid); 
select customerid from reviews group by customerid having count(*)>1; 
select customerid, count(*) as ordercount from orders group by customerid having count(*)>2;
select distinct c.cname from customers c join orders o join orderdetails od join reviews r on c.CustomerID=o.CustomerID and o.OrderID=od.OrderID and c.CustomerID=r.CustomerID and od.ProductID=r.ProductID;
select p.PName from reviews r join customers c join products p on r.CustomerID=c.CustomerID and r.ProductID=p.ProductID where c.cname='John Sexton';
select rating, count(*) as count from reviews group by rating; 
select p.pname, avg(r.rating) as Avgrating from reviews r join products p on r.ProductID=p.ProductID group by PName;
select p.pname, count(od.orderid) as DiscountedOrderCount from orderdetails od join products p  join discounts d on od.ProductID=p.ProductID and p.productid=d.ProductID group by p.pname; 
select distinct o.orderid from orders o join orderdetails od join products p on o.orderid=od.orderid and od.productid=p.ProductId where p.pname='Product_1';
select productid, sum(quantity) as totalquantity from orderdetails group by productid order by totalquantity asc; 
select c.customerid, c.cname from customers c join orders o join orderdetails od on c.CustomerID=o.CustomerID and o.OrderID=od.OrderID group by c.customerid, c.cname having count(distinct od.productid)=(select count(distinct r.productid) from reviews r where r.customerid = c.customerid); 
select o.orderid, count(distinct od.productid) as ProductCount from orders o join orderdetails od on o.orderid=od.orderid group by o.orderid; 
select od.productid, o.customerid,count(*) as PurchaseCount from orderdetails od join orders o on o.OrderID=od.OrderID group by od.ProductID, o.customerid having count(*) > 1; 
select orderid, sum(quantity) as TotalItems from orderdetails group by orderid;
select cname from customers where customerid not in (select customerid from reviews); 
select p.pname, sum(od.quantity+p.price)as revenue from orderdetails od join products p on od.productid=p.productid group by p.pname; 
select o.customerid from orders o join orderdetails od on o.orderid=od.orderid join products p on p.productid=od.productid group by o.customerid having count(distinct p.categoryid)>=2; 
select p.productid, p.pname, p.price, d.discountamt from products p join discounts d on p.productid=d.productid where p.price>500; 
select c.customerid, cname, count(shippingid) as ShipmentCount from customers c join shipping s join orders o on c.customerid=o.customerid and o.orderid=s.orderid group by c.customerid,c.cname having count(s.shippingid)>1;
select c.categoryname, sum(od.quantity) as TotalQty from orderdetails od join products p join categories c on od.productid=p.ProductID and p.categoryid=c.categoryid group by c.categoryname; 
select c.categoryname, count(p.productid) as ProductCount from categories c join products p on c.categoryid=p.categoryid group by c.categoryname;
select orderdate, count(*) as ordercount from orders group by orderdate;  
select p.pname, sum(od.quantity) as TotalOrdered from orderdetails od join products p on od.productid=p.productid group by p.pname order by TotalOrdered desc limit 3; 
select c.customerid, c.cname from customers c join orders o on c.customerid=o.customerid group by c.customerid, c.cname having count(o.orderid) = 1;
select p.productid, p.pname from products p where p.productid not in (select distinct productid from orderdetails);
select c.categoryid, c.categoryname, count(p.productid) as ProductCount from categories c join products p on c.categoryid=p.categoryid group by c.categoryid, c.categoryname having count(p.ProductID) >3;
select c.customerid, c.cname from customers c join reviews r on c.customerid=r.customerid group by c.customerid, c.cname having count(r.reviewid)=1;
select o.orderid from orders o join orderdetails od on o.orderid=od.orderid join products p on od.ProductID=p.ProductID where p.ProductID in (select productid from discounts) group by o.orderid having count(*) =(select count(*) from orderdetails od2 where od2.orderid = o.orderid);
select cp.couponid, cp.discountamount from coupons cp where cp.couponid not in (select distinct couponid from orders where CouponID is not null);