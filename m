From: akpm@linux-foundation.org
Subject: + genirq-reimplement-exit_irq_thread-hook-via-task_work_add.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:50:54 -0700
Message-ID: <20120430235054.378E2A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:56523 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2D3Xu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:50:57 -0400
Received: by wibhj13 with SMTP id hj13so187199wib.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:50:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, agordeev@redhat.com, chris@zankel.net, dhowells@redhat.com, dsmith@redhat.com, fche@redhat.com, geert@linux-m68k.org, lwoodman@redhat.com, mingo@elte.hu, peterz@infradead.org, rkuo@codeaurora.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org


The patch titled
     Subject: genirq: reimplement exit_irq_thread() hook via task_work_add()
has been added to the -mm tree.  Its filename is
     genirq-reimplement-exit_irq_thread-hook-via-task_work_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: genirq: reimplement exit_irq_thread() hook via task_work_add()

exit_irq_thread() and task->irq_thread are needed to handle the unexpected
(and unlikely) exit of irq-thread.

We can use task_work instead and make this all private to
kernel/irq/manage.c, cleanup plus micro-optimization.

1. rename exit_irq_thread() to irq_thread_dtor(), make it
   static, and move it up before irq_thread().

2. change irq_thread() to do task_work_add(irq_thread_dtor)
   at the start and task_work_cancel() before return.

   tracehook_notify_resume() can never play with kthreads,
   only do_exit()->exit_task_work() can call the callback
   and this is what we want.

3. remove task_struct->irq_thread and the special hook
   in do_exit().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
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

 include/linux/interrupt.h |    4 --
 include/linux/sched.h     |   10 +----
 kernel/exit.c             |    2 -
 kernel/irq/manage.c       |   68 +++++++++++++++++-------------------
 4 files changed, 35 insertions(+), 49 deletions(-)

diff -puN include/linux/interrupt.h~genirq-reimplement-exit_irq_thread-hook-via-task_work_add include/linux/interrupt.h
--- a/include/linux/interrupt.h~genirq-reimplement-exit_irq_thread-hook-via-task_work_add
+++ a/include/linux/interrupt.h
@@ -142,8 +142,6 @@ request_any_context_irq(unsigned int irq
 extern int __must_check
 request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		   const char *devname, void __percpu *percpu_dev_id);
-
-extern void exit_irq_thread(void);
 #else
 
 extern int __must_check
@@ -177,8 +175,6 @@ request_percpu_irq(unsigned int irq, irq
 {
 	return request_irq(irq, handler, 0, devname, percpu_dev_id);
 }
-
-static inline void exit_irq_thread(void) { }
 #endif
 
 extern void free_irq(unsigned int, void *);
diff -puN include/linux/sched.h~genirq-reimplement-exit_irq_thread-hook-via-task_work_add include/linux/sched.h
--- a/include/linux/sched.h~genirq-reimplement-exit_irq_thread-hook-via-task_work_add
+++ a/include/linux/sched.h
@@ -1356,11 +1356,6 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
-#ifdef CONFIG_GENERIC_HARDIRQS
-	/* IRQ handler threads */
-	unsigned irq_thread:1;
-#endif
-
 	pid_t pid;
 	pid_t tgid;
 
@@ -1368,10 +1363,9 @@ struct task_struct {
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
 #endif
-
-	/* 
+	/*
 	 * pointers to (original) parent process, youngest child, younger sibling,
-	 * older sibling, respectively.  (p->father can be replaced with 
+	 * older sibling, respectively.  (p->father can be replaced with
 	 * p->real_parent->pid)
 	 */
 	struct task_struct __rcu *real_parent; /* real parent process */
diff -puN kernel/exit.c~genirq-reimplement-exit_irq_thread-hook-via-task_work_add kernel/exit.c
--- a/kernel/exit.c~genirq-reimplement-exit_irq_thread-hook-via-task_work_add
+++ a/kernel/exit.c
@@ -954,8 +954,6 @@ void do_exit(long code)
 
 	exit_task_work(tsk);
 
-	exit_irq_thread();
-
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
diff -puN kernel/irq/manage.c~genirq-reimplement-exit_irq_thread-hook-via-task_work_add kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-reimplement-exit_irq_thread-hook-via-task_work_add
+++ a/kernel/irq/manage.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/task_work.h>
 
 #include "internals.h"
 
@@ -773,11 +774,39 @@ static void wake_threads_waitq(struct ir
 		wake_up(&desc->wait_for_threads);
 }
 
+static void irq_thread_dtor(struct task_work *unused)
+{
+	struct task_struct *tsk = current;
+	struct irq_desc *desc;
+	struct irqaction *action;
+
+	if (WARN_ON_ONCE(!(current->flags & PF_EXITING)))
+		return;
+
+	action = kthread_data(tsk);
+
+	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
+	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
+
+
+	desc = irq_to_desc(action->irq);
+	/*
+	 * If IRQTF_RUNTHREAD is set, we need to decrement
+	 * desc->threads_active and wake possible waiters.
+	 */
+	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		wake_threads_waitq(desc);
+
+	/* Prevent a stale desc->threads_oneshot */
+	irq_finalize_oneshot(desc, action);
+}
+
 /*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
 {
+	struct task_work on_exit_work;
 	static const struct sched_param param = {
 		.sched_priority = MAX_USER_RT_PRIO/2,
 	};
@@ -793,7 +822,9 @@ static int irq_thread(void *data)
 		handler_fn = irq_thread_fn;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->irq_thread = 1;
+
+	init_task_work(&on_exit_work, irq_thread_dtor, NULL);
+	task_work_add(current, &on_exit_work, false);
 
 	while (!irq_wait_for_interrupt(action)) {
 		irqreturn_t action_ret;
@@ -815,44 +846,11 @@ static int irq_thread(void *data)
 	 * cannot touch the oneshot mask at this point anymore as
 	 * __setup_irq() might have given out currents thread_mask
 	 * again.
-	 *
-	 * Clear irq_thread. Otherwise exit_irq_thread() would make
-	 * fuzz about an active irq thread going into nirvana.
 	 */
-	current->irq_thread = 0;
+	task_work_cancel(current, irq_thread_dtor);
 	return 0;
 }
 
-/*
- * Called from do_exit()
- */
-void exit_irq_thread(void)
-{
-	struct task_struct *tsk = current;
-	struct irq_desc *desc;
-	struct irqaction *action;
-
-	if (!tsk->irq_thread)
-		return;
-
-	action = kthread_data(tsk);
-
-	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
-
-	desc = irq_to_desc(action->irq);
-
-	/*
-	 * If IRQTF_RUNTHREAD is set, we need to decrement
-	 * desc->threads_active and wake possible waiters.
-	 */
-	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
-		wake_threads_waitq(desc);
-
-	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action);
-}
-
 static void irq_setup_forced_threading(struct irqaction *new)
 {
 	if (!force_irqthreads)
_
Subject: Subject: genirq: reimplement exit_irq_thread() hook via task_work_add()

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
task_work_add-generic-process-context-callbacks.patch
genirq-reimplement-exit_irq_thread-hook-via-task_work_add.patch
hexagon-do_notify_resume-needs-tracehook_notify_resume.patch
keys-change-keyctl_session_to_parent-to-use-task_work_add.patch
keys-kill-the-dummy-key_replace_session_keyring.patch
keys-kill-task_struct-replacement_session_keyring.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
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
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

