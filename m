From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max8907-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:56 -0700
Message-ID: <20130430185556.6F5AC5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46071 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab3D3Sz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:57 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86883vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max8907: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max8907-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max8907: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8907.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-max8907.c~rtc-rtc-max8907-use-devm_rtc_device_register drivers/rtc/rtc-max8907.c
--- a/drivers/rtc/rtc-max8907.c~rtc-rtc-max8907-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-max8907.c
@@ -190,7 +190,7 @@ static int max8907_rtc_probe(struct plat
 	rtc->max8907 = max8907;
 	rtc->regmap = max8907->regmap_rtc;
 
-	rtc->rtc_dev = rtc_device_register("max8907-rtc", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8907-rtc",
 					&max8907_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
@@ -217,16 +217,11 @@ static int max8907_rtc_probe(struct plat
 	return 0;
 
 err_unregister:
-	rtc_device_unregister(rtc->rtc_dev);
 	return ret;
 }
 
 static int max8907_rtc_remove(struct platform_device *pdev)
 {
-	struct max8907_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rtc_dev);
