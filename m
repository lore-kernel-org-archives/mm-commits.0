From: akpm@linux-foundation.org
Subject: + ptrace-wait_task_zombie-s-parent-real_parent.patch added to -mm tree
Date: Tue, 26 May 2009 14:13:35 -0700
Message-ID: <200905262113.n4QLDZhv009930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297AbZEZVNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: wait_task_zombie: s/->parent/->real_parent/
has been added to the -mm tree.  Its filename is
     ptrace-wait_task_zombie-s-parent-real_parent.patch

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
Subject: ptrace: wait_task_zombie: s/->parent/->real_parent/
From: Oleg Nesterov <oleg@redhat.com>

Change wait_task_zombie() to use ->real_parent instead of ->parent.  We
could even use current afaics, but ->real_parent is more clean.

We know that the child is not ptrace_reparented() and thus they are equal.
 But we should avoid using task_struct->parent, we are going to remove it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~ptrace-wait_task_zombie-s-parent-real_parent kernel/exit.c
--- a/kernel/exit.c~ptrace-wait_task_zombie-s-parent-real_parent
+++ a/kernel/exit.c
@@ -1203,7 +1203,7 @@ static int wait_task_zombie(struct task_
 		 * p->signal fields, because they are only touched by
 		 * __exit_signal, which runs with tasklist_lock
 		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to p->parent->signal fields,
+		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
@@ -1212,8 +1212,8 @@ static int wait_task_zombie(struct task_
 		 * group including the group leader.
 		 */
 		thread_group_cputime(p, &cputime);
-		spin_lock_irq(&p->parent->sighand->siglock);
-		psig = p->parent->signal;
+		spin_lock_irq(&p->real_parent->sighand->siglock);
+		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
@@ -1247,7 +1247,7 @@ static int wait_task_zombie(struct task_
 			psig->cmaxrss = maxrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		spin_unlock_irq(&p->parent->sighand->siglock);
+		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
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
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
ptrace-wait_task_zombie-s-parent-real_parent.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch
introduce-struct-wait_opts-to-simplify-do_wait-pathes.patch
do_wait-simplify-retval-tsk_result-notask_error-mess.patch
do_wait-kill-the-old-bug_on-use-while_each_thread.patch
do_wait-fix-the-theoretical-race-with-stop-trace-cont.patch
mm-exitc-reorder-wait_opts-to-remove-padding-on-64-bit-builds.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch

