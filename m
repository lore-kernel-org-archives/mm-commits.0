From: akpm@linux-foundation.org
Subject: [merged] rtc-s5m-add-support-for-s2mps14-rtc.patch removed from
 -mm tree
Date: Wed, 11 Jun 2014 12:04:09 -0700
Message-ID: <5398a829.p3+cNwzGvcCPyKkW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFKTEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 15:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lee.jones@linaro.org, kyungmin.park@samsung.com, b.zolnierkie@samsung.com, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: [merged] rtc-s5m-add-support-for-s2mps14-rtc.patch removed from -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,b.zolnierkie@samsung.com,kyungmin.park@samsung.com,lee.jones@linaro.org,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 12:04:09 -0700


The patch titled
     Subject: rtc: s5m: add support for S2MPS14 RTC
has been removed from the -mm tree.  Its filename was
     rtc-s5m-add-support-for-s2mps14-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: rtc: s5m: add support for S2MPS14 RTC

Add support for S2MPS14 to the rtc-s5m driver. Differences in S2MPS14
(in comparison to S5M8767):

 - Layout of registers;
 - Lack of century support for time and alarms (7 registers used for
   storing time/alarm);
 - Two buffer control registers: WUDR and RUDR;
 - No register for enabling writing time;
 - RTC interrupts are reported in main PMIC I2C device;

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig   |    4 -
 drivers/rtc/rtc-s5m.c |  103 +++++++++++++++++++++++++++++++++-------
 2 files changed, 87 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-s5m-add-support-for-s2mps14-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-s5m-add-support-for-s2mps14-rtc
+++ a/drivers/rtc/Kconfig
@@ -530,11 +530,11 @@ config RTC_DRV_RV3029C2
 	  will be called rtc-rv3029c2.
 
 config RTC_DRV_S5M
-	tristate "Samsung S5M series"
+	tristate "Samsung S2M/S5M series"
 	depends on MFD_SEC_CORE
 	help
 	  If you say yes here you will get support for the
-	  RTC of Samsung S5M PMIC series.
+	  RTC of Samsung S2MPS14 and S5M PMIC series.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-s5m.
diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-add-support-for-s2mps14-rtc drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-add-support-for-s2mps14-rtc
+++ a/drivers/rtc/rtc-s5m.c
@@ -17,16 +17,14 @@
 
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/slab.h>
 #include <linux/bcd.h>
-#include <linux/bitops.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
-#include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
+#include <linux/mfd/samsung/s2mps14.h>
 
 /*
  * Maximum number of retries for checking changes in UDR field
@@ -74,6 +72,21 @@ static const struct s5m_rtc_reg_config s
 	.rtc_udr_mask		= S5M_RTC_UDR_MASK,
 };
 
+/*
+ * Register map for S2MPS14.
+ * It may be also suitable for S2MPS11 but this was not tested.
+ */
+static const struct s5m_rtc_reg_config s2mps_rtc_regs = {
+	.regs_count		= 7,
+	.time			= S2MPS_RTC_SEC,
+	.ctrl			= S2MPS_RTC_CTRL,
+	.alarm0			= S2MPS_ALARM0_SEC,
+	.alarm1			= S2MPS_ALARM1_SEC,
+	.smpl_wtsr		= S2MPS_WTSR_SMPL_CNTL,
+	.rtc_udr_update		= S2MPS_RTC_UDR_CON,
+	.rtc_udr_mask		= S2MPS_RTC_WUDR_MASK,
+};
+
 struct s5m_rtc_info {
 	struct device *dev;
 	struct i2c_client *i2c;
@@ -178,6 +191,11 @@ static inline int s5m_check_peding_alarm
 		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		val &= S5M_ALARM0_STATUS;
 		break;
+	case S2MPS14X:
+		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
+				&val);
+		val &= S2MPS_ALARM0_STATUS;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -203,8 +221,9 @@ static inline int s5m8767_rtc_set_time_r
 		return ret;
 	}
 
-	data |= S5M_RTC_TIME_EN_MASK;
 	data |= info->regs->rtc_udr_mask;
+	if (info->device_type == S5M8763X || info->device_type == S5M8767X)
+		data |= S5M_RTC_TIME_EN_MASK;
 
 	ret = regmap_write(info->regmap, info->regs->rtc_udr_update, data);
 	if (ret < 0) {
@@ -229,8 +248,18 @@ static inline int s5m8767_rtc_set_alarm_
 		return ret;
 	}
 
-	data &= ~S5M_RTC_TIME_EN_MASK;
 	data |= info->regs->rtc_udr_mask;
+	switch (info->device_type) {
+	case S5M8763X:
+	case S5M8767X:
+		data &= ~S5M_RTC_TIME_EN_MASK;
+		break;
+	case S2MPS14X:
+		data |= S2MPS_RTC_RUDR_MASK;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	ret = regmap_write(info->regmap, info->regs->rtc_udr_update, data);
 	if (ret < 0) {
@@ -282,6 +311,17 @@ static int s5m_rtc_read_time(struct devi
 	u8 data[info->regs->regs_count];
 	int ret;
 
+	if (info->device_type == S2MPS14X) {
+		ret = regmap_update_bits(info->regmap,
+				info->regs->rtc_udr_update,
+				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
+		if (ret) {
+			dev_err(dev,
+				"Failed to prepare registers for time reading: %d\n",
+				ret);
+			return ret;
+		}
+	}
 	ret = regmap_bulk_read(info->regmap, info->regs->time, data,
 			info->regs->regs_count);
 	if (ret < 0)
@@ -293,6 +333,7 @@ static int s5m_rtc_read_time(struct devi
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
 		break;
 
@@ -318,6 +359,7 @@ static int s5m_rtc_set_time(struct devic
 		s5m8763_tm_to_data(tm, data);
 		break;
 	case S5M8767X:
+	case S2MPS14X:
 		ret = s5m8767_tm_to_data(tm, data);
 		break;
 	default:
@@ -364,6 +406,7 @@ static int s5m_rtc_read_alarm(struct dev
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
 		alrm->enabled = 0;
 		for (i = 0; i < info->regs->regs_count; i++) {
@@ -411,6 +454,7 @@ static int s5m_rtc_stop_alarm(struct s5m
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		for (i = 0; i < info->regs->regs_count; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
@@ -454,6 +498,7 @@ static int s5m_rtc_start_alarm(struct s5
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		data[RTC_SEC] |= ALARM_ENABLE_MASK;
 		data[RTC_MIN] |= ALARM_ENABLE_MASK;
 		data[RTC_HOUR] |= ALARM_ENABLE_MASK;
@@ -492,6 +537,7 @@ static int s5m_rtc_set_alarm(struct devi
 		break;
 
 	case S5M8767X:
+	case S2MPS14X:
 		s5m8767_tm_to_data(&alrm->time, data);
 		break;
 
@@ -578,19 +624,33 @@ static int s5m8767_rtc_init_reg(struct s
 	u8 data[2];
 	int ret;
 
-	/* UDR update time. Default of 7.32 ms is too long. */
-	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
-			S5M_RTC_UDR_T_MASK, S5M_RTC_UDR_T_450_US);
-	if (ret < 0)
-		dev_err(info->dev, "%s: fail to change UDR time: %d\n",
-				__func__, ret);
-
-	/* Set RTC control register : Binary mode, 24hour mode */
-	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
-	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+	switch (info->device_type) {
+	case S5M8763X:
+	case S5M8767X:
+		/* UDR update time. Default of 7.32 ms is too long. */
+		ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
+				S5M_RTC_UDR_T_MASK, S5M_RTC_UDR_T_450_US);
+		if (ret < 0)
+			dev_err(info->dev, "%s: fail to change UDR time: %d\n",
+					__func__, ret);
+
+		/* Set RTC control register : Binary mode, 24hour mode */
+		data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+		data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+
+		ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
+		break;
+
+	case S2MPS14X:
+		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
+		break;
+
+	default:
+		return -EINVAL;
+	}
 
 	info->rtc_24hr_mode = 1;
-	ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 			__func__, ret);
@@ -620,6 +680,7 @@ static int s5m_rtc_probe(struct platform
 	switch (pdata->device_type) {
 	case S2MPS14X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
+		info->regs = &s2mps_rtc_regs;
 		break;
 	case S5M8763X:
 		regmap_cfg = &s5m_rtc_regmap_config;
@@ -654,6 +715,11 @@ static int s5m_rtc_probe(struct platform
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
 	switch (pdata->device_type) {
+	case S2MPS14X:
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S2MPS14_IRQ_RTCA0);
+		break;
+
 	case S5M8763X:
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
 				S5M8763_IRQ_ALARM0);
@@ -768,7 +834,8 @@ static int s5m_rtc_suspend(struct device
 static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
 
 static const struct platform_device_id s5m_rtc_id[] = {
-	{ "s5m-rtc", 0 },
+	{ "s5m-rtc",		S5M8767X },
+	{ "s2mps14-rtc",	S2MPS14X },
 };
 
 static struct platform_driver s5m_rtc_driver = {
@@ -787,6 +854,6 @@ module_platform_driver(s5m_rtc_driver);
 
 /* Module information */
 MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
-MODULE_DESCRIPTION("Samsung S5M RTC driver");
+MODULE_DESCRIPTION("Samsung S5M/S2MPS14 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:s5m-rtc");
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
linux-next.patch

