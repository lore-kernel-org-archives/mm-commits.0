From: akpm@linux-foundation.org
Subject: + genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch added to -mm tree
Date: Mon, 22 Jun 2009 14:27:35 -0700
Message-ID: <200906222127.n5MLRZn3000579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbZFVV3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 17:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, khilman@deeprootsystems.com, rjw@sisk.pl, rmk@arm.linux.org.uk, stable@kernel.org


The patch titled
     genirq: do not disable IRQ_WAKEUP marked irqs on suspend
has been added to the -mm tree.  Its filename is
     genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch

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
Subject: genirq: do not disable IRQ_WAKEUP marked irqs on suspend
From: Thomas Gleixner <tglx@linutronix.de>

commit 0a0c5168df (PM: Introduce functions for suspending and resuming
device interrupts) iterates through all interrupts and disables them on
the hardware level.  Some architectures have functionality implemented to
mark an interrupt source as wakeup source for suspend, but the new power
management code disables them unconditionally which breaks the resume on
interrupt functionality.

The wakeup interrupts are marked in the status with the IRQ_WAKEUP bit. 
Skip the disablement for those interrupts which have the IRQ_WAKEUP bit
set.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/irq/pm.c~genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend kernel/irq/pm.c
--- a/kernel/irq/pm.c~genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend
+++ a/kernel/irq/pm.c
@@ -29,7 +29,8 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		if (!(desc->status & IRQ_WAKEUP))
+			__disable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
parisc-remove-obsolete-hw_interrupt_type.patch
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch

