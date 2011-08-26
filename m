From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:07:04 -0700
Message-ID: <201108261903.p7QJ3m7C005727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab1HZTE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-bd2802.c: bd2802_unregister_led_classdev() should unregister all registered leds
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-bd2802c-bd2802_unregister_led_classdev-should-unregister-all-registered-leds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-bd2802.c: bd2802_unregister_led_classdev() should unregister all registered leds
From: Axel Lin <axel.lin@gmail.com>

bd2802_unregister_led_classdev() should unregister all registered
instances of led_classdev class that had registered by
bd2802_register_led_classdev().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Kim Kyuwon <q1.kim@samsung.com>
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
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

