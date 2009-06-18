From: akpm@linux-foundation.org
Subject: [merged] leds-fix-led-bd2802-errors-while-resuming.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:32 -0700
Message-ID: <200906181820.n5IIKWbR018043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbZFRSVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: fix led-bd2802 errors while resuming
has been removed from the -mm tree.  Its filename was
     leds-fix-led-bd2802-errors-while-resuming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix led-bd2802 errors while resuming
From: Kim Kyuwon <chammoru@gmail.com>

LED_CORE_SUSPENDRESUME flag is not needed in the bd2802 driver, because
all works for suspend/resume is done in bd2802_suspend and bd2802_suspend
functions.  And this patch allows bd2802 to be configured again when it
resumes from suspend.

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-fix-led-bd2802-errors-while-resuming drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-fix-led-bd2802-errors-while-resuming
+++ a/drivers/leds/leds-bd2802.c
@@ -538,7 +538,6 @@ static int bd2802_register_led_classdev(
 	led->cdev_led1r.brightness = LED_OFF;
 	led->cdev_led1r.brightness_set = bd2802_set_led1r_brightness;
 	led->cdev_led1r.blink_set = bd2802_set_led1r_blink;
-	led->cdev_led1r.flags |= LED_CORE_SUSPENDRESUME;
 
 	ret = led_classdev_register(&led->client->dev, &led->cdev_led1r);
 	if (ret < 0) {
@@ -551,7 +550,6 @@ static int bd2802_register_led_classdev(
 	led->cdev_led1g.brightness = LED_OFF;
 	led->cdev_led1g.brightness_set = bd2802_set_led1g_brightness;
 	led->cdev_led1g.blink_set = bd2802_set_led1g_blink;
-	led->cdev_led1g.flags |= LED_CORE_SUSPENDRESUME;
 
 	ret = led_classdev_register(&led->client->dev, &led->cdev_led1g);
 	if (ret < 0) {
@@ -564,7 +562,6 @@ static int bd2802_register_led_classdev(
 	led->cdev_led1b.brightness = LED_OFF;
 	led->cdev_led1b.brightness_set = bd2802_set_led1b_brightness;
 	led->cdev_led1b.blink_set = bd2802_set_led1b_blink;
-	led->cdev_led1b.flags |= LED_CORE_SUSPENDRESUME;
 
 	ret = led_classdev_register(&led->client->dev, &led->cdev_led1b);
 	if (ret < 0) {
@@ -577,7 +574,6 @@ static int bd2802_register_led_classdev(
 	led->cdev_led2r.brightness = LED_OFF;
 	led->cdev_led2r.brightness_set = bd2802_set_led2r_brightness;
 	led->cdev_led2r.blink_set = bd2802_set_led2r_blink;
-	led->cdev_led2r.flags |= LED_CORE_SUSPENDRESUME;
 
 	ret = led_classdev_register(&led->client->dev, &led->cdev_led2r);
 	if (ret < 0) {
@@ -590,7 +586,6 @@ static int bd2802_register_led_classdev(
 	led->cdev_led2g.brightness = LED_OFF;
 	led->cdev_led2g.brightness_set = bd2802_set_led2g_brightness;
 	led->cdev_led2g.blink_set = bd2802_set_led2g_blink;
-	led->cdev_led2g.flags |= LED_CORE_SUSPENDRESUME;
 
 	ret = led_classdev_register(&led->client->dev, &led->cdev_led2g);
 	if (ret < 0) {
@@ -723,8 +718,7 @@ static int bd2802_resume(struct i2c_clie
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	if (!bd2802_is_all_off(led) || led->adf_on) {
-		gpio_set_value(led->pdata->reset_gpio, 1);
-		udelay(100);
+		bd2802_reset_cancel(led);
 		bd2802_restore_state(led);
 	}
 
_

Patches currently in -mm which might be from chammoru@gmail.com are

linux-next.patch

