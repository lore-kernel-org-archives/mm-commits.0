From: akpm@osdl.org
Subject: + lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:50:30 -0800
Message-ID: <200612182350.kBINoVpK016796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbWLRXug (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:50:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, matthew@wil.cx


The patch titled
     lock debugging: fix DEBUG_LOCKS_WARN_ON() & debug_locks_silent
has been added to the -mm tree.  Its filename is
     lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lock debugging: fix DEBUG_LOCKS_WARN_ON() & debug_locks_silent
From: Ingo Molnar <mingo@elte.hu>

Matthew Wilcox noticed that the debug_locks_silent use should be inverted
in DEBUG_LOCKS_WARN_ON().  This bug was causing spurious stacktraces and
incorrect failures in the locking self-test on the parisc kernel.

Bug-found-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/debug_locks.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/debug_locks.h~lock-debugging-fix-debug_locks_warn_on-debug_locks_silent include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~lock-debugging-fix-debug_locks_warn_on-debug_locks_silent
+++ a/include/linux/debug_locks.h
@@ -24,7 +24,7 @@ extern int debug_locks_off(void);
 	int __ret = 0;							\
 									\
 	if (unlikely(c)) {						\
-		if (debug_locks_silent || debug_locks_off())		\
+		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN_ON(1);					\
 		__ret = 1;						\
 	}								\
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch
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
schedule_on_each_cpu-use-preempt_disable.patch
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
debugging-feature-proc-timer_list.patch
debugging-feature-sysrq-q-to-print-timers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
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

