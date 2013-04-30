From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1302-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:10 -0700
Message-ID: <20130430185710.6BF6531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:61065 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369Ab3D3S5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:11 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86865qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1302: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1302-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1302: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-use-devm_rtc_device_register drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ds1302.c
@@ -224,7 +224,7 @@ static int __init ds1302_rtc_probe(struc
 		return -ENODEV;
 	}
 
-	rtc = rtc_device_register("ds1302", &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, "ds1302",
 					   &ds1302_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -236,9 +236,6 @@ static int __init ds1302_rtc_probe(struc
 
 static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
