From: akpm@linux-foundation.org
Subject: + rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch added to -mm tree
Date: Tue, 28 Oct 2008 13:33:34 -0700
Message-ID: <200810282033.m9SKXYsX020848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbYJ1Uei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 16:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: martyn.welch@gefanuc.com, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org


The patch titled
     rtc: basic implementation of Epson RX-8581 I2C Real Time Clock
has been added to the -mm tree.  Its filename is
     rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch

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
Subject: rtc: basic implementation of Epson RX-8581 I2C Real Time Clock
From: Martyn Welch <martyn.welch@gefanuc.com>

Provide the basic "get" and "set" functionality for the Epson RX-8581 I2C
RTC.  It currently does not support the RTC's Alarm or Fixed-cycle timer.

Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    8 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-rx8581.c |  321 +++++++++++++++++++++++++++++++++++++
 3 files changed, 330 insertions(+)

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
@@ -58,6 +58,7 @@ obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701
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
@@ -0,0 +1,321 @@
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
+#include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
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
+	unsigned char date[7] = { RX8581_REG_SC };
+	unsigned char flags = RX8581_REG_FLAG;
+	int err;
+
+	/* First we ensure that the "update flag" is not set, we read the
+	 * time and date then re-read the "update flag". If the update flag
+	 * has been set, we know that the time has changed during the read so
+	 * we repeat the whole process again.
+	 */
+	/* Read flag register */
+	struct i2c_msg msgs[] = {
+		{ client->addr, 0, 1, &flags },		/* setup read ptr */
+		{ client->addr, I2C_M_RD, 1, &flags },	/* read flags */
+	};
+
+	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	do {
+
+		/* If update flag set, clear it */
+		if (flags & RX8581_FLAG_UF) {
+			unsigned char data[2] = { RX8581_REG_FLAG,
+				(flags & ~RX8581_FLAG_UF) };
+
+			err = i2c_master_send(client, data, sizeof(data));
+			if (err != sizeof(data)) {
+				dev_err(&client->dev,
+					"%s: err=%d addr=%02x, data=%02x\n",
+					__func__, err, data[0], data[1]);
+				return -EIO;
+			}
+		}
+
+		/* Now read time and date */
+		date[0] = RX8581_REG_SC;
+		msgs[0].buf = date;
+		msgs[1].buf = date;
+		msgs[1].len = 7;
+
+		if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+			dev_err(&client->dev, "%s: read error\n", __func__);
+			return -EIO;
+		}
+
+		/* Check flag register */
+		flags = RX8581_REG_FLAG;
+		msgs[0].buf = &flags;
+		msgs[1].buf = &flags;
+		msgs[1].len = 1;
+
+		if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+			dev_err(&client->dev, "%s: read error\n", __func__);
+			return -EIO;
+		}
+	} while (flags & RX8581_FLAG_UF);
+
+	if (flags & RX8581_FLAG_VLF)
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
+	int i, err;
+	unsigned char buf[9];
+	unsigned char ctrl = RX8581_REG_CTRL;
+	unsigned char data[2];
+	struct i2c_msg msgs[] = {
+		{ client->addr, 0, 1, &ctrl },		/* setup read ptr */
+		{ client->addr, I2C_M_RD, 1, &ctrl },	/* read flags */
+	};
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
+	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	data[0] = RX8581_REG_CTRL;
+	data[1] = (ctrl | RX8581_CTRL_STOP);
+
+	err = i2c_master_send(client, data, sizeof(data));
+	if (err != sizeof(data)) {
+		dev_err(&client->dev,
+			"%s: err=%d addr=%02x, data=%02x\n",
+			__func__, err, data[0], data[1]);
+		return -EIO;
+	}
+
+	/* write register's data */
+	for (i = 0; i < 7; i++) {
+		data[0] = RX8581_REG_SC + i;
+		data[1] = buf[RX8581_REG_SC + i];
+
+		err = i2c_master_send(client, data, sizeof(data));
+		if (err != sizeof(data)) {
+			dev_err(&client->dev,
+				"%s: err=%d addr=%02x, data=%02x\n",
+				__func__, err, data[0], data[1]);
+			return -EIO;
+		}
+	};
+
+	/* Restart the clock */
+	ctrl = RX8581_REG_CTRL;
+
+	msgs[0].buf = &ctrl;
+	msgs[1].buf = &ctrl;
+
+	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	data[0] = RX8581_REG_CTRL;
+	data[1] = (ctrl & ~(RX8581_CTRL_STOP));
+
+	err = i2c_master_send(client, data, sizeof(data));
+	if (err != sizeof(data)) {
+		dev_err(&client->dev,
+			"%s: err=%d addr=%02x, data=%02x\n",
+			__func__, err, data[0], data[1]);
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
+	struct rtc_device *rtc = NULL;
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
+	if (rtc)
+		rtc_device_unregister(rtc);
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

rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch

