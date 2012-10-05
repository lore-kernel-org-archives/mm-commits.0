From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:57 -0700
Message-ID: <20121005201757.A3DA0100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50910 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:58 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236805vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: use platform_get_irq() to get RTC irq details
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: use platform_get_irq() to get RTC irq details

As RTC driver needs only irq number from platform data, using
platform_get_irq(), instead of generic dev_get_platdata().

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-use-platform_get_irq-to-get-rtc-irq-details
+++ a/drivers/rtc/rtc-tps65910.c
@@ -226,7 +226,6 @@ static int __devinit tps65910_rtc_probe(
 {
 	struct tps65910 *tps65910 = NULL;
 	struct tps65910_rtc *tps_rtc = NULL;
-	struct tps65910_board *pmic_plat_data;
 	int ret;
 	int irq;
 	u32 rtc_reg;
@@ -253,15 +252,13 @@ static int __devinit tps65910_rtc_probe(
 	if (ret < 0)
 		return ret;
 
-	pmic_plat_data = dev_get_platdata(tps65910->dev);
-	irq = pmic_plat_data->irq_base;
+	irq  = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
 			irq);
 		return ret;
 	}
 
-	irq += TPS65910_IRQ_RTC_ALARM;
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
 		"rtc-tps65910", &pdev->dev);
_

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
linux-next.patch

