From: akpm@linux-foundation.org
Subject: + sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch added to -mm tree
Date: Wed, 07 Jul 2010 12:38:26 -0700
Message-ID: <201007071938.o67JcQnv023011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374Ab0GGTjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 15:39:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org, jmorris@namei.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     sched: make sched_param argument static variables in some sched_setscheduler() caller
has been added to the -mm tree.  Its filename is
     sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: make sched_param argument static variables in some sched_setscheduler() caller
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Andrew Morton pointed out almost sched_setscheduler() caller are using
fixed parameter and it can be converted static.  it reduce runtume memory
waste a bit.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h         |    5 +++--
 kernel/irq/manage.c           |    4 +++-
 kernel/kthread.c              |    2 +-
 kernel/sched.c                |    6 +++---
 kernel/softirq.c              |    4 +++-
 kernel/stop_machine.c         |    2 +-
 kernel/trace/trace_selftest.c |    2 +-
 kernel/watchdog.c             |    2 +-
 kernel/workqueue.c            |    2 +-
 9 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller include/linux/sched.h
--- a/include/linux/sched.h~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/include/linux/sched.h
@@ -1922,9 +1922,10 @@ extern int task_nice(const struct task_s
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
-extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
+extern int sched_setscheduler(struct task_struct *, int,
+			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
-				      struct sched_param *);
+				      const struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff -puN kernel/irq/manage.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/irq/manage.c
--- a/kernel/irq/manage.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/irq/manage.c
@@ -572,7 +572,9 @@ irq_thread_check_affinity(struct irq_des
  */
 static int irq_thread(void *data)
 {
-	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
+	static struct sched_param param = {
+		.sched_priority = MAX_USER_RT_PRIO/2,
+	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	int wake, oneshot = desc->status & IRQ_ONESHOT;
diff -puN kernel/kthread.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/kthread.c
--- a/kernel/kthread.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/kthread.c
@@ -131,7 +131,7 @@ struct task_struct *kthread_create(int (
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
-		struct sched_param param = { .sched_priority = 0 };
+		static struct sched_param param = { .sched_priority = 0 };
 		va_list args;
 
 		va_start(args, namefmt);
diff -puN kernel/sched.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/sched.c
--- a/kernel/sched.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/sched.c
@@ -4570,7 +4570,7 @@ static bool check_same_owner(struct task
 }
 
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				struct sched_param *param, bool user)
+				const struct sched_param *param, bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
@@ -4716,7 +4716,7 @@ recheck:
  * NOTE that the task may be already dead.
  */
 int sched_setscheduler(struct task_struct *p, int policy,
-		       struct sched_param *param)
+		       const struct sched_param *param)
 {
 	return __sched_setscheduler(p, policy, param, true);
 }
@@ -4734,7 +4734,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
  * but our caller might not have that capability.
  */
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
-			       struct sched_param *param)
+			       const struct sched_param *param)
 {
 	return __sched_setscheduler(p, policy, param, false);
 }
diff -puN kernel/softirq.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/softirq.c
--- a/kernel/softirq.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/softirq.c
@@ -827,7 +827,9 @@ static int __cpuinit cpu_callback(struct
 			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+		static struct sched_param param = {
+			.sched_priority = MAX_RT_PRIO-1
+		};
 
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
diff -puN kernel/stop_machine.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/stop_machine.c
--- a/kernel/stop_machine.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/stop_machine.c
@@ -291,7 +291,7 @@ repeat:
 static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 					   unsigned long action, void *hcpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	static struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
 	struct task_struct *p;
diff -puN kernel/trace/trace_selftest.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/trace/trace_selftest.c
--- a/kernel/trace/trace_selftest.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/trace/trace_selftest.c
@@ -560,7 +560,7 @@ trace_selftest_startup_nop(struct tracer
 static int trace_wakeup_test_thread(void *data)
 {
 	/* Make this a RT thread, doesn't need to be too high */
-	struct sched_param param = { .sched_priority = 5 };
+	static struct sched_param param = { .sched_priority = 5 };
 	struct completion *x = data;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
diff -puN kernel/watchdog.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/watchdog.c
--- a/kernel/watchdog.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/watchdog.c
@@ -310,7 +310,7 @@ static enum hrtimer_restart watchdog_tim
  */
 static int watchdog(void *unused)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
diff -puN kernel/workqueue.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller kernel/workqueue.c
--- a/kernel/workqueue.c~sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller
+++ a/kernel/workqueue.c
@@ -962,7 +962,7 @@ init_cpu_workqueue(struct workqueue_stru
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct workqueue_struct *wq = cwq->wq;
 	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

acpi-fix-unused-function-warning.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
mm-use-memdup_user.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
vmscan-recalculate-lru_pages-on-each-priority.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch
mm-set-vm_fault_write-in-do_swap_page.patch
reiser4.patch

