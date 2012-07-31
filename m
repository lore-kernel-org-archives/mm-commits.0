From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:01 -0700
Message-ID: <20120731185202.12C1420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:62249 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2GaSwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:52:05 -0400
Received: by lagr15 with SMTP id r15so292297lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare

Make sure we prepare/unprepare the clock for the COH901331 RTC driver as
is required by the clk API especially if you use common clock.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare
+++ a/drivers/rtc/rtc-coh901331.c
@@ -157,6 +157,7 @@ static int __exit coh901331_remove(struc
 	if (rtap) {
 		free_irq(rtap->irq, rtap);
 		rtc_device_unregister(rtap->rtc);
+		clk_unprepare(rtap->clk);
 		clk_put(rtap->clk);
 		iounmap(rtap->virtbase);
 		release_mem_region(rtap->phybase, rtap->physize);
@@ -213,10 +214,10 @@ static int __init coh901331_probe(struct
 	}
 
 	/* We enable/disable the clock only to assure it works */
-	ret = clk_enable(rtap->clk);
+	ret = clk_prepare_enable(rtap->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "could not enable clock\n");
-		goto out_no_clk_enable;
+		goto out_no_clk_prepenable;
 	}
 	clk_disable(rtap->clk);
 
@@ -232,7 +233,8 @@ static int __init coh901331_probe(struct
 
  out_no_rtc:
 	platform_set_drvdata(pdev, NULL);
- out_no_clk_enable:
+	clk_unprepare(rtap->clk);
+ out_no_clk_prepenable:
 	clk_put(rtap->clk);
  out_no_clk:
 	free_irq(rtap->irq, rtap);
@@ -265,6 +267,7 @@ static int coh901331_suspend(struct plat
 		writel(0, rtap->virtbase + COH901331_IRQ_MASK);
 		clk_disable(rtap->clk);
 	}
+	clk_unprepare(rtap->clk);
 	return 0;
 }
 
@@ -272,6 +275,7 @@ static int coh901331_resume(struct platf
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
+	clk_prepare(rtap->clk);
 	if (device_may_wakeup(&pdev->dev)) {
 		disable_irq_wake(rtap->irq);
 	} else {
@@ -293,6 +297,7 @@ static void coh901331_shutdown(struct pl
 	clk_enable(rtap->clk);
 	writel(0, rtap->virtbase + COH901331_IRQ_MASK);
 	clk_disable(rtap->clk);
+	clk_unprepare(rtap->clk);
 }
 
 static struct platform_driver coh901331_driver = {
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch

