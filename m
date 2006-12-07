From: akpm@osdl.org
Subject: - sysrq-x-show-blocked-tasks.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:51 -0800
Message-ID: <200612072301.kB7N1pUm029813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163634AbWLGXBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     SysRq-X: show blocked tasks
has been removed from the -mm tree.  Its filename was
     sysrq-x-show-blocked-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SysRq-X: show blocked tasks
From: Ingo Molnar <mingo@elte.hu>

Add SysRq-X support: show blocked (TASK_UNINTERRUPTIBLE) tasks only.

Useful for debugging IO stalls.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sysrq.c  |   14 +++++++++++++-
 include/linux/sched.h |   11 ++++++++++-
 kernel/sched.c        |   11 ++++++++---
 3 files changed, 31 insertions(+), 5 deletions(-)

diff -puN drivers/char/sysrq.c~sysrq-x-show-blocked-tasks drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-x-show-blocked-tasks
+++ a/drivers/char/sysrq.c
@@ -182,6 +182,18 @@ static struct sysrq_key_op sysrq_showsta
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
+static void sysrq_handle_showstate_blocked(int key, struct tty_struct *tty)
+{
+	show_state_filter(TASK_UNINTERRUPTIBLE);
+}
+static struct sysrq_key_op sysrq_showstate_blocked_op = {
+	.handler	= sysrq_handle_showstate_blocked,
+	.help_msg	= "showBlockedTasks",
+	.action_msg	= "Show Blocked State",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+
+
 static void sysrq_handle_showmem(int key, struct tty_struct *tty)
 {
 	show_mem();
@@ -304,7 +316,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	/* May be assigned at init time by SMP VOYAGER */
 	NULL,				/* v */
 	NULL,				/* w */
-	NULL,				/* x */
+	&sysrq_showstate_blocked_op,	/* x */
 	NULL,				/* y */
 	NULL				/* z */
 };
diff -puN include/linux/sched.h~sysrq-x-show-blocked-tasks include/linux/sched.h
--- a/include/linux/sched.h~sysrq-x-show-blocked-tasks
+++ a/include/linux/sched.h
@@ -194,7 +194,16 @@ extern void init_idle(struct task_struct
 
 extern cpumask_t nohz_cpu_mask;
 
-extern void show_state(void);
+/*
+ * Only dump TASK_* tasks. (-1 for all tasks)
+ */
+extern void show_state_filter(unsigned long state_filter);
+
+static inline void show_state(void)
+{
+	show_state_filter(-1);
+}
+
 extern void show_regs(struct pt_regs *);
 
 /*
diff -puN kernel/sched.c~sysrq-x-show-blocked-tasks kernel/sched.c
--- a/kernel/sched.c~sysrq-x-show-blocked-tasks
+++ a/kernel/sched.c
@@ -4804,7 +4804,7 @@ static void show_task(struct task_struct
 		show_stack(p, NULL);
 }
 
-void show_state(void)
+void show_state_filter(unsigned long state_filter)
 {
 	struct task_struct *g, *p;
 
@@ -4824,11 +4824,16 @@ void show_state(void)
 		 * console might take alot of time:
 		 */
 		touch_nmi_watchdog();
-		show_task(p);
+		if (p->state & state_filter)
+			show_task(p);
 	} while_each_thread(g, p);
 
 	read_unlock(&tasklist_lock);
-	debug_show_all_locks();
+	/*
+	 * Only show locks if all tasks are dumped:
+	 */
+	if (state_filter == -1)
+		debug_show_all_locks();
 }
 
 /**
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch
time-re-add-verify_pmtmr_rate.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
fix-generic-warn_on-message.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
sched-fix-migration-cost-estimator.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
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
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
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

