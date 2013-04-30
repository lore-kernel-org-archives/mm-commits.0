From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max8998-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:23 -0700
Message-ID: <20130430190023.6E7A831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40453 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3TAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:24 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87411yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max8998: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max8998-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max8998: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8998.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-max8998.c~rtc-rtc-max8998-use-devm_-functions drivers/rtc/rtc-max8998.c
--- a/drivers/rtc/rtc-max8998.c~rtc-rtc-max8998-use-devm_-functions
+++ a/drivers/rtc/rtc-max8998.c
@@ -256,7 +256,8 @@ static int max8998_rtc_probe(struct plat
 	struct max8998_rtc_info *info;
 	int ret;
 
-	info = kzalloc(sizeof(struct max8998_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max8998_rtc_info),
+			GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -267,7 +268,7 @@ static int max8998_rtc_probe(struct plat
 
 	platform_set_drvdata(pdev, info);
 
-	info->rtc_dev = rtc_device_register("max8998-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8998-rtc",
 			&max8998_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
@@ -276,8 +277,8 @@ static int max8998_rtc_probe(struct plat
 		goto out_rtc;
 	}
 
-	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
-			"rtc-alarm0", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
+				max8998_rtc_alarm_irq, 0, "rtc-alarm0", info);
 
 	if (ret < 0)
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
@@ -294,20 +295,11 @@ static int max8998_rtc_probe(struct plat
 
 out_rtc:
 	platform_set_drvdata(pdev, NULL);
-	kfree(info);
 	return ret;
 }
 
 static int max8998_rtc_remove(struct platform_device *pdev)
 {
-	struct max8998_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info) {
-		free_irq(info->irq, info);
-		rtc_device_unregister(info->rtc_dev);
-		kfree(info);
-	}
