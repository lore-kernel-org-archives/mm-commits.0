From: akpm@linux-foundation.org
Subject: - genirq-record-trigger-type.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:46:18 -0700
Message-ID: <200810012146.m91LkJIv005624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbYJAVqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: record trigger type
has been removed from the -mm tree.  Its filename was
     genirq-record-trigger-type.patch

This patch was dropped because everyone's trees are all incredibly fucked up

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: record trigger type
From: David Brownell <dbrownell@users.sourceforge.net>

Genirq hasn't previously recorded the trigger type used by any given IRQ,
although some irq_chip support has done so.  That data can be useful when
troubleshooting.  This patch records it in the relevant irq_desc.status
bits, and improves consistency between the two driver-visible calls
affected:

 - Make set_irq_type() usage match request_irq() usage:
    * IRQ_TYPE_NONE should be a NOP; succeed, so irq_chip methods
      won't have to handle that case any more (many do it wrong).
    * IRQ_TYPE_PROBE is ignored; any buggy out-of-tree callers
      might need to switch over to the real IRQ probing code.
    * emit the same diagnostics (from shared utility code)

 - Their kerneldoc now reflects usage:
    * request_irq() flags include IRQF_TRIGGER_* to specify
      active edge(s)/level ... docs previously omitted that
    * set_irq_type() is declared in <linux/irq.h> so callers
      should use the (bit-equivalent) IRQ_TYPE_* symbols there

Also: adds a warning about shared IRQs that don't end up using the
requested trigger mode; and fix an unrelated "sparse" warning.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c      |   15 ++++++++-------
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   21 ++++++++++++++++++---
 3 files changed, 29 insertions(+), 10 deletions(-)

diff -puN kernel/irq/chip.c~genirq-record-trigger-type kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-record-trigger-type
+++ a/kernel/irq/chip.c
@@ -113,9 +113,9 @@ int set_irq_chip(unsigned int irq, struc
 EXPORT_SYMBOL(set_irq_chip);
 
 /**
- *	set_irq_type - set the irq type for an irq
+ *	set_irq_type - set the irq trigger type for an irq
  *	@irq:	irq number
- *	@type:	interrupt type - see include/linux/interrupt.h
+ *	@type:	IRQ_TYPE_{LEVEL,EDGE}_* value - see include/linux/irq.h
  */
 int set_irq_type(unsigned int irq, unsigned int type)
 {
@@ -129,11 +129,12 @@ int set_irq_type(unsigned int irq, unsig
 		return -ENODEV;
 	}
 
-	if (desc->chip->set_type) {
-		spin_lock_irqsave(&desc->lock, flags);
-		ret = desc->chip->set_type(irq, type);
-		spin_unlock_irqrestore(&desc->lock, flags);
-	}
+	if (type == IRQ_TYPE_NONE)
+		return 0;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	ret = __irq_set_trigger(desc, irq, flags);
+	spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(set_irq_type);
diff -puN kernel/irq/internals.h~genirq-record-trigger-type kernel/irq/internals.h
--- a/kernel/irq/internals.h~genirq-record-trigger-type
+++ a/kernel/irq/internals.h
@@ -10,6 +10,9 @@ extern void irq_chip_set_defaults(struct
 /* Set default handler: */
 extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
+extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
+		unsigned long flags);
+
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
diff -puN kernel/irq/manage.c~genirq-record-trigger-type kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-record-trigger-type
+++ a/kernel/irq/manage.c
@@ -225,7 +225,7 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
-int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
@@ -319,10 +319,11 @@ void compat_irq_chip_set_default_handler
 		desc->handle_irq = NULL;
 }
 
-static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
+int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags)
 {
 	int ret;
+	struct irq_chip *chip = desc->chip;
 
 	if (!chip || !chip->set_type) {
 		/*
@@ -340,6 +341,11 @@ static int __irq_set_trigger(struct irq_
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
 				(int)(flags & IRQF_TRIGGER_MASK),
 				irq, chip->set_type);
+	else {
+		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
+		desc->status &= ~IRQ_TYPE_SENSE_MASK;
+		desc->status |= flags & IRQ_TYPE_SENSE_MASK;
+	}
 
 	return ret;
 }
@@ -419,7 +425,7 @@ int setup_irq(unsigned int irq, struct i
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			ret = __irq_set_trigger(desc->chip, irq, new->flags);
+			ret = __irq_set_trigger(desc, irq, new->flags);
 
 			if (ret) {
 				spin_unlock_irqrestore(&desc->lock, flags);
@@ -448,6 +454,14 @@ int setup_irq(unsigned int irq, struct i
 
 		/* Set default affinity mask once everything is setup */
 		irq_select_affinity(irq);
+
+	} else if ((new->flags & IRQF_TRIGGER_MASK)
+			&& (new->flags & IRQF_TRIGGER_MASK)
+				!= (desc->status & IRQ_TYPE_SENSE_MASK)) {
+		/* hope the handler works with the actual trigger mode... */
+		pr_warning("IRQ %d uses trigger mode %d; requested %d\n",
+				irq, (int)(desc->status & IRQ_TYPE_SENSE_MASK),
+				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
 	*p = new;
@@ -605,6 +619,7 @@ EXPORT_SYMBOL(free_irq);
  *	IRQF_SHARED		Interrupt is shared
  *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
+ *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
  */
 int request_irq(unsigned int irq, irq_handler_t handler,
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
git-arm.patch
git-avr32.patch
git-x86.patch
git-mtd.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
spi-simplify-spi_write_then_read.patch
spi_s3c24xx-pin-configuration-updates.patch
pxa2xx_spi-minor-cleanup.patch
pxa2xx_spi-fix-chip_info-defaults-and-documentation.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
rtc-cmos-export-second-nvram-bank.patch
make-gpiochip-label-const.patch
genirq-record-trigger-type.patch
genirq-record-trigger-type-fix.patch
irq-warn-about-irqf_disabledirqf_shared.patch

