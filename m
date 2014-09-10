From: akpm@linux-foundation.org
Subject: + rtc-rk808-add-rtc-driver-for-rk808.patch added to -mm tree
Date: Wed, 10 Sep 2014 13:39:07 -0700
Message-ID: <5410b6eb.o+fTtMCRp6cFFMzZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaIJUjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 16:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zyw@rock-chips.com, a.zummo@towertech.it, dianders@chromium.org, dtor@chromium.org, heiko@sntech.de, ijc+devicetree@hellion.org.uk, javier.martinez@collabora.co.uk, kever.yang@rock-chips.com, mark.rutland@arm.com, olof@lixom.net, pawel.moll@arm.com, sameo@linux.intel.com, zhangqing@rock-chips.com, zhong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: RTC: RK808: add RTC driver for RK808
has been added to the -mm tree.  Its filename is
     rtc-rk808-add-rtc-driver-for-rk808.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rk808-add-rtc-driver-for-rk808.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rk808-add-rtc-driver-for-rk808.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Zhong <zyw@rock-chips.com>
Subject: RTC: RK808: add RTC driver for RK808

This is the initial version of the RK808 PMIC.  This is a power management
IC for multimedia products.  It provides regulators that are able to
supply power to processor cores and other components.  The chip provides
other modules including RTC, Clockout.

Add RTC driver for supporting RTC device present inside RK808 PMIC.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com> says:
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Olof Johansson <olof@lixom.net>
Cc: Dmitry Torokhov <dtor@chromium.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kever Yang <kever.yang@rock-chips.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig     |   10 
 drivers/rtc/Makefile    |    1 
 drivers/rtc/rtc-rk808.c |  427 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 438 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-rk808-add-rtc-driver-for-rk808 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rk808-add-rtc-driver-for-rk808
+++ a/drivers/rtc/Kconfig
@@ -288,6 +288,16 @@ config RTC_DRV_MAX77686
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max77686.
 
+config RTC_DRV_RK808
+	tristate "Rockchip RK808 RTC"
+	depends on MFD_RK808
+	help
+	  If you say yes here you will get support for the
+	  RTC of RK808 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rk808-rtc.
+
 config RTC_DRV_RS5C372
 	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
 	help
diff -puN drivers/rtc/Makefile~rtc-rk808-add-rtc-driver-for-rk808 drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rk808-add-rtc-driver-for-rk808
+++ a/drivers/rtc/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_RTC_DRV_PUV3)	+= rtc-puv3.o
 obj-$(CONFIG_RTC_DRV_PXA)	+= rtc-pxa.o
 obj-$(CONFIG_RTC_DRV_R9701)	+= rtc-r9701.o
 obj-$(CONFIG_RTC_DRV_RC5T583)	+= rtc-rc5t583.o
+obj-$(CONFIG_RTC_DRV_RK808)	+= rtc-rk808.o
 obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
diff -puN /dev/null drivers/rtc/rtc-rk808.c
--- /dev/null
+++ a/drivers/rtc/rtc-rk808.c
@@ -0,0 +1,427 @@
+/*
+ * RTC driver for Rockchip RK808
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * Author: Chris Zhong <zyw@rock-chips.com>
+ * Author: Zhang Qing <zhangqing@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/mfd/rk808.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+
+/* RTC_CTRL_REG bitfields */
+#define BIT_RTC_CTRL_REG_STOP_RTC_M		BIT(0)
+
+/* RK808 has a shadowed register for saving a "frozen" RTC time.
+ * When user setting "GET_TIME" to 1, the time will save in this shadowed
+ * register. If set "READSEL" to 1, user read rtc time register, actually
+ * get the time of that moment. If we need the real time, clr this bit.
+ */
+#define BIT_RTC_CTRL_REG_RTC_GET_TIME		BIT(6)
+#define BIT_RTC_CTRL_REG_RTC_READSEL_M		BIT(7)
+#define BIT_RTC_INTERRUPTS_REG_IT_ALARM_M	BIT(3)
+#define RTC_STATUS_MASK		0xFE
+
+#define SECONDS_REG_MSK		0x7F
+#define MINUTES_REG_MAK		0x7F
+#define HOURS_REG_MSK		0x3F
+#define DAYS_REG_MSK		0x3F
+#define MONTHS_REG_MSK		0x1F
+#define YEARS_REG_MSK		0xFF
+#define WEEKS_REG_MSK		0x7
+
+/* REG_SECONDS_REG through REG_YEARS_REG is how many registers? */
+
+#define NUM_TIME_REGS	(RK808_WEEKS_REG - RK808_SECONDS_REG + 1)
+#define NUM_ALARM_REGS	(RK808_ALARM_YEARS_REG - RK808_ALARM_SECONDS_REG + 1)
+
+struct rk808_rtc {
+	struct rk808 *rk808;
+	struct rtc_device *rtc;
+	int irq;
+};
+
+/* Read current time and date in RTC */
+static int rk808_rtc_readtime(struct device *dev, struct rtc_time *tm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	u8 rtc_data[NUM_TIME_REGS];
+	int ret;
+
+	/* Force an update of the shadowed registers right now */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
+				 0);
+	if (ret) {
+		dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
+				 BIT_RTC_CTRL_REG_RTC_GET_TIME);
+	if (ret) {
+		dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_bulk_read(rk808->regmap, RK808_SECONDS_REG,
+			       rtc_data, NUM_TIME_REGS);
+	if (ret) {
+		dev_err(dev, "Failed to bulk read rtc_data: %d\n", ret);
+		return ret;
+	}
+
+	tm->tm_sec = bcd2bin(rtc_data[0] & SECONDS_REG_MSK);
+	tm->tm_min = bcd2bin(rtc_data[1] & MINUTES_REG_MAK);
+	tm->tm_hour = bcd2bin(rtc_data[2] & HOURS_REG_MSK);
+	tm->tm_mday = bcd2bin(rtc_data[3] & DAYS_REG_MSK);
+	tm->tm_mon = (bcd2bin(rtc_data[4] & MONTHS_REG_MSK)) - 1;
+	tm->tm_year = (bcd2bin(rtc_data[5] & YEARS_REG_MSK)) + 100;
+	tm->tm_wday = bcd2bin(rtc_data[6] & WEEKS_REG_MSK);
+	dev_dbg(dev, "RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
+		tm->tm_wday, tm->tm_hour , tm->tm_min, tm->tm_sec);
+
+	return ret;
+}
+
+/* Set current time and date in RTC */
+static int rk808_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	u8 rtc_data[NUM_TIME_REGS];
+	int ret;
+
+	rtc_data[0] = bin2bcd(tm->tm_sec);
+	rtc_data[1] = bin2bcd(tm->tm_min);
+	rtc_data[2] = bin2bcd(tm->tm_hour);
+	rtc_data[3] = bin2bcd(tm->tm_mday);
+	rtc_data[4] = bin2bcd(tm->tm_mon + 1);
+	rtc_data[5] = bin2bcd(tm->tm_year - 100);
+	rtc_data[6] = bin2bcd(tm->tm_wday);
+	dev_dbg(dev, "set RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
+		tm->tm_wday, tm->tm_hour , tm->tm_min, tm->tm_sec);
+
+	/* Stop RTC while updating the RTC registers */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M);
+	if (ret) {
+		dev_err(dev, "Failed to update RTC control: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_bulk_write(rk808->regmap, RK808_SECONDS_REG,
+				rtc_data, NUM_TIME_REGS);
+	if (ret) {
+		dev_err(dev, "Failed to bull write rtc_data: %d\n", ret);
+		return ret;
+	}
+	/* Start RTC again */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M, 0);
+	if (ret) {
+		dev_err(dev, "Failed to update RTC control: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+/* Read alarm time and date in RTC */
+static int rk808_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	u8 alrm_data[NUM_ALARM_REGS];
+	uint32_t int_reg;
+	int ret;
+
+	ret = regmap_bulk_read(rk808->regmap, RK808_ALARM_SECONDS_REG,
+			       alrm_data, NUM_ALARM_REGS);
+
+	alrm->time.tm_sec = bcd2bin(alrm_data[0] & SECONDS_REG_MSK);
+	alrm->time.tm_min = bcd2bin(alrm_data[1] & MINUTES_REG_MAK);
+	alrm->time.tm_hour = bcd2bin(alrm_data[2] & HOURS_REG_MSK);
+	alrm->time.tm_mday = bcd2bin(alrm_data[3] & DAYS_REG_MSK);
+	alrm->time.tm_mon = (bcd2bin(alrm_data[4] & MONTHS_REG_MSK)) - 1;
+	alrm->time.tm_year = (bcd2bin(alrm_data[5] & YEARS_REG_MSK)) + 100;
+
+	ret = regmap_read(rk808->regmap, RK808_RTC_INT_REG, &int_reg);
+	if (ret) {
+		dev_err(dev, "Failed to read RTC INT REG: %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(dev, "alrm read RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + alrm->time.tm_year, alrm->time.tm_mon + 1,
+		alrm->time.tm_mday, alrm->time.tm_wday, alrm->time.tm_hour,
+		alrm->time.tm_min, alrm->time.tm_sec);
+
+	alrm->enabled = (int_reg & BIT_RTC_INTERRUPTS_REG_IT_ALARM_M) ? 1 : 0;
+
+	return 0;
+}
+
+static int rk808_rtc_stop_alarm(struct rk808_rtc *rk808_rtc)
+{
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	int ret;
+
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_INT_REG,
+				 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M, 0);
+
+	return ret;
+}
+
+static int rk808_rtc_start_alarm(struct rk808_rtc *rk808_rtc)
+{
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	int ret;
+
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_INT_REG,
+				 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M,
+				 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+
+	return ret;
+}
+
+static int rk808_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	u8 alrm_data[NUM_ALARM_REGS];
+	int ret;
+
+	ret = rk808_rtc_stop_alarm(rk808_rtc);
+	if (ret) {
+		dev_err(dev, "Failed to stop alarm: %d\n", ret);
+		return ret;
+	}
+	dev_dbg(dev, "alrm set RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
+		1900 + alrm->time.tm_year, alrm->time.tm_mon + 1,
+		alrm->time.tm_mday, alrm->time.tm_wday, alrm->time.tm_hour,
+		alrm->time.tm_min, alrm->time.tm_sec);
+
+	alrm_data[0] = bin2bcd(alrm->time.tm_sec);
+	alrm_data[1] = bin2bcd(alrm->time.tm_min);
+	alrm_data[2] = bin2bcd(alrm->time.tm_hour);
+	alrm_data[3] = bin2bcd(alrm->time.tm_mday);
+	alrm_data[4] = bin2bcd(alrm->time.tm_mon + 1);
+	alrm_data[5] = bin2bcd(alrm->time.tm_year - 100);
+
+	ret = regmap_bulk_write(rk808->regmap, RK808_ALARM_SECONDS_REG,
+				alrm_data, NUM_ALARM_REGS);
+	if (ret) {
+		dev_err(dev, "Failed to bulk write: %d\n", ret);
+		return ret;
+	}
+	if (alrm->enabled) {
+		ret = rk808_rtc_start_alarm(rk808_rtc);
+		if (ret) {
+			dev_err(dev, "Failed to start alarm: %d\n", ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int rk808_rtc_alarm_irq_enable(struct device *dev,
+				      unsigned int enabled)
+{
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(dev);
+
+	if (enabled)
+		return rk808_rtc_start_alarm(rk808_rtc);
+
+	return rk808_rtc_stop_alarm(rk808_rtc);
+}
+
+/*
+ * We will just handle setting the frequency and make use the framework for
+ * reading the periodic interupts.
+ *
+ * @freq: Current periodic IRQ freq:
+ * bit 0: every second
+ * bit 1: every minute
+ * bit 2: every hour
+ * bit 3: every day
+ */
+static irqreturn_t rk808_alarm_irq(int irq, void *data)
+{
+	struct rk808_rtc *rk808_rtc = data;
+	struct rk808 *rk808 = rk808_rtc->rk808;
+	struct i2c_client *client = rk808->i2c;
+	int ret;
+
+	ret = regmap_write(rk808->regmap, RK808_RTC_STATUS_REG,
+			   RTC_STATUS_MASK);
+	if (ret) {
+		dev_err(&client->dev,
+			"%s:Failed to update RTC status: %d\n", __func__, ret);
+		return ret;
+	}
+
+	rtc_update_irq(rk808_rtc->rtc, 1, RTC_IRQF | RTC_AF);
+	dev_dbg(&client->dev,
+		 "%s:irq=%d\n", __func__, irq);
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops rk808_rtc_ops = {
+	.read_time = rk808_rtc_readtime,
+	.set_time = rk808_rtc_set_time,
+	.read_alarm = rk808_rtc_readalarm,
+	.set_alarm = rk808_rtc_setalarm,
+	.alarm_irq_enable = rk808_rtc_alarm_irq_enable,
+};
+
+#ifdef CONFIG_PM_SLEEP
+/* Turn off the alarm if it should not be a wake source. */
+static int rk808_rtc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(&pdev->dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(rk808_rtc->irq);
+
+	return 0;
+}
+
+/* Enable the alarm if it should be enabled (in case it was disabled to
+ * prevent use as a wake source).
+ */
+static int rk808_rtc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rk808_rtc *rk808_rtc = dev_get_drvdata(&pdev->dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(rk808_rtc->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(rk808_rtc_pm_ops,
+	rk808_rtc_suspend, rk808_rtc_resume);
+
+/* 2014.1.1 12:00:00 Saturday */
+struct rtc_time tm_def = {
+			.tm_wday = 6,
+			.tm_year = 114,
+			.tm_mon = 0,
+			.tm_mday = 1,
+			.tm_hour = 12,
+			.tm_min = 0,
+			.tm_sec = 0,
+};
+
+static int rk808_rtc_probe(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct rk808_rtc *rk808_rtc;
+	struct rtc_time tm;
+	int ret;
+
+	rk808_rtc = devm_kzalloc(&pdev->dev, sizeof(*rk808_rtc), GFP_KERNEL);
+	if (rk808_rtc == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, rk808_rtc);
+	rk808_rtc->rk808 = rk808;
+
+	/* start rtc running by default, and use shadowed timer. */
+	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
+				 BIT_RTC_CTRL_REG_STOP_RTC_M |
+				 BIT_RTC_CTRL_REG_RTC_READSEL_M,
+				 BIT_RTC_CTRL_REG_RTC_READSEL_M);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to update RTC control: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_write(rk808->regmap, RK808_RTC_STATUS_REG,
+			   RTC_STATUS_MASK);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to write RTC status: %d\n", ret);
+			return ret;
+	}
+
+	/* set init time */
+	ret = rk808_rtc_readtime(&pdev->dev, &tm);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to read RTC time\n");
+		return ret;
+	}
+	ret = rtc_valid_tm(&tm);
+	if (ret) {
+		dev_warn(&pdev->dev, "invalid date/time and init time\n");
+		rk808_rtc_set_time(&pdev->dev, &tm_def);
+	}
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	rk808_rtc->rtc = devm_rtc_device_register(&pdev->dev, "rk808-rtc",
+						  &rk808_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rk808_rtc->rtc)) {
+		ret = PTR_ERR(rk808_rtc->rtc);
+		return ret;
+	}
+
+	rk808_rtc->irq = platform_get_irq(pdev, 0);
+	if (rk808_rtc->irq < 0) {
+		if (rk808_rtc->irq != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Wake up is not possible as irq = %d\n",
+				rk808_rtc->irq);
+		return rk808_rtc->irq;
+	}
+
+	/* request alarm irq of rk808 */
+	ret = devm_request_threaded_irq(&pdev->dev, rk808_rtc->irq, NULL,
+					rk808_alarm_irq, 0,
+					"RTC alarm", rk808_rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
+			rk808_rtc->irq, ret);
+	}
+
+	return ret;
+}
+
+static struct platform_driver rk808_rtc_driver = {
+	.probe = rk808_rtc_probe,
+	.driver = {
+		.name = "rk808-rtc",
+		.pm = &rk808_rtc_pm_ops,
+	},
+};
+
+module_platform_driver(rk808_rtc_driver);
+
+MODULE_DESCRIPTION("RTC driver for the rk808 series PMICs");
+MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
+MODULE_AUTHOR("Zhang Qing <zhangqing@rock-chips.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk808-rtc");
_

Patches currently in -mm which might be from zyw@rock-chips.com are

rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
linux-next.patch

