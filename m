From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-wm831x-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:33 -0700
Message-ID: <20130430185633.7005931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:46131 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325Ab3D3S4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:34 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86773ggc.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-wm831x: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm831x-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-wm831x: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~rtc-rtc-wm831x-use-devm_rtc_device_register drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~rtc-rtc-wm831x-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-wm831x.c
@@ -436,7 +436,7 @@ static int wm831x_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	wm831x_rtc->rtc = rtc_device_register("wm831x", &pdev->dev,
+	wm831x_rtc->rtc = devm_rtc_device_register(&pdev->dev, "wm831x",
 					      &wm831x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(wm831x_rtc->rtc)) {
 		ret = PTR_ERR(wm831x_rtc->rtc);
@@ -462,10 +462,6 @@ err:
 
 static int wm831x_rtc_remove(struct platform_device *pdev)
 {
-	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(wm831x_rtc->rtc);
