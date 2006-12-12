From: akpm@osdl.org
Subject: + debugging-feature-proc-timer_list-fix-2.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:57:55 -0800
Message-ID: <200612122057.kBCKvtbD015530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbWLLU6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     debugging feature: /proc/timer_list, fix #2
has been added to the -mm tree.  Its filename is
     debugging-feature-proc-timer_list-fix-2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: debugging feature: /proc/timer_list, fix #2
From: Ingo Molnar <mingo@elte.hu>

remove -rt-isms: DEFINE_RAW_SPINLOCK -> DEFINE_SPINLOCK and
raw_spinlock_t -> spinlock_t.

Verified that the resulting kernel builds and boots fine and that the
/proc/timer_list and /proc/timer_stats features work as expected.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/timer_stats.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/timer_stats.c~debugging-feature-proc-timer_list-fix-2 kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~debugging-feature-proc-timer_list-fix-2
+++ a/kernel/time/timer_stats.c
@@ -80,12 +80,12 @@ struct entry {
 /*
  * Spinlock protecting the tables - not taken during lookup:
  */
-static DEFINE_RAW_SPINLOCK(table_lock);
+static DEFINE_SPINLOCK(table_lock);
 
 /*
  * Per-CPU lookup locks for fast hash lookup:
  */
-static DEFINE_PER_CPU(raw_spinlock_t, lookup_lock);
+static DEFINE_PER_CPU(spinlock_t, lookup_lock);
 
 /*
  * Mutex to serialize state changes with show-stats activities:
@@ -232,7 +232,7 @@ void timer_stats_update_stats(void *time
 	/*
 	 * It doesnt matter which lock we take:
 	 */
-	raw_spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+	spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
 	struct entry *entry, input;
 	unsigned long flags;
 
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
lockdep-fix-possible-race-while-disabling-lock-debugging-restore-fix.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
optimize-calc_load.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-i8253c-remove-hpet-dependencies.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-high-res-timers-core-cleanup-state-tracking-update.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dynticks-core-code-fix-resume-bug.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
updated-debugging-feature-timer-stats-fixes.patch
debugging-feature-proc-timer_list.patch
debugging-feature-proc-timer_list-fix.patch
debugging-feature-proc-timer_list-fix-2.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
clockevents-convert-hpet-to-clockevents.patch
clockevents-make-apicc-exports-gpl-remove-fastcall-attributes.patch
clockevents-remove-ptregs-argument-from-handlers.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch

