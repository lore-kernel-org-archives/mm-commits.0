From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-nuc900-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:31 -0700
Message-ID: <20130430190031.7038E31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45605 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3D3TAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:32 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so87369qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-nuc900: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-nuc900-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-nuc900: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |   53 +++++++------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-use-devm_-functions drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-use-devm_-functions
+++ a/drivers/rtc/rtc-nuc900.c
@@ -226,9 +226,9 @@ static int __init nuc900_rtc_probe(struc
 {
 	struct resource *res;
 	struct nuc900_rtc *nuc900_rtc;
-	int err = 0;
 
-	nuc900_rtc = kzalloc(sizeof(struct nuc900_rtc), GFP_KERNEL);
+	nuc900_rtc = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_rtc),
+				GFP_KERNEL);
 	if (!nuc900_rtc) {
 		dev_err(&pdev->dev, "kzalloc nuc900_rtc failed\n");
 		return -ENOMEM;
@@ -236,68 +236,37 @@ static int __init nuc900_rtc_probe(struc
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "platform_get_resource failed\n");
-		err = -ENXIO;
-		goto fail1;
+		return -ENXIO;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res),
-				pdev->name)) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		err = -EBUSY;
-		goto fail1;
-	}
-
-	nuc900_rtc->rtc_reg = ioremap(res->start, resource_size(res));
-	if (!nuc900_rtc->rtc_reg) {
-		dev_err(&pdev->dev, "ioremap rtc_reg failed\n");
-		err = -ENOMEM;
-		goto fail2;
-	}
+	nuc900_rtc->rtc_reg = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(nuc900_rtc->rtc_reg))
+		return PTR_ERR(nuc900_rtc->rtc_reg);
 
 	platform_set_drvdata(pdev, nuc900_rtc);
 
-	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
+	nuc900_rtc->rtcdev = devm_rtc_device_register(&pdev->dev, pdev->name,
 						&nuc900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(nuc900_rtc->rtcdev)) {
 		dev_err(&pdev->dev, "rtc device register failed\n");
-		err = PTR_ERR(nuc900_rtc->rtcdev);
-		goto fail3;
+		return PTR_ERR(nuc900_rtc->rtcdev);
 	}
 
 	__raw_writel(__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_TSSR) | MODE24,
 					nuc900_rtc->rtc_reg + REG_RTC_TSSR);
 
 	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
-	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
-				0, "nuc900rtc", nuc900_rtc)) {
+	if (devm_request_irq(&pdev->dev, nuc900_rtc->irq_num,
+			nuc900_rtc_interrupt, 0, "nuc900rtc", nuc900_rtc)) {
 		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
-		err = -EBUSY;
-		goto fail4;
+		return -EBUSY;
 	}
 
 	return 0;
-
-fail4:	rtc_device_unregister(nuc900_rtc->rtcdev);
-fail3:	iounmap(nuc900_rtc->rtc_reg);
-fail2:	release_mem_region(res->start, resource_size(res));
-fail1:	kfree(nuc900_rtc);
-	return err;
 }
 
 static int __exit nuc900_rtc_remove(struct platform_device *pdev)
 {
-	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
-	rtc_device_unregister(nuc900_rtc->rtcdev);
-	iounmap(nuc900_rtc->rtc_reg);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(nuc900_rtc);
