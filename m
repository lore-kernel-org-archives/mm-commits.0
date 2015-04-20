From: akpm@linux-foundation.org
Subject: [merged] rtc-s5m-add-support-for-s2mps13-rtc.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:18:04 -0700
Message-ID: <553550ec.ZlL2v9EbYPWOPUmE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbbDTTLn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: add support for S2MPS13 RTC
has been removed from the -mm tree.  Its filename was
     rtc-s5m-add-support-for-s2mps13-rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-s5m.c: add support for S2MPS13 RTC

The S2MPS13 RTC is almost the same as S2MPS14. The differences when
updating alarm are:
1. Set WUDR+AUDR field instead of WUDR+RUDR.
2. Clear the AUDR field later (it is not auto-cleared).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c           |   20 +++++++++++++++++++-
 include/linux/mfd/samsung/rtc.h |    2 ++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-add-support-for-s2mps13-rtc drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-add-support-for-s2mps13-rtc
+++ a/drivers/rtc/rtc-s5m.c
@@ -187,6 +187,7 @@ static inline int s5m_check_peding_alarm
 		val &= S5M_ALARM0_STATUS;
 		break;
 	case S2MPS14X:
+	case S2MPS13X:
 		ret = regmap_read(info->s5m87xx->regmap_pmic, S2MPS14_REG_ST2,
 				&val);
 		val &= S2MPS_ALARM0_STATUS;
@@ -252,6 +253,9 @@ static inline int s5m8767_rtc_set_alarm_
 	case S2MPS14X:
 		data |= S2MPS_RTC_RUDR_MASK;
 		break;
+	case S2MPS13X:
+		data |= S2MPS13_RTC_AUDR_MASK;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -265,6 +269,11 @@ static inline int s5m8767_rtc_set_alarm_
 
 	ret = s5m8767_wait_for_udr_update(info);
 
+	/* On S2MPS13 the AUDR is not auto-cleared */
+	if (info->device_type == S2MPS13X)
+		regmap_update_bits(info->regmap, info->regs->rtc_udr_update,
+				   S2MPS13_RTC_AUDR_MASK, 0);
+
 	return ret;
 }
 
@@ -306,7 +315,7 @@ static int s5m_rtc_read_time(struct devi
 	u8 data[info->regs->regs_count];
 	int ret;
 
-	if (info->device_type == S2MPS14X) {
+	if (info->device_type == S2MPS14X || info->device_type == S2MPS13X) {
 		ret = regmap_update_bits(info->regmap,
 				info->regs->rtc_udr_update,
 				S2MPS_RTC_RUDR_MASK, S2MPS_RTC_RUDR_MASK);
@@ -329,6 +338,7 @@ static int s5m_rtc_read_time(struct devi
 
 	case S5M8767X:
 	case S2MPS14X:
+	case S2MPS13X:
 		s5m8767_data_to_tm(data, tm, info->rtc_24hr_mode);
 		break;
 
@@ -355,6 +365,7 @@ static int s5m_rtc_set_time(struct devic
 		break;
 	case S5M8767X:
 	case S2MPS14X:
+	case S2MPS13X:
 		ret = s5m8767_tm_to_data(tm, data);
 		break;
 	default:
@@ -402,6 +413,7 @@ static int s5m_rtc_read_alarm(struct dev
 
 	case S5M8767X:
 	case S2MPS14X:
+	case S2MPS13X:
 		s5m8767_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
 		alrm->enabled = 0;
 		for (i = 0; i < info->regs->regs_count; i++) {
@@ -450,6 +462,7 @@ static int s5m_rtc_stop_alarm(struct s5m
 
 	case S5M8767X:
 	case S2MPS14X:
+	case S2MPS13X:
 		for (i = 0; i < info->regs->regs_count; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
@@ -494,6 +507,7 @@ static int s5m_rtc_start_alarm(struct s5
 
 	case S5M8767X:
 	case S2MPS14X:
+	case S2MPS13X:
 		data[RTC_SEC] |= ALARM_ENABLE_MASK;
 		data[RTC_MIN] |= ALARM_ENABLE_MASK;
 		data[RTC_HOUR] |= ALARM_ENABLE_MASK;
@@ -533,6 +547,7 @@ static int s5m_rtc_set_alarm(struct devi
 
 	case S5M8767X:
 	case S2MPS14X:
+	case S2MPS13X:
 		s5m8767_tm_to_data(&alrm->time, data);
 		break;
 
@@ -615,6 +630,7 @@ static int s5m8767_rtc_init_reg(struct s
 		break;
 
 	case S2MPS14X:
+	case S2MPS13X:
 		data[0] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 		ret = regmap_write(info->regmap, info->regs->ctrl, data[0]);
 		break;
@@ -652,6 +668,7 @@ static int s5m_rtc_probe(struct platform
 
 	switch (pdata->device_type) {
 	case S2MPS14X:
+	case S2MPS13X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
 		info->regs = &s2mps_rtc_regs;
 		alarm_irq = S2MPS14_IRQ_RTCA0;
@@ -772,6 +789,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops,
 
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc",		S5M8767X },
+	{ "s2mps13-rtc",	S2MPS13X },
 	{ "s2mps14-rtc",	S2MPS14X },
 	{ },
 };
diff -puN include/linux/mfd/samsung/rtc.h~rtc-s5m-add-support-for-s2mps13-rtc include/linux/mfd/samsung/rtc.h
--- a/include/linux/mfd/samsung/rtc.h~rtc-s5m-add-support-for-s2mps13-rtc
+++ a/include/linux/mfd/samsung/rtc.h
@@ -105,6 +105,8 @@ enum s2mps_rtc_reg {
 #define S5M_RTC_UDR_MASK	(1 << S5M_RTC_UDR_SHIFT)
 #define S2MPS_RTC_WUDR_SHIFT	4
 #define S2MPS_RTC_WUDR_MASK	(1 << S2MPS_RTC_WUDR_SHIFT)
+#define S2MPS13_RTC_AUDR_SHIFT	1
+#define S2MPS13_RTC_AUDR_MASK	(1 << S2MPS13_RTC_AUDR_SHIFT)
 #define S2MPS_RTC_RUDR_SHIFT	0
 #define S2MPS_RTC_RUDR_MASK	(1 << S2MPS_RTC_RUDR_SHIFT)
 #define RTC_TCON_SHIFT		1
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
linux-next.patch

