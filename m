From: akpm@linux-foundation.org
Subject: - mm-only-hrtimers-debug-patch.patch removed from -mm tree
Date: Fri, 30 Mar 2007 09:53:50 -0700
Message-ID: <200703301653.l2UGrpiH031836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbXC3QyP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 12:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimers debug patch
has been removed from the -mm tree.  Its filename was
     mm-only-hrtimers-debug-patch.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: hrtimers debug patch
From: Ingo Molnar <mingo@elte.hu>

debugging helper for hrtimers.  Keep a lookout for WARN_ON messages.  Saves
a stacktrace on every expires_next update, and makes that stack-trace
available in SysRq-Q (or /proc/timer_list) output.

( make sure to run this on a lockdep-enabled kernel, so that
  CONFIG_STACKTRACE=y. )

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c    |    2 +
 include/linux/hrtimer.h    |    7 ++++
 kernel/hrtimer.c           |   53 +++++++++++++++++++++++++++--------
 kernel/time/tick-oneshot.c |   13 +++++++-
 kernel/time/timer_list.c   |   23 ++++++++++++++-
 5 files changed, 84 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/apic.c~mm-only-hrtimers-debug-patch arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~mm-only-hrtimers-debug-patch
+++ a/arch/i386/kernel/apic.c
@@ -525,6 +525,8 @@ void __init setup_boot_APIC_clock(void)
 		 */
 		if (nmi_watchdog != NMI_IO_APIC)
 			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+		else
+			printk(KERN_WARNING "APIC timer registered as dummy, due to nmi_watchdog=1!\n");
 	}
 
 	/* Setup the lapic or request the broadcast */
diff -puN include/linux/hrtimer.h~mm-only-hrtimers-debug-patch include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~mm-only-hrtimers-debug-patch
+++ a/include/linux/hrtimer.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_HRTIMER_H
 #define _LINUX_HRTIMER_H
 
+#include <linux/stacktrace.h>
 #include <linux/rbtree.h>
 #include <linux/ktime.h>
 #include <linux/init.h>
@@ -196,6 +197,12 @@ struct hrtimer_cpu_base {
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
+# define HRTIMERS_STACK_TRACE_DEPTH	32
+# ifdef CONFIG_STACKTRACE
+	struct stack_trace		exp_trace;
+	unsigned long			exp_entries[HRTIMERS_STACK_TRACE_DEPTH];
+# endif
+	ktime_t				exp_prev;
 	int				hres_active;
 	struct list_head		cb_pending;
 	unsigned long			nr_events;
diff -puN kernel/hrtimer.c~mm-only-hrtimers-debug-patch kernel/hrtimer.c
--- a/kernel/hrtimer.c~mm-only-hrtimers-debug-patch
+++ a/kernel/hrtimer.c
@@ -305,6 +305,26 @@ unsigned long ktime_divns(const ktime_t 
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
+static void update_cpu_base_expires_next(struct hrtimer_cpu_base *cpu_base,
+					 ktime_t expires_next)
+{
+	cpu_base->exp_prev = cpu_base->expires_next;
+	cpu_base->expires_next = expires_next;
+
+#ifdef CONFIG_STACKTRACE
+	{
+		struct stack_trace *trace = &cpu_base->exp_trace;
+
+		trace->nr_entries = 0;
+		trace->entries = cpu_base->exp_entries;
+		trace->max_entries = HRTIMERS_STACK_TRACE_DEPTH;
+		trace->skip = 1;
+
+		save_stack_trace(trace);
+	}
+#endif
+}
+
 /*
  * High resolution timer enabled ?
  */
@@ -353,7 +373,7 @@ static void hrtimer_force_reprogram(stru
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t expires;
 
-	cpu_base->expires_next.tv64 = KTIME_MAX;
+	update_cpu_base_expires_next(cpu_base, (ktime_t){ .tv64 = KTIME_MAX });
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
@@ -363,7 +383,7 @@ static void hrtimer_force_reprogram(stru
 		timer = rb_entry(base->first, struct hrtimer, node);
 		expires = ktime_sub(timer->expires, base->offset);
 		if (expires.tv64 < cpu_base->expires_next.tv64)
-			cpu_base->expires_next = expires;
+			update_cpu_base_expires_next(cpu_base, expires);
 	}
 
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
@@ -382,7 +402,7 @@ static void hrtimer_force_reprogram(stru
 static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
-	ktime_t *expires_next = &__get_cpu_var(hrtimer_bases).expires_next;
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires = ktime_sub(timer->expires, base->offset);
 	int res;
 
@@ -396,7 +416,7 @@ static int hrtimer_reprogram(struct hrti
 	if (hrtimer_callback_running(timer))
 		return 0;
 
-	if (expires.tv64 >= expires_next->tv64)
+	if (expires.tv64 >= cpu_base->expires_next.tv64)
 		return 0;
 
 	/*
@@ -404,7 +424,7 @@ static int hrtimer_reprogram(struct hrti
 	 */
 	res = tick_program_event(expires, 0);
 	if (!IS_ERR_VALUE(res))
-		*expires_next = expires;
+		update_cpu_base_expires_next(cpu_base, expires);
 	return res;
 }
 
@@ -479,7 +499,7 @@ static inline void hrtimer_remove_cb_pen
  */
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 {
-	base->expires_next.tv64 = KTIME_MAX;
+	update_cpu_base_expires_next(base, (ktime_t){ .tv64 = KTIME_MAX });
 	base->hres_active = 0;
 	INIT_LIST_HEAD(&base->cb_pending);
 }
@@ -543,7 +563,8 @@ static inline int hrtimer_enqueue_reprog
  */
 static int hrtimer_switch_to_hres(void)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	int cpu = smp_processor_id();
+	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
 	if (base->hres_active)
@@ -553,6 +574,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
+		printk(KERN_WARNING "Could not switch to high resolution "
+				    "mode on CPU %d\n", cpu);
 		return 0;
 	}
 	base->hres_active = 1;
@@ -667,6 +690,7 @@ static void enqueue_hrtimer(struct hrtim
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
 	struct hrtimer *entry;
+	int leftmost = 1;
 
 	/*
 	 * Find the right place in the rbtree:
@@ -678,18 +702,19 @@ static void enqueue_hrtimer(struct hrtim
 		 * We dont care about collisions. Nodes with
 		 * the same expiry time stay together.
 		 */
-		if (timer->expires.tv64 < entry->expires.tv64)
+		if (timer->expires.tv64 < entry->expires.tv64) {
 			link = &(*link)->rb_left;
-		else
+		} else {
 			link = &(*link)->rb_right;
+			leftmost = 0;
+		}
 	}
 
 	/*
 	 * Insert the timer to the rbtree and check whether it
 	 * replaces the first pending timer
 	 */
-	if (!base->first || timer->expires.tv64 <
-	    rb_entry(base->first, struct hrtimer, node)->expires.tv64) {
+	if (leftmost) {
 		/*
 		 * Reprogram the clock event device. When the timer is already
 		 * expired hrtimer_enqueue_reprogram has either called the
@@ -706,6 +731,9 @@ static void enqueue_hrtimer(struct hrtim
 
 	rb_link_node(&timer->node, parent, link);
 	rb_insert_color(&timer->node, &base->active);
+
+	WARN_ON(base->first != rb_first(&base->active));
+
 	/*
 	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
 	 * state of a possibly running callback.
@@ -742,6 +770,7 @@ static void __remove_hrtimer(struct hrti
 				hrtimer_force_reprogram(base->cpu_base);
 		}
 		rb_erase(&timer->node, &base->active);
+		WARN_ON(base->first != rb_first(&base->active));
 	}
 	timer->state = newstate;
 }
@@ -1058,7 +1087,7 @@ void hrtimer_interrupt(struct clock_even
 		base++;
 	}
 
-	cpu_base->expires_next = expires_next;
+	update_cpu_base_expires_next(cpu_base, expires_next);
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
diff -puN kernel/time/tick-oneshot.c~mm-only-hrtimers-debug-patch kernel/time/tick-oneshot.c
--- a/kernel/time/tick-oneshot.c~mm-only-hrtimers-debug-patch
+++ a/kernel/time/tick-oneshot.c
@@ -73,8 +73,19 @@ int tick_switch_to_oneshot(void (*handle
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
-	    !tick_device_is_functional(dev))
+		    !tick_device_is_functional(dev)) {
+
+		printk("could not switch to one-shot clockevents mode.\n");
+		if (!dev) {
+			printk("because no tick device\n");
+		} else {
+			if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+				printk("because %s does not support one-shot mode.\n", dev->name);
+			if (!tick_device_is_functional(dev))
+				printk("because %s is not functional.\n", dev->name);
+		}
 		return -EINVAL;
+	}
 
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;
diff -puN kernel/time/timer_list.c~mm-only-hrtimers-debug-patch kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~mm-only-hrtimers-debug-patch
+++ a/kernel/time/timer_list.c
@@ -46,7 +46,7 @@ static void print_name_offset(struct seq
 
 	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
 	if (sym_name)
-		SEQ_printf(m, "%s", sym_name);
+		SEQ_printf(m, "%s+%lx/%lx", sym_name, offset, size);
 	else
 		SEQ_printf(m, "<%p>", sym);
 }
@@ -129,6 +129,25 @@ print_base(struct seq_file *m, struct hr
 	print_active_timers(m, base, now);
 }
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+static void print_cpu_base_stack_trace(struct seq_file *m,
+				       struct hrtimer_cpu_base *cpu_base)
+{
+#ifdef CONFIG_STACKTRACE
+	struct stack_trace *trace = &cpu_base->exp_trace;
+	int i;
+
+	SEQ_printf(m, " last expires_next stacktrace:\n");
+	for (i = 0; i < trace->nr_entries; i++) {
+		SEQ_printf(m, "  ");
+		print_name_offset(m, (void *)trace->entries[i]);
+		SEQ_printf(m, "\n");
+	}
+	SEQ_printf(m, "\n");
+#endif
+}
+#endif
+
 static void print_cpu(struct seq_file *m, int cpu, u64 now)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
@@ -147,6 +166,8 @@ static void print_cpu(struct seq_file *m
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 	P_ns(expires_next);
+	P_ns(exp_prev);
+	print_cpu_base_stack_trace(m, cpu_base);
 	P(hres_active);
 	P(nr_events);
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-work-around-null-skb-dereference-crash.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
mm-only-hrtimers-debug-patch.patch
