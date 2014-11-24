From: akpm@linux-foundation.org
Subject: [nacked]
 exit-reparent-fix-update-the-comments-in-zap_pid_ns_processes.patch removed from -mm tree
Date: Mon, 24 Nov 2014 14:21:41 -0800
Message-ID: <5473af75.vIl60BFu83RkhSpy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaKXWVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:21:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, serge.hallyn@ubuntu.com, stalexan@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: fix/update the comments in zap_pid_ns_processes()
has been removed from the -mm tree.  Its filename was
     exit-reparent-fix-update-the-comments-in-zap_pid_ns_processes.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: fix/update the comments in zap_pid_ns_processes()

The comments in zap_pid_ns_processes() are simply wrong, we need
to explain how this code actually works.

1. "Ignore SIGCHLD" looks like optimization but it is not, we also
   need this for correctness.

2. The comment above sys_wait4() could be more clear.

3. The comment about TASK_DEAD children is outdated. Contrary to
   what it says we do not need to make sure they all go away.

   At the same time, we do need to wait for nr_hashed == init_pids,
   but the reason is quite different and not obvious.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN kernel/pid_namespace.c~exit-reparent-fix-update-the-comments-in-zap_pid_ns_processes kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~exit-reparent-fix-update-the-comments-in-zap_pid_ns_processes
+++ a/kernel/pid_namespace.c
@@ -190,7 +190,11 @@ void zap_pid_ns_processes(struct pid_nam
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
 
-	/* Ignore SIGCHLD causing any terminated children to autoreap */
+	/*
+	 * Ignore SIGCHLD causing any terminated children to autoreap.
+	 * This speeds up the namespace shutdown, plus see the comment
+	 * below.
+	 */
 	spin_lock_irq(&me->sighand->siglock);
 	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
 	spin_unlock_irq(&me->sighand->siglock);
@@ -223,15 +227,26 @@ void zap_pid_ns_processes(struct pid_nam
 	}
 	read_unlock(&tasklist_lock);
 
-	/* Firstly reap the EXIT_ZOMBIE children we may have. */
+	/* Reap the EXIT_ZOMBIE children we had before we ignored SIGCHLD */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
 	/*
-	 * sys_wait4() above can't reap the TASK_DEAD children.
-	 * Make sure they all go away, see free_pid().
+	 * sys_wait4() above can't reap the TASK_DEAD children but we do not
+	 * really care, we could reparent them to the global init. We could
+	 * exit and reap ->child_reaper even if it is not the last thread in
+	 * this pid_ns, free_pid(nr_hashed == 0) calls proc_cleanup_work(),
+	 * pid_ns can not go away until proc_kill_sb() drops the reference.
+	 *
+	 * But this namespace can also have other tasks injected by setns().
+	 * Again, we do not really need to wait until they are all reaped,
+	 * but they can be reparented to us and thus we need to ensure that
+	 * pid->child_reaper is valid until they all go away.
+	 *
+	 * We rely on ignored SIGCHLD, an injected zombie must be autoreaped
+	 * if reparented.
 	 */
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
exit-wait-cleanup-the-ptrace_reparented-checks.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
exit-wait-dont-use-zombie-real_parent.patch
exit-wait-drop-tasklist_lock-before-psig-c-accounting.patch
exit-release_task-fix-the-comment-about-group-leader-accounting.patch
exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
exit-reparent-fix-the-cross-namespace-pr_set_child_subreaper-reparenting.patch
exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
exit-reparent-document-the-has_child_subreaper-checks.patch
exit-reparent-introduce-find_child_reaper.patch
exit-reparent-introduce-find_alive_thread.patch
exit-reparent-avoid-find_new_reaper-if-no-children.patch
exit-reparent-call-forget_original_parent-under-tasklist_lock.patch
exit-exit_notify-re-use-dead-list-to-autoreap-current.patch
exit-reparent-fix-update-the-comments-in-zap_pid_ns_processes-fix.patch
exit-pidns-alloc_pid-leaks-pid_namespace-if-child_reaper-is-exiting.patch
linux-next.patch

