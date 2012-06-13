From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch added to -mm tree
Date: Wed, 13 Jun 2012 14:08:14 -0700
Message-ID: <20120613210815.0BFABA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:32829 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2FMVIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 17:08:16 -0400
Received: by qabg24 with SMTP id g24so201616qab.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 14:08:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare/unprepare

Patches currently in -mm which might be from linus.walleij@linaro.org are

linux-next.patch
drivers-rtc-rtc-coh901331c-use-clk_prepare-unprepare.patch
drivers-rtc-rtc-coh901331c-use-devm-allocation.patch

