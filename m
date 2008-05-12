From: akpm@linux-foundation.org
Subject: + asic3-use-uppercase-only-for-macros-and-defines.patch added to -mm tree
Date: Mon, 12 May 2008 16:51:47 -0700
Message-ID: <200805122351.m4CNpl2A015368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283AbYELXvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sameo@openedhand.com


The patch titled
     asic3: Use uppercase only for macros and defines.
has been added to the -mm tree.  Its filename is
     asic3-use-uppercase-only-for-macros-and-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asic3: Use uppercase only for macros and defines.
From: Samuel Ortiz <sameo@openedhand.com>

Let's be consistent and use uppercase only, for both macro and defines.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c       |   88 ++++++++++++++++++------------------
 include/linux/mfd/asic3.h |   54 +++++++++++-----------
 2 files changed, 71 insertions(+), 71 deletions(-)

diff -puN drivers/mfd/asic3.c~asic3-use-uppercase-only-for-macros-and-defines drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~asic3-use-uppercase-only-for-macros-and-defines
+++ a/drivers/mfd/asic3.c
@@ -55,8 +55,8 @@ static inline u32 asic3_read_register(st
 
 /* IRQs */
 #define MAX_ASIC_ISR_LOOPS    20
-#define ASIC3_GPIO_Base_INCR \
-	(ASIC3_GPIO_B_Base - ASIC3_GPIO_A_Base)
+#define ASIC3_GPIO_BASE_INCR \
+	(ASIC3_GPIO_B_BASE - ASIC3_GPIO_A_BASE)
 
 static void asic3_irq_flip_edge(struct asic3 *asic,
 				u32 base, int bit)
@@ -66,10 +66,10 @@ static void asic3_irq_flip_edge(struct a
 
 	spin_lock_irqsave(&asic->lock, flags);
 	edge = asic3_read_register(asic,
-				   base + ASIC3_GPIO_EdgeTrigger);
+				   base + ASIC3_GPIO_EDGE_TRIGGER);
 	edge ^= bit;
 	asic3_write_register(asic,
-			     base + ASIC3_GPIO_EdgeTrigger, edge);
+			     base + ASIC3_GPIO_EDGE_TRIGGER, edge);
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
@@ -89,7 +89,7 @@ static void asic3_irq_demux(unsigned int
 
 		spin_lock_irqsave(&asic->lock, flags);
 		status = asic3_read_register(asic,
-					     ASIC3_OFFSET(INTR, PIntStat));
+					     ASIC3_OFFSET(INTR, P_INT_STAT));
 		spin_unlock_irqrestore(&asic->lock, flags);
 
 		/* Check all ten register bits */
@@ -101,17 +101,17 @@ static void asic3_irq_demux(unsigned int
 			if (status & (1 << bank)) {
 				unsigned long base, istat;
 
-				base = ASIC3_GPIO_A_Base
-				       + bank * ASIC3_GPIO_Base_INCR;
+				base = ASIC3_GPIO_A_BASE
+				       + bank * ASIC3_GPIO_BASE_INCR;
 
 				spin_lock_irqsave(&asic->lock, flags);
 				istat = asic3_read_register(asic,
 							    base +
-							    ASIC3_GPIO_IntStatus);
+							    ASIC3_GPIO_INT_STATUS);
 				/* Clearing IntStatus */
 				asic3_write_register(asic,
 						     base +
-						     ASIC3_GPIO_IntStatus, 0);
+						     ASIC3_GPIO_INT_STATUS, 0);
 				spin_unlock_irqrestore(&asic->lock, flags);
 
 				for (i = 0; i < ASIC3_GPIOS_PER_BANK; i++) {
@@ -154,7 +154,7 @@ static inline int asic3_irq_to_bank(stru
 
 	n = (irq - asic->irq_base) >> 4;
 
-	return (n * (ASIC3_GPIO_B_Base - ASIC3_GPIO_A_Base));
+	return (n * (ASIC3_GPIO_B_BASE - ASIC3_GPIO_A_BASE));
 }
 
 static inline int asic3_irq_to_index(struct asic3 *asic, int irq)
@@ -172,9 +172,9 @@ static void asic3_mask_gpio_irq(unsigned
 	index = asic3_irq_to_index(asic, irq);
 
 	spin_lock_irqsave(&asic->lock, flags);
-	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
+	val = asic3_read_register(asic, bank + ASIC3_GPIO_MASK);
 	val |= 1 << index;
-	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
+	asic3_write_register(asic, bank + ASIC3_GPIO_MASK, val);
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
@@ -186,15 +186,15 @@ static void asic3_mask_irq(unsigned int 
 
 	spin_lock_irqsave(&asic->lock, flags);
 	regval = asic3_read_register(asic,
-				     ASIC3_INTR_Base +
-				     ASIC3_INTR_IntMask);
+				     ASIC3_INTR_BASE +
+				     ASIC3_INTR_INT_MASK);
 
 	regval &= ~(ASIC3_INTMASK_MASK0 <<
 		    (irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
 
 	asic3_write_register(asic,
-			     ASIC3_INTR_Base +
-			     ASIC3_INTR_IntMask,
+			     ASIC3_INTR_BASE +
+			     ASIC3_INTR_INT_MASK,
 			     regval);
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
@@ -209,9 +209,9 @@ static void asic3_unmask_gpio_irq(unsign
 	index = asic3_irq_to_index(asic, irq);
 
 	spin_lock_irqsave(&asic->lock, flags);
-	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
+	val = asic3_read_register(asic, bank + ASIC3_GPIO_MASK);
 	val &= ~(1 << index);
-	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
+	asic3_write_register(asic, bank + ASIC3_GPIO_MASK, val);
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
@@ -223,15 +223,15 @@ static void asic3_unmask_irq(unsigned in
 
 	spin_lock_irqsave(&asic->lock, flags);
 	regval = asic3_read_register(asic,
-				     ASIC3_INTR_Base +
-				     ASIC3_INTR_IntMask);
+				     ASIC3_INTR_BASE +
+				     ASIC3_INTR_INT_MASK);
 
 	regval |= (ASIC3_INTMASK_MASK0 <<
 		   (irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
 
 	asic3_write_register(asic,
-			     ASIC3_INTR_Base +
-			     ASIC3_INTR_IntMask,
+			     ASIC3_INTR_BASE +
+			     ASIC3_INTR_INT_MASK,
 			     regval);
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
@@ -249,11 +249,11 @@ static int asic3_gpio_irq_type(unsigned 
 
 	spin_lock_irqsave(&asic->lock, flags);
 	level = asic3_read_register(asic,
-				    bank + ASIC3_GPIO_LevelTrigger);
+				    bank + ASIC3_GPIO_LEVEL_TRIGGER);
 	edge = asic3_read_register(asic,
-				   bank + ASIC3_GPIO_EdgeTrigger);
+				   bank + ASIC3_GPIO_EDGE_TRIGGER);
 	trigger = asic3_read_register(asic,
-				      bank + ASIC3_GPIO_TriggerType);
+				      bank + ASIC3_GPIO_TRIGGER_TYPE);
 	asic->irq_bothedge[(irq - asic->irq_base) >> 4] &= ~bit;
 
 	if (type == IRQT_RISING) {
@@ -283,11 +283,11 @@ static int asic3_gpio_irq_type(unsigned 
 		 */
 		dev_notice(asic->dev, "irq type not changed\n");
 	}
-	asic3_write_register(asic, bank + ASIC3_GPIO_LevelTrigger,
+	asic3_write_register(asic, bank + ASIC3_GPIO_LEVEL_TRIGGER,
 			     level);
-	asic3_write_register(asic, bank + ASIC3_GPIO_EdgeTrigger,
+	asic3_write_register(asic, bank + ASIC3_GPIO_EDGE_TRIGGER,
 			     edge);
-	asic3_write_register(asic, bank + ASIC3_GPIO_TriggerType,
+	asic3_write_register(asic, bank + ASIC3_GPIO_TRIGGER_TYPE,
 			     trigger);
 	spin_unlock_irqrestore(&asic->lock, flags);
 	return 0;
@@ -339,7 +339,7 @@ static int asic3_irq_probe(struct platfo
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
-	asic3_write_register(asic, ASIC3_OFFSET(INTR, IntMask),
+	asic3_write_register(asic, ASIC3_OFFSET(INTR, INT_MASK),
 			     ASIC3_INTMASK_GINTMASK);
 
 	set_irq_chained_handler(asic->irq_nr, asic3_irq_demux);
@@ -377,7 +377,7 @@ static int asic3_gpio_direction(struct g
 	asic = container_of(chip, struct asic3, gpio);
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
-	if (gpio_base > ASIC3_GPIO_D_Base) {
+	if (gpio_base > ASIC3_GPIO_D_BASE) {
 		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
 			gpio_base, offset);
 		return -EINVAL;
@@ -385,7 +385,7 @@ static int asic3_gpio_direction(struct g
 
 	spin_lock_irqsave(&asic->lock, flags);
 
-	out_reg = asic3_read_register(asic, gpio_base + ASIC3_GPIO_Direction);
+	out_reg = asic3_read_register(asic, gpio_base + ASIC3_GPIO_DIRECTION);
 
 	/* Input is 0, Output is 1 */
 	if (out)
@@ -393,7 +393,7 @@ static int asic3_gpio_direction(struct g
 	else
 		out_reg &= ~mask;
 
-	asic3_write_register(asic, gpio_base + ASIC3_GPIO_Direction, out_reg);
+	asic3_write_register(asic, gpio_base + ASIC3_GPIO_DIRECTION, out_reg);
 
 	spin_unlock_irqrestore(&asic->lock, flags);
 
@@ -423,13 +423,13 @@ static int asic3_gpio_get(struct gpio_ch
 	asic = container_of(chip, struct asic3, gpio);
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
-	if (gpio_base > ASIC3_GPIO_D_Base) {
+	if (gpio_base > ASIC3_GPIO_D_BASE) {
 		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
 			gpio_base, offset);
 		return -EINVAL;
 	}
 
-	return asic3_read_register(asic, gpio_base + ASIC3_GPIO_Status) & mask;
+	return asic3_read_register(asic, gpio_base + ASIC3_GPIO_STATUS) & mask;
 }
 
 static void asic3_gpio_set(struct gpio_chip *chip,
@@ -443,7 +443,7 @@ static void asic3_gpio_set(struct gpio_c
 	asic = container_of(chip, struct asic3, gpio);
 	gpio_base = ASIC3_GPIO_TO_BASE(offset);
 
-	if (gpio_base > ASIC3_GPIO_D_Base) {
+	if (gpio_base > ASIC3_GPIO_D_BASE) {
 		dev_err(asic->dev, "Invalid base (0x%x) for gpio %d\n",
 			gpio_base, offset);
 		return;
@@ -453,14 +453,14 @@ static void asic3_gpio_set(struct gpio_c
 
 	spin_lock_irqsave(&asic->lock, flags);
 
-	out_reg = asic3_read_register(asic, gpio_base + ASIC3_GPIO_Out);
+	out_reg = asic3_read_register(asic, gpio_base + ASIC3_GPIO_OUT);
 
 	if (value)
 		out_reg |= mask;
 	else
 		out_reg &= ~mask;
 
-	asic3_write_register(asic, gpio_base + ASIC3_GPIO_Out, out_reg);
+	asic3_write_register(asic, gpio_base + ASIC3_GPIO_OUT, out_reg);
 
 	spin_unlock_irqrestore(&asic->lock, flags);
 
@@ -481,10 +481,10 @@ static int asic3_gpio_probe(struct platf
 	memset(dir_reg, 0, ASIC3_NUM_GPIO_BANKS);
 
 	/* Enable all GPIOs */
-	asic3_write_register(asic, ASIC3_GPIO_OFFSET(A, Mask), 0xffff);
-	asic3_write_register(asic, ASIC3_GPIO_OFFSET(B, Mask), 0xffff);
-	asic3_write_register(asic, ASIC3_GPIO_OFFSET(C, Mask), 0xffff);
-	asic3_write_register(asic, ASIC3_GPIO_OFFSET(D, Mask), 0xffff);
+	asic3_write_register(asic, ASIC3_GPIO_OFFSET(A, MASK), 0xffff);
+	asic3_write_register(asic, ASIC3_GPIO_OFFSET(B, MASK), 0xffff);
+	asic3_write_register(asic, ASIC3_GPIO_OFFSET(C, MASK), 0xffff);
+	asic3_write_register(asic, ASIC3_GPIO_OFFSET(D, MASK), 0xffff);
 
 	for (i = 0; i < num; i++) {
 		u8 alt, pin, dir, init, bank_num, bit_num;
@@ -506,14 +506,14 @@ static int asic3_gpio_probe(struct platf
 	for (i = 0; i < ASIC3_NUM_GPIO_BANKS; i++) {
 		asic3_write_register(asic,
 				     ASIC3_BANK_TO_BASE(i) +
-				     ASIC3_GPIO_Direction,
+				     ASIC3_GPIO_DIRECTION,
 				     dir_reg[i]);
 		asic3_write_register(asic,
-				     ASIC3_BANK_TO_BASE(i) + ASIC3_GPIO_Out,
+				     ASIC3_BANK_TO_BASE(i) + ASIC3_GPIO_OUT,
 				     out_reg[i]);
 		asic3_write_register(asic,
 				     ASIC3_BANK_TO_BASE(i) +
-				     ASIC3_GPIO_AltFunction,
+				     ASIC3_GPIO_ALT_FUNCTION,
 				     alt_reg[i]);
 	}
 
diff -puN include/linux/mfd/asic3.h~asic3-use-uppercase-only-for-macros-and-defines include/linux/mfd/asic3.h
--- a/include/linux/mfd/asic3.h~asic3-use-uppercase-only-for-macros-and-defines
+++ a/include/linux/mfd/asic3.h
@@ -45,39 +45,39 @@ struct asic3_platform_data {
 /* All offsets below are specified with this address bus shift */
 #define ASIC3_DEFAULT_ADDR_SHIFT 2
 
-#define ASIC3_OFFSET(base, reg) (ASIC3_##base##_Base + ASIC3_##base##_##reg)
+#define ASIC3_OFFSET(base, reg) (ASIC3_##base##_BASE + ASIC3_##base##_##reg)
 #define ASIC3_GPIO_OFFSET(base, reg) \
-	(ASIC3_GPIO_##base##_Base + ASIC3_GPIO_##reg)
+	(ASIC3_GPIO_##base##_BASE + ASIC3_GPIO_##reg)
 
-#define ASIC3_GPIO_A_Base      0x0000
-#define ASIC3_GPIO_B_Base      0x0100
-#define ASIC3_GPIO_C_Base      0x0200
-#define ASIC3_GPIO_D_Base      0x0300
+#define ASIC3_GPIO_A_BASE      0x0000
+#define ASIC3_GPIO_B_BASE      0x0100
+#define ASIC3_GPIO_C_BASE      0x0200
+#define ASIC3_GPIO_D_BASE      0x0300
 
 #define ASIC3_GPIO_TO_BANK(gpio) ((gpio) >> 4)
 #define ASIC3_GPIO_TO_BIT(gpio)  ((gpio) - \
 				  (ASIC3_GPIOS_PER_BANK * ((gpio) >> 4)))
 #define ASIC3_GPIO_TO_MASK(gpio) (1 << ASIC3_GPIO_TO_BIT(gpio))
-#define ASIC3_GPIO_TO_BASE(gpio) (ASIC3_GPIO_A_Base + (((gpio) >> 4) * 0x0100))
-#define ASIC3_BANK_TO_BASE(bank) (ASIC3_GPIO_A_Base + ((bank) * 0x100))
+#define ASIC3_GPIO_TO_BASE(gpio) (ASIC3_GPIO_A_BASE + (((gpio) >> 4) * 0x0100))
+#define ASIC3_BANK_TO_BASE(bank) (ASIC3_GPIO_A_BASE + ((bank) * 0x100))
 
-#define ASIC3_GPIO_Mask          0x00    /* R/W 0:don't mask */
-#define ASIC3_GPIO_Direction     0x04    /* R/W 0:input */
-#define ASIC3_GPIO_Out           0x08    /* R/W 0:output low */
-#define ASIC3_GPIO_TriggerType   0x0c    /* R/W 0:level */
-#define ASIC3_GPIO_EdgeTrigger   0x10    /* R/W 0:falling */
-#define ASIC3_GPIO_LevelTrigger  0x14    /* R/W 0:low level detect */
-#define ASIC3_GPIO_SleepMask     0x18    /* R/W 0:don't mask in sleep mode */
-#define ASIC3_GPIO_SleepOut      0x1c    /* R/W level 0:low in sleep mode */
-#define ASIC3_GPIO_BattFaultOut  0x20    /* R/W level 0:low in batt_fault */
-#define ASIC3_GPIO_IntStatus     0x24    /* R/W 0:none, 1:detect */
-#define ASIC3_GPIO_AltFunction   0x28	 /* R/W 1:LED register control */
-#define ASIC3_GPIO_SleepConf     0x2c    /*
+#define ASIC3_GPIO_MASK          0x00    /* R/W 0:don't mask */
+#define ASIC3_GPIO_DIRECTION     0x04    /* R/W 0:input */
+#define ASIC3_GPIO_OUT           0x08    /* R/W 0:output low */
+#define ASIC3_GPIO_TRIGGER_TYPE  0x0c    /* R/W 0:level */
+#define ASIC3_GPIO_EDGE_TRIGGER  0x10    /* R/W 0:falling */
+#define ASIC3_GPIO_LEVEL_TRIGGER 0x14    /* R/W 0:low level detect */
+#define ASIC3_GPIO_SLEEP_MASK    0x18    /* R/W 0:don't mask in sleep mode */
+#define ASIC3_GPIO_SLEEP_OUT     0x1c    /* R/W level 0:low in sleep mode */
+#define ASIC3_GPIO_BAT_FAULT_OUT 0x20    /* R/W level 0:low in batt_fault */
+#define ASIC3_GPIO_INT_STATUS    0x24    /* R/W 0:none, 1:detect */
+#define ASIC3_GPIO_ALT_FUNCTION  0x28	 /* R/W 1:LED register control */
+#define ASIC3_GPIO_SLEEP_CONF    0x2c    /*
 					  * R/W bit 1: autosleep
 					  * 0: disable gposlpout in normal mode,
 					  * enable gposlpout in sleep mode.
 					  */
-#define ASIC3_GPIO_Status        0x30    /* R   Pin status */
+#define ASIC3_GPIO_STATUS        0x30    /* R   Pin status */
 
 /*
  * ASIC3 GPIO config
@@ -137,7 +137,7 @@ struct asic3_platform_data {
 #define LED_AUTOSTOP	(1 << 5) /* LED ON/OFF auto stop 0:disable, 1:enable */
 #define LED_ALWAYS	(1 << 6) /* LED Interrupt Mask 0:No mask, 1:mask */
 
-#define ASIC3_CLOCK_Base		0x0A00
+#define ASIC3_CLOCK_BASE	   0x0A00
 #define ASIC3_CLOCK_CDEX           0x00
 #define ASIC3_CLOCK_SEL            0x04
 
@@ -168,12 +168,12 @@ struct asic3_platform_data {
 #define CLOCK_SEL_CX            (1 << 2)
 
 
-#define ASIC3_INTR_Base		0x0B00
+#define ASIC3_INTR_BASE		0x0B00
 
-#define ASIC3_INTR_IntMask       0x00  /* Interrupt mask control */
-#define ASIC3_INTR_PIntStat      0x04  /* Peripheral interrupt status */
-#define ASIC3_INTR_IntCPS        0x08  /* Interrupt timer clock pre-scale */
-#define ASIC3_INTR_IntTBS        0x0c  /* Interrupt timer set */
+#define ASIC3_INTR_INT_MASK       0x00  /* Interrupt mask control */
+#define ASIC3_INTR_P_INT_STAT     0x04  /* Peripheral interrupt status */
+#define ASIC3_INTR_INT_CPS        0x08  /* Interrupt timer clock pre-scale */
+#define ASIC3_INTR_INT_TBS        0x0c  /* Interrupt timer set */
 
 #define ASIC3_INTMASK_GINTMASK    (1 << 0)  /* Global INTs mask 1:enable */
 #define ASIC3_INTMASK_GINTEL      (1 << 1)  /* 1: rising edge, 0: hi level */
_

Patches currently in -mm which might be from sameo@openedhand.com are

asic3-platform_get_irq-may-return-signed-unnoticed.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
asic3-use-dev_-macros.patch
asic3-use-uppercase-only-for-macros-and-defines.patch

