From: akpm@linux-foundation.org
Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:32:54 -0700
Message-ID: <542c7306.S8gRjYIoDMaNVVIw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaJAVcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Defer input led work to workqueue
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch

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
Subject: Defer input led work to workqueue

When the kbd changes its led state (e.g.  caps lock), this triggers
(led_trigger_event) the kbd-capsl trigger, which is by default used by the
vt::capsl LED, which triggers (led_trigger_event) the vt-capsl trigger. 
These two nested led_trigger_event calls take a trig->leddev_list_lock
lock and thus lockdep complains.

Actually the user can make the vt::capsl LED use its own vt-capsl trigger
and thus build a loop.  This produces an immediate oops.

This changeset defers the second led_trigger_event call into a workqueue,
which avoids the nested locking altogether.  This does not prevent the
user from shooting himself in the foot by creating a vt::capsl <->
vt-capsl loop, but the only consequence is the workqueue threads eating
some CPU until the user breaks the loop, which is not too bad.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/leds.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-2 drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-2
+++ a/drivers/input/leds.c
@@ -100,13 +100,24 @@ static unsigned long vt_led_registered[B
 /* Number of input devices having each LED */
 static int vt_led_references[LED_CNT];
 
+static int vt_led_state[LED_CNT];
+static struct work_struct vt_led_work[LED_CNT];
+
+static void vt_led_cb(struct work_struct *work)
+{
+	int led = work - vt_led_work;
+
+	led_trigger_event(&vt_led_triggers[led], vt_led_state[led]);
+}
+
 /* VT LED state change, tell the VT trigger.  */
 static void vt_led_set(struct led_classdev *cdev,
 			  enum led_brightness brightness)
 {
 	int led = cdev - vt_leds;
 
-	led_trigger_event(&vt_led_triggers[led], !!brightness);
+	vt_led_state[led] = !!brightness;
+	schedule_work(&vt_led_work[led]);
 }
 
 /* LED state change for some keyboard, notify that keyboard.  */
@@ -244,6 +255,22 @@ void input_led_disconnect(struct input_d
 	mutex_unlock(&vt_led_registered_lock);
 }
 
+static int __init input_led_init(void)
+{
+	unsigned i;
+
+	for (i = 0; i < LED_CNT; i++)
+		INIT_WORK(&vt_led_work[i], vt_led_cb);
+
+	return 0;
+}
+
+static void __exit input_led_exit(void)
+{
+}
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for input layer");
 MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
+module_init(input_led_init);
+module_exit(input_led_exit);
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-2.patch

