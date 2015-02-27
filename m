From: akpm@linux-foundation.org
Subject: [merged]
 rtc-s5m-remove-unused-watchdog-and-sudden-momentary-power-loss.patch
 removed from -mm tree
Date: Fri, 27 Feb 2015 11:52:36 -0800
Message-ID: <54f0cb04.4YMD8Gz6lObW/Jmb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbbB0Twh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 14:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, lee.jones@linaro.org, m.szyprowski@samsung.com, sameo@linux.intel.com, sbkim73@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: remove unused watchdog and sudden momentary power loss
has been removed from the -mm tree.  Its filename was
     rtc-s5m-remove-unused-watchdog-and-sudden-momentary-power-loss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-s5m.c: remove unused watchdog and sudden momentary power loss

The WTSR (Watchdog Timer Software Reset) and SMPL (Sudden Momentary Power
Loss) are never enabled.  These are left-overs from board files.  After
removing them the driver's shutdown callback is empty so get rid of it as
well.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   60 ----------------------------------------
 1 file changed, 60 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-remove-unused-watchdog-and-sudden-momentary-power-loss drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-remove-unused-watchdog-and-sudden-momentary-power-loss
+++ a/drivers/rtc/rtc-s5m.c
@@ -48,8 +48,6 @@ struct s5m_rtc_reg_config {
 	unsigned int alarm0;
 	/* First register for alarm 1, seconds */
 	unsigned int alarm1;
-	/* SMPL/WTSR register */
-	unsigned int smpl_wtsr;
 	/*
 	 * Register for update flag (UDR). Typically setting UDR field to 1
 	 * will enable update of time or alarm register. Then it will be
@@ -67,7 +65,6 @@ static const struct s5m_rtc_reg_config s
 	.ctrl			= S5M_ALARM1_CONF,
 	.alarm0			= S5M_ALARM0_SEC,
 	.alarm1			= S5M_ALARM1_SEC,
-	.smpl_wtsr		= S5M_WTSR_SMPL_CNTL,
 	.rtc_udr_update		= S5M_RTC_UDR_CON,
 	.rtc_udr_mask		= S5M_RTC_UDR_MASK,
 };
@@ -82,7 +79,6 @@ static const struct s5m_rtc_reg_config s
 	.ctrl			= S2MPS_RTC_CTRL,
 	.alarm0			= S2MPS_ALARM0_SEC,
 	.alarm1			= S2MPS_ALARM1_SEC,
-	.smpl_wtsr		= S2MPS_WTSR_SMPL_CNTL,
 	.rtc_udr_update		= S2MPS_RTC_UDR_CON,
 	.rtc_udr_mask		= S2MPS_RTC_WUDR_MASK,
 };
@@ -96,7 +92,6 @@ struct s5m_rtc_info {
 	int irq;
 	int device_type;
 	int rtc_24hr_mode;
-	bool wtsr_smpl;
 	const struct s5m_rtc_reg_config	*regs;
 };
 
@@ -597,28 +592,6 @@ static const struct rtc_class_ops s5m_rt
 	.alarm_irq_enable = s5m_rtc_alarm_irq_enable,
 };
 
-static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
-{
-	int ret;
-	ret = regmap_update_bits(info->regmap, info->regs->smpl_wtsr,
-				 WTSR_ENABLE_MASK,
-				 enable ? WTSR_ENABLE_MASK : 0);
-	if (ret < 0)
-		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
-			__func__, ret);
-}
-
-static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
-{
-	int ret;
-	ret = regmap_update_bits(info->regmap, info->regs->smpl_wtsr,
-				 SMPL_ENABLE_MASK,
-				 enable ? SMPL_ENABLE_MASK : 0);
-	if (ret < 0)
-		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
-			__func__, ret);
-}
-
 static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 {
 	u8 data[2];
@@ -715,7 +688,6 @@ static int s5m_rtc_probe(struct platform
 	info->dev = &pdev->dev;
 	info->s5m87xx = s5m87xx;
 	info->device_type = s5m87xx->device_type;
-	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
 	if (s5m87xx->irq_data) {
 		info->irq = regmap_irq_get_virq(s5m87xx->irq_data, alarm_irq);
@@ -731,11 +703,6 @@ static int s5m_rtc_probe(struct platform
 
 	ret = s5m8767_rtc_init_reg(info);
 
-	if (info->wtsr_smpl) {
-		s5m_rtc_enable_wtsr(info, true);
-		s5m_rtc_enable_smpl(info, true);
-	}
-
 	device_init_wakeup(&pdev->dev, 1);
 
 	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "s5m-rtc",
@@ -768,36 +735,10 @@ err:
 	return ret;
 }
 
-static void s5m_rtc_shutdown(struct platform_device *pdev)
-{
-	struct s5m_rtc_info *info = platform_get_drvdata(pdev);
-	int i;
-	unsigned int val = 0;
-	if (info->wtsr_smpl) {
-		for (i = 0; i < 3; i++) {
-			s5m_rtc_enable_wtsr(info, false);
-			regmap_read(info->regmap, info->regs->smpl_wtsr, &val);
-			pr_debug("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
-			if (val & WTSR_ENABLE_MASK)
-				pr_emerg("%s: fail to disable WTSR\n",
-					 __func__);
-			else {
-				pr_info("%s: success to disable WTSR\n",
-					__func__);
-				break;
-			}
-		}
-	}
-	/* Disable SMPL when power off */
-	s5m_rtc_enable_smpl(info, false);
-}
