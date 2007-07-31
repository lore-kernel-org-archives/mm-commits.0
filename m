From: akpm@linux-foundation.org
Subject: + genirq-temporary-fix-for-level-triggered-irq-resend.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:51:20 -0700
Message-ID: <200707311851.l6VIpKnV016976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60460 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932196AbXGaSwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     genirq: temporary fix for level-triggered IRQ
has been added to the -mm tree.  Its filename is
     genirq-temporary-fix-for-level-triggered-irq-resend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: genirq: temporary fix for level-triggered IRQ
From: Thomas Gleixner <tglx@linutronix.de>


With -rc2 approaching I think we should apply the minimal fix below to get
Marcin's ne2k-pci networking back in working order.  The WARN_ON_ONCE()
will not prevent the system from working and it will be a reminder.

A better workaround would be to inhibit the resent vector via the IO-APIC
irqchip - but i'd still like to have the patch below because the ne2k
driver _should_ be able to survive the spurious irq that happens.  (even on
Marcin's system that ne2k-pci irq line is shared with another networking
card, so an irq could happen at any moment - it's just that with the
delayed-disable logic it happens _all the time_.)

	Ingo


Delayed disable relies on the ability to re-trigger the interrupt in the
case that a real interrupt happens after the software disable was set.  In
this case we actually disable the interrupt on the hardware level _after_
it occurred.

On enable_irq, we need to re-trigger the interrupt. On i386 this relies
on a hardware resend mechanism (send_IPI_self()).

Actually we only need the resend for edge type interrupts. Level type
interrupts come back once enable_irq() re-enables the interrupt line.

I assume that the interrupt in question is level triggered because it is
shared and above the legacy irqs 0-15:

	17:         12   IO-APIC-fasteoi   eth1, eth0

Looking into the IO_APIC code, the resend via send_IPI_self() happens
unconditionally. So the resend is done for level and edge interrupts.
This makes the problem more mysterious.

The code in question lib8390.c does

	disable_irq();
	fiddle_with_the_network_card_hardware()
	enable_irq();

The fiddle_with_the_network_card_hardware() might cause interrupts,
which are cleared in the same code path again,

Marcin found that when he disables the irq line on the hardware level
(removing the delayed disable) the card is kept alive.

So the difference is that we can get a resend on enable_irq, when an
interrupt happens during the time, where we are in the disabled region.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/resend.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN kernel/irq/resend.c~genirq-temporary-fix-for-level-triggered-irq-resend kernel/irq/resend.c
--- a/kernel/irq/resend.c~genirq-temporary-fix-for-level-triggered-irq-resend
+++ a/kernel/irq/resend.c
@@ -62,6 +62,15 @@ void check_irq_resend(struct irq_desc *d
 	 */
 	desc->chip->enable(irq);
 
+	/*
+	 * Temporary hack to figure out more about the problem, which
+	 * is causing the ancient network cards to die.
+	 */
+	if (desc->handle_irq != handle_edge_irq) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	if ((status & (IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
genirq-temporary-fix-for-level-triggered-irq-resend.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
