From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:01:17 -0700
Message-ID: <20120611220118.17E95A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56025 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2FKWBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:01:19 -0400
Received: by qabg24 with SMTP id g24so389081qab.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:01:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, egtvedt@samfundet.no, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/atmel-pwm-bl.c: use devm_ functions
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch

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
Subject: Subject: drivers/video/backlight/atmel-pwm-bl.c: use devm_ functions

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch
drivers-video-backlight-ot200_blc-use-devm_-functions.patch
drivers-video-backlight-lm3533_blc-use-devm_-functions.patch

