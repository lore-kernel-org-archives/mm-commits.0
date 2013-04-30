From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ls1x-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:27 -0700
Message-ID: <20130430185727.6FB2A31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:47640 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab3D3S52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:28 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86976vbe.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ls1x: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ls1x-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ls1x: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ls1x.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ls1x.c~rtc-rtc-ls1x-use-devm_rtc_device_register drivers/rtc/rtc-ls1x.c
--- a/drivers/rtc/rtc-ls1x.c~rtc-rtc-ls1x-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ls1x.c
@@ -172,7 +172,7 @@ static int ls1x_rtc_probe(struct platfor
 	while (readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TTS)
 		usleep_range(1000, 3000);
 
-	rtcdev = rtc_device_register("ls1x-rtc", &pdev->dev,
+	rtcdev = devm_rtc_device_register(&pdev->dev, "ls1x-rtc",
 					&ls1x_rtc_ops , THIS_MODULE);
 	if (IS_ERR(rtcdev)) {
 		ret = PTR_ERR(rtcdev);
@@ -187,9 +187,6 @@ err:
 
 static int ls1x_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtcdev = platform_get_drvdata(pdev);
