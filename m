From: akpm@linux-foundation.org
Subject: + ptrace-do-not-use-task_lock-for-attach.patch added to -mm tree
Date: Tue, 05 May 2009 16:11:19 -0700
Message-ID: <200905052311.n45NBKm1017970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996AbZEEXOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 19:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, chrisw@sous-sol.org, roland@redhat.com


The patch titled
     ptrace: do not use task_lock() for attach
has been added to the -mm tree.  Its filename is
     ptrace-do-not-use-task_lock-for-attach.patch

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
Subject: ptrace: do not use task_lock() for attach
From: Oleg Nesterov <oleg@redhat.com>

Remove the "Nasty, nasty" lock dance in ptrace_attach()/ptrace_traceme() -
from now task_lock() has nothing to do with ptrace at all.

With the recent changes nobody uses task_lock() to serialize with ptrace,
but in fact it was never needed and it was never used consistently.

However ptrace_attach() calls __ptrace_may_access() and needs task_lock()
to pin task->mm for get_dumpable().  But we can call __ptrace_may_access()
before we take tasklist_lock, ->cred_exec_mutex protects us against
do_execve() path which can change creds and MMF_DUMP* flags.

(ugly, but we can't use ptrace_may_access() because it hides the error
code, so we have to take task_lock() and use __ptrace_may_access()).

NOTE: this change assumes that LSM hooks, security_ptrace_may_access() and
security_ptrace_traceme(), can be called without task_lock() held.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   59 ++++++++++------------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

diff -puN kernel/ptrace.c~ptrace-do-not-use-task_lock-for-attach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-do-not-use-task_lock-for-attach
+++ a/kernel/ptrace.c
@@ -177,7 +177,6 @@ bool ptrace_may_access(struct task_struc
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
-	unsigned long flags;
 
 	audit_ptrace(task);
 
@@ -193,34 +192,19 @@ int ptrace_attach(struct task_struct *ta
 	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval < 0)
 		goto out;
-repeat:
-	/*
-	 * Nasty, nasty.
-	 *
-	 * We want to hold both the task-lock and the
-	 * tasklist_lock for writing at the same time.
-	 * But that's against the rules (tasklist_lock
-	 * is taken for reading by interrupts on other
-	 * cpu's that may have task_lock).
-	 */
-	task_lock(task);
-	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-		task_unlock(task);
-		do {
-			cpu_relax();
-		} while (!write_can_lock(&tasklist_lock));
-		goto repeat;
-	}
 
+	task_lock(task);
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	task_unlock(task);
 	if (retval)
-		goto bad;
+		goto unlock_creds;
 
+	write_lock_irq(&tasklist_lock);
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
-		goto bad;
+		goto unlock_tasklist;
 	if (task->ptrace)
-		goto bad;
+		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
@@ -230,9 +214,9 @@ repeat:
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
 	retval = 0;
-bad:
-	write_unlock_irqrestore(&tasklist_lock, flags);
-	task_unlock(task);
+unlock_tasklist:
+	write_unlock_irq(&tasklist_lock);
+unlock_creds:
 	mutex_unlock(&task->cred_exec_mutex);
 out:
 	return retval;
@@ -248,26 +232,10 @@ int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
-	/*
-	 * Are we already being traced?
-	 */
-repeat:
-	task_lock(current);
+	write_lock_irq(&tasklist_lock);
+	/* Are we already being traced? */
 	if (!current->ptrace) {
-		/*
-		 * See ptrace_attach() comments about the locking here.
-		 */
-		unsigned long flags;
-		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-			task_unlock(current);
-			do {
-				cpu_relax();
-			} while (!write_can_lock(&tasklist_lock));
-			goto repeat;
-		}
-
 		ret = security_ptrace_traceme(current->parent);
-
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
 		 * exit_ptrace(). Otherwise we don't report the error but
@@ -277,10 +245,9 @@ repeat:
 			current->ptrace = PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}
-
-		write_unlock_irqrestore(&tasklist_lock, flags);
 	}
-	task_unlock(current);
+	write_unlock_irq(&tasklist_lock);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
rcu_sched_grace_period-kill-the-bogus-flush_signals.patch
drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch
utrace-core-kill-exclude_xtrace-logic.patch

