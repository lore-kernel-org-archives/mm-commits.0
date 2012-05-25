From: akpm@linux-foundation.org
Subject: [merged] task_work_add-generic-process-context-callbacks.patch removed from -mm tree
Date: Fri, 25 May 2012 13:48:30 -0700
Message-ID: <20120525204830.B062FA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40652 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2EYUsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:48:33 -0400
Received: by were53 with SMTP id e53so70551wer.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:48:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, agordeev@redhat.com, chris@zankel.net, dhowells@redhat.com, dsmith@redhat.com, fche@redhat.com, geert@linux-m68k.org, lwoodman@redhat.com, mingo@elte.hu, peterz@infradead.org, rkuo@codeaurora.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: task_work_add: generic process-context callbacks
has been removed from the -mm tree.  Its filename was
     task_work_add-generic-process-context-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: task_work_add: generic process-context callbacks

Provide a simple mechanism that allows running code in the (nonatomic)
context of the arbitrary task.

The caller does task_work_add(task, task_work) and this task executes
task_work->func() either from do_notify_resume() or from do_exit().  The
callback can rely on PF_EXITING to detect the latter case.

"struct task_work" can be embedded in another struct, still it has "void
*data" to handle the most common/simple case.

This allows us to kill the ->replacement_session_keyring hack, and
potentially this can have more users.

Performance-wise, this adds 2 "unlikely(!hlist_empty())" checks into
tracehook_notify_resume() and do_exit().  But at the same time we can
remove the "replacement_session_keyring != NULL" checks from
arch/*/signal.c and exit_creds().

Note: task_work_add/task_work_run abuses ->pi_lock.  This is only because
this lock is already used by lookup_pi_state() to synchronize with
do_exit() setting PF_EXITING.  Fortunately the scope of this lock in
task_work.c is really tiny, and the code is unlikely anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Smith <dsmith@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h     |    2 
 include/linux/task_work.h |   33 ++++++++++++++
 include/linux/tracehook.h |   13 ++++-
 kernel/Makefile           |    2 
 kernel/exit.c             |    5 +-
 kernel/fork.c             |    2 
 kernel/task_work.c        |   84 ++++++++++++++++++++++++++++++++++++
 7 files changed, 137 insertions(+), 4 deletions(-)

diff -puN include/linux/sched.h~task_work_add-generic-process-context-callbacks include/linux/sched.h
--- a/include/linux/sched.h~task_work_add-generic-process-context-callbacks
+++ a/include/linux/sched.h
@@ -1415,6 +1415,8 @@ struct task_struct {
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
+	struct hlist_head task_works;
+
 	struct audit_context *audit_context;
 #ifdef CONFIG_AUDITSYSCALL
 	uid_t loginuid;
diff -puN /dev/null include/linux/task_work.h
--- /dev/null
+++ a/include/linux/task_work.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_TASK_WORK_H
+#define _LINUX_TASK_WORK_H
+
+#include <linux/list.h>
+#include <linux/sched.h>
+
+struct task_work;
+typedef void (*task_work_func_t)(struct task_work *);
+
+struct task_work {
+	struct hlist_node hlist;
+	task_work_func_t func;
+	void *data;
+};
+
+static inline void
+init_task_work(struct task_work *twork, task_work_func_t func, void *data)
+{
+	twork->func = func;
+	twork->data = data;
+}
+
+int task_work_add(struct task_struct *task, struct task_work *twork, bool);
+struct task_work *task_work_cancel(struct task_struct *, task_work_func_t);
+void task_work_run(void);
+
+static inline void exit_task_work(struct task_struct *task)
+{
+	if (unlikely(!hlist_empty(&task->task_works)))
+		task_work_run();
+}
+
+#endif	/* _LINUX_TASK_WORK_H */
diff -puN include/linux/tracehook.h~task_work_add-generic-process-context-callbacks include/linux/tracehook.h
--- a/include/linux/tracehook.h~task_work_add-generic-process-context-callbacks
+++ a/include/linux/tracehook.h
@@ -49,6 +49,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
+#include <linux/task_work.h>
 struct linux_binprm;
 
 /*
@@ -153,7 +154,6 @@ static inline void tracehook_signal_hand
 		ptrace_notify(SIGTRAP);
 }
 
-#ifdef TIF_NOTIFY_RESUME
 /**
  * set_notify_resume - cause tracehook_notify_resume() to be called
  * @task:		task that will call tracehook_notify_resume()
@@ -165,8 +165,10 @@ static inline void tracehook_signal_hand
  */
 static inline void set_notify_resume(struct task_struct *task)
 {
+#ifdef TIF_NOTIFY_RESUME
 	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
 		kick_process(task);
+#endif
 }
 
 /**
@@ -184,7 +186,14 @@ static inline void set_notify_resume(str
  */
 static inline void tracehook_notify_resume(struct pt_regs *regs)
 {
+	/*
+	 * The caller just cleared TIF_NOTIFY_RESUME. This barrier
+	 * pairs with task_work_add()->set_notify_resume() after
+	 * hlist_add_head(task->task_works);
+	 */
+	smp_mb__after_clear_bit();
+	if (unlikely(!hlist_empty(&current->task_works)))
+		task_work_run();
 }
-#endif	/* TIF_NOTIFY_RESUME */
 
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/Makefile~task_work_add-generic-process-context-callbacks kernel/Makefile
--- a/kernel/Makefile~task_work_add-generic-process-context-callbacks
+++ a/kernel/Makefile
@@ -5,7 +5,7 @@
 obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
-	    signal.o sys.o kmod.o workqueue.o pid.o \
+	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
diff -puN kernel/exit.c~task_work_add-generic-process-context-callbacks kernel/exit.c
--- a/kernel/exit.c~task_work_add-generic-process-context-callbacks
+++ a/kernel/exit.c
@@ -946,11 +946,14 @@ void do_exit(long code)
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
+	 * an exiting task cleaning up the robust pi futexes, and in
+	 * task_work_add() to avoid the race with exit_task_work().
 	 */
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
+	exit_task_work(tsk);
+
 	exit_irq_thread();
 
 	if (unlikely(in_atomic()))
diff -puN kernel/fork.c~task_work_add-generic-process-context-callbacks kernel/fork.c
--- a/kernel/fork.c~task_work_add-generic-process-context-callbacks
+++ a/kernel/fork.c
@@ -1420,6 +1420,8 @@ static struct task_struct *copy_process(
 	 */
 	p->group_leader = p;
 
+	INIT_HLIST_HEAD(&p->task_works);
+
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
diff -puN /dev/null kernel/task_work.c
--- /dev/null
+++ a/kernel/task_work.c
@@ -0,0 +1,84 @@
+#include <linux/spinlock.h>
+#include <linux/task_work.h>
+#include <linux/tracehook.h>
+
+int
+task_work_add(struct task_struct *task, struct task_work *twork, bool notify)
+{
+	unsigned long flags;
+	int err = -ESRCH;
+
+#ifndef TIF_NOTIFY_RESUME
+	if (notify)
+		return -ENOTSUPP;
+#endif
+	/*
+	 * We must not insert the new work if the task has already passed
+	 * exit_task_work(). We rely on do_exit()->raw_spin_unlock_wait()
+	 * and check PF_EXITING under pi_lock.
+	 */
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	if (likely(!(task->flags & PF_EXITING))) {
+		hlist_add_head(&twork->hlist, &task->task_works);
+		err = 0;
+	}
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
+	if (likely(!err) && notify)
+		set_notify_resume(task);
+	return err;
+}
+
+struct task_work *
+task_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	unsigned long flags;
+	struct task_work *twork;
+	struct hlist_node *pos;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	hlist_for_each_entry(twork, pos, &task->task_works, hlist) {
+		if (twork->func == func) {
+			hlist_del(&twork->hlist);
+			goto found;
+		}
+	}
+	twork = NULL;
+ found:
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	return twork;
+}
+
+void task_work_run(void)
+{
+	struct task_struct *task = current;
+	struct hlist_head task_works;
+	struct hlist_node *pos;
+
+	raw_spin_lock_irq(&task->pi_lock);
+	hlist_move_list(&task->task_works, &task_works);
+	raw_spin_unlock_irq(&task->pi_lock);
+
+	if (unlikely(hlist_empty(&task_works)))
+		return;
+	/*
+	 * We use hlist to save the space in task_struct, but we want fifo.
+	 * Find the last entry, the list should be short, then process them
+	 * in reverse order.
+	 */
+	for (pos = task_works.first; pos->next; pos = pos->next)
+		;
+
+	for (;;) {
+		struct hlist_node **pprev = pos->pprev;
+		struct task_work *twork = container_of(pos, struct task_work,
+							hlist);
+		twork->func(twork);
+
+		if (pprev == &task_works.first)
+			break;
+		pos = container_of(pprev, struct hlist_node, next);
+	}
+}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

