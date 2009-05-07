From: akpm@linux-foundation.org
Subject: + do_wait-simplify-retval-tsk_result-notask_error-mess.patch added to -mm tree
Date: Thu, 07 May 2009 13:17:47 -0700
Message-ID: <200905072017.n47KHm4M026855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbZEGUWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 16:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@elte.hu, roland@redhat.com


The patch titled
     do_wait: simplify retval/tsk_result/notask_error mess
has been added to the -mm tree.  Its filename is
     do_wait-simplify-retval-tsk_result-notask_error-mess.patch

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
Subject: do_wait: simplify retval/tsk_result/notask_error mess
From: Oleg Nesterov <oleg@redhat.com>

Now that we don't pass &retval down to other helpers we can simplify
the code more.

- kill tsk_result, just use retval

- add the "notask" label right after the main loop, and
  s/got end/goto notask/ after the fastpath pid check.

  This way we don't need to initialize retval before this
  check and the code becomes a bit more clean, if this pid
  has no attached tasks we should just skip the list search.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN kernel/exit.c~do_wait-simplify-retval-tsk_result-notask_error-mess kernel/exit.c
--- a/kernel/exit.c~do_wait-simplify-retval-tsk_result-notask_error-mess
+++ a/kernel/exit.c
@@ -1582,27 +1582,22 @@ repeat:
 	 * might later match our criteria, even if we are not able to reap
 	 * it yet.
 	 */
-	retval = wo->notask_error = -ECHILD;
+	wo->notask_error = -ECHILD;
 	if ((wo->wo_type < PIDTYPE_MAX) &&
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
-		goto end;
+		goto notask;
 
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		int tsk_result = do_wait_thread(wo, tsk);
-
-		if (!tsk_result)
-			tsk_result = ptrace_do_wait(wo, tsk);
+		retval = do_wait_thread(wo, tsk);
+		if (retval)
+			goto end;
 
-		if (tsk_result) {
-			/*
-			 * tasklist_lock is unlocked and we have a final result.
-			 */
-			retval = tsk_result;
+		retval = ptrace_do_wait(wo, tsk);
+		if (retval)
 			goto end;
-		}
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
@@ -1611,6 +1606,7 @@ repeat:
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
+notask:
 	retval = wo->notask_error;
 	if (!retval && !(wo->wo_flags & WNOHANG)) {
 		retval = -ERESTARTSYS;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
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
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch
introduce-struct-wait_opts-to-simplify-do_wait-pathes.patch
do_wait-simplify-retval-tsk_result-notask_error-mess.patch
do_wait-kill-the-old-bug_on-use-while_each_thread.patch
do_wait-fix-the-theoretical-race-with-stop-trace-cont.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch

