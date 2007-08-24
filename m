From: akpm@linux-foundation.org
Subject: + x86_64-apic-add-clockevents-functions.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:19 -0700
Message-ID: <200708242205.l7OM5JMs017029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758835AbXHXWP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     x86_64: Add (not yet used) clock event functions
has been added to the -mm tree.  Its filename is
     x86_64-apic-add-clockevents-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: Add (not yet used) clock event functions
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig       |    6 ++
 arch/x86_64/kernel/apic.c |   79 ++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff -puN arch/x86_64/Kconfig~x86_64-apic-add-clockevents-functions arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-apic-add-clockevents-functions
+++ a/arch/x86_64/Kconfig
@@ -28,6 +28,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS_MIGR
+	bool
+	default y
+
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
@@ -138,6 +142,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC
diff -puN arch/x86_64/kernel/apic.c~x86_64-apic-add-clockevents-functions arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-apic-add-clockevents-functions
+++ a/arch/x86_64/kernel/apic.c
@@ -25,6 +25,7 @@
 #include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/clockchips.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -57,6 +58,77 @@ static struct resource lapic_resource = 
 
 static unsigned int calibration_result;
 
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt);
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt);
+
+static void lapic_timer_broadcast(cpumask_t mask);
+
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen);
+
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.broadcast	= lapic_timer_broadcast,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt)
+{
+	apic_write(APIC_TMICT, delta);
+	return 0;
+}
+
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
+{
+	unsigned long flags;
+	unsigned int v;
+
+	/* Lapic used as dummy for broadcast ? */
+	if (evt->features & CLOCK_EVT_FEAT_DUMMY)
+		return;
+
+	local_irq_save(flags);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_ONESHOT:
+		__setup_APIC_LVTT(calibration_result,
+				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		v = apic_read(APIC_LVTT);
+		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, v);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
+	}
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Local APIC timer broadcast function
+ */
+static void lapic_timer_broadcast(cpumask_t mask)
+{
+#ifdef CONFIG_SMP
+	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+#endif
+}
+
 /*
  * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
  * IPIs in place of local APIC timers
@@ -870,6 +942,13 @@ static void __init calibrate_APIC_clock(
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC, 32);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
 	calibration_result = result / HZ;
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
git-acpi.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
