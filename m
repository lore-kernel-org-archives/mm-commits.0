From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pxa-use-devm_-functions.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:33:32 -0700
Message-ID: <51db140c.MlT/GVzZlY0OIaqy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3GHTdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-pxa-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:32 -0700


The patch titled
     Subject: rtc: rtc-pxa: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pxa-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pxa: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   43 +++++++++++-----------------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~rtc-rtc-pxa-use-devm_-functions drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-rtc-pxa-use-devm_-functions
+++ a/drivers/rtc/rtc-pxa.c
@@ -324,37 +324,35 @@ static int __init pxa_rtc_probe(struct p
 	int ret;
 	u32 rttr;
 
-	pxa_rtc = kzalloc(sizeof(struct pxa_rtc), GFP_KERNEL);
+	pxa_rtc = devm_kzalloc(dev, sizeof(*pxa_rtc), GFP_KERNEL);
 	if (!pxa_rtc)
 		return -ENOMEM;
 
 	spin_lock_init(&pxa_rtc->lock);
 	platform_set_drvdata(pdev, pxa_rtc);
 
-	ret = -ENXIO;
 	pxa_rtc->ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!pxa_rtc->ress) {
 		dev_err(dev, "No I/O memory resource defined\n");
-		goto err_ress;
+		return -ENXIO;
 	}
 
 	pxa_rtc->irq_1Hz = platform_get_irq(pdev, 0);
 	if (pxa_rtc->irq_1Hz < 0) {
 		dev_err(dev, "No 1Hz IRQ resource defined\n");
-		goto err_ress;
+		return -ENXIO;
 	}
 	pxa_rtc->irq_Alrm = platform_get_irq(pdev, 1);
 	if (pxa_rtc->irq_Alrm < 0) {
 		dev_err(dev, "No alarm IRQ resource defined\n");
-		goto err_ress;
+		return -ENXIO;
 	}
 	pxa_rtc_open(dev);
-	ret = -ENOMEM;
-	pxa_rtc->base = ioremap(pxa_rtc->ress->start,
+	pxa_rtc->base = devm_ioremap(dev, pxa_rtc->ress->start,
 				resource_size(pxa_rtc->ress));
 	if (!pxa_rtc->base) {
-		dev_err(&pdev->dev, "Unable to map pxa RTC I/O memory\n");
-		goto err_map;
+		dev_err(dev, "Unable to map pxa RTC I/O memory\n");
+		return -ENOMEM;
 	}
 
 	/*
@@ -370,41 +368,24 @@ static int __init pxa_rtc_probe(struct p
 
 	rtsr_clear_bits(pxa_rtc, RTSR_PIALE | RTSR_RDALE1 | RTSR_HZE);
 
-	pxa_rtc->rtc = rtc_device_register("pxa-rtc", &pdev->dev, &pxa_rtc_ops,
-					   THIS_MODULE);
-	ret = PTR_ERR(pxa_rtc->rtc);
+	pxa_rtc->rtc = devm_rtc_device_register(&pdev->dev, "pxa-rtc",
+						&pxa_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pxa_rtc->rtc)) {
+		ret = PTR_ERR(pxa_rtc->rtc);
 		dev_err(dev, "Failed to register RTC device -> %d\n", ret);
-		goto err_rtc_reg;
+		return ret;
 	}
 
 	device_init_wakeup(dev, 1);
 
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
-	pxa_rtc_release(dev);
-
-	rtc_device_unregister(pxa_rtc->rtc);
-
-	spin_lock_irq(&pxa_rtc->lock);
-	iounmap(pxa_rtc->base);
-	spin_unlock_irq(&pxa_rtc->lock);
