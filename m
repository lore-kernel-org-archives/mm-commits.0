From: akpm@linux-foundation.org
Subject: [merged] introduce-struct-wait_opts-to-simplify-do_wait-pathes.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:56 -0700
Message-ID: <200906182246.n5IMkujQ006000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994AbZFRW6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     introduce "struct wait_opts" to simplify do_wait() patches
has been removed from the -mm tree.  Its filename was
     introduce-struct-wait_opts-to-simplify-do_wait-pathes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce "struct wait_opts" to simplify do_wait() patches
From: Oleg Nesterov <oleg@redhat.com>

Introduce "struct wait_opts" which holds the parameters for misc helpers
in do_wait() pathes.

This adds 13 lines to kernel/exit.c, but saves 256 bytes from .o and imho
makes the code much more readable.

This patch temporary uglifies rusage/siginfo code a little bit, will be
addressed by further cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |  209 +++++++++++++++++++++++++-----------------------
 1 file changed, 111 insertions(+), 98 deletions(-)

diff -puN kernel/exit.c~introduce-struct-wait_opts-to-simplify-do_wait-pathes kernel/exit.c
--- a/kernel/exit.c~introduce-struct-wait_opts-to-simplify-do_wait-pathes
+++ a/kernel/exit.c
@@ -1080,6 +1080,18 @@ SYSCALL_DEFINE1(exit_group, int, error_c
 	return 0;
 }
 
+struct wait_opts {
+	enum pid_type		wo_type;
+	struct pid		*wo_pid;
+	int			wo_flags;
+
+	struct siginfo __user	*wo_info;
+	int __user		*wo_stat;
+	struct rusage __user	*wo_rusage;
+
+	int			notask_error;
+};
+
 static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid = NULL;
@@ -1090,13 +1102,12 @@ static struct pid *task_pid_type(struct 
 	return pid;
 }
 
-static int eligible_child(enum pid_type type, struct pid *pid, int options,
-			  struct task_struct *p)
+static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 {
 	int err;
 
-	if (type < PIDTYPE_MAX) {
-		if (task_pid_type(p, type) != pid)
+	if (wo->wo_type < PIDTYPE_MAX) {
+		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
 			return 0;
 	}
 
@@ -1105,8 +1116,8 @@ static int eligible_child(enum pid_type 
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
 	 * A "clone" child here is one that reports to its parent
 	 * using a signal other than SIGCHLD.) */
-	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
-	    && !(options & __WALL))
+	if (((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
+	    && !(wo->wo_flags & __WALL))
 		return 0;
 
 	err = security_task_wait(p);
@@ -1116,14 +1127,15 @@ static int eligible_child(enum pid_type 
 	return 1;
 }
 
-static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
-			       int why, int status,
-			       struct siginfo __user *infop,
-			       struct rusage __user *rusagep)
+static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
+				pid_t pid, uid_t uid, int why, int status)
 {
-	int retval = rusagep ? getrusage(p, RUSAGE_BOTH, rusagep) : 0;
+	struct siginfo __user *infop;
+	int retval = wo->wo_rusage
+		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 
 	put_task_struct(p);
+	infop = wo->wo_info;
 	if (!retval)
 		retval = put_user(SIGCHLD, &infop->si_signo);
 	if (!retval)
@@ -1147,19 +1159,18 @@ static int wait_noreap_copyout(struct ta
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_zombie(struct task_struct *p, int options,
-			    struct siginfo __user *infop,
-			    int __user *stat_addr, struct rusage __user *ru)
+static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
 	unsigned long state;
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
+	struct siginfo __user *infop;
 
-	if (!likely(options & WEXITED))
+	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
 
-	if (unlikely(options & WNOWAIT)) {
+	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
 		int why, status;
 
@@ -1172,8 +1183,7 @@ static int wait_task_zombie(struct task_
 			why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
 			status = exit_code & 0x7f;
 		}
-		return wait_noreap_copyout(p, pid, uid, why,
-					   status, infop, ru);
+		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
 
 	/*
@@ -1250,11 +1260,14 @@ static int wait_task_zombie(struct task_
 	 */
 	read_unlock(&tasklist_lock);
 
-	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
+	retval = wo->wo_rusage
+		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (!retval && stat_addr)
-		retval = put_user(status, stat_addr);
+	if (!retval && wo->wo_stat)
+		retval = put_user(status, wo->wo_stat);
+
+	infop = wo->wo_info;
 	if (!retval && infop)
 		retval = put_user(SIGCHLD, &infop->si_signo);
 	if (!retval && infop)
@@ -1322,10 +1335,10 @@ static int *task_stopped_code(struct tas
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_stopped(int ptrace, struct task_struct *p,
-			     int options, struct siginfo __user *infop,
-			     int __user *stat_addr, struct rusage __user *ru)
+static int wait_task_stopped(struct wait_opts *wo,
+				int ptrace, struct task_struct *p)
 {
+	struct siginfo __user *infop;
 	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
@@ -1333,7 +1346,7 @@ static int wait_task_stopped(int ptrace,
 	/*
 	 * Traditionally we see ptrace'd stopped tasks regardless of options.
 	 */
-	if (!ptrace && !(options & WUNTRACED))
+	if (!ptrace && !(wo->wo_flags & WUNTRACED))
 		return 0;
 
 	exit_code = 0;
@@ -1347,7 +1360,7 @@ static int wait_task_stopped(int ptrace,
 	if (!exit_code)
 		goto unlock_sig;
 
-	if (!unlikely(options & WNOWAIT))
+	if (!unlikely(wo->wo_flags & WNOWAIT))
 		*p_code = 0;
 
 	/* don't need the RCU readlock here as we're holding a spinlock */
@@ -1369,14 +1382,15 @@ unlock_sig:
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(options & WNOWAIT))
-		return wait_noreap_copyout(p, pid, uid,
-					   why, exit_code,
-					   infop, ru);
-
-	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
-	if (!retval && stat_addr)
-		retval = put_user((exit_code << 8) | 0x7f, stat_addr);
+	if (unlikely(wo->wo_flags & WNOWAIT))
+		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
+
+	retval = wo->wo_rusage
+		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
+	if (!retval && wo->wo_stat)
+		retval = put_user((exit_code << 8) | 0x7f, wo->wo_stat);
+
+	infop = wo->wo_info;
 	if (!retval && infop)
 		retval = put_user(SIGCHLD, &infop->si_signo);
 	if (!retval && infop)
@@ -1403,15 +1417,13 @@ unlock_sig:
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_continued(struct task_struct *p, int options,
-			       struct siginfo __user *infop,
-			       int __user *stat_addr, struct rusage __user *ru)
+static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 {
 	int retval;
 	pid_t pid;
 	uid_t uid;
 
-	if (!unlikely(options & WCONTINUED))
+	if (!unlikely(wo->wo_flags & WCONTINUED))
 		return 0;
 
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
@@ -1423,7 +1435,7 @@ static int wait_task_continued(struct ta
 		spin_unlock_irq(&p->sighand->siglock);
 		return 0;
 	}
-	if (!unlikely(options & WNOWAIT))
+	if (!unlikely(wo->wo_flags & WNOWAIT))
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	uid = __task_cred(p)->uid;
 	spin_unlock_irq(&p->sighand->siglock);
@@ -1432,17 +1444,17 @@ static int wait_task_continued(struct ta
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	if (!infop) {
-		retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
+	if (!wo->wo_info) {
+		retval = wo->wo_rusage
+			? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 		put_task_struct(p);
-		if (!retval && stat_addr)
-			retval = put_user(0xffff, stat_addr);
+		if (!retval && wo->wo_stat)
+			retval = put_user(0xffff, wo->wo_stat);
 		if (!retval)
 			retval = pid;
 	} else {
-		retval = wait_noreap_copyout(p, pid, uid,
-					     CLD_CONTINUED, SIGCONT,
-					     infop, ru);
+		retval = wait_noreap_copyout(wo, p, pid, uid,
+					     CLD_CONTINUED, SIGCONT);
 		BUG_ON(retval == 0);
 	}
 
@@ -1452,19 +1464,16 @@ static int wait_task_continued(struct ta
 /*
  * Consider @p for a wait by @parent.
  *
- * -ECHILD should be in *@notask_error before the first call.
+ * -ECHILD should be in ->notask_error before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue;
- * then *@notask_error is 0 if @p is an eligible child,
+ * then ->notask_error is 0 if @p is an eligible child,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int wait_consider_task(struct task_struct *parent, int ptrace,
-			      struct task_struct *p, int *notask_error,
-			      enum pid_type type, struct pid *pid, int options,
-			      struct siginfo __user *infop,
-			      int __user *stat_addr, struct rusage __user *ru)
+static int wait_consider_task(struct wait_opts *wo, struct task_struct *parent,
+				int ptrace, struct task_struct *p)
 {
-	int ret = eligible_child(type, pid, options, p);
+	int ret = eligible_child(wo, p);
 	if (!ret)
 		return ret;
 
@@ -1476,8 +1485,8 @@ static int wait_consider_task(struct tas
 		 * to look for security policy problems, rather
 		 * than for mysterious wait bugs.
 		 */
-		if (*notask_error)
-			*notask_error = ret;
+		if (wo->notask_error)
+			wo->notask_error = ret;
 		return 0;
 	}
 
@@ -1486,7 +1495,7 @@ static int wait_consider_task(struct tas
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
 		 */
-		*notask_error = 0;
+		wo->notask_error = 0;
 		return 0;
 	}
 
@@ -1497,34 +1506,30 @@ static int wait_consider_task(struct tas
 	 * We don't reap group leaders with subthreads.
 	 */
 	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
-		return wait_task_zombie(p, options, infop, stat_addr, ru);
+		return wait_task_zombie(wo, p);
 
 	/*
 	 * It's stopped or running now, so it might
 	 * later continue, exit, or stop again.
 	 */
-	*notask_error = 0;
+	wo->notask_error = 0;
 
 	if (task_stopped_code(p, ptrace))
-		return wait_task_stopped(ptrace, p, options,
-					 infop, stat_addr, ru);
+		return wait_task_stopped(wo, ptrace, p);
 
-	return wait_task_continued(p, options, infop, stat_addr, ru);
+	return wait_task_continued(wo, p);
 }
 
 /*
  * Do the work of do_wait() for one thread in the group, @tsk.
  *
- * -ECHILD should be in *@notask_error before the first call.
+ * -ECHILD should be in ->notask_error before the first call.
  * Returns nonzero for a final return, when we have unlocked tasklist_lock.
  * Returns zero if the search for a child should continue; then
- * *@notask_error is 0 if there were any eligible children,
+ * ->notask_error is 0 if there were any eligible children,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int do_wait_thread(struct task_struct *tsk, int *notask_error,
-			  enum pid_type type, struct pid *pid, int options,
-			  struct siginfo __user *infop, int __user *stat_addr,
-			  struct rusage __user *ru)
+static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 {
 	struct task_struct *p;
 
@@ -1533,9 +1538,7 @@ static int do_wait_thread(struct task_st
 		 * Do not consider detached threads.
 		 */
 		if (!task_detached(p)) {
-			int ret = wait_consider_task(tsk, 0, p, notask_error,
-						     type, pid, options,
-						     infop, stat_addr, ru);
+			int ret = wait_consider_task(wo, tsk, 0, p);
 			if (ret)
 				return ret;
 		}
@@ -1544,17 +1547,12 @@ static int do_wait_thread(struct task_st
 	return 0;
 }
 
-static int ptrace_do_wait(struct task_struct *tsk, int *notask_error,
-			  enum pid_type type, struct pid *pid, int options,
-			  struct siginfo __user *infop, int __user *stat_addr,
-			  struct rusage __user *ru)
+static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 {
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(tsk, 1, p, notask_error,
-					     type, pid, options,
-					     infop, stat_addr, ru);
+		int ret = wait_consider_task(wo, tsk, 1, p);
 		if (ret)
 			return ret;
 	}
@@ -1562,38 +1560,36 @@ static int ptrace_do_wait(struct task_st
 	return 0;
 }
 
-static long do_wait(enum pid_type type, struct pid *pid, int options,
-		    struct siginfo __user *infop, int __user *stat_addr,
-		    struct rusage __user *ru)
+static long do_wait(struct wait_opts *wo)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int retval;
 
-	trace_sched_process_wait(pid);
+	trace_sched_process_wait(wo->wo_pid);
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
 	/*
 	 * If there is nothing that can match our critiera just get out.
-	 * We will clear @retval to zero if we see any child that might later
-	 * match our criteria, even if we are not able to reap it yet.
+	 * We will clear ->notask_error to zero if we see any child that
+	 * might later match our criteria, even if we are not able to reap
+	 * it yet.
 	 */
-	retval = -ECHILD;
-	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
+	retval = wo->notask_error = -ECHILD;
+	if ((wo->wo_type < PIDTYPE_MAX) &&
+	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
 		goto end;
 
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		int tsk_result = do_wait_thread(tsk, &retval,
-						type, pid, options,
-						infop, stat_addr, ru);
+		int tsk_result = do_wait_thread(wo, tsk);
+
 		if (!tsk_result)
-			tsk_result = ptrace_do_wait(tsk, &retval,
-						    type, pid, options,
-						    infop, stat_addr, ru);
+			tsk_result = ptrace_do_wait(wo, tsk);
+
 		if (tsk_result) {
 			/*
 			 * tasklist_lock is unlocked and we have a final result.
@@ -1602,25 +1598,27 @@ repeat:
 			goto end;
 		}
 
-		if (options & __WNOTHREAD)
+		if (wo->wo_flags & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
 		BUG_ON(tsk->signal != current->signal);
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
-	if (!retval && !(options & WNOHANG)) {
+	retval = wo->notask_error;
+	if (!retval && !(wo->wo_flags & WNOHANG)) {
 		retval = -ERESTARTSYS;
 		if (!signal_pending(current)) {
 			schedule();
 			goto repeat;
 		}
 	}
-
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
-	if (infop) {
+	if (wo->wo_info) {
+		struct siginfo __user *infop = wo->wo_info;
+
 		if (retval > 0)
 			retval = 0;
 		else {
@@ -1649,6 +1647,7 @@ end:
 SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
 		infop, int, options, struct rusage __user *, ru)
 {
+	struct wait_opts wo;
 	struct pid *pid = NULL;
 	enum pid_type type;
 	long ret;
@@ -1678,7 +1677,14 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 
 	if (type < PIDTYPE_MAX)
 		pid = find_get_pid(upid);
-	ret = do_wait(type, pid, options, infop, NULL, ru);
+
+	wo.wo_type	= type;
+	wo.wo_pid	= pid;
+	wo.wo_flags	= options;
+	wo.wo_info	= infop;
+	wo.wo_stat	= NULL;
+	wo.wo_rusage	= ru;
+	ret = do_wait(&wo);
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
@@ -1689,6 +1695,7 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 SYSCALL_DEFINE4(wait4, pid_t, upid, int __user *, stat_addr,
 		int, options, struct rusage __user *, ru)
 {
+	struct wait_opts wo;
 	struct pid *pid = NULL;
 	enum pid_type type;
 	long ret;
@@ -1710,7 +1717,13 @@ SYSCALL_DEFINE4(wait4, pid_t, upid, int 
 		pid = find_get_pid(upid);
 	}
 
-	ret = do_wait(type, pid, options | WEXITED, NULL, stat_addr, ru);
+	wo.wo_type	= type;
+	wo.wo_pid	= pid;
+	wo.wo_flags	= options | WEXITED;
+	wo.wo_info	= NULL;
+	wo.wo_stat	= stat_addr;
+	wo.wo_rusage	= ru;
+	ret = do_wait(&wo);
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

