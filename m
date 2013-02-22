From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-da9052-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:45:05 -0800
Message-ID: <20130222204505.933BE31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:45127 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BVUpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:45:06 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so104047vbb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:45:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-da9052: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-da9052-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-da9052: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~rtc-rtc-da9052-use-devm_request_threaded_irq drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-rtc-da9052-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-da9052.c
@@ -240,9 +240,10 @@ static int da9052_rtc_probe(struct platf
 	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
 	rtc->irq = platform_get_irq_byname(pdev, "ALM");
-	ret = request_threaded_irq(rtc->irq, NULL, da9052_rtc_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "ALM", rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				da9052_rtc_irq,
+				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				"ALM", rtc);
 	if (ret != 0) {
 		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
 		return ret;
@@ -250,16 +251,10 @@ static int da9052_rtc_probe(struct platf
 
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				       &da9052_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc->rtc)) {
-		ret = PTR_ERR(rtc->rtc);
-		goto err_free_irq;
-	}
+	if (IS_ERR(rtc->rtc))
+		return PTR_ERR(rtc->rtc);
 
 	return 0;
