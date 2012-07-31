From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:07 -0700
Message-ID: <20120731185008.162C8200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40382 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2GaSuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:10 -0400
Received: by weyr1 with SMTP id r1so292314wey.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, egtvedt@samfundet.no, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/atmel-pwm-bl.c: use devm_ functions
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/atmel-pwm-bl.c: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~drivers-video-backlight-atmel-pwm-blc-use-devm_-functions drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~drivers-video-backlight-atmel-pwm-blc-use-devm_-functions
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -127,7 +127,8 @@ static int atmel_pwm_bl_probe(struct pla
 	struct atmel_pwm_bl *pwmbl;
 	int retval;
 
-	pwmbl = kzalloc(sizeof(struct atmel_pwm_bl), GFP_KERNEL);
+	pwmbl = devm_kzalloc(&pdev->dev, sizeof(struct atmel_pwm_bl),
+				GFP_KERNEL);
 	if (!pwmbl)
 		return -ENOMEM;
 
@@ -202,7 +203,6 @@ err_free_gpio:
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
 err_free_mem:
-	kfree(pwmbl);
 	return retval;
 }
 
@@ -218,7 +218,6 @@ static int __exit atmel_pwm_bl_remove(st
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(pwmbl);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

