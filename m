From: akpm@linux-foundation.org
Subject: - lockdep-more-unlock-on-error-fixes-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 15:29:13 -0800
Message-ID: <200702082329.l18NTERv030594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030256AbXBHX30 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 18:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, jarkao2@o2.pl, mm-commits@vger.kernel.org


The patch titled
     lockdep-more-unlock-on-error-fixes fix
has been removed from the -mm tree.  Its filename was
     lockdep-more-unlock-on-error-fixes-fix.patch

This patch was dropped because it was folded into lockdep-more-unlock-on-error-fixes.patch

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
 1 file changed, 8 insertions(+), 2 deletions(-)

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
@@ -2208,6 +2214,7 @@ out_calc_hash:
 		if (!chain_head && ret != 2)
 			if (!check_prevs_add(curr, hlock))
 				return 0;
+		graph_unlock();
 	} else
 		/* after lookup_chain_cache(): */
 		if (unlikely(!debug_locks))
@@ -2216,7 +2223,7 @@ out_calc_hash:
 	curr->lockdep_depth++;
 	check_chain_key(curr);
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
-		debug_locks_off_graph_unlock();
+		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
 		return 0;
@@ -2225,7 +2232,6 @@ out_calc_hash:
 	if (unlikely(curr->lockdep_depth > max_lockdep_depth))
 		max_lockdep_depth = curr->lockdep_depth;
 
-	graph_unlock();
 	return 1;
 }
 
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
fix-apparent-typo-config_lockdep_debug.patch
highmem-catch-illegal-nesting.patch
fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch
debug-shared-irqs.patch
kernel-shut-up-the-irq-mismatch-messages.patch
lockdep-forward-declare-struct-task_struct.patch
close_files-add-scheduling-point.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
i386-enable-dynticks-in-kconfig.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
sched-avoid-div-in-rebalance_tick.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
kvm-optimize-inline-assembly.patch
kvm-fix-asm-constraint-for-lldt-instruction.patch
kvm-fix-gva_to_gpa.patch
kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch
kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch
kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch
kvm-two-way-apic-tpr-synchronization.patch
kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch
kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch
kvm-fix-vcpu-freeing-bug.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
kvm-vmx-add-vcpu_clear.patch
kvm-cpu-hotplug-support.patch
kvm-host-suspend-resume-support.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
