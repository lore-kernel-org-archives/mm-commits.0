From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-palmas-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:05 -0700
Message-ID: <20130430185605.715B131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:48646 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3D3S4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:06 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86837qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-palmas: use devm_rtc_device_register() and devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-palmas-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-palmas: use devm_rtc_device_register() and devm_request_threaded_irq()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Also, use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-palmas.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-palmas.c~rtc-rtc-palmas-use-devm_rtc_device_register drivers/rtc/rtc-palmas.c
--- a/drivers/rtc/rtc-palmas.c~rtc-rtc-palmas-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-palmas.c
@@ -264,7 +264,7 @@ static int palmas_rtc_probe(struct platf
 
 	palmas_rtc->irq = platform_get_irq(pdev, 0);
 
-	palmas_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	palmas_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&palmas_rtc_ops, THIS_MODULE);
 	if (IS_ERR(palmas_rtc->rtc)) {
 		ret = PTR_ERR(palmas_rtc->rtc);
@@ -272,14 +272,13 @@ static int palmas_rtc_probe(struct platf
 		return ret;
 	}
 
-	ret = request_threaded_irq(palmas_rtc->irq, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, palmas_rtc->irq, NULL,
 			palmas_rtc_interrupt,
 			IRQF_TRIGGER_LOW | IRQF_ONESHOT |
 			IRQF_EARLY_RESUME,
 			dev_name(&pdev->dev), palmas_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ request failed, err = %d\n", ret);
-		rtc_device_unregister(palmas_rtc->rtc);
 		return ret;
 	}
 
@@ -289,11 +288,7 @@ static int palmas_rtc_probe(struct platf
 
 static int palmas_rtc_remove(struct platform_device *pdev)
 {
-	struct palmas_rtc *palmas_rtc = platform_get_drvdata(pdev);
