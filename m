From: akpm@linux-foundation.org
Subject: + leds-leds-pca9532-add-support-pca9530-pca9531-and-pca9533.patch added to -mm tree
Date: Wed, 18 May 2011 16:11:24 -0700
Message-ID: <201105182311.p4INBOSq030477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769Ab1ERXLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 19:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.weitzel@phytec.de, grant.likely@secretlab.ca, hsweeten@visionengravers.com, j.kilb@phytec.de, joachim.eastwood@jotron.com, rpurdie@rpsys.net, w.sang@pengutronix.de


The patch titled
     drivers/leds/leds-pca9532.c: add support pca9530, pca9531 and pca9533
has been added to the -mm tree.  Its filename is
     leds-leds-pca9532-add-support-pca9530-pca9531-and-pca9533.patch

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
Subject: drivers/leds/leds-pca9532.c: add support pca9530, pca9531 and pca9533
From: Jan Weitzel <j.weitzel@phytec.de>

The pca953x family are only different in number of leds and register
layout Adding chipinfo to use driver with whole pca953x family Rename
driver to pca953x, but left files and platformflags named pca9532.

Tested with pca9530 and pca9533

Tested-by: Juergen Kilb <j.kilb@phytec.de>
Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
Acked-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Tested-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |   84 +++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 22 deletions(-)

diff -puN drivers/leds/leds-pca9532.c~leds-leds-pca9532-add-support-pca9530-pca9531-and-pca9533 drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-leds-pca9532-add-support-pca9530-pca9531-and-pca9533
+++ a/drivers/leds/leds-pca9532.c
@@ -1,13 +1,14 @@
 /*
  * pca9532.c - 16-bit Led dimmer
  *
+ * Copyright (C) 2011 Jan Weitzel
  * Copyright (C) 2008 Riku Voipio
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
  *
- * Datasheet: http://www.nxp.com/acrobat/datasheets/PCA9532_3.pdf
+ * Datasheet: http://www.nxp.com/documents/data_sheet/PCA9532.pdf
  *
  */
 
@@ -21,15 +22,20 @@
 #include <linux/leds-pca9532.h>
 #include <linux/gpio.h>
 
-#define PCA9532_REG_INPUT(i) ((i)/8)
-#define PCA9532_REG_PSC(i) (0x2+(i)*2)
-#define PCA9532_REG_PWM(i) (0x3+(i)*2)
-#define PCA9532_REG_LS0  0x6
-#define LED_REG(led) ((led>>2)+PCA9532_REG_LS0)
-#define LED_NUM(led) (led & 0x3)
+/* m =  num_leds*/
+#define PCA9532_REG_INPUT(i)	((i) >> 3)
+#define PCA9532_REG_OFFSET(m)	((m) >> 4)
+#define PCA9532_REG_PSC(m, i)	(PCA9532_REG_OFFSET(m) + 0x1 + (i) * 2)
+#define PCA9532_REG_PWM(m, i)	(PCA9532_REG_OFFSET(m) + 0x2 + (i) * 2)
+#define LED_REG(m, led)		(PCA9532_REG_OFFSET(m) + 0x5 + (led >> 2))
+#define LED_NUM(led)		(led & 0x3)
 
 #define ldev_to_led(c)       container_of(c, struct pca9532_led, ldev)
 
+struct pca9532_chip_info {
+	u8	num_leds;
+};
+
 struct pca9532_data {
 	struct i2c_client *client;
 	struct pca9532_led leds[16];
@@ -39,6 +45,7 @@ struct pca9532_data {
 #ifdef CONFIG_LEDS_PCA9532_GPIO
 	struct gpio_chip gpio;
 #endif
+	const struct pca9532_chip_info *chip_info;
 	u8 pwm[2];
 	u8 psc[2];
 };
@@ -47,16 +54,41 @@ static int pca9532_probe(struct i2c_clie
 	const struct i2c_device_id *id);
 static int pca9532_remove(struct i2c_client *client);
 
+enum {
+	pca9530,
+	pca9531,
+	pca9532,
+	pca9533,
+};
+
 static const struct i2c_device_id pca9532_id[] = {
-	{ "pca9532", 0 },
+	{ "pca9530", pca9530 },
+	{ "pca9531", pca9531 },
+	{ "pca9532", pca9532 },
+	{ "pca9533", pca9533 },
 	{ }
 };
 
 MODULE_DEVICE_TABLE(i2c, pca9532_id);
 
+static const struct pca9532_chip_info pca9532_chip_info_tbl[] = {
+	[pca9530] = {
+		.num_leds = 2,
+	},
+	[pca9531] = {
+		.num_leds = 8,
+	},
+	[pca9532] = {
+		.num_leds = 16,
+	},
+	[pca9533] = {
+		.num_leds = 4,
+	},
+};
+
 static struct i2c_driver pca9532_driver = {
 	.driver = {
-		.name = "pca9532",
+		.name = "pca953x",
 	},
 	.probe = pca9532_probe,
 	.remove = pca9532_remove,
@@ -73,7 +105,7 @@ static int pca9532_calcpwm(struct i2c_cl
 {
 	int a = 0, b = 0, i = 0;
 	struct pca9532_data *data = i2c_get_clientdata(client);
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < data->chip_info->num_leds; i++) {
 		if (data->leds[i].type == PCA9532_TYPE_LED &&
 			data->leds[i].state == PCA9532_PWM0+pwm) {
 				a++;
@@ -97,10 +129,12 @@ static int pca9532_calcpwm(struct i2c_cl
 static int pca9532_setpwm(struct i2c_client *client, int pwm)
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
+	u8 maxleds = data->chip_info->num_leds;
+
 	mutex_lock(&data->update_lock);
-	i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(pwm),
+	i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(maxleds, pwm),
 		data->pwm[pwm]);
-	i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(pwm),
+	i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(maxleds, pwm),
 		data->psc[pwm]);
 	mutex_unlock(&data->update_lock);
 	return 0;
@@ -111,15 +145,16 @@ static void pca9532_setled(struct pca953
 {
 	struct i2c_client *client = led->client;
 	struct pca9532_data *data = i2c_get_clientdata(client);
+	u8 maxleds = data->chip_info->num_leds;
 	char reg;
 
 	mutex_lock(&data->update_lock);
-	reg = i2c_smbus_read_byte_data(client, LED_REG(led->id));
+	reg = i2c_smbus_read_byte_data(client, LED_REG(maxleds, led->id));
 	/* zero led bits */
 	reg = reg & ~(0x3<<LED_NUM(led->id)*2);
 	/* set the new value */
 	reg = reg | (led->state << LED_NUM(led->id)*2);
-	i2c_smbus_write_byte_data(client, LED_REG(led->id), reg);
+	i2c_smbus_write_byte_data(client, LED_REG(maxleds, led->id), reg);
 	mutex_unlock(&data->update_lock);
 }
 
@@ -188,10 +223,12 @@ static int pca9532_event(struct input_de
 
 static void pca9532_input_work(struct work_struct *work)
 {
-	struct pca9532_data *data;
-	data = container_of(work, struct pca9532_data, work);
+	struct pca9532_data *data =
+		container_of(work, struct pca9532_data, work);
+	u8 maxleds = data->chip_info->num_leds;
+
 	mutex_lock(&data->update_lock);
-	i2c_smbus_write_byte_data(data->client, PCA9532_REG_PWM(1),
+	i2c_smbus_write_byte_data(data->client, PCA9532_REG_PWM(maxleds, 1),
 		data->pwm[1]);
 	mutex_unlock(&data->update_lock);
 }
@@ -301,17 +338,18 @@ static int pca9532_configure(struct i2c_
 {
 	int i, err = 0;
 	int gpios = 0;
+	u8 maxleds = data->chip_info->num_leds;
 
 	for (i = 0; i < 2; i++)	{
 		data->pwm[i] = pdata->pwm[i];
 		data->psc[i] = pdata->psc[i];
-		i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(i),
+		i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(maxleds, i),
 			data->pwm[i]);
-		i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(i),
+		i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(maxleds, i),
 			data->psc[i]);
 	}
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < data->chip_info->num_leds; i++) {
 		struct pca9532_led *led = &data->leds[i];
 		struct pca9532_led *pled = &pdata->leds[i];
 		led->client = client;
@@ -382,7 +420,7 @@ static int pca9532_configure(struct i2c_
 		data->gpio.request = pca9532_gpio_request_pin;
 		data->gpio.can_sleep = 1;
 		data->gpio.base = pdata->gpio_base;
-		data->gpio.ngpio = 16;
+		data->gpio.ngpio = data->chip_info->num_leds;
 		data->gpio.dev = &client->dev;
 		data->gpio.owner = THIS_MODULE;
 
@@ -424,6 +462,8 @@ static int pca9532_probe(struct i2c_clie
 	if (!data)
 		return -ENOMEM;
 
+	data->chip_info = &pca9532_chip_info_tbl[id->driver_data];
+
 	dev_info(&client->dev, "setting platform data\n");
 	i2c_set_clientdata(client, data);
 	data->client = client;
@@ -441,7 +481,7 @@ static int pca9532_remove(struct i2c_cli
 	struct pca9532_data *data = i2c_get_clientdata(client);
 	int err;
 
-	err = pca9532_destroy_devices(data, 16);
+	err = pca9532_destroy_devices(data, data->chip_info->num_leds);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from j.weitzel@phytec.de are

drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-leds-pca9532-add-support-pca9530-pca9531-and-pca9533.patch

