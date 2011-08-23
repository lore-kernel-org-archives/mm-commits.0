From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds.patch added to -mm tree
Date: Tue, 23 Aug 2011 16:36:04 -0700
Message-ID: <201108232336.p7NNa4Qv014062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab1HWXgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 19:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-bd2802.c: bd2802_unregister_led_classdev() should unregister all registered leds
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds.patch

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
Subject: drivers/leds/leds-bd2802.c: bd2802_unregister_led_classdev() should unregister all registered leds
From: Axel Lin <axel.lin@gmail.com>

bd2802_unregister_led_classdev() should unregister all registered
instances of led_classdev class that had registered by
bd2802_register_led_classdev().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/leds/leds-bd2802.c~drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds
+++ a/drivers/leds/leds-bd2802.c
@@ -662,6 +662,11 @@ failed_unregister_led1_R:
 static void bd2802_unregister_led_classdev(struct bd2802_led *led)
 {
 	cancel_work_sync(&led->work);
+	led_classdev_unregister(&led->cdev_led2b);
+	led_classdev_unregister(&led->cdev_led2g);
+	led_classdev_unregister(&led->cdev_led2r);
+	led_classdev_unregister(&led->cdev_led1b);
+	led_classdev_unregister(&led->cdev_led1g);
 	led_classdev_unregister(&led->cdev_led1r);
 }
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch
leds-add-missing-include-of-linux-moduleh.patch
backlight-fix-module-alias-prefix-for-adp8870_bl.patch
drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch
drivers-misc-ab8500-pwmc-fix-modalias.patch
drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

