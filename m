From: akpm@linux-foundation.org
Subject: + oz99x-i2c-button-and-led-support-driver-update.patch added to -mm tree
Date: Mon, 07 Jan 2008 16:05:04 -0800
Message-ID: <200801080005.m08054SA019048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbYAHAGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:06:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: post@hendrik-sattler.de, khali@linux-fr.org, rpurdie@rpsys.net


The patch titled
     oz99x-i2c-button-and-led-support-driver update
has been added to the -mm tree.  Its filename is
     oz99x-i2c-button-and-led-support-driver-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oz99x-i2c-button-and-led-support-driver update
From: Hendrik Sattler <post@hendrik-sattler.de>

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/Kconfig |    1 
 drivers/i2c/chips/oz99x.c |   65 +++++++++++++++++++++---------------
 2 files changed, 38 insertions(+), 28 deletions(-)

diff -puN drivers/i2c/chips/Kconfig~oz99x-i2c-button-and-led-support-driver-update drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~oz99x-i2c-button-and-led-support-driver-update
+++ a/drivers/i2c/chips/Kconfig
@@ -139,7 +139,6 @@ config OZ99X
 	tristate "O2 Micro/ETC OZ990/OZ992 SMBus chip"
 	depends on I2C
 	select INPUT_POLLDEV
-	select LEDS_CLASS
 	help
 	  If you say Y here, you get support for the OZ990 and OZ992 chip
 	  from O2 Micro. This driver provides support for buttons and
diff -puN drivers/i2c/chips/oz99x.c~oz99x-i2c-button-and-led-support-driver-update drivers/i2c/chips/oz99x.c
--- a/drivers/i2c/chips/oz99x.c~oz99x-i2c-button-and-led-support-driver-update
+++ a/drivers/i2c/chips/oz99x.c
@@ -54,17 +54,6 @@ struct oz99x_data {
 	} range;
 };
 
-struct oz99x_led_data {
-	struct oz99x_data *data;
-
-	int gpio;
-	char name[8];
-	struct led_classdev cdev;
-
-	struct list_head list;
-};
-#define oz99x_from_led_cdev(c) container_of(c, struct oz99x_led_data, cdev)
-
 #define oz99x_reg_write(client, reg, value) \
 	i2c_smbus_write_word_data(client, reg, value)
 #define oz99x_reg_read(client, reg) i2c_smbus_read_word_data(client, reg)
@@ -231,6 +220,18 @@ static DEVICE_ATTR(regs, 0444, regs_show
 #define OZ99X_CHIPID_ID(n)  (((n) >> 8) & 0x00FF)
 #define OZ99X_CHIPID_REV(n) ((n) & 0x00FF)
 
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+struct oz99x_led_data {
+	struct oz99x_data *data;
+
+	int gpio;
+	char name[8];
+	struct led_classdev cdev;
+
+	struct list_head list;
+};
+#define oz99x_from_led_cdev(c) container_of(c, struct oz99x_led_data, cdev)
+
 static
 int oz99x_find_leds(struct i2c_client *client)
 {
@@ -318,6 +319,21 @@ void oz99x_configure_leds(struct oz99x_d
 }
 
 static
+void __devexit oz99x_cleanup_leds (struct oz99x_data* data)
+{
+	struct list_head *pos;
+	list_for_each(pos, &data->leds) {
+		struct oz99x_led_data *ldata =
+			list_entry(pos, struct oz99x_led_data, list);
+		led_classdev_unregister(&ldata->cdev);
+		kfree(ldata);
+	}
+}
+#else
+#define oz99x_cleanup_leds(data)
+#endif /* CONFIG_LEDS_CLASS */
+
+static
 int oz99x_find_buttons(struct i2c_client *client)
 {
 	int i;
@@ -578,8 +594,7 @@ int __devinit oz99x_probe(struct i2c_cli
 	struct oz99x_data *data;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	int id;
-	int buttons;
-	int leds;
+	int lines;
 	int status = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
@@ -598,22 +613,24 @@ int __devinit oz99x_probe(struct i2c_cli
 		goto out;
 	}
 
-	buttons = oz99x_find_buttons(client);
-	if (!buttons) {
+	lines = oz99x_find_buttons(client);
+	if (!lines) {
 		dev_info(&client->dev, "no buttons configured.\n");
 	} else {
-		status = oz99x_configure_buttons(client, buttons);
+		status = oz99x_configure_buttons(client, lines);
 		if (!status)
-			status = oz99x_buttons_poll_setup(data, buttons);
+			status = oz99x_buttons_poll_setup(data, lines);
 		if (status)
 			goto out;
 	}
 
-	leds = oz99x_find_leds(client);
-	if (!leds)
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	lines = oz99x_find_leds(client);
+	if (!lines)
 		dev_info(&client->dev, "no LEDs configured.\n");
 	else
-		oz99x_configure_leds(data, leds);
+		oz99x_configure_leds(data, lines);
+#endif /* CONFIG_LEDS_CLASS */
 
 	switch (id) {
 	case 0x90:
@@ -642,7 +659,6 @@ out:
 static
 int __devexit oz99x_remove(struct i2c_client *client)
 {
-	struct list_head *pos;
 	struct oz99x_data *data = i2c_get_clientdata(client);
 
 	if (data->ipdev)
@@ -654,12 +670,7 @@ int __devexit oz99x_remove(struct i2c_cl
 		device_remove_file(&client->dev, &dev_attr_regs_max);
 	}
 
-	list_for_each(pos, &data->leds) {
-		struct oz99x_led_data *ldata =
-			list_entry(pos, struct oz99x_led_data, list);
-		led_classdev_unregister(&ldata->cdev);
-		kfree(ldata);
-	}
+	oz99x_cleanup_leds(data);
 
 	kfree(data);
 	return 0;
_

Patches currently in -mm which might be from post@hendrik-sattler.de are

oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
fjkeyinf-driver-for-fsc-lifebook-laptops.patch
