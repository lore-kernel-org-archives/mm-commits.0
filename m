From: akpm@linux-foundation.org
Subject: - generic-irq-let-setup_irq-reenable-a-shared-irq.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:51 -0700
Message-ID: <200805021943.m42Jhpq5011325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933542AbYEBTot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, Uwe.Kleine-Koenig@digi.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     generic irq: let setup_irq reenable a shared irq
has been removed from the -mm tree.  Its filename was
     generic-irq-let-setup_irq-reenable-a-shared-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic irq: let setup_irq reenable a shared irq
From: Thomas Gleixner <tglx@linutronix.de>

Uwe Kleine-Koenig has some strange hardware where one of the shared interrupts
can be asserted during boot before the appropriate driver loads.  Requesting
the shared irq line from another driver results in a spurious interrupt storm
which finally disables the interrupt line.

I have seen similar behaviour on resume before (the hardware does not work
anymore so I can not verify) and this spurious irq issue is raised on a
regular base in bugreports.

Change the spurious disable logic to increment the disable depth and mark the
interrupt with an extra flag which allows us to reenable the interrupt when a
new driver arrives which requests the same irq line.  In the worst case this
will disable the irq again via the spurious trap, but there is a decent chance
that the new driver is the one which can handle the already asserted interrupt
and makes the box usable again.

[Uwe.Kleine-Koenig@digi.com: changed IRQ_SPURIOUS_DISABLED to be different from IRQ_NO_BALANCING]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Tested-and-Signed-off-by: Uwe Kleine-Koenig <Uwe.Kleine-Koenig@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h   |    1 
 kernel/irq/manage.c   |   49 ++++++++++++++++++++++++++--------------
 kernel/irq/spurious.c |    4 +--
 3 files changed, 35 insertions(+), 19 deletions(-)

diff -puN include/linux/irq.h~generic-irq-let-setup_irq-reenable-a-shared-irq include/linux/irq.h
--- a/include/linux/irq.h~generic-irq-let-setup_irq-reenable-a-shared-irq
+++ a/include/linux/irq.h
@@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
+#define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
diff -puN kernel/irq/manage.c~generic-irq-let-setup_irq-reenable-a-shared-irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~generic-irq-let-setup_irq-reenable-a-shared-irq
+++ a/kernel/irq/manage.c
@@ -150,6 +150,26 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
+static void __enable_irq(struct irq_desc *desc, unsigned int irq)
+{
+	switch (desc->depth) {
+	case 0:
+		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN_ON(1);
+		break;
+	case 1: {
+		unsigned int status = desc->status & ~IRQ_DISABLED;
+
+		/* Prevent probing on this irq: */
+		desc->status = status | IRQ_NOPROBE;
+		check_irq_resend(desc, irq);
+		/* fall-through */
+	}
+	default:
+		desc->depth--;
+	}
+}
+
 /**
  *	enable_irq - enable handling of an irq
  *	@irq: Interrupt to enable
@@ -169,22 +189,7 @@ void enable_irq(unsigned int irq)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	switch (desc->depth) {
-	case 0:
-		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		WARN_ON(1);
-		break;
-	case 1: {
-		unsigned int status = desc->status & ~IRQ_DISABLED;
-
-		/* Prevent probing on this irq: */
-		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
-		/* fall-through */
-	}
-	default:
-		desc->depth--;
-	}
+	__enable_irq(desc, irq);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL(enable_irq);
@@ -365,7 +370,7 @@ int setup_irq(unsigned int irq, struct i
 			compat_irq_chip_set_default_handler(desc);
 
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
-				  IRQ_INPROGRESS);
+				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
@@ -381,6 +386,16 @@ int setup_irq(unsigned int irq, struct i
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
+
+	/*
+	 * Check whether we disabled the irq via the spurious handler
+	 * before. Reenable it and give it another chance.
+	 */
+	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
+		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+		__enable_irq(desc, irq);
+	}
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	new->irq = irq;
diff -puN kernel/irq/spurious.c~generic-irq-let-setup_irq-reenable-a-shared-irq kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~generic-irq-let-setup_irq-reenable-a-shared-irq
+++ a/kernel/irq/spurious.c
@@ -209,8 +209,8 @@ void note_interrupt(unsigned int irq, st
 		 * Now kill the IRQ
 		 */
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_DISABLED;
-		desc->depth = 1;
+		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
+		desc->depth++;
 		desc->chip->disable(irq);
 	}
 	desc->irqs_unhandled = 0;
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-x86-fixup.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
clocksource-shift-helper.patch
git-kvm.patch
git-sched.patch
aes-x86_64-asm-implementation-optimization.patch
clocksource-fix-permissions-for-available_clocksource.patch

