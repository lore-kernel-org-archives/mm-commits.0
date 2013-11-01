From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch
 added to -mm tree
Date: Fri, 01 Nov 2013 13:07:34 -0700
Message-ID: <52740a06.UZPomt2Yixl3Zcch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3KAUHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, jhovold@gmail.com

Subject: + backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch added to -mm tree
To: jhovold@gmail.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:07:34 -0700


The patch titled
     Subject: backlight: atmel-pwm-bl: clean up probe error handling
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch

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
Subject: backlight: atmel-pwm-bl: clean up probe error handling

Clean up probe error handling by checking parameters before any
allocations and removing an obsolete error label.  Also remove unnecessary
reset of private gpio number.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   31 ++++++++---------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-clean-up-probe-error-handling drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-clean-up-probe-error-handling
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -126,40 +126,33 @@ static int __init atmel_pwm_bl_probe(str
 	struct atmel_pwm_bl *pwmbl;
 	int retval;
 
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		return -ENODEV;
+
+	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
+			pdata->pwm_duty_min > pdata->pwm_duty_max ||
+			pdata->pwm_frequency == 0)
+		return -EINVAL;
+
 	pwmbl = devm_kzalloc(&pdev->dev, sizeof(struct atmel_pwm_bl),
 				GFP_KERNEL);
 	if (!pwmbl)
 		return -ENOMEM;
 
 	pwmbl->pdev = pdev;
-
-	pdata = dev_get_platdata(&pdev->dev);
-	if (!pdata) {
-		retval = -ENODEV;
-		goto err_free_mem;
-	}
-
-	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
-			pdata->pwm_duty_min > pdata->pwm_duty_max ||
-			pdata->pwm_frequency == 0) {
-		retval = -EINVAL;
-		goto err_free_mem;
-	}
-
 	pwmbl->pdata = pdata;
 	pwmbl->gpio_on = pdata->gpio_on;
 
 	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
 	if (retval)
-		goto err_free_mem;
+		return retval;
 
 	if (pwmbl->gpio_on != -1) {
 		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
 					"gpio_atmel_pwm_bl");
-		if (retval) {
-			pwmbl->gpio_on = -1;
+		if (retval)
 			goto err_free_pwm;
-		}
 
 		/* Turn display off by default. */
 		retval = gpio_direction_output(pwmbl->gpio_on,
@@ -197,7 +190,7 @@ static int __init atmel_pwm_bl_probe(str
 
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
-err_free_mem:
+
 	return retval;
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

