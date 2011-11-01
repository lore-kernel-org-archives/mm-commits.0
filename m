From: akpm@linux-foundation.org
Subject: [merged] leds-turn-the-blink_timer-off-before-starting-to-blink.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:41 -0700
Message-ID: <201111012115.pA1LFfh2007631@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ospite@studenti.unina.it, johannes@sipsolutions.net, rpurdie@rpsys.net, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: turn the blink_timer off before starting to blink
has been removed from the -mm tree.  Its filename was
     leds-turn-the-blink_timer-off-before-starting-to-blink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from ospite@studenti.unina.it are

origin.patch
linux-next.patch

