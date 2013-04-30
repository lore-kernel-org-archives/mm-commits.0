From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ab8500-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:52 -0700
Message-ID: <20130430185952.6E21A31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:46953 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3D3S7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:53 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so87146qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ab8500: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ab8500-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ab8500: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-rtc-ab8500-use-devm_-functions drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-rtc-ab8500-use-devm_-functions
+++ a/drivers/rtc/rtc-ab8500.c
@@ -422,20 +422,19 @@ static int ab8500_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, true);
 
-	rtc = rtc_device_register("ab8500-rtc", &pdev->dev, &ab8500_rtc_ops,
-			THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, "ab8500-rtc",
+					&ab8500_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "Registration failed\n");
 		err = PTR_ERR(rtc);
 		return err;
 	}
 
-	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
-		IRQF_NO_SUSPEND | IRQF_ONESHOT, "ab8500-rtc", rtc);
-	if (err < 0) {
-		rtc_device_unregister(rtc);
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+			rtc_alarm_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
+			"ab8500-rtc", rtc);
+	if (err < 0)
 		return err;
-	}
 
 	platform_set_drvdata(pdev, rtc);
 
@@ -450,13 +449,8 @@ static int ab8500_rtc_probe(struct platf
 
 static int ab8500_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	int irq = platform_get_irq_byname(pdev, "ALARM");
