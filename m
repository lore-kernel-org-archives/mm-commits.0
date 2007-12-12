From: akpm@linux-foundation.org
Subject: + itimer_real-convert-to-use-struct-pid.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:13:31 -0800
Message-ID: <200712120513.lBC5DVju026893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbXLLFOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, roland@redhat.com, tglx@linutronix.de, xemul@openvz.org


The patch titled
     ITIMER_REAL: convert to use struct pid
has been added to the -mm tree.  Its filename is
     itimer_real-convert-to-use-struct-pid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -453,7 +453,7 @@ struct signal_struct {
 
 	/* ITIMER_REAL timer for the process */
 	struct hrtimer real_timer;
-	struct task_struct *tsk;
+	struct pid *leader_pid;
 	ktime_t it_real_incr;
 
 	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
@@ -1663,7 +1663,6 @@ extern void block_all_signals(int (*noti
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
@@ -883,7 +883,6 @@ static int copy_signal(unsigned long clo
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
-	sig->tsk = tsk;
 
 	sig->it_virt_expires = cputime_zero;
 	sig->it_virt_incr = cputime_zero;
@@ -1308,6 +1307,7 @@ static struct task_struct *copy_process(
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
@@ -1204,20 +1204,6 @@ send_sig(int sig, struct task_struct *p,
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

__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
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
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
fix-group-stop-with-exit-race.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
