From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-led-triggersc-fix-memory-leak.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:07 -0700
Message-ID: <201111012115.pA1LF7gh020151@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Masakazu.Mokuno@jp.sony.com, mokuno@sm.sony.co.jp, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/led-triggers.c: fix memory leak
has been removed from the -mm tree.  Its filename was
     drivers-leds-led-triggersc-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Masakazu Mokuno <Masakazu.Mokuno@jp.sony.com>
Subject: drivers/leds/led-triggers.c: fix memory leak

The memory for struct led_trigger should be kfreed in the
led_trigger_register() error path.  Also this function should return NULL
on error.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-triggers.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/leds/led-triggers.c~drivers-leds-led-triggersc-fix-memory-leak drivers/leds/led-triggers.c
--- a/drivers/leds/led-triggers.c~drivers-leds-led-triggersc-fix-memory-leak
+++ a/drivers/leds/led-triggers.c
@@ -261,9 +261,12 @@ void led_trigger_register_simple(const c
 	if (trigger) {
 		trigger->name = name;
 		err = led_trigger_register(trigger);
-		if (err < 0)
+		if (err < 0) {
+			kfree(trigger);
+			trigger = NULL;
 			printk(KERN_WARNING "LED trigger %s failed to register"
 				" (%d)\n", name, err);
+		}
 	} else
 		printk(KERN_WARNING "LED trigger %s failed to register"
 			" (no memory)\n", name);
_

Patches currently in -mm which might be from Masakazu.Mokuno@jp.sony.com are

origin.patch

