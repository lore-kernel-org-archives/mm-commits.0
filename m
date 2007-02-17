From: akpm@linux-foundation.org
Subject: - i386-prepare-nmi-watchdog-for-dynticks.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:08 -0800
Message-ID: <200702170715.l1H7F8bi021597@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946464AbXBQHP0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, ebiederm@xmission.com, johnstul@us.ibm.com, mingo@elte.hu, rohitseth@google.com, zach@vmware.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     i386 prepare nmi watchdog for dynticks
has been removed from the -mm tree.  Its filename was
     i386-prepare-nmi-watchdog-for-dynticks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 prepare nmi watchdog for dynticks
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
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/nmi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/nmi.c~i386-prepare-nmi-watchdog-for-dynticks arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~i386-prepare-nmi-watchdog-for-dynticks
+++ a/arch/i386/kernel/nmi.c
@@ -23,6 +23,7 @@
 #include <linux/dmi.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
@@ -973,9 +974,13 @@ __kprobes int nmi_watchdog_tick(struct p
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
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
