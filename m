From: akpm@linux-foundation.org
Subject: + leds-pca9532-fix-memory-leak-and-properly-handle-errors.patch added to -mm tree
Date: Thu, 20 Nov 2008 13:53:48 -0800
Message-ID: <200811202153.mAKLrmWo011833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589AbYKTVyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 16:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, riku.voipio@iki.fi, rpurdie@rpsys.net


The patch titled
     leds-pca9532: fix memory leak and properly handle errors
has been added to the -mm tree.  Its filename is
     leds-pca9532-fix-memory-leak-and-properly-handle-errors.patch

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
Subject: leds-pca9532: fix memory leak and properly handle errors
From: Sven Wegener <sven.wegener@stealer.net>

When the registration fails, we need to release the memory we allocated. 
Also we need to save the error from led_classdev_register and propagate it
up, else we'll return success, even if we failed.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/leds/leds-pca9532.c~leds-pca9532-fix-memory-leak-and-properly-handle-errors drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-pca9532-fix-memory-leak-and-properly-handle-errors
+++ a/drivers/leds/leds-pca9532.c
@@ -204,8 +204,8 @@ static int pca9532_configure(struct i2c_
 			led->ldev.brightness = LED_OFF;
 			led->ldev.brightness_set = pca9532_set_brightness;
 			led->ldev.blink_set = pca9532_set_blink;
-			if (led_classdev_register(&client->dev,
-				&led->ldev) < 0)	{
+			err = led_classdev_register(&client->dev, &led->ldev);
+			if (err < 0) {
 				dev_err(&client->dev,
 					"couldn't register LED %s\n",
 					led->name);
@@ -263,7 +263,6 @@ exit:
 			}
 
 	return err;
-
 }
 
 static int pca9532_probe(struct i2c_client *client,
@@ -271,12 +270,16 @@ static int pca9532_probe(struct i2c_clie
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
 	struct pca9532_platform_data *pca9532_pdata = client->dev.platform_data;
+	int err;
+
+	if (!pca9532_pdata)
+		return -EIO;
 
 	if (!i2c_check_functionality(client->adapter,
 		I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	data = kzalloc(sizeof(struct pca9532_data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -285,12 +288,13 @@ static int pca9532_probe(struct i2c_clie
 	data->client = client;
 	mutex_init(&data->update_lock);
 
-	if (pca9532_pdata == NULL)
-		return -EIO;
