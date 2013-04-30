From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-efi-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:18 -0700
Message-ID: <20130430185718.702555A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40473 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333Ab3D3S5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:19 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so86931yen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-efi: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-efi-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-efi: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-efi.c~rtc-rtc-efi-use-devm_rtc_device_register drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~rtc-rtc-efi-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-efi.c
@@ -191,7 +191,7 @@ static int __init efi_rtc_probe(struct p
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("rtc-efi", &dev->dev, &efi_rtc_ops,
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-efi", &efi_rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -203,10 +203,6 @@ static int __init efi_rtc_probe(struct p
 
 static int __exit efi_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	rtc_device_unregister(rtc);
