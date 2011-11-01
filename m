From: akpm@linux-foundation.org
Subject: [merged] leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:37 -0700
Message-ID: <201111012115.pA1LFbx9010971@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ospite@studenti.unina.it, johannes@sipsolutions.net, rpurdie@rpsys.net, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: save the delay values after a successful call to blink_set()
has been removed from the -mm tree.  Its filename was
     leds-save-the-delay-values-after-a-successful-call-to-blink_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from ospite@studenti.unina.it are

origin.patch
linux-next.patch

