From: akpm@linux-foundation.org
Subject: - genirq-record-irq_level-in-irq_desc.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:20 -0800
Message-ID: <200812152002.mBFK2Kc1030890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbYLOUDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:03:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: record IRQ_LEVEL in irq_desc[]
has been removed from the -mm tree.  Its filename was
     genirq-record-irq_level-in-irq_desc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: record IRQ_LEVEL in irq_desc[]
From: David Brownell <dbrownell@users.sourceforge.net>

When recording the irq trigger type, let's also make sure
that IRQ_LEVEL gets set correctly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c   |    1 +
 kernel/irq/manage.c |   15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN kernel/irq/chip.c~genirq-record-irq_level-in-irq_desc kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-record-irq_level-in-irq_desc
+++ a/kernel/irq/chip.c
@@ -124,6 +124,7 @@ int set_irq_type(unsigned int irq, unsig
 		return -ENODEV;
 	}
 
+	type &= IRQ_TYPE_SENSE_MASK;
 	if (type == IRQ_TYPE_NONE)
 		return 0;
 
diff -puN kernel/irq/manage.c~genirq-record-irq_level-in-irq_desc kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-record-irq_level-in-irq_desc
+++ a/kernel/irq/manage.c
@@ -368,16 +368,18 @@ int __irq_set_trigger(struct irq_desc *d
 		return 0;
 	}
 
-	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
+	/* caller masked out all except trigger mode flags */
+	ret = chip->set_type(irq, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
-				(int)(flags & IRQF_TRIGGER_MASK),
-				irq, chip->set_type);
+				(int)flags, irq, chip->set_type);
 	else {
+		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+			flags |= IRQ_LEVEL;
 		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= flags & IRQ_TYPE_SENSE_MASK;
+		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
+		desc->status |= flags;
 	}
 
 	return ret;
@@ -457,7 +459,8 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			ret = __irq_set_trigger(desc, irq, new->flags);
+			ret = __irq_set_trigger(desc, irq,
+					new->flags & IRQF_TRIGGER_MASK);
 
 			if (ret) {
 				spin_unlock_irqrestore(&desc->lock, flags);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
documentation-when-to-bug-and-when-to-not-bug.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch
mfd-da903x-section-fix.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch
gpio-pca953x-handles-more-chips-i2c-fault-codes.patch

