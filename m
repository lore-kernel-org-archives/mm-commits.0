From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ab3100-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:01 -0700
Message-ID: <20130430185701.7015431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:59198 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269Ab3D3S5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:02 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86961yen.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ab3100: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ab3100-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ab3100: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab3100.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ab3100.c~rtc-rtc-ab3100-use-devm_rtc_device_register drivers/rtc/rtc-ab3100.c
--- a/drivers/rtc/rtc-ab3100.c~rtc-rtc-ab3100-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ab3100.c
@@ -229,8 +229,8 @@ static int __init ab3100_rtc_probe(struc
 		/* Ignore any error on this write */
 	}
 
-	rtc = rtc_device_register("ab3100-rtc", &pdev->dev, &ab3100_rtc_ops,
-				  THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, "ab3100-rtc",
+					&ab3100_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		err = PTR_ERR(rtc);
 		return err;
@@ -242,9 +242,6 @@ static int __init ab3100_rtc_probe(struc
 
 static int __exit ab3100_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
