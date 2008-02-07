From: akpm@linux-foundation.org
Subject: - asic3-driver-update.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:30:07 -0800
Message-ID: <200802070329.m173TmqS013894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbYBGDaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:30:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sameo@openedhand.com, ben@trinity.fluff.org, pmiscml@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ASIC3 driver update
has been removed from the -mm tree.  Its filename was
     asic3-driver-update.patch

This patch was dropped because it was folded into asic3-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ASIC3 driver update
From: Samuel Ortiz <sameo@openedhand.com>

On Thu, Oct 18, 2007 at 03:05:44PM -0700, Andrew Morton wrote:
> On Thu, 18 Oct 2007 11:12:41 +0200
> Samuel Ortiz <sameo@openedhand.com> wrote:
> You're not a big fan of checkpatch, I see.
Well, now I am :-)
I fixed all the errors, there are only a couple lines being more than 80
characters left.

> > +#include <linux/module.h>
> > +#include <linux/version.h>
> > +#include <linux/irq.h>
>
> Please see the large comment at the top of linux/irq.h.  I believe this
> driver will fial to compile on at least arm.
It doesn't build as a module, since we need the irq.h symbols.
I changed MFD_ASIC3 to bool. I somehow feel that this is not the cleanest
solution, but OTOH I think that dynamically adding IRQs and GPIOs to an
embedded board doesn't make much sense.

> We really should fix this.
As I explained to Thomas, asic3 defines an additional range of IRQs for the
board, so we really need to access the irq API.
There may be another way, but I'm not aware of it.

> > +static inline void asic3_write_register(struct asic3 *asic,
> > +				 unsigned int reg, u32 value)
> > +{
> > +	iowrite16(value, (unsigned long)asic->mapping +
> > +		  (reg >> (2 - asic->bus_shift)));
> > +}
> > +
> > +static inline u32 asic3_read_register(struct asic3 *asic,
> > +			       unsigned int reg)
> > +{
> > +	return ioread16((unsigned long)asic->mapping +
> > +			(reg >> (2 - asic->bus_shift)));
> > +}
>
> You'd get faster code if that "2 - asic->bus_shift" was cached in struct
> asic3 rather than recalculated each time.
Done.

> > +static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
> > +{
> > +	int iter, i;
> > +	struct asic3 *asic;
> > +
> > +	desc->chip->ack(irq);
>
> hm, so this delves into the innards of the IRQ management.  Does it work OK
> with and without CONFIG_GENERIC_HARDIRQS?  If not, some Kconfig work will
> be needed.
It needs CONFIG_GENERIC_HARDIRQS, I fixed Kconfig.

> > +				for (i = 0; i < ASIC3_GPIOS_PER_BANK; i++) {
> > +					int bit = (1 << i);
> > +					unsigned int irqnr;
> > +					if (!(istat & bit))
> > +						continue;
>
> Most people prefer a blank line between end-of-definitions and start-of-code.
Done.

> > +static void asic3_unmask_gpio_irq(unsigned int irq)
> > +{
> > +	struct asic3 *asic = get_irq_chip_data(irq);
> > +	u32 val, bank, index;
> > +
> > +	bank = asic3_irq_to_bank(asic, irq);
> > +	index = asic3_irq_to_index(asic, irq);
> > +
> > +	spin_lock(&asic->lock);
> > +	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
> > +	val &= ~(1 << index);
> > +	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
> > +	spin_unlock(&asic->lock);
> > +}
>
> Am wondering about the handling of asic->lock.  As it is taken from hard
> interrupts, it is a bug to take it with local interrupts enabled.  afacit
> that is what this code is doing and is hence deadlockable.  But I didn't
> look very hard.
No, I think you're right, the lock should be taken with local interrupts
disabled. I fixed that too.

> Has this code been exercised with lockdep enabled?
Yes, I'm running it with lockdep enabled.

> > +int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
> > +{
> > +	u32 mask = ASIC3_GPIO_bit(gpio);
> > +
> > +	switch (gpio >> 4) {
> > +	case ASIC3_GPIO_BANK_A:
> > +		return asic3_get_gpio_a(asic, Status) & mask;
> > +	case ASIC3_GPIO_BANK_B:
> > +		return asic3_get_gpio_b(asic, Status) & mask;
> > +	case ASIC3_GPIO_BANK_C:
> > +		return asic3_get_gpio_c(asic, Status) & mask;
> > +	case ASIC3_GPIO_BANK_D:
> > +		return asic3_get_gpio_d(asic, Status) & mask;
> > +	default:
> > +		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
> > +		       __FUNCTION__, gpio);
> > +		return -EINVAL;
> > +	}
> > +}
> > +EXPORT_SYMBOL(asic3_gpio_get_value);
> > ...
> > +EXPORT_SYMBOL(asic3_gpio_set_value);
>
> To what are these exported?
Currently nothing, but the plan is to push several drivers (leds, MMC,
buttons...) based on the ASIC3, and they need to access the ASIC3 GPIOs.
Do you want me to remove the EXPORT_SYMBOL until we actually add those
drivers ?

Thanks a lot for the review, here goes a new version of this patch:

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Cc: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Ben Dooks <ben@trinity.fluff.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig       |    5 
 drivers/mfd/asic3.c       |  146 +++++++++-------
 include/linux/mfd/asic3.h |  314 +++++++++++++++++++-----------------
 3 files changed, 258 insertions(+), 207 deletions(-)

diff -puN drivers/mfd/Kconfig~asic3-driver-update drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~asic3-driver-update
+++ a/drivers/mfd/Kconfig
@@ -16,10 +16,11 @@ config MFD_SM501
 	  varying functions enabled.
 
 config MFD_ASIC3
-	tristate "Support for Compaq ASIC3"
+	bool "Support for Compaq ASIC3"
+	depends on GENERIC_HARDIRQS
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
-	  PDAs (mainly iPAQ and HTC based ones)
+	  PDAs (mainly iPAQ and HTC based ones).
 
 endmenu
 
diff -puN drivers/mfd/asic3.c~asic3-driver-update drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-driver-update
+++ a/drivers/mfd/asic3.c
@@ -10,10 +10,14 @@
  * Copyright 2001 Compaq Computer Corporation.
  * Copyright 2004-2005 Phil Blundell
  * Copyright 2007 OpenedHand Ltd.
+ *
+ * Authors: Phil Blundell <pb@handhelds.org>,
+ *	    Samuel Ortiz <sameo@openedhand.com>
+ *
  */
 
-#include <linux/module.h>
 #include <linux/version.h>
+#include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
@@ -25,14 +29,14 @@ static inline void asic3_write_register(
 				 unsigned int reg, u32 value)
 {
 	iowrite16(value, (unsigned long)asic->mapping +
-		  (reg >> (2 - asic->bus_shift)));
+		  (reg >> asic->bus_shift));
 }
 
 static inline u32 asic3_read_register(struct asic3 *asic,
 			       unsigned int reg)
 {
 	return ioread16((unsigned long)asic->mapping +
-			(reg >> (2 - asic->bus_shift)));
+			(reg >> asic->bus_shift));
 }
 
 /* IRQs */
@@ -40,23 +44,25 @@ static inline u32 asic3_read_register(st
 #define ASIC3_GPIO_Base_INCR \
 	(ASIC3_GPIO_B_Base - ASIC3_GPIO_A_Base)
 
-static inline void asic3_irq_flip_edge(struct asic3 *asic,
-				       u32 base, int bit)
+static void asic3_irq_flip_edge(struct asic3 *asic,
+				u32 base, int bit)
 {
 	u16 edge;
+	unsigned long flags;
 
-	spin_lock(&asic->lock);
+	spin_lock_irqsave(&asic->lock, flags);
 	edge = asic3_read_register(asic,
 				   base + ASIC3_GPIO_EdgeTrigger);
 	edge ^= bit;
 	asic3_write_register(asic,
 			     base + ASIC3_GPIO_EdgeTrigger, edge);
-	spin_unlock(&asic->lock);
+	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
 static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 {
 	int iter, i;
+	unsigned long flags;
 	struct asic3 *asic;
 
 	desc->chip->ack(irq);
@@ -67,10 +73,10 @@ static void asic3_irq_demux(unsigned int
 		u32 status;
 		int bank;
 
-		spin_lock(&asic->lock);
+		spin_lock_irqsave(&asic->lock, flags);
 		status = asic3_read_register(asic,
 					     ASIC3_OFFSET(INTR, PIntStat));
-		spin_unlock(&asic->lock);
+		spin_unlock_irqrestore(&asic->lock, flags);
 
 		/* Check all ten register bits */
 		if ((status & 0x3ff) == 0)
@@ -84,7 +90,7 @@ static void asic3_irq_demux(unsigned int
 				base = ASIC3_GPIO_A_Base
 				       + bank * ASIC3_GPIO_Base_INCR;
 
-				spin_lock(&asic->lock);
+				spin_lock_irqsave(&asic->lock, flags);
 				istat = asic3_read_register(asic,
 							    base +
 							    ASIC3_GPIO_IntStatus);
@@ -92,22 +98,23 @@ static void asic3_irq_demux(unsigned int
 				asic3_write_register(asic,
 						     base +
 						     ASIC3_GPIO_IntStatus, 0);
-				spin_unlock(&asic->lock);
+				spin_unlock_irqrestore(&asic->lock, flags);
 
 				for (i = 0; i < ASIC3_GPIOS_PER_BANK; i++) {
 					int bit = (1 << i);
 					unsigned int irqnr;
+
 					if (!(istat & bit))
 						continue;
 
 					irqnr = asic->irq_base +
-						(ASIC3_GPIOS_PER_BANK * bank) + i;
+						(ASIC3_GPIOS_PER_BANK * bank)
+						+ i;
 					desc = irq_desc + irqnr;
 					desc->handle_irq(irqnr, desc);
-					if (asic->irq_bothedge[bank] & bit) {
+					if (asic->irq_bothedge[bank] & bit)
 						asic3_irq_flip_edge(asic, base,
 								    bit);
-					}
 				}
 			}
 		}
@@ -128,7 +135,7 @@ static void asic3_irq_demux(unsigned int
 		       __FUNCTION__);
 }
 
-static inline int asic3_irq_to_bank(struct asic3 * asic, int irq)
+static inline int asic3_irq_to_bank(struct asic3 *asic, int irq)
 {
 	int n;
 
@@ -137,7 +144,7 @@ static inline int asic3_irq_to_bank(stru
 	return (n * (ASIC3_GPIO_B_Base - ASIC3_GPIO_A_Base));
 }
 
-static inline int asic3_irq_to_index(struct asic3 * asic, int irq)
+static inline int asic3_irq_to_index(struct asic3 *asic, int irq)
 {
 	return (irq - asic->irq_base) & 0xf;
 }
@@ -146,23 +153,25 @@ static void asic3_mask_gpio_irq(unsigned
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	u32 val, bank, index;
+	unsigned long flags;
 
 	bank = asic3_irq_to_bank(asic, irq);
 	index = asic3_irq_to_index(asic, irq);
 
-	spin_lock(&asic->lock);
+	spin_lock_irqsave(&asic->lock, flags);
 	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
 	val |= 1 << index;
 	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
-	spin_unlock(&asic->lock);
+	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
 static void asic3_mask_irq(unsigned int irq)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	int regval;
+	unsigned long flags;
 
-	spin_lock(&asic->lock);
+	spin_lock_irqsave(&asic->lock, flags);
 	regval = asic3_read_register(asic,
 				     ASIC3_INTR_Base +
 				     ASIC3_INTR_IntMask);
@@ -174,30 +183,32 @@ static void asic3_mask_irq(unsigned int 
 			     ASIC3_INTR_Base +
 			     ASIC3_INTR_IntMask,
 			     regval);
-	spin_unlock(&asic->lock);
+	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
 static void asic3_unmask_gpio_irq(unsigned int irq)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	u32 val, bank, index;
+	unsigned long flags;
 
 	bank = asic3_irq_to_bank(asic, irq);
 	index = asic3_irq_to_index(asic, irq);
 
-	spin_lock(&asic->lock);
+	spin_lock_irqsave(&asic->lock, flags);
 	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
 	val &= ~(1 << index);
 	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
-	spin_unlock(&asic->lock);
+	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
 static void asic3_unmask_irq(unsigned int irq)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	int regval;
+	unsigned long flags;
 
-	spin_lock(&asic->lock);
+	spin_lock_irqsave(&asic->lock, flags);
 	regval = asic3_read_register(asic,
 				     ASIC3_INTR_Base +
 				     ASIC3_INTR_IntMask);
@@ -209,7 +220,7 @@ static void asic3_unmask_irq(unsigned in
 			     ASIC3_INTR_Base +
 			     ASIC3_INTR_IntMask,
 			     regval);
-	spin_unlock(&asic->lock);
+	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
 static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
@@ -217,12 +228,13 @@ static int asic3_gpio_irq_type(unsigned 
 	struct asic3 *asic = get_irq_chip_data(irq);
 	u32 bank, index;
 	u16 trigger, level, edge, bit;
+	unsigned long flags;
 
 	bank = asic3_irq_to_bank(asic, irq);
 	index = asic3_irq_to_index(asic, irq);
 	bit = 1<<index;
 
-	spin_lock(&asic->lock);
+	spin_lock_irqsave(&asic->lock, flags);
 	level = asic3_read_register(asic,
 				    bank + ASIC3_GPIO_LevelTrigger);
 	edge = asic3_read_register(asic,
@@ -264,7 +276,7 @@ static int asic3_gpio_irq_type(unsigned 
 			     edge);
 	asic3_write_register(asic, bank + ASIC3_GPIO_TriggerType,
 			     trigger);
-	spin_unlock(&asic->lock);
+	spin_unlock_irqrestore(&asic->lock, flags);
 	return 0;
 }
 
@@ -285,9 +297,9 @@ static struct irq_chip asic3_irq_chip = 
 
 static int asic3_irq_probe(struct platform_device *pdev)
 {
-	struct asic3 * asic = platform_get_drvdata(pdev);
+	struct asic3 *asic = platform_get_drvdata(pdev);
 	unsigned long clksel = 0;
-	unsigned int irq;
+	unsigned int irq, irq_base;
 
 	asic->irq_nr = platform_get_irq(pdev, 0);
 	if (asic->irq_nr < 0)
@@ -298,7 +310,9 @@ static int asic3_irq_probe(struct platfo
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL),
 			     clksel);
 
-	for (irq = asic->irq_base; irq < asic->irq_base + ASIC3_NR_IRQS; irq++) {
+	irq_base = asic->irq_base;
+
+	for (irq = irq_base; irq < irq_base + ASIC3_NR_IRQS; irq++) {
 		if (irq < asic->irq_base + ASIC3_NUM_GPIOS)
 			set_irq_chip(irq, &asic3_gpio_irq_chip);
 		else
@@ -321,13 +335,15 @@ static int asic3_irq_probe(struct platfo
 
 static void asic3_irq_remove(struct platform_device *pdev)
 {
-	struct asic3 * asic = platform_get_drvdata(pdev);
-	unsigned int irq;
+	struct asic3 *asic = platform_get_drvdata(pdev);
+	unsigned int irq, irq_base;
+
+	irq_base = asic->irq_base;
 
-	for (irq = asic->irq_base; irq < asic->irq_base + ASIC3_NR_IRQS; irq++) {
+	for (irq = irq_base; irq < irq_base + ASIC3_NR_IRQS; irq++) {
 		set_irq_flags(irq, 0);
-		set_irq_handler (irq, NULL);
-		set_irq_chip (irq, NULL);
+		set_irq_handler(irq, NULL);
+		set_irq_chip(irq, NULL);
 		set_irq_chip_data(irq, NULL);
 	}
 	set_irq_chained_handler(asic->irq_nr, NULL);
@@ -340,8 +356,8 @@ static inline u32 asic3_get_gpio(struct 
 	return asic3_read_register(asic, base + function);
 }
 
-static inline void asic3_set_gpio(struct asic3 *asic, unsigned int base,
-				  unsigned int function, u32 bits, u32 val)
+static void asic3_set_gpio(struct asic3 *asic, unsigned int base,
+			   unsigned int function, u32 bits, u32 val)
 {
 	unsigned long flags;
 
@@ -352,21 +368,31 @@ static inline void asic3_set_gpio(struct
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-#define asic3_get_gpio_a(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##function)
-#define asic3_get_gpio_b(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##function)
-#define asic3_get_gpio_c(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##function)
-#define asic3_get_gpio_d(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##function)
-
-#define asic3_set_gpio_a(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##function, bits, val)
-#define asic3_set_gpio_b(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##function, bits, val)
-#define asic3_set_gpio_c(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##function, bits, val)
-#define asic3_set_gpio_d(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##function, bits, val)
-
-#define asic3_set_gpio_banks(asic, function, bits, pdata, field) \
-	asic3_set_gpio_a((asic), function, (bits), (pdata)->gpio_a.field); \
-	asic3_set_gpio_b((asic), function, (bits), (pdata)->gpio_b.field); \
-	asic3_set_gpio_c((asic), function, (bits), (pdata)->gpio_c.field); \
-	asic3_set_gpio_d((asic), function, (bits), (pdata)->gpio_d.field);
+#define asic3_get_gpio_a(asic, fn) \
+	asic3_get_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##fn)
+#define asic3_get_gpio_b(asic, fn) \
+	asic3_get_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##fn)
+#define asic3_get_gpio_c(asic, fn) \
+	asic3_get_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##fn)
+#define asic3_get_gpio_d(asic, fn) \
+	asic3_get_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##fn)
+
+#define asic3_set_gpio_a(asic, fn, bits, val) \
+	asic3_set_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##fn, bits, val)
+#define asic3_set_gpio_b(asic, fn, bits, val) \
+	asic3_set_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##fn, bits, val)
+#define asic3_set_gpio_c(asic, fn, bits, val) \
+	asic3_set_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##fn, bits, val)
+#define asic3_set_gpio_d(asic, fn, bits, val) \
+	asic3_set_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##fn, bits, val)
+
+#define asic3_set_gpio_banks(asic, fn, bits, pdata, field) 		  \
+	do {								  \
+	     asic3_set_gpio_a((asic), fn, (bits), (pdata)->gpio_a.field); \
+	     asic3_set_gpio_b((asic), fn, (bits), (pdata)->gpio_b.field); \
+	     asic3_set_gpio_c((asic), fn, (bits), (pdata)->gpio_c.field); \
+	     asic3_set_gpio_d((asic), fn, (bits), (pdata)->gpio_d.field); \
+	} while (0)
 
 int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
 {
@@ -420,7 +446,7 @@ EXPORT_SYMBOL(asic3_gpio_set_value);
 static int asic3_gpio_probe(struct platform_device *pdev)
 {
 	struct asic3_platform_data *pdata = pdev->dev.platform_data;
-	struct asic3 * asic = platform_get_drvdata(pdev);
+	struct asic3 *asic = platform_get_drvdata(pdev);
 
 	asic3_write_register(asic, ASIC3_GPIO_OFFSET(A, Mask), 0xffff);
 	asic3_write_register(asic, ASIC3_GPIO_OFFSET(B, Mask), 0xffff);
@@ -489,9 +515,9 @@ static int asic3_probe(struct platform_d
 	asic->irq_base = pdata->irq_base;
 
 	if (pdata && pdata->bus_shift)
-		asic->bus_shift = pdata->bus_shift;
+		asic->bus_shift = 2 - pdata->bus_shift;
 	else
-		asic->bus_shift = 2;
+		asic->bus_shift = 0;
 
 	clksel = 0;
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), clksel);
@@ -511,7 +537,7 @@ static int asic3_probe(struct platform_d
 		}
 	}
 
-	printk("ASIC3 Core driver\n");
+	printk(KERN_INFO "ASIC3 Core driver\n");
 
 	return 0;
 
@@ -559,14 +585,4 @@ static int __init asic3_init(void)
 	return retval;
 }
 
-static void __exit asic3_exit(void)
-{
-	platform_driver_unregister(&asic3_device_driver);
-}
-
 subsys_initcall(asic3_init);
-module_exit(asic3_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Phil Blundell <pb@handhelds.org, Samuel Ortiz <sameo@openedhand.com>>");
-MODULE_DESCRIPTION("Core driver for ASIC3");
diff -puN include/linux/mfd/asic3.h~asic3-driver-update include/linux/mfd/asic3.h
--- a/include/linux/mfd/asic3.h~asic3-driver-update
+++ a/include/linux/mfd/asic3.h
@@ -14,7 +14,7 @@
 #ifndef __ASIC3_H__
 #define __ASIC3_H__
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 struct asic3 {
 	void __iomem *mapping;
@@ -41,7 +41,7 @@ struct asic3_platform_data {
 
 	unsigned int irq_base;
 
-	struct platform_device ** children;
+	struct platform_device **children;
 	unsigned int n_children;
 };
 
@@ -58,32 +58,38 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_GPIO_BANK_C	2
 #define ASIC3_GPIO_BANK_D	3
 
-#define ASIC3_GPIO(bank, gpio) ((ASIC3_GPIOS_PER_BANK * ASIC3_GPIO_BANK_##bank) + (gpio))
+#define ASIC3_GPIO(bank, gpio) \
+	((ASIC3_GPIOS_PER_BANK * ASIC3_GPIO_BANK_##bank) + (gpio))
 #define ASIC3_GPIO_bit(gpio) (1 << (gpio & 0xf))
 /* All offsets below are specified with this address bus shift */
 #define ASIC3_DEFAULT_ADDR_SHIFT 2
 
-#define ASIC3_OFFSET(base,reg) (ASIC3_##base##_Base + ASIC3_##base##_##reg)
-#define ASIC3_GPIO_OFFSET(base,reg) (ASIC3_GPIO_##base##_Base + ASIC3_GPIO_##reg)
+#define ASIC3_OFFSET(base, reg) (ASIC3_##base##_Base + ASIC3_##base##_##reg)
+#define ASIC3_GPIO_OFFSET(base, reg) \
+	(ASIC3_GPIO_##base##_Base + ASIC3_GPIO_##reg)
 
 #define ASIC3_GPIO_A_Base      0x0000
 #define ASIC3_GPIO_B_Base      0x0100
 #define ASIC3_GPIO_C_Base      0x0200
 #define ASIC3_GPIO_D_Base      0x0300
 
-#define ASIC3_GPIO_Mask          0x00    /* R/W 0:don't mask, 1:mask interrupt */
-#define ASIC3_GPIO_Direction     0x04    /* R/W 0:input, 1:output              */
-#define ASIC3_GPIO_Out           0x08    /* R/W 0:output low, 1:output high    */
-#define ASIC3_GPIO_TriggerType   0x0c    /* R/W 0:level, 1:edge                */
-#define ASIC3_GPIO_EdgeTrigger   0x10    /* R/W 0:falling, 1:rising            */
-#define ASIC3_GPIO_LevelTrigger  0x14    /* R/W 0:low, 1:high level detect     */
-#define ASIC3_GPIO_SleepMask     0x18    /* R/W 0:don't mask, 1:mask trigger in sleep mode  */
-#define ASIC3_GPIO_SleepOut      0x1c    /* R/W level 0:low, 1:high in sleep mode           */
-#define ASIC3_GPIO_BattFaultOut  0x20    /* R/W level 0:low, 1:high in batt_fault           */
-#define ASIC3_GPIO_IntStatus     0x24    /* R/W 0:none, 1:detect               */
-#define ASIC3_GPIO_AltFunction   0x28	/* R/W 0:normal control 1:LED register control */
-#define ASIC3_GPIO_SleepConf     0x2c    /* R/W bit 1: autosleep 0: disable gposlpout in normal mode, enable gposlpout in sleep mode */
-#define ASIC3_GPIO_Status        0x30    /* R   Pin status                                  */
+#define ASIC3_GPIO_Mask          0x00    /* R/W 0:don't mask */
+#define ASIC3_GPIO_Direction     0x04    /* R/W 0:input */
+#define ASIC3_GPIO_Out           0x08    /* R/W 0:output low */
+#define ASIC3_GPIO_TriggerType   0x0c    /* R/W 0:level */
+#define ASIC3_GPIO_EdgeTrigger   0x10    /* R/W 0:falling */
+#define ASIC3_GPIO_LevelTrigger  0x14    /* R/W 0:low level detect */
+#define ASIC3_GPIO_SleepMask     0x18    /* R/W 0:don't mask in sleep mode */
+#define ASIC3_GPIO_SleepOut      0x1c    /* R/W level 0:low in sleep mode */
+#define ASIC3_GPIO_BattFaultOut  0x20    /* R/W level 0:low in batt_fault */
+#define ASIC3_GPIO_IntStatus     0x24    /* R/W 0:none, 1:detect */
+#define ASIC3_GPIO_AltFunction   0x28	 /* R/W 1:LED register control */
+#define ASIC3_GPIO_SleepConf     0x2c    /*
+					  * R/W bit 1: autosleep
+					  * 0: disable gposlpout in normal mode,
+					  * enable gposlpout in sleep mode.
+					  */
+#define ASIC3_GPIO_Status        0x30    /* R   Pin status */
 
 #define ASIC3_SPI_Base		      0x0400
 #define ASIC3_SPI_Control               0x0000
@@ -112,15 +118,15 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_LED_AutoStopCount         0x000c    /* R/W 16 bits */
 
 /* LED TimeBase bits - match ASIC2 */
-#define LED_TBS		0x0f		/* Low 4 bits sets time base, max = 13		*/
-					/* Note: max = 5 on hx4700			*/
-					/* 0: maximum time base				*/
-					/* 1: maximum time base / 2			*/
-					/* n: maximum time base / 2^n			*/
-
-#define LED_EN		(1 << 4)	/* LED ON/OFF 0:off, 1:on			*/
-#define LED_AUTOSTOP	(1 << 5)	/* LED ON/OFF auto stop set 0:disable, 1:enable */
-#define LED_ALWAYS	(1 << 6)	/* LED Interrupt Mask 0:No mask, 1:mask		*/
+#define LED_TBS		0x0f /* Low 4 bits sets time base, max = 13 */
+			     /* Note: max = 5 on hx4700	*/
+			     /* 0: maximum time base */
+			     /* 1: maximum time base / 2 */
+			     /* n: maximum time base / 2^n */
+
+#define LED_EN		(1 << 4) /* LED ON/OFF 0:off, 1:on */
+#define LED_AUTOSTOP	(1 << 5) /* LED ON/OFF auto stop 0:disable, 1:enable */
+#define LED_ALWAYS	(1 << 6) /* LED Interrupt Mask 0:No mask, 1:mask */
 
 #define ASIC3_CLOCK_Base		0x0A00
 #define ASIC3_CLOCK_CDEX           0x00
@@ -137,17 +143,20 @@ void asic3_gpio_set_value(struct asic3 *
 #define CLOCK_CDEX_LED1         (1 << 7)
 #define CLOCK_CDEX_LED2         (1 << 8)
 
-#define CLOCK_CDEX_SD_HOST      (1 << 9)   /* R/W: SD host clock source 24.576M/12.288M */
-#define CLOCK_CDEX_SD_BUS       (1 << 10)  /* R/W: SD bus clock source control 24.576M/12.288M */
+/* Clocks settings: 1 for 24.576 MHz, 0 for 12.288Mhz */
+#define CLOCK_CDEX_SD_HOST      (1 << 9)   /* R/W: SD host clock source */
+#define CLOCK_CDEX_SD_BUS       (1 << 10)  /* R/W: SD bus clock source ctrl */
 #define CLOCK_CDEX_SMBUS        (1 << 11)
 #define CLOCK_CDEX_CONTROL_CX   (1 << 12)
 
 #define CLOCK_CDEX_EX0          (1 << 13)  /* R/W: 32.768 kHz crystal */
 #define CLOCK_CDEX_EX1          (1 << 14)  /* R/W: 24.576 MHz crystal */
 
-#define CLOCK_SEL_SD_HCLK_SEL   (1 << 0)   /* R/W: SDIO host clock select  -  1: 24.576 Mhz, 0: 12.288 MHz */
-#define CLOCK_SEL_SD_BCLK_SEL   (1 << 1)   /* R/W: SDIO bus clock select -  1: 24.576 MHz, 0: 12.288 MHz */
-#define CLOCK_SEL_CX            (1 << 2)   /* R/W: INT clock source control (32.768 kHz) */
+#define CLOCK_SEL_SD_HCLK_SEL   (1 << 0)   /* R/W: SDIO host clock select */
+#define CLOCK_SEL_SD_BCLK_SEL   (1 << 1)   /* R/W: SDIO bus clock select */
+
+/* R/W: INT clock source control (32.768 kHz) */
+#define CLOCK_SEL_CX            (1 << 2)
 
 
 #define ASIC3_INTR_Base		0x0B00
@@ -157,7 +166,7 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_INTR_IntCPS        0x08  /* Interrupt timer clock pre-scale */
 #define ASIC3_INTR_IntTBS        0x0c  /* Interrupt timer set */
 
-#define ASIC3_INTMASK_GINTMASK    (1 << 0)  /* Global interrupt mask 1:enable */
+#define ASIC3_INTMASK_GINTMASK    (1 << 0)  /* Global INTs mask 1:enable */
 #define ASIC3_INTMASK_GINTEL      (1 << 1)  /* 1: rising edge, 0: hi level */
 #define ASIC3_INTMASK_MASK0       (1 << 2)
 #define ASIC3_INTMASK_MASK1       (1 << 3)
@@ -178,7 +187,7 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_INTR_OWM            (1 << 9)
 
 #define ASIC3_INTR_CPS(x)         ((x)&0x0f)    /* 4 bits, max 14 */
-#define ASIC3_INTR_CPS_SET        ( 1 << 4 )    /* Time base enable */
+#define ASIC3_INTR_CPS_SET        (1 << 4)    /* Time base enable */
 
 
 /* Basic control of the SD ASIC */
@@ -188,10 +197,14 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_SDHWCTRL_SUSPEND    (1 << 0)  /* 1=suspend all SD operations */
 #define ASIC3_SDHWCTRL_CLKSEL     (1 << 1)  /* 1=SDICK, 0=HCLK */
 #define ASIC3_SDHWCTRL_PCLR       (1 << 2)  /* All registers of SDIO cleared */
-#define ASIC3_SDHWCTRL_LEVCD      (1 << 3)  /* Level of SD card detection: 1:high, 0:low */
-#define ASIC3_SDHWCTRL_LEVWP      (1 << 4)  /* Level of SD card write protection: 1=low, 0=high */
-#define ASIC3_SDHWCTRL_SDLED      (1 << 5)  /* SD card LED signal 1=enable, 0=disable */
-#define ASIC3_SDHWCTRL_SDPWR      (1 << 6)  /* SD card power supply control 1=enable */
+#define ASIC3_SDHWCTRL_LEVCD      (1 << 3)  /* SD card detection: 0:low */
+
+/* SD card write protection: 0=high */
+#define ASIC3_SDHWCTRL_LEVWP      (1 << 4)
+#define ASIC3_SDHWCTRL_SDLED      (1 << 5)  /* SD card LED signal 0=disable */
+
+/* SD card power supply ctrl 1=enable */
+#define ASIC3_SDHWCTRL_SDPWR      (1 << 6)
 
 #define ASIC3_EXTCF_Base		0x1100
 
@@ -203,17 +216,17 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_EXTCF_SMOD2	         (1 << 2)  /* slot number of mode 2 */
 #define ASIC3_EXTCF_OWM_EN	         (1 << 4)  /* enable onewire module */
 #define ASIC3_EXTCF_OWM_SMB	         (1 << 5)  /* OWM bus selection */
-#define ASIC3_EXTCF_OWM_RESET            (1 << 6)  /* undocumented, used by OWM and CF */
-#define ASIC3_EXTCF_CF0_SLEEP_MODE       (1 << 7)  /* CF0 sleep state control */
-#define ASIC3_EXTCF_CF1_SLEEP_MODE       (1 << 8)  /* CF1 sleep state control */
-#define ASIC3_EXTCF_CF0_PWAIT_EN         (1 << 10)  /* CF0 PWAIT_n control */
-#define ASIC3_EXTCF_CF1_PWAIT_EN         (1 << 11)  /* CF1 PWAIT_n control */
-#define ASIC3_EXTCF_CF0_BUF_EN           (1 << 12)  /* CF0 buffer control */
-#define ASIC3_EXTCF_CF1_BUF_EN           (1 << 13)  /* CF1 buffer control */
+#define ASIC3_EXTCF_OWM_RESET            (1 << 6)  /* ?? used by OWM and CF */
+#define ASIC3_EXTCF_CF0_SLEEP_MODE       (1 << 7)  /* CF0 sleep state */
+#define ASIC3_EXTCF_CF1_SLEEP_MODE       (1 << 8)  /* CF1 sleep state */
+#define ASIC3_EXTCF_CF0_PWAIT_EN         (1 << 10) /* CF0 PWAIT_n control */
+#define ASIC3_EXTCF_CF1_PWAIT_EN         (1 << 11) /* CF1 PWAIT_n control */
+#define ASIC3_EXTCF_CF0_BUF_EN           (1 << 12) /* CF0 buffer control */
+#define ASIC3_EXTCF_CF1_BUF_EN           (1 << 13) /* CF1 buffer control */
 #define ASIC3_EXTCF_SD_MEM_ENABLE        (1 << 14)
-#define ASIC3_EXTCF_CF_SLEEP             (1 << 15)  /* CF sleep mode control */
+#define ASIC3_EXTCF_CF_SLEEP             (1 << 15) /* CF sleep mode control */
 
-/*****************************************************************************
+/*********************************************
  *  The Onewire interface registers
  *
  *  OWM_CMD
@@ -222,7 +235,7 @@ void asic3_gpio_set_value(struct asic3 *
  *  OWM_INTEN
  *  OWM_CLKDIV
  *
- *****************************************************************************/
+ *********************************************/
 
 #define ASIC3_OWM_Base		0xC00
 
@@ -249,8 +262,8 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_OWM_INTEN_ETMT       (1 << 3)
 #define ASIC3_OWM_INTEN_ERBF       (1 << 4)
 
-#define ASIC3_OWM_CLKDIV_PRE       (3 << 0) /* two bits wide at bit position 0 */
-#define ASIC3_OWM_CLKDIV_DIV       (7 << 2) /* 3 bits wide at bit position 2 */
+#define ASIC3_OWM_CLKDIV_PRE       (3 << 0) /* two bits wide at bit 0 */
+#define ASIC3_OWM_CLKDIV_DIV       (7 << 2) /* 3 bits wide at bit 2 */
 
 
 /*****************************************************************************
@@ -262,35 +275,57 @@ void asic3_gpio_set_value(struct asic3 *
  *  SDIO_CTRL         Control registers for SDIO operations
  *
  *****************************************************************************/
-#define ASIC3_SD_CONFIG_Base            0x0400    // Assumes 32 bit addressing
+#define ASIC3_SD_CONFIG_Base            0x0400 /* Assumes 32 bit addressing */
 
 #define ASIC3_SD_CONFIG_Command           0x08   /* R/W: Command */
-#define ASIC3_SD_CONFIG_Addr0             0x20   /* [9:31] SD Control Register Base Address */
-#define ASIC3_SD_CONFIG_Addr1             0x24   /* [9:31] SD Control Register Base Address */
-#define ASIC3_SD_CONFIG_IntPin            0x78   /* R/O: interrupt assigned to pin */
-#define ASIC3_SD_CONFIG_ClkStop           0x80   /* Set to 0x1f to clock SD controller, 0 otherwise. */
-							/* at 0x82 - Gated Clock Control */
-#define ASIC3_SD_CONFIG_ClockMode         0x84   /* Control clock of SD controller */
-#define ASIC3_SD_CONFIG_SDHC_PinStatus    0x88   /* R/0: read status of SD pins */
-#define ASIC3_SD_CONFIG_SDHC_Power1       0x90   /* Power1 - manual power control */
-							/* Power2 is at 0x92 - auto power up after card inserted */
-#define ASIC3_SD_CONFIG_SDHC_Power3       0x94   /* auto power down when card removed */
-#define ASIC3_SD_CONFIG_SDHC_CardDetect   0x98   /* */
-#define ASIC3_SD_CONFIG_SDHC_Slot         0xA0   /* R/O: define support slot number */
-#define ASIC3_SD_CONFIG_SDHC_ExtGateClk1  0x1E0  /* Could be used for gated clock (don't use) */
-#define ASIC3_SD_CONFIG_SDHC_ExtGateClk2  0x1E2  /* Could be used for gated clock (don't use) */
-#define ASIC3_SD_CONFIG_SDHC_GPIO_OutAndEnable  0x1E8  /* GPIO Output Reg. , at 0x1EA - GPIO Output Enable Reg. */
+
+/* [0:8] SD Control Register Base Address */
+#define ASIC3_SD_CONFIG_Addr0             0x20
+
+/* [9:31] SD Control Register Base Address */
+#define ASIC3_SD_CONFIG_Addr1             0x24
+
+/* R/O: interrupt assigned to pin */
+#define ASIC3_SD_CONFIG_IntPin            0x78
+
+/*
+ * Set to 0x1f to clock SD controller, 0 otherwise.
+ * At 0x82 - Gated Clock Ctrl
+ */
+#define ASIC3_SD_CONFIG_ClkStop           0x80
+
+/* Control clock of SD controller */
+#define ASIC3_SD_CONFIG_ClockMode         0x84
+#define ASIC3_SD_CONFIG_SDHC_PinStatus    0x88   /* R/0: SD pins status */
+#define ASIC3_SD_CONFIG_SDHC_Power1       0x90   /* Power1 - manual pwr ctrl */
+
+/* auto power up after card inserted */
+#define ASIC3_SD_CONFIG_SDHC_Power2       0x92
+
+/* auto power down when card removed */
+#define ASIC3_SD_CONFIG_SDHC_Power3       0x94
+#define ASIC3_SD_CONFIG_SDHC_CardDetect   0x98
+#define ASIC3_SD_CONFIG_SDHC_Slot         0xA0   /* R/O: support slot number */
+#define ASIC3_SD_CONFIG_SDHC_ExtGateClk1  0x1E0  /* Not used */
+#define ASIC3_SD_CONFIG_SDHC_ExtGateClk2  0x1E2  /* Not used*/
+
+/* GPIO Output Reg. , at 0x1EA - GPIO Output Enable Reg. */
+#define ASIC3_SD_CONFIG_SDHC_GPIO_OutAndEnable  0x1E8
 #define ASIC3_SD_CONFIG_SDHC_GPIO_Status  0x1EC  /* GPIO Status Reg. */
-#define ASIC3_SD_CONFIG_SDHC_ExtGateClk3  0x1F0  /* Bit 1: double buffer/single buffer */
 
-#define SD_CONFIG_COMMAND_MAE                (1<<1)    /* Memory access enable (set to 1 to access SD Controller) */
+/* Bit 1: double buffer/single buffer */
+#define ASIC3_SD_CONFIG_SDHC_ExtGateClk3  0x1F0
+
+/* Memory access enable (set to 1 to access SD Controller) */
+#define SD_CONFIG_COMMAND_MAE                (1<<1)
 
 #define SD_CONFIG_CLK_ENABLE_ALL             0x1f
 
 #define SD_CONFIG_POWER1_PC_33V              0x0200    /* Set for 3.3 volts */
 #define SD_CONFIG_POWER1_PC_OFF              0x0000    /* Turn off power */
 
-#define SD_CONFIG_CARDDETECTMODE_CLK           ((x)&0x3) /* two bits - number of cycles for card detection */
+ /* two bits - number of cycles for card detection */
+#define SD_CONFIG_CARDDETECTMODE_CLK           ((x) & 0x3)
 
 
 #define ASIC3_SD_CTRL_Base            0x1000
@@ -323,27 +358,27 @@ void asic3_gpio_set_value(struct asic3 *
 
 #define SD_CTRL_SOFTWARE_RESET_CLEAR            (1<<0)
 
-#define SD_CTRL_TRANSACTIONCONTROL_SET          (1<<8) // 0x0100
+#define SD_CTRL_TRANSACTIONCONTROL_SET          (1<<8)
 
-#define SD_CTRL_CARDCLOCKCONTROL_FOR_SD_CARD    (1<<15)// 0x8000
-#define SD_CTRL_CARDCLOCKCONTROL_ENABLE_CLOCK   (1<<8) // 0x0100
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_512    (1<<7) // 0x0080
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_256    (1<<6) // 0x0040
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_128    (1<<5) // 0x0020
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_64     (1<<4) // 0x0010
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_32     (1<<3) // 0x0008
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_16     (1<<2) // 0x0004
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_8      (1<<1) // 0x0002
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_4      (1<<0) // 0x0001
-#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_2      (0<<0) // 0x0000
+#define SD_CTRL_CARDCLOCKCONTROL_FOR_SD_CARD    (1<<15)
+#define SD_CTRL_CARDCLOCKCONTROL_ENABLE_CLOCK   (1<<8)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_512    (1<<7)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_256    (1<<6)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_128    (1<<5)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_64     (1<<4)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_32     (1<<3)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_16     (1<<2)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_8      (1<<1)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_4      (1<<0)
+#define SD_CTRL_CARDCLOCKCONTROL_CLK_DIV_2      (0<<0)
 
 #define MEM_CARD_OPTION_REQUIRED                   0x000e
-#define MEM_CARD_OPTION_DATA_RESPONSE_TIMEOUT(x)   (((x) & 0x0f) << 4)      /* Four bits */
-#define MEM_CARD_OPTION_C2_MODULE_NOT_PRESENT      (1<<14) // 0x4000
-#define MEM_CARD_OPTION_DATA_XFR_WIDTH_1           (1<<15) // 0x8000
-#define MEM_CARD_OPTION_DATA_XFR_WIDTH_4           (0<<15) //~0x8000
+#define MEM_CARD_OPTION_DATA_RESPONSE_TIMEOUT(x)   (((x) & 0x0f) << 4)
+#define MEM_CARD_OPTION_C2_MODULE_NOT_PRESENT      (1<<14)
+#define MEM_CARD_OPTION_DATA_XFR_WIDTH_1           (1<<15)
+#define MEM_CARD_OPTION_DATA_XFR_WIDTH_4           0
 
-#define SD_CTRL_COMMAND_INDEX(x)                   ((x)&0x3f)           /* 0=CMD0, 1=CMD1, ..., 63=CMD63 */
+#define SD_CTRL_COMMAND_INDEX(x)                   ((x) & 0x3f)
 #define SD_CTRL_COMMAND_TYPE_CMD                   (0 << 6)
 #define SD_CTRL_COMMAND_TYPE_ACMD                  (1 << 6)
 #define SD_CTRL_COMMAND_TYPE_AUTHENTICATION        (2 << 6)
@@ -371,59 +406,59 @@ void asic3_gpio_set_value(struct asic3 *
 #define SD_CTRL_CARDSTATUS_CARD_INSERTED_3         (1 << 9)
 #define SD_CTRL_CARDSTATUS_SIGNAL_STATE_PRESENT_3  (1 << 10)
 
-#define SD_CTRL_BUFFERSTATUS_CMD_INDEX_ERROR       (1 << 0) // 0x0001
-#define SD_CTRL_BUFFERSTATUS_CRC_ERROR             (1 << 1) // 0x0002
-#define SD_CTRL_BUFFERSTATUS_STOP_BIT_END_ERROR    (1 << 2) // 0x0004
-#define SD_CTRL_BUFFERSTATUS_DATA_TIMEOUT          (1 << 3) // 0x0008
-#define SD_CTRL_BUFFERSTATUS_BUFFER_OVERFLOW       (1 << 4) // 0x0010
-#define SD_CTRL_BUFFERSTATUS_BUFFER_UNDERFLOW      (1 << 5) // 0x0020
-#define SD_CTRL_BUFFERSTATUS_CMD_TIMEOUT           (1 << 6) // 0x0040
-#define SD_CTRL_BUFFERSTATUS_UNK7                  (1 << 7) // 0x0080
-#define SD_CTRL_BUFFERSTATUS_BUFFER_READ_ENABLE    (1 << 8) // 0x0100
-#define SD_CTRL_BUFFERSTATUS_BUFFER_WRITE_ENABLE   (1 << 9) // 0x0200
-#define SD_CTRL_BUFFERSTATUS_ILLEGAL_FUNCTION      (1 << 13)// 0x2000
-#define SD_CTRL_BUFFERSTATUS_CMD_BUSY              (1 << 14)// 0x4000
-#define SD_CTRL_BUFFERSTATUS_ILLEGAL_ACCESS        (1 << 15)// 0x8000
-
-#define SD_CTRL_INTMASKCARD_RESPONSE_END           (1 << 0) // 0x0001
-#define SD_CTRL_INTMASKCARD_RW_END                 (1 << 2) // 0x0004
-#define SD_CTRL_INTMASKCARD_CARD_REMOVED_0         (1 << 3) // 0x0008
-#define SD_CTRL_INTMASKCARD_CARD_INSERTED_0        (1 << 4) // 0x0010
-#define SD_CTRL_INTMASKCARD_SIGNAL_STATE_PRESENT_0 (1 << 5) // 0x0020
-#define SD_CTRL_INTMASKCARD_UNK6                   (1 << 6) // 0x0040
-#define SD_CTRL_INTMASKCARD_WRITE_PROTECT          (1 << 7) // 0x0080
-#define SD_CTRL_INTMASKCARD_CARD_REMOVED_3         (1 << 8) // 0x0100
-#define SD_CTRL_INTMASKCARD_CARD_INSERTED_3        (1 << 9) // 0x0200
-#define SD_CTRL_INTMASKCARD_SIGNAL_STATE_PRESENT_3 (1 << 10)// 0x0400
-
-#define SD_CTRL_INTMASKBUFFER_CMD_INDEX_ERROR      (1 << 0) // 0x0001
-#define SD_CTRL_INTMASKBUFFER_CRC_ERROR            (1 << 1) // 0x0002
-#define SD_CTRL_INTMASKBUFFER_STOP_BIT_END_ERROR   (1 << 2) // 0x0004
-#define SD_CTRL_INTMASKBUFFER_DATA_TIMEOUT         (1 << 3) // 0x0008
-#define SD_CTRL_INTMASKBUFFER_BUFFER_OVERFLOW      (1 << 4) // 0x0010
-#define SD_CTRL_INTMASKBUFFER_BUFFER_UNDERFLOW     (1 << 5) // 0x0020
-#define SD_CTRL_INTMASKBUFFER_CMD_TIMEOUT          (1 << 6) // 0x0040
-#define SD_CTRL_INTMASKBUFFER_UNK7                 (1 << 7) // 0x0080
-#define SD_CTRL_INTMASKBUFFER_BUFFER_READ_ENABLE   (1 << 8) // 0x0100
-#define SD_CTRL_INTMASKBUFFER_BUFFER_WRITE_ENABLE  (1 << 9) // 0x0200
-#define SD_CTRL_INTMASKBUFFER_ILLEGAL_FUNCTION     (1 << 13)// 0x2000
-#define SD_CTRL_INTMASKBUFFER_CMD_BUSY             (1 << 14)// 0x4000
-#define SD_CTRL_INTMASKBUFFER_ILLEGAL_ACCESS       (1 << 15)// 0x8000
-
-#define SD_CTRL_DETAIL0_RESPONSE_CMD_ERROR                   (1 << 0) // 0x0001
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_RESPONSE_NON_CMD12 (1 << 2) // 0x0004
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_RESPONSE_CMD12     (1 << 3) // 0x0008
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_READ_DATA          (1 << 4) // 0x0010
-#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_WRITE_CRC_STATUS   (1 << 5) // 0x0020
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_RESPONSE_NON_CMD12     (1 << 8) // 0x0100
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_RESPONSE_CMD12         (1 << 9) // 0x0200
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_READ_DATA              (1 << 10)// 0x0400
-#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_WRITE_CMD              (1 << 11)// 0x0800
-
-#define SD_CTRL_DETAIL1_NO_CMD_RESPONSE                      (1 << 0) // 0x0001
-#define SD_CTRL_DETAIL1_TIMEOUT_READ_DATA                    (1 << 4) // 0x0010
-#define SD_CTRL_DETAIL1_TIMEOUT_CRS_STATUS                   (1 << 5) // 0x0020
-#define SD_CTRL_DETAIL1_TIMEOUT_CRC_BUSY                     (1 << 6) // 0x0040
+#define SD_CTRL_BUFFERSTATUS_CMD_INDEX_ERROR       (1 << 0)
+#define SD_CTRL_BUFFERSTATUS_CRC_ERROR             (1 << 1)
+#define SD_CTRL_BUFFERSTATUS_STOP_BIT_END_ERROR    (1 << 2)
+#define SD_CTRL_BUFFERSTATUS_DATA_TIMEOUT          (1 << 3)
+#define SD_CTRL_BUFFERSTATUS_BUFFER_OVERFLOW       (1 << 4)
+#define SD_CTRL_BUFFERSTATUS_BUFFER_UNDERFLOW      (1 << 5)
+#define SD_CTRL_BUFFERSTATUS_CMD_TIMEOUT           (1 << 6)
+#define SD_CTRL_BUFFERSTATUS_UNK7                  (1 << 7)
+#define SD_CTRL_BUFFERSTATUS_BUFFER_READ_ENABLE    (1 << 8)
+#define SD_CTRL_BUFFERSTATUS_BUFFER_WRITE_ENABLE   (1 << 9)
+#define SD_CTRL_BUFFERSTATUS_ILLEGAL_FUNCTION      (1 << 13)
+#define SD_CTRL_BUFFERSTATUS_CMD_BUSY              (1 << 14)
+#define SD_CTRL_BUFFERSTATUS_ILLEGAL_ACCESS        (1 << 15)
+
+#define SD_CTRL_INTMASKCARD_RESPONSE_END           (1 << 0)
+#define SD_CTRL_INTMASKCARD_RW_END                 (1 << 2)
+#define SD_CTRL_INTMASKCARD_CARD_REMOVED_0         (1 << 3)
+#define SD_CTRL_INTMASKCARD_CARD_INSERTED_0        (1 << 4)
+#define SD_CTRL_INTMASKCARD_SIGNAL_STATE_PRESENT_0 (1 << 5)
+#define SD_CTRL_INTMASKCARD_UNK6                   (1 << 6)
+#define SD_CTRL_INTMASKCARD_WRITE_PROTECT          (1 << 7)
+#define SD_CTRL_INTMASKCARD_CARD_REMOVED_3         (1 << 8)
+#define SD_CTRL_INTMASKCARD_CARD_INSERTED_3        (1 << 9)
+#define SD_CTRL_INTMASKCARD_SIGNAL_STATE_PRESENT_3 (1 << 10)
+
+#define SD_CTRL_INTMASKBUFFER_CMD_INDEX_ERROR      (1 << 0)
+#define SD_CTRL_INTMASKBUFFER_CRC_ERROR            (1 << 1)
+#define SD_CTRL_INTMASKBUFFER_STOP_BIT_END_ERROR   (1 << 2)
+#define SD_CTRL_INTMASKBUFFER_DATA_TIMEOUT         (1 << 3)
+#define SD_CTRL_INTMASKBUFFER_BUFFER_OVERFLOW      (1 << 4)
+#define SD_CTRL_INTMASKBUFFER_BUFFER_UNDERFLOW     (1 << 5)
+#define SD_CTRL_INTMASKBUFFER_CMD_TIMEOUT          (1 << 6)
+#define SD_CTRL_INTMASKBUFFER_UNK7                 (1 << 7)
+#define SD_CTRL_INTMASKBUFFER_BUFFER_READ_ENABLE   (1 << 8)
+#define SD_CTRL_INTMASKBUFFER_BUFFER_WRITE_ENABLE  (1 << 9)
+#define SD_CTRL_INTMASKBUFFER_ILLEGAL_FUNCTION     (1 << 13)
+#define SD_CTRL_INTMASKBUFFER_CMD_BUSY             (1 << 14)
+#define SD_CTRL_INTMASKBUFFER_ILLEGAL_ACCESS       (1 << 15)
+
+#define SD_CTRL_DETAIL0_RESPONSE_CMD_ERROR                   (1 << 0)
+#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_RESPONSE_NON_CMD12 (1 << 2)
+#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_RESPONSE_CMD12     (1 << 3)
+#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_READ_DATA          (1 << 4)
+#define SD_CTRL_DETAIL0_END_BIT_ERROR_FOR_WRITE_CRC_STATUS   (1 << 5)
+#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_RESPONSE_NON_CMD12     (1 << 8)
+#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_RESPONSE_CMD12         (1 << 9)
+#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_READ_DATA              (1 << 10)
+#define SD_CTRL_DETAIL0_CRC_ERROR_FOR_WRITE_CMD              (1 << 11)
+
+#define SD_CTRL_DETAIL1_NO_CMD_RESPONSE                      (1 << 0)
+#define SD_CTRL_DETAIL1_TIMEOUT_READ_DATA                    (1 << 4)
+#define SD_CTRL_DETAIL1_TIMEOUT_CRS_STATUS                   (1 << 5)
+#define SD_CTRL_DETAIL1_TIMEOUT_CRC_BUSY                     (1 << 6)
 
 #define ASIC3_SDIO_CTRL_Base          0x1200
 
@@ -460,4 +495,3 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_MAP_SIZE	     		     0x2000
 
 #endif /* __ASIC3_H__ */
-
_

Patches currently in -mm which might be from sameo@openedhand.com are

asic3-driver.patch
asic3-driver-update.patch
asic3-driver-update-2.patch
