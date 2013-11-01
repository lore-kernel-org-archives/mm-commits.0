From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-clean-up-get_intensity.patch added to
 -mm tree
Date: Fri, 01 Nov 2013 13:07:35 -0700
Message-ID: <52740a07.Tmn9zRjY5mKKNzX5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3KAUHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, jhovold@gmail.com

Subject: + backlight-atmel-pwm-bl-clean-up-get_intensity.patch added to -mm tree
To: jhovold@gmail.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:07:35 -0700


The patch titled
     Subject: backlight: atmel-pwm-bl: clean up get_intensity
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-clean-up-get_intensity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-atmel-pwm-bl-clean-up-get_intensity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-atmel-pwm-bl-clean-up-get_intensity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: backlight: atmel-pwm-bl: clean up get_intensity

Clean up get_intensity to increase readability.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-clean-up-get_intensity drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-clean-up-get_intensity
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -70,15 +70,14 @@ static int atmel_pwm_bl_set_intensity(st
 static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
 {
 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
+	u32 cdty;
 	u32 intensity;
 
-	if (pwmbl->pdata->pwm_active_low) {
-		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
-			pwmbl->pdata->pwm_duty_min;
-	} else {
-		intensity = pwmbl->pdata->pwm_duty_max -
-			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
-	}
+	cdty = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
+	if (pwmbl->pdata->pwm_active_low)
+		intensity = cdty - pwmbl->pdata->pwm_duty_min;
+	else
+		intensity = pwmbl->pdata->pwm_duty_max - cdty;
 
 	return intensity & 0xffff;
 }
_

Patches currently in -mm which might be from jhovold@gmail.com are

backlight-atmel-pwm-bl-fix-reported-brightness.patch
backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch
backlight-atmel-pwm-bl-fix-module-autoload.patch
backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch
backlight-atmel-pwm-bl-clean-up-get_intensity.patch
backlight-atmel-pwm-bl-remove-unused-include.patch
backlight-atmel-pwm-bl-use-gpio_is_valid.patch
backlight-atmel-pwm-bl-refactor-gpio_on-handling.patch
backlight-atmel-pwm-bl-use-gpio_request_one.patch
linux-next.patch

