From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max8997-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:58 -0700
Message-ID: <20130430185558.6C35F5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61739 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3D3Sz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:59 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88167qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max8997: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max8997-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max8997: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8997.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-max8997.c~rtc-rtc-max8997-use-devm_rtc_device_register drivers/rtc/rtc-max8997.c
--- a/drivers/rtc/rtc-max8997.c~rtc-rtc-max8997-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-max8997.c
@@ -479,8 +479,8 @@ static int max8997_rtc_probe(struct plat
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
-			&max8997_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8997-rtc",
+					&max8997_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -507,17 +507,11 @@ static int max8997_rtc_probe(struct plat
 	return ret;
 
 err_out:
-	rtc_device_unregister(info->rtc_dev);
 	return ret;
 }
 
 static int max8997_rtc_remove(struct platform_device *pdev)
 {
-	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info)
-		rtc_device_unregister(info->rtc_dev);
