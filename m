From: akpm@linux-foundation.org
Subject: + xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:57 -0700
Message-ID: <200903310000.n2V00vTv031628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761781AbZCaAFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, chris@zankel.net, jw@emlix.com, os@emlix.com


The patch titled
     xtensa: support s6000 gpio irqs and alternate function selection
has been added to the -mm tree.  Its filename is
     xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch

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
Subject: xtensa: support s6000 gpio irqs and alternate function selection
From: Daniel Glockner <dg@emlix.com>

The patch implements an irq chip to handle interrupts via gpio.

As interrupts may be needed very early it is up to platform setup code
to initialize gpio by calling s6_setup_gpio. Its parameter is a bitmask
of those pins that should be configured for their alternative function.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/gpio.h                    |    8 
 arch/xtensa/platforms/s6105/setup.c               |    3 
 arch/xtensa/variants/s6000/gpio.c                 |  164 +++++++++++-
 arch/xtensa/variants/s6000/include/variant/gpio.h |    6 
 arch/xtensa/variants/s6000/include/variant/irq.h  |    1 
 5 files changed, 176 insertions(+), 6 deletions(-)

diff -puN arch/xtensa/include/asm/gpio.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/include/asm/gpio.h
--- a/arch/xtensa/include/asm/gpio.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/include/asm/gpio.h
@@ -38,14 +38,14 @@ static inline int gpio_cansleep(unsigned
 	return __gpio_cansleep(gpio);
 }
 
-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
+/*
+ * Not implemented, yet.
+ */
 static inline int irq_to_gpio(unsigned int irq)
 {
 	return -EINVAL;
diff -puN arch/xtensa/platforms/s6105/setup.c~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/platforms/s6105/setup.c
--- a/arch/xtensa/platforms/s6105/setup.c~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/platforms/s6105/setup.c
@@ -10,6 +10,8 @@
 #include <asm/bootparam.h>
 
 #include <variant/hardware.h>
+#include <variant/gpio.h>
+
 #include <platform/gpio.h>
 
 void platform_halt(void)
@@ -47,6 +49,7 @@ void __init platform_setup(char **cmdlin
 
 void __init platform_init(bp_tag_t *first)
 {
+	s6_setup_gpio(0);
 	gpio_request(GPIO_LED1_NGREEN, "led1_green");
 	gpio_request(GPIO_LED1_RED, "led1_red");
 	gpio_direction_output(GPIO_LED1_NGREEN, 1);
diff -puN arch/xtensa/variants/s6000/gpio.c~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/variants/s6000/gpio.c
--- a/arch/xtensa/variants/s6000/gpio.c~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/variants/s6000/gpio.c
@@ -4,15 +4,20 @@
  * Copyright (c) 2009 emlix GmbH
  * Authors:	Oskar Schirmer <os@emlix.com>
  *		Johannes Weiner <jw@emlix.com>
+ *		Daniel Gloeckner <dg@emlix.com>
  */
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/gpio.h>
 
 #include <variant/hardware.h>
 
+#define IRQ_BASE XTENSA_NR_IRQS
+
 #define S6_GPIO_DATA		0x000
 #define S6_GPIO_IS		0x404
 #define S6_GPIO_IBE		0x408
@@ -52,20 +57,175 @@ static void set(struct gpio_chip *chip, 
 	writeb(val ? ~0 : 0, S6_REG_GPIO + S6_GPIO_DATA + S6_GPIO_OFFSET(off));
 }
 
+static int to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset < 8)
+		return offset + IRQ_BASE;
+	return -EINVAL;
+}
+
 static struct gpio_chip gpiochip = {
 	.owner = THIS_MODULE,
 	.direction_input = direction_input,
 	.get = get,
 	.direction_output = direction_output,
 	.set = set,
+	.to_irq = to_irq,
 	.base = 0,
 	.ngpio = 24,
 	.can_sleep = 0, /* no blocking io needed */
 	.exported = 0, /* no exporting to userspace */
 };
 
-static int gpio_init(void)
+int __init s6_setup_gpio(u32 afsel)
 {
+	writeb(afsel, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_AFSEL);
+	writeb(afsel >> 8, S6_REG_GPIO + S6_GPIO_BANK(1) + S6_GPIO_AFSEL);
+	writeb(afsel >> 16, S6_REG_GPIO + S6_GPIO_BANK(2) + S6_GPIO_AFSEL);
 	return gpiochip_add(&gpiochip);
 }
-device_initcall(gpio_init);
+
+static void ack(unsigned int irq)
+{
+	writeb(1 << (irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
+}
+
+static void mask(unsigned int irq)
+{
+	u8 r = readb(S6_REG_GPIO + S6_GPIO_IE);
+	r &= ~(1 << (irq - IRQ_BASE));
+	writeb(r, S6_REG_GPIO + S6_GPIO_IE);
+}
+
+static void unmask(unsigned int irq)
+{
+	u8 m = readb(S6_REG_GPIO + S6_GPIO_IE);
+	m |= 1 << (irq - IRQ_BASE);
+	writeb(m, S6_REG_GPIO + S6_GPIO_IE);
+}
+
+static int set_type(unsigned int irq, unsigned int type)
+{
+	const u8 m = 1 << (irq - IRQ_BASE);
+	irq_flow_handler_t handler;
+	struct irq_desc *desc;
+	u8 reg;
+
+	if (type == IRQ_TYPE_PROBE) {
+		if ((readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_AFSEL) & m)
+		    || (readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IE) & m)
+		    || readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_DIR
+			      + S6_GPIO_MASK(irq - IRQ_BASE)))
+			return 0;
+		type = IRQ_TYPE_EDGE_BOTH;
+	}
+
+	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IS);
+	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH)) {
+		reg |= m;
+		handler = handle_level_irq;
+	} else {
+		reg = ~m;
+		handler = handle_edge_irq;
+	}
+	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IS);
+	desc = irq_to_desc(irq);
+	desc->handle_irq = handler;
+
+	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IEV);
+	if (type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING))
+		reg |= m;
+	else
+		reg &= ~m;
+	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IEV);
+
+	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IBE);
+	if ((type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
+		reg |= m;
+	else
+		reg &= ~m;
+	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IBE);
+	return 0;
+}
+
+static struct irq_chip gpioirqs = {
+	.name = "GPIO",
+	.ack = ack,
+	.mask = mask,
+	.unmask = unmask,
+	.set_type = set_type,
+};
+
+static u8 demux_masks[4];
+
+static void demux_irqs(unsigned int irq, struct irq_desc *desc)
+{
+	u8 *mask = get_irq_desc_data(desc);
+	u8 pending;
+	int cirq;
+
+	desc->chip->mask(irq);
+	desc->chip->ack(irq);
+	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
+	cirq = IRQ_BASE - 1;
+	while (pending) {
+		int n = ffs(pending);
+		cirq += n;
+		pending >>= n;
+		generic_handle_irq(cirq);
+	}
+	desc->chip->unmask(irq);
+}
+
+extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];
+
+void __init variant_init_IRQ(void)
+{
+	int irq, n;
+	writeb(0, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IE);
+	for (irq = n = 0; irq < XTENSA_NR_IRQS; irq++) {
+		const signed char *mapping = platform_irq_mappings[irq];
+		int alone = 1;
+		u8 mask;
+		if (!mapping)
+			continue;
+		for(mask = 0; *mapping != -1; mapping++)
+			switch (*mapping) {
+			case S6_INTC_GPIO(0):
+				mask |= 1 << 0;
+				break;
+			case S6_INTC_GPIO(1):
+				mask |= 1 << 1;
+				break;
+			case S6_INTC_GPIO(2):
+				mask |= 1 << 2;
+				break;
+			case S6_INTC_GPIO(3):
+				mask |= 0x1f << 3;
+				break;
+			default:
+				alone = 0;
+			}
+		if (mask) {
+			int cirq, i;
+			if (!alone) {
+				printk(KERN_ERR "chained irq chips can't share"
+					" parent irq %i\n", irq);
+				continue;
+			}
+			demux_masks[n] = mask;
+			cirq = IRQ_BASE - 1;
+			do {
+				i = ffs(mask);
+				cirq += i;
+				mask >>= i;
+				set_irq_chip(cirq, &gpioirqs);
+				set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
+			} while (mask);
+			set_irq_data(irq, demux_masks + n);
+			set_irq_chained_handler(irq, demux_irqs);
+			if (++n == ARRAY_SIZE(demux_masks))
+				break;
+		}
+	}
+}
diff -puN /dev/null arch/xtensa/variants/s6000/include/variant/gpio.h
--- /dev/null
+++ a/arch/xtensa/variants/s6000/include/variant/gpio.h
@@ -0,0 +1,6 @@
+#ifndef __XTENSA_VARIANT_S6000_GPIO_H
+#define __XTENSA_VARIANT_S6000_GPIO_H
+
+int s6_setup_gpio(u32 afsel) __init;
+
+#endif
diff -puN arch/xtensa/variants/s6000/include/variant/irq.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection arch/xtensa/variants/s6000/include/variant/irq.h
--- a/arch/xtensa/variants/s6000/include/variant/irq.h~xtensa-support-s6000-gpio-irqs-and-alternate-function-selection
+++ a/arch/xtensa/variants/s6000/include/variant/irq.h
@@ -2,6 +2,7 @@
 #define __XTENSA_S6000_IRQ_H
 
 #define NO_IRQ		(-1)
+#define VARIANT_NR_IRQS 8 /* GPIO interrupts */
 
 extern void variant_irq_enable(unsigned int irq);
 extern void variant_irq_disable(unsigned int irq);
_

Patches currently in -mm which might be from dg@emlix.com are

linux-next.patch
xtensa-make-startup-code-discardable.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch

