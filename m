From: akpm@linux-foundation.org
Subject: + powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch added to -mm tree
Date: Mon, 08 Feb 2010 13:03:07 -0800
Message-ID: <201002082103.o18L37fS002812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274Ab0BHVDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 16:03:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, bgat@billgatliff.com, dbaryshkov@gmail.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     powerpc/mcu_mpc8349emitx: remove OF GPIO handling stuff
has been added to the -mm tree.  Its filename is
     powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

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
Subject: powerpc/mcu_mpc8349emitx: remove OF GPIO handling stuff
From: Anton Vorontsov <avorontsov@ru.mvista.com>

With the new OF GPIO infrastructure it's much easier to handle I2C GPIO
controllers, i.e.  now drivers don't have to deal with the OF-specific
bits.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   68 +++------------
 1 file changed, 14 insertions(+), 54 deletions(-)

diff -puN arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c~powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c~powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff
+++ a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -18,8 +18,6 @@
 #include <linux/mutex.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
-#include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 
@@ -36,7 +34,7 @@ struct mcu {
 	struct mutex lock;
 	struct device_node *np;
 	struct i2c_client *client;
-	struct of_gpio_chip of_gc;
+	struct gpio_chip gc;
 	u8 reg_ctrl;
 };
 
@@ -55,8 +53,7 @@ static void mcu_power_off(void)
 
 static void mcu_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 {
-	struct of_gpio_chip *of_gc = to_of_gpio_chip(gc);
-	struct mcu *mcu = container_of(of_gc, struct mcu, of_gc);
+	struct mcu *mcu = container_of(gc, struct mcu, gc);
 	u8 bit = 1 << (4 + gpio);
 
 	mutex_lock(&mcu->lock);
@@ -75,53 +72,6 @@ static int mcu_gpio_dir_out(struct gpio_
 	return 0;
 }
 
-static int mcu_gpiochip_add(struct mcu *mcu)
-{
-	struct device_node *np;
-	struct of_gpio_chip *of_gc = &mcu->of_gc;
-	struct gpio_chip *gc = &of_gc->gc;
-	int ret;
-
-	np = of_find_compatible_node(NULL, NULL, "fsl,mcu-mpc8349emitx");
-	if (!np)
-		return -ENODEV;
-
-	gc->owner = THIS_MODULE;
-	gc->label = np->full_name;
-	gc->can_sleep = 1;
-	gc->ngpio = MCU_NUM_GPIO;
-	gc->base = -1;
-	gc->set = mcu_gpio_set;
-	gc->direction_output = mcu_gpio_dir_out;
-	of_gc->chip = gc;
-	of_gc->gpio_cells = 2;
-	of_gc->xlate = of_gpio_simple_xlate;
-
-	np->data = of_gc;
-	mcu->np = np;
-
-	/*
-	 * We don't want to lose the node, its ->data and ->full_name...
-	 * So, if succeeded, we don't put the node here.
-	 */
-	ret = gpiochip_add(gc);
-	if (ret)
-		of_node_put(np);
-	return ret;
-}
-
-static int mcu_gpiochip_remove(struct mcu *mcu)
-{
-	int ret;
-
-	ret = gpiochip_remove(&mcu->of_gc.gc);
-	if (ret)
-		return ret;
-	of_node_put(mcu->np);
-
-	return 0;
-}
-
 static int __devinit mcu_probe(struct i2c_client *client,
 			       const struct i2c_device_id *id)
 {
@@ -141,7 +91,16 @@ static int __devinit mcu_probe(struct i2
 		goto err;
 	mcu->reg_ctrl = ret;
 
-	ret = mcu_gpiochip_add(mcu);
+	mcu->gc.dev = &client->dev;
+	mcu->gc.owner = THIS_MODULE;
+	mcu->gc.label = dev_name(&client->dev);
+	mcu->gc.can_sleep = 1;
+	mcu->gc.ngpio = MCU_NUM_GPIO;
+	mcu->gc.base = -1;
+	mcu->gc.set = mcu_gpio_set;
+	mcu->gc.direction_output = mcu_gpio_dir_out;
+
+	ret = gpiochip_add(&mcu->gc);
 	if (ret)
 		goto err;
 
@@ -168,9 +127,10 @@ static int __devexit mcu_remove(struct i
 		glob_mcu = NULL;
 	}
 
-	ret = mcu_gpiochip_remove(mcu);
+	ret = gpiochip_remove(&mcu->gc);
 	if (ret)
 		return ret;
+
 	i2c_set_clientdata(client, NULL);
 	kfree(mcu);
 	return 0;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

