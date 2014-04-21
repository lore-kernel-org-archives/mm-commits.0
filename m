From: akpm@linux-foundation.org
Subject: + rtc-s5m-consolidate-two-device-type-switch-statements.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 15:21:49 -0700
Message-ID: <535599fd.BY18mU7GlaxvwxNw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaDUWVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sbkim73@samsung.com, sameo@linux.intel.com, m.szyprowski@samsung.com, lee.jones@linaro.org, kyungmin.park@samsung.com, b.zolnierkie@samsung.com, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: + rtc-s5m-consolidate-two-device-type-switch-statements.patch added to -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,b.zolnierkie@samsung.com,kyungmin.park@samsung.com,lee.jones@linaro.org,m.szyprowski@samsung.com,sameo@linux.intel.com,sbkim73@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:21:49 -0700


The patch titled
     Subject: rtc: s5m: consolidate two device type switch statements
has been added to the -mm tree.  Its filename is
     rtc-s5m-consolidate-two-device-type-switch-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-s5m-consolidate-two-device-type-switch-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-s5m-consolidate-two-device-type-switch-statements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: rtc: s5m: consolidate two device type switch statements

In probe the configuration of driver for different chipsets was done in
two switch (pdata->device_type) statements.  Consolidate them into one
switch statement to increase code readability.

Additionally check the return value of regmap_irq_get_virq and exit probe
on error.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-consolidate-two-device-type-switch-statements drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-consolidate-two-device-type-switch-statements
+++ a/drivers/rtc/rtc-s5m.c
@@ -666,7 +666,7 @@ static int s5m_rtc_probe(struct platform
 	struct sec_platform_data *pdata = s5m87xx->pdata;
 	struct s5m_rtc_info *info;
 	const struct regmap_config *regmap_cfg;
-	int ret;
+	int ret, alarm_irq;
 
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "Platform data not supplied\n");
@@ -681,14 +681,17 @@ static int s5m_rtc_probe(struct platform
 	case S2MPS14X:
 		regmap_cfg = &s2mps14_rtc_regmap_config;
 		info->regs = &s2mps_rtc_regs;
+		alarm_irq = S2MPS14_IRQ_RTCA0;
 		break;
 	case S5M8763X:
 		regmap_cfg = &s5m_rtc_regmap_config;
 		info->regs = &s5m_rtc_regs;
+		alarm_irq = S5M8763_IRQ_ALARM0;
 		break;
 	case S5M8767X:
 		regmap_cfg = &s5m_rtc_regmap_config;
 		info->regs = &s5m_rtc_regs;
+		alarm_irq = S5M8767_IRQ_RTCA1;
 		break;
 	default:
 		dev_err(&pdev->dev, "Device type is not supported by RTC driver\n");
@@ -714,25 +717,11 @@ static int s5m_rtc_probe(struct platform
 	info->device_type = s5m87xx->device_type;
 	info->wtsr_smpl = s5m87xx->wtsr_smpl;
 
-	switch (pdata->device_type) {
-	case S2MPS14X:
-		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
-				S2MPS14_IRQ_RTCA0);
-		break;
-
-	case S5M8763X:
-		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
-				S5M8763_IRQ_ALARM0);
-		break;
-
-	case S5M8767X:
-		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
-				S5M8767_IRQ_RTCA1);
-		break;
