From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ps3-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:39 -0700
Message-ID: <20130430185739.63FF15A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36125 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab3D3S5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:40 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so86952qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ps3: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ps3-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ps3: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ps3.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ps3.c~rtc-rtc-ps3-use-devm_rtc_device_register drivers/rtc/rtc-ps3.c
--- a/drivers/rtc/rtc-ps3.c~rtc-rtc-ps3-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ps3.c
@@ -62,7 +62,7 @@ static int __init ps3_rtc_probe(struct p
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("rtc-ps3", &dev->dev, &ps3_rtc_ops,
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-ps3", &ps3_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -73,7 +73,6 @@ static int __init ps3_rtc_probe(struct p
 
 static int __exit ps3_rtc_remove(struct platform_device *dev)
 {
-	rtc_device_unregister(platform_get_drvdata(dev));
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

