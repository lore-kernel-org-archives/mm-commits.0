From: akpm@linux-foundation.org
Subject: + leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch added to -mm tree
Date: Thu, 07 Aug 2008 16:36:44 -0700
Message-ID: <200808072336.m77Nai0s011686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbYHGXhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 19:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, ncase@xes-inc.com, rpurdie@rpsys.net


The patch titled
     leds-pca955x: add proper error handling and fix bogus memory handling
has been added to the -mm tree.  Its filename is
     leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Richard Purdie <rpurdie@rpsys.net>
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
@@ -282,43 +281,46 @@ static int __devinit pca955x_probe(struc
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
+			snprintf(pca955x[i].name, 32, "pca955x:%d", i);
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
+		if (err < 0) {
+			while (i > 0) {
+				i--;
+				led_classdev_unregister(&pca955x[i].led_cdev);
+			}
+
+			goto exit;
+		}
 	}
 
 	/* Turn off LEDs */
@@ -336,23 +338,27 @@ static int __devinit pca955x_probe(struc
 	pca955x_write_psc(client, 1, 0);
 
 	return 0;
+
 exit:
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

leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch

