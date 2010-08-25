From: akpm@linux-foundation.org
Subject: + rtc-add-max8998-rtc-driver.patch added to -mm tree
Date: Wed, 25 Aug 2010 12:19:45 -0700
Message-ID: <201008251919.o7PJJjOX011002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab0HYTV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 15:21:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jy0922.shim@samsung.com, a.zummo@towertech.it, kyungmin.park@samsung.com, mcuos.com@gmail.com, sameo@linux.intel.com


The patch titled
     rtc: add MAX8998 rtc driver
has been added to the -mm tree.  Its filename is
     rtc-add-max8998-rtc-driver.patch

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
Subject: rtc: add MAX8998 rtc driver
From: Joonyoung Shim <jy0922.shim@samsung.com>

This adds support for the RTC provided by the Maxim 8998 chip.  This
driver was tested on a GONI board by using the rtc-test application from
the Documentation/rtc.txt.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/max8998.c               |   24 +-
 drivers/rtc/Kconfig                 |   10 
 drivers/rtc/Makefile                |    1 
 drivers/rtc/rtc-max8998.c           |  300 ++++++++++++++++++++++++++
 include/linux/mfd/max8998-private.h |    6 
 5 files changed, 339 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/max8998.c~rtc-add-max8998-rtc-driver drivers/mfd/max8998.c
--- a/drivers/mfd/max8998.c~rtc-add-max8998-rtc-driver
+++ a/drivers/mfd/max8998.c
@@ -30,10 +30,14 @@
 #include <linux/mfd/max8998.h>
 #include <linux/mfd/max8998-private.h>
 
+#define RTC_I2C_ADDR		(0x0c >> 1)
+
 static struct mfd_cell max8998_devs[] = {
 	{
 		.name = "max8998-pmic",
-	}
+	}, {
+		.name = "max8998-rtc",
+	},
 };
 
 int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
@@ -80,6 +84,21 @@ int max8998_write_reg(struct i2c_client 
 }
 EXPORT_SYMBOL(max8998_write_reg);
 
+int max8998_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+{
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
+	int ret;
+
+	mutex_lock(&max8998->iolock);
+	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
+	mutex_unlock(&max8998->iolock);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(max8998_bulk_write);
+
 int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 {
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
@@ -120,6 +139,9 @@ static int max8998_i2c_probe(struct i2c_
 	}
 	mutex_init(&max8998->iolock);
 
+	max8998->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	i2c_set_clientdata(max8998->rtc, max8998);
+
 	max8998_irq_init(max8998);
 
 	ret = mfd_add_devices(max8998->dev, -1,
diff -puN drivers/rtc/Kconfig~rtc-add-max8998-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-max8998-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -195,6 +195,16 @@ config RTC_DRV_MAX8925
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max8925.
 
+config RTC_DRV_MAX8998
+	tristate "Maxim MAX8998"
+	depends on MFD_MAX8998
+	help
+	  If you say yes here you will get support for the
+	  RTC of Maxim MAX8998 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max8998.
+
 config RTC_DRV_RS5C372
 	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-max8998-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-max8998-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t
 obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
+obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MC13783)	+= rtc-mc13783.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
diff -puN /dev/null drivers/rtc/rtc-max8998.c
--- /dev/null
+++ a/drivers/rtc/rtc-max8998.c
@@ -0,0 +1,300 @@
+/*
+ * RTC driver for Maxim MAX8998
+ *
+ * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Author: Minkyu Kang <mk7.kang@samsung.com>
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max8998.h>
+#include <linux/mfd/max8998-private.h>
+
+#define MAX8998_RTC_SEC			0x00
+#define MAX8998_RTC_MIN			0x01
+#define MAX8998_RTC_HOUR		0x02
+#define MAX8998_RTC_WEEKDAY		0x03
+#define MAX8998_RTC_DATE		0x04
+#define MAX8998_RTC_MONTH		0x05
+#define MAX8998_RTC_YEAR1		0x06
+#define MAX8998_RTC_YEAR2		0x07
+#define MAX8998_ALARM0_SEC		0x08
+#define MAX8998_ALARM0_MIN		0x09
+#define MAX8998_ALARM0_HOUR		0x0a
+#define MAX8998_ALARM0_WEEKDAY		0x0b
+#define MAX8998_ALARM0_DATE		0x0c
+#define MAX8998_ALARM0_MONTH		0x0d
+#define MAX8998_ALARM0_YEAR1		0x0e
+#define MAX8998_ALARM0_YEAR2		0x0f
+#define MAX8998_ALARM1_SEC		0x10
+#define MAX8998_ALARM1_MIN		0x11
+#define MAX8998_ALARM1_HOUR		0x12
+#define MAX8998_ALARM1_WEEKDAY		0x13
+#define MAX8998_ALARM1_DATE		0x14
+#define MAX8998_ALARM1_MONTH		0x15
+#define MAX8998_ALARM1_YEAR1		0x16
+#define MAX8998_ALARM1_YEAR2		0x17
+#define MAX8998_ALARM0_CONF		0x18
+#define MAX8998_ALARM1_CONF		0x19
+#define MAX8998_RTC_STATUS		0x1a
+#define MAX8998_WTSR_SMPL_CNTL		0x1b
+#define MAX8998_TEST			0x1f
+
+#define HOUR_12				(1 << 7)
+#define HOUR_PM				(1 << 5)
+#define ALARM0_STATUS			(1 << 1)
+#define ALARM1_STATUS			(1 << 2)
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_DATE,
+	RTC_MONTH,
+	RTC_YEAR1,
+	RTC_YEAR2,
+};
+
+struct max8998_rtc_info {
+	struct device		*dev;
+	struct max8998_dev	*max8998;
+	struct i2c_client	*rtc;
+	struct rtc_device	*rtc_dev;
+	int irq;
+};
+
+static void max8998_data_to_tm(u8 *data, struct rtc_time *tm)
+{
+	tm->tm_sec = bcd2bin(data[RTC_SEC]);
+	tm->tm_min = bcd2bin(data[RTC_MIN]);
+	if (data[RTC_HOUR] & HOUR_12) {
+		tm->tm_hour = bcd2bin(data[RTC_HOUR] & 0x1f);
+		if (data[RTC_HOUR] & HOUR_PM)
+			tm->tm_hour += 12;
+	} else
+		tm->tm_hour = bcd2bin(data[RTC_HOUR] & 0x3f);
+
+	tm->tm_wday = data[RTC_WEEKDAY] & 0x07;
+	tm->tm_mday = bcd2bin(data[RTC_DATE]);
+	tm->tm_mon = bcd2bin(data[RTC_MONTH]);
+	tm->tm_year = bcd2bin(data[RTC_YEAR1]) + bcd2bin(data[RTC_YEAR2]) * 100;
+	tm->tm_year -= 1900;
+}
+
+static void max8998_tm_to_data(struct rtc_time *tm, u8 *data)
+{
+	data[RTC_SEC] = bin2bcd(tm->tm_sec);
+	data[RTC_MIN] = bin2bcd(tm->tm_min);
+	data[RTC_HOUR] = bin2bcd(tm->tm_hour);
+	data[RTC_WEEKDAY] = tm->tm_wday;
+	data[RTC_DATE] = bin2bcd(tm->tm_mday);
+	data[RTC_MONTH] = bin2bcd(tm->tm_mon);
+	data[RTC_YEAR1] = bin2bcd(tm->tm_year % 100);
+	data[RTC_YEAR2] = bin2bcd((tm->tm_year + 1900) / 100);
+}
+
+static int max8998_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max8998_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[8];
+	int ret;
+
+	ret = max8998_bulk_read(info->rtc, MAX8998_RTC_SEC, 8, data);
+	if (ret < 0)
+		return ret;
+
+	max8998_data_to_tm(data, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int max8998_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max8998_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[8];
+
+	max8998_tm_to_data(tm, data);
+
+	return max8998_bulk_write(info->rtc, MAX8998_RTC_SEC, 8, data);
+}
+
+static int max8998_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max8998_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[8];
+	u8 val;
+	int ret;
+
+	ret = max8998_bulk_read(info->rtc, MAX8998_ALARM0_SEC, 8, data);
+	if (ret < 0)
+		return ret;
+
+	max8998_data_to_tm(data, &alrm->time);
+
+	ret = max8998_read_reg(info->rtc, MAX8998_ALARM0_CONF, &val);
+	if (ret < 0)
+		return ret;
+
+	alrm->enabled = !!val;
+
+	ret = max8998_read_reg(info->rtc, MAX8998_RTC_STATUS, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val & ALARM0_STATUS)
+		alrm->pending = 1;
+	else
+		alrm->pending = 0;
+
+	return 0;
+}
+
+static int max8998_rtc_stop_alarm(struct max8998_rtc_info *info)
+{
+	return max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0);
+}
+
+static int max8998_rtc_start_alarm(struct max8998_rtc_info *info)
+{
+	return max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0x77);
+}
+
+static int max8998_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max8998_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[8];
+	int ret;
+
+	max8998_tm_to_data(&alrm->time, data);
+
+	ret = max8998_rtc_stop_alarm(info);
+	if (ret < 0)
+		return ret;
+
+	ret = max8998_bulk_write(info->rtc, MAX8998_ALARM0_SEC, 8, data);
+	if (ret < 0)
+		return ret;
+
+	if (alrm->enabled)
+		return max8998_rtc_start_alarm(info);
+
+	return 0;
+}
+
+static int max8998_rtc_alarm_irq_enable(struct device *dev,
+					unsigned int enabled)
+{
+	struct max8998_rtc_info *info = dev_get_drvdata(dev);
+
+	if (enabled)
+		return max8998_rtc_start_alarm(info);
+	else
+		return max8998_rtc_stop_alarm(info);
+}
+
+static irqreturn_t max8998_rtc_alarm_irq(int irq, void *data)
+{
+	struct max8998_rtc_info *info = data;
+
+	rtc_update_irq(info->rtc_dev, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops max8998_rtc_ops = {
+	.read_time = max8998_rtc_read_time,
+	.set_time = max8998_rtc_set_time,
+	.read_alarm = max8998_rtc_read_alarm,
+	.set_alarm = max8998_rtc_set_alarm,
+	.alarm_irq_enable = max8998_rtc_alarm_irq_enable,
+};
+
+static int __devinit max8998_rtc_probe(struct platform_device *pdev)
+{
+	struct max8998_dev *max8998 = dev_get_drvdata(pdev->dev.parent);
+	struct max8998_rtc_info *info;
+	int ret;
+
+	info = kzalloc(sizeof(struct max8998_rtc_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->dev = &pdev->dev;
+	info->max8998 = max8998;
+	info->rtc = max8998->rtc;
+	info->irq = max8998->irq_base + MAX8998_IRQ_ALARM0;
+
+	info->rtc_dev = rtc_device_register("max8998-rtc", &pdev->dev,
+			&max8998_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(info->rtc_dev)) {
+		ret = PTR_ERR(info->rtc_dev);
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		goto out_rtc;
+	}
+
+	platform_set_drvdata(pdev, info);
+
+	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
+			"rtc-alarm0", info);
+	if (ret < 0)
+		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
+			info->irq, ret);
+
+	return 0;
+
+out_rtc:
+	kfree(info);
+	return ret;
+}
+
+static int __devexit max8998_rtc_remove(struct platform_device *pdev)
+{
+	struct max8998_rtc_info *info = platform_get_drvdata(pdev);
+
+	if (info) {
+		free_irq(info->irq, info);
+		rtc_device_unregister(info->rtc_dev);
+		kfree(info);
+	}
+
+	return 0;
+}
+
+static struct platform_driver max8998_rtc_driver = {
+	.driver		= {
+		.name	= "max8998-rtc",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= max8998_rtc_probe,
+	.remove		= __devexit_p(max8998_rtc_remove),
+};
+
+static int __init max8998_rtc_init(void)
+{
+	return platform_driver_register(&max8998_rtc_driver);
+}
+module_init(max8998_rtc_init);
+
+static void __exit max8998_rtc_exit(void)
+{
+	platform_driver_unregister(&max8998_rtc_driver);
+}
+module_exit(max8998_rtc_exit);
+
+MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_DESCRIPTION("Maxim MAX8998 RTC driver");
+MODULE_LICENSE("GPL");
diff -puN include/linux/mfd/max8998-private.h~rtc-add-max8998-rtc-driver include/linux/mfd/max8998-private.h
--- a/include/linux/mfd/max8998-private.h~rtc-add-max8998-rtc-driver
+++ a/include/linux/mfd/max8998-private.h
@@ -126,7 +126,8 @@ enum {
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
- * @i2c: i2c client private data
+ * @i2c: i2c client private data for regulator
+ * @rtc: i2c client private data for rtc
  * @iolock: mutex for serializing io access
  * @irqlock: mutex for buslock
  * @irq_base: base IRQ number for max8998, required for IRQs
@@ -138,6 +139,7 @@ enum {
 struct max8998_dev {
 	struct device *dev;
 	struct i2c_client *i2c;
+	struct i2c_client *rtc;
 	struct mutex iolock;
 	struct mutex irqlock;
 
@@ -155,6 +157,8 @@ extern int max8998_read_reg(struct i2c_c
 extern int max8998_bulk_read(struct i2c_client *i2c, u8 reg, int count,
 		u8 *buf);
 extern int max8998_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
+extern int max8998_bulk_write(struct i2c_client *i2c, u8 reg, int count,
+		u8 *buf);
 extern int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
 
 #endif /*  __LINUX_MFD_MAX8998_PRIV_H */
_

Patches currently in -mm which might be from jy0922.shim@samsung.com are

linux-next.patch
mfd-max8998-use-struct-i2c_client-to-argument-on-i2c-operation-functions.patch
mfd-max8998-add-interrupts-support.patch
rtc-add-max8998-rtc-driver.patch

