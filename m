From: akpm@linux-foundation.org
Subject: + of-gpio-implement-gpiolib-notifier-hooks.patch added to -mm tree
Date: Mon, 08 Feb 2010 13:03:03 -0800
Message-ID: <201002082103.o18L33mt002800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab0BHVDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 16:03:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, bgat@billgatliff.com, dbaryshkov@gmail.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, khali@linux-fr.org


The patch titled
     of/gpio: implement GPIOLIB notifier hooks
has been added to the -mm tree.  Its filename is
     of-gpio-implement-gpiolib-notifier-hooks.patch

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
Subject: of/gpio: implement GPIOLIB notifier hooks
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Implement GPIOLIB notifier hooks, and thus make device-enabled GPIO chips
(i.e.  the ones that have gpio_chip->dev specified) automatically attach
to the OpenFirmware subsystem.  Which means that now we can handle I2C and
SPI GPIO chips almost* transparently.

* "Almost" because some chips still require platform data, and for these
  chips OF-glue is still needed, though with this support the glue will
  be much smaller.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/gpio.c |  100 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff -puN drivers/of/gpio.c~of-gpio-implement-gpiolib-notifier-hooks drivers/of/gpio.c
--- a/drivers/of/gpio.c~of-gpio-implement-gpiolib-notifier-hooks
+++ a/drivers/of/gpio.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/notifier.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
@@ -236,3 +237,102 @@ err0:
 	return ret;
 }
 EXPORT_SYMBOL(of_mm_gpiochip_add);
+
+/**
+ * of_gpiochip_register_simple - Register a chip with the OF GPIO subsystem
+ * @chip	pointer to a GPIO chip
+ * @np:		device node to register the GPIO chip with
+ *
+ * This function registers a GPIO chip with the OF infrastructure. It is
+ * assumed that the chip was previsously allocated and added to a generic
+ * GPIOLIB framework (using gpiochip_add() function).
+ *
+ * The `simple' name means that the chip is using simple two-cells scheme for
+ * the gpio-specifier.
+ */
+static int of_gpiochip_register_simple(struct gpio_chip *chip,
+				       struct device_node *np)
+{
+	struct of_gpio_chip *of_gc;
+
+	if (np->data) {
+		WARN_ON(1);
+		return -EBUSY;
+	}
+
+	of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
+	if (!of_gc)
+		return -ENOMEM;
+
+	of_gc->gpio_cells = 2;
+	of_gc->xlate = of_gpio_simple_xlate;
+	of_gc->chip = chip;
+	np->data = of_gc;
+	of_node_get(np);
+
+	return 0;
+}
+EXPORT_SYMBOL(of_gpiochip_register_simple);
+
+/**
+ * of_gpiochip_unregister - Unregister a GPIO chip
+ * @chip	pointer to a GPIO chip
+ * @np:		device node for which the GPIO chip was previously registered
+ *
+ * This function unregisters a GPIO chip that was previsously registered
+ * with of_gpiochip_register*().
+ */
+static int of_gpiochip_unregister(struct gpio_chip *chip,
+				  struct device_node *np)
+{
+	struct of_gpio_chip *of_gc = np->data;
+
+	if (!of_gc || of_gc->chip != chip) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	np->data = NULL;
+	kfree(of_gc);
+	of_node_put(np);
+
+	return 0;
+}
+
+static int of_gpio_notify(struct notifier_block *nb, unsigned long msg,
+			  void *chip)
+{
+	struct gpio_chip *gc = chip;
+	struct device_node *np;
+	int ret = 0;
+
+	if (!gc->dev)
+		return NOTIFY_DONE;
+
+	np = dev_archdata_get_node(&gc->dev->archdata);
+	if (!np)
+		return NOTIFY_DONE;
+
+	switch (msg) {
+	case GPIO_NOTIFY_CHIP_ADDED:
+		ret = of_gpiochip_register_simple(gc, np);
+		break;
+	case GPIO_NOTIFY_CHIP_REMOVE:
+		ret = of_gpiochip_unregister(gc, np);
+		break;
+	default:
+		break;
+	}
+
+	return ret ? notifier_from_errno(ret) : NOTIFY_OK;
+}
+
+static struct notifier_block of_gpio_nb = {
+	.notifier_call = of_gpio_notify,
+};
+
+static int __init of_gpio_notifier_init(void)
+{
+	return blocking_notifier_chain_register(&gpio_notifier, &of_gpio_nb);
+}
+arch_initcall(of_gpio_notifier_init);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

