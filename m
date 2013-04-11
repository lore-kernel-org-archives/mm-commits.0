From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:39 -0700
Message-ID: <20130411230139.C9E5431C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:59770 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3DKXBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:40 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so196379ghr.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, haojian.zhuang@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-88pm860x.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch

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
Subject: drivers/rtc/rtc-88pm860x.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm860x.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-88pm860x.c~drivers-rtc-rtc-88pm860xc-use-devm_-apis drivers/rtc/rtc-88pm860x.c
--- a/drivers/rtc/rtc-88pm860x.c~drivers-rtc-rtc-88pm860xc-use-devm_-apis
+++ a/drivers/rtc/rtc-88pm860x.c
@@ -318,14 +318,14 @@ static int pm860x_rtc_probe(struct platf
 
 	pdata = pdev->dev.platform_data;
 
-	info = kzalloc(sizeof(struct pm860x_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_rtc_info),
+			    GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 	info->irq = platform_get_irq(pdev, 0);
 	if (info->irq < 0) {
 		dev_err(&pdev->dev, "No IRQ resource!\n");
-		ret = -EINVAL;
-		goto out;
+		return info->irq;
 	}
 
 	info->chip = chip;
@@ -333,12 +333,13 @@ static int pm860x_rtc_probe(struct platf
 	info->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, info);
 
-	ret = request_threaded_irq(info->irq, NULL, rtc_update_handler,
-				   IRQF_ONESHOT, "rtc", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
+					rtc_update_handler, IRQF_ONESHOT, "rtc",
+					info);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
 			info->irq, ret);
-		goto out;
+		return ret;
 	}
 
 	/* set addresses of 32-bit base value for RTC time */
@@ -350,7 +351,7 @@ static int pm860x_rtc_probe(struct platf
 	ret = pm860x_rtc_read_time(&pdev->dev, &tm);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to read initial time.\n");
-		goto out_rtc;
+		return ret;
 	}
 	if ((tm.tm_year < 70) || (tm.tm_year > 138)) {
 		tm.tm_year = 70;
@@ -362,7 +363,7 @@ static int pm860x_rtc_probe(struct platf
 		ret = pm860x_rtc_set_time(&pdev->dev, &tm);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Failed to set initial time.\n");
-			goto out_rtc;
+			return ret;
 		}
 	}
 	rtc_tm_to_time(&tm, &ticks);
@@ -373,12 +374,12 @@ static int pm860x_rtc_probe(struct platf
 		}
 	}
 
-	info->rtc_dev = rtc_device_register("88pm860x-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "88pm860x-rtc",
 					    &pm860x_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(info->rtc_dev);
 	if (IS_ERR(info->rtc_dev)) {
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-		goto out_rtc;
+		return ret;
 	}
 
 	/*
@@ -405,11 +406,6 @@ static int pm860x_rtc_probe(struct platf
 	device_init_wakeup(&pdev->dev, 1);
 
 	return 0;
-out_rtc:
-	free_irq(info->irq, info);
-out:
-	kfree(info);
-	return ret;
 }
 
 static int pm860x_rtc_remove(struct platform_device *pdev)
@@ -423,9 +419,6 @@ static int pm860x_rtc_remove(struct plat
 #endif	/* VRTC_CALIBRATION */
 
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(info->rtc_dev);
-	free_irq(info->irq, info);
-	kfree(info);
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

