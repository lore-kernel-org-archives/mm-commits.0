From: akpm@linux-foundation.org
Subject: + ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch added to -mm tree
Date: Thu, 28 May 2009 01:44:17 -0700
Message-ID: <200905280844.n4S8iHrX002444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbZE1Iob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 04:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: don't take tasklist to get/set ->last_siginfo
has been added to the -mm tree.  Its filename is
     ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch

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
Subject: ptrace: don't take tasklist to get/set ->last_siginfo
From: Oleg Nesterov <oleg@redhat.com>

Change ptrace_getsiginfo/ptrace_setsiginfo to use lock_task_sighand()
without tasklist_lock.  Perhaps it makes sense to make a single helper
with "bool rw" argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/ptrace.c~ptrace-dont-take-tasklist-to-get-set-last_siginfo kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-dont-take-tasklist-to-get-set-last_siginfo
+++ a/kernel/ptrace.c
@@ -422,37 +422,33 @@ static int ptrace_setoptions(struct task
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
 {
+	unsigned long flags;
 	int error = -ESRCH;
 
-	read_lock(&tasklist_lock);
-	if (likely(child->sighand != NULL)) {
+	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
 			*info = *child->last_siginfo;
 			error = 0;
 		}
-		spin_unlock_irq(&child->sighand->siglock);
+		unlock_task_sighand(child, &flags);
 	}
-	read_unlock(&tasklist_lock);
 	return error;
 }
 
 static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 {
+	unsigned long flags;
 	int error = -ESRCH;
 
-	read_lock(&tasklist_lock);
-	if (likely(child->sighand != NULL)) {
+	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		spin_lock_irq(&child->sighand->siglock);
 		if (likely(child->last_siginfo != NULL)) {
 			*child->last_siginfo = *info;
 			error = 0;
 		}
-		spin_unlock_irq(&child->sighand->siglock);
+		unlock_task_sighand(child, &flags);
 	}
-	read_unlock(&tasklist_lock);
 	return error;
 }
 
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
ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage.patch
ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch
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
pids-clean-up-find_task_by_pid-variants.patch

