From: akpm@linux-foundation.org
Subject: [merged] leds-convert-bd2802-driver-to-dev_pm_ops.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:32:52 -0700
Message-ID: <201103232036.p2NKaS7h028123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933375Ab1CWUhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:37:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: convert bd2802 driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     leds-convert-bd2802-driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: convert bd2802 driver to dev_pm_ops
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

There is a move to deprecate bus-specific PM operations and move to using
dev_pm_ops instead in order to reduce the amount of boilerplate code in
buses and facilitiate updates to the PM core.  Do this move for the bs2802
driver.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Kim Kyuwon <chammoru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |   47 ++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-convert-bd2802-driver-to-dev_pm_ops drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-convert-bd2802-driver-to-dev_pm_ops
+++ a/drivers/leds/leds-bd2802.c
@@ -19,7 +19,7 @@
 #include <linux/leds.h>
 #include <linux/leds-bd2802.h>
 #include <linux/slab.h>
-
+#include <linux/pm.h>
 
 #define LED_CTL(rgb2en, rgb1en) ((rgb2en) << 4 | ((rgb1en) << 0))
 
@@ -319,20 +319,6 @@ static void bd2802_turn_off(struct bd280
 	bd2802_update_state(led, id, color, BD2802_OFF);
 }
 
-static void bd2802_restore_state(struct bd2802_led *led)
-{
-	int i;
-
-	for (i = 0; i < LED_NUM; i++) {
-		if (led->led[i].r)
-			bd2802_turn_on(led, i, RED, led->led[i].r);
-		if (led->led[i].g)
-			bd2802_turn_on(led, i, GREEN, led->led[i].g);
-		if (led->led[i].b)
-			bd2802_turn_on(led, i, BLUE, led->led[i].b);
-	}
-}
-
 #define BD2802_SET_REGISTER(reg_addr, reg_name)				\
 static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	struct device_attribute *attr, const char *buf, size_t count)	\
@@ -761,8 +747,25 @@ static int __exit bd2802_remove(struct i
 	return 0;
 }
 
-static int bd2802_suspend(struct i2c_client *client, pm_message_t mesg)
+#ifdef CONFIG_PM
+
+static void bd2802_restore_state(struct bd2802_led *led)
 {
+	int i;
+
+	for (i = 0; i < LED_NUM; i++) {
+		if (led->led[i].r)
+			bd2802_turn_on(led, i, RED, led->led[i].r);
+		if (led->led[i].g)
+			bd2802_turn_on(led, i, GREEN, led->led[i].g);
+		if (led->led[i].b)
+			bd2802_turn_on(led, i, BLUE, led->led[i].b);
+	}
+}
+
+static int bd2802_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	gpio_set_value(led->pdata->reset_gpio, 0);
@@ -770,8 +773,9 @@ static int bd2802_suspend(struct i2c_cli
 	return 0;
 }
 
-static int bd2802_resume(struct i2c_client *client)
+static int bd2802_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	if (!bd2802_is_all_off(led) || led->adf_on) {
@@ -782,6 +786,12 @@ static int bd2802_resume(struct i2c_clie
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(bd2802_pm, bd2802_suspend, bd2802_resume);
+#define BD2802_PM (&bd2802_pm)
+#else		/* CONFIG_PM */
+#define BD2802_PM NULL
+#endif
+
 static const struct i2c_device_id bd2802_id[] = {
 	{ "BD2802", 0 },
 	{ }
@@ -791,11 +801,10 @@ MODULE_DEVICE_TABLE(i2c, bd2802_id);
 static struct i2c_driver bd2802_i2c_driver = {
 	.driver	= {
 		.name	= "BD2802",
+		.pm	= BD2802_PM,
 	},
 	.probe		= bd2802_probe,
 	.remove		= __exit_p(bd2802_remove),
-	.suspend	= bd2802_suspend,
-	.resume		= bd2802_resume,
 	.id_table	= bd2802_id,
 };
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

