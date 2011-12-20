From: akpm@linux-foundation.org
Subject: + leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available.patch added to -mm tree
Date: Tue, 20 Dec 2011 14:21:16 -0800
Message-ID: <20111220222117.545E35C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:55046 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:21:19 -0500
Received: by faar15 with SMTP id r15so235474faa.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:21:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, rdunlap@xenotime.net


The patch titled
     Subject: leds-tca6507: allow driver to compile when GPIOLIB is not available.
has been added to the -mm tree.  Its filename is
     leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available.patch

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
From: NeilBrown <neilb@suse.de>
Subject: leds-tca6507: allow driver to compile when GPIOLIB is not available.

This driver can configure the outputs as GPIO line instead of LEDs.  But
that only works if GPIOLIB is available.  So make that code conditional on
the library's availability.

Also remove the 'teardown' callback as it is never called and should
never be needed.

Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c  |   92 ++++++++++++++++++++++-----------
 include/linux/leds-tca6507.h |    3 -
 2 files changed, 65 insertions(+), 30 deletions(-)

diff -puN drivers/leds/leds-tca6507.c~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available
+++ a/drivers/leds/leds-tca6507.c
@@ -155,9 +155,11 @@ struct tca6507_chip {
 		int			bank;	/* Bank used, or -1 */
 		int			blink;	/* 1 if we are hardware-blinking */
 	} leds[NUM_LEDS];
+#ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
 	const char			*gpio_name[NUM_LEDS];
 	int				gpio_map[NUM_LEDS];
+#endif
 };
 
 static const struct i2c_device_id tca6507_id[] = {
@@ -528,6 +530,7 @@ static int tca6507_blink_set(struct led_
 	return 0;
 }
 
+#ifdef CONFIG_GPIOLIB
 static void tca6507_gpio_set_value(struct gpio_chip *gc,
 				   unsigned offset, int val)
 {
@@ -551,6 +554,62 @@ static int tca6507_gpio_direction_output
 	tca6507_gpio_set_value(gc, offset, val);
 	return 0;
 }
+static int tca6507_probe_gpios(struct i2c_client *client,
+			       struct tca6507_chip *tca,
+			       struct tca6507_platform_data *pdata)
+{
+	int err;
+	int i = 0;
+	int gpios = 0;
+
+	for (i = 0; i < NUM_LEDS; i++)
+		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
+			/* Configure as a gpio */
+			tca->gpio_name[gpios] = pdata->leds.leds[i].name;
+			tca->gpio_map[gpios] = i;
+			gpios++;
+		}
+
+	if (!gpios)
+		return 0;
+
+	tca->gpio.label = "gpio-tca6507";
+	tca->gpio.names = tca->gpio_name;
+	tca->gpio.ngpio = gpios;
+	tca->gpio.base = pdata->gpio_base;
+	tca->gpio.owner = THIS_MODULE;
+	tca->gpio.direction_output = tca6507_gpio_direction_output;
+	tca->gpio.set = tca6507_gpio_set_value;
+	tca->gpio.dev = &client->dev;
+	err = gpiochip_add(&tca->gpio);
+	if (err) {
+		tca->gpio.ngpio = 0;
+		return err;
+	}
+	if (pdata->setup)
+		pdata->setup(tca->gpio.base, tca->gpio.ngpio);
+	return 0;
+}
+
+static void tca6507_remove_gpio(struct tca6507_chip *tca)
+{
+	if (tca->gpio.ngpio) {
+		int err = gpiochip_remove(&tca->gpio);
+		dev_err(&tca->client->dev, "%s failed, %d\n",
+			"gpiochip_remove()", err);
+	}
+}
+#else /* CONFIG_GPIOLIB */
+static int tca6507_probe_gpios(struct i2c_client *client,
+			       struct tca6507_chip *tca,
+			       struct tca6507_platform_data *pdata)
+{
+	return 0;
+}
+static void tca6507_remove_gpio(struct tca6507_chip *tca)
+{
+}
+#endif /* CONFIG_GPIOLIB */
 
 static int __devinit tca6507_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
@@ -560,7 +619,6 @@ static int __devinit tca6507_probe(struc
 	struct tca6507_platform_data *pdata;
 	int err;
 	int i = 0;
-	int gpios = 0;
 
 	adapter = to_i2c_adapter(client->dev.parent);
 	pdata = client->dev.platform_data;
@@ -599,30 +657,10 @@ static int __devinit tca6507_probe(struc
 			if (err < 0)
 				goto exit;
 		}
-		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
-			/* Configure as a gpio */
-			tca->gpio_name[gpios] = pdata->leds.leds[i].name;
-			tca->gpio_map[gpios] = i;
-			gpios++;
-		}
-	}
-	if (gpios) {
-		tca->gpio.label = "gpio-tca6507";
-		tca->gpio.names = tca->gpio_name;
-		tca->gpio.ngpio = gpios;
-		tca->gpio.base = pdata->gpio_base;
-		tca->gpio.owner = THIS_MODULE;
-		tca->gpio.direction_output = tca6507_gpio_direction_output;
-		tca->gpio.set = tca6507_gpio_set_value;
-		tca->gpio.dev = &client->dev;
-		err = gpiochip_add(&tca->gpio);
-		if (err) {
-			tca->gpio.ngpio = 0;
-			goto exit;
-		}
-		if (pdata->setup)
-			pdata->setup(tca->gpio.base, tca->gpio.ngpio);
 	}
+	err = tca6507_probe_gpios(client, tca, pdata);
+	if (err)
+		goto exit;
 	i2c_set_clientdata(client, tca);
 	/* set all registers to known state - zero */
 	tca->reg_set = 0x7f;
@@ -647,11 +685,7 @@ static int __devexit tca6507_remove(stru
 		if (tca_leds[i].led_cdev.name)
 			led_classdev_unregister(&tca_leds[i].led_cdev);
 	}
-	if (tca->gpio.ngpio) {
-		int err = gpiochip_remove(&tca->gpio);
-		dev_err(&tca->client->dev, "%s failed, %d\n",
-			"gpiochip_remove()", err);
-	}
+	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
 	kfree(tca);
 	i2c_set_clientdata(client, NULL);
diff -puN include/linux/leds-tca6507.h~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available include/linux/leds-tca6507.h
--- a/include/linux/leds-tca6507.h~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available
+++ a/include/linux/leds-tca6507.h
@@ -24,9 +24,10 @@
 
 struct tca6507_platform_data {
 	struct led_platform_data leds;
+#ifdef CONFIG_GPIOLIB
 	int gpio_base;
 	void (*setup)(unsigned gpio_base, unsigned ngpio);
-	void (*teardown)(unsigned gpio_base, unsigned ngpio);
+#endif
 };
 
 #define	TCA6507_MAKE_GPIO 1
_
Subject: Subject: leds-tca6507: allow driver to compile when GPIOLIB is not available.

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
leds-add-driver-for-tca6507-led-controller.patch
leds-add-driver-for-tca6507-led-controller-fix.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available.patch
leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch
leds-tca6507-fix-off-by-one-error.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

