From: akpm@linux-foundation.org
Subject: + rtc-rtc-driver-for-da9052-pmic.patch added to -mm tree
Date: Tue, 26 Apr 2011 14:22:26 -0700
Message-ID: <201104262122.p3QLMQLn020191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932515Ab1DZVYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 17:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Ashish.Jangam@kpitcummins.com, a.zummo@towertech.it, dchen@diasemi.com, p_gortmaker@yahoo.com


The patch titled
     rtc: rtc driver for DA9052 PMIC
has been added to the -mm tree.  Its filename is
     rtc-rtc-driver-for-da9052-pmic.patch

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
Subject: rtc: rtc driver for DA9052 PMIC
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>

RTC Driver for Dialog Semiconductor DA9052 PMICs.

Signed-off-by: D. Chen <dchen@diasemi.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    7 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-da9052.c |  341 +++++++++++++++++++++++++++++++++++++
 3 files changed, 349 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-rtc-driver-for-da9052-pmic drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-driver-for-da9052-pmic
+++ a/drivers/rtc/Kconfig
@@ -511,6 +511,13 @@ config RTC_DRV_VRTC
 	style programming interface is mostly conserved, but any
 	updates are done via IPC calls to the system controller FW.
 
+config RTC_DRV_DA9052
+	tristate "Dialog DA9052 RTC"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the RTC driver for
+	  Dialog Semiconductor DA9052 PMIC.
+
 config RTC_DRV_DS1216
 	tristate "Dallas DS1216"
 	depends on SNI_RM
diff -puN drivers/rtc/Makefile~rtc-rtc-driver-for-da9052-pmic drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rtc-driver-for-da9052-pmic
+++ a/drivers/rtc/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_RTC_DRV_BQ32K)	+= rtc-bq32k
 obj-$(CONFIG_RTC_DRV_BQ4802)	+= rtc-bq4802.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
+obj-$(CONFIG_RTC_DRV_DA9052)		+= rtc-da9052.o
 obj-$(CONFIG_RTC_DRV_DAVINCI)	+= rtc-davinci.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
diff -puN /dev/null drivers/rtc/rtc-da9052.c
--- /dev/null
+++ a/drivers/rtc/rtc-da9052.c
@@ -0,0 +1,341 @@
+/*
+ * Real time clock driver for DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dajun.chen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define rtc_err(da9052, fmt, ...) \
+		dev_err(da9052->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
+
+struct da9052_rtc {
+	struct rtc_device *rtc;
+	struct da9052 *da9052;
+	int irq;
+};
+
+static int da9052_rtc_enable_alarm(struct da9052 *da9052, bool enable)
+{
+	int ret = 0;
+	if (enable) {
+		ret = da9052_set_bits(da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_ALARM_ON);
+		if (ret != 0)
+			rtc_err(da9052, "Failed to enable ALM: %d\n", ret);
+	} else {
+		ret = da9052_clear_bits(da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_ALARM_ON);
+		if (ret != 0)
+			rtc_err(da9052, "Write error: %d\n",
+					ret);
+	}
+	return ret;
+}
+
+static irqreturn_t da9052_rtc_irq(int irq, void *data)
+{
+	struct da9052_rtc *rtc = data;
+	int ret = 0;
+
+	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
+	if (ret < 0) {
+		rtc_err(rtc->da9052, "Read error: %d\n",
+					ret);
+		return IRQ_NONE;
+	}
+	if (ret & DA9052_ALARMMI_ALARMTYPE)
+		da9052_rtc_enable_alarm(rtc->da9052, 0);
+
+	return IRQ_HANDLED;
+}
+
+static int da9052_read_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
+{
+
+	int ret = 0;
+	uint8_t v[5] = {0, 0, 0, 0, 0};
+	ret = da9052_group_read(da9052, DA9052_ALARM_MI_REG, 5, v);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to group read ALM: %d\n", ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year = v[4] & DA9052_RTC_YEAR;
+	rtc_tm->tm_mon  = v[3] & DA9052_RTC_MONTH;
+	rtc_tm->tm_mday = v[2] & DA9052_RTC_DAY;
+	rtc_tm->tm_hour = v[1] & DA9052_RTC_HOUR;
+	rtc_tm->tm_min  = v[0] & DA9052_RTC_MIN;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret != 0)
+		return ret;
+
+	rtc_tm->tm_year += 100;
+	rtc_tm->tm_mon -= 1;
+
+	return ret;
+}
+
+static int da9052_set_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
+{
+	int ret = 0;
+	uint8_t v[3] = {0, 0, 0};
+
+	rtc_tm->tm_sec = 0;
+	rtc_tm->tm_year -= 100;
+	rtc_tm->tm_mon += 1;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret)
+		return ret;
+
+	ret = da9052_reg_update(da9052, DA9052_ALARM_MI_REG,
+				DA9052_RTC_MIN, rtc_tm->tm_min);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to write ALRM MIN: %d\n", ret);
+		return ret;
+	}
+
+	ret = da9052_reg_update(da9052, DA9052_ALARM_Y_REG,
+				DA9052_RTC_YEAR, rtc_tm->tm_year);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to write ALRM YEAR: %d\n", ret);
+		return ret;
+	}
+
+	v[0] = rtc_tm->tm_hour;
+	v[1] = rtc_tm->tm_mday;
+	v[2] = rtc_tm->tm_mon;
+
+	return da9052_group_write(da9052, DA9052_ALARM_H_REG, 3, v);
+}
+
+static int da9052_rtc_get_alarm_status(struct da9052 *da9052)
+{
+	int ret = 0;
+	ret = da9052_reg_read(da9052, DA9052_ALARM_Y_REG);
+	if (ret < 0) {
+		rtc_err(da9052, "Failed to read ALM: %d\n", ret);
+		return ret;
+	}
+	ret &= DA9052_ALARM_Y_ALARM_ON;
+	return (ret > 0) ? 1 : 0;
+}
+
+static int da9052_rtc_read_time
+			(struct device *dev, struct rtc_time *rtc_tm)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	int ret;
+
+	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "Failed to read RTC time : %d\n",
+					ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year = v[5] & DA9052_RTC_YEAR;
+	rtc_tm->tm_mon  = v[4] & DA9052_RTC_MONTH;
+	rtc_tm->tm_mday = v[3] & DA9052_RTC_DAY;
+	rtc_tm->tm_hour = v[2] & DA9052_RTC_HOUR;
+	rtc_tm->tm_min  = v[1] & DA9052_RTC_MIN;
+	rtc_tm->tm_sec  = v[0] & DA9052_RTC_SEC;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "rtc_valid_tm failed: %d\n",
+					ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year += 100;
+	rtc_tm->tm_mon -= 1;
+
+	return 0;
+}
+
+
+static int da9052_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	int ret;
+	struct da9052_rtc *rtc;
+	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+
+	rtc = dev_get_drvdata(dev);
+
+	tm->tm_year -= 100;
+	tm->tm_mon += 1;
+
+	ret = rtc_valid_tm(tm);
+	if (ret != 0)
+		return ret;
+
+	v[0] = tm->tm_sec;
+	v[1] = tm->tm_min;
+	v[2] = tm->tm_hour;
+	v[3] = tm->tm_mday;
+	v[4] = tm->tm_mon;
+	v[5] = tm->tm_year;
+	return da9052_group_write(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
+}
+
+static int da9052_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	int ret = 0;
+	struct rtc_time *tm = &alrm->time;
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	ret = da9052_read_alarm(rtc->da9052, tm);
+
+	if (ret)
+		return ret;
+
+	alrm->enabled = da9052_rtc_get_alarm_status(rtc->da9052);
+
+	return 0;
+}
+
+static int da9052_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	int ret = 0;
+	struct rtc_time *tm = &alrm->time;
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	ret = da9052_set_alarm(rtc->da9052, tm);
+
+	if (ret)
+		return ret;
+
+	ret = da9052_rtc_enable_alarm(rtc->da9052, 1);
+
+	return ret;
+}
+
+static int da9052_rtc_update_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		return da9052_set_bits(rtc->da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_TICK_ON);
+	else
+		return da9052_clear_bits(rtc->da9052, DA9052_ALARM_Y_REG,
+					 DA9052_ALARM_Y_TICK_ON);
+}
+
+static int da9052_rtc_alarm_irq_enable(struct device *dev,
+			unsigned int enabled)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		return da9052_rtc_enable_alarm(rtc->da9052, enabled);
+	else
+		return da9052_rtc_enable_alarm(rtc->da9052, enabled);
+}
+
+static const struct rtc_class_ops da9052_rtc_ops = {
+	.read_time	= da9052_rtc_read_time,
+	.set_time	= da9052_rtc_set_time,
+	.read_alarm	= da9052_rtc_read_alarm,
+	.set_alarm	= da9052_rtc_set_alarm,
+	.update_irq_enable = da9052_rtc_update_irq_enable,
+	.alarm_irq_enable = da9052_rtc_alarm_irq_enable,
+};
+
+static int __devinit da9052_rtc_probe(struct platform_device *pdev)
+{
+	struct da9052_rtc *rtc;
+	int ret = 0;
+
+	rtc = kzalloc(sizeof(struct da9052_rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
+	rtc->irq = platform_get_irq_byname(pdev, "ALM");
+
+	ret = request_threaded_irq(rtc->da9052->irq_base + rtc->irq,
+				NULL, da9052_rtc_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"ALM", rtc);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "irq registration failed: %d\n",
+					ret);
+		goto err_mem;
+	}
+
+	da9052_set_bits(rtc->da9052, DA9052_ALARM_Y_REG,
+			DA9052_ALARM_Y_TICK_ON);
+
+	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+				       &da9052_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
+		goto err_free_irq;
+	}
+
+	platform_set_drvdata(pdev, rtc);
+
+	return 0;
+
+err_free_irq:
+	free_irq(rtc->da9052->irq_base + rtc->irq, NULL);
+err_mem:
+	kfree(rtc);
+	return ret;
+}
+
+static int __devexit da9052_rtc_remove(struct platform_device *pdev)
+{
+	struct da9052_rtc *rtc = pdev->dev.platform_data;
+
+	rtc_device_unregister(rtc->rtc);
+	free_irq(rtc->da9052->irq_base + rtc->irq, NULL);
+	platform_set_drvdata(pdev, NULL);
+	kfree(rtc);
+
+	return 0;
+}
+
+static struct platform_driver da9052_rtc_driver = {
+	.driver = {
+			.name		= "da9052-rtc",
+			.owner	= THIS_MODULE,
+	},
+	.probe	= da9052_rtc_probe,
+	.remove	= __devexit_p(da9052_rtc_remove),
+};
+
+static int __init da9052_rtc_init(void)
+{
+	return platform_driver_register(&da9052_rtc_driver);
+}
+module_init(da9052_rtc_init);
+
+static void __exit da9052_rtc_exit(void)
+{
+	platform_driver_unregister(&da9052_rtc_driver);
+}
+module_exit(da9052_rtc_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("RTC driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-rtc");
_

Patches currently in -mm which might be from Ashish.Jangam@kpitcummins.com are

rtc-rtc-driver-for-da9052-pmic.patch

