From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pxac-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:53 -0700
Message-ID: <20130411230153.CB4F231C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36934 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3DKXBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:55 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so196665ggn.3
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, robert.jarzmik@free.fr


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pxac-use-devm_-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-pxa.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   41 +++++++++++-----------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-use-devm_-apis drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-use-devm_-apis
+++ a/drivers/rtc/rtc-pxa.c
@@ -364,7 +364,7 @@ static int __init pxa_rtc_probe(struct p
 	int ret;
 	u32 rttr;
 
-	pxa_rtc = kzalloc(sizeof(struct pxa_rtc), GFP_KERNEL);
+	pxa_rtc = devm_kzalloc(dev, sizeof(struct pxa_rtc), GFP_KERNEL);
 	if (!pxa_rtc)
 		return -ENOMEM;
 	rtc_info = pxa_rtc;
@@ -375,37 +375,37 @@ static int __init pxa_rtc_probe(struct p
 	pxa_rtc->ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!pxa_rtc->ress) {
 		dev_err(dev, "No I/O memory resource defined\n");
-		goto err_ress;
+		return ret;
 	}
 	pxa_rtc->ress_psbr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!pxa_rtc->ress_psbr) {
 		dev_err(dev, "No I/O memory resource defined\n");
-		goto err_ress;
+		return ret;
 	}
 
 	pxa_rtc->irq_1Hz = platform_get_irq(pdev, 0);
 	if (pxa_rtc->irq_1Hz < 0) {
 		dev_err(dev, "No 1Hz IRQ resource defined\n");
-		goto err_ress;
+		return ret;
 	}
 	pxa_rtc->irq_Alrm = platform_get_irq(pdev, 1);
 	if (pxa_rtc->irq_Alrm < 0) {
 		dev_err(dev, "No alarm IRQ resource defined\n");
-		goto err_ress;
+		return ret;
 	}
 	ret = -ENOMEM;
-	pxa_rtc->base = ioremap(pxa_rtc->ress->start,
+	pxa_rtc->base = devm_ioremap(&pdev->dev, pxa_rtc->ress->start,
 				resource_size(pxa_rtc->ress));
 	if (!pxa_rtc->base) {
 		dev_err(&pdev->dev, "Unable to map pxa RTC I/O memory\n");
-		goto err_map;
+		return ret;
 	}
 
-	pxa_rtc->base_psbr = ioremap(pxa_rtc->ress_psbr->start,
+	pxa_rtc->base_psbr = devm_ioremap(&pdev->dev, pxa_rtc->ress_psbr->start,
 				resource_size(pxa_rtc->ress_psbr));
 	if (!pxa_rtc->base_psbr) {
 		dev_err(&pdev->dev, "Unable to map pxa RTC PSBR I/O memory\n");
-		goto err_map;
+		return ret;
 	}
 	/*
 	 * If the clock divider is uninitialized then reset it to the
@@ -420,41 +420,24 @@ static int __init pxa_rtc_probe(struct p
 
 	rtsr_clear_bits(pxa_rtc, RTSR_PIALE | RTSR_RDALE1 | RTSR_HZE);
 
-	pxa_rtc->rtc = rtc_device_register("pxa-rtc", &pdev->dev, &pxa_rtc_ops,
-					   THIS_MODULE);
+	pxa_rtc->rtc = devm_rtc_device_register(&pdev->dev, "pxa-rtc",
+						&pxa_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(pxa_rtc->rtc);
 	if (IS_ERR(pxa_rtc->rtc)) {
 		dev_err(dev, "Failed to register RTC device -> %d\n", ret);
-		goto err_rtc_reg;
+		return ret;
 	}
 
 	device_init_wakeup(dev, 1);
 	pxa_rtc_open(dev);
 	return 0;
-
-err_rtc_reg:
-	 iounmap(pxa_rtc->base);
-err_ress:
-err_map:
-	kfree(pxa_rtc);
-	return ret;
 }
 
 static int __exit pxa_rtc_remove(struct platform_device *pdev)
 {
-	struct pxa_rtc *pxa_rtc = platform_get_drvdata(pdev);
-
 	struct device *dev = &pdev->dev;
 	pxa_rtc_release(dev);
 
-	rtc_device_unregister(pxa_rtc->rtc);
-
-	spin_lock_irq(&pxa_rtc->lock);
-	iounmap(pxa_rtc->base);
-	spin_unlock_irq(&pxa_rtc->lock);
-
-	kfree(pxa_rtc);
