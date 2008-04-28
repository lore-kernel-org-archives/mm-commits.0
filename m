From: akpm@linux-foundation.org
Subject: - mmap_region-cleanup-the-final-vma_merge-related-code.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:47 -0700
Message-ID: <200804282150.m3SLolwv017520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934608AbYD1VvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, hugh@veritas.com, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     mmap_region: cleanup the final vma_merge() related code
has been removed from the -mm tree.  Its filename was
     mmap_region-cleanup-the-final-vma_merge-related-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap_region: cleanup the final vma_merge() related code
From: Oleg Nesterov <oleg@tv-sign.ru>

It is not easy to actually understand the "if (!file || !vma_merge())"
code, turn it into "if (file && vma_merge())".  This makes immediately
obvious that the subsequent "if (file)" is superfluous.

As Hugh Dickins pointed out, we can also factor out the ->i_writecount
corrections, and add a small comment about that.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN mm/mmap.c~mmap_region-cleanup-the-final-vma_merge-related-code mm/mmap.c
--- a/mm/mmap.c~mmap_region-cleanup-the-final-vma_merge-related-code
+++ a/mm/mmap.c
@@ -1068,7 +1068,6 @@ int vma_wants_writenotify(struct vm_area
 		mapping_cap_account_dirty(vma->vm_file->f_mapping);
 }
 
-
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
 			  unsigned int vm_flags, unsigned long pgoff,
@@ -1181,22 +1180,20 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
+	if (file && vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
-		file = vma->vm_file;
-		vma_link(mm, vma, prev, rb_link, rb_parent);
-		if (correct_wcount)
-			atomic_inc(&inode->i_writecount);
-	} else {
-		if (file) {
-			if (correct_wcount)
-				atomic_inc(&inode->i_writecount);
-			fput(file);
-		}
 		mpol_free(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
+		fput(file);
+	} else {
+		vma_link(mm, vma, prev, rb_link, rb_parent);
+		file = vma->vm_file;
 	}
-out:	
+
+	/* Once vma denies write, undo our temporary denial count */
+	if (correct_wcount)
+		atomic_inc(&inode->i_writecount);
+out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-s390.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
cgroups-add-an-owner-to-the-mm_struct.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
procfs-mem-permission-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

