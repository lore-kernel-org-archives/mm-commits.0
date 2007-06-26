From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-m41t80-driver.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:47:43 -0700
Message-ID: <200706260447.l5Q4lhGO018589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbXFZEsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, ab@mycable.de, khali@linux-fr.org, mgreer@mvista.com, wim@iguana.be


The patch titled
     rtc: add rtc-m41t80 driver
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-m41t80-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: add rtc-m41t80 driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This is a new-style i2c driver for ST M41T80 series RTC chip, derived from
works by Alexander Bigga <ab@mycable.de> who wrote the original rtc-m41txx.c
based on drivers/i2c/chips/m41t00.c driver.

This driver supports M41T8[0-4] and M41ST8[457].  The old m41t00 driver
supports M41T00, M41T81 and M41T85(M41ST85).  While the M41T00 chip is now
supported by rtc-ds1307 driver, this driver does not include support for the
chip.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Alexander Bigga <ab@mycable.de>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |   12 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-m41t80.c |  578 +++++++++++++++++++++++++++++++++++++
 include/linux/m41t80.h   |   40 ++
 4 files changed, 631 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-m41t80-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-rtc-m41t80-driver
+++ a/drivers/rtc/Kconfig
@@ -281,6 +281,18 @@ config RTC_DRV_DS1742
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
 
+config RTC_DRV_M41T80
+	tristate "ST M41T80 series RTC"
+	depends on RTC_CLASS && I2C
+	help
+	  If you say Y here you will get support for the
+	  ST M41T80 RTC chips series. Currently following chips are
+	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85
+	  and M41ST87.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m41t80.
+
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
 	depends on RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-add-rtc-m41t80-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-rtc-m41t80-driver
+++ a/drivers/rtc/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
+obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
diff -puN /dev/null drivers/rtc/rtc-m41t80.c
--- /dev/null
+++ a/drivers/rtc/rtc-m41t80.c
@@ -0,0 +1,578 @@
+/*
+ * I2C client/driver for the ST M41T80 family of i2c rtc chips.
+ *
+ * Author: Alexander Bigga <ab@mycable.de>
+ *
+ * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
+ *
+ * 2006 (c) mycable GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/m41t80.h>
+
+#define M41T80_REG_SSEC	0
+#define M41T80_REG_SEC	1
+#define M41T80_REG_MIN	2
+#define M41T80_REG_HOUR	3
+#define M41T80_REG_WDAY	4
+#define M41T80_REG_DAY	5
+#define M41T80_REG_MON	6
+#define M41T80_REG_YEAR	7
+#define M41T80_REG_ALARM_MON	0xa
+#define M41T80_REG_ALARM_DAY	0xb
+#define M41T80_REG_ALARM_HOUR	0xc
+#define M41T80_REG_ALARM_MIN	0xd
+#define M41T80_REG_ALARM_SEC	0xe
+#define M41T80_REG_FLAGS	0xf
+#define M41T80_REG_SQW	0x13
+
+#define M41T80_DATETIME_REG_SIZE	(M41T80_REG_YEAR + 1)
+#define M41T80_ALARM_REG_SIZE	\
+	(M41T80_REG_ALARM_SEC + 1 - M41T80_REG_ALARM_MON)
+
+#define M41T80_SEC_ST		(1 << 7)	/* ST: Stop Bit */
+#define M41T80_ALMON_AFE	(1 << 7)	/* AFE: AF Enable Bit */
+#define M41T80_ALHOUR_HT	(1 << 6)	/* HT: Halt Update Bit */
+#define M41T80_FLAGS_AF		(1 << 6)	/* AF: Alarm Flag Bit */
+#define M41T80_FLAGS_BATT_LOW	(1 << 4)	/* BL: Battery Low Bit */
+
+#define M41T80_FEATURE_HT	(1 << 0)
+#define M41T80_FEATURE_BL	(1 << 1)
+
+#define DRV_VERSION "0.04"
+
+struct m41t80_chip_info {
+	const char *name;
+	u8 features;
+};
+
+static const struct m41t80_chip_info m41t80_chip_info_tbl[] = {
+	{
+		.name		= "m41t80",
+		.features	= 0,
+	},
+	{
+		.name		= "m41t81",
+		.features	= M41T80_FEATURE_HT,
+	},
+	{
+		.name		= "m41t81s",
+		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
+	},
+	{
+		.name		= "m41t82",
+		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
+	},
+	{
+		.name		= "m41t83",
+		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
+	},
+	{
+		.name		= "m41st84",
+		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
+	},
+	{
+		.name		= "m41st85",
+		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
+	},
+	{
+		.name		= "m41st87",
+		.features	= M41T80_FEATURE_HT | M41T80_FEATURE_BL,
+	},
+};
+
+struct m41t80_data {
+	const struct m41t80_chip_info *chip;
+	struct rtc_device *rtc;
+};
+
+static int m41t80_get_datetime(struct i2c_client *client,
+			       struct rtc_time *tm)
+{
+	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= dt_addr,
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+			.buf	= buf + M41T80_REG_SEC,
+		},
+	};
+
+	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
+		dev_err(&client->dev, "read error\n");
+		return -EIO;
+	}
+
+	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
+	tm->tm_min = BCD2BIN(buf[M41T80_REG_MIN] & 0x7f);
+	tm->tm_hour = BCD2BIN(buf[M41T80_REG_HOUR] & 0x3f);
+	tm->tm_mday = BCD2BIN(buf[M41T80_REG_DAY] & 0x3f);
+	tm->tm_wday = buf[M41T80_REG_WDAY] & 0x07;
+	tm->tm_mon = BCD2BIN(buf[M41T80_REG_MON] & 0x1f) - 1;
+
+	/* assume 20YY not 19YY, and ignore the Century Bit */
+	tm->tm_year = BCD2BIN(buf[M41T80_REG_YEAR]) + 100;
+	return 0;
+}
+
+/* Sets the given date and time to the real time clock. */
+static int m41t80_set_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	u8 wbuf[1 + M41T80_DATETIME_REG_SIZE];
+	u8 *buf = &wbuf[1];
+	u8 dt_addr[1] = { M41T80_REG_SEC };
+	struct i2c_msg msgs_in[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= dt_addr,
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+			.buf	= buf + M41T80_REG_SEC,
+		},
+	};
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1 + M41T80_DATETIME_REG_SIZE,
+			.buf	= wbuf,
+		 },
+	};
+
+	/* Read current reg values into buf[1..7] */
+	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+		dev_err(&client->dev, "read error\n");
+		return -EIO;
+	}
+
+	wbuf[0] = 0; /* offset into rtc's regs */
+	/* Merge time-data and register flags into buf[0..7] */
+	buf[M41T80_REG_SSEC] = 0;
+	buf[M41T80_REG_SEC] =
+		BIN2BCD(tm->tm_sec) | (buf[M41T80_REG_SEC] & ~0x7f);
+	buf[M41T80_REG_MIN] =
+		BIN2BCD(tm->tm_min) | (buf[M41T80_REG_MIN] & ~0x7f);
+	buf[M41T80_REG_HOUR] =
+		BIN2BCD(tm->tm_hour) | (buf[M41T80_REG_HOUR] & ~0x3f) ;
+	buf[M41T80_REG_WDAY] =
+		(tm->tm_wday & 0x07) | (buf[M41T80_REG_WDAY] & ~0x07);
+	buf[M41T80_REG_DAY] =
+		BIN2BCD(tm->tm_mday) | (buf[M41T80_REG_DAY] & ~0x3f);
+	buf[M41T80_REG_MON] =
+		BIN2BCD(tm->tm_mon + 1) | (buf[M41T80_REG_MON] & ~0x1f);
+	/* assume 20YY not 19YY */
+	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+
+	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+		dev_err(&client->dev, "write error\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+#if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
+static int m41t80_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct m41t80_data *clientdata = i2c_get_clientdata(client);
+	u8 reg;
+
+	if (clientdata->chip->features & M41T80_FEATURE_BL) {
+		reg = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
+		seq_printf(seq, "battery\t\t: %s\n",
+			   (reg & M41T80_FLAGS_BATT_LOW) ? "exhausted" : "ok");
+	}
+	return 0;
+}
+#else
+#define m41t80_rtc_proc NULL
+#endif
+
+static int m41t80_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return m41t80_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int m41t80_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return m41t80_set_datetime(to_i2c_client(dev), tm);
+}
+
+#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
+static int
+m41t80_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int rc;
+
+	switch (cmd) {
+	case RTC_AIE_OFF:
+	case RTC_AIE_ON:
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
+	if (rc < 0)
+		goto err;
+	switch (cmd) {
+	case RTC_AIE_OFF:
+		rc &= ~M41T80_ALMON_AFE;
+		break;
+	case RTC_AIE_ON:
+		rc |= M41T80_ALMON_AFE;
+		break;
+	}
+	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON, rc) < 0)
+		goto err;
+	return 0;
+err:
+	return -EIO;
+}
+#else
+#define	m41t80_rtc_ioctl NULL
+#endif
+
+static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 wbuf[1 + M41T80_ALARM_REG_SIZE];
+	u8 *buf = &wbuf[1];
+	u8 *reg = buf - M41T80_REG_ALARM_MON;
+	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
+	struct i2c_msg msgs_in[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= dt_addr,
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= M41T80_ALARM_REG_SIZE,
+			.buf	= buf,
+		},
+	};
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1 + M41T80_ALARM_REG_SIZE,
+			.buf	= wbuf,
+		 },
+	};
+
+	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+		dev_err(&client->dev, "read error\n");
+		return -EIO;
+	}
+	reg[M41T80_REG_ALARM_MON] &= ~(0x1f | M41T80_ALMON_AFE);
+	reg[M41T80_REG_ALARM_DAY] = 0;
+	reg[M41T80_REG_ALARM_HOUR] &= ~(0x3f | 0x80);
+	reg[M41T80_REG_ALARM_MIN] = 0;
+	reg[M41T80_REG_ALARM_SEC] = 0;
+
+	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
+	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
+		BIN2BCD(t->time.tm_sec) : 0x80;
+	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
+		BIN2BCD(t->time.tm_min) : 0x80;
+	reg[M41T80_REG_ALARM_HOUR] |= t->time.tm_hour >= 0 ?
+		BIN2BCD(t->time.tm_hour) : 0x80;
+	reg[M41T80_REG_ALARM_DAY] |= t->time.tm_mday >= 0 ?
+		BIN2BCD(t->time.tm_mday) : 0x80;
+	if (t->time.tm_mon >= 0)
+		reg[M41T80_REG_ALARM_MON] |= BIN2BCD(t->time.tm_mon + 1);
+	else
+		reg[M41T80_REG_ALARM_DAY] |= 0x40;
+
+	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+		dev_err(&client->dev, "write error\n");
+		return -EIO;
+	}
+
+	if (t->enabled) {
+		reg[M41T80_REG_ALARM_MON] |= M41T80_ALMON_AFE;
+		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
+					      reg[M41T80_REG_ALARM_MON]) < 0) {
+			dev_err(&client->dev, "write error\n");
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
+	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
+	u8 *reg = buf - M41T80_REG_ALARM_MON;
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= dt_addr,
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= M41T80_ALARM_REG_SIZE + 1,
+			.buf	= buf,
+		},
+	};
+
+	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
+		dev_err(&client->dev, "read error\n");
+		return -EIO;
+	}
+	t->time.tm_sec = -1;
+	t->time.tm_min = -1;
+	t->time.tm_hour = -1;
+	t->time.tm_mday = -1;
+	t->time.tm_mon = -1;
+	if (!(reg[M41T80_REG_ALARM_SEC] & 0x80))
+		t->time.tm_sec = BCD2BIN(reg[M41T80_REG_ALARM_SEC] & 0x7f);
+	if (!(reg[M41T80_REG_ALARM_MIN] & 0x80))
+		t->time.tm_min = BCD2BIN(reg[M41T80_REG_ALARM_MIN] & 0x7f);
+	if (!(reg[M41T80_REG_ALARM_HOUR] & 0x80))
+		t->time.tm_hour = BCD2BIN(reg[M41T80_REG_ALARM_HOUR] & 0x3f);
+	if (!(reg[M41T80_REG_ALARM_DAY] & 0x80))
+		t->time.tm_mday = BCD2BIN(reg[M41T80_REG_ALARM_DAY] & 0x3f);
+	if (!(reg[M41T80_REG_ALARM_DAY] & 0x40))
+		t->time.tm_mon = BCD2BIN(reg[M41T80_REG_ALARM_MON] & 0x1f) - 1;
+	t->time.tm_year = -1;
+	t->time.tm_wday = -1;
+	t->time.tm_yday = -1;
+	t->time.tm_isdst = -1;
+	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
+	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
+	return 0;
+}
+
+static struct rtc_class_ops m41t80_rtc_ops = {
+	.read_time = m41t80_rtc_read_time,
+	.set_time = m41t80_rtc_set_time,
+	.read_alarm = m41t80_rtc_read_alarm,
+	.set_alarm = m41t80_rtc_set_alarm,
+	.proc = m41t80_rtc_proc,
+	.ioctl = m41t80_rtc_ioctl,
+};
+
+#if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)
+static ssize_t m41t80_sysfs_show_flags(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int val;
+
+	val = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
+	if (val < 0)
+		return val;
+	return sprintf(buf, "%#x\n", val);
+}
+static DEVICE_ATTR(flags, S_IRUGO, m41t80_sysfs_show_flags, NULL);
+
+static int m41t80_sysfs_register(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_flags);
+}
+#else
+static int m41t80_sysfs_register(struct device *dev)
+{
+	return 0;
+}
+#endif
+
+/*
+ *****************************************************************************
+ *
+ *	Driver Interface
+ *
+ *****************************************************************************
+ */
+static int m41t80_probe(struct i2c_client *client)
+{
+	int i, rc = 0;
+	struct rtc_device *rtc = NULL;
+	struct rtc_time tm;
+	struct m41t80_platform_data *pdata = client->dev.platform_data;
+	const static struct m41t80_chip_info *chip;
+	struct m41t80_data *clientdata = NULL;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
+				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
+		rc = -ENODEV;
+		goto exit;
+	}
+
+	dev_info(&client->dev,
+		 "chip found, driver version " DRV_VERSION "\n");
+
+	chip = NULL;
+	for (i = 0; i < ARRAY_SIZE(m41t80_chip_info_tbl); i++) {
+		if (!strcmp(m41t80_chip_info_tbl[i].name, client->name)) {
+			chip = &m41t80_chip_info_tbl[i];
+			break;
+		}
+	}
+	if (!chip) {
+		dev_err(&client->dev, "%s is not supported\n", client->name);
+		rc = -ENODEV;
+		goto exit;
+	}
+
+	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
+	if (!clientdata) {
+		rc = -ENOMEM;
+		goto exit;
+	}
+
+	rtc = rtc_device_register(client->name, &client->dev,
+				  &m41t80_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		rc = PTR_ERR(rtc);
+		rtc = NULL;
+		goto exit;
+	}
+
+	clientdata->rtc = rtc;
+	clientdata->chip = chip;
+	i2c_set_clientdata(client, clientdata);
+
+	/* If asked, disable SQW, set SQW frequency & re-enable */
+	if (pdata && pdata->sqw_freq) {
+		rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
+		if (rc < 0)
+			goto sqw_err;
+		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
+					      rc & ~0x40) < 0 ||
+		    i2c_smbus_write_byte_data(client, M41T80_REG_SQW,
+					      pdata->sqw_freq) < 0 ||
+		    i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
+					      rc | 0x40) < 0)
+			goto sqw_err;
+	}
+
+	/* Make sure HT (Halt Update) bit is cleared */
+	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
+	if (rc < 0)
+		goto ht_err;
+
+	if (rc & M41T80_ALHOUR_HT) {
+		if (chip->features & M41T80_FEATURE_HT) {
+			m41t80_get_datetime(client, &tm);
+			dev_info(&client->dev, "HT bit was set!\n");
+			dev_info(&client->dev,
+				 "Power Down at "
+				 "%04i-%02i-%02i %02i:%02i:%02i\n",
+				 tm.tm_year + 1900,
+				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
+				 tm.tm_min, tm.tm_sec);
+		}
+		if (i2c_smbus_write_byte_data(client,
+					      M41T80_REG_ALARM_HOUR,
+					      rc & ~M41T80_ALHOUR_HT) < 0)
+			goto ht_err;
+	}
+
+	/* Make sure ST (stop) bit is cleared */
+	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
+	if (rc < 0)
+		goto st_err;
+
+	if (rc & M41T80_SEC_ST) {
+		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
+					      rc & ~M41T80_SEC_ST) < 0)
+			goto st_err;
+	}
+
+	rc = m41t80_sysfs_register(&client->dev);
+	if (rc)
+		goto exit;
+
+	return 0;
+
+st_err:
+	rc = -EIO;
+	dev_err(&client->dev, "Can't clear ST bit\n");
+	goto exit;
+ht_err:
+	rc = -EIO;
+	dev_err(&client->dev, "Can't clear HT bit\n");
+	goto exit;
+sqw_err:
+	rc = -EIO;
+	dev_err(&client->dev, "Can't set SQW Frequency\n");
+
+exit:
+	if (rtc)
+		rtc_device_unregister(rtc);
+	kfree(clientdata);
+	return rc;
+}
+
+static int m41t80_remove(struct i2c_client *client)
+{
+	struct m41t80_data *clientdata = i2c_get_clientdata(client);
+	struct rtc_device *rtc = clientdata->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+	kfree(clientdata);
+
+	return 0;
+}
+
+static struct i2c_driver m41t80_driver = {
+	.driver = {
+		.name = M41T80_DRV_NAME,
+	},
+	.probe = m41t80_probe,
+	.remove = m41t80_remove,
+};
+
+static int __init m41t80_rtc_init(void)
+{
+	return i2c_add_driver(&m41t80_driver);
+}
+
+static void __exit m41t80_rtc_exit(void)
+{
+	i2c_del_driver(&m41t80_driver);
+}
+
+MODULE_AUTHOR("Alexander Bigga <ab@mycable.de>");
+MODULE_DESCRIPTION("ST Microelectronics M41T80 series RTC I2C Client Driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(m41t80_rtc_init);
+module_exit(m41t80_rtc_exit);
diff -puN /dev/null include/linux/m41t80.h
--- /dev/null
+++ a/include/linux/m41t80.h
@@ -0,0 +1,40 @@
+/*
+ * Definitions for the ST M41T80 family of i2c rtc chips.
+ *
+ * Based on m41t00.h by Mark A. Greer <mgreer@mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _M41T80_H
+#define _M41T80_H
+
+#define	M41T80_DRV_NAME		"m41t80"
+#define	M41T80_I2C_ADDR		0x68
+
+struct m41t80_platform_data {
+	u8	sqw_freq;
+};
+
+/* SQW output disabled, this is default value by power on */
+#define M41T80_SQW_DISABLE	(0)
+
+#define M41T80_SQW_32KHZ	(1<<4)		/* 32.768 KHz */
+#define M41T80_SQW_8KHZ		(2<<4)		/* 8.192 KHz */
+#define M41T80_SQW_4KHZ		(3<<4)		/* 4.096 KHz */
+#define M41T80_SQW_2KHZ		(4<<4)		/* 2.048 KHz */
+#define M41T80_SQW_1KHZ		(5<<4)		/* 1.024 KHz */
+#define M41T80_SQW_512HZ	(6<<4)		/* 512 Hz */
+#define M41T80_SQW_256HZ	(7<<4)		/* 256 Hz */
+#define M41T80_SQW_128HZ	(8<<4)		/* 128 Hz */
+#define M41T80_SQW_64HZ		(9<<4)		/* 64 Hz */
+#define M41T80_SQW_32HZ		(10<<4)		/* 32 Hz */
+#define M41T80_SQW_16HZ		(11<<4)		/* 16 Hz */
+#define M41T80_SQW_8HZ		(12<<4)		/* 8 Hz */
+#define M41T80_SQW_4HZ		(13<<4)		/* 4 Hz */
+#define M41T80_SQW_2HZ		(14<<4)		/* 2 Hz */
+#define M41T80_SQW_1HZ		(15<<4)		/* 1 Hz */
+
+#endif /* _M41T80_H */
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-kbuild.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
rtc-add-rtc-m41t80-driver.patch
rtc-watchdog-support-for-rtc-m41t80-driver.patch
