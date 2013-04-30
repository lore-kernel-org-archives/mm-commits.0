From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rs5c313-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:47 -0700
Message-ID: <20130430185747.6F6715A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53702 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab3D3S5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:48 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86858ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rs5c313: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c313-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rs5c313: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c313.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-rs5c313.c~rtc-rtc-rs5c313-use-devm_rtc_device_register drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-rtc-rs5c313-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -367,7 +367,7 @@ static const struct rtc_class_ops rs5c31
 
 static int rs5c313_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = rtc_device_register("rs5c313", &pdev->dev,
+	struct rtc_device *rtc = devm_rtc_device_register(&pdev->dev, "rs5c313",
 				&rs5c313_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
@@ -380,10 +380,6 @@ static int rs5c313_rtc_probe(struct plat
 
 static int rs5c313_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata( pdev );
-
-	rtc_device_unregister(rtc);
