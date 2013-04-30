From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max8925c-use-devm_-apis.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:49 -0700
Message-ID: <20130430185949.7686E31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41444 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab3D3S7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:51 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so87154yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, haojian.zhuang@linaro.org, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max8925.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max8925c-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-max8925.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8925.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-use-devm_-apis drivers/rtc/rtc-max8925.c
--- a/drivers/rtc/rtc-max8925.c~drivers-rtc-rtc-max8925c-use-devm_-apis
+++ a/drivers/rtc/rtc-max8925.c
@@ -253,7 +253,8 @@ static int max8925_rtc_probe(struct plat
 	struct max8925_rtc_info *info;
 	int ret;
 
-	info = kzalloc(sizeof(struct max8925_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max8925_rtc_info),
+			    GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 	info->chip = chip;
@@ -261,12 +262,13 @@ static int max8925_rtc_probe(struct plat
 	info->dev = &pdev->dev;
 	info->irq = platform_get_irq(pdev, 0);
 
-	ret = request_threaded_irq(info->irq, NULL, rtc_update_handler,
-				   IRQF_ONESHOT, "rtc-alarm0", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
+					rtc_update_handler, IRQF_ONESHOT,
+					"rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
 			info->irq, ret);
-		goto out_irq;
+		goto err;
 	}
 
 	dev_set_drvdata(&pdev->dev, info);
@@ -275,32 +277,22 @@ static int max8925_rtc_probe(struct plat
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8925-rtc",
 					&max8925_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(info->rtc_dev);
 	if (IS_ERR(info->rtc_dev)) {
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-		goto out_rtc;
+		goto err;
 	}
 
 	return 0;
-out_rtc:
+err:
 	platform_set_drvdata(pdev, NULL);
-	free_irq(info->irq, info);
-out_irq:
-	kfree(info);
 	return ret;
 }
 
 static int max8925_rtc_remove(struct platform_device *pdev)
 {
-	struct max8925_rtc_info *info = platform_get_drvdata(pdev);
