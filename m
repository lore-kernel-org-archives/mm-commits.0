From: akpm@linux-foundation.org
Subject: + ptrace-introduce-task_detached-helper.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:31:19 -0800
Message-ID: <200803030831.m238VJi0006871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbYCCIcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:32:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     ptrace: introduce task_detached() helper
has been added to the -mm tree.  Its filename is
     ptrace-introduce-task_detached-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: introduce task_detached() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

exit.c has numerous "->exit_signal == -1" comparisons, this check is subtle
and deserves a helper.  Imho makes the code more parseable for humans.  At
least it's surely more greppable.

Also, a couple of whitespace cleanups. No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff -puN kernel/exit.c~ptrace-introduce-task_detached-helper kernel/exit.c
--- a/kernel/exit.c~ptrace-introduce-task_detached-helper
+++ a/kernel/exit.c
@@ -52,6 +52,11 @@
 
 static void exit_mm(struct task_struct * tsk);
 
+static inline int task_detached(struct task_struct *p)
+{
+	return p->exit_signal == -1;
+}
+
 static void __unhash_process(struct task_struct *p)
 {
 	nr_threads--;
@@ -160,7 +165,7 @@ repeat:
 	zap_leader = 0;
 	leader = p->group_leader;
 	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
-		BUG_ON(leader->exit_signal == -1);
+		BUG_ON(task_detached(leader));
 		do_notify_parent(leader, leader->exit_signal);
 		/*
 		 * If we were the last child thread and the leader has
@@ -170,7 +175,7 @@ repeat:
 		 * do_notify_parent() will have marked it self-reaping in
 		 * that case.
 		 */
-		zap_leader = (leader->exit_signal == -1);
+		zap_leader = task_detached(leader);
 	}
 
 	write_unlock_irq(&tasklist_lock);
@@ -655,14 +660,14 @@ reparent_thread(struct task_struct *p, s
 		return;
 
 	/* We don't want people slaying init.  */
-	if (p->exit_signal != -1)
+	if (!task_detached(p))
 		p->exit_signal = SIGCHLD;
 
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
 	if (!traced && p->exit_state == EXIT_ZOMBIE &&
-	    p->exit_signal != -1 && thread_group_empty(p))
+	    !task_detached(p) && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
 	kill_orphaned_pgrp(p, father);
@@ -715,18 +720,18 @@ static void forget_original_parent(struc
 		} else {
 			/* reparent ptraced task to its real parent */
 			__ptrace_unlink (p);
-			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
+			if (p->exit_state == EXIT_ZOMBIE && !task_detached(p) &&
 			    thread_group_empty(p))
 				do_notify_parent(p, p->exit_signal);
 		}
 
 		/*
-		 * if the ptraced child is a zombie with exit_signal == -1
-		 * we must collect it before we exit, or it will remain
-		 * zombie forever since we prevented it from self-reap itself
-		 * while it was being traced by us, to be able to see it in wait4.
+		 * if the ptraced child is a detached zombie we must collect
+		 * it before we exit, or it will remain zombie forever since
+		 * we prevented it from self-reap itself while it was being
+		 * traced by us, to be able to see it in wait4.
 		 */
-		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
+		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && task_detached(p)))
 			list_add(&p->ptrace_list, &ptrace_dead);
 	}
 
@@ -783,26 +788,26 @@ static void exit_notify(struct task_stru
 	 * we have changed execution domain as these two values started
 	 * the same after a fork.
 	 */
-	if (tsk->exit_signal != SIGCHLD && tsk->exit_signal != -1 &&
+	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
 	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id != tsk->parent_exec_id)
-	    && !capable(CAP_KILL))
+	     tsk->self_exec_id != tsk->parent_exec_id) &&
+	    !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 
-
 	/* If something other than our normal parent is ptracing us, then
 	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
 	 * only has special meaning to our real parent.
 	 */
-	if (tsk->exit_signal != -1 && thread_group_empty(tsk)) {
-		int signal = tsk->parent == tsk->real_parent ? tsk->exit_signal : SIGCHLD;
+	if (!task_detached(tsk) && thread_group_empty(tsk)) {
+		int signal = (tsk->parent == tsk->real_parent)
+				? tsk->exit_signal : SIGCHLD;
 		do_notify_parent(tsk, signal);
 	} else if (tsk->ptrace) {
 		do_notify_parent(tsk, SIGCHLD);
 	}
 
 	state = EXIT_ZOMBIE;
-	if (tsk->exit_signal == -1 && likely(!tsk->ptrace))
+	if (task_detached(tsk) && likely(!tsk->ptrace))
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
@@ -1107,7 +1112,7 @@ static int eligible_child(enum pid_type 
 	 * Do not consider detached threads that are
 	 * not ptraced:
 	 */
-	if (p->exit_signal == -1 && !p->ptrace)
+	if (task_detached(p) && !p->ptrace)
 		return 0;
 
 	/* Wait for all children (clone and not) if __WALL is set;
@@ -1299,9 +1304,9 @@ static int wait_task_zombie(struct task_
 		 * If it's still not detached after that, don't release
 		 * it now.
 		 */
-		if (p->exit_signal != -1) {
+		if (!task_detached(p)) {
 			do_notify_parent(p, p->exit_signal);
-			if (p->exit_signal != -1) {
+			if (!task_detached(p)) {
 				p->exit_state = EXIT_ZOMBIE;
 				p = NULL;
 			}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
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
introduce-kill_orphaned_pgrp-helper.patch
will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch
exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch
ptrace-introduce-task_detached-helper.patch
ptrace-introduce-ptrace_reparented-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

