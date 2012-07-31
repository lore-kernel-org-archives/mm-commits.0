From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ot200_blc-use-devm_-functions.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:11 -0700
Message-ID: <20120731185011.B4E7E1E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2GaSuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:12 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, christian.gmeiner@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ot200_bl.c: use devm_ functions
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ot200_blc-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ot200_bl.c: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ot200_bl.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/ot200_bl.c~drivers-video-backlight-ot200_blc-use-devm_-functions drivers/video/backlight/ot200_bl.c
--- a/drivers/video/backlight/ot200_bl.c~drivers-video-backlight-ot200_blc-use-devm_-functions
+++ a/drivers/video/backlight/ot200_bl.c
@@ -97,10 +97,10 @@ static int ot200_backlight_probe(struct 
 		goto error_mfgpt_alloc;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		retval = -ENOMEM;
-		goto error_kzalloc;
+		goto error_devm_kzalloc;
 	}
 
 	/* setup gpio */
@@ -122,16 +122,14 @@ static int ot200_backlight_probe(struct 
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		retval = PTR_ERR(bl);
-		goto error_backlight_device_register;
+		goto error_devm_kzalloc;
 	}
 
 	platform_set_drvdata(pdev, bl);
 
 	return 0;
 
-error_backlight_device_register:
-	kfree(data);
-error_kzalloc:
+error_devm_kzalloc:
 	cs5535_mfgpt_free_timer(pwm_timer);
 error_mfgpt_alloc:
 	gpio_free(GPIO_DIMM);
@@ -141,7 +139,6 @@ error_mfgpt_alloc:
 static int ot200_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct ot200_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
 
@@ -154,7 +151,6 @@ static int ot200_backlight_remove(struct
 	cs5535_mfgpt_free_timer(pwm_timer);
 	gpio_free(GPIO_DIMM);
 
-	kfree(data);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

