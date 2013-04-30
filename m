From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:36 -0700
Message-ID: <20130430185536.6F25231C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:40026 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab3D3Szh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:37 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86709qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-davinci: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-davinci: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_rtc_device_register drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-davinci.c
@@ -523,7 +523,7 @@ static int __init davinci_rtc_probe(stru
 
 	platform_set_drvdata(pdev, davinci_rtc);
 
-	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	davinci_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
 		ret = PTR_ERR(davinci_rtc->rtc);
@@ -543,7 +543,7 @@ static int __init davinci_rtc_probe(stru
 			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
-		goto fail2;
+		goto fail1;
 	}
 
 	/* Enable interrupts */
@@ -557,8 +557,6 @@ static int __init davinci_rtc_probe(stru
 
 	return 0;
 
-fail2:
-	rtc_device_unregister(davinci_rtc->rtc);
 fail1:
 	platform_set_drvdata(pdev, NULL);
 	return ret;
@@ -572,8 +570,6 @@ static int __exit davinci_rtc_remove(str
 
 	rtcif_write(davinci_rtc, 0, PRTCIF_INTEN);
 
-	rtc_device_unregister(davinci_rtc->rtc);
