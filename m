From: akpm@osdl.org
Subject: - sleep-profiling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:28 -0800
Message-ID: <200612072304.kB7N4SAZ030054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163745AbWLGXEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sleep profiling
has been removed from the -mm tree.  Its filename was
     sleep-profiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sleep profiling
From: Ingo Molnar <mingo@elte.hu>

Implement prof=sleep profiling.  TASK_UNINTERRUPTIBLE sleeps will be taken
as a profile hit, and every millisecond spent sleeping causes a profile-hit
for the call site that initiated the sleep.

Sample readprofile output on i386:

   306 ps2_sendbyte                               1.3973
   432 call_usermodehelper_keys                   1.9548
   484 ps2_command                                0.6453
   790 __driver_attach                            4.7879
  1593 msleep                                    44.2500
  3976 sync_buffer                               64.1290
  4076 do_lookup                                 12.4648
  8587 sync_page                                122.6714
 20820 total                                      0.0067

(NOTE: architectures need to check whether get_wchan() can be called from
deep within the wakeup path.)

akpm: we need to mark more functions __sched.  lock_sock(), msleep(), others..

akpm: the contention in do_lookup() is a surprise.  Presumably doing disk
reads for directory contents while holding i_mutex.

[akpm@osdl.org: various fixes]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    1 
 include/linux/profile.h             |   24 +++++++++++++++-
 kernel/profile.c                    |   39 ++++++++++++++++++++------
 kernel/sched.c                      |   11 +++++++
 4 files changed, 65 insertions(+), 10 deletions(-)

diff -puN Documentation/kernel-parameters.txt~sleep-profiling Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~sleep-profiling
+++ a/Documentation/kernel-parameters.txt
@@ -1294,6 +1294,7 @@ and is between 256 and 4096 characters. 
 			Param: "schedule" - profile schedule points.
 			Param: <number> - step/bucket size as a power of 2 for
 				statistical time based profiling.
+			Param: "sleep" - profile D-state sleeping (millisecs)
 
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
diff -puN include/linux/profile.h~sleep-profiling include/linux/profile.h
--- a/include/linux/profile.h~sleep-profiling
+++ a/include/linux/profile.h
@@ -6,10 +6,15 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/cpumask.h>
+#include <linux/cache.h>
+
 #include <asm/errno.h>
 
+extern int prof_on __read_mostly;
+
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
+#define SLEEP_PROFILING	3
 
 struct proc_dir_entry;
 struct pt_regs;
@@ -18,7 +23,24 @@ struct notifier_block;
 /* init basic kernel profiler */
 void __init profile_init(void);
 void profile_tick(int);
-void profile_hit(int, void *);
+
+/*
+ * Add multiple profiler hits to a given address:
+ */
+void profile_hits(int, void *ip, unsigned int nr_hits);
+
+/*
+ * Single profiler hit:
+ */
+static inline void profile_hit(int type, void *ip)
+{
+	/*
+	 * Speedup for the common (no profiling enabled) case:
+	 */
+	if (unlikely(prof_on == type))
+		profile_hits(type, ip, 1);
+}
+
 #ifdef CONFIG_PROC_FS
 void create_prof_cpu_mask(struct proc_dir_entry *);
 #else
diff -puN kernel/profile.c~sleep-profiling kernel/profile.c
--- a/kernel/profile.c~sleep-profiling
+++ a/kernel/profile.c
@@ -40,7 +40,7 @@ int (*timer_hook)(struct pt_regs *) __re
 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
-static int prof_on __read_mostly;
+int prof_on __read_mostly;
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
@@ -51,9 +51,19 @@ static DEFINE_MUTEX(profile_flip_mutex);
 static int __init profile_setup(char * str)
 {
 	static char __initdata schedstr[] = "schedule";
+	static char __initdata sleepstr[] = "sleep";
 	int par;
 
-	if (!strncmp(str, schedstr, strlen(schedstr))) {
+	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
+		prof_on = SLEEP_PROFILING;
+		if (str[strlen(sleepstr)] == ',')
+			str += strlen(sleepstr) + 1;
+		if (get_option(&str, &par))
+			prof_shift = par;
+		printk(KERN_INFO
+			"kernel sleep profiling enabled (shift: %ld)\n",
+			prof_shift);
+	} else if (!strncmp(str, sleepstr, strlen(sleepstr))) {
 		prof_on = SCHED_PROFILING;
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
@@ -204,7 +214,8 @@ EXPORT_SYMBOL_GPL(profile_event_unregist
  * positions to which hits are accounted during short intervals (e.g.
  * several seconds) is usually very small. Exclusion from buffer
  * flipping is provided by interrupt disablement (note that for
- * SCHED_PROFILING profile_hit() may be called from process context).
+ * SCHED_PROFILING or SLEEP_PROFILING profile_hit() may be called from
+ * process context).
  * The hash function is meant to be lightweight as opposed to strong,
  * and was vaguely inspired by ppc64 firmware-supported inverted
  * pagetable hash functions, but uses a full hashtable full of finite
@@ -257,7 +268,7 @@ static void profile_discard_flip_buffers
 	mutex_unlock(&profile_flip_mutex);
 }
 
-void profile_hit(int type, void *__pc)
+void profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
 	int i, j, cpu;
@@ -274,21 +285,31 @@ void profile_hit(int type, void *__pc)
 		put_cpu();
 		return;
 	}
+	/*
+	 * We buffer the global profiler buffer into a per-CPU
+	 * queue and thus reduce the number of global (and possibly
+	 * NUMA-alien) accesses. The write-queue is self-coalescing:
+	 */
 	local_irq_save(flags);
 	do {
 		for (j = 0; j < PROFILE_GRPSZ; ++j) {
 			if (hits[i + j].pc == pc) {
-				hits[i + j].hits++;
+				hits[i + j].hits += nr_hits;
 				goto out;
 			} else if (!hits[i + j].hits) {
 				hits[i + j].pc = pc;
-				hits[i + j].hits = 1;
+				hits[i + j].hits = nr_hits;
 				goto out;
 			}
 		}
 		i = (i + secondary) & (NR_PROFILE_HIT - 1);
 	} while (i != primary);
-	atomic_inc(&prof_buffer[pc]);
+
+	/*
+	 * Add the current hit(s) and flush the write-queue out
+	 * to the global buffer:
+	 */
+	atomic_add(nr_hits, &prof_buffer[pc]);
 	for (i = 0; i < NR_PROFILE_HIT; ++i) {
 		atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
 		hits[i].pc = hits[i].hits = 0;
@@ -356,14 +377,14 @@ static int __devinit profile_cpu_callbac
 #define profile_flip_buffers()		do { } while (0)
 #define profile_discard_flip_buffers()	do { } while (0)
 
-void profile_hit(int type, void *__pc)
+void profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
 
 	if (prof_on != type || !prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
-	atomic_inc(&prof_buffer[min(pc, prof_len - 1)]);
+	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
 }
 #endif /* !CONFIG_SMP */
 
diff -puN kernel/sched.c~sleep-profiling kernel/sched.c
--- a/kernel/sched.c~sleep-profiling
+++ a/kernel/sched.c
@@ -948,6 +948,17 @@ static void activate_task(struct task_st
 	}
 #endif
 
+	/*
+	 * Sleep time is in units of nanosecs, so shift by 20 to get a
+	 * milliseconds-range estimation of the amount of time that the task
+	 * spent sleeping:
+	 */
+	if (unlikely(prof_on == SLEEP_PROFILING)) {
+		if (p->state == TASK_UNINTERRUPTIBLE)
+			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
+				     (now - p->timestamp) >> 20);
+	}
+
 	if (!rt_task(p))
 		p->prio = recalc_task_prio(p, now);
 
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

