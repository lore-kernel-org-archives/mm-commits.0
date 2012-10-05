From: akpm@linux-foundation.org
Subject: [merged] rtc-rc5t583-add-ricoh-rc5t583-rtc-driver.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:07 -0700
Message-ID: <20121005201708.2AE475C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34529 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEURK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:10 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57926wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rc5t583: add ricoh rc5t583 RTC driver
has been removed from the -mm tree.  Its filename was
     rtc-rc5t583-add-ricoh-rc5t583-rtc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: rtc: rc5t583: add ricoh rc5t583 RTC driver

Add an RTC driver for the RTC device on Ricoh MFD Rc5t583.  Ricoh RTC has
3 types of alarms.  The current patch adds support for the Y-Alarm of
RC5t583 RTC.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig         |   10 +
 drivers/rtc/Makefile        |    1 
 drivers/rtc/rtc-rc5t583.c   |  331 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/rc5t583.h |   22 ++
 4 files changed, 364 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-rc5t583-add-ricoh-rc5t583-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rc5t583-add-ricoh-rc5t583-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -350,6 +350,16 @@ config RTC_DRV_TPS65910
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-tps65910.
 
+config RTC_DRV_RC5T583
+	tristate "RICOH 5T583 RTC driver"
+	depends on MFD_RC5T583
+	help
+	  If you say yes here you get support for the RTC on the
+	  RICOH 5T583 chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-rc5t583.
+
 config RTC_DRV_S35390A
 	tristate "Seiko Instruments S-35390A"
 	select BITREVERSE
diff -puN drivers/rtc/Makefile~rtc-rc5t583-add-ricoh-rc5t583-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rc5t583-add-ricoh-rc5t583-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
 obj-$(CONFIG_RTC_DRV_PUV3)	+= rtc-puv3.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
+obj-$(CONFIG_RTC_DRV_RC5T583)	+= rtc-rc5t583.o
 obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
diff -puN /dev/null drivers/rtc/rtc-rc5t583.c
--- /dev/null
+++ a/drivers/rtc/rtc-rc5t583.c
@@ -0,0 +1,331 @@
+/*
+ * rtc-rc5t583.c -- RICOH RC5T583 Real Time Clock
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Author: Venu Byravarasu <vbyravarasu@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>. */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/rc5t583.h>
+
+struct rc5t583_rtc {
+	struct rtc_device	*rtc;
+	/* To store the list of enabled interrupts, during system suspend */
+	u32 irqen;
+};
+
+/* Total number of RTC registers needed to set time*/
+#define NUM_TIME_REGS	(RC5T583_RTC_YEAR - RC5T583_RTC_SEC + 1)
+
+/* Total number of RTC registers needed to set Y-Alarm*/
+#define NUM_YAL_REGS	(RC5T583_RTC_AY_YEAR - RC5T583_RTC_AY_MIN + 1)
+
+/* Set Y-Alarm interrupt */
+#define SET_YAL BIT(5)
+
+/* Get Y-Alarm interrupt status*/
+#define GET_YAL_STATUS BIT(3)
+
+static int rc5t583_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	u8 val;
+
+	/* Set Y-Alarm, based on 'enabled' */
+	val = enabled ? SET_YAL : 0;
+
+	return regmap_update_bits(rc5t583->regmap, RC5T583_RTC_CTL1, SET_YAL,
+		val);
+}
+
+/*
+ * Gets current rc5t583 RTC time and date parameters.
+ *
+ * The RTC's time/alarm representation is not what gmtime(3) requires
+ * Linux to use:
+ *
+ *  - Months are 1..12 vs Linux 0-11
+ *  - Years are 0..99 vs Linux 1900..N (we assume 21st century)
+ */
+static int rc5t583_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	u8 rtc_data[NUM_TIME_REGS];
+	int ret;
+
+	ret = regmap_bulk_read(rc5t583->regmap, RC5T583_RTC_SEC, rtc_data,
+		NUM_TIME_REGS);
+	if (ret < 0) {
+		dev_err(dev, "RTC read time failed with err:%d\n", ret);
+		return ret;
+	}
+
+	tm->tm_sec = bcd2bin(rtc_data[0]);
+	tm->tm_min = bcd2bin(rtc_data[1]);
+	tm->tm_hour = bcd2bin(rtc_data[2]);
+	tm->tm_wday = bcd2bin(rtc_data[3]);
+	tm->tm_mday = bcd2bin(rtc_data[4]);
+	tm->tm_mon = bcd2bin(rtc_data[5]) - 1;
+	tm->tm_year = bcd2bin(rtc_data[6]) + 100;
+
+	return ret;
+}
+
+static int rc5t583_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	unsigned char rtc_data[NUM_TIME_REGS];
+	int ret;
+
+	rtc_data[0] = bin2bcd(tm->tm_sec);
+	rtc_data[1] = bin2bcd(tm->tm_min);
+	rtc_data[2] = bin2bcd(tm->tm_hour);
+	rtc_data[3] = bin2bcd(tm->tm_wday);
+	rtc_data[4] = bin2bcd(tm->tm_mday);
+	rtc_data[5] = bin2bcd(tm->tm_mon + 1);
+	rtc_data[6] = bin2bcd(tm->tm_year - 100);
+
+	ret = regmap_bulk_write(rc5t583->regmap, RC5T583_RTC_SEC, rtc_data,
+		NUM_TIME_REGS);
+	if (ret < 0) {
+		dev_err(dev, "RTC set time failed with error %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int rc5t583_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	unsigned char alarm_data[NUM_YAL_REGS];
+	u32 interrupt_enable;
+	int ret;
+
+	ret = regmap_bulk_read(rc5t583->regmap, RC5T583_RTC_AY_MIN, alarm_data,
+		NUM_YAL_REGS);
+	if (ret < 0) {
+		dev_err(dev, "rtc_read_alarm error %d\n", ret);
+		return ret;
+	}
+
+	alm->time.tm_min = bcd2bin(alarm_data[0]);
+	alm->time.tm_hour = bcd2bin(alarm_data[1]);
+	alm->time.tm_mday = bcd2bin(alarm_data[2]);
+	alm->time.tm_mon = bcd2bin(alarm_data[3]) - 1;
+	alm->time.tm_year = bcd2bin(alarm_data[4]) + 100;
+
+	ret = regmap_read(rc5t583->regmap, RC5T583_RTC_CTL1, &interrupt_enable);
+	if (ret < 0)
+		return ret;
+
+	/* check if YALE is set */
+	if (interrupt_enable & SET_YAL)
+		alm->enabled = 1;
+
+	return ret;
+}
+
+static int rc5t583_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	unsigned char alarm_data[NUM_YAL_REGS];
+	int ret;
+
+	ret = rc5t583_rtc_alarm_irq_enable(dev, 0);
+	if (ret)
+		return ret;
+
+	alarm_data[0] = bin2bcd(alm->time.tm_min);
+	alarm_data[1] = bin2bcd(alm->time.tm_hour);
+	alarm_data[2] = bin2bcd(alm->time.tm_mday);
+	alarm_data[3] = bin2bcd(alm->time.tm_mon + 1);
+	alarm_data[4] = bin2bcd(alm->time.tm_year - 100);
+
+	ret = regmap_bulk_write(rc5t583->regmap, RC5T583_RTC_AY_MIN, alarm_data,
+		NUM_YAL_REGS);
+	if (ret) {
+		dev_err(dev, "rtc_set_alarm error %d\n", ret);
+		return ret;
+	}
+
+	if (alm->enabled)
+		ret = rc5t583_rtc_alarm_irq_enable(dev, 1);
+
+	return ret;
+}
+
+static irqreturn_t rc5t583_rtc_interrupt(int irq, void *rtc)
+{
+	struct device *dev = rtc;
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(dev);
+	unsigned long events = 0;
+	int ret;
+	u32 rtc_reg;
+
+	ret = regmap_read(rc5t583->regmap, RC5T583_RTC_CTL2, &rtc_reg);
+	if (ret < 0)
+		return IRQ_NONE;
+
+	if (rtc_reg & GET_YAL_STATUS) {
+		events = RTC_IRQF | RTC_AF;
+		/* clear pending Y-alarm interrupt bit */
+		rtc_reg &= ~GET_YAL_STATUS;
+	}
+
+	ret = regmap_write(rc5t583->regmap, RC5T583_RTC_CTL2, rtc_reg);
+	if (ret)
+		return IRQ_NONE;
+
+	/* Notify RTC core on event */
+	rtc_update_irq(rc5t583_rtc->rtc, 1, events);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops rc5t583_rtc_ops = {
+	.read_time	= rc5t583_rtc_read_time,
+	.set_time	= rc5t583_rtc_set_time,
+	.read_alarm	= rc5t583_rtc_read_alarm,
+	.set_alarm	= rc5t583_rtc_set_alarm,
+	.alarm_irq_enable = rc5t583_rtc_alarm_irq_enable,
+};
+
+static int __devinit rc5t583_rtc_probe(struct platform_device *pdev)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(pdev->dev.parent);
+	struct rc5t583_rtc *ricoh_rtc;
+	struct rc5t583_platform_data *pmic_plat_data;
+	int ret;
+	int irq;
+
+	ricoh_rtc = devm_kzalloc(&pdev->dev, sizeof(struct rc5t583_rtc),
+			GFP_KERNEL);
+	if (!ricoh_rtc)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ricoh_rtc);
+
+	/* Clear pending interrupts */
+	ret = regmap_write(rc5t583->regmap, RC5T583_RTC_CTL2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* clear RTC Adjust register */
+	ret = regmap_write(rc5t583->regmap, RC5T583_RTC_ADJ, 0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to program rtc_adjust reg\n");
+		return -EBUSY;
+	}
+
+	pmic_plat_data = dev_get_platdata(rc5t583->dev);
+	irq = pmic_plat_data->irq_base;
+	if (irq <= 0) {
+		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
+			irq);
+		return ret;
+	}
+
+	irq += RC5T583_IRQ_YALE;
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+		rc5t583_rtc_interrupt, IRQF_TRIGGER_LOW,
+		"rtc-rc5t583", &pdev->dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "IRQ is not free.\n");
+		return ret;
+	}
+	device_init_wakeup(&pdev->dev, 1);
+
+	ricoh_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+		&rc5t583_rtc_ops, THIS_MODULE);
+	if (IS_ERR(ricoh_rtc->rtc)) {
+		ret = PTR_ERR(ricoh_rtc->rtc);
+		dev_err(&pdev->dev, "RTC device register: err %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Disable rc5t583 RTC interrupts.
+ * Sets status flag to free.
+ */
+static int __devexit rc5t583_rtc_remove(struct platform_device *pdev)
+{
+	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(&pdev->dev);
+
+	rc5t583_rtc_alarm_irq_enable(&rc5t583_rtc->rtc->dev, 0);
+
+	rtc_device_unregister(rc5t583_rtc->rtc);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+
+static int rc5t583_rtc_suspend(struct device *dev)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(dev);
+	int ret;
+
+	/* Store current list of enabled interrupts*/
+	ret = regmap_read(rc5t583->regmap, RC5T583_RTC_CTL1,
+		&rc5t583_rtc->irqen);
+	return ret;
+}
+
+static int rc5t583_rtc_resume(struct device *dev)
+{
+	struct rc5t583 *rc5t583 = dev_get_drvdata(dev->parent);
+	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(dev);
+
+	/* Restore list of enabled interrupts before suspend */
+	return regmap_write(rc5t583->regmap, RC5T583_RTC_CTL1,
+		rc5t583_rtc->irqen);
+}
+
+static const struct dev_pm_ops rc5t583_rtc_pm_ops = {
+	.suspend	= rc5t583_rtc_suspend,
+	.resume		= rc5t583_rtc_resume,
+};
+
+#define DEV_PM_OPS     (&rc5t583_rtc_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
+static struct platform_driver rc5t583_rtc_driver = {
+	.probe		= rc5t583_rtc_probe,
+	.remove		= __devexit_p(rc5t583_rtc_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "rtc-rc5t583",
+		.pm	= DEV_PM_OPS,
+	},
+};
+
+module_platform_driver(rc5t583_rtc_driver);
+MODULE_ALIAS("platform:rtc-rc5t583");
+MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
+MODULE_LICENSE("GPL v2");
diff -puN include/linux/mfd/rc5t583.h~rtc-rc5t583-add-ricoh-rc5t583-rtc-driver include/linux/mfd/rc5t583.h
--- a/include/linux/mfd/rc5t583.h~rtc-rc5t583-add-ricoh-rc5t583-rtc-driver
+++ a/include/linux/mfd/rc5t583.h
@@ -146,6 +146,28 @@
 #define RC5T583_GPIO_MON_IOIN	0xAB
 #define RC5T583_GPIO_GPOFUNC	0xAC
 
+/* RTC registers */
+#define RC5T583_RTC_SEC		0xE0
+#define RC5T583_RTC_MIN		0xE1
+#define RC5T583_RTC_HOUR	0xE2
+#define RC5T583_RTC_WDAY	0xE3
+#define RC5T583_RTC_DAY		0xE4
+#define RC5T583_RTC_MONTH	0xE5
+#define RC5T583_RTC_YEAR	0xE6
+#define RC5T583_RTC_ADJ		0xE7
+#define RC5T583_RTC_AW_MIN	0xE8
+#define RC5T583_RTC_AW_HOUR	0xE9
+#define RC5T583_RTC_AW_WEEK	0xEA
+#define RC5T583_RTC_AD_MIN	0xEB
+#define RC5T583_RTC_AD_HOUR	0xEC
+#define RC5T583_RTC_CTL1	0xED
+#define RC5T583_RTC_CTL2	0xEE
+#define RC5T583_RTC_AY_MIN	0xF0
+#define RC5T583_RTC_AY_HOUR	0xF1
+#define RC5T583_RTC_AY_DAY	0xF2
+#define RC5T583_RTC_AY_MONTH 0xF3
+#define RC5T583_RTC_AY_YEAR	0xF4
+
 /* RICOH_RC5T583 IRQ definitions */
 enum {
 	RC5T583_IRQ_ONKEY,
_

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
linux-next.patch

