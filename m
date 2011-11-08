From: akpm@linux-foundation.org
Subject: + revert-leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch added to -mm tree
Date: Tue, 08 Nov 2011 14:30:06 -0800
Message-ID: <201111082230.pA8MU6I8002758@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54543 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1KHWap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 17:30:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, johannes@sipsolutions.net, ospite@studenti.unina.it, rpurdie@rpsys.net, stable@vger.kernel.org


The patch titled
     Subject: Revert "leds: save the delay values after a successful call to blink_set()"
has been added to the -mm tree.  Its filename is
     revert-leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch

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
From: Johan Hovold <jhovold@gmail.com>
Subject: Revert "leds: save the delay values after a successful call to blink_set()"

Revert commit 6123b0e27.  The problem this patch intends to solve has
already been fixed by commit 7a5caabd090b8f7
("drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/leds/led-class.c~revert-leds-save-the-delay-values-after-a-successful-call-to-blink_set drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~revert-leds-save-the-delay-values-after-a-successful-call-to-blink_set
+++ a/drivers/leds/led-class.c
@@ -270,11 +270,8 @@ void led_blink_set(struct led_classdev *
 	del_timer_sync(&led_cdev->blink_timer);
 
 	if (led_cdev->blink_set &&
-	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
-		led_cdev->blink_delay_on = *delay_on;
-		led_cdev->blink_delay_off = *delay_off;
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
 		return;
-	}
 
 	/* blink with 1 Hz as default if nothing specified */
 	if (!*delay_on && !*delay_off)
_
Subject: Subject: Revert "leds: save the delay values after a successful call to blink_set()"

Patches currently in -mm which might be from jhovold@gmail.com are

revert-leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch

