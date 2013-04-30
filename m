From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-wm8350-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:06 -0700
Message-ID: <20130430185806.6F88131C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:49551 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab3D3S6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:07 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77537veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-wm8350: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm8350-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-wm8350: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-use-devm_rtc_device_register drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-wm8350.c
@@ -439,8 +439,8 @@ static int wm8350_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	wm_rtc->rtc = rtc_device_register("wm8350", &pdev->dev,
-					  &wm8350_rtc_ops, THIS_MODULE);
+	wm_rtc->rtc = devm_rtc_device_register(&pdev->dev, "wm8350",
+					&wm8350_rtc_ops, THIS_MODULE);
 	if (IS_ERR(wm_rtc->rtc)) {
 		ret = PTR_ERR(wm_rtc->rtc);
 		dev_err(&pdev->dev, "failed to register RTC: %d\n", ret);
@@ -462,13 +462,10 @@ static int wm8350_rtc_probe(struct platf
 static int wm8350_rtc_remove(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
-	struct wm8350_rtc *wm_rtc = &wm8350->rtc;
 
 	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_ALM, wm8350);
 
-	rtc_device_unregister(wm_rtc->rtc);
