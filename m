From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-maxim-dallas-rtc-ds1347.patch added to -mm
 tree
Date: Fri, 21 Mar 2014 13:05:37 -0700
Message-ID: <532c9b91.joNs0bpOe7g7Vxb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaCUUFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 16:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, ravi23ganiga@gmail.com

Subject: + rtc-add-support-for-maxim-dallas-rtc-ds1347.patch added to -mm tree
To: ravi23ganiga@gmail.com,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 13:05:37 -0700


The patch titled
     Subject: rtc: add support for maxim dallas rtc ds1347
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-maxim-dallas-rtc-ds1347.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-support-for-maxim-dallas-rtc-ds1347.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-support-for-maxim-dallas-rtc-ds1347.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: rtc: add support for maxim dallas rtc ds1347

Add support for maxim dallas rtc ds1347

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   12 ++
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-ds1347.c |  167 +++++++++++++++++++++++++++++++++++++
 3 files changed, 180 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-support-for-maxim-dallas-rtc-ds1347 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-support-for-maxim-dallas-rtc-ds1347
+++ a/drivers/rtc/Kconfig
@@ -573,6 +573,18 @@ config RTC_DRV_DS1305
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1305.
 
+config RTC_DRV_DS1347
+	tristate "Dallas/Maxim DS1347"
+	help
+	  If you say yes here you get support for the
+	  Dallas/Maxim DS1347 chips.
+
+	  This driver only supports the RTC feature, and not other chip
+	  features such as alarms.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds1347.
+
 config RTC_DRV_DS1390
 	tristate "Dallas/Maxim DS1390/93/94"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-support-for-maxim-dallas-rtc-ds1347 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-support-for-maxim-dallas-rtc-ds1347
+++ a/drivers/rtc/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_RTC_DRV_DS1286)	+= rtc-ds12
 obj-$(CONFIG_RTC_DRV_DS1302)	+= rtc-ds1302.o
 obj-$(CONFIG_RTC_DRV_DS1305)	+= rtc-ds1305.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
+obj-$(CONFIG_RTC_DRV_DS1347)	+= rtc-ds1347.o
 obj-$(CONFIG_RTC_DRV_DS1374)	+= rtc-ds1374.o
 obj-$(CONFIG_RTC_DRV_DS1390)	+= rtc-ds1390.o
 obj-$(CONFIG_RTC_DRV_DS1511)	+= rtc-ds1511.o
diff -puN /dev/null drivers/rtc/rtc-ds1347.c
--- /dev/null
+++ a/drivers/rtc/rtc-ds1347.c
@@ -0,0 +1,167 @@
+/* rtc-ds1347.c
+ *
+ * Driver for Dallas Semiconductor DS1347 Low Current, SPI Compatible
+ * Real Time Clock
+ *
+ * Author : Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+#include <linux/bcd.h>
+
+/* Registers in ds1347 rtc */
+
+#define DS1347_SECONDS_REG	0x01
+#define DS1347_MINUTES_REG	0x03
+#define DS1347_HOURS_REG	0x05
+#define DS1347_DATE_REG		0x07
+#define DS1347_MONTH_REG	0x09
+#define DS1347_DAY_REG		0x0B
+#define DS1347_YEAR_REG		0x0D
+#define DS1347_CONTROL_REG	0x0F
+#define DS1347_STATUS_REG	0x17
+#define DS1347_CLOCK_BURST	0x3F
+
+static int ds1347_read_reg(struct device *dev, unsigned char address,
+				unsigned char *data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+
+	*data = address | 0x80;
+
+	return spi_write_then_read(spi, data, 1, data, 1);
+}
+
+static int ds1347_write_reg(struct device *dev, unsigned char address,
+				unsigned char data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned char buf[2];
+
+	buf[0] = address & 0x7F;
+	buf[1] = data;
+
+	return spi_write_then_read(spi, buf, 2, NULL, 0);
+}
+
+static int ds1347_read_time(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	int err;
+	unsigned char buf[8];
+
+	buf[0] = DS1347_CLOCK_BURST | 0x80;
+
+	err = spi_write_then_read(spi, buf, 1, buf, 8);
+	if (err)
+		return err;
+
+	dt->tm_sec = bcd2bin(buf[0]);
+	dt->tm_min = bcd2bin(buf[1]);
+	dt->tm_hour = bcd2bin(buf[2] & 0x3F);
+	dt->tm_mday = bcd2bin(buf[3]);
+	dt->tm_mon = bcd2bin(buf[4]) - 1;
+	dt->tm_wday = bcd2bin(buf[5]) - 1;
+	dt->tm_year = bcd2bin(buf[6]) + 100;
+
+	return rtc_valid_tm(dt);
+}
+
+static int ds1347_set_time(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned char buf[9];
+
+	buf[0] = DS1347_CLOCK_BURST & 0x7F;
+	buf[1] = bin2bcd(dt->tm_sec);
+	buf[2] = bin2bcd(dt->tm_min);
+	buf[3] = (bin2bcd(dt->tm_hour) & 0x3F);
+	buf[4] = bin2bcd(dt->tm_mday);
+	buf[5] = bin2bcd(dt->tm_mon + 1);
+	buf[6] = bin2bcd(dt->tm_wday + 1);
+
+	/* year in linux is from 1900 i.e in range of 100
+	in rtc it is from 00 to 99 */
+	dt->tm_year = dt->tm_year % 100;
+
+	buf[7] = bin2bcd(dt->tm_year);
+	buf[8] = bin2bcd(0x00);
+
+	/* write the rtc settings */
+	return spi_write_then_read(spi, buf, 9, NULL, 0);
+}
+
+static const struct rtc_class_ops ds1347_rtc_ops = {
+	.read_time = ds1347_read_time,
+	.set_time = ds1347_set_time,
+};
+
+static int ds1347_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	unsigned char data;
+	int res;
+
+	/* spi setup with ds1347 in mode 3 and bits per word as 8 */
+	spi->mode = SPI_MODE_3;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	/* RTC Settings */
+	res = ds1347_read_reg(&spi->dev, DS1347_SECONDS_REG, &data);
+	if (res)
+		return res;
+
+	/* Disable the write protect of rtc */
+	ds1347_read_reg(&spi->dev, DS1347_CONTROL_REG, &data);
+	data = data & ~(1<<7);
+	ds1347_write_reg(&spi->dev, DS1347_CONTROL_REG, data);
+
+	/* Enable the oscillator , disable the oscillator stop flag,
+	 and glitch filter to reduce current consumption */
+	ds1347_read_reg(&spi->dev, DS1347_STATUS_REG, &data);
+	data = data & 0x1B;
+	ds1347_write_reg(&spi->dev, DS1347_STATUS_REG, data);
+
+	/* display the settings */
+	ds1347_read_reg(&spi->dev, DS1347_CONTROL_REG, &data);
+	dev_info(&spi->dev, "DS1347 RTC CTRL Reg = 0x%02x\n", data);
+
+	ds1347_read_reg(&spi->dev, DS1347_STATUS_REG, &data);
+	dev_info(&spi->dev, "DS1347 RTC Status Reg = 0x%02x\n", data);
+
+	rtc = devm_rtc_device_register(&spi->dev, "ds1347",
+				&ds1347_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	spi_set_drvdata(spi, rtc);
+
+	return 0;
+}
+
+static struct spi_driver ds1347_driver = {
+	.driver = {
+		.name = "ds1347",
+		.owner = THIS_MODULE,
+	},
+	.probe = ds1347_probe,
+};
+
+module_spi_driver(ds1347_driver);
+
+MODULE_DESCRIPTION("DS1347 SPI RTC DRIVER");
+MODULE_AUTHOR("Raghavendra C Ganiga <ravi23ganiga@gmail.com>");
+MODULE_LICENSE("GPL v2");
+
_

Patches currently in -mm which might be from ravi23ganiga@gmail.com are

rtc-add-support-for-maxim-dallas-rtc-ds1347.patch

