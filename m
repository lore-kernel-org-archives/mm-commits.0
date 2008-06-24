From: akpm@linux-foundation.org
Subject: + leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate.patch added to -mm tree
Date: Tue, 24 Jun 2008 14:02:40 -0700
Message-ID: <200806242102.m5OL2e9R005827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbYFXVDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 17:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, rpurdie@rpsys.net


The patch titled
     leds: make sure led->trigger is valid before calling trigger->activate
has been added to the -mm tree.  Its filename is
     leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: make sure led->trigger is valid before calling trigger->activate
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-triggers.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/leds/led-triggers.c~leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate drivers/leds/led-triggers.c
--- a/drivers/leds/led-triggers.c~leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate
+++ a/drivers/leds/led-triggers.c
@@ -111,16 +111,17 @@ void led_trigger_set(struct led_classdev
 			flags);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
+		led_cdev->trigger = NULL;
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
 		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
 		write_unlock_irqrestore(&trigger->leddev_list_lock, flags);
+		led_cdev->trigger = trigger;
 		if (trigger->activate)
 			trigger->activate(led_cdev);
 	}
-	led_cdev->trigger = trigger;
 }
 EXPORT_SYMBOL_GPL(led_trigger_set);
 
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

leds-make-sure-led-trigger-is-valid-before-calling-trigger-activate.patch

