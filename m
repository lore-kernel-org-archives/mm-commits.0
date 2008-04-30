From: akpm@linux-foundation.org
Subject: + generic-irq-let-setup_irq-reenable-a-shared-irq.patch added to -mm tree
Date: Wed, 30 Apr 2008 05:31:03 -0700
Message-ID: <200804301231.m3UCV3mi013539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757103AbYD3McI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, Uwe.Kleine-Koenig@digi.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu


The patch titled
     generic irq: let setup_irq reenable a shared irq
has been added to the -mm tree.  Its filename is
     generic-irq-let-setup_irq-reenable-a-shared-irq.patch

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
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
asm-futexh-should-include-linux-uaccessh.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-update.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-kvm.patch
aes-x86_64-asm-implementation-optimization.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
remove-div_long_long_rem.patch
ntp-cleanup-ntpc.patch
ntp-ntp4-user-space-bits-update.patch
ntp-increase-time_freq-resolution.patch
ntp-increase-time_offset-resolution.patch
ntp-support-for-tai.patch
ntp-rename-tick_length_shift-to-ntp_scale_shift.patch
ntp-remove-current_tick_length.patch
ntp-handle-leap-second-via-timer.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

