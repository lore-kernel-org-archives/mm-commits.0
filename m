From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-generic_blc-use-dev_info-instead-of-pr_info.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:31 -0700
Message-ID: <20130430185131.6F5545A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39786 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Svc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:32 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86337ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/generic_bl.c: use dev_info() instead of pr_info()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-generic_blc-use-dev_info-instead-of-pr_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/generic_bl.c: use dev_info() instead of pr_info()

dev_info() is preferred to pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/generic_bl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/generic_bl.c~drivers-video-backlight-generic_blc-use-dev_info-instead-of-pr_info drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~drivers-video-backlight-generic_blc-use-dev_info-instead-of-pr_info
+++ a/drivers/video/backlight/generic_bl.c
@@ -9,8 +9,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -108,7 +106,7 @@ static int genericbl_probe(struct platfo
 
 	generic_backlight_device = bd;
 
-	pr_info("Generic Backlight Driver Initialized.\n");
+	dev_info(&pdev->dev, "Generic Backlight Driver Initialized.\n");
 	return 0;
 }
 
@@ -122,7 +120,7 @@ static int genericbl_remove(struct platf
 
 	backlight_device_unregister(bd);
 
-	pr_info("Generic Backlight Driver Unloaded\n");
+	dev_info(&pdev->dev, "Generic Backlight Driver Unloaded\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

