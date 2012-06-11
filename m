From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lm3533_blc-use-devm_-functions.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:01:21 -0700
Message-ID: <20120611220121.C3E16A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:59269 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2FKWBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:01:23 -0400
Received: by yhgm50 with SMTP id m50so523908yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:01:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, jhovold@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/lm3533_bl.c: use devm_ functions
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lm3533_blc-use-devm_-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/video/backlight/lm3533_bl.c: use devm_ functions

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch
drivers-video-backlight-ot200_blc-use-devm_-functions.patch
drivers-video-backlight-lm3533_blc-use-devm_-functions.patch

