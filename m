From: akpm@linux-foundation.org
Subject: + rtc-rtc-driver-for-da9052-53-pmic-v1.patch added to -mm tree
Date: Mon, 06 Feb 2012 14:26:01 -0800
Message-ID: <20120206222602.8F291A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62569 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2BFW0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 17:26:04 -0500
Received: by yenm1 with SMTP id m1so35079yen.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 14:26:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ashish.jangam@kpitcummins.com, a.zummo@towertech.it, dchen@diasemi.com, p_gortmaker@yahoo.com, sameo@linux.intel.com


The patch titled
     Subject: rtc: driver for DA9052/53 PMIC v1
has been added to the -mm tree.  Its filename is
     rtc-rtc-driver-for-da9052-53-pmic-v1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: rtc: driver for DA9052/53 PMIC v1

RTC Driver for Dialog Semiconductor DA9052/53 PMICs.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    7 
 drivers/rtc/Makefile     |    1 
 drivers/rtc/rtc-da9052.c |  293 +++++++++++++++++++++++++++++++++++++
 3 files changed, 301 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-rtc-driver-for-da9052-53-pmic-v1 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rtc-driver-for-da9052-53-pmic-v1
+++ a/drivers/rtc/Kconfig
@@ -563,6 +563,13 @@ config RTC_DRV_DS1742
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
 
+config RTC_DRV_DA9052
+	tristate "Dialog DA9052/DA9053 RTC"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the RTC driver for Dialog Semiconductor
+	  DA9052-BC and DA9053-AA/Bx PMICs.
+
 config RTC_DRV_EFI
 	tristate "EFI RTC"
 	depends on IA64
diff -puN drivers/rtc/Makefile~rtc-rtc-driver-for-da9052-53-pmic-v1 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rtc-driver-for-da9052-53-pmic-v1
+++ a/drivers/rtc/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_RTC_DRV_BQ32K)	+= rtc-bq32k
 obj-$(CONFIG_RTC_DRV_BQ4802)	+= rtc-bq4802.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_COH901331)	+= rtc-coh901331.o
+obj-$(CONFIG_RTC_DRV_DA9052)	+= rtc-da9052.o
 obj-$(CONFIG_RTC_DRV_DAVINCI)	+= rtc-davinci.o
 obj-$(CONFIG_RTC_DRV_DM355EVM)	+= rtc-dm355evm.o
 obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
diff -puN /dev/null drivers/rtc/rtc-da9052.c
--- /dev/null
+++ a/drivers/rtc/rtc-da9052.c
@@ -0,0 +1,293 @@
+/*
+ * Real time clock driver for DA9052
+ *
+ *Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ *Author: Dajun Dajun Chen <dajun.chen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
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
+	int ret;
+	if (enable) {
+		ret = da9052_reg_update(da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_ALARM_ON,
+					DA9052_ALARM_Y_ALARM_ON);
+		if (ret != 0)
+			rtc_err(da9052, "Failed to enable ALM: %d\n", ret);
+	} else {
+		ret = da9052_reg_update(da9052, DA9052_ALARM_Y_REG,
+					DA9052_ALARM_Y_ALARM_ON, 0);
+		if (ret != 0)
+			rtc_err(da9052, "Write error: %d\n", ret);
+	}
+	return ret;
+}
+
+static irqreturn_t da9052_rtc_irq(int irq, void *data)
+{
+	struct da9052_rtc *rtc = data;
+	int ret;
+
+	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
+	if (ret < 0) {
+		rtc_err(rtc->da9052, "Read error: %d\n", ret);
+		return IRQ_NONE;
+	}
+
+	if (ret & DA9052_ALARMMI_ALARMTYPE) {
+		da9052_rtc_enable_alarm(rtc->da9052, 0);
+		rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_AF);
+	} else
+		rtc_update_irq(rtc->rtc, 1, RTC_IRQF | RTC_PF);
+
+	return IRQ_HANDLED;
+}
+
+static int da9052_read_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
+{
+	int ret;
+	uint8_t v[5] = {0, 0, 0, 0, 0};
+
+	ret = da9052_group_read(da9052, DA9052_ALARM_MI_REG, 5, v);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to group read ALM: %d\n", ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year = (v[4] & DA9052_RTC_YEAR) + 100;
+	rtc_tm->tm_mon  = (v[3] & DA9052_RTC_MONTH) - 1;
+	rtc_tm->tm_mday = v[2] & DA9052_RTC_DAY;
+	rtc_tm->tm_hour = v[1] & DA9052_RTC_HOUR;
+	rtc_tm->tm_min  = v[0] & DA9052_RTC_MIN;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret != 0)
+		return ret;
+	return ret;
+}
+
+static int da9052_set_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
+{
+	int ret;
+	uint8_t v[3] = {0, 0, 0};
+
+	rtc_tm->tm_year -= 100;
+	rtc_tm->tm_mon += 1;
+
+	ret = da9052_reg_update(da9052, DA9052_ALARM_MI_REG,
+				DA9052_RTC_MIN, rtc_tm->tm_min);
+	if (ret != 0) {
+		rtc_err(da9052, "Failed to write ALRM MIN: %d\n", ret);
+		return ret;
+	}
+
+	v[0] = rtc_tm->tm_hour;
+	v[1] = rtc_tm->tm_mday;
+	v[2] = rtc_tm->tm_mon;
+
+	ret = da9052_group_write(da9052, DA9052_ALARM_H_REG, 3, v);
+	if (ret < 0)
+		return ret;
+
+	ret = da9052_reg_update(da9052, DA9052_ALARM_Y_REG,
+				DA9052_RTC_YEAR, rtc_tm->tm_year);
+	if (ret != 0)
+		rtc_err(da9052, "Failed to write ALRM YEAR: %d\n", ret);
+
+	return ret;
+}
+
+static int da9052_rtc_get_alarm_status(struct da9052 *da9052)
+{
+	int ret;
+
+	ret = da9052_reg_read(da9052, DA9052_ALARM_Y_REG);
+	if (ret < 0) {
+		rtc_err(da9052, "Failed to read ALM: %d\n", ret);
+		return ret;
+	}
+	ret &= DA9052_ALARM_Y_ALARM_ON;
+	return (ret > 0) ? 1 : 0;
+}
+
+static int da9052_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	int ret;
+
+	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
+	if (ret < 0) {
+		rtc_err(rtc->da9052, "Failed to read RTC time : %d\n", ret);
+		return ret;
+	}
+
+	rtc_tm->tm_year = (v[5] & DA9052_RTC_YEAR) + 100;
+	rtc_tm->tm_mon  = (v[4] & DA9052_RTC_MONTH) - 1;
+	rtc_tm->tm_mday = v[3] & DA9052_RTC_DAY;
+	rtc_tm->tm_hour = v[2] & DA9052_RTC_HOUR;
+	rtc_tm->tm_min  = v[1] & DA9052_RTC_MIN;
+	rtc_tm->tm_sec  = v[0] & DA9052_RTC_SEC;
+
+	ret = rtc_valid_tm(rtc_tm);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "rtc_valid_tm failed: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int da9052_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct da9052_rtc *rtc;
+	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+
+	rtc = dev_get_drvdata(dev);
+
+	v[0] = tm->tm_sec;
+	v[1] = tm->tm_min;
+	v[2] = tm->tm_hour;
+	v[3] = tm->tm_mday;
+	v[4] = tm->tm_mon + 1;
+	v[5] = tm->tm_year - 100;
+
+	return da9052_group_write(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
+}
+
+static int da9052_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	int ret;
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
+	int ret;
+	struct rtc_time *tm = &alrm->time;
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	ret = da9052_rtc_enable_alarm(rtc->da9052, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = da9052_set_alarm(rtc->da9052, tm);
+	if (ret)
+		return ret;
+
+	ret = da9052_rtc_enable_alarm(rtc->da9052, 1);
+
+	return ret;
+}
+
+static int da9052_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct da9052_rtc *rtc = dev_get_drvdata(dev);
+
+	return da9052_rtc_enable_alarm(rtc->da9052, enabled);
+}
+
+static const struct rtc_class_ops da9052_rtc_ops = {
+	.read_time	= da9052_rtc_read_time,
+	.set_time	= da9052_rtc_set_time,
+	.read_alarm	= da9052_rtc_read_alarm,
+	.set_alarm	= da9052_rtc_set_alarm,
+	.alarm_irq_enable = da9052_rtc_alarm_irq_enable,
+};
+
+static int __devinit da9052_rtc_probe(struct platform_device *pdev)
+{
+	struct da9052_rtc *rtc;
+	int ret;
+
+	rtc = devm_kzalloc(&pdev->dev, sizeof(struct da9052_rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, rtc);
+	rtc->irq = platform_get_irq_byname(pdev, "ALM");
+	ret = request_threaded_irq(rtc->irq, NULL, da9052_rtc_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "ALM", rtc);
+	if (ret != 0) {
+		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
+		goto err_mem;
+	}
+
+	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+				       &da9052_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
+		goto err_free_irq;
+	}
+
+	return 0;
+
+err_free_irq:
+	free_irq(rtc->irq, rtc);
+err_mem:
+	devm_kfree(&pdev->dev, rtc);
+	return ret;
+}
+
+static int __devexit da9052_rtc_remove(struct platform_device *pdev)
+{
+	struct da9052_rtc *rtc = pdev->dev.platform_data;
+
+	rtc_device_unregister(rtc->rtc);
+	free_irq(rtc->irq, rtc);
+	platform_set_drvdata(pdev, NULL);
+	devm_kfree(&pdev->dev, rtc);
+
+	return 0;
+}
+
+static struct platform_driver da9052_rtc_driver = {
+	.probe	= da9052_rtc_probe,
+	.remove	= __devexit_p(da9052_rtc_remove),
+	.driver = {
+		.name	= "da9052-rtc",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9052_rtc_driver);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("RTC driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-rtc");
_
Subject: Subject: rtc: driver for DA9052/53 PMIC v1

Patches currently in -mm which might be from ashish.jangam@kpitcummins.com are

rtc-rtc-driver-for-da9052-53-pmic-v1.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch

