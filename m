From: akpm@linux-foundation.org
Subject: + leds-convert-bd2802-driver-to-dev_pm_ops.patch added to -mm tree
Date: Thu, 20 Jan 2011 15:12:26 -0800
Message-ID: <201101202312.p0KNCQBJ008272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204Ab1ATXNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 18:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net


The patch titled
     leds: convert bd2802 driver to dev_pm_ops
has been added to the -mm tree.  Its filename is
     leds-convert-bd2802-driver-to-dev_pm_ops.patch

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
Subject: leds: convert bd2802 driver to dev_pm_ops
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

There is a move to deprecate bus-specific PM operations and move to using
dev_pm_ops instead in order to reduce the amount of boilerplate code in
buses and facilitiate updates to the PM core.  Do this move for the bs2802
driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Kim Kyuwon <chammoru@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

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
 
@@ -761,8 +761,9 @@ static int __exit bd2802_remove(struct i
 	return 0;
 }
 
-static int bd2802_suspend(struct i2c_client *client, pm_message_t mesg)
+static int bd2802_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	gpio_set_value(led->pdata->reset_gpio, 0);
@@ -770,8 +771,9 @@ static int bd2802_suspend(struct i2c_cli
 	return 0;
 }
 
-static int bd2802_resume(struct i2c_client *client)
+static int bd2802_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bd2802_led *led = i2c_get_clientdata(client);
 
 	if (!bd2802_is_all_off(led) || led->adf_on) {
@@ -782,6 +784,8 @@ static int bd2802_resume(struct i2c_clie
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(bd2802_pm, bd2802_suspend, bd2802_resume);
+
 static const struct i2c_device_id bd2802_id[] = {
 	{ "BD2802", 0 },
 	{ }
@@ -791,11 +795,10 @@ MODULE_DEVICE_TABLE(i2c, bd2802_id);
 static struct i2c_driver bd2802_i2c_driver = {
 	.driver	= {
 		.name	= "BD2802",
+		.pm	= &bd2802_pm,
 	},
 	.probe		= bd2802_probe,
 	.remove		= __exit_p(bd2802_remove),
-	.suspend	= bd2802_suspend,
-	.resume		= bd2802_resume,
 	.id_table	= bd2802_id,
 };
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch

