From: akpm@osdl.org
Subject: + lockdep-more-unlock-on-error-fixes-fix.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:26:22 -0800
Message-ID: <200612192026.kBJKQMEp009373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbWLSU0f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, jarkao2@o2.pl


The patch titled
     lockdep-more-unlock-on-error-fixes fix
has been added to the -mm tree.  Its filename is
     lockdep-more-unlock-on-error-fixes-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep-more-unlock-on-error-fixes fix
From: Ingo Molnar <mingo@elte.hu>

My __acquire_lock() cleanup introduced a locking bug: on SMP systems we'd
release a non-owned graph lock.  Fix this by moving the graph unlock back,
and by leaving the max_lockdep_depth variable update possibly racy.  (we
dont care, it's just statistics)

Also add some minimal debugging code to graph_unlock()/graph_lock(),
which caught this locking bug.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep.c~lockdep-more-unlock-on-error-fixes-fix kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-more-unlock-on-error-fixes-fix
+++ a/kernel/lockdep.c
@@ -70,6 +70,9 @@ static int graph_lock(void)
 
 static inline int graph_unlock(void)
 {
+	if (debug_locks && !__raw_spin_is_locked(&lockdep_lock))
+		return DEBUG_LOCKS_WARN_ON(1);
+
 	__raw_spin_unlock(&lockdep_lock);
 	return 0;
 }
@@ -712,6 +715,9 @@ find_usage_backwards(struct lock_class *
 	struct lock_list *entry;
 	int ret;
 
+	if (!__raw_spin_is_locked(&lockdep_lock))
+		return DEBUG_LOCKS_WARN_ON(1);
+
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -2204,6 +2210,7 @@ out_calc_hash:
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
 				return 0;
+		graph_unlock();
 	} else
 		/* after lookup_chain_cache(): */
 		if (unlikely(!debug_locks))
@@ -2212,7 +2219,7 @@ out_calc_hash:
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
-		debug_locks_off_graph_unlock();
+		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		return 0;
@@ -2221,7 +2228,6 @@ out_calc_hash:
 	if (unlikely(curr->lockdep_depth > max_lockdep_depth))
 		max_lockdep_depth = curr->lockdep_depth;
 
-	graph_unlock();
 	return 1;
 }
 
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
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
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

