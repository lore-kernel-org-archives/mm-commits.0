From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-renesas-tpuc-update-driver-to-use-workqueue.patch added to -mm tree
Date: Mon, 29 Aug 2011 15:00:15 -0700
Message-ID: <201108292200.p7TM0FPa000327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798Ab1H2WBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 18:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, grant.likely@secretlab.ca, lethal@linux-sh.org, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-renesas-tpu.c: update driver to use workqueue
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-renesas-tpuc-update-driver-to-use-workqueue.patch

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
Subject: drivers/leds/leds-renesas-tpu.c: update driver to use workqueue
From: Magnus Damm <damm@opensource.se>

Use a workqueue in the Renesas TPU LED driver to allow the Runtime PM code
to sleep.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-renesas-tpu.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/leds/leds-renesas-tpu.c~drivers-leds-leds-renesas-tpuc-update-driver-to-use-workqueue drivers/leds/leds-renesas-tpu.c
--- a/drivers/leds/leds-renesas-tpu.c~drivers-leds-leds-renesas-tpuc-update-driver-to-use-workqueue
+++ a/drivers/leds/leds-renesas-tpu.c
@@ -31,6 +31,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/workqueue.h>
 
 enum r_tpu_pin { R_TPU_PIN_UNUSED, R_TPU_PIN_GPIO, R_TPU_PIN_GPIO_FN };
 enum r_tpu_timer { R_TPU_TIMER_UNUSED, R_TPU_TIMER_ON };
@@ -44,6 +45,8 @@ struct r_tpu_priv {
 	enum r_tpu_timer timer_state;
 	unsigned long min_rate;
 	unsigned int refresh_rate;
+	struct work_struct work;
+	enum led_brightness new_brightness;
 };
 
 static DEFINE_SPINLOCK(r_tpu_lock);
@@ -211,15 +214,15 @@ static void r_tpu_set_pin(struct r_tpu_p
 	p->pin_state = new_state;
 }
 
-static void r_tpu_set_brightness(struct led_classdev *ldev,
-				 enum led_brightness brightness)
+static void r_tpu_work(struct work_struct *work)
 {
-	struct r_tpu_priv *p = container_of(ldev, struct r_tpu_priv, ldev);
+	struct r_tpu_priv *p = container_of(work, struct r_tpu_priv, work);
+	enum led_brightness brightness = p->new_brightness;
 
 	r_tpu_disable(p);
 
 	/* off and maximum are handled as GPIO pins, in between PWM */
-	if ((brightness == 0) || (brightness == ldev->max_brightness))
+	if ((brightness == 0) || (brightness == p->ldev.max_brightness))
 		r_tpu_set_pin(p, R_TPU_PIN_GPIO, brightness);
 	else {
 		r_tpu_set_pin(p, R_TPU_PIN_GPIO_FN, 0);
@@ -227,6 +230,14 @@ static void r_tpu_set_brightness(struct 
 	}
 }
 
+static void r_tpu_set_brightness(struct led_classdev *ldev,
+				 enum led_brightness brightness)
+{
+	struct r_tpu_priv *p = container_of(ldev, struct r_tpu_priv, ldev);
+	p->new_brightness = brightness;
+	schedule_work(&p->work);
+}
+
 static int __devinit r_tpu_probe(struct platform_device *pdev)
 {
 	struct led_renesas_tpu_config *cfg = pdev->dev.platform_data;
@@ -274,6 +285,7 @@ static int __devinit r_tpu_probe(struct 
 	r_tpu_set_pin(p, R_TPU_PIN_GPIO, LED_OFF);
 	platform_set_drvdata(pdev, p);
 
+	INIT_WORK(&p->work, r_tpu_work);
 
 	p->ldev.name = cfg->name;
 	p->ldev.brightness = LED_OFF;
@@ -307,6 +319,7 @@ static int __devexit r_tpu_remove(struct
 
 	r_tpu_set_brightness(&p->ldev, LED_OFF);
 	led_classdev_unregister(&p->ldev);
+	cancel_work_sync(&p->work);
 	r_tpu_disable(p);
 	r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
 
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
leds-renesas-tpu-led-driver-v2.patch
leds-renesas-tpu-led-driver-v2-fix.patch
drivers-leds-leds-renesas-tpuc-update-driver-to-use-workqueue.patch

