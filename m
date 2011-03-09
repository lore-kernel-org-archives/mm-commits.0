From: akpm@linux-foundation.org
Subject: + rtc-driver-for-pt7c4338-chip.patch added to -mm tree
Date: Tue, 08 Mar 2011 16:31:17 -0800
Message-ID: <201103090031.p290VJhQ003771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756820Ab1CIAbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2011 19:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Priyanka.Jain@freescale.com, a.zummo@towertech.it, benh@kernel.crashing.org, galak@gate.crashing.org


The patch titled
     rtc: driver for PT7C4338 chip
has been added to the -mm tree.  Its filename is
     rtc-driver-for-pt7c4338-chip.patch

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
Subject: rtc: driver for PT7C4338 chip
From: Priyanka Jain <Priyanka.Jain@freescale.com>

The PT7C4338 chip is being manufactured by Pericom Technology Inc.  It is
a serial real-time clock which provides:

1) Low-power clock/calendar.
2) Programmable square-wave output.

It has 56 bytes of nonvolatile RAM.

The PT7C4338 RTC driver is verified on the Freescale P1010RDB.

Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |    9 +
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-pt7c4338.c |  215 +++++++++++++++++++++++++++++++++++
 3 files changed, 225 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-driver-for-pt7c4338-chip drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-driver-for-pt7c4338-chip
+++ a/drivers/rtc/Kconfig
@@ -354,6 +354,15 @@ config RTC_DRV_RX8025
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-rx8025.
 
+config RTC_DRV_PT7C4338
+	tristate "Pericom Technology Inc. PT7C4338 RTC"
+	help
+	  If you say yes here you get support for the Pericom Technology
+	  Inc. PT7C4338 RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-pt7c4338.
+
 endif # I2C
 
 comment "SPI RTC drivers"
diff -puN drivers/rtc/Makefile~rtc-driver-for-pt7c4338-chip drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-driver-for-pt7c4338-chip
+++ a/drivers/rtc/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pc
 obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
 obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031.o
 obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
+obj-$(CONFIG_RTC_DRV_PT7C4338)	+= rtc-pt7c4338.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
diff -puN /dev/null drivers/rtc/rtc-pt7c4338.c
--- /dev/null
+++ a/drivers/rtc/rtc-pt7c4338.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright 2010 Freescale Semiconductor, Inc.
+ *
+ * Author:	Priyanka Jain <Priyanka.Jain@freescale.com>
+ *
+ * See file CREDITS for list of people who contributed to this
+ * project.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+/*
+ * This file provides Date & Time support (no alarms) for PT7C4338 chip.
+ *
+ * This file is based on drivers/rtc/rtc-ds1307.c
+ *
+ * PT7C4338 chip is manufactured by Pericom Technology Inc.
+ * It is a serial real-time clock which provides
+ * 1)Low-power clock/calendar.
+ * 2)Programmable square-wave output.
+ * It has 56 bytes of nonvolatile RAM.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+
+/* RTC register addresses */
+#define PT7C4338_REG_SECONDS          0x00
+#define PT7C4338_REG_MINUTES          0x01
+#define PT7C4338_REG_HOURS            0x02
+#define PT7C4338_REG_AMPM             0x02
+#define PT7C4338_REG_DAY              0x03
+#define PT7C4338_REG_DATE             0x04
+#define PT7C4338_REG_MONTH            0x05
+#define PT7C4338_REG_YEAR             0x06
+#define PT7C4338_REG_CTRL_STAT        0x07
+
+/* RTC second register address bit */
+#define PT7C4338_SEC_BIT_CH           0x80	/*Clock Halt (in Register 0)*/
+
+/* RTC control and status register bits */
+#define PT7C4338_CTRL_STAT_BIT_RS0    0x1	/*Rate select 0*/
+#define PT7C4338_CTRL_STAT_BIT_RS1    0x2	/*Rate select 1*/
+#define PT7C4338_CTRL_STAT_BIT_SQWE   0x10	/*Square Wave Enable*/
+#define PT7C4338_CTRL_STAT_BIT_OSF    0x20	/*Oscillator Stop Flag*/
+#define PT7C4338_CTRL_STAT_BIT_OUT    0x80	/*Output Level Control*/
+
+static const struct i2c_device_id pt7c4338_id[] = {
+	{ "pt7c4338", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pt7c4338_id);
+
+struct pt7c4338{
+	struct i2c_client *client;
+	struct rtc_device *rtc;
+};
+
+static int pt7c4338_read_time(struct device *dev, struct rtc_time *time)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+	u8 buf[7];
+	u8 year, month, day, hour, minute, second;
+	u8 week, twelve_hr, am_pm;
+
+	ret = i2c_smbus_read_i2c_block_data(client,
+			PT7C4338_REG_SECONDS, 7, buf);
+	if (ret < 0)
+		return ret;
+	if (ret < 7)
+		return -EIO;
+
+	second = buf[0];
+	minute = buf[1];
+	hour = buf[2];
+	week = buf[3];
+	day = buf[4];
+	month = buf[5];
+	year = buf[6];
+
+	/* Extract additional information for AM/PM */
+	twelve_hr = hour & 0x40;
+	am_pm = hour & 0x20;
+
+	/* Write to rtc_time structure */
+	time->tm_sec = bcd2bin(second & 0x7f);
+	time->tm_min = bcd2bin(minute & 0x7f);
+	if (twelve_hr) {
+		/* Convert to 24 hr */
+		if (am_pm)
+			time->tm_hour = bcd2bin(hour & 0x10) + 12;
+		else
+			time->tm_hour = bcd2bin(hour & 0xBF);
+	} else {
+		time->tm_hour = bcd2bin(hour);
+	}
+
+	time->tm_wday = bcd2bin(week & 0x07) - 1;
+	time->tm_mday = bcd2bin(day & 0x3f);
+	time->tm_mon = bcd2bin(month & 0x1F) - 1;
+	/* assume 20YY not 19YY */
+	time->tm_year = bcd2bin(year) + 100;
+
+	return 0;
+}
+
+static int pt7c4338_set_time(struct device *dev, struct rtc_time *time)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 buf[7];
+
+	/* Extract time from rtc_time and load into pt7c4338*/
+	buf[0] = bin2bcd(time->tm_sec);
+	buf[1] = bin2bcd(time->tm_min);
+	buf[2] = bin2bcd(time->tm_hour);
+	buf[3] = bin2bcd(time->tm_wday + 1); /* Day of the week */
+	buf[4] = bin2bcd(time->tm_mday); /* Date */
+	buf[5] = bin2bcd(time->tm_mon + 1);
+
+	/* assume 20YY not 19YY */
+	if (time->tm_year >= 100)
+		buf[6] = bin2bcd(time->tm_year - 100);
+	else
+		buf[6] = bin2bcd(time->tm_year);
+
+	return i2c_smbus_write_i2c_block_data(client,
+					PT7C4338_REG_SECONDS, 7, buf);
+}
+
+static const struct rtc_class_ops pt7c4338_rtc_ops = {
+	.read_time = pt7c4338_read_time,
+	.set_time = pt7c4338_set_time,
+};
+
+static int pt7c4338_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct pt7c4338 *pt7c4338;
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	int ret;
+
+	pt7c4338 = kzalloc(sizeof(struct pt7c4338), GFP_KERNEL);
+	if (!pt7c4338)
+		return -ENOMEM;
+
+	pt7c4338->client = client;
+	i2c_set_clientdata(client, pt7c4338);
+	pt7c4338->rtc = rtc_device_register(client->name, &client->dev,
+					&pt7c4338_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pt7c4338->rtc)) {
+		ret = PTR_ERR(pt7c4338->rtc);
+		dev_err(&client->dev, "unable to register the class device\n");
+		goto out_free;
+	}
+
+	return 0;
+out_free:
+	i2c_set_clientdata(client, NULL);
+	kfree(pt7c4338);
+	return ret;
+}
+
+static int __devexit pt7c4338_remove(struct i2c_client *client)
+{
+	struct pt7c4338 *pt7c4338 = i2c_get_clientdata(client);
+
+	rtc_device_unregister(pt7c4338->rtc);
+	i2c_set_clientdata(client, NULL);
+	kfree(pt7c4338);
+	return 0;
+}
+
+static struct i2c_driver pt7c4338_driver = {
+	.driver = {
+		.name = "rtc-pt7c4338",
+		.owner = THIS_MODULE,
+	},
+	.probe = pt7c4338_probe,
+	.remove = __devexit_p(pt7c4338_remove),
+	.id_table = pt7c4338_id,
+};
+
+static int __init pt7c4338_init(void)
+{
+	return i2c_add_driver(&pt7c4338_driver);
+}
+
+static void __exit pt7c4338_exit(void)
+{
+	i2c_del_driver(&pt7c4338_driver);
+}
+
+module_init(pt7c4338_init);
+module_exit(pt7c4338_exit);
+
+MODULE_AUTHOR("Priyanka Jain <Priyanka.Jain@freescale.com>");
+MODULE_DESCRIPTION("pericom Technology Inc. PT7C4338 RTC Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from Priyanka.Jain@freescale.com are

rtc-driver-for-pt7c4338-chip.patch
rtc-driver-for-pt7c4338-chip-fix.patch

