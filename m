From: akpm@linux-foundation.org
Subject: [folded] ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2.patch removed from -mm tree
Date: Thu, 18 Jun 2009 12:23:49 -0700
Message-ID: <200906181923.n5IJNos7011910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbZFRTYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 15:24:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, a.p.zijlstra@chello.nl, roland@redhat.com, sgruszka@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2
has been removed from the -mm tree.  Its filename was
     ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2.patch

This patch was dropped because it was folded into ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2
From: Oleg Nesterov <oleg@redhat.com>

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2 kernel/exit.c
--- a/kernel/exit.c~ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2
+++ a/kernel/exit.c
@@ -1199,7 +1199,10 @@ static int wait_task_zombie(struct wait_
 	}
 
 	traced = ptrace_reparented(p);
-
+	/*
+	 * It can be ptraced but not reparented, check
+	 * !task_detached() to filter out sub-threads.
+	 */
 	if (likely(!traced) && likely(!task_detached(p))) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
ptrace-wait_task_zombie-s-parent-real_parent.patch
ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage.patch
ptrace-dont-take-tasklist-to-get-set-last_siginfo.patch
wait_task_zombie-do-not-use-thread_group_cputime.patch
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
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads-fix-2.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

