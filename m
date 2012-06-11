From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ot200_blc-use-devm_-functions.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:01:19 -0700
Message-ID: <20120611220119.D4E06A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42249 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2FKWBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:01:20 -0400
Received: by vbnl22 with SMTP id l22so418784vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:01:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, christian.gmeiner@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/ot200_bl.c: use devm_ functions
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ot200_blc-use-devm_-functions.patch

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
Subject: Subject: drivers/video/backlight/ot200_bl.c: use devm_ functions

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch
drivers-video-backlight-ot200_blc-use-devm_-functions.patch
drivers-video-backlight-lm3533_blc-use-devm_-functions.patch

