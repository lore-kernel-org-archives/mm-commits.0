From: akpm@osdl.org
Subject: + at91-gpio-wrappers.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:13:45 -0800
Message-ID: <200612210613.kBL6DjHU017392@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422763AbWLUGN4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:13:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     AT91 GPIO wrappers
has been added to the -mm tree.  Its filename is
     at91-gpio-wrappers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AT91 GPIO wrappers
From: David Brownell <david-b@pacbell.net>

This is a first cut at making the AT91 code use the generic GPIO calls.

Note that the original AT91 GPIO calls merged the "mux pin as GPIO" and "set
GPIO direction" functionality into one API call, contrary to what's specified
as a cross-platform portable model.  So this involved a few non-inlinable
functions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/mach-at91rm9200/gpio.c        |   48 +++++++++++++++++++++++
 include/asm-arm/arch-at91rm9200/gpio.h |   37 +++++++++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-at91rm9200/gpio.c~at91-gpio-wrappers arch/arm/mach-at91rm9200/gpio.c
--- a/arch/arm/mach-at91rm9200/gpio.c~at91-gpio-wrappers
+++ a/arch/arm/mach-at91rm9200/gpio.c
@@ -66,6 +66,24 @@ static inline unsigned pin_to_mask(unsig
 
 
 /*
+ * mux the pin to the "GPIO" peripheral role.
+ */
+int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup)
+{
+	void __iomem	*pio = pin_to_controller(pin);
+	unsigned	mask = pin_to_mask(pin);
+
+	if (!pio)
+		return -EINVAL;
+	__raw_writel(mask, pio + PIO_IDR);
+	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
+	__raw_writel(mask, pio + PIO_PER);
+	return 0;
+}
+EXPORT_SYMBOL(at91_set_GPIO_periph);
+
+
+/*
  * mux the pin to the "A" internal peripheral role.
  */
 int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup)
@@ -182,6 +200,36 @@ EXPORT_SYMBOL(at91_set_multi_drive);
 
 /*--------------------------------------------------------------------------*/
 
+/* new-style GPIO calls; these expect at91_set_GPIO_periph to have been
+ * called, and maybe at91_set_multi_drive() for putout pins.
+ */
+
+int gpio_direction_input(unsigned pin)
+{
+	void __iomem	*pio = pin_to_controller(pin);
+	unsigned	mask = pin_to_mask(pin);
+
+	if (!pio || !(__raw_readl(pio + PIO_PSR) & mask))
+		return -EINVAL;
+	__raw_writel(mask, pio + PIO_OER);
+	return 0;
+}
+EXPORT_SYMBOL(gpio_direction_input);
+
+int gpio_direction_output(unsigned pin)
+{
+	void __iomem	*pio = pin_to_controller(pin);
+	unsigned	mask = pin_to_mask(pin);
+
+	if (!pio || !(__raw_readl(pio + PIO_PSR) & mask))
+		return -EINVAL;
+	__raw_writel(mask, pio + PIO_OER);
+	return 0;
+}
+EXPORT_SYMBOL(gpio_direction_output);
+
+/*--------------------------------------------------------------------------*/
+
 /*
  * assuming the pin is muxed as a gpio output, set its value.
  */
diff -puN include/asm-arm/arch-at91rm9200/gpio.h~at91-gpio-wrappers include/asm-arm/arch-at91rm9200/gpio.h
--- a/include/asm-arm/arch-at91rm9200/gpio.h~at91-gpio-wrappers
+++ a/include/asm-arm/arch-at91rm9200/gpio.h
@@ -179,6 +179,7 @@
 
 #ifndef __ASSEMBLY__
 /* setup setup routines, called from board init or driver probe() */
+extern int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup);
 extern int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup);
 extern int __init_or_module at91_set_B_periph(unsigned pin, int use_pullup);
 extern int __init_or_module at91_set_gpio_input(unsigned pin, int use_pullup);
@@ -193,7 +194,41 @@ extern int at91_get_gpio_value(unsigned 
 /* callable only from core power-management code */
 extern void at91_gpio_suspend(void);
 extern void at91_gpio_resume(void);
-#endif
+
+/*-------------------------------------------------------------------------*/
+
+/* wrappers for "new style" GPIO calls. the old AT91-specfic ones should
+ * eventually be removed (along with this errno.h inclusion), and the
+ * gpio request/free calls should probably be implemented.
+ */
+
+#include <asm/errno.h>
+
+static inline int gpio_request(unsigned gpio, const char *label)
+	{ return 0; }
+
+static inline void gpio_free(unsigned gpio)
+	{ }
+
+
+extern int gpio_direction_input(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio);
+
+static inline int gpio_get_value(unsigned gpio)
+	{ return at91_get_gpio_value(gpio); }
+
+static inline void gpio_set_value(unsigned gpio, int value)
+	{ (void) at91_set_gpio_value(gpio, value); }
+
+#include <asm-generic/gpio.h>		/* cansleep wrappers */
+
+static inline int gpio_to_irq(unsigned gpio)
+	{ return gpio; }
+
+static inline int irq_to_gpio(unsigned irq)
+	{ return irq; }
+
+#endif	/* __ASSEMBLY__ */
 
 #endif
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

