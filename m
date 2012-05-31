From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:52 -0700
Message-ID: <20120531191952.6AFADA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38265 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101Ab2EaTTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:54 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so75525bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.stein@systec-electronic.com, bryan.wu@canonical.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-pca955x.c: fix race condition while setting brightness on several LEDs
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: drivers/leds/leds-pca955x.c: fix race condition while setting brightness on several LEDs

When issuing the following command:

for I in 0 1 2 3 4 5 6 7; do
  echo 0 > /sys/class/leds/pca955x\:${I}/brightness;
done

It is possible that all the pca955x_read_ls calls are done sequentially
before any pca955x_write_ls call is done.  This updates the LS only to the
last LED update in its set.

Fix this by using a global lock for the pca995x device during
pca955x_led_work.  Also used a struct for shared data betreen all LEDs.

[akpm@linux-foundation.org: revert unintentional rename of pca955x_ledsel()]
Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |   95 +++++++++++++++++++++-------------
 1 file changed, 59 insertions(+), 36 deletions(-)

diff -puN drivers/leds/leds-pca955x.c~drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds
+++ a/drivers/leds/leds-pca955x.c
@@ -101,11 +101,16 @@ static const struct i2c_device_id pca955
 };
 MODULE_DEVICE_TABLE(i2c, pca955x_id);
 
-struct pca955x_led {
+struct pca955x {
+	struct mutex lock;
+	struct pca955x_led *leds;
 	struct pca955x_chipdef	*chipdef;
 	struct i2c_client	*client;
+};
+
+struct pca955x_led {
+	struct pca955x	*pca955x;
 	struct work_struct	work;
-	spinlock_t		lock;
 	enum led_brightness	brightness;
 	struct led_classdev	led_cdev;
 	int			led_num;	/* 0 .. 15 potentially */
@@ -140,7 +145,7 @@ static inline u8 pca955x_ledsel(u8 oldva
  */
 static void pca955x_write_psc(struct i2c_client *client, int n, u8 val)
 {
-	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+	struct pca955x *pca955x = i2c_get_clientdata(client);
 
 	i2c_smbus_write_byte_data(client,
 		pca95xx_num_input_regs(pca955x->chipdef->bits) + 2*n,
@@ -156,7 +161,7 @@ static void pca955x_write_psc(struct i2c
  */
 static void pca955x_write_pwm(struct i2c_client *client, int n, u8 val)
 {
-	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+	struct pca955x *pca955x = i2c_get_clientdata(client);
 
 	i2c_smbus_write_byte_data(client,
 		pca95xx_num_input_regs(pca955x->chipdef->bits) + 1 + 2*n,
@@ -169,7 +174,7 @@ static void pca955x_write_pwm(struct i2c
  */
 static void pca955x_write_ls(struct i2c_client *client, int n, u8 val)
 {
-	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+	struct pca955x *pca955x = i2c_get_clientdata(client);
 
 	i2c_smbus_write_byte_data(client,
 		pca95xx_num_input_regs(pca955x->chipdef->bits) + 4 + n,
@@ -182,7 +187,7 @@ static void pca955x_write_ls(struct i2c_
  */
 static u8 pca955x_read_ls(struct i2c_client *client, int n)
 {
-	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+	struct pca955x *pca955x = i2c_get_clientdata(client);
 
 	return (u8) i2c_smbus_read_byte_data(client,
 		pca95xx_num_input_regs(pca955x->chipdef->bits) + 4 + n);
@@ -190,18 +195,23 @@ static u8 pca955x_read_ls(struct i2c_cli
 
 static void pca955x_led_work(struct work_struct *work)
 {
-	struct pca955x_led *pca955x;
+	struct pca955x_led *pca955x_led;
+	struct pca955x *pca955x;
 	u8 ls;
 	int chip_ls;	/* which LSx to use (0-3 potentially) */
 	int ls_led;	/* which set of bits within LSx to use (0-3) */
 
-	pca955x = container_of(work, struct pca955x_led, work);
-	chip_ls = pca955x->led_num / 4;
-	ls_led = pca955x->led_num % 4;
+	pca955x_led = container_of(work, struct pca955x_led, work);
+	pca955x = pca955x_led->pca955x;
+
+	chip_ls = pca955x_led->led_num / 4;
+	ls_led = pca955x_led->led_num % 4;
+
+	mutex_lock(&pca955x->lock);
 
 	ls = pca955x_read_ls(pca955x->client, chip_ls);
 
-	switch (pca955x->brightness) {
+	switch (pca955x_led->brightness) {
 	case LED_FULL:
 		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_LED_ON);
 		break;
@@ -219,12 +229,15 @@ static void pca955x_led_work(struct work
 		 * OFF, HALF, or FULL.  But, this is probably better than
 		 * just turning off for all other values.
 		 */
-		pca955x_write_pwm(pca955x->client, 1, 255-pca955x->brightness);
+		pca955x_write_pwm(pca955x->client, 1,
+				255 - pca955x_led->brightness);
 		ls = pca955x_ledsel(ls, ls_led, PCA955X_LS_BLINK1);
 		break;
 	}
 
 	pca955x_write_ls(pca955x->client, chip_ls, ls);
+
+	mutex_unlock(&pca955x->lock);
 }
 
 static void pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness value)
@@ -233,7 +246,6 @@ static void pca955x_led_set(struct led_c
 
 	pca955x = container_of(led_cdev, struct pca955x_led, led_cdev);
 
-	spin_lock(&pca955x->lock);
 	pca955x->brightness = value;
 
 	/*
@@ -241,14 +253,13 @@ static void pca955x_led_set(struct led_c
 	 * can sleep.
 	 */
 	schedule_work(&pca955x->work);
-
-	spin_unlock(&pca955x->lock);
 }
 
 static int __devinit pca955x_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
-	struct pca955x_led *pca955x;
+	struct pca955x *pca955x;
+	struct pca955x_led *pca955x_led;
 	struct pca955x_chipdef *chip;
 	struct i2c_adapter *adapter;
 	struct led_platform_data *pdata;
@@ -282,39 +293,48 @@ static int __devinit pca955x_probe(struc
 		}
 	}
 
-	pca955x = kzalloc(sizeof(*pca955x) * chip->bits, GFP_KERNEL);
+	pca955x = kzalloc(sizeof(*pca955x), GFP_KERNEL);
 	if (!pca955x)
 		return -ENOMEM;
 
+	pca955x->leds = kzalloc(sizeof(*pca955x_led) * chip->bits, GFP_KERNEL);
+	if (!pca955x->leds) {
+		err = -ENOMEM;
+		goto exit_nomem;
+	}
+
 	i2c_set_clientdata(client, pca955x);
 
+	mutex_init(&pca955x->lock);
+	pca955x->client = client;
+	pca955x->chipdef = chip;
+
 	for (i = 0; i < chip->bits; i++) {
-		pca955x[i].chipdef = chip;
-		pca955x[i].client = client;
-		pca955x[i].led_num = i;
+		pca955x_led = &pca955x->leds[i];
+		pca955x_led->led_num = i;
+		pca955x_led->pca955x = pca955x;
 
 		/* Platform data can specify LED names and default triggers */
 		if (pdata) {
 			if (pdata->leds[i].name)
-				snprintf(pca955x[i].name,
-					 sizeof(pca955x[i].name), "pca955x:%s",
-					 pdata->leds[i].name);
+				snprintf(pca955x_led->name,
+					sizeof(pca955x_led->name), "pca955x:%s",
+					pdata->leds[i].name);
 			if (pdata->leds[i].default_trigger)
-				pca955x[i].led_cdev.default_trigger =
+				pca955x_led->led_cdev.default_trigger =
 					pdata->leds[i].default_trigger;
 		} else {
-			snprintf(pca955x[i].name, sizeof(pca955x[i].name),
+			snprintf(pca955x_led->name, sizeof(pca955x_led->name),
 				 "pca955x:%d", i);
 		}
 
-		spin_lock_init(&pca955x[i].lock);
-
-		pca955x[i].led_cdev.name = pca955x[i].name;
-		pca955x[i].led_cdev.brightness_set = pca955x_led_set;
+		pca955x_led->led_cdev.name = pca955x_led->name;
+		pca955x_led->led_cdev.brightness_set = pca955x_led_set;
 
-		INIT_WORK(&pca955x[i].work, pca955x_led_work);
+		INIT_WORK(&pca955x_led->work, pca955x_led_work);
 
-		err = led_classdev_register(&client->dev, &pca955x[i].led_cdev);
+		err = led_classdev_register(&client->dev,
+					&pca955x_led->led_cdev);
 		if (err < 0)
 			goto exit;
 	}
@@ -337,10 +357,12 @@ static int __devinit pca955x_probe(struc
 
 exit:
 	while (i--) {
-		led_classdev_unregister(&pca955x[i].led_cdev);
-		cancel_work_sync(&pca955x[i].work);
+		led_classdev_unregister(&pca955x->leds[i].led_cdev);
+		cancel_work_sync(&pca955x->leds[i].work);
 	}
 
+	kfree(pca955x->leds);
+exit_nomem:
 	kfree(pca955x);
 
 	return err;
@@ -348,14 +370,15 @@ exit:
 
 static int __devexit pca955x_remove(struct i2c_client *client)
 {
-	struct pca955x_led *pca955x = i2c_get_clientdata(client);
+	struct pca955x *pca955x = i2c_get_clientdata(client);
 	int i;
 
 	for (i = 0; i < pca955x->chipdef->bits; i++) {
-		led_classdev_unregister(&pca955x[i].led_cdev);
-		cancel_work_sync(&pca955x[i].work);
+		led_classdev_unregister(&pca955x->leds[i].led_cdev);
+		cancel_work_sync(&pca955x->leds[i].work);
 	}
 
+	kfree(pca955x->leds);
 	kfree(pca955x);
 
 	return 0;
_

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

origin.patch
linux-next.patch

