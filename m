From: akpm@osdl.org
Subject: - sched-fix-cond_resched_softirq-offset.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:22 -0800
Message-ID: <200701020724.l027OMQw012939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbXABHY0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: fix cond_resched_softirq() offset
has been removed from the -mm tree.  Its filename was
     sched-fix-cond_resched_softirq-offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix cond_resched_softirq() offset
From: Ingo Molnar <mingo@elte.hu>

Remove the __resched_legal() check: it is conceptually broken.  The biggest
problem it had is that it can mask buggy cond_resched() calls.  A
cond_resched() call is only legal if we are not in an atomic context, with
two narrow exceptions:

 - if the system is booting
 - a reacquire_kernel_lock() down() done while PREEMPT_ACTIVE is set

But __resched_legal() hid this and just silently returned whenever
these primitives were called from invalid contexts. (Same goes for
cond_resched_locked() and cond_resched_softirq()).

Furthermore, the __legal_resched(0) call was buggy in that it caused
unnecessarily long softirq latencies via cond_resched_softirq().  (which is
only called from softirq-off sections, hence the code did nothing.)

The fix is to resurrect the efficiency of the might_sleep checks and to
only allow the narrow exceptions.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN kernel/sched.c~sched-fix-cond_resched_softirq-offset kernel/sched.c
--- a/kernel/sched.c~sched-fix-cond_resched_softirq-offset
+++ a/kernel/sched.c
@@ -4617,17 +4617,6 @@ asmlinkage long sys_sched_yield(void)
 	return 0;
 }
 
-static inline int __resched_legal(int expected_preempt_count)
-{
-#ifdef CONFIG_PREEMPT
-	if (unlikely(preempt_count() != expected_preempt_count))
-		return 0;
-#endif
-	if (unlikely(system_state != SYSTEM_RUNNING))
-		return 0;
-	return 1;
-}
-
 static void __cond_resched(void)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
@@ -4647,7 +4636,8 @@ static void __cond_resched(void)
 
 int __sched cond_resched(void)
 {
-	if (need_resched() && __resched_legal(0)) {
+	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
+					system_state == SYSTEM_RUNNING) {
 		__cond_resched();
 		return 1;
 	}
@@ -4673,7 +4663,7 @@ int cond_resched_lock(spinlock_t *lock)
 		ret = 1;
 		spin_lock(lock);
 	}
-	if (need_resched() && __resched_legal(1)) {
+	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		spin_release(&lock->dep_map, 1, _THIS_IP_);
 		_raw_spin_unlock(lock);
 		preempt_enable_no_resched();
@@ -4689,7 +4679,7 @@ int __sched cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	if (need_resched() && __resched_legal(0)) {
+	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		raw_local_irq_disable();
 		_local_bh_enable();
 		raw_local_irq_enable();
_

Patches currently in -mm which might be from mingo@elte.hu are

use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
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
sched-improve-sched_clock-on-i686.patch
sched-improve-sched_clock-on-i686-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
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
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
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
debugging-feature-proc-timer_list-warning-fix.patch
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_slow.patch
fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-filesystem-aio-read-tidy.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
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
