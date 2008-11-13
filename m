From: akpm@linux-foundation.org
Subject: - rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:30 -0800
Message-ID: <200811132127.mADLRUas027963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbYKMV14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martyn.welch@gefanuc.com, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     rtc: basic implementation of Epson RX-8581 I2C Real Time Clock
has been removed from the -mm tree.  Its filename was
     rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: basic implementation of Epson RX-8581 I2C Real Time Clock
From: Martyn Welch <martyn.welch@gefanuc.com>

Provide the basic "get" and "set" functionality for the Epson RX-8581 I2C
RTC.  It currently does not support the RTC's Alarm or Fixed-cycle timer.

[akpm@linux-foundation.org: need log2.h for ilog2(), remove unneeded initialisation]
Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    8 +
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-rx8581.c |  281 +++++++++++++++++++++++++++++++++++++
 3 files changed, 290 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock
+++ a/drivers/rtc/Kconfig
@@ -277,6 +277,14 @@ config RTC_DRV_FM3130
 	  This driver can also be built as a module. If so the module
 	  will be called rtc-fm3130.
 
+config RTC_DRV_RX8581
+	tristate "Epson RX-8581"
+	help
+	  If you say yes here you will get support for the Epson RX-8581.
+
+	  This driver can also be built as a module. If so the module
+	  will be called rtc-rx8581.
+
 endif # I2C
 
 comment "SPI RTC drivers"
diff -puN drivers/rtc/Makefile~rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock
+++ a/drivers/rtc/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
+obj-$(CONFIG_RTC_DRV_RX8581)	+= rtc-rx8581.o
 obj-$(CONFIG_RTC_DRV_S35390A)	+= rtc-s35390a.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
diff -puN /dev/null drivers/rtc/rtc-rx8581.c
--- /dev/null
+++ a/drivers/rtc/rtc-rx8581.c
@@ -0,0 +1,281 @@
+/*
+ * An I2C driver for the Epson RX8581 RTC
+ *
+ * Author: Martyn Welch <martyn.welch@gefanuc.com>
+ * Copyright 2008 GE Fanuc Intelligent Platforms Embedded Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on: rtc-pcf8563.c (An I2C driver for the Philips PCF8563 RTC)
+ * Copyright 2005-06 Tower Technologies
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+#include <linux/log2.h>
+
+#define DRV_VERSION "0.1"
+
+#define RX8581_REG_SC		0x00 /* Second in BCD */
+#define RX8581_REG_MN		0x01 /* Minute in BCD */
+#define RX8581_REG_HR		0x02 /* Hour in BCD */
+#define RX8581_REG_DW		0x03 /* Day of Week */
+#define RX8581_REG_DM		0x04 /* Day of Month in BCD */
+#define RX8581_REG_MO		0x05 /* Month in BCD */
+#define RX8581_REG_YR		0x06 /* Year in BCD */
+#define RX8581_REG_RAM		0x07 /* RAM */
+#define RX8581_REG_AMN		0x08 /* Alarm Min in BCD*/
+#define RX8581_REG_AHR		0x09 /* Alarm Hour in BCD */
+#define RX8581_REG_ADM		0x0A
+#define RX8581_REG_ADW		0x0A
+#define RX8581_REG_TMR0		0x0B
+#define RX8581_REG_TMR1		0x0C
+#define RX8581_REG_EXT		0x0D /* Extension Register */
+#define RX8581_REG_FLAG		0x0E /* Flag Register */
+#define RX8581_REG_CTRL		0x0F /* Control Register */
+
+
+/* Flag Register bit definitions */
+#define RX8581_FLAG_UF		0x20 /* Update */
+#define RX8581_FLAG_TF		0x10 /* Timer */
+#define RX8581_FLAG_AF		0x08 /* Alarm */
+#define RX8581_FLAG_VLF		0x02 /* Voltage Low */
+
+/* Control Register bit definitions */
+#define RX8581_CTRL_UIE		0x20 /* Update Interrupt Enable */
+#define RX8581_CTRL_TIE		0x10 /* Timer Interrupt Enable */
+#define RX8581_CTRL_AIE		0x08 /* Alarm Interrupt Enable */
+#define RX8581_CTRL_STOP	0x02 /* STOP bit */
+#define RX8581_CTRL_RESET	0x01 /* RESET bit */
+
+static struct i2c_driver rx8581_driver;
+
+/*
+ * In the routines that deal directly with the rx8581 hardware, we use
+ * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
+ */
+static int rx8581_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	unsigned char date[7];
+	int data, err;
+
+	/* First we ensure that the "update flag" is not set, we read the
+	 * time and date then re-read the "update flag". If the update flag
+	 * has been set, we know that the time has changed during the read so
+	 * we repeat the whole process again.
+	 */
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_FLAG);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read device flags\n");
+		return -EIO;
+	}
+
+	do {
+		/* If update flag set, clear it */
+		if (data & RX8581_FLAG_UF) {
+			err = i2c_smbus_write_byte_data(client,
+				RX8581_REG_FLAG, (data & ~RX8581_FLAG_UF));
+			if (err != 0) {
+				dev_err(&client->dev, "Unable to write device "
+					"flags\n");
+				return -EIO;
+			}
+		}
+
+		/* Now read time and date */
+		err = i2c_smbus_read_i2c_block_data(client, RX8581_REG_SC,
+			7, date);
+		if (err < 0) {
+			dev_err(&client->dev, "Unable to read date\n");
+			return -EIO;
+		}
+
+		/* Check flag register */
+		data = i2c_smbus_read_byte_data(client, RX8581_REG_FLAG);
+		if (data < 0) {
+			dev_err(&client->dev, "Unable to read device flags\n");
+			return -EIO;
+		}
+	} while (data & RX8581_FLAG_UF);
+
+	if (data & RX8581_FLAG_VLF)
+		dev_info(&client->dev,
+			"low voltage detected, date/time is not reliable.\n");
+
+	dev_dbg(&client->dev,
+		"%s: raw data is sec=%02x, min=%02x, hr=%02x, "
+		"wday=%02x, mday=%02x, mon=%02x, year=%02x\n",
+		__func__,
+		date[0], date[1], date[2], date[3], date[4], date[5], date[6]);
+
+	tm->tm_sec = bcd2bin(date[RX8581_REG_SC] & 0x7F);
+	tm->tm_min = bcd2bin(date[RX8581_REG_MN] & 0x7F);
+	tm->tm_hour = bcd2bin(date[RX8581_REG_HR] & 0x3F); /* rtc hr 0-23 */
+	tm->tm_wday = ilog2(date[RX8581_REG_DW] & 0x7F);
+	tm->tm_mday = bcd2bin(date[RX8581_REG_DM] & 0x3F);
+	tm->tm_mon = bcd2bin(date[RX8581_REG_MO] & 0x1F) - 1; /* rtc mn 1-12 */
+	tm->tm_year = bcd2bin(date[RX8581_REG_YR]);
+	if (tm->tm_year < 70)
+		tm->tm_year += 100;	/* assume we are in 1970...2069 */
+
+
+	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
+		"mday=%d, mon=%d, year=%d, wday=%d\n",
+		__func__,
+		tm->tm_sec, tm->tm_min, tm->tm_hour,
+		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	err = rtc_valid_tm(tm);
+	if (err < 0)
+		dev_err(&client->dev, "retrieved date/time is not valid.\n");
+
+	return err;
+}
+
+static int rx8581_set_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	int data, err;
+	unsigned char buf[7];
+
+	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
+		"mday=%d, mon=%d, year=%d, wday=%d\n",
+		__func__,
+		tm->tm_sec, tm->tm_min, tm->tm_hour,
+		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	/* hours, minutes and seconds */
+	buf[RX8581_REG_SC] = bin2bcd(tm->tm_sec);
+	buf[RX8581_REG_MN] = bin2bcd(tm->tm_min);
+	buf[RX8581_REG_HR] = bin2bcd(tm->tm_hour);
+
+	buf[RX8581_REG_DM] = bin2bcd(tm->tm_mday);
+
+	/* month, 1 - 12 */
+	buf[RX8581_REG_MO] = bin2bcd(tm->tm_mon + 1);
+
+	/* year and century */
+	buf[RX8581_REG_YR] = bin2bcd(tm->tm_year % 100);
+	buf[RX8581_REG_DW] = (0x1 << tm->tm_wday);
+
+	/* Stop the clock */
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_CTRL);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read control register\n");
+		return -EIO;
+	}
+
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
+		(data | RX8581_CTRL_STOP));
+	if (err < 0) {
+		dev_err(&client->dev, "Unable to write control register\n");
+		return -EIO;
+	}
+
+	/* write register's data */
+	err = i2c_smbus_write_i2c_block_data(client, RX8581_REG_SC, 7, buf);
+	if (err < 0) {
+		dev_err(&client->dev, "Unable to write to date registers\n");
+		return -EIO;
+	}
+
+	/* Restart the clock */
+	data = i2c_smbus_read_byte_data(client, RX8581_REG_CTRL);
+	if (data < 0) {
+		dev_err(&client->dev, "Unable to read control register\n");
+		return -EIO;
+	}
+
+	err = i2c_smbus_write_byte_data(client, RX8581_REG_FLAG,
+		(data | ~(RX8581_CTRL_STOP)));
+	if (err != 0) {
+		dev_err(&client->dev, "Unable to write control register\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int rx8581_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return rx8581_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int rx8581_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return rx8581_set_datetime(to_i2c_client(dev), tm);
+}
+
+static const struct rtc_class_ops rx8581_rtc_ops = {
+	.read_time	= rx8581_rtc_read_time,
+	.set_time	= rx8581_rtc_set_time,
+};
+
+static int __devinit rx8581_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct rtc_device *rtc;
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
+
+	rtc = rtc_device_register(rx8581_driver.driver.name,
+				&client->dev, &rx8581_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	i2c_set_clientdata(client, rtc);
+
+	return 0;
+}
+
+static int __devexit rx8581_remove(struct i2c_client *client)
+{
+	struct rtc_device *rtc = i2c_get_clientdata(client);
+
+	rtc_device_unregister(rtc);
+
+	return 0;
+}
+
+static const struct i2c_device_id rx8581_id[] = {
+	{ "rx8581", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rx8581_id);
+
+static struct i2c_driver rx8581_driver = {
+	.driver		= {
+		.name	= "rtc-rx8581",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= rx8581_probe,
+	.remove		= __devexit_p(rx8581_remove),
+	.id_table	= rx8581_id,
+};
+
+static int __init rx8581_init(void)
+{
+	return i2c_add_driver(&rx8581_driver);
+}
+
+static void __exit rx8581_exit(void)
+{
+	i2c_del_driver(&rx8581_driver);
+}
+
+MODULE_AUTHOR("Martyn Welch <martyn.welch@gefanuc.com>");
+MODULE_DESCRIPTION("Epson RX-8581 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(rx8581_init);
+module_exit(rx8581_exit);
_

Patches currently in -mm which might be from martyn.welch@gefanuc.com are

origin.patch

