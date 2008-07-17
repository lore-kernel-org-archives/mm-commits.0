From: akpm@linux-foundation.org
Subject: + ptrace-do_wait-reorganization.patch added to -mm tree
Date: Thu, 17 Jul 2008 00:31:17 -0700
Message-ID: <200807170731.m6H7VHVM004505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760091AbYGQHbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 03:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     ptrace: do_wait reorganization
has been added to the -mm tree.  Its filename is
     ptrace-do_wait-reorganization.patch

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
Subject: ptrace: do_wait reorganization
From: Roland McGrath <roland@redhat.com>

This breaks out the guts of do_wait into three subfunctions.  The control
flow is less nonobvious without so much goto.  do_wait_thread and
ptrace_do_wait contain the main work of the outer loop. 
wait_consider_task contains the main work of the inner loop.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |  215 ++++++++++++++++++++++++++++++------------------
 1 file changed, 135 insertions(+), 80 deletions(-)

diff -puN kernel/exit.c~ptrace-do_wait-reorganization kernel/exit.c
--- a/kernel/exit.c~ptrace-do_wait-reorganization
+++ a/kernel/exit.c
@@ -1230,7 +1230,7 @@ static int wait_noreap_copyout(struct ta
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_zombie(struct task_struct *p, int noreap,
+static int wait_task_zombie(struct task_struct *p, int options,
 			    struct siginfo __user *infop,
 			    int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1238,7 +1238,10 @@ static int wait_task_zombie(struct task_
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
 
-	if (unlikely(noreap)) {
+	if (!likely(options & WEXITED))
+		return 0;
+
+	if (unlikely(options & WNOWAIT)) {
 		uid_t uid = p->uid;
 		int exit_code = p->exit_code;
 		int why, status;
@@ -1389,13 +1392,16 @@ static int wait_task_zombie(struct task_
  * released the lock and the system call should return.
  */
 static int wait_task_stopped(struct task_struct *p,
-			     int noreap, struct siginfo __user *infop,
+			     int options, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
 	int retval, exit_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
+	if (!(p->ptrace & PT_PTRACED) && !(options & WUNTRACED))
+		return 0;
+
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
@@ -1413,7 +1419,7 @@ static int wait_task_stopped(struct task
 	if (!exit_code)
 		goto unlock_sig;
 
-	if (!noreap)
+	if (!unlikely(options & WNOWAIT))
 		p->exit_code = 0;
 
 	uid = p->uid;
@@ -1434,7 +1440,7 @@ unlock_sig:
 	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(noreap))
+	if (unlikely(options & WNOWAIT))
 		return wait_noreap_copyout(p, pid, uid,
 					   why, exit_code,
 					   infop, ru);
@@ -1468,7 +1474,7 @@ unlock_sig:
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_continued(struct task_struct *p, int noreap,
+static int wait_task_continued(struct task_struct *p, int options,
 			       struct siginfo __user *infop,
 			       int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1476,6 +1482,9 @@ static int wait_task_continued(struct ta
 	pid_t pid;
 	uid_t uid;
 
+	if (!unlikely(options & WCONTINUED))
+		return 0;
+
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
 
@@ -1485,7 +1494,7 @@ static int wait_task_continued(struct ta
 		spin_unlock_irq(&p->sighand->siglock);
 		return 0;
 	}
-	if (!noreap)
+	if (!unlikely(options & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
@@ -1511,89 +1520,137 @@ static int wait_task_continued(struct ta
 	return retval;
 }
 
+/*
+ * Consider @p for a wait by @parent.
+ *
+ * -ECHILD should be in *@notask_error before the first call.
+ * Returns nonzero for a final return, when we have unlocked tasklist_lock.
+ * Returns zero if the search for a child should continue;
+ * then *@notask_error is 0 if @p is an eligible child, or still -ECHILD.
+ */
+static int wait_consider_task(struct task_struct *parent,
+			      struct task_struct *p, int *notask_error,
+			      enum pid_type type, struct pid *pid, int options,
+			      struct siginfo __user *infop,
+			      int __user *stat_addr, struct rusage __user *ru)
+{
+	int ret = eligible_child(type, pid, options, p);
+	if (ret <= 0)
+		return ret;
+
+	if (p->exit_state == EXIT_DEAD)
+		return 0;
+
+	/*
+	 * We don't reap group leaders with subthreads.
+	 */
+	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
+		return wait_task_zombie(p, options, infop, stat_addr, ru);
+
+	/*
+	 * It's stopped or running now, so it might
+	 * later continue, exit, or stop again.
+	 */
+	*notask_error = 0;
+
+	if (task_is_stopped_or_traced(p))
+		return wait_task_stopped(p, options, infop, stat_addr, ru);
+
+	return wait_task_continued(p, options, infop, stat_addr, ru);
+}
+
+/*
+ * Do the work of do_wait() for one thread in the group, @tsk.
+ *
+ * -ECHILD should be in *@notask_error before the first call.
+ * Returns nonzero for a final return, when we have unlocked tasklist_lock.
+ * Returns zero if the search for a child should continue; then
+ * *@notask_error is 0 if there were any eligible children, or still -ECHILD.
+ */
+static int do_wait_thread(struct task_struct *tsk, int *notask_error,
+			  enum pid_type type, struct pid *pid, int options,
+			  struct siginfo __user *infop, int __user *stat_addr,
+			  struct rusage __user *ru)
+{
+	struct task_struct *p;
+
+	list_for_each_entry(p, &tsk->children, sibling) {
+		int ret = wait_consider_task(tsk, p, notask_error,
+					     type, pid, options,
+					     infop, stat_addr, ru);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ptrace_do_wait(struct task_struct *tsk, int *notask_error,
+			  enum pid_type type, struct pid *pid, int options,
+			  struct siginfo __user *infop, int __user *stat_addr,
+			  struct rusage __user *ru)
+{
+	struct task_struct *p;
+
+	/*
+	 * If we never saw an eligile child, check for children stolen by
+	 * ptrace.  We don't leave -ECHILD in *@notask_error if there are any,
+	 * because we will eventually be allowed to wait for them again.
+	 */
+	if (!*notask_error)
+		return 0;
+
+	list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
+		int ret = eligible_child(type, pid, options, p);
+		if (unlikely(ret < 0))
+			return ret;
+		if (ret) {
+			*notask_error = 0;
+			return 0;
+		}
+	}
+
+	return 0;
+}
+
 static long do_wait(enum pid_type type, struct pid *pid, int options,
 		    struct siginfo __user *infop, int __user *stat_addr,
 		    struct rusage __user *ru)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
-	int flag, retval;
+	int retval;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
-	/* If there is nothing that can match our critier just get out */
+	/*
+	 * If there is nothing that can match our critiera just get out.
+	 * We will clear @retval to zero if we see any child that might later
+	 * match our criteria, even if we are not able to reap it yet.
+	 */
 	retval = -ECHILD;
 	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
 		goto end;
 
-	/*
-	 * We will set this flag if we see any child that might later
-	 * match our criteria, even if we are not able to reap it yet.
-	 */
-	flag = retval = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		struct task_struct *p;
-
-		list_for_each_entry(p, &tsk->children, sibling) {
-			int ret = eligible_child(type, pid, options, p);
-			if (!ret)
-				continue;
-
-			if (unlikely(ret < 0)) {
-				retval = ret;
-			} else if (task_is_stopped_or_traced(p)) {
-				/*
-				 * It's stopped now, so it might later
-				 * continue, exit, or stop again.
-				 */
-				flag = 1;
-				if (!(p->ptrace & PT_PTRACED) &&
-				    !(options & WUNTRACED))
-					continue;
-
-				retval = wait_task_stopped(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			} else if (p->exit_state == EXIT_ZOMBIE &&
-					!delay_group_leader(p)) {
-				/*
-				 * We don't reap group leaders with subthreads.
-				 */
-				if (!likely(options & WEXITED))
-					continue;
-				retval = wait_task_zombie(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			} else if (p->exit_state != EXIT_DEAD) {
-				/*
-				 * It's running now, so it might later
-				 * exit, stop, or stop and then continue.
-				 */
-				flag = 1;
-				if (!unlikely(options & WCONTINUED))
-					continue;
-				retval = wait_task_continued(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			}
-			if (retval != 0) /* tasklist_lock released */
-				goto end;
-		}
-		if (!flag) {
-			list_for_each_entry(p, &tsk->ptrace_children,
-								ptrace_list) {
-				flag = eligible_child(type, pid, options, p);
-				if (!flag)
-					continue;
-				if (likely(flag > 0))
-					break;
-				retval = flag;
-				goto end;
-			}
+		int tsk_result = do_wait_thread(tsk, &retval,
+						type, pid, options,
+						infop, stat_addr, ru);
+		if (!tsk_result)
+			tsk_result = ptrace_do_wait(tsk, &retval,
+						    type, pid, options,
+						    infop, stat_addr, ru);
+		if (tsk_result) {
+			/*
+			 * tasklist_lock is unlocked and we have a final result.
+			 */
+			retval = tsk_result;
+			goto end;
 		}
+
 		if (options & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
@@ -1601,16 +1658,14 @@ repeat:
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
-	if (flag) {
-		if (options & WNOHANG)
-			goto end;
+	if (!retval && !(options & WNOHANG)) {
 		retval = -ERESTARTSYS;
-		if (signal_pending(current))
-			goto end;
-		schedule();
-		goto repeat;
+		if (!signal_pending(current)) {
+			schedule();
+			goto repeat;
+		}
 	}
-	retval = -ECHILD;
+
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
ptrace-do_wait-reorganization.patch
ptrace-ptrace-children-revamp.patch
ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch
ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch

