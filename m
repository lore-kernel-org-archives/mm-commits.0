From: akpm@linux-foundation.org
Subject: [wrecked] drivers-rtc-rtc-pxac-use-devm_-apis.patch removed from -mm tree
Date: Thu, 09 May 2013 13:42:48 -0700
Message-ID: <20130509204249.2D97131C1AD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:50283 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3EIUmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:42:50 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so320038ghr.0
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:42:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, robert.jarzmik@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pxac-use-devm_-apis.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch

