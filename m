From: akpm@osdl.org
Subject: - clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:52:30 -0800
Message-ID: <200612132252.kBDMqUXZ023293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbWLMXBO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 18:01:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ebiederm@xmission.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Check for clock event device handler being non NULL before calling it
has been removed from the -mm tree.  Its filename was
     clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Check for clock event device handler being non NULL before calling it
From: Vivek Goyal <vgoyal@in.ibm.com>

o Kdump broke in 2.6.19-rc4-mm1 on i386 due to LAPIC timer interrupt handling
  changes. (clock events)

o Problems happens because a pending LAPIC timer interrupt is received
  as soon as kernel enables interrupts first time during boot but
  associated clock event device has not been initialized yet and
  kernel crashes.

o One can receive a pending LAPIC timer interrupt from previous kernel's
  context (as in kdump).

o A pending LAPIC timer interrupt is delivedred to CPU in second kernel as
  soon as interrupts are enabled. Already idt vector has been set to handle
  LAPIC timer interrupts but actually LPAIC is setup in setup_local_APIC()
  much later. setup_local_APIC() also initializes LAPIC timer and in turn
  related clock_event_device. But here interrupts comes really early and LAPIC
  has not been set, associated clock_event_device structure has not been
  initialized hence kernel crashes in smp_apic_timer_interrupt().

o One of the possible solution is that register the LAPIC timer vector late
  after LAPIC has been initialized. But this would only solve the problem
  for boot cpu and not other cpus.

o In this patch, I check for clock_event_device event handler and if
  handler is NULL, that interrupt is ignored as spurious one. Not the best
  way to handle the situation as it does not count for bugs in
  clock_event_device creation and registration logic, and also introduces
  un-necessary check in fastpath. Pleaes suggest if there is a better way
  to handle this.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apic.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+)

diff -puN arch/i386/kernel/apic.c~clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it
+++ a/arch/i386/kernel/apic.c
@@ -563,6 +563,22 @@ static void local_apic_timer_interrupt(v
 		return;
 	}
 
+	/* Normally we should not be here till LAPIC has been initialized
+	 * but in some cases like kdump, its possible that there is a
+	 * pending LAPIC timer interrupt from previous kernel's context
+	 * and is delivered in new kernel the moment interrupts are enabled.
+	 *
+	 * Interrupts are enabled early and LAPIC is setup much later, hence
+	 * its possible that when we get here evt->event_handler is NULL.
+	 * Check for event_handler being NULL and discard the interrupt
+	 * as spurious.
+	 */
+
+	if (!evt->event_handler) {
+		printk("Spurious LAPIC timer interrupt on cpu %d\n", cpu);
+		return;
+	}
+
 	per_cpu(irq_stat, cpu).apic_timer_irqs++;
 
 	evt->event_handler();
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

origin.patch
clockevents-i386-drivers.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch

