From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lm3533_blc-use-devm_-functions.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:14 -0700
Message-ID: <20120731185014.AEF41100081@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2GaSuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:15 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, jhovold@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lm3533_bl.c: use devm_ functions
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lm3533_blc-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/lm3533_bl.c: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3533_bl.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/lm3533_bl.c~drivers-video-backlight-lm3533_blc-use-devm_-functions drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~drivers-video-backlight-lm3533_blc-use-devm_-functions
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -295,7 +295,7 @@ static int __devinit lm3533_bl_probe(str
 		return -EINVAL;
 	}
 
-	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
 	if (!bl) {
 		dev_err(&pdev->dev,
 				"failed to allocate memory for backlight\n");
@@ -317,8 +317,7 @@ static int __devinit lm3533_bl_probe(str
 						&lm3533_bl_ops, &props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev, "failed to register backlight device\n");
-		ret = PTR_ERR(bd);
-		goto err_free;
+		return PTR_ERR(bd);
 	}
 
 	bl->bd = bd;
@@ -348,8 +347,6 @@ err_sysfs_remove:
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 err_unregister:
 	backlight_device_unregister(bd);
-err_free:
-	kfree(bl);
 
 	return ret;
 }
@@ -367,7 +364,6 @@ static int __devexit lm3533_bl_remove(st
 	lm3533_ctrlbank_disable(&bl->cb);
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 	backlight_device_unregister(bd);
-	kfree(bl);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

