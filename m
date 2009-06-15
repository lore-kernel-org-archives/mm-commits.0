From: akpm@linux-foundation.org
Subject: + wait_task_zombie-do-not-use-thread_group_cputime.patch added to -mm tree
Date: Mon, 15 Jun 2009 15:08:42 -0700
Message-ID: <200906152208.n5FM8hub027401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758092AbZFOWI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 18:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, roland@redhat.com, sgruszka@redhat.com, vmayatsk@redhat.com


The patch titled
     wait_task_zombie: do not use thread_group_cputime()
has been added to the -mm tree.  Its filename is
     wait_task_zombie-do-not-use-thread_group_cputime.patch

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
Subject: wait_task_zombie: do not use thread_group_cputime()
From: Oleg Nesterov <oleg@redhat.com>

There is no reason for thread_group_cputime() in wait_task_zombie(), there
must be no other threads.

This call was previously needed to collect the per-cpu data which we do
not have any longer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~wait_task_zombie-do-not-use-thread_group_cputime kernel/exit.c
--- a/kernel/exit.c~wait_task_zombie-do-not-use-thread_group_cputime
+++ a/kernel/exit.c
@@ -1197,7 +1197,6 @@ static int wait_task_zombie(struct task_
 	if (likely(!traced) && likely(!task_detached(p))) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
-		struct task_cputime cputime;
 		unsigned long maxrss;
 
 		/*
@@ -1214,23 +1213,20 @@ static int wait_task_zombie(struct task_
 		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
-		 *
-		 * We use thread_group_cputime() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
 		 */
-		thread_group_cputime(p, &cputime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(cputime.utime,
-				    sig->cutime));
+			cputime_add(p->utime,
+			cputime_add(sig->utime,
+				    sig->cutime)));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(cputime.stime,
-				    sig->cstime));
+			cputime_add(p->stime,
+			cputime_add(sig->stime,
+				    sig->cstime)));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
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
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
wait_task_zombie-do-not-use-thread_group_cputime.patch
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
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-clean-up-find_task_by_pid-variants.patch

