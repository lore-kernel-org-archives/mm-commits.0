From: akpm@google.com
Subject: + leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch added to -mm tree
Date: Tue, 11 Oct 2011 16:02:40 -0700
Message-ID: <201110112302.p9BN2fPb020455@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1JKXDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 19:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ospite@studenti.unina.it, johannes@sipsolutions.net, rpurdie@rpsys.net, stable@kernel.org


The patch titled
     Subject: leds: save the delay values after a successful call to blink_set()
has been added to the -mm tree.  Its filename is
     leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch

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
Subject: leds: save the delay values after a successful call to blink_set()

When calling the hardware blinking function implemented by blink_set(),
the delay_on and delay_off values are not preserved across calls.

Fix that and make the "timer" trigger work as expected when hardware
blinking is available.

BEFORE the fix:
  $ cd /sys/class/leds/someled
  $ echo timer > trigger
  $ cat delay_on delay_off
  0
  0
  $ echo 100 > delay_on
  $ cat delay_on delay_off
  0
  0
  $ echo 100 > delay_off
  $ cat delay_on delay_off
  0
  0

AFTER the fix:
  $ cd /sys/class/leds/someled
  $ echo timer > trigger
  $ cat delay_on delay_off
  0
  0
  $ echo 100 > delay_on
  $ cat delay_on delay_off
  100
  0
  $ echo 100 > delay_off
  $ cat delay_on delay_off
  100
  100

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/leds/led-class.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/leds/led-class.c~leds-save-the-delay-values-after-a-successful-call-to-blink_set drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-save-the-delay-values-after-a-successful-call-to-blink_set
+++ a/drivers/leds/led-class.c
@@ -268,8 +268,11 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_off)
 {
 	if (led_cdev->blink_set &&
-	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
+		led_cdev->blink_delay_on = *delay_on;
+		led_cdev->blink_delay_off = *delay_off;
 		return;
+	}
 
 	/* blink with 1 Hz as default if nothing specified */
 	if (!*delay_on && !*delay_off)
_
Subject: Subject: leds: save the delay values after a successful call to blink_set()

Patches currently in -mm which might be from ospite@studenti.unina.it are

linux-next.patch
leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch
leds-turn-the-blink_timer-off-before-starting-to-blink.patch

