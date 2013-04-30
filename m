From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-at91sam9-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:55 -0700
Message-ID: <20130430185955.719BB31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52391 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233Ab3D3S74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:56 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87333vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-at91sam9: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91sam9-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-at91sam9: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-rtc-at91sam9-use-devm_-functions drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-rtc-at91sam9-use-devm_-functions
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -20,6 +20,7 @@
 #include <linux/ioctl.h>
 #include <linux/slab.h>
 #include <linux/platform_data/atmel.h>
+#include <linux/io.h>
 
 #include <mach/at91_rtt.h>
 #include <mach/cpu.h>
@@ -309,7 +310,7 @@ static int at91_rtc_probe(struct platfor
 		return irq;
 	}
 
-	rtc = kzalloc(sizeof *rtc, GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
@@ -320,18 +321,19 @@ static int at91_rtc_probe(struct platfor
 		device_init_wakeup(&pdev->dev, 1);
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtt = ioremap(r->start, resource_size(r));
+	rtc->rtt = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!rtc->rtt) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
 
-	rtc->gpbr = ioremap(r_gpbr->start, resource_size(r_gpbr));
+	rtc->gpbr = devm_ioremap(&pdev->dev, r_gpbr->start,
+				resource_size(r_gpbr));
 	if (!rtc->gpbr) {
 		dev_err(&pdev->dev, "failed to map gpbr registers, aborting.\n");
 		ret = -ENOMEM;
-		goto fail_gpbr;
+		goto fail;
 	}
 
 	mr = rtt_readl(rtc, MR);
@@ -346,20 +348,19 @@ static int at91_rtc_probe(struct platfor
 	mr &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
 	rtt_writel(rtc, MR, mr);
 
-	rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
-				&at91_rtc_ops, THIS_MODULE);
+	rtc->rtcdev = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtcdev)) {
 		ret = PTR_ERR(rtc->rtcdev);
-		goto fail_register;
+		goto fail;
 	}
 
 	/* register irq handler after we know what name we'll use */
-	ret = request_irq(rtc->irq, at91_rtc_interrupt, IRQF_SHARED,
-				dev_name(&rtc->rtcdev->dev), rtc);
+	ret = devm_request_irq(&pdev->dev, rtc->irq, at91_rtc_interrupt,
+				IRQF_SHARED, dev_name(&rtc->rtcdev->dev), rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", rtc->irq);
-		rtc_device_unregister(rtc->rtcdev);
-		goto fail_register;
+		goto fail;
 	}
 
 	/* NOTE:  sam9260 rev A silicon has a ROM bug which resets the
@@ -374,13 +375,8 @@ static int at91_rtc_probe(struct platfor
 
 	return 0;
 
-fail_register:
-	iounmap(rtc->gpbr);
-fail_gpbr:
-	iounmap(rtc->rtt);
 fail:
 	platform_set_drvdata(pdev, NULL);
-	kfree(rtc);
 	return ret;
 }
 
@@ -394,14 +390,8 @@ static int at91_rtc_remove(struct platfo
 
 	/* disable all interrupts */
 	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
-	free_irq(rtc->irq, rtc);
