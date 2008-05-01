From: akpm@linux-foundation.org
Subject: - ptrace-introduce-task_detached-helper.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:28 -0700
Message-ID: <200805010927.m419RSZj030421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075AbYEAJjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: introduce task_detached() helper
has been removed from the -mm tree.  Its filename was
     ptrace-introduce-task_detached-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -721,14 +726,14 @@ reparent_thread(struct task_struct *p, s
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
@@ -781,18 +786,18 @@ static void forget_original_parent(struc
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
 
@@ -849,26 +854,26 @@ static void exit_notify(struct task_stru
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
 
@@ -1173,7 +1178,7 @@ static int eligible_child(enum pid_type 
 	 * Do not consider detached threads that are
 	 * not ptraced:
 	 */
-	if (p->exit_signal == -1 && !p->ptrace)
+	if (task_detached(p) && !p->ptrace)
 		return 0;
 
 	/* Wait for all children (clone and not) if __WALL is set;
@@ -1365,9 +1370,9 @@ static int wait_task_zombie(struct task_
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

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

