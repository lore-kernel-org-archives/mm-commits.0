From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-lp8788-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:50 -0700
Message-ID: <20130430185550.6BFC431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50440 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab3D3Szv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:51 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so86703qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-lp8788: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-lp8788-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-lp8788: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-lp8788.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-lp8788.c~rtc-rtc-lp8788-use-devm_rtc_device_register drivers/rtc/rtc-lp8788.c
--- a/drivers/rtc/rtc-lp8788.c~rtc-rtc-lp8788-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-lp8788.c
@@ -299,7 +299,7 @@ static int lp8788_rtc_probe(struct platf
 
 	device_init_wakeup(dev, 1);
 
-	rtc->rdev = rtc_device_register("lp8788_rtc", dev,
+	rtc->rdev = devm_rtc_device_register(dev, "lp8788_rtc",
 					&lp8788_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rdev)) {
 		dev_err(dev, "can not register rtc device\n");
@@ -314,9 +314,6 @@ static int lp8788_rtc_probe(struct platf
 
 static int lp8788_rtc_remove(struct platform_device *pdev)
 {
-	struct lp8788_rtc *rtc = platform_get_drvdata(pdev);
