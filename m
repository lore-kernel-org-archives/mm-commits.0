From: akpm@linux-foundation.org
Subject: [merged] ptrace-revert-ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch removed from -mm tree
Date: Fri, 05 Jun 2009 11:55:18 -0700
Message-ID: <200906051855.n55ItIiE020603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbZFESzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 14:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jan.kratochvil@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: revert "ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic"
has been removed from the -mm tree.  Its filename was
     ptrace-revert-ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: revert "ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic"
From: Oleg Nesterov <oleg@redhat.com>

Commit 95a3540da9c81a5987be810e1d9a83640a366bd5 ("ptrace_detach: the wrong
wakeup breaks the ERESTARTxxx logic") removed the "extra"
wake_up_process() from ptrace_detach(), but as Jan pointed out this breaks
the compatibility.

I believe the changelog is right and this wake_up() is wrong in many ways.
 But GDB assumes that ptrace(PTRACE_DETACH, child, 0, 0) always wakes up
the tracee.  Despite the fact this breaks
SIGNAL_STOP_STOPPED/group_stop_count logic, and despite the fact this
wake_up_process() can break another assumption: PTRACE_DETACH with SIGSTOP
should leave the tracee in TASK_STOPPED case.  Because the untraced child
can dequeue SIGSTOP and call do_signal_stop() before ptrace_detach() calls
wake_up_process().

Revert this change for now.  We need some fixes even if we we want to keep
the current behaviour, but these fixes are not for 2.6.30.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/ptrace.c~ptrace-revert-ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-revert-ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic
+++ a/kernel/ptrace.c
@@ -304,6 +304,8 @@ int ptrace_detach(struct task_struct *ch
 	if (child->ptrace) {
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
+		if (!child->exit_state)
+			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
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

