From: akpm@linux-foundation.org
Subject: + wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:24:53 -0800
Message-ID: <200711270524.lAR5OrOL028830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbXK0F0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:26:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     wait_task_stopped: simplify and fix races with SIGCONT/SIGKILL/untrace
has been added to the -mm tree.  Its filename is
     wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_stopped: simplify and fix races with SIGCONT/SIGKILL/untrace
From: Oleg Nesterov <oleg@tv-sign.ru>

wait_task_stopped() has multiple races with SIGCONT/SIGKILL.  tasklist_lock
does not pin the child in TASK_TRACED/TASK_STOPPED stated, almost all info
reported (including exit_code) may be wrong.

In fact, the code under write_lock_irq(tasklist_lock) is not safe.  The child
may be PTRACE_DETACH'ed at this time by another subthread, in that case it is
possible we are no longer its ->parent.

Change wait_task_stopped() to take ->siglock before inspecting the task.  This
guarantees that the child can't resume and (for example) clear its
->exit_code, so we don't need to use xchg(&p->exit_code) and re-check.  The
only exception is ptrace_stop() which changes ->state and ->exit_code without
->siglock held during abort.  But this can only happen if both the tracer and
the tracee are dying (coredump is in progress), we don't care.

With this patch wait_task_stopped() doesn't move the child to the end of the
->parent lis
t on success.  This optimization could be restored, but in that
case we have to take write_lock(tasklist) and do some nasty checks.

Also change the do_wait() since we don't return EAGAIN any longer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   88 ++++++++++++++----------------------------------
 1 file changed, 26 insertions(+), 62 deletions(-)

diff -puN kernel/exit.c~wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace
+++ a/kernel/exit.c
@@ -1352,17 +1352,35 @@ static int wait_task_stopped(struct task
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code;
+	int retval, exit_code, why;
+	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
-	if (!p->exit_code)
-		return 0;
+	exit_code = 0;
+	spin_lock_irq(&p->sighand->siglock);
+
+	if (unlikely(!is_task_stopped_or_traced(p)))
+		goto unlock_sig;
+
 	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
 	    p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
 		 */
+		goto unlock_sig;
+
+	exit_code = p->exit_code;
+	if (!exit_code)
+		goto unlock_sig;
+
+	if (!noreap)
+		p->exit_code = 0;
+
+	uid = p->uid;
+unlock_sig:
+	spin_unlock_irq(&p->sighand->siglock);
+	if (!exit_code)
 		return 0;
 
 	/*
@@ -1372,65 +1390,15 @@ static int wait_task_stopped(struct task
 	 * keep holding onto the tasklist_lock while we call getrusage and
 	 * possibly take page faults for user memory.
 	 */
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	get_task_struct(p);
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(noreap)) {
-		uid_t uid = p->uid;
-		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
-
-		exit_code = p->exit_code;
-		if (unlikely(!exit_code) || unlikely(p->exit_state))
-			goto bail_ref;
+	if (unlikely(noreap))
 		return wait_noreap_copyout(p, pid, uid,
 					   why, exit_code,
 					   infop, ru);
-	}
-
-	write_lock_irq(&tasklist_lock);
-
-	/*
-	 * This uses xchg to be atomic with the thread resuming and setting
-	 * it.  It must also be done with the write lock held to prevent a
-	 * race with the EXIT_ZOMBIE case.
-	 */
-	exit_code = xchg(&p->exit_code, 0);
-	if (unlikely(p->exit_state)) {
-		/*
-		 * The task resumed and then died.  Let the next iteration
-		 * catch it in EXIT_ZOMBIE.  Note that exit_code might
-		 * already be zero here if it resumed and did _exit(0).
-		 * The task itself is dead and won't touch exit_code again;
-		 * other processors in this function are locked out.
-		 */
-		p->exit_code = exit_code;
-		exit_code = 0;
-	}
-	if (unlikely(exit_code == 0)) {
-		/*
-		 * Another thread in this function got to it first, or it
-		 * resumed, or it resumed and then died.
-		 */
-		write_unlock_irq(&tasklist_lock);
-bail_ref:
-		put_task_struct(p);
-		/*
-		 * We are returning to the wait loop without having successfully
-		 * removed the process and having released the lock. We cannot
-		 * continue, since the "p" task pointer is potentially stale.
-		 *
-		 * Return -EAGAIN, and do_wait() will restart the loop from the
-		 * beginning. Do _not_ re-acquire the lock.
-		 */
-		return -EAGAIN;
-	}
-
-	/* move to end of parent's list to avoid starvation */
-	remove_parent(p);
-	add_parent(p);
-
-	write_unlock_irq(&tasklist_lock);
 
 	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
 	if (!retval && stat_addr)
@@ -1440,15 +1408,13 @@ bail_ref:
 	if (!retval && infop)
 		retval = put_user(0, &infop->si_errno);
 	if (!retval && infop)
-		retval = put_user((short)((p->ptrace & PT_PTRACED)
-					  ? CLD_TRAPPED : CLD_STOPPED),
-				  &infop->si_code);
+		retval = put_user(why, &infop->si_code);
 	if (!retval && infop)
 		retval = put_user(exit_code, &infop->si_status);
 	if (!retval && infop)
 		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
-		retval = put_user(p->uid, &infop->si_uid);
+		retval = put_user(uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 	put_task_struct(p);
@@ -1555,8 +1521,6 @@ repeat:
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval == -EAGAIN)
-					goto repeat;
 				if (retval != 0) /* He released the lock.  */
 					goto end;
 			} else if (p->exit_state == EXIT_ZOMBIE) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
