From: akpm@linux-foundation.org
Subject: - rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:05 -0800
Message-ID: <200901072219.n07MJ5c6018479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763410AbZAGWh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, mpfj@mimc.co.uk, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-ds1390 probe sequence and misc fixes
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-ds1390 probe sequence and misc fixes
From: Alessandro Zummo <a.zummo@towertech.it>

Small fixes for the ds1390 driver

 - fixed initialization of the spi device
 - added missing includes
 - removed printks
 - removed useless wrappers for rtc ops
 - removed dead code

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    3 +
 drivers/rtc/rtc-ds1390.c |   72 +++++++++++--------------------------
 2 files changed, 24 insertions(+), 51 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-rtc-ds1390-probe-sequence-and-misc-fixes drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-ds1390-probe-sequence-and-misc-fixes
+++ a/drivers/rtc/Kconfig
@@ -317,7 +317,8 @@ config RTC_DRV_DS1305
 config RTC_DRV_DS1390
 	tristate "Dallas/Maxim DS1390/93/94"
 	help
-	  If you say yes here you get support for the DS1390/93/94 chips.
+	  If you say yes here you get support for the
+	  Dallas/Maxim DS1390/93/94 chips.
 
 	  This driver only supports the RTC feature, and not other chip
 	  features such as alarms and trickle charging.
diff -puN drivers/rtc/rtc-ds1390.c~rtc-rtc-ds1390-probe-sequence-and-misc-fixes drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~rtc-rtc-ds1390-probe-sequence-and-misc-fixes
+++ a/drivers/rtc/rtc-ds1390.c
@@ -1,5 +1,5 @@
 /*
- * rtc-ds1390.c -- driver for DS1390/93/94
+ * rtc-ds1390.c -- driver for the Dallas/Maxim DS1390/93/94 SPI RTC
  *
  * Copyright (C) 2008 Mercury IMC Ltd
  * Written by Mark Jackson <mpfj@mimc.co.uk>
@@ -8,11 +8,13 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * NOTE : Currently this driver only supports the bare minimum for read
- * and write the RTC.  The extra features provided by the chip family
+ * NOTE: Currently this driver only supports the bare minimum for read
+ * and write the RTC. The extra features provided by the chip family
  * (alarms, trickle charger, different control registers) are unavailable.
  */
 
+#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
@@ -42,20 +44,6 @@ struct ds1390 {
 	u8 txrx_buf[9];	/* cmd + 8 registers */
 };
 
-static void ds1390_set_reg(struct device *dev, unsigned char address,
-				unsigned char data)
-{
-	struct spi_device *spi = to_spi_device(dev);
-	struct ds1390 *chip = dev_get_drvdata(dev);
-
-	/* Set MSB to indicate write */
-	chip->txrx_buf[0] = address | 0x80;
-	chip->txrx_buf[1] = data;
-
-	/* do the i/o */
-	spi_write_then_read(spi, chip->txrx_buf, 2, NULL, 0);
-}
-
 static int ds1390_get_reg(struct device *dev, unsigned char address,
 				unsigned char *data)
 {
@@ -78,7 +66,7 @@ static int ds1390_get_reg(struct device 
 	return 0;
 }
 
-static int ds1390_get_datetime(struct device *dev, struct rtc_time *dt)
+static int ds1390_read_time(struct device *dev, struct rtc_time *dt)
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct ds1390 *chip = dev_get_drvdata(dev);
@@ -107,7 +95,7 @@ static int ds1390_get_datetime(struct de
 	return rtc_valid_tm(dt);
 }
 
-static int ds1390_set_datetime(struct device *dev, struct rtc_time *dt)
+static int ds1390_set_time(struct device *dev, struct rtc_time *dt)
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct ds1390 *chip = dev_get_drvdata(dev);
@@ -127,16 +115,6 @@ static int ds1390_set_datetime(struct de
 	return spi_write_then_read(spi, chip->txrx_buf, 8, NULL, 0);
 }
 
-static int ds1390_read_time(struct device *dev, struct rtc_time *tm)
-{
-	return ds1390_get_datetime(dev, tm);
-}
-
-static int ds1390_set_time(struct device *dev, struct rtc_time *tm)
-{
-	return ds1390_set_datetime(dev, tm);
-}
-
 static const struct rtc_class_ops ds1390_rtc_ops = {
 	.read_time	= ds1390_read_time,
 	.set_time	= ds1390_set_time,
@@ -149,46 +127,40 @@ static int __devinit ds1390_probe(struct
 	struct ds1390 *chip;
 	int res;
 
-	printk(KERN_DEBUG "DS1390 SPI RTC driver\n");
-
-	rtc = rtc_device_register("ds1390",
-				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		printk(KERN_ALERT "RTC : unable to register device\n");
-		return PTR_ERR(rtc);
-	}
-
 	spi->mode = SPI_MODE_3;
 	spi->bits_per_word = 8;
 	spi_setup(spi);
 
 	chip = kzalloc(sizeof *chip, GFP_KERNEL);
 	if (!chip) {
-		printk(KERN_ALERT "RTC : unable to allocate device memory\n");
-		rtc_device_unregister(rtc);
+		dev_err(&spi->dev, "unable to allocate device memory\n");
 		return -ENOMEM;
 	}
-	chip->rtc = rtc;
 	dev_set_drvdata(&spi->dev, chip);
 
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
-	if (res) {
-		printk(KERN_ALERT "RTC : unable to read device\n");
-		rtc_device_unregister(rtc);
+	if (res != 0) {
+		dev_err(&spi->dev, "unable to read device\n");
+		kfree(chip);
 		return res;
 	}
 
-	return 0;
+	chip->rtc = rtc_device_register("ds1390",
+				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
+	if (IS_ERR(chip->rtc)) {
+		dev_err(&spi->dev, "unable to register device\n");
+		res = PTR_ERR(chip->rtc);
+		kfree(chip);
+	}
+
+	return res;
 }
 
 static int __devexit ds1390_remove(struct spi_device *spi)
 {
 	struct ds1390 *chip = platform_get_drvdata(spi);
-	struct rtc_device *rtc = chip->rtc;
