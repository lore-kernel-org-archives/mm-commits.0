From: akpm@linux-foundation.org
Subject: + do_wait-wakeup-optimization.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:15:22 -0800
Message-ID: <200811212015.mALKFMs4019558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbYKUUQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, mingo@elte.hu, oleg@redhat.com, rnalumasu@gmail.com


The patch titled
     do_wait() wakeup optimization
has been added to the -mm tree.  Its filename is
     do_wait-wakeup-optimization.patch

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
Subject: do_wait() wakeup optimization
From: Roland McGrath <roland@redhat.com>

Ratan Nalumasu reported that in a process with many threads doing
unnecessary wakeups.  Every waiting thread in the process wakes up to loop
through the children and see that the only ones it cares about are still
not ready.

Change do_wait() to use init_waitqueue_func_entry with a custom wake
function.  This skips the wakeup for a do_wait() call that is not
interested in the child that's doing wake_up on wait_chldexit.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   90 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 12 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization
+++ a/kernel/exit.c
@@ -1195,10 +1195,8 @@ static struct pid *task_pid_type(struct 
 }
 
 static int eligible_child(enum pid_type type, struct pid *pid, int options,
-			  struct task_struct *p)
+			  struct task_struct *p, int exit_signal)
 {
-	int err;
-
 	if (type < PIDTYPE_MAX) {
 		if (task_pid_type(p, type) != pid)
 			return 0;
@@ -1209,14 +1207,10 @@ static int eligible_child(enum pid_type 
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
 	 * A "clone" child here is one that reports to its parent
 	 * using a signal other than SIGCHLD.) */
-	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
+	if (((exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
 	    && !(options & __WALL))
 		return 0;
 
-	err = security_task_wait(p);
-	if (err)
-		return err;
-
 	return 1;
 }
 
@@ -1563,10 +1557,11 @@ static int wait_consider_task(struct tas
 			      struct siginfo __user *infop,
 			      int __user *stat_addr, struct rusage __user *ru)
 {
-	int ret = eligible_child(type, pid, options, p);
+	int ret = eligible_child(type, pid, options, p, p->exit_signal);
 	if (!ret)
 		return ret;
 
+	ret = security_task_wait(p);
 	if (unlikely(ret < 0)) {
 		/*
 		 * If we have not yet seen any eligible child,
@@ -1665,17 +1660,88 @@ static int ptrace_do_wait(struct task_st
 	return 0;
 }
 
+/*
+ * This sits on the stack of a thread that is blocked in do_wait().
+ * @wq.private holds the task_struct pointer of that thread.
+ */
+struct do_wait_queue_entry {
+	wait_queue_t wq;
+	struct pid *pid;
+	enum pid_type type;
+	int options;
+};
+
+/*
+ * Here current (@task) is a thread calling do_notify_parent().
+ * Return zero to optimize out the wake-up of a parent thread in
+ * do_wait() that doesn't care about this child.  An extra wake-up
+ * is permissible, but missing one is not.
+ */
+static int needs_wakeup(struct task_struct *task, struct do_wait_queue_entry *w)
+{
+	if ((w->options & __WNOTHREAD) && task->parent != w->wq.private)
+		return 0;
+
+	if (eligible_child(w->type, w->pid, w->options,
+			   task, task->exit_signal))
+		return 1;
+
+	if (thread_group_leader(task)) {
+		/*
+		 * In a group leader, do_notify_parent() may have
+		 * just reset task->exit_signal because SIGCHLD was
+		 * ignored, but that doesn't prevent the wakeup.
+		 */
+		if (!task_detached(task) ||
+		    !eligible_child(w->type, w->pid, w->options,
+				    task, SIGCHLD))
+			return 0;
+	} else {
+		/*
+		 * In a non-leader, this might be the release_task()
+		 * case, where it's the leader rather than task
+		 * whose parent is being woken.
+		 */
+		if (!eligible_child(w->type, w->pid, w->options,
+				    task->group_leader,
+				    task_detached(task->group_leader) ?
+				    SIGCHLD : task->group_leader->exit_signal))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int do_wait_wake_function(wait_queue_t *curr, unsigned mode, int sync,
+				 void *key)
+{
+	struct task_struct *task = current;
+	struct do_wait_queue_entry *w =
+		container_of(curr, struct do_wait_queue_entry, wq);
+
+	if (!needs_wakeup(task, w))
+		return 0;
+
+	return default_wake_function(curr, mode, sync, key);
+}
+
 static long do_wait(enum pid_type type, struct pid *pid, int options,
 		    struct siginfo __user *infop, int __user *stat_addr,
 		    struct rusage __user *ru)
 {
-	DECLARE_WAITQUEUE(wait, current);
+	struct do_wait_queue_entry wait;
 	struct task_struct *tsk;
 	int retval;
 
 	trace_sched_process_wait(pid);
 
-	add_wait_queue(&current->signal->wait_chldexit,&wait);
+	init_waitqueue_func_entry(&wait.wq, do_wait_wake_function);
+	wait.wq.private = current;
+	wait.type = type;
+	wait.pid = pid;
+	wait.options = options;
+
+	add_wait_queue(&current->signal->wait_chldexit, &wait.wq);
 repeat:
 	/*
 	 * If there is nothing that can match our critiera just get out.
@@ -1722,7 +1788,7 @@ repeat:
 
 end:
 	current->state = TASK_RUNNING;
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wait.wq);
 	if (infop) {
 		if (retval > 0)
 			retval = 0;
_

Patches currently in -mm which might be from roland@redhat.com are

posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
forkc-cleanup-for-copy_sighand.patch
do_wait-wakeup-optimization.patch
signals-protect-sbin-init-from-unwanted-signals-more.patch
signals-simplify-sig_ignored-pathes.patch

