From: akpm@osdl.org
Subject: - updated-acpi-include-apich.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:59 -0800
Message-ID: <200612132248.kBDMmxXP023121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52923 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbWLMWt3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, len.brown@intel.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: Include apic.h
has been removed from the -mm tree.  Its filename was
     updated-acpi-include-apich.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ACPI: Include apic.h
From: Thomas Gleixner <tglx@linutronix.de>

apic.h does not get included on UP compiles.  That way the
APICTIMER_STOPS_ON_C3 is not there and UP boxen have no support for timer
broadcasting.  This was never noticed, because the lapic timer is only used
for profiling on UP.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_idle.c |   10 ++++++++++
 1 files changed, 10 insertions(+)

diff -puN drivers/acpi/processor_idle.c~updated-acpi-include-apich drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~updated-acpi-include-apich
+++ a/drivers/acpi/processor_idle.c
@@ -40,6 +40,16 @@
 #include <linux/sched.h>	/* need_resched() */
 #include <linux/latency.h>
 
+/*
+ * Include the apic definitions for x86 to have the APIC timer related defines
+ * available also for UP (on SMP it gets magically included via linux/smp.h).
+ * asm/acpi.h is not an option, as it would require more include magic. Also
+ * creating an empty asm-ia64/apic.h would just trade pest vs. cholera.
+ */
+#ifdef CONFIG_X86
+#include <asm/apic.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
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

