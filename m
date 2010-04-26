From: akpm@linux-foundation.org
Subject: [merged] rmap-anon_vma_prepare-can-leak-anon_vma_chain.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:41 -0400
Message-ID: <201004261728.o3QHSFPa009109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952Ab0DZR2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bp@alien8.de, hugh.dickins@tiscali.co.uk, riel@redhat.com, torvalds@linux-foundation.org, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rmap: anon_vma_prepare() can leak anon_vma_chain
has been removed from the -mm tree.  Its filename was
     rmap-anon_vma_prepare-can-leak-anon_vma_chain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: anon_vma_prepare() can leak anon_vma_chain
From: Oleg Nesterov <oleg@redhat.com>

If find_mergeable_anon_vma() succeeds but another thread installs
->anon_vma before we take ptl, then allocated == NULL but avc should be
freed.  Change the code to check avc != NULL to detect this case.

Also, a couple of whitespace changes to make the critical section more
visible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/rmap.c~rmap-anon_vma_prepare-can-leak-anon_vma_chain mm/rmap.c
--- a/mm/rmap.c~rmap-anon_vma_prepare-can-leak-anon_vma_chain
+++ a/mm/rmap.c
@@ -133,8 +133,8 @@ int anon_vma_prepare(struct vm_area_stru
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
 		}
-		spin_lock(&anon_vma->lock);
 
+		spin_lock(&anon_vma->lock);
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
@@ -144,14 +144,15 @@ int anon_vma_prepare(struct vm_area_stru
 			list_add(&avc->same_vma, &vma->anon_vma_chain);
 			list_add(&avc->same_anon_vma, &anon_vma->head);
 			allocated = NULL;
+			avc = NULL;
 		}
 		spin_unlock(&mm->page_table_lock);
-
 		spin_unlock(&anon_vma->lock);
-		if (unlikely(allocated)) {
+
+		if (unlikely(allocated))
 			anon_vma_free(allocated);
+		if (unlikely(avc))
 			anon_vma_chain_free(avc);
-		}
 	}
 	return 0;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
oom-select_bad_process-never-choose-tasks-with-badness-==-0.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
exit-exit_notify-can-trust-signal-notify_count-0.patch
exit-change-zap_other_threads-to-count-sub-threads.patch
exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch
exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch
fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch
signals-make-task_struct-signal-immutable-refcountable.patch
signals-clear-signal-tty-when-the-last-thread-exits.patch
signals-clear-signal-tty-when-the-last-thread-exits-fix.patch
signals-kill-the-awful-task_rq_unlock_wait-hack.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
proc-cleanup-remove-unused-assignments.patch

