From: akpm@linux-foundation.org
Subject: + rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch added to -mm tree
Date: Fri, 12 Sep 2014 15:13:50 -0700
Message-ID: <5413701e.G0pG3yGGiAHizzSk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaILWNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 18:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, a.zummo@towertech.it, dianders@chromium.org, k.kozlowski@samsung.com, olof@lixom.net, sjg@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add driver for Maxim 77802 PMIC Real-Time-Clock
has been added to the -mm tree.  Its filename is
     rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: rtc: add driver for Maxim 77802 PMIC Real-Time-Clock

The MAX7802 PMIC has a Real-Time-Clock (RTC) with two alarms.  This patch
adds support for the RTC and is based on a driver added by Simon Glass to
the Chrome OS kernel 3.8 tree.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Olof Johansson <olof@lixom.net>
Cc: Simon Glass <sjg@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |   10 
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-max77802.c |  513 +++++++++++++++++++++++++++++++++++
 3 files changed, 524 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-driver-for-maxim-77802-pmic-real-time-clock drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-driver-for-maxim-77802-pmic-real-time-clock
+++ a/drivers/rtc/Kconfig
@@ -298,6 +298,16 @@ config RTC_DRV_RK808
 	  This driver can also be built as a module. If so, the module
 	  will be called rk808-rtc.
 
+config RTC_DRV_MAX77802
+	tristate "Maxim 77802 RTC"
+	depends on MFD_MAX77686
+	help
+	  If you say yes here you will get support for the
+	  RTC of Maxim MAX77802 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max77802.
+
 config RTC_DRV_RS5C372
 	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-driver-for-maxim-77802-pmic-real-time-clock drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-driver-for-maxim-77802-pmic-real-time-clock
+++ a/drivers/rtc/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max
 obj-$(CONFIG_RTC_DRV_MAX8997)	+= rtc-max8997.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
+obj-$(CONFIG_RTC_DRV_MAX77802)  += rtc-max77802.o
 obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
 obj-$(CONFIG_RTC_DRV_MCP795)	+= rtc-mcp795.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
diff -puN /dev/null drivers/rtc/rtc-max77802.c
--- /dev/null
+++ a/drivers/rtc/rtc-max77802.c
@@ -0,0 +1,513 @@
+/*
+ * RTC driver for Maxim MAX77802
+ *
+ * Copyright (C) 2013 Google, Inc
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ *
+ *  based on rtc-max8997.c
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/rtc.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/irqdomain.h>
+#include <linux/regmap.h>
+
+/* RTC Control Register */
+#define BCD_EN_SHIFT			0
+#define BCD_EN_MASK			(1 << BCD_EN_SHIFT)
+#define MODEL24_SHIFT			1
+#define MODEL24_MASK			(1 << MODEL24_SHIFT)
+/* RTC Update Register1 */
+#define RTC_UDR_SHIFT			0
+#define RTC_UDR_MASK			(1 << RTC_UDR_SHIFT)
+#define RTC_RBUDR_SHIFT			4
+#define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
+/* RTC Hour register */
+#define HOUR_PM_SHIFT			6
+#define HOUR_PM_MASK			(1 << HOUR_PM_SHIFT)
+/* RTC Alarm Enable */
+#define ALARM_ENABLE_SHIFT		7
+#define ALARM_ENABLE_MASK		(1 << ALARM_ENABLE_SHIFT)
+
+/* For the RTCAE1 register, we write this value to enable the alarm */
+#define ALARM_ENABLE_VALUE		0x77
+
+#define MAX77802_RTC_UPDATE_DELAY_US	200
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_MONTH,
+	RTC_YEAR,
+	RTC_DATE,
+	RTC_NR_TIME
+};
+
+struct max77802_rtc_info {
+	struct device		*dev;
+	struct max77686_dev	*max77802;
+	struct i2c_client	*rtc;
+	struct rtc_device	*rtc_dev;
+	struct mutex		lock;
+
+	struct regmap		*regmap;
+
+	int virq;
+	int rtc_24hr_mode;
+};
+
+enum MAX77802_RTC_OP {
+	MAX77802_RTC_WRITE,
+	MAX77802_RTC_READ,
+};
+
+static inline int max77802_rtc_calculate_wday(u8 shifted)
+{
+	int counter = -1;
+
+	while (shifted) {
+		shifted >>= 1;
+		counter++;
+	}
+
+	return counter;
+}
+
+static void max77802_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
+				   int rtc_24hr_mode)
+{
+	tm->tm_sec = data[RTC_SEC] & 0xff;
+	tm->tm_min = data[RTC_MIN] & 0xff;
+	if (rtc_24hr_mode)
+		tm->tm_hour = data[RTC_HOUR] & 0x1f;
+	else {
+		tm->tm_hour = data[RTC_HOUR] & 0x0f;
+		if (data[RTC_HOUR] & HOUR_PM_MASK)
+			tm->tm_hour += 12;
+	}
+
+	tm->tm_wday = max77802_rtc_calculate_wday(data[RTC_WEEKDAY] & 0xff);
+	tm->tm_mday = data[RTC_DATE] & 0x1f;
+	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
+
+	tm->tm_year = data[RTC_YEAR] & 0xff;
+	tm->tm_yday = 0;
+	tm->tm_isdst = 0;
+}
+
+static int max77802_rtc_tm_to_data(struct rtc_time *tm, u8 *data)
+{
+	data[RTC_SEC] = tm->tm_sec;
+	data[RTC_MIN] = tm->tm_min;
+	data[RTC_HOUR] = tm->tm_hour;
+	data[RTC_WEEKDAY] = 1 << tm->tm_wday;
+	data[RTC_DATE] = tm->tm_mday;
+	data[RTC_MONTH] = tm->tm_mon + 1;
+	data[RTC_YEAR] = tm->tm_year;
+
+	return 0;
+}
+
+static int max77802_rtc_update(struct max77802_rtc_info *info,
+	enum MAX77802_RTC_OP op)
+{
+	int ret;
+	unsigned int data;
+
+	if (op == MAX77802_RTC_WRITE)
+		data = 1 << RTC_UDR_SHIFT;
+	else
+		data = 1 << RTC_RBUDR_SHIFT;
+
+	ret = regmap_update_bits(info->max77802->regmap,
+				 MAX77802_RTC_UPDATE0, data, data);
+	if (ret < 0)
+		dev_err(info->dev, "%s: fail to write update reg(ret=%d, data=0x%x)\n",
+				__func__, ret, data);
+	else {
+		/* Minimum delay required before RTC update. */
+		usleep_range(MAX77802_RTC_UPDATE_DELAY_US,
+			     MAX77802_RTC_UPDATE_DELAY_US * 2);
+	}
+
+	return ret;
+}
+
+static int max77802_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max77802_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_read(info->max77802->regmap,
+				MAX77802_RTC_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read time reg(%d)\n", __func__,
+			ret);
+		goto out;
+	}
+
+	max77802_rtc_data_to_tm(data, tm, info->rtc_24hr_mode);
+
+	ret = rtc_valid_tm(tm);
+
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max77802_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max77802_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	ret = max77802_rtc_tm_to_data(tm, data);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&info->lock);
+
+	ret = regmap_bulk_write(info->max77802->regmap,
+				 MAX77802_RTC_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
+			ret);
+		goto out;
+	}
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
+
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max77802_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max77802_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	unsigned int val;
+	int ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_read(info->max77802->regmap,
+				 MAX77802_ALARM1_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
+				__func__, __LINE__, ret);
+		goto out;
+	}
+
+	max77802_rtc_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
+
+	alrm->enabled = 0;
+	ret = regmap_read(info->max77802->regmap,
+			  MAX77802_RTC_AE1, &val);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read alarm enable(%d)\n",
+			__func__, __LINE__, ret);
+		goto out;
+	}
+	if (val)
+		alrm->enabled = 1;
+
+	alrm->pending = 0;
+	ret = regmap_read(info->max77802->regmap, MAX77802_REG_STATUS2, &val);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read status2 reg(%d)\n",
+				__func__, __LINE__, ret);
+		goto out;
+	}
+
+	if (val & (1 << 2)) /* RTCA1 */
+		alrm->pending = 1;
+
+out:
+	mutex_unlock(&info->lock);
+	return 0;
+}
+
+static int max77802_rtc_stop_alarm(struct max77802_rtc_info *info)
+{
+	int ret;
+
+	if (!mutex_is_locked(&info->lock))
+		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_write(info->max77802->regmap,
+			   MAX77802_RTC_AE1, 0);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+			__func__, ret);
+		goto out;
+	}
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
+out:
+	return ret;
+}
+
+static int max77802_rtc_start_alarm(struct max77802_rtc_info *info)
+{
+	int ret;
+
+	if (!mutex_is_locked(&info->lock))
+		dev_warn(info->dev, "%s: should have mutex locked\n",
+			 __func__);
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_write(info->max77802->regmap,
+				   MAX77802_RTC_AE1,
+				   ALARM_ENABLE_VALUE);
+
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
+out:
+	return ret;
+}
+
+static int max77802_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max77802_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	ret = max77802_rtc_tm_to_data(&alrm->time, data);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max77802_rtc_stop_alarm(info);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_write(info->max77802->regmap,
+				 MAX77802_ALARM1_SEC, data, RTC_NR_TIME);
+
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
+	if (ret < 0)
+		goto out;
+
+	if (alrm->enabled)
+		ret = max77802_rtc_start_alarm(info);
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max77802_rtc_alarm_irq_enable(struct device *dev,
+					 unsigned int enabled)
+{
+	struct max77802_rtc_info *info = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&info->lock);
+	if (enabled)
+		ret = max77802_rtc_start_alarm(info);
+	else
+		ret = max77802_rtc_stop_alarm(info);
+	mutex_unlock(&info->lock);
+
+	return ret;
+}
+
+static irqreturn_t max77802_rtc_alarm_irq(int irq, void *data)
+{
+	struct max77802_rtc_info *info = data;
+
+	dev_dbg(info->dev, "%s:irq(%d)\n", __func__, irq);
+
+	rtc_update_irq(info->rtc_dev, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops max77802_rtc_ops = {
+	.read_time = max77802_rtc_read_time,
+	.set_time = max77802_rtc_set_time,
+	.read_alarm = max77802_rtc_read_alarm,
+	.set_alarm = max77802_rtc_set_alarm,
+	.alarm_irq_enable = max77802_rtc_alarm_irq_enable,
+};
+
+static int max77802_rtc_init_reg(struct max77802_rtc_info *info)
+{
+	u8 data[2];
+	int ret;
+
+	max77802_rtc_update(info, MAX77802_RTC_READ);
+
+	/* Set RTC control register : Binary mode, 24hour mdoe */
+	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+
+	info->rtc_24hr_mode = 1;
+
+	ret = regmap_bulk_write(info->max77802->regmap,
+				MAX77802_RTC_CONTROLM, data, ARRAY_SIZE(data));
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
+				__func__, ret);
+		return ret;
+	}
+
+	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
+	return ret;
+}
+
+static int max77802_rtc_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *max77802 = dev_get_drvdata(pdev->dev.parent);
+	struct max77802_rtc_info *info;
+	int ret;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max77802_rtc_info),
+			    GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	mutex_init(&info->lock);
+	info->dev = &pdev->dev;
+	info->max77802 = max77802;
+	info->rtc = max77802->i2c;
+
+	platform_set_drvdata(pdev, info);
+
+	ret = max77802_rtc_init_reg(info);
+
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
+		return ret;
+	}
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max77802-rtc",
+						 &max77802_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(info->rtc_dev)) {
+		ret = PTR_ERR(info->rtc_dev);
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		if (ret == 0)
+			ret = -EINVAL;
+		return ret;
+	}
+
+	if (!max77802->rtc_irq_data) {
+		dev_err(&pdev->dev, "No RTC regmap IRQ chip\n");
+		return -EINVAL;
+	}
+
+	info->virq = regmap_irq_get_virq(max77802->rtc_irq_data,
+					 MAX77686_RTCIRQ_RTCA1);
+
+	if (info->virq <= 0) {
+		dev_err(&pdev->dev, "Failed to get virtual IRQ %d\n",
+			MAX77686_RTCIRQ_RTCA1);
+		return -EINVAL;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, info->virq, NULL,
+					max77802_rtc_alarm_irq, 0, "rtc-alarm1",
+					info);
+	if (ret < 0)
+		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
+			info->virq, ret);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int max77802_rtc_suspend(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct max77802_rtc_info *info = dev_get_drvdata(dev);
+
+		return enable_irq_wake(info->virq);
+	}
+
+	return 0;
+}
+
+static int max77802_rtc_resume(struct device *dev)
+{
+	if (device_may_wakeup(dev)) {
+		struct max77802_rtc_info *info = dev_get_drvdata(dev);
+
+		return disable_irq_wake(info->virq);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(max77802_rtc_pm_ops,
+			 max77802_rtc_suspend, max77802_rtc_resume);
+
+static const struct platform_device_id rtc_id[] = {
+	{ "max77802-rtc", 0 },
+	{},
+};
+
+static struct platform_driver max77802_rtc_driver = {
+	.driver		= {
+		.name	= "max77802-rtc",
+		.owner	= THIS_MODULE,
+		.pm	= &max77802_rtc_pm_ops,
+	},
+	.probe		= max77802_rtc_probe,
+	.id_table	= rtc_id,
+};
+
+module_platform_driver(max77802_rtc_driver);
+
+MODULE_DESCRIPTION("Maxim MAX77802 RTC driver");
+MODULE_AUTHOR("Simon Glass <sjg@chromium.org>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from javier.martinez@collabora.co.uk are

rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
rtc-max77686-allow-the-max77686-rtc-to-wakeup-the-system.patch
rtc-max77686-remove-dead-code-for-smpl-and-wtsr.patch
rtc-max77686-fail-to-probe-if-no-rtc-regmap-irqchip-is-set.patch
rtc-max77686-remove-unneded-info-log.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
linux-next.patch

