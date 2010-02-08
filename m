From: akpm@linux-foundation.org
Subject: + of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch added to -mm tree
Date: Mon, 08 Feb 2010 13:03:00 -0800
Message-ID: <201002082103.o18L301a002796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab0BHVDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 16:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, bgat@billgatliff.com, dbaryshkov@gmail.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     of/gpio: add support for two-stage registration for the of_gpio_chips
has been added to the -mm tree.  Its filename is
     of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch

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
Subject: of/gpio: add support for two-stage registration for the of_gpio_chips
From: Anton Vorontsov <avorontsov@ru.mvista.com>

I2C/SPI drivers allocate gpio_chip structure already, so we don't need
'struct gpio_chip gc' in the OF GPIO subsystem, instead we need to store
just a pointer, and then attach the already allocated gpio_chip to the
of_gpio_chip structure.

With this patch there are two ways to register OF GPIO controllers:

1. Allocating the of_gpio_chip structure and passing the
   &of_gc->gc pointer to the gpiochip_add. (Can use container_of
   to convert the gpio_chip to the of_gpio_chip.)

2. Allocating and registering the gpio_chip structure separately
   from the of_gpio_chip. (Since two allocations are separate,
   container_of won't work.)

As time goes by we'll kill the first option.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |    1 
 drivers/of/gpio.c                              |   23 +++++++++++++--
 include/linux/of_gpio.h                        |    3 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c~of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c~of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips
+++ a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -93,6 +93,7 @@ static int mcu_gpiochip_add(struct mcu *
 	gc->base = -1;
 	gc->set = mcu_gpio_set;
 	gc->direction_output = mcu_gpio_dir_out;
+	of_gc->chip = gc;
 	of_gc->gpio_cells = 2;
 	of_gc->xlate = of_gpio_simple_xlate;
 
diff -puN drivers/of/gpio.c~of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips drivers/of/gpio.c
--- a/drivers/of/gpio.c~of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips
+++ a/drivers/of/gpio.c
@@ -70,7 +70,7 @@ int of_get_gpio_flags(struct device_node
 	if (ret < 0)
 		goto err1;
 
-	ret += of_gc->gc.base;
+	ret += of_gc->chip->base;
 err1:
 	of_node_put(gc);
 err0:
@@ -140,7 +140,7 @@ int of_gpio_simple_xlate(struct of_gpio_
 		return -EINVAL;
 	}
 
-	if (*gpio > of_gc->gc.ngpio)
+	if (*gpio > of_gc->chip->ngpio)
 		return -EINVAL;
 
 	if (flags)
@@ -178,6 +178,25 @@ int of_mm_gpiochip_add(struct device_nod
 	struct of_gpio_chip *of_gc = &mm_gc->of_gc;
 	struct gpio_chip *gc = &of_gc->gc;
 
+	/*
+	 * Currently there are two ways to register OF GPIO controllers:
+	 *
+	 * 1. Allocating the of_gpio_chip structure and passing the
+	 *    &of_gc->gc pointer to the gpiochip_add. (Can use container_of
+	 *    to convert the gpio_chip to the of_gpio_chip.)
+	 *
+	 * 2. Allocating and registering the gpio_chip structure separately
+	 *    from the of_gpio_chip. (Since two allocations are separate,
+	 *    container_of won't work.)
+	 *
+	 * As time goes by we'll kill the first option. For now just check
+	 * if it's the new-style registration or the old-style.
+	 */
+	if (!of_gc->chip)
+		of_gc->chip = gc;
+	else
+		gc = of_gc->chip;
+
 	gc->label = kstrdup(np->full_name, GFP_KERNEL);
 	if (!gc->label)
 		goto err0;
diff -puN include/linux/of_gpio.h~of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips include/linux/of_gpio.h
--- a/include/linux/of_gpio.h~of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips
+++ a/include/linux/of_gpio.h
@@ -36,7 +36,8 @@ enum of_gpio_flags {
  * Generic OF GPIO chip
  */
 struct of_gpio_chip {
-	struct gpio_chip gc;
+	struct gpio_chip gc; /* legacy, don't use for a new code */
+	struct gpio_chip *chip;
 	int gpio_cells;
 	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
 		     const void *gpio_spec, enum of_gpio_flags *flags);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

