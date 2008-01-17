From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-the-s-35390a-rtc-chip.patch removed from -mm tree
Date: Thu, 17 Jan 2008 11:05:22 -0800
Message-ID: <200801171905.m0HJ52io007883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYAQTFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 14:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byron.bbradley@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org, timtimred@foonas.org, mm-commits@vger.kernel.org


The patch titled
     rtc: add support for the S-35390A RTC chip
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-the-s-35390a-rtc-chip.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add support for the S-35390A RTC chip
From: Byron Bradley <byron.bbradley@gmail.com>

This adds basic get/set time support for the Seiko Instruments S-35390A. 
This chip communicates using I2C and is used on the QNAP TS-109/TS-209 NAS
devices.

[akpm@linux-foundation.org: use bitrev8()]
Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Tested-by: Tim Ellis <timtimred@foonas.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |    9 +
 drivers/rtc/Makefile      |    1 
 drivers/rtc/rtc-s35390a.c |  296 ++++++++++++++++++++++++++++++++++++
 3 files changed, 306 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-support-for-the-s-35390a-rtc-chip drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-support-for-the-s-35390a-rtc-chip
+++ a/drivers/rtc/Kconfig
@@ -250,6 +250,15 @@ config RTC_DRV_TWL92330
 	  platforms.  The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.
 
+config RTC_DRV_S35390A
+	tristate "Seiko Instruments S-35390A"
+	help
+	  If you say yes here you will get support for the Seiko
+	  Instruments S-35390A.
+
+	  This driver can also be built as a module. If so the module
+	  will be called rtc-s35390a.
+
 endif # I2C
 
 comment "SPI RTC drivers"
diff -puN drivers/rtc/Makefile~rtc-add-support-for-the-s-35390a-rtc-chip drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-support-for-the-s-35390a-rtc-chip
+++ a/drivers/rtc/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_RTC_DRV_PL031)	+= rtc-pl031
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
+obj-$(CONFIG_RTC_DRV_S35390A)	+= rtc-s35390a.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
diff -puN /dev/null drivers/rtc/rtc-s35390a.c
--- /dev/null
+++ a/drivers/rtc/rtc-s35390a.c
@@ -0,0 +1,296 @@
+/*
+ * Seiko Instruments S-35390A RTC Driver
+ *
+ * Copyright (c) 2007 Byron Bradley
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/i2c.h>
+#include <linux/bitrev.h>
+#include <linux/bcd.h>
+
+#define S35390A_CMD_STATUS1	0
+#define S35390A_CMD_STATUS2	1
+#define S35390A_CMD_TIME1	2
+
+#define S35390A_BYTE_YEAR	0
+#define S35390A_BYTE_MONTH	1
+#define S35390A_BYTE_DAY	2
+#define S35390A_BYTE_WDAY	3
+#define S35390A_BYTE_HOURS	4
+#define S35390A_BYTE_MINS	5
+#define S35390A_BYTE_SECS	6
+
+#define S35390A_FLAG_POC	0x01
+#define S35390A_FLAG_BLD	0x02
+#define S35390A_FLAG_24H	0x40
+#define S35390A_FLAG_RESET	0x80
+#define S35390A_FLAG_TEST	0x01
+
+struct s35390a {
+	struct i2c_client *client;
+	struct rtc_device *rtc;
+	int twentyfourhour;
+};
+
+static int s35390a_set_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+{
+	struct i2c_client *client = s35390a->client;
+	struct i2c_msg msg[] = {
+		{ client->addr | reg, 0, len, buf },
+	};
+
+	/* Only write to the writable bits in the status1 register */
+	if (reg == S35390A_CMD_STATUS1)
+		buf[0] &= 0xf;
+
+	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int s35390a_get_reg(struct s35390a *s35390a, int reg, char *buf, int len)
+{
+	struct i2c_client *client = s35390a->client;
+	struct i2c_msg msg[] = {
+		{ client->addr | reg, I2C_M_RD, len, buf },
+	};
+
+	if ((i2c_transfer(client->adapter, msg, 1)) != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int s35390a_reset(struct s35390a *s35390a)
+{
+	char buf[1];
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf)) < 0)
+		return -EIO;
+
+	if (!(buf[0] & (S35390A_FLAG_POC | S35390A_FLAG_BLD)))
+		return 0;
+
+	buf[0] |= S35390A_FLAG_RESET;
+	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf));
+}
+
+static int s35390a_disable_test_mode(struct s35390a *s35390a)
+{
+	char buf[1];
+
+	if (s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf)) < 0)
+		return -EIO;
+
+	if (!(buf[0] & S35390A_FLAG_TEST))
+		return 0;
+
+	buf[0] &= ~S35390A_FLAG_TEST;
+	return s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, buf, sizeof(buf));
+}
+
+static char s35390a_hr2reg(struct s35390a *s35390a, int hour)
+{
+	if (s35390a->twentyfourhour)
+		return BIN2BCD(hour);
+
+	if (hour < 12)
+		return BIN2BCD(hour);
+
+	return 0x40 | BIN2BCD(hour - 12);
+}
+
+static int s35390a_reg2hr(struct s35390a *s35390a, char reg)
+{
+	unsigned hour;
+
+	if (s35390a->twentyfourhour)
+		return BCD2BIN(reg & 0x3f);
+
+	hour = BCD2BIN(reg & 0x3f);
+	if (reg & 0x40)
+		hour += 12;
+
+	return hour;
+}
+
+static int s35390a_set_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	struct s35390a	*s35390a = i2c_get_clientdata(client);
+	int i, err;
+	char buf[7];
+
+	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d mday=%d, "
+		"mon=%d, year=%d, wday=%d\n", __FUNCTION__, tm->tm_sec,
+		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
+		tm->tm_wday);
+
+	buf[S35390A_BYTE_YEAR] = BIN2BCD(tm->tm_year - 100);
+	buf[S35390A_BYTE_MONTH] = BIN2BCD(tm->tm_mon + 1);
+	buf[S35390A_BYTE_DAY] = BIN2BCD(tm->tm_mday);
+	buf[S35390A_BYTE_WDAY] = BIN2BCD(tm->tm_wday);
+	buf[S35390A_BYTE_HOURS] = s35390a_hr2reg(s35390a, tm->tm_hour);
+	buf[S35390A_BYTE_MINS] = BIN2BCD(tm->tm_min);
+	buf[S35390A_BYTE_SECS] = BIN2BCD(tm->tm_sec);
+
+	/* This chip expects the bits of each byte to be in reverse order */
+	for (i = 0; i < 7; ++i)
+		buf[i] = bitrev8(buf[i]);
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
+
+	return err;
+}
+
+static int s35390a_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[7];
+	int i, err;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
+	if (err < 0)
+		return err;
+
+	/* This chip returns the bits of each byte in reverse order */
+	for (i = 0; i < 7; ++i)
+		buf[i] = bitrev8(buf[i]);
+
+	tm->tm_sec = BCD2BIN(buf[S35390A_BYTE_SECS]);
+	tm->tm_min = BCD2BIN(buf[S35390A_BYTE_MINS]);
+	tm->tm_hour = s35390a_reg2hr(s35390a, buf[S35390A_BYTE_HOURS]);
+	tm->tm_wday = BCD2BIN(buf[S35390A_BYTE_WDAY]);
+	tm->tm_mday = BCD2BIN(buf[S35390A_BYTE_DAY]);
+	tm->tm_mon = BCD2BIN(buf[S35390A_BYTE_MONTH]) - 1;
+	tm->tm_year = BCD2BIN(buf[S35390A_BYTE_YEAR]) + 100;
+
+	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, mday=%d, "
+		"mon=%d, year=%d, wday=%d\n", __FUNCTION__, tm->tm_sec,
+		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
+		tm->tm_wday);
+
+	return rtc_valid_tm(tm);
+}
+
+static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return s35390a_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int s35390a_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return s35390a_set_datetime(to_i2c_client(dev), tm);
+}
+
+static const struct rtc_class_ops s35390a_rtc_ops = {
+	.read_time	= s35390a_rtc_read_time,
+	.set_time	= s35390a_rtc_set_time,
+};
+
+static struct i2c_driver s35390a_driver;
+
+static int s35390a_probe(struct i2c_client *client)
+{
+	int err = 0;
+	struct s35390a *s35390a;
+	struct rtc_time tm;
+	char buf[1];
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		err = -ENODEV;
+		goto exit;
+	}
+
+	s35390a = kzalloc(sizeof(struct s35390a), GFP_KERNEL);
+	if (!s35390a) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	s35390a->client = client;
+	i2c_set_clientdata(client, s35390a);
+
+	err = s35390a_disable_test_mode(s35390a);
+	if (err < 0) {
+		dev_err(&client->dev, "error disabling test mode\n");
+		goto exit_kfree;
+	}
+
+	err = s35390a_reset(s35390a);
+	if (err < 0) {
+		dev_err(&client->dev, "error resetting chip\n");
+		goto exit_kfree;
+	}
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, buf, sizeof(buf));
+	if (err < 0) {
+		dev_err(&client->dev, "error checking 12/24 hour mode\n");
+		goto exit_kfree;
+	}
+	if (buf[0] & S35390A_FLAG_24H)
+		s35390a->twentyfourhour = 1;
+	else
+		s35390a->twentyfourhour = 0;
+
+	if (s35390a_get_datetime(client, &tm) < 0)
+		dev_warn(&client->dev, "clock needs to be set\n");
+
+	dev_info(&client->dev, "S35390A found\n");
+
+	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
+				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(s35390a->rtc)) {
+		err = PTR_ERR(s35390a->rtc);
+		goto exit_kfree;
+	}
+	return 0;
+
+exit_kfree:
+	kfree(s35390a);
+
+exit:
+	return err;
+}
+
+static int s35390a_remove(struct i2c_client *client)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+
+	rtc_device_unregister(s35390a->rtc);
+	kfree(s35390a);
+	return 0;
+}
+
+static struct i2c_driver s35390a_driver = {
+	.driver		= {
+		.name	= "rtc-s35390a",
+	},
+	.probe		= s35390a_probe,
+	.remove		= s35390a_remove,
+};
+
+static int __init s35390a_rtc_init(void)
+{
+	return i2c_add_driver(&s35390a_driver);
+}
+
+static void __exit s35390a_rtc_exit(void)
+{
+	i2c_del_driver(&s35390a_driver);
+}
+
+MODULE_AUTHOR("Byron Bradley <byron.bbradley@gmail.com>");
+MODULE_DESCRIPTION("S35390A RTC driver");
+MODULE_LICENSE("GPL");
+
+module_init(s35390a_rtc_init);
+module_exit(s35390a_rtc_exit);
_

Patches currently in -mm which might be from byron.bbradley@gmail.com are

git-arm.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update2.patch
