From: akpm@linux-foundation.org
Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch added to -mm tree
Date: Tue, 04 Nov 2014 13:01:47 -0800
Message-ID: <54593ebb.LRjcAvKQL3Jfzc3K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaKDVBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 16:01:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Merge input leds init/exit into input module init/exit
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Merge input leds init/exit into input module init/exit

Now that input/leds.c is compiled into the input.ko module in the mm
tree, its init and exit function must be called by input.ko's init and
exit functions, instead of duplicating the module init/exit hooks, which
leads to the following build error when input is built as a module:

leds.c:(.init.text+0x0): multiple definition of `init_module'
leds.c:(.exit.text+0x0): multiple definition of `cleanup_module'

This also adds a proper clean of the vt_led_work queues in the exit
function.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    3 +++
 drivers/input/leds.c  |   16 ++++++----------
 include/linux/input.h |    7 +++++++
 3 files changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/input/input.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-3 drivers/input/input.c
--- a/drivers/input/input.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-3
+++ a/drivers/input/input.c
@@ -2428,6 +2428,8 @@ static int __init input_init(void)
 		goto fail2;
 	}
 
+	input_led_init();
+
 	return 0;
 
  fail2:	input_proc_exit();
@@ -2437,6 +2439,7 @@ static int __init input_init(void)
 
 static void __exit input_exit(void)
 {
+	input_led_exit();
 	input_proc_exit();
 	unregister_chrdev_region(MKDEV(INPUT_MAJOR, 0),
 				 INPUT_MAX_CHAR_DEVICES);
diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-3 drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-3
+++ a/drivers/input/leds.c
@@ -255,22 +255,18 @@ void input_led_disconnect(struct input_d
 	mutex_unlock(&vt_led_registered_lock);
 }
 
-static int __init input_led_init(void)
+void __init input_led_init(void)
 {
 	unsigned i;
 
 	for (i = 0; i < LED_CNT; i++)
 		INIT_WORK(&vt_led_work[i], vt_led_cb);
-
-	return 0;
 }
 
-static void __exit input_led_exit(void)
+void __exit input_led_exit(void)
 {
-}
+	unsigned i;
 
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("User LED support for input layer");
-MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
-module_init(input_led_init);
-module_exit(input_led_exit);
+	for (i = 0; i < LED_CNT; i++)
+		cancel_work_sync(&vt_led_work[i]);
+}
diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-3 include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-3
+++ a/include/linux/input.h
@@ -536,11 +536,18 @@ int input_ff_create_memless(struct input
 
 #ifdef CONFIG_INPUT_LEDS
 
+void input_led_init(void);
+void input_led_exit(void);
+
 int input_led_connect(struct input_dev *dev);
 void input_led_disconnect(struct input_dev *dev);
 
 #else
 
+static inline void input_led_init(void) { }
+
+static inline void input_led_exit(void) { }
+
 static inline int input_led_connect(struct input_dev *dev)
 {
 	return 0;
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-3.patch

