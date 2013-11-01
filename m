From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch added
 to -mm tree
Date: Fri, 01 Nov 2013 13:07:32 -0700
Message-ID: <52740a04.KeL3AxjeJcJ4fioJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3KAUHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, jg1.han@samsung.com, jhovold@gmail.com

Subject: + backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch added to -mm tree
To: jhovold@gmail.com,jg1.han@samsung.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:07:32 -0700


The patch titled
     Subject: backlight: atmel-pwm-bl: fix gpio polarity in remove
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch

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
Subject: backlight: atmel-pwm-bl: fix gpio polarity in remove

Make sure to honour gpio polarity also at remove so that the backlight is
actually disabled on boards with active-low enable pin.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -205,8 +205,10 @@ static int __exit atmel_pwm_bl_remove(st
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
-	if (pwmbl->gpio_on != -1)
-		gpio_set_value(pwmbl->gpio_on, 0);
+	if (pwmbl->gpio_on != -1) {
+		gpio_set_value(pwmbl->gpio_on,
+					0 ^ pwmbl->pdata->on_active_low);
+	}
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 
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

