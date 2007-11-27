From: akpm@linux-foundation.org
Subject: + wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:15:26 -0800
Message-ID: <200711270715.lAR7FQWm032711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbXK0HQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     wait_task_continued/zombie: don't use task_pid_nr_ns() lockless
has been added to the -mm tree.  Its filename is
     wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_continued/zombie: don't use task_pid_nr_ns() lockless
From: Oleg Nesterov <oleg@tv-sign.ru>

Surprise, other 2 wait_task_() functions also abuse task_pid_nr_ns().  May
cause read-after-free or report nr == 0 in wait_task_continued(). 
wait_task_zombie() doesn't have this problem, but still it is better to cache
pid_t rather than call task_pid_nr_ns() 3 times on the saved pid_namespace.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless kernel/exit.c
--- a/kernel/exit.c~wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless
+++ a/kernel/exit.c
@@ -1186,12 +1186,9 @@ static int wait_task_zombie(struct task_
 {
 	unsigned long state;
 	int retval, status, traced;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
+	pid_t pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 
 	if (unlikely(noreap)) {
-		pid_t pid = task_pid_nr_ns(p, ns);
 		uid_t uid = p->uid;
 		int exit_code = p->exit_code;
 		int why, status;
@@ -1310,11 +1307,11 @@ static int wait_task_zombie(struct task_
 			retval = put_user(status, &infop->si_status);
 	}
 	if (!retval && infop)
-		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
+		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
 	if (!retval)
-		retval = task_pid_nr_ns(p, ns);
+		retval = pid;
 
 	if (traced) {
 		write_lock_irq(&tasklist_lock);
@@ -1433,7 +1430,6 @@ static int wait_task_continued(struct ta
 	int retval;
 	pid_t pid;
 	uid_t uid;
-	struct pid_namespace *ns;
 
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
@@ -1448,8 +1444,7 @@ static int wait_task_continued(struct ta
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
-	ns = current->nsproxy->pid_ns;
-	pid = task_pid_nr_ns(p, ns);
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	uid = p->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
@@ -1460,7 +1455,7 @@ static int wait_task_continued(struct ta
 		if (!retval && stat_addr)
 			retval = put_user(0xffff, stat_addr);
 		if (!retval)
-			retval = task_pid_nr_ns(p, ns);
+			retval = pid;
 	} else {
 		retval = wait_noreap_copyout(p, pid, uid,
 					     CLD_CONTINUED, SIGCONT,
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
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
