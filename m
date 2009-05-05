From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch added to -mm tree
Date: Tue, 05 May 2009 16:11:17 -0700
Message-ID: <200905052311.n45NBHIU017889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbZEEXOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 19:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, chrisw@sous-sol.org, roland@redhat.com


The patch titled
     ptrace: cleanup check/set of PT_PTRACED during attach
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch

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
Subject: ptrace: cleanup check/set of PT_PTRACED during attach
From: Oleg Nesterov <oleg@redhat.com>

ptrace_attach() and ptrace_traceme() are the last functions which look as
if the untraced task can have task->ptrace != 0, this must not be
possible.  Change the code to just check ->ptrace != 0 and s/|=/=/ to set
PT_PTRACED.

Also, a couple of trivial whitespace cleanups in ptrace_attach().

And move ptrace_traceme() up near ptrace_attach() to keep them close to
each other.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |  102 +++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff -puN kernel/ptrace.c~ptrace-cleanup-check-set-of-pt_ptraced-during-attach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-cleanup-check-set-of-pt_ptraced-during-attach
+++ a/kernel/ptrace.c
@@ -186,12 +186,12 @@ int ptrace_attach(struct task_struct *ta
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
-
-	/* Protect exec's credential calculations against our interference;
+	/*
+	 * Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
 	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
-	if (retval  < 0)
+	if (retval < 0)
 		goto out;
 repeat:
 	/*
@@ -219,10 +219,10 @@ repeat:
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
 		goto bad;
-	if (task->ptrace & PT_PTRACED)
+	if (task->ptrace)
 		goto bad;
 
-	task->ptrace |= PT_PTRACED;
+	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
@@ -238,6 +238,52 @@ out:
 	return retval;
 }
 
+/**
+ * ptrace_traceme  --  helper for PTRACE_TRACEME
+ *
+ * Performs checks and sets PT_PTRACED.
+ * Should be used by all ptrace implementations for PTRACE_TRACEME.
+ */
+int ptrace_traceme(void)
+{
+	int ret = -EPERM;
+
+	/*
+	 * Are we already being traced?
+	 */
+repeat:
+	task_lock(current);
+	if (!current->ptrace) {
+		/*
+		 * See ptrace_attach() comments about the locking here.
+		 */
+		unsigned long flags;
+		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
+			task_unlock(current);
+			do {
+				cpu_relax();
+			} while (!write_can_lock(&tasklist_lock));
+			goto repeat;
+		}
+
+		ret = security_ptrace_traceme(current->parent);
+
+		/*
+		 * Check PF_EXITING to ensure ->real_parent has not passed
+		 * exit_ptrace(). Otherwise we don't report the error but
+		 * pretend ->real_parent untraces us right after return.
+		 */
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
+			current->ptrace = PT_PTRACED;
+			__ptrace_link(current, current->real_parent);
+		}
+
+		write_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	task_unlock(current);
+	return ret;
+}
+
 /*
  * Called with irqs disabled, returns true if childs should reap themselves.
  */
@@ -575,52 +621,6 @@ int ptrace_request(struct task_struct *c
 }
 
 /**
- * ptrace_traceme  --  helper for PTRACE_TRACEME
- *
- * Performs checks and sets PT_PTRACED.
- * Should be used by all ptrace implementations for PTRACE_TRACEME.
- */
-int ptrace_traceme(void)
-{
-	int ret = -EPERM;
-
-	/*
-	 * Are we already being traced?
-	 */
-repeat:
-	task_lock(current);
-	if (!(current->ptrace & PT_PTRACED)) {
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
-		ret = security_ptrace_traceme(current->parent);
-
-		/*
-		 * Check PF_EXITING to ensure ->real_parent has not passed
-		 * exit_ptrace(). Otherwise we don't report the error but
-		 * pretend ->real_parent untraces us right after return.
-		 */
-		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
-			current->ptrace |= PT_PTRACED;
-			__ptrace_link(current, current->real_parent);
-		}
-
-		write_unlock_irqrestore(&tasklist_lock, flags);
-	}
-	task_unlock(current);
-	return ret;
-}
-
-/**
  * ptrace_get_task_struct  --  grab a task struct reference for ptrace
  * @pid:       process id to grab a task_struct reference of
  *
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

