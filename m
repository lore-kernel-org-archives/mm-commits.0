From: akpm@linux-foundation.org
Subject: - itimer_real-convert-to-use-struct-pid.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:30 -0800
Message-ID: <200802082014.m18KEBFK010376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757376AbYBHVER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, roland@redhat.com, tglx@linutronix.de, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     ITIMER_REAL: convert to use struct pid
has been removed from the -mm tree.  Its filename was
     itimer_real-convert-to-use-struct-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ITIMER_REAL: convert to use struct pid
From: Oleg Nesterov <oleg@tv-sign.ru>

signal_struct->tsk points to the ->group_leader and thus we have the nasty
code in de_thread() which has to change it and restart ->real_timer if the
leader is changed.

Use "struct pid *leader_pid" instead.  This also allows us to kill now
unneeded send_group_sig_info().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |   22 ++--------------------
 include/linux/sched.h |    3 +--
 kernel/fork.c         |    2 +-
 kernel/itimer.c       |    2 +-
 kernel/signal.c       |   14 --------------
 5 files changed, 5 insertions(+), 38 deletions(-)

diff -puN fs/exec.c~itimer_real-convert-to-use-struct-pid fs/exec.c
--- a/fs/exec.c~itimer_real-convert-to-use-struct-pid
+++ a/fs/exec.c
@@ -782,26 +782,8 @@ static int de_thread(struct task_struct 
 	zap_other_threads(tsk);
 	read_unlock(&tasklist_lock);
 
-	/*
-	 * Account for the thread group leader hanging around:
-	 */
-	count = 1;
-	if (!thread_group_leader(tsk)) {
-		count = 2;
-		/*
-		 * The SIGALRM timer survives the exec, but needs to point
-		 * at us as the new group leader now.  We have a race with
-		 * a timer firing now getting the old leader, so we need to
-		 * synchronize with any firing (by calling del_timer_sync)
-		 * before we can safely let the old group leader die.
-		 */
-		sig->tsk = tsk;
-		spin_unlock_irq(lock);
-		if (hrtimer_cancel(&sig->real_timer))
-			hrtimer_restart(&sig->real_timer);
-		spin_lock_irq(lock);
-	}
-
+	/* Account for the thread group leader hanging around: */
+	count = thread_group_leader(tsk) ? 1 : 2;
 	sig->notify_count = count;
 	while (atomic_read(&sig->count) > count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
diff -puN include/linux/sched.h~itimer_real-convert-to-use-struct-pid include/linux/sched.h
--- a/include/linux/sched.h~itimer_real-convert-to-use-struct-pid
+++ a/include/linux/sched.h
@@ -460,7 +460,7 @@ struct signal_struct {
 
 	/* ITIMER_REAL timer for the process */
 	struct hrtimer real_timer;
-	struct task_struct *tsk;
+	struct pid *leader_pid;
 	ktime_t it_real_incr;
 
 	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
@@ -1686,7 +1686,6 @@ extern void block_all_signals(int (*noti
 extern void unblock_all_signals(void);
 extern void release_task(struct task_struct * p);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
-extern int send_group_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
diff -puN kernel/fork.c~itimer_real-convert-to-use-struct-pid kernel/fork.c
--- a/kernel/fork.c~itimer_real-convert-to-use-struct-pid
+++ a/kernel/fork.c
@@ -909,7 +909,6 @@ static int copy_signal(unsigned long clo
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
-	sig->tsk = tsk;
 
 	sig->it_virt_expires = cputime_zero;
 	sig->it_virt_incr = cputime_zero;
@@ -1338,6 +1337,7 @@ static struct task_struct *copy_process(
 			if (clone_flags & CLONE_NEWPID)
 				p->nsproxy->pid_ns->child_reaper = p;
 
+			p->signal->leader_pid = pid;
 			p->signal->tty = current->signal->tty;
 			set_task_pgrp(p, task_pgrp_nr(current));
 			set_task_session(p, task_session_nr(current));
diff -puN kernel/itimer.c~itimer_real-convert-to-use-struct-pid kernel/itimer.c
--- a/kernel/itimer.c~itimer_real-convert-to-use-struct-pid
+++ a/kernel/itimer.c
@@ -132,7 +132,7 @@ enum hrtimer_restart it_real_fn(struct h
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
-	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
+	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
 
 	return HRTIMER_NORESTART;
 }
diff -puN kernel/signal.c~itimer_real-convert-to-use-struct-pid kernel/signal.c
--- a/kernel/signal.c~itimer_real-convert-to-use-struct-pid
+++ a/kernel/signal.c
@@ -1205,20 +1205,6 @@ send_sig(int sig, struct task_struct *p,
 	return send_sig_info(sig, __si_special(priv), p);
 }
 
-/*
- * This is the entry point for "process-wide" signals.
- * They will go to an appropriate thread in the thread group.
- */
-int
-send_group_sig_info(int sig, struct siginfo *info, struct task_struct *p)
-{
-	int ret;
-	read_lock(&tasklist_lock);
-	ret = group_send_sig_info(sig, info, p);
-	read_unlock(&tasklist_lock);
-	return ret;
-}
-
 void
 force_sig(int sig, struct task_struct *p)
 {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
