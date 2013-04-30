From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-generic-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:22 -0700
Message-ID: <20130430185722.6E53831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:50587 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306Ab3D3S5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:23 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86932qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-generic: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-generic-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-generic: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-generic.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-generic.c~rtc-rtc-generic-use-devm_rtc_device_register drivers/rtc/rtc-generic.c
--- a/drivers/rtc/rtc-generic.c~rtc-rtc-generic-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-generic.c
@@ -38,8 +38,8 @@ static int __init generic_rtc_probe(stru
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("rtc-generic", &dev->dev, &generic_rtc_ops,
-				  THIS_MODULE);
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-generic",
+					&generic_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -50,10 +50,6 @@ static int __init generic_rtc_probe(stru
 
 static int __exit generic_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	rtc_device_unregister(rtc);
