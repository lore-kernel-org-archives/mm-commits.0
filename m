From: akpm@linux-foundation.org
Subject: + leds-leds-pwm-return-proper-error-if-pwm_request-failed.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:08:58 -0800
Message-ID: <201101210008.p0L08wGA010677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854Ab1AUAJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:09:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, dtor@mail.ru, l.fu@pengutronix.de, rpurdie@rpsys.net


The patch titled
     leds: leds-pwm: return proper error if pwm_request failed
has been added to the -mm tree.  Its filename is
     leds-leds-pwm-return-proper-error-if-pwm_request-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: leds-pwm: return proper error if pwm_request failed
From: Axel Lin <axel.lin@gmail.com>

Return PTR_ERR(led_dat->pwm) instead of 0 if pwm_request failed

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Luotao Fu <l.fu@pengutronix.de>
Cc: Reviewed-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pwm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-pwm.c~leds-leds-pwm-return-proper-error-if-pwm_request-failed drivers/leds/leds-pwm.c
--- a/drivers/leds/leds-pwm.c~leds-leds-pwm-return-proper-error-if-pwm_request-failed
+++ a/drivers/leds/leds-pwm.c
@@ -69,6 +69,7 @@ static int led_pwm_probe(struct platform
 		led_dat->pwm = pwm_request(cur_led->pwm_id,
 				cur_led->name);
 		if (IS_ERR(led_dat->pwm)) {
+			ret = PTR_ERR(led_dat->pwm);
 			dev_err(&pdev->dev, "unable to request PWM %d\n",
 					cur_led->pwm_id);
 			goto err;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-leds-pwm-return-proper-error-if-pwm_request-failed.patch

