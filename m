From: akpm@linux-foundation.org
Subject: [merged] leds-leds-pca9532-cleanups.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:17 -0800
Message-ID: <201101132005.p0DK5wZe029680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933472Ab1AMUGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:06:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, dtor@mail.ru, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: leds-pca9532 cleanups
has been removed from the -mm tree.  Its filename was
     leds-leds-pca9532-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: leds-pca9532 cleanups
From: Axel Lin <axel.lin@gmail.com>

- Remove unneeded input_free_device() after input_unregister_device().

- Add pca9532_destroy_devices() function for destroy devices.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |   66 ++++++++++++++--------------------
 1 file changed, 28 insertions(+), 38 deletions(-)

diff -puN drivers/leds/leds-pca9532.c~leds-leds-pca9532-cleanups drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-leds-pca9532-cleanups
+++ a/drivers/leds/leds-pca9532.c
@@ -200,6 +200,32 @@ static void pca9532_led_work(struct work
 	pca9532_setled(led);
 }
 
+static void pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
+{
+	int i = n_devs;
+
+	if (!data)
+		return;
+
+	while (--i >= 0) {
+		switch (data->leds[i].type) {
+		case PCA9532_TYPE_NONE:
+			break;
+		case PCA9532_TYPE_LED:
+			led_classdev_unregister(&data->leds[i].ldev);
+			cancel_work_sync(&data->leds[i].work);
+			break;
+		case PCA9532_TYPE_N2100_BEEP:
+			if (data->idev != NULL) {
+				input_unregister_device(data->idev);
+				cancel_work_sync(&data->work);
+				data->idev = NULL;
+			}
+			break;
+		}
+	}
+}
+
 static int pca9532_configure(struct i2c_client *client,
 	struct pca9532_data *data, struct pca9532_platform_data *pdata)
 {
@@ -274,25 +300,7 @@ static int pca9532_configure(struct i2c_
 	return 0;
 
 exit:
-	if (i > 0)
-		for (i = i - 1; i >= 0; i--)
-			switch (data->leds[i].type) {
-			case PCA9532_TYPE_NONE:
-				break;
-			case PCA9532_TYPE_LED:
-				led_classdev_unregister(&data->leds[i].ldev);
-				cancel_work_sync(&data->leds[i].work);
-				break;
-			case PCA9532_TYPE_N2100_BEEP:
-				if (data->idev != NULL) {
-					input_unregister_device(data->idev);
-					input_free_device(data->idev);
-					cancel_work_sync(&data->work);
-					data->idev = NULL;
-				}
-				break;
-			}
-
+	pca9532_destroy_devices(data, i);
 	return err;
 }
 
@@ -329,25 +337,7 @@ static int pca9532_probe(struct i2c_clie
 static int pca9532_remove(struct i2c_client *client)
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
-	int i;
-	for (i = 0; i < 16; i++)
-		switch (data->leds[i].type) {
-		case PCA9532_TYPE_NONE:
-			break;
-		case PCA9532_TYPE_LED:
-			led_classdev_unregister(&data->leds[i].ldev);
-			cancel_work_sync(&data->leds[i].work);
-			break;
-		case PCA9532_TYPE_N2100_BEEP:
-			if (data->idev != NULL) {
-				input_unregister_device(data->idev);
-				input_free_device(data->idev);
-				cancel_work_sync(&data->work);
-				data->idev = NULL;
-			}
-			break;
-		}
