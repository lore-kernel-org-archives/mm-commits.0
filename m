From: akpm@linux-foundation.org
Subject: - leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:29 -0700
Message-ID: <200810072339.m97NdTk4009561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757961AbYJGXjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, ncase@xes-inc.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-pca955x: add proper error handling and fix bogus memory handling
has been removed from the -mm tree.  Its filename was
     leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-pca955x: add proper error handling and fix bogus memory handling
From: Sven Wegener <sven.wegener@stealer.net>

Check the return value of led_classdev_register and unregister all
registered devices, if registering one device fails.  Also the dynamic
memory handling is totally bogus.  You can't allocate multiple chunks via
kzalloc() and expect them to be in order later.  I wonder how this ever
worked.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Nate Case <ncase@xes-inc.com>
Tested-by: Nate Case <ncase@xes-inc.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |   72 ++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff -puN drivers/leds/leds-pca955x.c~leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling
+++ a/drivers/leds/leds-pca955x.c
@@ -248,11 +248,10 @@ static int __devinit pca955x_probe(struc
 					const struct i2c_device_id *id)
 {
 	struct pca955x_led *pca955x;
-	int i;
-	int err = -ENODEV;
 	struct pca955x_chipdef *chip;
 	struct i2c_adapter *adapter;
 	struct led_platform_data *pdata;
+	int i, err;
 
 	chip = &pca955x_chipdefs[id->driver_data];
 	adapter = to_i2c_adapter(client->dev.parent);
@@ -282,43 +281,41 @@ static int __devinit pca955x_probe(struc
 		}
 	}
 
+	pca955x = kzalloc(sizeof(*pca955x) * chip->bits, GFP_KERNEL);
+	if (!pca955x)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, pca955x);
+
 	for (i = 0; i < chip->bits; i++) {
-		pca955x = kzalloc(sizeof(struct pca955x_led), GFP_KERNEL);
-		if (!pca955x) {
-			err = -ENOMEM;
-			goto exit;
-		}
+		pca955x[i].chipdef = chip;
+		pca955x[i].client = client;
+		pca955x[i].led_num = i;
 
-		pca955x->chipdef = chip;
-		pca955x->client = client;
-		pca955x->led_num = i;
 		/* Platform data can specify LED names and default triggers */
 		if (pdata) {
 			if (pdata->leds[i].name)
-				snprintf(pca955x->name, 32, "pca955x:%s",
-							pdata->leds[i].name);
+				snprintf(pca955x[i].name,
+					 sizeof(pca955x[i].name), "pca955x:%s",
+					 pdata->leds[i].name);
 			if (pdata->leds[i].default_trigger)
-				pca955x->led_cdev.default_trigger =
+				pca955x[i].led_cdev.default_trigger =
 					pdata->leds[i].default_trigger;
 		} else {
-			snprintf(pca955x->name, 32, "pca955x:%d", i);
+			snprintf(pca955x[i].name, sizeof(pca955x[i].name),
+				 "pca955x:%d", i);
 		}
-		spin_lock_init(&pca955x->lock);
 
-		pca955x->led_cdev.name = pca955x->name;
-		pca955x->led_cdev.brightness_set =
-				pca955x_led_set;
-
-		/*
-		 * Client data is a pointer to the _first_ pca955x_led
-		 * struct
-		 */
-		if (i == 0)
-			i2c_set_clientdata(client, pca955x);
+		spin_lock_init(&pca955x[i].lock);
+
+		pca955x[i].led_cdev.name = pca955x[i].name;
+		pca955x[i].led_cdev.brightness_set = pca955x_led_set;
 
-		INIT_WORK(&(pca955x->work), pca955x_led_work);
+		INIT_WORK(&pca955x[i].work, pca955x_led_work);
 
-		led_classdev_register(&client->dev, &(pca955x->led_cdev));
+		err = led_classdev_register(&client->dev, &pca955x[i].led_cdev);
+		if (err < 0)
+			goto exit;
 	}
 
 	/* Turn off LEDs */
@@ -336,23 +333,32 @@ static int __devinit pca955x_probe(struc
 	pca955x_write_psc(client, 1, 0);
 
 	return 0;
+
 exit:
+	while (i--) {
+		led_classdev_unregister(&pca955x[i].led_cdev);
+		cancel_work_sync(&pca955x[i].work);
+	}
+
+	kfree(pca955x);
+	i2c_set_clientdata(client, NULL);
+
 	return err;
 }
 
 static int __devexit pca955x_remove(struct i2c_client *client)
 {
 	struct pca955x_led *pca955x = i2c_get_clientdata(client);
-	int leds = pca955x->chipdef->bits;
 	int i;
 
-	for (i = 0; i < leds; i++) {
-		led_classdev_unregister(&(pca955x->led_cdev));
-		cancel_work_sync(&(pca955x->work));
-		kfree(pca955x);
-		pca955x = pca955x + 1;
+	for (i = 0; i < pca955x->chipdef->bits; i++) {
+		led_classdev_unregister(&pca955x[i].led_cdev);
+		cancel_work_sync(&pca955x[i].work);
 	}
 
+	kfree(pca955x);
+	i2c_set_clientdata(client, NULL);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

git-net.patch
git-cpufreq.patch
leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-pca955x-mark-pca955x_led_set-static.patch
leds-pca9532-mark-pca9532_event-static.patch
md-check-for-memory-allocation-failure-in-faulty-personality.patch

