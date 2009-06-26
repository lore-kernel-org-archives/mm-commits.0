From: akpm@linux-foundation.org
Subject: + rtc-philips-nxp-pcf2123-driver.patch added to -mm tree
Date: Fri, 26 Jun 2009 16:07:09 -0700
Message-ID: <200906262307.n5QN79b5027911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZFZXHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 19:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisv@cyberswitching.com, a.zummo@towertech.it


The patch titled
     rtc: Philips/NXP PCF2123 driver
has been added to the -mm tree.  Its filename is
     rtc-philips-nxp-pcf2123-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: Philips/NXP PCF2123 driver
From: Chris Verges <chrisv@cyberswitching.com>

Add support for the Philips/NXP PCF2123 RTC.

Our hardware should arrive in early July, so I'll update (v0.3?) based
on testing after that.

Signed-off-by: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |    9 +
 drivers/rtc/Makefile      |    1 
 drivers/rtc/rtc-pcf2123.c |  245 ++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-philips-nxp-pcf2123-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-philips-nxp-pcf2123-driver
+++ a/drivers/rtc/Kconfig
@@ -224,6 +224,15 @@ config RTC_DRV_PCF8583
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8583.
 
+config RTC_DRV_PCF2123
+	tristate "NXP PCF2123"
+	help
+	  If you say yes here you get support for the NXP PCF2123
+	  RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-pcf2123.
+
 config RTC_DRV_M41T80
 	tristate "ST M41T62/65/M41T80/81/82/83/84/85/87"
 	help
diff -puN drivers/rtc/Makefile~rtc-philips-nxp-pcf2123-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-philips-nxp-pcf2123-driver
+++ a/drivers/rtc/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
 obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
+obj-$(CONFIG_RTC_DRV_PCF2123)	+= rtc-pcf2123.o
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
diff -puN /dev/null drivers/rtc/rtc-pcf2123.c
--- /dev/null
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -0,0 +1,245 @@
+/*
+ * An SPI driver for the Philips PCF2123 RTC
+ * Copyright 2009 Cyber Switching, Inc.
+ *
+ * Author: Chris Verges <chrisv@cyberswitching.com>
+ * Maintainers: http://www.cyberswitching.com
+ *
+ * based on the RS5C348 driver in this same directory.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bcd.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/rtc.h>
+#include <linux/workqueue.h>
+#include <linux/spi/spi.h>
+
+#define DRV_VERSION "0.2"
+
+#define PCF2123_REG_CTRL1	0x00 /* Control Register 1 */
+#define PCF2123_REG_CTRL2	0x01 /* Control Register 2 */
+
+#define PCF2123_REG_SC		0x02 /* datetime */
+#define PCF2123_REG_MN		0x03
+#define PCF2123_REG_HR		0x04
+#define PCF2123_REG_DM		0x05
+#define PCF2123_REG_DW		0x06
+#define PCF2123_REG_MO		0x07
+#define PCF2123_REG_YR		0x08
+
+#define PCF2123_CMD_W(addr)	(((addr) & 0x0F) | 0x40)  /* single write */
+#define PCF2123_CMD_R(addr)	(((addr) & 0x0F) | 0x90)  /* single read */
+
+static struct spi_driver pcf2123_driver;
+
+struct pcf2123_plat_data {
+	struct rtc_device *rtc;
+};
+
+static int pcf2123_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 txbuf[1], rxbuf[7];
+	int ret;
+
+	txbuf[0] = PCF2123_CMD_R(PCF2123_REG_SC);
+	ret = spi_write_then_read(spi, txbuf, sizeof(txbuf),
+			rxbuf, sizeof(rxbuf));
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		return ret;
+
+	tm->tm_sec = bcd2bin(rxbuf[0] & 0x7F);
+	tm->tm_min = bcd2bin(rxbuf[1] & 0x7F);
+	tm->tm_hour = bcd2bin(rxbuf[2] & 0x3F); /* rtc hr 0-23 */
+	tm->tm_mday = bcd2bin(rxbuf[3] & 0x3F);
+	tm->tm_wday = rxbuf[4] & 0x07;
+	tm->tm_mon = bcd2bin(rxbuf[5] & 0x1F) - 1; /* rtc mn 1-12 */
+	tm->tm_year = bcd2bin(rxbuf[6]);
+	if (tm->tm_year < 70)
+		tm->tm_year += 100;	/* assume we are in 1970...2069 */
+
+	dev_dbg(dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
+			"mday=%d, mon=%d, year=%d, wday=%d\n",
+			__func__,
+			tm->tm_sec, tm->tm_min, tm->tm_hour,
+			tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	/* the clock can give out invalid datetime, but we cannot return
+	 * -EINVAL otherwise hwclock will refuse to set the time on bootup.
+	 */
+	if (rtc_valid_tm(tm) < 0)
+		dev_err(dev, "retrieved date/time is not valid.\n");
+
+	return 0;
+}
+
+static int pcf2123_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 txbuf[8];
+	int ret;
+
+	dev_dbg(dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
+			"mday=%d, mon=%d, year=%d, wday=%d\n",
+			__func__,
+			tm->tm_sec, tm->tm_min, tm->tm_hour,
+			tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	/* Stop the counter first */
+	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
+	txbuf[1] = 0x20;
+	ret = spi_write(spi, txbuf, 2);
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		return ret;
+
+	/* Set the new time */
+	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_SC);
+	txbuf[1] = bin2bcd(tm->tm_sec & 0x7F);
+	txbuf[2] = bin2bcd(tm->tm_min & 0x7F);
+	txbuf[3] = bin2bcd(tm->tm_hour & 0x3F);
+	txbuf[4] = bin2bcd(tm->tm_mday & 0x3F);
+	txbuf[5] = tm->tm_wday & 0x07;
+	txbuf[6] = bin2bcd((tm->tm_mon + 1) & 0x1F); /* rtc mn 1-12 */
+	txbuf[7] = bin2bcd(tm->tm_year < 100 ? tm->tm_year : tm->tm_year - 100);
+
+	ret = spi_write(spi, txbuf, sizeof(txbuf));
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		return ret;
+
+	/* Start the counter */
+	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
+	txbuf[1] = 0x00;
+	ret = spi_write(spi, txbuf, 2);
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static const struct rtc_class_ops pcf2123_rtc_ops = {
+	.read_time	= pcf2123_rtc_read_time,
+	.set_time	= pcf2123_rtc_set_time,
+};
+
+static int __devinit pcf2123_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	struct pcf2123_plat_data *pdata;
+	u8 txbuf[2], rxbuf[1];
+	int ret;
+
+	pdata = kzalloc(sizeof(struct pcf2123_plat_data), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+	spi->dev.platform_data = pdata;
+
+	/* Send a software reset command */
+	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
+	txbuf[1] = 0x58;
+	ret = spi_write(spi, txbuf, sizeof(txbuf));
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		return ret;
+
+	/* Stop the counter */
+	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
+	txbuf[1] = 0x20;
+	ret = spi_write(spi, txbuf, sizeof(txbuf));
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		return ret;
+
+	/* See if the counter was actually stopped */
+	txbuf[0] = PCF2123_CMD_R(PCF2123_REG_CTRL1);
+	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, sizeof(rxbuf));
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		goto kfree_exit;
+
+	if (!(rxbuf[0] & 0x20)) {
+		dev_err(&spi->dev, "not found.\n");
+		goto kfree_exit;
+	}
+
+	dev_info(&spi->dev, "chip found, driver version " DRV_VERSION "\n");
+	dev_info(&spi->dev, "spiclk %u KHz.\n",
+			(spi->max_speed_hz + 500) / 1000);
+
+	/* Start the counter */
+	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
+	txbuf[1] = 0x00;
+	ret = spi_write(spi, txbuf, sizeof(txbuf));
+	udelay(30); /* Trec 30us */
+	if (ret < 0)
+		goto kfree_exit;
+
+	/* Finalize the initialization */
+	rtc = rtc_device_register(pcf2123_driver.driver.name, &spi->dev,
+			&pcf2123_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto kfree_exit;
+	}
+
+	pdata->rtc = rtc;
+
+	return 0;
+kfree_exit:
+	kfree(pdata);
+	return ret;
+}
+
+static int pcf2123_remove(struct spi_device *spi)
+{
+	struct pcf2123_plat_data *pdata = spi->dev.platform_data;
+	struct rtc_device *rtc = pdata->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	kfree(pdata);
+
+	return 0;
+}
+
+static struct spi_driver pcf2123_driver = {
+	.driver	= {
+			.name	= "rtc-pcf2123",
+			.bus	= &spi_bus_type,
+			.owner	= THIS_MODULE,
+	},
+	.probe	= pcf2123_probe,
+	.remove	= __devexit_p(pcf2123_remove),
+};
+
+static int __init pcf2123_init(void)
+{
+	return spi_register_driver(&pcf2123_driver);
+}
+
+static void __exit pcf2123_exit(void)
+{
+	spi_unregister_driver(&pcf2123_driver);
+}
+
+MODULE_AUTHOR("Chris Verges <chrisv@cyberswitching.com>");
+MODULE_DESCRIPTION("NXP PCF2123 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(pcf2123_init);
+module_exit(pcf2123_exit);
_

Patches currently in -mm which might be from chrisv@cyberswitching.com are

rtc-philips-nxp-pcf2123-driver.patch

