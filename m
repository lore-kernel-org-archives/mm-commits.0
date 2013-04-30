From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mv-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:00 -0700
Message-ID: <20130430185600.6EFB731C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:50712 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3D3S4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:01 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86825qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mv: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mv-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mv: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-mv.c~rtc-rtc-mv-use-devm_rtc_device_register drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~rtc-rtc-mv-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-mv.c
@@ -272,12 +272,13 @@ static int __init mv_rtc_probe(struct pl
 
 	if (pdata->irq >= 0) {
 		device_init_wakeup(&pdev->dev, 1);
-		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 						 &mv_rtc_alarm_ops,
 						 THIS_MODULE);
-	} else
-		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	} else {
+		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 						 &mv_rtc_ops, THIS_MODULE);
+	}
 	if (IS_ERR(pdata->rtc)) {
 		ret = PTR_ERR(pdata->rtc);
 		goto out;
@@ -308,7 +309,6 @@ static int __exit mv_rtc_remove(struct p
 	if (pdata->irq >= 0)
 		device_init_wakeup(&pdev->dev, 0);
 
-	rtc_device_unregister(pdata->rtc);
 	if (!IS_ERR(pdata->clk))
 		clk_disable_unprepare(pdata->clk);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

