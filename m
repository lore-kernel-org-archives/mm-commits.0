From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:41 -0700
Message-ID: <20130411230141.CA4655A4228@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55441 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3DKXBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:42 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so196385ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, hcegtvedt@atmel.com, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-at32ap700x.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch

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
Subject: drivers/rtc/rtc-at32ap700x.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~drivers-rtc-rtc-at32ap700xc-use-devm_-apis drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~drivers-rtc-rtc-at32ap700xc-use-devm_-apis
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -202,7 +202,8 @@ static int __init at32_rtc_probe(struct
 	int irq;
 	int ret;
 
-	rtc = kzalloc(sizeof(struct rtc_at32ap700x), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(struct rtc_at32ap700x),
+			   GFP_KERNEL);
 	if (!rtc) {
 		dev_dbg(&pdev->dev, "out of memory\n");
 		return -ENOMEM;
@@ -223,7 +224,7 @@ static int __init at32_rtc_probe(struct
 	}
 
 	rtc->irq = irq;
-	rtc->regs = ioremap(regs->start, resource_size(regs));
+	rtc->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!rtc->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
@@ -244,20 +245,21 @@ static int __init at32_rtc_probe(struct
 				| RTC_BIT(CTRL_EN));
 	}
 
-	ret = request_irq(irq, at32_rtc_interrupt, IRQF_SHARED, "rtc", rtc);
+	ret = devm_request_irq(&pdev->dev, irq, at32_rtc_interrupt, IRQF_SHARED,
+				"rtc", rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "could not request irq %d\n", irq);
-		goto out_iounmap;
+		goto out;
 	}
 
 	platform_set_drvdata(pdev, rtc);
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&at32_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_dbg(&pdev->dev, "could not register rtc device\n");
 		ret = PTR_ERR(rtc->rtc);
-		goto out_free_irq;
+		goto out;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -267,26 +269,15 @@ static int __init at32_rtc_probe(struct
 
 	return 0;
 
-out_free_irq:
-	platform_set_drvdata(pdev, NULL);
-	free_irq(irq, rtc);
-out_iounmap:
-	iounmap(rtc->regs);
 out:
-	kfree(rtc);
+	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
 static int __exit at32_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_at32ap700x *rtc = platform_get_drvdata(pdev);
-
 	device_init_wakeup(&pdev->dev, 0);
 
-	free_irq(rtc->irq, rtc);
-	iounmap(rtc->regs);
-	rtc_device_unregister(rtc->rtc);
-	kfree(rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
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

