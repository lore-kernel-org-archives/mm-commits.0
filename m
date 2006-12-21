From: akpm@osdl.org
Subject: + workqueue-fix-schedule_on_each_cpu.patch added to -mm tree
Date: Wed, 20 Dec 2006 16:58:22 -0800
Message-ID: <200612210058.kBL0wMmu011759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161100AbWLUA6h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, dhowells@redhat.com


The patch titled
     workqueue: fix schedule_on_each_cpu()
has been added to the -mm tree.  Its filename is
     workqueue-fix-schedule_on_each_cpu.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: fix schedule_on_each_cpu()
From: Ingo Molnar <mingo@elte.hu>

Fix the schedule_on_each_cpu() implementation: __queue_work() is now
stricter, hence set the work-pending bit before passing in the new work.

(found in the -rt tree, using Peter Zijlstra's files-lock scalability
patchset)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-schedule_on_each_cpu kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-schedule_on_each_cpu
+++ a/kernel/workqueue.c
@@ -637,9 +637,11 @@ int schedule_on_each_cpu(work_func_t fun
 
 	mutex_lock(&workqueue_mutex);
 	for_each_online_cpu(cpu) {
-		INIT_WORK(per_cpu_ptr(works, cpu), func);
-		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu),
-				per_cpu_ptr(works, cpu));
+		struct work_struct *work = per_cpu_ptr(works, cpu);
+
+		INIT_WORK(work, func);
+		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
+		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
 	}
 	mutex_unlock(&workqueue_mutex);
 	flush_workqueue(keventd_wq);
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch
workqueue-fix-schedule_on_each_cpu.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
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
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
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
sched-improve-efficiency-of-sched_fork.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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

