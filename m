From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ep93xx-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:46 -0700
Message-ID: <20130430185546.71FE95A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37789 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab3D3Szr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:47 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86441yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ep93xx: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ep93xx-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ep93xx: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ep93xx.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-ep93xx.c~rtc-rtc-ep93xx-use-devm_rtc_device_register drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-rtc-ep93xx-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -153,8 +153,8 @@ static int ep93xx_rtc_probe(struct platf
 	pdev->dev.platform_data = ep93xx_rtc;
 	platform_set_drvdata(pdev, ep93xx_rtc);
 
-	ep93xx_rtc->rtc = rtc_device_register(pdev->name,
-				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
+	ep93xx_rtc->rtc = devm_rtc_device_register(&pdev->dev,
+				pdev->name, &ep93xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ep93xx_rtc->rtc)) {
 		err = PTR_ERR(ep93xx_rtc->rtc);
 		goto exit;
@@ -162,12 +162,10 @@ static int ep93xx_rtc_probe(struct platf
 
 	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
-		goto fail;
+		goto exit;
 
 	return 0;
 
-fail:
-	rtc_device_unregister(ep93xx_rtc->rtc);
 exit:
 	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
@@ -176,11 +174,8 @@ exit:
 
 static int ep93xx_rtc_remove(struct platform_device *pdev)
 {
-	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
