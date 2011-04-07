From: akpm@linux-foundation.org
Subject: + leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch added to -mm tree
Date: Thu, 07 Apr 2011 16:34:20 -0700
Message-ID: <201104072334.p37NYKMi007007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab1DGXeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 19:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eha@doredevelopment.dk


The patch titled
     leds: support automatic start of blinking with ledtrig-timer
has been added to the -mm tree.  Its filename is
     leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch

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
Subject: leds: support automatic start of blinking with ledtrig-timer
From: Esben Haabendal <eha@doredevelopment.dk>

By setting initial values blink_delay_on and blink_delay_off in a
led_classdev struct, this change starts the blinking when the led is
initialized.

Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c     |    3 ++-
 drivers/leds/ledtrig-timer.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/leds/led-class.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer
+++ a/drivers/leds/led-class.c
@@ -131,7 +131,8 @@ static void led_set_software_blink(struc
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (delay_on == led_cdev->blink_delay_on &&
+	if (led_cdev->trigger_data &&
+	    delay_on == led_cdev->blink_delay_on &&
 	    delay_off == led_cdev->blink_delay_off)
 		return;
 
diff -puN drivers/leds/ledtrig-timer.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer
+++ a/drivers/leds/ledtrig-timer.c
@@ -91,6 +91,9 @@ static void timer_trig_activate(struct l
 	if (rc)
 		goto err_out_delayon;
 
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
+		      &led_cdev->blink_delay_off);
+
 	led_cdev->trigger_data = (void *)1;
 
 	return;
_

Patches currently in -mm which might be from eha@doredevelopment.dk are

leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch

