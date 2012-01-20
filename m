From: akpm@linux-foundation.org
Subject: + rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:23:35 -0800
Message-ID: <20120120232335.BA1F11E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55445 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2ATXXh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:23:37 -0500
Received: by ghbg20 with SMTP id g20so90017ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:23:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, ab@mycable.de, byron.bbradley@gmail.com, dale@farnsworth.org, gregory.hermant@calao-systems.com, hvr@gnu.org, kosmo@semihalf.com, martyn.welch@ge.com, mike@compulab.co.il, roman.fietze@telemotive.de, scottwood@freescale.com, slapin@ossfans.org, srikanth.srinivasan@freescale.com, wg@grandegger.com


The patch titled
     Subject: rtc: convert rtc i2c drivers to module_i2c_driver
has been added to the -mm tree.  Its filename is
     rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: rtc: convert rtc i2c drivers to module_i2c_driver

Factor out some boilerplate code for i2c driver registration into
module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Piotr Ziecik <kosmo@semihalf.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Sergey Lapin <slapin@ossfans.org>
Cc: Roman Fietze <roman.fietze@telemotive.de>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Alexander Bigga <ab@mycable.de>
Cc: Dale Farnsworth <dale@farnsworth.org>
Cc: Gregory Hermant <gregory.hermant@calao-systems.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Martyn Welch <martyn.welch@ge.com>
Cc: Byron Bradley <byron.bbradley@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c    |   12 +-----------
 drivers/rtc/rtc-ds1307.c   |   12 +-----------
 drivers/rtc/rtc-ds1374.c   |   13 +------------
 drivers/rtc/rtc-ds1672.c   |   13 +------------
 drivers/rtc/rtc-ds3232.c   |   13 +------------
 drivers/rtc/rtc-em3027.c   |   13 +------------
 drivers/rtc/rtc-fm3130.c   |   12 +-----------
 drivers/rtc/rtc-isl12022.c |   13 +------------
 drivers/rtc/rtc-isl1208.c  |   15 +--------------
 drivers/rtc/rtc-m41t80.c   |   13 +------------
 drivers/rtc/rtc-max6900.c  |   13 +------------
 drivers/rtc/rtc-pcf8563.c  |   13 +------------
 drivers/rtc/rtc-pcf8583.c  |   13 +------------
 drivers/rtc/rtc-rs5c372.c  |   13 +------------
 drivers/rtc/rtc-rv3029c2.c |   13 +------------
 drivers/rtc/rtc-rx8025.c   |   13 +------------
 drivers/rtc/rtc-rx8581.c   |   13 +------------
 drivers/rtc/rtc-s35390a.c  |   13 +------------
 drivers/rtc/rtc-x1205.c    |   13 +------------
 19 files changed, 19 insertions(+), 227 deletions(-)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-bq32k.c
@@ -187,17 +187,7 @@ static struct i2c_driver bq32k_driver = 
 	.id_table	= bq32k_id,
 };
 
-static __init int bq32k_init(void)
-{
-	return i2c_add_driver(&bq32k_driver);
-}
-module_init(bq32k_init);
-
-static __exit void bq32k_exit(void)
-{
-	i2c_del_driver(&bq32k_driver);
-}
-module_exit(bq32k_exit);
+module_i2c_driver(bq32k_driver);
 
 MODULE_AUTHOR("Semihalf, Piotr Ziecik <kosmo@semihalf.com>");
 MODULE_DESCRIPTION("TI BQ32000 I2C RTC driver");
diff -puN drivers/rtc/rtc-ds1307.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-ds1307.c
@@ -938,17 +938,7 @@ static struct i2c_driver ds1307_driver =
 	.id_table	= ds1307_id,
 };
 
-static int __init ds1307_init(void)
-{
-	return i2c_add_driver(&ds1307_driver);
-}
-module_init(ds1307_init);
-
-static void __exit ds1307_exit(void)
-{
-	i2c_del_driver(&ds1307_driver);
-}
-module_exit(ds1307_exit);
+module_i2c_driver(ds1307_driver);
 
 MODULE_DESCRIPTION("RTC driver for DS1307 and similar chips");
 MODULE_LICENSE("GPL");
diff -puN drivers/rtc/rtc-ds1374.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-ds1374.c
@@ -446,18 +446,7 @@ static struct i2c_driver ds1374_driver =
 	.id_table = ds1374_id,
 };
 
-static int __init ds1374_init(void)
-{
-	return i2c_add_driver(&ds1374_driver);
-}
-
-static void __exit ds1374_exit(void)
-{
-	i2c_del_driver(&ds1374_driver);
-}
-
-module_init(ds1374_init);
-module_exit(ds1374_exit);
+module_i2c_driver(ds1374_driver);
 
 MODULE_AUTHOR("Scott Wood <scottwood@freescale.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS1374 RTC Driver");
diff -puN drivers/rtc/rtc-ds1672.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-ds1672.c
@@ -202,20 +202,9 @@ static struct i2c_driver ds1672_driver =
 	.id_table = ds1672_id,
 };
 
-static int __init ds1672_init(void)
-{
-	return i2c_add_driver(&ds1672_driver);
-}
-
-static void __exit ds1672_exit(void)
-{
-	i2c_del_driver(&ds1672_driver);
-}
+module_i2c_driver(ds1672_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("Dallas/Maxim DS1672 timekeeper driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ds1672_init);
-module_exit(ds1672_exit);
diff -puN drivers/rtc/rtc-ds3232.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-ds3232.c
@@ -473,18 +473,7 @@ static struct i2c_driver ds3232_driver =
 	.id_table = ds3232_id,
 };
 
-static int __init ds3232_init(void)
-{
-	return i2c_add_driver(&ds3232_driver);
-}
-
-static void __exit ds3232_exit(void)
-{
-	i2c_del_driver(&ds3232_driver);
-}
-
-module_init(ds3232_init);
-module_exit(ds3232_exit);
+module_i2c_driver(ds3232_driver);
 
 MODULE_AUTHOR("Srikanth Srinivasan <srikanth.srinivasan@freescale.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS3232 RTC Driver");
diff -puN drivers/rtc/rtc-em3027.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-em3027.c
--- a/drivers/rtc/rtc-em3027.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-em3027.c
@@ -144,19 +144,8 @@ static struct i2c_driver em3027_driver =
 	.id_table = em3027_id,
 };
 
-static int __init em3027_init(void)
-{
-	return i2c_add_driver(&em3027_driver);
-}
-
-static void __exit em3027_exit(void)
-{
-	i2c_del_driver(&em3027_driver);
-}
+module_i2c_driver(em3027_driver);
 
 MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_DESCRIPTION("EM Microelectronic EM3027 RTC driver");
 MODULE_LICENSE("GPL");
-
-module_init(em3027_init);
-module_exit(em3027_exit);
diff -puN drivers/rtc/rtc-fm3130.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-fm3130.c
@@ -565,17 +565,7 @@ static struct i2c_driver fm3130_driver =
 	.id_table	= fm3130_id,
 };
 
-static int __init fm3130_init(void)
-{
-	return i2c_add_driver(&fm3130_driver);
-}
-module_init(fm3130_init);
-
-static void __exit fm3130_exit(void)
-{
-	i2c_del_driver(&fm3130_driver);
-}
-module_exit(fm3130_exit);
+module_i2c_driver(fm3130_driver);
 
 MODULE_DESCRIPTION("RTC driver for FM3130");
 MODULE_AUTHOR("Sergey Lapin <slapin@ossfans.org>");
diff -puN drivers/rtc/rtc-isl12022.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-isl12022.c
@@ -309,18 +309,7 @@ static struct i2c_driver isl12022_driver
 	.id_table	= isl12022_id,
 };
 
-static int __init isl12022_init(void)
-{
-	return i2c_add_driver(&isl12022_driver);
-}
-
-static void __exit isl12022_exit(void)
-{
-	i2c_del_driver(&isl12022_driver);
-}
-
-module_init(isl12022_init);
-module_exit(isl12022_exit);
+module_i2c_driver(isl12022_driver);
 
 MODULE_AUTHOR("roman.fietze@telemotive.de");
 MODULE_DESCRIPTION("ISL 12022 RTC driver");
diff -puN drivers/rtc/rtc-isl1208.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-isl1208.c
@@ -710,22 +710,9 @@ static struct i2c_driver isl1208_driver 
 	.id_table = isl1208_id,
 };
 
-static int __init
-isl1208_init(void)
-{
-	return i2c_add_driver(&isl1208_driver);
-}
-
-static void __exit
-isl1208_exit(void)
-{
-	i2c_del_driver(&isl1208_driver);
-}
+module_i2c_driver(isl1208_driver);
 
 MODULE_AUTHOR("Herbert Valerio Riedel <hvr@gnu.org>");
 MODULE_DESCRIPTION("Intersil ISL1208 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(isl1208_init);
-module_exit(isl1208_exit);
diff -puN drivers/rtc/rtc-m41t80.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-m41t80.c
@@ -900,20 +900,9 @@ static struct i2c_driver m41t80_driver =
 	.id_table = m41t80_id,
 };
 
-static int __init m41t80_rtc_init(void)
-{
-	return i2c_add_driver(&m41t80_driver);
-}
-
-static void __exit m41t80_rtc_exit(void)
-{
-	i2c_del_driver(&m41t80_driver);
-}
+module_i2c_driver(m41t80_driver);
 
 MODULE_AUTHOR("Alexander Bigga <ab@mycable.de>");
 MODULE_DESCRIPTION("ST Microelectronics M41T80 series RTC I2C Client Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(m41t80_rtc_init);
-module_exit(m41t80_rtc_exit);
diff -puN drivers/rtc/rtc-max6900.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-max6900.c
@@ -261,20 +261,9 @@ static struct i2c_driver max6900_driver 
 	.id_table = max6900_id,
 };
 
-static int __init max6900_init(void)
-{
-	return i2c_add_driver(&max6900_driver);
-}
-
-static void __exit max6900_exit(void)
-{
-	i2c_del_driver(&max6900_driver);
-}
+module_i2c_driver(max6900_driver);
 
 MODULE_DESCRIPTION("Maxim MAX6900 RTC driver");
 MODULE_AUTHOR("Dale Farnsworth <dale@farnsworth.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(max6900_init);
-module_exit(max6900_exit);
diff -puN drivers/rtc/rtc-pcf8563.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -252,20 +252,9 @@ static struct i2c_driver pcf8563_driver 
 	.id_table	= pcf8563_id,
 };
 
-static int __init pcf8563_init(void)
-{
-	return i2c_add_driver(&pcf8563_driver);
-}
-
-static void __exit pcf8563_exit(void)
-{
-	i2c_del_driver(&pcf8563_driver);
-}
+module_i2c_driver(pcf8563_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("Philips PCF8563/Epson RTC8564 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pcf8563_init);
-module_exit(pcf8563_exit);
diff -puN drivers/rtc/rtc-pcf8583.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -320,18 +320,7 @@ static struct i2c_driver pcf8583_driver 
 	.id_table	= pcf8583_id,
 };
 
-static __init int pcf8583_init(void)
-{
-	return i2c_add_driver(&pcf8583_driver);
-}
-
-static __exit void pcf8583_exit(void)
-{
-	i2c_del_driver(&pcf8583_driver);
-}
-
-module_init(pcf8583_init);
-module_exit(pcf8583_exit);
+module_i2c_driver(pcf8583_driver);
 
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("PCF8583 I2C RTC driver");
diff -puN drivers/rtc/rtc-rs5c372.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -689,18 +689,7 @@ static struct i2c_driver rs5c372_driver 
 	.id_table	= rs5c372_id,
 };
 
-static __init int rs5c372_init(void)
-{
-	return i2c_add_driver(&rs5c372_driver);
-}
-
-static __exit void rs5c372_exit(void)
-{
-	i2c_del_driver(&rs5c372_driver);
-}
-
-module_init(rs5c372_init);
-module_exit(rs5c372_exit);
+module_i2c_driver(rs5c372_driver);
 
 MODULE_AUTHOR(
 		"Pavel Mironchik <pmironchik@optifacio.net>, "
diff -puN drivers/rtc/rtc-rv3029c2.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-rv3029c2.c
--- a/drivers/rtc/rtc-rv3029c2.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -436,18 +436,7 @@ static struct i2c_driver rv3029c2_driver
 	.id_table = rv3029c2_id,
 };
 
-static int __init rv3029c2_init(void)
-{
-	return i2c_add_driver(&rv3029c2_driver);
-}
-
-static void __exit rv3029c2_exit(void)
-{
-	i2c_del_driver(&rv3029c2_driver);
-}
-
-module_init(rv3029c2_init);
-module_exit(rv3029c2_exit);
+module_i2c_driver(rv3029c2_driver);
 
 MODULE_AUTHOR("Gregory Hermant <gregory.hermant@calao-systems.com>");
 MODULE_DESCRIPTION("Micro Crystal RV3029C2 RTC driver");
diff -puN drivers/rtc/rtc-rx8025.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-rx8025.c
--- a/drivers/rtc/rtc-rx8025.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-rx8025.c
@@ -644,19 +644,8 @@ static struct i2c_driver rx8025_driver =
 	.id_table	= rx8025_id,
 };
 
-static int __init rx8025_init(void)
-{
-	return i2c_add_driver(&rx8025_driver);
-}
-
-static void __exit rx8025_exit(void)
-{
-	i2c_del_driver(&rx8025_driver);
-}
+module_i2c_driver(rx8025_driver);
 
 MODULE_AUTHOR("Wolfgang Grandegger <wg@grandegger.com>");
 MODULE_DESCRIPTION("RX-8025 SA/NB RTC driver");
 MODULE_LICENSE("GPL");
-
-module_init(rx8025_init);
-module_exit(rx8025_exit);
diff -puN drivers/rtc/rtc-rx8581.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-rx8581.c
--- a/drivers/rtc/rtc-rx8581.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-rx8581.c
@@ -276,20 +276,9 @@ static struct i2c_driver rx8581_driver =
 	.id_table	= rx8581_id,
 };
 
-static int __init rx8581_init(void)
-{
-	return i2c_add_driver(&rx8581_driver);
-}
-
-static void __exit rx8581_exit(void)
-{
-	i2c_del_driver(&rx8581_driver);
-}
+module_i2c_driver(rx8581_driver);
 
 MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
 MODULE_DESCRIPTION("Epson RX-8581 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(rx8581_init);
-module_exit(rx8581_exit);
diff -puN drivers/rtc/rtc-s35390a.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-s35390a.c
@@ -304,19 +304,8 @@ static struct i2c_driver s35390a_driver 
 	.id_table	= s35390a_id,
 };
 
-static int __init s35390a_rtc_init(void)
-{
-	return i2c_add_driver(&s35390a_driver);
-}
-
-static void __exit s35390a_rtc_exit(void)
-{
-	i2c_del_driver(&s35390a_driver);
-}
+module_i2c_driver(s35390a_driver);
 
 MODULE_AUTHOR("Byron Bradley <byron.bbradley@gmail.com>");
 MODULE_DESCRIPTION("S35390A RTC driver");
 MODULE_LICENSE("GPL");
-
-module_init(s35390a_rtc_init);
-module_exit(s35390a_rtc_exit);
diff -puN drivers/rtc/rtc-x1205.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-convert-rtc-i2c-drivers-to-module_i2c_driver
+++ a/drivers/rtc/rtc-x1205.c
@@ -623,15 +623,7 @@ static struct i2c_driver x1205_driver = 
 	.id_table	= x1205_id,
 };
 
-static int __init x1205_init(void)
-{
-	return i2c_add_driver(&x1205_driver);
-}
-
-static void __exit x1205_exit(void)
-{
-	i2c_del_driver(&x1205_driver);
-}
+module_i2c_driver(x1205_driver);
 
 MODULE_AUTHOR(
 	"Karen Spearel <kas111 at gmail dot com>, "
@@ -639,6 +631,3 @@ MODULE_AUTHOR(
 MODULE_DESCRIPTION("Xicor/Intersil X1205 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
