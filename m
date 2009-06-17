From: akpm@linux-foundation.org
Subject: [folded] ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:49:27 -0700
Message-ID: <200906172249.n5HMnRJM009507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762055AbZFQWtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix
has been removed from the -mm tree.  Its filename was
     ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch

This patch was dropped because it was folded into ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix
From: Oleg Nesterov <oleg@redhat.com>

On 04/23, Roland McGrath wrote:
>
> > tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.
>
> Please make it instead say that cred_exec_mutex is held by the caller
> through the exec.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/tracehook.h~ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix include/linux/tracehook.h
--- a/include/linux/tracehook.h~ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix
+++ a/include/linux/tracehook.h
@@ -142,6 +142,8 @@ static inline void tracehook_report_sysc
  * @task:		current task doing exec
  *
  * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
+ *
+ * task->cred_exec_mutex is held by the caller through the do_execve().
  */
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {
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
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
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

