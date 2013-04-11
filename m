From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-max8925c-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:51 -0700
Message-ID: <20130411230151.CB91F31C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35869 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3DKXBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:53 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so9563qcr.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, haojian.zhuang@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max8925.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max8925c-use-devm_-apis.patch

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
-
-	if (info) {
-		free_irq(info->irq, info);
-		rtc_device_unregister(info->rtc_dev);
-		kfree(info);
-	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch
drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch
drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch
drivers-rtc-rtc-ds1305c-use-devm_-apis.patch
drivers-rtc-rtc-ds1374c-use-devm_-apis.patch
drivers-rtc-rtc-ds3232c-use-devm_-apis.patch
drivers-rtc-rtc-m48t35c-use-devm_-apis.patch
drivers-rtc-rtc-max8925c-use-devm_-apis.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

