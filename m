From: akpm@linux-foundation.org
Subject: [merged] rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:20 -0700
Message-ID: <20120326193120.90A00A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:48787 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2CZTbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:21 -0400
Received: by yenq2 with SMTP id q2so832340yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, Kim.Heino@bluegiga.com, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, chrisv@cyberswitching.com, damm@opensource.se, denzzzhome@yahoo.com, mpfj@mimc.co.uk, n.voss@weinmann.de, raph@raphnet.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: convert rtc spi drivers to module_spi_driver
has been removed from the -mm tree.  Its filename was
     rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: rtc: convert rtc spi drivers to module_spi_driver

Factor out some boilerplate code for spi driver registration into
module_spi_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: Nikolaus Voss <n.voss@weinmann.de>
Cc: "Kim B. Heino" <Kim.Heino@bluegiga.com>
Cc: Raphael Assenat <raph@raphnet.net>
Cc: Chris Verges <chrisv@cyberswitching.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c  |   12 +-----------
 drivers/rtc/rtc-ds1390.c  |   12 +-----------
 drivers/rtc/rtc-ds3234.c  |   12 +-----------
 drivers/rtc/rtc-m41t93.c  |   12 +-----------
 drivers/rtc/rtc-m41t94.c  |   14 +-------------
 drivers/rtc/rtc-max6902.c |   12 +-----------
 drivers/rtc/rtc-pcf2123.c |   13 +------------
 drivers/rtc/rtc-r9701.c   |   12 +-----------
 drivers/rtc/rtc-rs5c348.c |   13 +------------
 9 files changed, 9 insertions(+), 103 deletions(-)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-ds1305.c
@@ -814,17 +814,7 @@ static struct spi_driver ds1305_driver =
 	/* REVISIT add suspend/resume */
 };
 
-static int __init ds1305_init(void)
-{
-	return spi_register_driver(&ds1305_driver);
-}
-module_init(ds1305_init);
-
-static void __exit ds1305_exit(void)
-{
-	spi_unregister_driver(&ds1305_driver);
-}
-module_exit(ds1305_exit);
+module_spi_driver(ds1305_driver);
 
 MODULE_DESCRIPTION("RTC driver for DS1305 and DS1306 chips");
 MODULE_LICENSE("GPL");
diff -puN drivers/rtc/rtc-ds1390.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-ds1390.c
@@ -175,17 +175,7 @@ static struct spi_driver ds1390_driver =
 	.remove = __devexit_p(ds1390_remove),
 };
 
-static __init int ds1390_init(void)
-{
-	return spi_register_driver(&ds1390_driver);
-}
-module_init(ds1390_init);
-
-static __exit void ds1390_exit(void)
-{
-	spi_unregister_driver(&ds1390_driver);
-}
-module_exit(ds1390_exit);
+module_spi_driver(ds1390_driver);
 
 MODULE_DESCRIPTION("Dallas/Maxim DS1390/93/94 SPI RTC driver");
 MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
diff -puN drivers/rtc/rtc-ds3234.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-ds3234.c
@@ -173,17 +173,7 @@ static struct spi_driver ds3234_driver =
 	.remove = __devexit_p(ds3234_remove),
 };
 
-static __init int ds3234_init(void)
-{
-	return spi_register_driver(&ds3234_driver);
-}
-module_init(ds3234_init);
-
-static __exit void ds3234_exit(void)
-{
-	spi_unregister_driver(&ds3234_driver);
-}
-module_exit(ds3234_exit);
+module_spi_driver(ds3234_driver);
 
 MODULE_DESCRIPTION("DS3234 SPI RTC driver");
 MODULE_AUTHOR("Dennis Aberilla <denzzzhome@yahoo.com>");
diff -puN drivers/rtc/rtc-m41t93.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-m41t93.c
--- a/drivers/rtc/rtc-m41t93.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-m41t93.c
@@ -206,17 +206,7 @@ static struct spi_driver m41t93_driver =
 	.remove = __devexit_p(m41t93_remove),
 };
 
-static __init int m41t93_init(void)
-{
-	return spi_register_driver(&m41t93_driver);
-}
-module_init(m41t93_init);
-
-static __exit void m41t93_exit(void)
-{
-	spi_unregister_driver(&m41t93_driver);
-}
-module_exit(m41t93_exit);
+module_spi_driver(m41t93_driver);
 
 MODULE_AUTHOR("Nikolaus Voss <n.voss@weinmann.de>");
 MODULE_DESCRIPTION("Driver for ST M41T93 SPI RTC");
diff -puN drivers/rtc/rtc-m41t94.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-m41t94.c
--- a/drivers/rtc/rtc-m41t94.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-m41t94.c
@@ -153,19 +153,7 @@ static struct spi_driver m41t94_driver =
 	.remove = __devexit_p(m41t94_remove),
 };
 
-static __init int m41t94_init(void)
-{
-	return spi_register_driver(&m41t94_driver);
-}
-
-module_init(m41t94_init);
-
-static __exit void m41t94_exit(void)
-{
-	spi_unregister_driver(&m41t94_driver);
-}
-
-module_exit(m41t94_exit);
+module_spi_driver(m41t94_driver);
 
 MODULE_AUTHOR("Kim B. Heino <Kim.Heino@bluegiga.com>");
 MODULE_DESCRIPTION("Driver for ST M41T94 SPI RTC");
diff -puN drivers/rtc/rtc-max6902.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-max6902.c
@@ -160,17 +160,7 @@ static struct spi_driver max6902_driver 
 	.remove = __devexit_p(max6902_remove),
 };
 
-static __init int max6902_init(void)
-{
-	return spi_register_driver(&max6902_driver);
-}
-module_init(max6902_init);
-
-static __exit void max6902_exit(void)
-{
-	spi_unregister_driver(&max6902_driver);
-}
-module_exit(max6902_exit);
+module_spi_driver(max6902_driver);
 
 MODULE_DESCRIPTION ("max6902 spi RTC driver");
 MODULE_AUTHOR ("Raphael Assenat");
diff -puN drivers/rtc/rtc-pcf2123.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -346,20 +346,9 @@ static struct spi_driver pcf2123_driver 
 	.remove	= __devexit_p(pcf2123_remove),
 };
 
-static int __init pcf2123_init(void)
-{
-	return spi_register_driver(&pcf2123_driver);
-}
-
-static void __exit pcf2123_exit(void)
-{
-	spi_unregister_driver(&pcf2123_driver);
-}
+module_spi_driver(pcf2123_driver);
 
 MODULE_AUTHOR("Chris Verges <chrisv@cyberswitching.com>");
 MODULE_DESCRIPTION("NXP PCF2123 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(pcf2123_init);
-module_exit(pcf2123_exit);
diff -puN drivers/rtc/rtc-r9701.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-r9701.c
@@ -159,17 +159,7 @@ static struct spi_driver r9701_driver = 
 	.remove = __devexit_p(r9701_remove),
 };
 
-static __init int r9701_init(void)
-{
-	return spi_register_driver(&r9701_driver);
-}
-module_init(r9701_init);
-
-static __exit void r9701_exit(void)
-{
-	spi_unregister_driver(&r9701_driver);
-}
-module_exit(r9701_exit);
+module_spi_driver(r9701_driver);
 
 MODULE_DESCRIPTION("r9701 spi RTC driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
diff -puN drivers/rtc/rtc-rs5c348.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~rtc-convert-rtc-spi-drivers-to-module_spi_driver
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -235,18 +235,7 @@ static struct spi_driver rs5c348_driver 
 	.remove	= __devexit_p(rs5c348_remove),
 };
 
-static __init int rs5c348_init(void)
-{
-	return spi_register_driver(&rs5c348_driver);
-}
-
-static __exit void rs5c348_exit(void)
-{
-	spi_unregister_driver(&rs5c348_driver);
-}
