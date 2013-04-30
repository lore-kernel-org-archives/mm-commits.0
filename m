From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-imxdi-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:48 -0700
Message-ID: <20130430185548.610525A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47879 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab3D3Szt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88221qab.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-imxdi: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-imxdi-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-imxdi: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-use-devm_rtc_device_register drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-imxdi.c
@@ -464,7 +464,7 @@ static int __init dryice_rtc_probe(struc
 	}
 
 	platform_set_drvdata(pdev, imxdi);
-	imxdi->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	imxdi->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &dryice_rtc_ops, THIS_MODULE);
 	if (IS_ERR(imxdi->rtc)) {
 		rc = PTR_ERR(imxdi->rtc);
@@ -488,8 +488,6 @@ static int __exit dryice_rtc_remove(stru
 	/* mask all interrupts */
 	__raw_writel(0, imxdi->ioaddr + DIER);
 
-	rtc_device_unregister(imxdi->rtc);
