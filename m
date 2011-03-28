From: akpm@linux-foundation.org
Subject: + rtc-add-em3027-rtc-driver.patch added to -mm tree
Date: Mon, 28 Mar 2011 16:05:49 -0700
Message-ID: <201103282305.p2SN5nFJ003106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab1C1XIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 19:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il, a.zummo@towertech.it


The patch titled
     rtc: add EM3027 rtc driver
has been added to the -mm tree.  Its filename is
     rtc-add-em3027-rtc-driver.patch

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
Subject: rtc: add EM3027 rtc driver
From: Mike Rapoport <mike@compulab.co.il>

Add support for EM Microelectronic EM3027 RTC chip.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    9 ++
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-em3027.c |  161 +++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-em3027-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-em3027-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -354,6 +354,15 @@ config RTC_DRV_RX8025
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-rx8025.
 
+config RTC_DRV_EM3027
+	tristate "EM Microelectronic EM3027"
+	help
+	  If you say yes here you get support for the EM
+	  Microelectronic EM3027 RTC chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-em3027.
+
 endif # I2C
 
 comment "SPI RTC drivers"
diff -puN drivers/rtc/Makefile~rtc-add-em3027-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-em3027-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_RTC_DRV_DS1742)	+= rtc-ds17
 obj-$(CONFIG_RTC_DRV_DS3232)	+= rtc-ds3232.o
 obj-$(CONFIG_RTC_DRV_DS3234)	+= rtc-ds3234.o
 obj-$(CONFIG_RTC_DRV_EFI)	+= rtc-efi.o
+obj-$(CONFIG_RTC_DRV_EM3027)	+= rtc-em3027.o
 obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
diff -puN /dev/null drivers/rtc/rtc-em3027.c
--- /dev/null
+++ a/drivers/rtc/rtc-em3027.c
@@ -0,0 +1,161 @@
+/*
+ * An rtc/i2c driver for the EM Microelectronic EM3027
+ * Copyright 2011 CompuLab, Ltd.
+ *
+ * Author: Mike Rapoport <mike@compulab.co.il>
+ *
+ * Based on rtc-ds1672.c by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+
+/* Registers */
+#define EM3027_REG_ON_OFF_CTRL	0x00
+#define EM3027_REG_IRQ_CTRL	0x01
+#define EM3027_REG_IRQ_FLAGS	0x02
+#define EM3027_REG_STATUS	0x03
+#define EM3027_REG_RST_CTRL	0x04
+
+#define EM3027_REG_WATCH_SEC	0x08
+#define EM3027_REG_WATCH_MIN	0x09
+#define EM3027_REG_WATCH_HOUR	0x0a
+#define EM3027_REG_WATCH_DATE	0x0b
+#define EM3027_REG_WATCH_DAY	0x0c
+#define EM3027_REG_WATCH_MON	0x0d
+#define EM3027_REG_WATCH_YEAR	0x0e
+
+#define EM3027_REG_ALARM_SEC	0x10
+#define EM3027_REG_ALARM_MIN	0x11
+#define EM3027_REG_ALARM_HOUR	0x12
+#define EM3027_REG_ALARM_DATE	0x13
+#define EM3027_REG_ALARM_DAY	0x14
+#define EM3027_REG_ALARM_MON	0x15
+#define EM3027_REG_ALARM_YEAR	0x16
+
+static struct i2c_driver em3027_driver;
+
+static int em3027_get_time(struct device *dev, struct rtc_time *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	unsigned char addr = EM3027_REG_WATCH_SEC;
+	unsigned char buf[7];
+
+	struct i2c_msg msgs[] = {
+		{client->addr, 0, 1, &addr},		/* setup read addr */
+		{client->addr, I2C_M_RD, 7, buf},	/* read time/date */
+	};
+
+	/* read time/date registers */
+	if ((i2c_transfer(client->adapter, &msgs[0], 2)) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	tm->tm_sec	= bcd2bin(buf[0]);
+	tm->tm_min	= bcd2bin(buf[1]);
+	tm->tm_hour	= bcd2bin(buf[2]);
+	tm->tm_mday	= bcd2bin(buf[3]);
+	tm->tm_wday	= bcd2bin(buf[4]);
+	tm->tm_mon	= bcd2bin(buf[5]);
+	tm->tm_year	= bcd2bin(buf[6]) + 100;
+
+	return 0;
+}
+
+static int em3027_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned char buf[8];
+
+	struct i2c_msg msg = {
+		client->addr, 0, 8, buf,	/* write time/date */
+	};
+
+	buf[0] = EM3027_REG_WATCH_SEC;
+	buf[1] = bin2bcd(tm->tm_sec);
+	buf[2] = bin2bcd(tm->tm_min);
+	buf[3] = bin2bcd(tm->tm_hour);
+	buf[4] = bin2bcd(tm->tm_mday);
+	buf[5] = bin2bcd(tm->tm_wday);
+	buf[6] = bin2bcd(tm->tm_mon);
+	buf[7] = bin2bcd(tm->tm_year % 100);
+
+	/* write time/date registers */
+	if ((i2c_transfer(client->adapter, &msg, 1)) != 1) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static const struct rtc_class_ops em3027_rtc_ops = {
+	.read_time = em3027_get_time,
+	.set_time = em3027_set_time,
+};
+
+static int em3027_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct rtc_device *rtc;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	rtc = rtc_device_register(em3027_driver.driver.name, &client->dev,
+				  &em3027_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	i2c_set_clientdata(client, rtc);
+
+	return 0;
+}
+
+static int em3027_remove(struct i2c_client *client)
+{
+	struct rtc_device *rtc = i2c_get_clientdata(client);
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	return 0;
+}
+
+static struct i2c_device_id em3027_id[] = {
+	{ "em3027", 0 },
+	{ }
+};
+
+static struct i2c_driver em3027_driver = {
+	.driver = {
+		   .name = "rtc-em3027",
+	},
+	.probe = &em3027_probe,
+	.remove = &em3027_remove,
+	.id_table = em3027_id,
+};
+
+static int __init em3027_init(void)
+{
+	return i2c_add_driver(&em3027_driver);
+}
+
+static void __exit em3027_exit(void)
+{
+	i2c_del_driver(&em3027_driver);
+}
+
+MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
+MODULE_DESCRIPTION("EM Microelectronic EM3027 RTC driver");
+MODULE_LICENSE("GPL");
+
+module_init(em3027_init);
+module_exit(em3027_exit);
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch
rtc-add-em3027-rtc-driver.patch

