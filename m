From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf50633-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:40 -0700
Message-ID: <20130430190040.727EB31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62353 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3D3TAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:41 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87512vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcf50633: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf50633-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcf50633: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf50633.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-pcf50633.c~rtc-rtc-pcf50633-use-devm_-functions drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~rtc-rtc-pcf50633-use-devm_-functions
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -252,20 +252,17 @@ static int pcf50633_rtc_probe(struct pla
 {
 	struct pcf50633_rtc *rtc;
 
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
 	rtc->pcf = dev_to_pcf50633(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtc_dev = rtc_device_register("pcf50633-rtc", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "pcf50633-rtc",
 				&pcf50633_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(rtc->rtc_dev)) {
-		int ret =  PTR_ERR(rtc->rtc_dev);
-		kfree(rtc);
-		return ret;
-	}
+	if (IS_ERR(rtc->rtc_dev))
+		return PTR_ERR(rtc->rtc_dev);
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
 					pcf50633_rtc_irq, rtc);
@@ -277,12 +274,8 @@ static int pcf50633_rtc_remove(struct pl
 	struct pcf50633_rtc *rtc;
 
 	rtc = platform_get_drvdata(pdev);
-
 	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_ALARM);
 
-	rtc_device_unregister(rtc->rtc_dev);
-	kfree(rtc);
