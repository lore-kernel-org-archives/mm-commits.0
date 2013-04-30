From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:34 -0700
Message-ID: <20130430185934.762D731C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:43082 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab3D3S7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:35 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so87075ggc.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, hcegtvedt@atmel.com, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at32ap700x.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
