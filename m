From: akpm@linux-foundation.org
Subject: + cpu-hotplug-support-broken.patch added to -mm tree
Date: Sat, 15 Sep 2007 03:19:16 -0700
Message-ID: <200709151019.l8FAJGlJ028934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbXIOKT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 06:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de


The patch titled
     cpu hotplug support broken
has been added to the -mm tree.  Its filename is
     cpu-hotplug-support-broken.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu hotplug support broken
From: Thomas Gleixner <tglx@linutronix.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |   21 +++++++++++++++++++++
 kernel/time/tick-broadcast.c  |   24 ++++++++++++++++--------
 kernel/time/tick-sched.c      |   12 ++++++++++++
 3 files changed, 49 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/processor_core.c~cpu-hotplug-support-broken drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~cpu-hotplug-support-broken
+++ a/drivers/acpi/processor_core.c
@@ -724,6 +724,25 @@ static void acpi_processor_notify(acpi_h
 	return;
 }
 
+static int acpi_cpu_soft_notify(struct notifier_block *nfb,
+		unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct acpi_processor *pr = processors[cpu];
+
+	if (action == CPU_ONLINE && pr) {
+		acpi_processor_ppc_has_changed(pr);
+		acpi_processor_cst_has_changed(pr);
+		acpi_processor_tstate_has_changed(pr);
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_cpu_notifier =
+{
+	    .notifier_call = acpi_cpu_soft_notify,
+};
+
 static int acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
@@ -987,6 +1006,7 @@ void acpi_processor_install_hotplug_noti
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, &action, NULL);
 #endif
+	register_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 static
@@ -999,6 +1019,7 @@ void acpi_processor_uninstall_hotplug_no
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, &action, NULL);
 #endif
+	unregister_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 /*
diff -puN kernel/time/tick-broadcast.c~cpu-hotplug-support-broken kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~cpu-hotplug-support-broken
+++ a/kernel/time/tick-broadcast.c
@@ -382,12 +382,23 @@ static int tick_broadcast_set_event(ktim
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
+	int cpu = smp_processor_id();
+
+	/*
+	 * If the CPU is marked for broadcast, enforce oneshot
+	 * broadcast mode. The jinxed VAIO does not resume otherwise.
+	 * No idea why it ends up in a lower C State during resume
+	 * without notifying the clock events layer.
+	 */
+	if (cpu_isset(cpu, tick_broadcast_mask))
+		cpu_set(cpu, tick_broadcast_oneshot_mask);
+
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 	if(!cpus_empty(tick_broadcast_oneshot_mask))
 		tick_broadcast_set_event(ktime_get(), 1);
 
-	return cpu_isset(smp_processor_id(), tick_broadcast_oneshot_mask);
+	return cpu_isset(cpu, tick_broadcast_oneshot_mask);
 }
 
 /*
@@ -549,20 +560,17 @@ void tick_broadcast_switch_to_oneshot(vo
  */
 void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 {
-	struct clock_event_device *bc;
 	unsigned long flags;
 	unsigned int cpu = *cpup;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
-	bc = tick_broadcast_device.evtdev;
+	/*
+	 * Clear the broadcast mask flag for the dead cpu, but do not
+	 * stop the broadcast device!
+	 */
 	cpu_clear(cpu, tick_broadcast_oneshot_mask);
 
-	if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT) {
-		if (bc && cpus_empty(tick_broadcast_oneshot_mask))
-			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	}
-
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
diff -puN kernel/time/tick-sched.c~cpu-hotplug-support-broken kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~cpu-hotplug-support-broken
+++ a/kernel/time/tick-sched.c
@@ -160,6 +160,18 @@ void tick_nohz_stop_sched_tick(void)
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
+	/*
+	 * If this cpu is offline and it is the one which updates
+	 * jiffies, then give up the assignment and let it be taken by
+	 * the cpu which runs the tick timer next. If we don't drop
+	 * this here the jiffies might be stale and do_timer() never
+	 * invoked.
+	 */
+	if (unlikely(!cpu_online(cpu))) {
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = -1;
+	}
+
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

futex_compat-fix-list-traversal-bugs.patch
fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch
timekeeping-prevent-time-going-backwards-on-resume.patch
timekeeping-prevent-time-going-backwards-on-resume-v2.patch
cpu-hotplug-support-broken.patch
git-acpi.patch
arm-cleanup-struct-irqaction-initializers.patch
git-mips.patch
sh-cleanup-struct-irqaction-initializers.patch
sh64-cleanup-struct-irqaction-initializers.patch
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
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
frv-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
v850-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
