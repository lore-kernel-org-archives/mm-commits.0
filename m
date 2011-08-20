From: akpm@linux-foundation.org
Subject: + drivers-leds-led-triggersc-fix-memory-leak.patch added to -mm tree
Date: Fri, 19 Aug 2011 17:04:18 -0700
Message-ID: <201108200004.p7K04IDj032583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab1HTAE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Aug 2011 20:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Masakazu.Mokuno@jp.sony.com, mokuno@sm.sony.co.jp, rpurdie@rpsys.net


The patch titled
     drivers/leds/led-triggers.c: fix memory leak
has been added to the -mm tree.  Its filename is
     drivers-leds-led-triggersc-fix-memory-leak.patch

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
Subject: drivers/leds/led-triggers.c: fix memory leak
From: Masakazu Mokuno <Masakazu.Mokuno@jp.sony.com>

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

drivers-leds-led-triggersc-fix-memory-leak.patch

