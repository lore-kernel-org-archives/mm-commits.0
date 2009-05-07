From: akpm@linux-foundation.org
Subject: + shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch added to -mm tree
Date: Thu, 07 May 2009 13:17:43 -0700
Message-ID: <200905072017.n47KHiaX026832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762154AbZEGUTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 16:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     shift "ptrace implies WUNTRACED" from ptrace_do_wait() to wait_task_stopped()
has been added to the -mm tree.  Its filename is
     shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped.patch

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
Subject: shift "ptrace implies WUNTRACED" from ptrace_do_wait() to wait_task_stopped()
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation for the next patch.

ptrace_do_wait() adds WUNTRACED to options for wait_task_stopped() which
should always accept the stopped tracee, even if do_wait() was called
without WUNTRACED.

Change wait_task_stopped() to check "ptrace || WUNTRACED" instead.  This
makes the code more explicit, and "int options" argument becomes const in
do_wait() pathes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/exit.c~shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped kernel/exit.c
--- a/kernel/exit.c~shift-ptrace-implies-wuntraced-from-ptrace_do_wait-to-wait_task_stopped
+++ a/kernel/exit.c
@@ -1336,7 +1336,10 @@ static int wait_task_stopped(int ptrace,
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
-	if (!(options & WUNTRACED))
+	/*
+	 * Traditionally we see ptrace'd stopped tasks regardless of options.
+	 */
+	if (!ptrace && !(options & WUNTRACED))
 		return 0;
 
 	exit_code = 0;
@@ -1554,11 +1557,6 @@ static int ptrace_do_wait(struct task_st
 {
 	struct task_struct *p;
 
-	/*
-	 * Traditionally we see ptrace'd stopped tasks regardless of options.
-	 */
-	options |= WUNTRACED;
-
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
 		int ret = wait_consider_task(tsk, 1, p, notask_error,
 					     type, pid, options,
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

