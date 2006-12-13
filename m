From: akpm@osdl.org
Subject: - updated-dynticks-fix-nmi-watchdog.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:50:02 -0800
Message-ID: <200612132250.kBDMo4Ia023198@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53113 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbWLMWuP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, ebiederm@xmission.com, mingo@elte.hu, rohitseth@google.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     dynticks: Fix nmi watchdog
has been removed from the -mm tree.  Its filename was
     updated-dynticks-fix-nmi-watchdog.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: dynticks: Fix nmi watchdog
From: Thomas Gleixner <tglx@linutronix.de>

The NMI watchdog implementation assumes that the local APIC timer interrupt is
happening.  This assumption is not longer true when high resolution timers and
dynamic ticks come into play, as they may switch off the local APIC timer
completely.  Take the PIT/HPET interrupts into account too, to avoid false
positives.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/nmi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/nmi.c~updated-dynticks-fix-nmi-watchdog arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~updated-dynticks-fix-nmi-watchdog
+++ a/arch/i386/kernel/nmi.c
@@ -23,6 +23,7 @@
 #include <linux/dmi.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
@@ -950,9 +951,13 @@ __kprobes int nmi_watchdog_tick(struct p
 		cpu_clear(cpu, backtrace_mask);
 	}
 
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs;
+	/*
+	 * Take the local apic timer and PIT/HPET into account. We don't
+	 * know which one is active, when we have highres/dyntick on
+	 */
+	sum = per_cpu(irq_stat, cpu).apic_timer_irqs + kstat_irqs(0);
 
-	/* if the apic timer isn't firing, this cpu isn't doing much */
+	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && last_irq_sums[cpu] == sum) {
 		/*
 		 * Ayiee, looks like this CPU is stuck ...
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

