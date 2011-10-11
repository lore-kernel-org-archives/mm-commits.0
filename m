From: akpm@google.com
Subject: + leds-turn-the-blink_timer-off-before-starting-to-blink.patch added to -mm tree
Date: Tue, 11 Oct 2011 16:02:44 -0700
Message-ID: <201110112302.p9BN2jhI014745@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:19402 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1JKXC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 19:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ospite@studenti.unina.it, johannes@sipsolutions.net, rpurdie@rpsys.net, stable@kernel.org


The patch titled
     Subject: leds: turn the blink_timer off before starting to blink
has been added to the -mm tree.  Its filename is
     leds-turn-the-blink_timer-off-before-starting-to-blink.patch

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
From: Antonio Ospite <ospite@studenti.unina.it>
Subject: leds: turn the blink_timer off before starting to blink

Depending on the implementation of the hardware blinking function in
blink_set(), the led can support hardware blinking for some values of
delay_on and delay_off and fall-back to software blinking for some other
values.

Turning off the blink_timer unconditionally before starting to blink
make sure that a sequence like:

  OFF
  hardware blinking
  software blinking
  hardware blinking

does not leave the software blinking timer active.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/leds/led-class.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/leds/led-class.c~leds-turn-the-blink_timer-off-before-starting-to-blink drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-turn-the-blink_timer-off-before-starting-to-blink
+++ a/drivers/leds/led-class.c
@@ -267,6 +267,8 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
+	del_timer_sync(&led_cdev->blink_timer);
+
 	if (led_cdev->blink_set &&
 	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
 		led_cdev->blink_delay_on = *delay_on;
_
Subject: Subject: leds: turn the blink_timer off before starting to blink

Patches currently in -mm which might be from ospite@studenti.unina.it are

linux-next.patch
leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch
leds-turn-the-blink_timer-off-before-starting-to-blink.patch

