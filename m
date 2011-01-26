From: akpm@linux-foundation.org
Subject: [merged] leds-leds-pwm-return-proper-error-if-pwm_request-failed.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:23 -0800
Message-ID: <201101262032.p0QKWNKx003167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab1AZUcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, dtor@mail.ru, l.fu@pengutronix.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: leds-pwm: return proper error if pwm_request failed
has been removed from the -mm tree.  Its filename was
     leds-leds-pwm-return-proper-error-if-pwm_request-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

