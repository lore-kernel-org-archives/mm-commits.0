From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mxc-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:03 -0700
Message-ID: <20130430185603.6E52931C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45065 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3D3S4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:04 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86772vbf.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mxc: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mxc-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mxc: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-use-devm_rtc_device_register drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-mxc.c
@@ -439,7 +439,7 @@ static int mxc_rtc_probe(struct platform
 	if (pdata->irq >=0)
 		device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &mxc_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
@@ -464,8 +464,6 @@ static int mxc_rtc_remove(struct platfor
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(pdata->rtc);
