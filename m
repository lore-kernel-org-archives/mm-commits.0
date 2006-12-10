From: akpm@osdl.org
Subject: - sched-fix-migration-cost-estimator.patch removed from -mm tree
Date: Sun, 10 Dec 2006 15:06:41 -0800
Message-ID: <200612102306.kBAN6fnI006177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762496AbWLJXGy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 18:06:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, blubkin@vmware.com, mm-commits@vger.kernel.org


The patch titled
     sched: fix migration cost estimator
has been removed from the -mm tree.  Its filename was
     sched-fix-migration-cost-estimator.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sched: fix migration cost estimator
From: Ingo Molnar <mingo@elte.hu>

Bela found the following bug: touch_cache() only touched 2 thirds of the cache
buffer (hence wasting memory and possibly making calibration less accurate).

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=7476

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Bela Lubkin <blubkin@vmware.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff -puN kernel/sched.c~sched-fix-migration-cost-estimator kernel/sched.c
--- a/kernel/sched.c~sched-fix-migration-cost-estimator
+++ a/kernel/sched.c
@@ -5738,14 +5738,24 @@ static void touch_cache(void *__cache, u
 	unsigned long *cache = __cache;
 	int i;
 
+	/*
+	 * We access the buffer via 6 independent 'streams' of
+	 * read/write access which are interleaved:
+	 *
+	 * [--->     <---|--->     <---|--->     <---]
+	 *
+	 * We touch every cacheline in the buffer. (iteration
+	 * step is 32 bytes on 32-bit systems, 64 bytes on
+	 * 64-bit systems)
+	 */
 	for (i = 0; i < size/6; i += 8) {
-		switch (i % 6) {
-			case 0: cache[i]++;
-			case 1: cache[size-1-i]++;
-			case 2: cache[chunk1-i]++;
-			case 3: cache[chunk1+i]++;
-			case 4: cache[chunk2-i]++;
-			case 5: cache[chunk2+i]++;
+		switch (i % 6*8) {
+			case 0*8: cache[i]++;
+			case 1*8: cache[size-1-i]++;
+			case 2*8: cache[chunk1-i]++;
+			case 3*8: cache[chunk1+i]++;
+			case 4*8: cache[chunk2-i]++;
+			case 5*8: cache[chunk2+i]++;
 		}
 	}
 }
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
sched-fix-migration-cost-estimator.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
round_jiffies-infrastructure.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
kvm-userspace-interface.patch
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
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
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
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
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
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
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

