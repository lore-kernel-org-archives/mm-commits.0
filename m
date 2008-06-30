From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-st-m41t94-spi-rtc.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:56:50 -0700
Message-ID: <200806302156.m5ULuoBl027560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763610AbYF3V56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Kim.Heino@bluegiga.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: add support for ST M41T94 SPI RTC
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-st-m41t94-spi-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add support for ST M41T94 SPI RTC
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>

This patch adds kernel driver for M41T94 RTC chip connected via SPI.
I've tested it on two different AT91-based hardwares.

This is third revision of the patch: some comments made by
Alessandro Zummo fixed.

Revision two added support for century bit and fixes.

Signed-off-by: Kim B. Heino <Kim.Heino@bluegiga.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    9 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-m41t94.c |  173 +++++++++++++++++++++++++++++++++++++
 3 files changed, 183 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-support-for-st-m41t94-spi-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-support-for-st-m41t94-spi-rtc
+++ a/drivers/rtc/Kconfig
@@ -273,6 +273,15 @@ comment "SPI RTC drivers"
 
 if SPI_MASTER
 
+config RTC_DRV_M41T94
+	tristate "ST M41T94"
+	help
+	  If you say yes here you will get support for the
+	  ST M41T94 SPI RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m41t94.
+
 config RTC_DRV_MAX6902
 	tristate "Maxim MAX6902"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-support-for-st-m41t94-spi-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-support-for-st-m41t94-spi-rtc
+++ a/drivers/rtc/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93
 obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
+obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
diff -puN /dev/null drivers/rtc/rtc-m41t94.c
--- /dev/null
+++ a/drivers/rtc/rtc-m41t94.c
@@ -0,0 +1,173 @@
+/*
+ * Driver for ST M41T94 SPI RTC
+ *
+ * Copyright (C) 2008 Kim B. Heino
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+#include <linux/bcd.h>
+
+#define M41T94_REG_SECONDS	0x01
+#define M41T94_REG_MINUTES	0x02
+#define M41T94_REG_HOURS	0x03
+#define M41T94_REG_WDAY		0x04
+#define M41T94_REG_DAY		0x05
+#define M41T94_REG_MONTH	0x06
+#define M41T94_REG_YEAR		0x07
+#define M41T94_REG_HT		0x0c
+
+#define M41T94_BIT_HALT		0x40
+#define M41T94_BIT_STOP		0x80
+#define M41T94_BIT_CB		0x40
+#define M41T94_BIT_CEB		0x80
+
+static int m41t94_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 buf[8]; /* write cmd + 7 registers */
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		"write", tm->tm_sec, tm->tm_min,
+		tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	buf[0] = 0x80 | M41T94_REG_SECONDS; /* write time + date */
+	buf[M41T94_REG_SECONDS] = BIN2BCD(tm->tm_sec);
+	buf[M41T94_REG_MINUTES] = BIN2BCD(tm->tm_min);
+	buf[M41T94_REG_HOURS]   = BIN2BCD(tm->tm_hour);
+	buf[M41T94_REG_WDAY]    = BIN2BCD(tm->tm_wday + 1);
+	buf[M41T94_REG_DAY]     = BIN2BCD(tm->tm_mday);
+	buf[M41T94_REG_MONTH]   = BIN2BCD(tm->tm_mon + 1);
+
+	buf[M41T94_REG_HOURS] |= M41T94_BIT_CEB;
+	if (tm->tm_year >= 100)
+		buf[M41T94_REG_HOURS] |= M41T94_BIT_CB;
+	buf[M41T94_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+
+	return spi_write(spi, buf, 8);
+}
+
+static int m41t94_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 buf[2];
+	int ret, hour;
+
+	/* clear halt update bit */
+	ret = spi_w8r8(spi, M41T94_REG_HT);
+	if (ret < 0)
+		return ret;
+	if (ret & M41T94_BIT_HALT) {
+		buf[0] = 0x80 | M41T94_REG_HT;
+		buf[1] = ret & ~M41T94_BIT_HALT;
+		spi_write(spi, buf, 2);
+	}
+
+	/* clear stop bit */
+	ret = spi_w8r8(spi, M41T94_REG_SECONDS);
+	if (ret < 0)
+		return ret;
+	if (ret & M41T94_BIT_STOP) {
+		buf[0] = 0x80 | M41T94_REG_SECONDS;
+		buf[1] = ret & ~M41T94_BIT_STOP;
+		spi_write(spi, buf, 2);
+	}
+
+	tm->tm_sec  = BCD2BIN(spi_w8r8(spi, M41T94_REG_SECONDS));
+	tm->tm_min  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MINUTES));
+	hour = spi_w8r8(spi, M41T94_REG_HOURS);
+	tm->tm_hour = BCD2BIN(hour & 0x3f);
+	tm->tm_wday = BCD2BIN(spi_w8r8(spi, M41T94_REG_WDAY)) - 1;
+	tm->tm_mday = BCD2BIN(spi_w8r8(spi, M41T94_REG_DAY));
+	tm->tm_mon  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MONTH)) - 1;
+	tm->tm_year = BCD2BIN(spi_w8r8(spi, M41T94_REG_YEAR));
+	if ((hour & M41T94_BIT_CB) || !(hour & M41T94_BIT_CEB))
+		tm->tm_year += 100;
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		"read", tm->tm_sec, tm->tm_min,
+		tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	/* initial clock setting can be undefined */
+	return rtc_valid_tm(tm);
+}
+
+static const struct rtc_class_ops m41t94_rtc_ops = {
+	.read_time	= m41t94_read_time,
+	.set_time	= m41t94_set_time,
+};
+
+static struct spi_driver m41t94_driver;
+
+static int __devinit m41t94_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	int res;
+
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	res = spi_w8r8(spi, M41T94_REG_SECONDS);
+	if (res < 0) {
+		dev_err(&spi->dev, "not found.\n");
+		return res;
+	}
+
+	rtc = rtc_device_register(m41t94_driver.driver.name,
+		&spi->dev, &m41t94_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	dev_set_drvdata(&spi->dev, rtc);
+
+	return 0;
+}
+
+static int __devexit m41t94_remove(struct spi_device *spi)
+{
+	struct rtc_device *rtc = platform_get_drvdata(spi);
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	return 0;
+}
+
+static struct spi_driver m41t94_driver = {
+	.driver = {
+		.name	= "rtc-m41t94",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= m41t94_probe,
+	.remove = __devexit_p(m41t94_remove),
+};
+
+static __init int m41t94_init(void)
+{
+	return spi_register_driver(&m41t94_driver);
+}
+
+module_init(m41t94_init);
+
+static __exit void m41t94_exit(void)
+{
+	spi_unregister_driver(&m41t94_driver);
+}
+
+module_exit(m41t94_exit);
+
+MODULE_AUTHOR("Kim B. Heino <Kim.Heino@bluegiga.com>");
+MODULE_DESCRIPTION("Driver for ST M41T94 SPI RTC");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from Kim.Heino@bluegiga.com are

rtc-add-support-for-st-m41t94-spi-rtc.patch

