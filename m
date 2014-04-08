From: akpm@linux-foundation.org
Subject: [merged]
 wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:20:05 -0700
Message-ID: <53446805.LcTIOFiHguTKOBOt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHVUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: [merged] wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch removed from -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:20:05 -0700


The patch titled
     Subject: wait: introduce EXIT_TRACE to avoid the racy EXIT_DEAD->EXIT_ZOMBIE transition
has been removed from the -mm tree.  Its filename was
     wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: introduce EXIT_TRACE to avoid the racy EXIT_DEAD->EXIT_ZOMBIE transition

wait_task_zombie() first does EXIT_ZOMBIE->EXIT_DEAD transition and drops
tasklist_lock.  If this task is not the natural child and it is traced, we
change its state back to EXIT_ZOMBIE for ->real_parent.

The last transition is racy, this is even documented in 50b8d257486a
"ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE
race".  wait_consider_task() tries to detect this transition and clear
->notask_error but we can't rely on ptrace_reparented(), debugger can exit
and do ptrace_unlink() before its sub-thread sets EXIT_ZOMBIE.

And there is another problem which were missed before: this transition can
also race with reparent_leader() which doesn't reset >exit_signal if
EXIT_DEAD, assuming that this task must be reaped by someone else.  So the
tracee can be re-parented with ->exit_signal != SIGCHLD, and if /sbin/init
doesn't use __WALL it becomes unreapable.  This was fixed by the previous
commit, but it was the temporary hack.

1. Add the new exit_state, EXIT_TRACE. It means that the task is the
   traced zombie, debugger is going to detach and notify its natural
   parent.

   This new state is actually EXIT_ZOMBIE | EXIT_DEAD. This way we
   can avoid the changes in proc/kgdb code, get_task_state() still
   reports "X (dead)" in this case.

   Note: with or without this change userspace can see Z -> X -> Z
   transition. Not really bad, but probably makes sense to fix.

2. Change wait_task_zombie() to use EXIT_TRACE instead of EXIT_DEAD
   if we need to notify the ->real_parent.

3. Revert the previous hack in reparent_leader(), now that EXIT_DEAD
   is always the final state we can safely ignore such a task.

4. Change wait_consider_task() to check EXIT_TRACE separately and kill
   the racy and no longer needed ptrace_reparented() case.

   If ptrace == T an EXIT_TRACE thread should be simply ignored, the
   owner of this state is going to ptrace_unlink() this task. We can
   pretend that it was already removed from ->ptraced list.

   Otherwise we should skip this thread too but clear ->notask_error,
   we must be the natural parent and debugger is going to untrace and
   notify us. IOW, this doesn't differ from "EXIT_ZOMBIE && p->ptrace"
   even if the task was already untraced.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Reported-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 
 kernel/exit.c         |   50 ++++++++++++++++------------------------
 2 files changed, 22 insertions(+), 29 deletions(-)

diff -puN include/linux/sched.h~wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition include/linux/sched.h
--- a/include/linux/sched.h~wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition
+++ a/include/linux/sched.h
@@ -212,6 +212,7 @@ print_cfs_rq(struct seq_file *m, int cpu
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
+#define EXIT_TRACE		(EXIT_ZOMBIE | EXIT_DEAD)
 /* in tsk->state again */
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
diff -puN kernel/exit.c~wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition kernel/exit.c
--- a/kernel/exit.c~wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition
+++ a/kernel/exit.c
@@ -560,6 +560,9 @@ static void reparent_leader(struct task_
 				struct list_head *dead)
 {
 	list_move_tail(&p->sibling, &p->real_parent->children);
+
+	if (p->exit_state == EXIT_DEAD)
+		return;
 	/*
 	 * If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -567,19 +570,9 @@ static void reparent_leader(struct task_
 	if (same_thread_group(p->real_parent, father))
 		return;
 
-	/*
-	 * We don't want people slaying init.
-	 *
-	 * Note: we do this even if it is EXIT_DEAD, wait_task_zombie()
-	 * can change ->exit_state to EXIT_ZOMBIE. If this is the final
-	 * state, do_notify_parent() was already called and ->exit_signal
-	 * doesn't matter.
-	 */
+	/* We don't want people slaying init. */
 	p->exit_signal = SIGCHLD;
 
-	if (p->exit_state == EXIT_DEAD)
-		return;
-
 	/* If it has exited notify the new parent about this child's death. */
 	if (!p->ptrace &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
@@ -1043,17 +1036,13 @@ static int wait_task_zombie(struct wait_
 		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
 
+	traced = ptrace_reparented(p);
 	/*
-	 * Try to move the task's state to DEAD
-	 * only one thread is allowed to do this:
+	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = xchg(&p->exit_state, EXIT_DEAD);
-	if (state != EXIT_ZOMBIE) {
-		BUG_ON(state != EXIT_DEAD);
+	state = traced ? EXIT_TRACE : EXIT_DEAD;
+	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
-	}
-
-	traced = ptrace_reparented(p);
 	/*
 	 * It can be ptraced but not reparented, check
 	 * thread_group_leader() to filter out sub-threads.
@@ -1114,7 +1103,7 @@ static int wait_task_zombie(struct wait_
 
 	/*
 	 * Now we are sure this task is interesting, and no other
-	 * thread can reap it because we set its state to EXIT_DEAD.
+	 * thread can reap it because we its state == DEAD/TRACE.
 	 */
 	read_unlock(&tasklist_lock);
 
@@ -1159,14 +1148,14 @@ static int wait_task_zombie(struct wait_
 		 * If this is not a sub-thread, notify the parent.
 		 * If parent wants a zombie, don't release it now.
 		 */
+		state = EXIT_DEAD;
 		if (thread_group_leader(p) &&
-		    !do_notify_parent(p, p->exit_signal)) {
-			p->exit_state = EXIT_ZOMBIE;
-			p = NULL;
-		}
+		    !do_notify_parent(p, p->exit_signal))
+			state = EXIT_ZOMBIE;
+		p->exit_state = state;
 		write_unlock_irq(&tasklist_lock);
 	}
-	if (p != NULL)
+	if (state == EXIT_DEAD)
 		release_task(p);
 
 	return retval;
@@ -1362,12 +1351,15 @@ static int wait_consider_task(struct wai
 	}
 
 	/* dead body doesn't have much to contribute */
-	if (unlikely(p->exit_state == EXIT_DEAD)) {
+	if (unlikely(p->exit_state == EXIT_DEAD))
+		return 0;
+
+	if (unlikely(p->exit_state == EXIT_TRACE)) {
 		/*
-		 * But do not ignore this task until the tracer does
-		 * wait_task_zombie()->do_notify_parent().
+		 * ptrace == 0 means we are the natural parent. In this case
+		 * we should clear notask_error, debugger will notify us.
 		 */
-		if (likely(!ptrace) && unlikely(ptrace_reparented(p)))
+		if (likely(!ptrace))
 			wo->notask_error = 0;
 		return 0;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch

