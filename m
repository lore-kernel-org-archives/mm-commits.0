From: akpm@linux-foundation.org
Subject: + add-dallas-ds1390-93-94-rtc-chips.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:38:00 -0700
Message-ID: <200810212238.m9LMc0mL004454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYJUWiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:38:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpfj@mimc.co.uk, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: add Dallas DS1390/93/94 RTC chips
has been added to the -mm tree.  Its filename is
     add-dallas-ds1390-93-94-rtc-chips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add Dallas DS1390/93/94 RTC chips
From: Mark Jackson <mpfj@mimc.co.uk>

Add support for the Dallas DS1390/93/94 SPI RTC chip.

Signed-off-by: Mark Jackson <mpfj@mimc.co.uk>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   11 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-ds1390.c |  220 +++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+)

diff -puN drivers/rtc/Kconfig~add-dallas-ds1390-93-94-rtc-chips drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~add-dallas-ds1390-93-94-rtc-chips
+++ a/drivers/rtc/Kconfig
@@ -292,6 +292,17 @@ config RTC_DRV_DS1305
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1305.
 
+config RTC_DRV_DS1390
+	tristate "Dallas/Maxim DS1390/93/94"
+	help
+	  If you say yes here you get support for the DS1390/93/94 chips.
+
+	  This driver only supports the RTC feature, and not other chip
+	  features such as alarms and trickle charging.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds1390.
+
 config RTC_DRV_MAX6902
 	tristate "Maxim MAX6902"
 	help
diff -puN drivers/rtc/Makefile~add-dallas-ds1390-93-94-rtc-chips drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~add-dallas-ds1390-93-94-rtc-chips
+++ a/drivers/rtc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RTC_DRV_DS1302)	+= rtc-ds13
 obj-$(CONFIG_RTC_DRV_DS1305)	+= rtc-ds1305.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
 obj-$(CONFIG_RTC_DRV_DS1374)	+= rtc-ds1374.o
+obj-$(CONFIG_RTC_DRV_DS1390)	+= rtc-ds1390.o
 obj-$(CONFIG_RTC_DRV_DS1511)	+= rtc-ds1511.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
diff -puN /dev/null drivers/rtc/rtc-ds1390.c
--- /dev/null
+++ a/drivers/rtc/rtc-ds1390.c
@@ -0,0 +1,220 @@
+/*
+ * rtc-ds1390.c -- driver for DS1390/93/94
+ *
+ * Copyright (C) 2008 Mercury IMC Ltd
+ * Written by Mark Jackson <mpfj@mimc.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * NOTE : Currently this driver only supports the bare minimum for read
+ * and write the RTC.  The extra features provided by the chip family
+ * (alarms, trickle charger, different control registers) are unavailable.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+#include <linux/bcd.h>
+
+#define DS1390_REG_100THS		0x00
+#define DS1390_REG_SECONDS		0x01
+#define DS1390_REG_MINUTES		0x02
+#define DS1390_REG_HOURS		0x03
+#define DS1390_REG_DAY			0x04
+#define DS1390_REG_DATE			0x05
+#define DS1390_REG_MONTH_CENT		0x06
+#define DS1390_REG_YEAR			0x07
+
+#define DS1390_REG_ALARM_100THS		0x08
+#define DS1390_REG_ALARM_SECONDS	0x09
+#define DS1390_REG_ALARM_MINUTES	0x0A
+#define DS1390_REG_ALARM_HOURS		0x0B
+#define DS1390_REG_ALARM_DAY_DATE	0x0C
+
+#define DS1390_REG_CONTROL		0x0D
+#define DS1390_REG_STATUS		0x0E
+#define DS1390_REG_TRICKLE		0x0F
+
+struct ds1390 {
+	struct rtc_device *rtc;
+	u8 txrx_buf[9];	/* cmd + 8 registers */
+};
+
+static void ds1390_set_reg(struct device *dev, unsigned char address,
+				unsigned char data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+
+	/* Set MSB to indicate write */
+	chip->txrx_buf[0] = address | 0x80;
+	chip->txrx_buf[1] = data;
+
+	/* do the i/o */
+	spi_write_then_read(spi, chip->txrx_buf, 2, NULL, 0);
+}
+
+static int ds1390_get_reg(struct device *dev, unsigned char address,
+				unsigned char *data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+	int status;
+
+	if (!data)
+		return -EINVAL;
+
+	/* Clear MSB to indicate read */
+	chip->txrx_buf[0] = address & 0x7f;
+	/* do the i/o */
+	status = spi_write_then_read(spi, chip->txrx_buf, 1, chip->txrx_buf, 1);
+	if (status != 0)
+		return status;
+
+	*data = chip->txrx_buf[1];
+
+	return 0;
+}
+
+static int ds1390_get_datetime(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+	int status;
+
+	/* build the message */
+	chip->txrx_buf[0] = DS1390_REG_SECONDS;
+
+	/* do the i/o */
+	status = spi_write_then_read(spi, chip->txrx_buf, 1, chip->txrx_buf, 8);
+	if (status != 0)
+		return status;
+
+	/* The chip sends data in this order:
+	 * Seconds, Minutes, Hours, Day, Date, Month / Century, Year */
+	dt->tm_sec	= bcd2bin(chip->txrx_buf[0]);
+	dt->tm_min	= bcd2bin(chip->txrx_buf[1]);
+	dt->tm_hour	= bcd2bin(chip->txrx_buf[2]);
+	dt->tm_wday	= bcd2bin(chip->txrx_buf[3]);
+	dt->tm_mday	= bcd2bin(chip->txrx_buf[4]);
+	/* mask off century bit */
+	dt->tm_mon	= bcd2bin(chip->txrx_buf[5] & 0x7f) - 1;
+	/* adjust for century bit */
+	dt->tm_year = bcd2bin(chip->txrx_buf[6]) + ((chip->txrx_buf[5] & 0x80) ? 100 : 0);
+
+	return rtc_valid_tm(dt);
+}
+
+static int ds1390_set_datetime(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+
+	/* build the message */
+	chip->txrx_buf[0] = DS1390_REG_SECONDS | 0x80;
+	chip->txrx_buf[1] = bin2bcd(dt->tm_sec);
+	chip->txrx_buf[2] = bin2bcd(dt->tm_min);
+	chip->txrx_buf[3] = bin2bcd(dt->tm_hour);
+	chip->txrx_buf[4] = bin2bcd(dt->tm_wday);
+	chip->txrx_buf[5] = bin2bcd(dt->tm_mday);
+	chip->txrx_buf[6] = bin2bcd(dt->tm_mon + 1) |
+				((dt->tm_year > 99) ? 0x80 : 0x00);
+	chip->txrx_buf[7] = bin2bcd(dt->tm_year % 100);
+
+	/* do the i/o */
+	return spi_write_then_read(spi, chip->txrx_buf, 8, NULL, 0);
+}
+
+static int ds1390_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return ds1390_get_datetime(dev, tm);
+}
+
+static int ds1390_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return ds1390_set_datetime(dev, tm);
+}
+
+static const struct rtc_class_ops ds1390_rtc_ops = {
+	.read_time	= ds1390_read_time,
+	.set_time	= ds1390_set_time,
+};
+
+static int __devinit ds1390_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	unsigned char tmp;
+	struct ds1390 *chip;
+	int res;
+
+	printk(KERN_DEBUG "DS1390 SPI RTC driver\n");
+
+	rtc = rtc_device_register("ds1390",
+				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		printk(KERN_ALERT "RTC : unable to register device\n");
+		return PTR_ERR(rtc);
+	}
+
+	spi->mode = SPI_MODE_3;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	if (!chip) {
+		printk(KERN_ALERT "RTC : unable to allocate device memory\n");
+		rtc_device_unregister(rtc);
+		return -ENOMEM;
+	}
+	chip->rtc = rtc;
+	dev_set_drvdata(&spi->dev, chip);
+
+	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
+	if (res) {
+		printk(KERN_ALERT "RTC : unable to read device\n");
+		rtc_device_unregister(rtc);
+		return res;
+	}
+
+	return 0;
+}
+
+static int __devexit ds1390_remove(struct spi_device *spi)
+{
+	struct ds1390 *chip = platform_get_drvdata(spi);
+	struct rtc_device *rtc = chip->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	kfree(chip);
+
+	return 0;
+}
+
+static struct spi_driver ds1390_driver = {
+	.driver = {
+		.name	= "rtc-ds1390",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= ds1390_probe,
+	.remove = __devexit_p(ds1390_remove),
+};
+
+static __init int ds1390_init(void)
+{
+	return spi_register_driver(&ds1390_driver);
+}
+module_init(ds1390_init);
+
+static __exit void ds1390_exit(void)
+{
+	spi_unregister_driver(&ds1390_driver);
+}
+module_exit(ds1390_exit);
+
+MODULE_DESCRIPTION("DS1390/93/94 SPI RTC driver");
+MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from mpfj@mimc.co.uk are

linux-next.patch
add-dallas-ds1390-93-94-rtc-chips.patch

