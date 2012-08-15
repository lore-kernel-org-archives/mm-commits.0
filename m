From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-remove-goto-err_free_mem.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:29:13 -0700
Message-ID: <20120815232913.A10FA1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59437 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2HOX3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:29:15 -0400
Received: by obbwc20 with SMTP id wc20so1539175obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:29:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, egtvedt@samfundet.no, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/atmel-pwm-bl.c: remove goto err_free_mem
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-remove-goto-err_free_mem.patch

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
Subject: drivers/video/backlight/atmel-pwm-bl.c: remove goto err_free_mem

Remove goto err_free_mem, which makes code a bit smaller.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-remove-goto-err_free_mem drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-remove-goto-err_free_mem
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -135,24 +135,20 @@ static int atmel_pwm_bl_probe(struct pla
 	pwmbl->pdev = pdev;
 
 	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		retval = -ENODEV;
-		goto err_free_mem;
-	}
+	if (!pdata)
+		return -ENODEV;
 
 	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
 			pdata->pwm_duty_min > pdata->pwm_duty_max ||
-			pdata->pwm_frequency == 0) {
-		retval = -EINVAL;
-		goto err_free_mem;
-	}
+			pdata->pwm_frequency == 0)
+		return -EINVAL;
 
 	pwmbl->pdata = pdata;
 	pwmbl->gpio_on = pdata->gpio_on;
 
 	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
 	if (retval)
-		goto err_free_mem;
+		return retval;
 
 	if (pwmbl->gpio_on != -1) {
 		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
@@ -200,7 +196,6 @@ err_free_bl_dev:
 	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
-err_free_mem:
 	return retval;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
backlight-atmel-pwm-bl-remove-goto-err_free_mem.patch

