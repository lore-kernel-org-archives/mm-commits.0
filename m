From: akpm@linux-foundation.org
Subject: [merged] do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:13 -0700
Message-ID: <200904061935.n36JZD2n011931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbZDFTlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, drepper@redhat.com, dvlasenk@redhat.com, ebiederm@xmission.com, jan.kratochvil@redhat.com, kkylheku@gmail.com, mtk.manpages@googlemail.com, roland@redhat.com, mm-comm


The patch titled
     do_wait: fix waiting for the group stop with the dead leader
has been removed from the -mm tree.  Its filename was
     do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait: fix waiting for the group stop with the dead leader
From: Oleg Nesterov <oleg@redhat.com>

do_wait(WSTOPPED) assumes that p->state must be == TASK_STOPPED, this is
not true if the leader is already dead.  Check SIGNAL_STOP_STOPPED instead
and use signal->group_exit_code.

Trivial test-case:

	void *tfunc(void *arg)
	{
		pause();
		return NULL;
	}

	int main(void)
	{
		pthread_t thr;
		pthread_create(&thr, NULL, tfunc, NULL);
		pthread_exit(NULL);
		return 0;
	}

It doesn't react to ^Z (and then to ^C or ^\). The task is stopped, but
bash can't see this.

The bug is very old, and it was reported multiple times. This patch was sent
more than a year ago (http://marc.info/?t=119713920000003) but it was ignored.

This change also fixes other oddities (but not all) in this area.  For
example, before this patch:

	$ sleep 100
	^Z
	[1]+  Stopped                 sleep 100
	$ strace -p `pidof sleep`
	Process 11442 attached - interrupt to quit

strace hangs in do_wait(), because ->exit_code was already consumed by
bash.  After this patch, strace happily proceeds:

	--- SIGTSTP (Stopped) @ 0 (0) ---
	restart_syscall(<... resuming interrupted call ...>

To me, this looks much more "natural" and correct.

Another example.  Let's suppose we have the main thread M and sub-thread
T, the process is stopped, and its parent did wait(WSTOPPED).  Now we can
ptrace T but not M.  This looks at least strange to me.

Imho, do_wait() should not confuse the per-thread ptrace stops with the
per-process job control stops.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Kaz Kylheku <kkylheku@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN kernel/exit.c~do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader kernel/exit.c
--- a/kernel/exit.c~do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader
+++ a/kernel/exit.c
@@ -1417,6 +1417,18 @@ static int wait_task_zombie(struct task_
 	return retval;
 }
 
+static int *task_stopped_code(struct task_struct *p, bool ptrace)
+{
+	if (ptrace) {
+		if (task_is_stopped_or_traced(p))
+			return &p->exit_code;
+	} else {
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			return &p->signal->group_exit_code;
+	}
+	return NULL;
+}
+
 /*
  * Handle sys_wait4 work for one task in state TASK_STOPPED.  We hold
  * read_lock(&tasklist_lock) on entry.  If we return zero, we still hold
@@ -1427,7 +1439,7 @@ static int wait_task_stopped(int ptrace,
 			     int options, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code, why;
+	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
@@ -1437,22 +1449,16 @@ static int wait_task_stopped(int ptrace,
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
-	if (unlikely(!task_is_stopped_or_traced(p)))
-		goto unlock_sig;
-
-	if (!ptrace && p->signal->group_stop_count > 0)
-		/*
-		 * A group stop is in progress and this is the group leader.
-		 * We won't report until all threads have stopped.
-		 */
+	p_code = task_stopped_code(p, ptrace);
+	if (unlikely(!p_code))
 		goto unlock_sig;
 
-	exit_code = p->exit_code;
+	exit_code = *p_code;
 	if (!exit_code)
 		goto unlock_sig;
 
 	if (!unlikely(options & WNOWAIT))
-		p->exit_code = 0;
+		*p_code = 0;
 
 	/* don't need the RCU readlock here as we're holding a spinlock */
 	uid = __task_cred(p)->uid;
@@ -1608,7 +1614,7 @@ static int wait_consider_task(struct tas
 	 */
 	*notask_error = 0;
 
-	if (task_is_stopped_or_traced(p))
+	if (task_stopped_code(p, ptrace))
 		return wait_task_stopped(ptrace, p, options,
 					 infop, stat_addr, ru);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

