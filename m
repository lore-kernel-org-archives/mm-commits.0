From: akpm@linux-foundation.org
Subject: + drivers-rtc-add-support-for-microchip-mcp795.patch added to -mm tree
Date: Wed, 07 May 2014 14:44:30 -0700
Message-ID: <536aa93e.KZV2JeKpl5lwuvYx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEGVob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, atx@atx.name

Subject: + drivers-rtc-add-support-for-microchip-mcp795.patch added to -mm tree
To: atx@atx.name,a.zummo@towertech.it,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:44:30 -0700


The patch titled
     Subject: drivers/rtc: add support for Microchip MCP795
has been added to the -mm tree.  Its filename is
     drivers-rtc-add-support-for-microchip-mcp795.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-add-support-for-microchip-mcp795.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-add-support-for-microchip-mcp795.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josef Gajdusek <atx@atx.name>
Subject: drivers/rtc: add support for Microchip MCP795

Add driver for SPI RTC Microchip MCP795.  Only supports saving/loading
time from the chip (i.  e.  no alarms/power events/ID).

Signed-off-by: Josef Gajdusek <atx@atx.name>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    8 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-mcp795.c |  199 +++++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+)

diff -puN drivers/rtc/Kconfig~drivers-rtc-add-support-for-microchip-mcp795 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-add-support-for-microchip-mcp795
+++ a/drivers/rtc/Kconfig
@@ -660,6 +660,14 @@ config RTC_DRV_RX4581
 	  This driver can also be built as a module. If so the module
 	  will be called rtc-rx4581.
 
+config RTC_DRV_MCP795
+	tristate "Microchip MCP795"
+	help
+	  If you say yes here you will get support for the Microchip MCP795.
+
+	  This driver can also be built as a module. If so the module
+	  will be called rtc-mcp795.
+
 endif # SPI_MASTER
 
 comment "Platform RTC drivers"
diff -puN drivers/rtc/Makefile~drivers-rtc-add-support-for-microchip-mcp795 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~drivers-rtc-add-support-for-microchip-mcp795
+++ a/drivers/rtc/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_RTC_DRV_MAX8997)	+= rtc-max
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
 obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
+obj-$(CONFIG_RTC_DRV_MCP795)	+= rtc-mcp795.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_MPC5121)	+= rtc-mpc5121.o
 obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
diff -puN /dev/null drivers/rtc/rtc-mcp795.c
--- /dev/null
+++ a/drivers/rtc/rtc-mcp795.c
@@ -0,0 +1,199 @@
+/*
+ * SPI Driver for Microchip MCP795 RTC
+ *
+ * Copyright (C) Josef Gajdusek <atx@atx.name>
+ *
+ * based on other Linux RTC drivers
+ *
+ * Device datasheet:
+ * http://ww1.microchip.com/downloads/en/DeviceDoc/22280A.pdf
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/printk.h>
+#include <linux/spi/spi.h>
+#include <linux/rtc.h>
+
+/* MCP795 Instructions, see datasheet table 3-1 */
+#define MCP795_EEREAD	0x03
+#define MCP795_EEWRITE	0x02
+#define MCP795_EEWRDI	0x04
+#define MCP795_EEWREN	0x06
+#define MCP795_SRREAD	0x05
+#define MCP795_SRWRITE	0x01
+#define MCP795_READ		0x13
+#define MCP795_WRITE	0x12
+#define MCP795_UNLOCK	0x14
+#define MCP795_IDWRITE	0x32
+#define MCP795_IDREAD	0x33
+#define MCP795_CLRWDT	0x44
+#define MCP795_CLRRAM	0x54
+
+#define MCP795_ST_BIT	0x80
+#define MCP795_24_BIT	0x40
+
+static int mcp795_rtcc_read(struct device *dev, u8 addr, u8 *buf, u8 count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	int ret;
+	u8 tx[2];
+
+	tx[0] = MCP795_READ;
+	tx[1] = addr;
+	ret = spi_write_then_read(spi, tx, sizeof(tx), buf, count);
+
+	if (ret)
+		dev_err(dev, "Failed reading %d bytes from address %x.\n",
+					count, addr);
+
+	return ret;
+}
+
+static int mcp795_rtcc_write(struct device *dev, u8 addr, u8 *data, u8 count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	int ret;
+	u8 tx[2 + count];
+
+	tx[0] = MCP795_WRITE;
+	tx[1] = addr;
+	memcpy(&tx[2], data, count);
+
+	ret = spi_write(spi, tx, 2 + count);
+
+	if (ret)
+		dev_err(dev, "Failed to write %d bytes to address %x.\n",
+					count, addr);
+
+	return ret;
+}
+
+static int mcp795_rtcc_set_bits(struct device *dev, u8 addr, u8 mask, u8 state)
+{
+	int ret;
+	u8 tmp;
+
+	ret = mcp795_rtcc_read(dev, addr, &tmp, 1);
+	if (ret)
+		return ret;
+
+	if ((tmp & mask) != state) {
+		tmp = (tmp & ~mask) | state;
+		ret = mcp795_rtcc_write(dev, addr, &tmp, 1);
+	}
+
+	return ret;
+}
+
+static int mcp795_set_time(struct device *dev, struct rtc_time *tim)
+{
+	int ret;
+	u8 data[7];
+
+	/* Read first, so we can leave config bits untouched */
+	ret = mcp795_rtcc_read(dev, 0x01, data, sizeof(data));
+
+	if (ret)
+		return ret;
+
+	data[0] = (data[0] & 0x80) | ((tim->tm_sec / 10) << 4) | (tim->tm_sec % 10);
+	data[1] = (data[1] & 0x80) | ((tim->tm_min / 10) << 4) | (tim->tm_min % 10);
+	data[2] = ((tim->tm_hour / 10) << 4) | (tim->tm_hour % 10);
+	data[4] = ((tim->tm_mday / 10) << 4) | ((tim->tm_mday) % 10);
+	data[5] = (data[5] & 0x10) | (tim->tm_mon / 10) | (tim->tm_mon % 10);
+
+	if (tim->tm_year > 100)
+		tim->tm_year -= 100;
+
+	data[6] = ((tim->tm_year / 10) << 4) | (tim->tm_year % 10);
+
+	ret = mcp795_rtcc_write(dev, 0x01, data, sizeof(data));
+
+	if (ret)
+		return ret;
+
+	dev_dbg(dev, "Set mcp795: %04d-%02d-%02d %02d:%02d:%02d\n",
+			tim->tm_year + 1900, tim->tm_mon, tim->tm_mday,
+			tim->tm_hour, tim->tm_min, tim->tm_sec);
+
+	return 0;
+}
+
+static int mcp795_read_time(struct device *dev, struct rtc_time *tim)
+{
+	int ret;
+	u8 data[7];
+
+	ret = mcp795_rtcc_read(dev, 0x01, data, sizeof(data));
+
+	if (ret)
+		return ret;
+
+	tim->tm_sec		= ((data[0] & 0x70) >> 4) * 10 + (data[0] & 0x0f);
+	tim->tm_min		= ((data[1] & 0x70) >> 4) * 10 + (data[1] & 0x0f);
+	tim->tm_hour	= ((data[2] & 0x30) >> 4) * 10 + (data[2] & 0x0f);
+	tim->tm_mday	= ((data[4] & 0x30) >> 4) * 10 + (data[4] & 0x0f);
+	tim->tm_mon		= ((data[5] & 0x10) >> 4) * 10 + (data[5] & 0x0f);
+	tim->tm_year	= ((data[6] & 0xf0) >> 4) * 10 + (data[6] & 0x0f) + 100; /* Assume we are in 20xx */
+
+	dev_dbg(dev, "Read from mcp795: %04d-%02d-%02d %02d:%02d:%02d\n",
+				tim->tm_year + 1900, tim->tm_mon, tim->tm_mday,
+				tim->tm_hour, tim->tm_min, tim->tm_sec);
+
+	return rtc_valid_tm(tim);
+}
+
+static struct rtc_class_ops mcp795_rtc_ops = {
+		.read_time = mcp795_read_time,
+		.set_time = mcp795_set_time
+};
+
+static int mcp795_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	int ret;
+
+	spi->mode = SPI_MODE_0;
+	spi->bits_per_word = 8;
+	ret = spi_setup(spi);
+	if (ret) {
+		dev_err(&spi->dev, "Unable to setup SPI\n");
+		return ret;
+	}
+
+	/* Start the oscillator */
+	mcp795_rtcc_set_bits(&spi->dev, 0x01, MCP795_ST_BIT, MCP795_ST_BIT);
+	/* Clear the 12 hour mode flag*/
+	mcp795_rtcc_set_bits(&spi->dev, 0x03, MCP795_24_BIT, 0);
+
+	rtc = devm_rtc_device_register(&spi->dev, "rtc-mcp795",
+								&mcp795_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	spi_set_drvdata(spi, rtc);
+
+	return 0;
+}
+
+static struct spi_driver mcp795_driver = {
+		.driver = {
+				.name = "rtc-mcp795",
+				.owner = THIS_MODULE,
+		},
+		.probe = mcp795_probe,
+};
+
+module_spi_driver(mcp795_driver);
+
+MODULE_DESCRIPTION("MCP795 RTC SPI Driver");
+MODULE_AUTHOR("Josef Gajdusek <atx@atx.name>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:mcp795");
_

Patches currently in -mm which might be from atx@atx.name are

drivers-rtc-add-support-for-microchip-mcp795.patch

