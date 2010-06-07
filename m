From: akpm@linux-foundation.org
Subject: + leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic.patch added to -mm tree
Date: Mon, 07 Jun 2010 16:10:19 -0700
Message-ID: <201006072310.o57NAJtW000958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab0FGXKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 19:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, dmitry.torokhov@gmail.com, rpurdie@rpsys.net, samuel.thibault@ens-lyon.org


The patch titled
     LEDS: leds-input, fix sleep inside atomic
has been added to the -mm tree.  Its filename is
     leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic.patch

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
Subject: LEDS: leds-input, fix sleep inside atomic
From: Jiri Slaby <jslaby@suse.cz>

input_led_connect creates an atomic context by spin_lock_irqsave and calls
functions which then perform sleeping operations.  For example GFP_KERNEL
allocations in led_classdev_register.

So LOCKDEP complains then like:
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2469 lockdep_trace_alloc+0xbc/0xd0()
Pid: 1, comm: swapper Not tainted 2.6.34-mm1_64+ #5
Call Trace:
...
 [<ffffffff8109359c>] lockdep_trace_alloc+0xbc/0xd0
 [<ffffffff810f65b2>] kmem_cache_alloc+0x32/0xf0
 [<ffffffff81324826>] device_create_vargs+0x56/0x110
 [<ffffffff8132490c>] device_create+0x2c/0x30
 [<ffffffff8142068c>] led_classdev_register+0x2c/0xe0
 [<ffffffff814213de>] input_led_connect+0x21e/0x2c0
...

Fix this by changing the spinlock to mutex as it is used only in
input_handler->connect and ->disconnect and it is safe to sleep there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-input.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/leds/leds-input.c~leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic drivers/leds/leds-input.c
--- a/drivers/leds/leds-input.c~leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic
+++ a/drivers/leds/leds-input.c
@@ -92,7 +92,7 @@ static struct led_trigger input_led_trig
 	DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
 };
 /* Lock for registration coherency */
-static DEFINE_SPINLOCK(input_led_registered_lock);
+static DEFINE_MUTEX(input_led_registered_lock);
 /* Which global LED classes and triggers are registered */
 static unsigned long input_led_registered[BITS_TO_LONGS(LED_CNT)];
 
@@ -159,7 +159,6 @@ static int input_led_connect(struct inpu
 {
 	struct input_handle *handle;
 	int i, error = 0;
-	unsigned long flags;
 	struct led_classdev *leds;
 
 	if (!test_bit(EV_LED, dev->keybit))
@@ -187,7 +186,7 @@ static int input_led_connect(struct inpu
 		goto err;
 
 	/* lazily register missing global input LEDs */
-	spin_lock_irqsave(&input_led_registered_lock, flags);
+	mutex_lock(&input_led_registered_lock);
 	for (i = 0; i < LED_CNT; i++)
 		if (input_leds[i].name
 				&& !test_bit(i, input_led_registered)
@@ -199,7 +198,7 @@ static int input_led_connect(struct inpu
 			else
 				led_trigger_unregister(&input_led_triggers[i]);
 		}
-	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+	mutex_unlock(&input_led_registered_lock);
 
 	/* and register this device's LEDs */
 	for (i = 0; i < LED_CNT; i++)
@@ -239,7 +238,6 @@ err:
 static void input_led_disconnect(struct input_handle *handle)
 {
 	int unregister, i;
-	unsigned long flags;
 	struct led_classdev *leds = handle->private;
 
 	for (i = 0; i < LED_CNT; i++)
@@ -249,7 +247,7 @@ static void input_led_disconnect(struct 
 	input_unregister_handle(handle);
 	input_led_delete_handle(handle);
 
-	spin_lock_irqsave(&input_led_registered_lock, flags);
+	mutex_lock(&input_led_registered_lock);
 	for (i = 0; i < LED_CNT; i++) {
 		if (!test_bit(i, input_led_registered))
 			continue;
@@ -268,7 +266,7 @@ static void input_led_disconnect(struct 
 		led_trigger_unregister(&input_led_triggers[i]);
 		clear_bit(i, input_led_registered);
 	}
-	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+	mutex_unlock(&input_led_registered_lock);
 }
 
 /* Only handle input devices which have LEDs */
_

Patches currently in -mm which might be from jslaby@suse.cz are

leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch

