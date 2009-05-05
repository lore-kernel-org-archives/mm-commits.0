From: akpm@linux-foundation.org
Subject: + ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch added to -mm tree
Date: Tue, 05 May 2009 16:11:15 -0700
Message-ID: <200905052311.n45NBFDI017884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbZEEXOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 19:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, chrisw@sous-sol.org, roland@redhat.com


The patch titled
     ptrace: ptrace_attach: check PF_KTHREAD + exit_state instead of ->mm
has been added to the -mm tree.  Its filename is
     ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch

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
Subject: ptrace: ptrace_attach: check PF_KTHREAD + exit_state instead of ->mm
From: Oleg Nesterov <oleg@redhat.com>

- Add PF_KTHREAD check to prevent attaching to the kernel thread
  with a borrowed ->mm.

  With or without this change we can race with daemonize() which
  can set PF_KTHREAD or clear ->mm after ptrace_attach() does the
  check, but this doesn't matter because reparent_to_kthreadd()
  does ptrace_unlink().

- Kill "!task->mm" check. We don't really care about ->mm != NULL,
  and the task can call exit_mm() right after we drop task_lock().
  What we need is to make sure we can't attach after exit_notify(),
  check task->exit_state != 0 instead.

Also, move the "already traced" check down for cosmetic reasons.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN kernel/ptrace.c~ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm
+++ a/kernel/ptrace.c
@@ -182,6 +182,8 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
+	if (unlikely(task->flags & PF_KTHREAD))
+		goto out;
 	if (same_thread_group(task, current))
 		goto out;
 
@@ -191,8 +193,6 @@ int ptrace_attach(struct task_struct *ta
 	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval  < 0)
 		goto out;
-
-	retval = -EPERM;
 repeat:
 	/*
 	 * Nasty, nasty.
@@ -212,23 +212,24 @@ repeat:
 		goto repeat;
 	}
 
-	if (!task->mm)
-		goto bad;
-	/* the same process cannot be attached many times */
-	if (task->ptrace & PT_PTRACED)
-		goto bad;
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
 	if (retval)
 		goto bad;
 
-	/* Go */
+	retval = -EPERM;
+	if (unlikely(task->exit_state))
+		goto bad;
+	if (task->ptrace & PT_PTRACED)
+		goto bad;
+
 	task->ptrace |= PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
-
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+
+	retval = 0;
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
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

