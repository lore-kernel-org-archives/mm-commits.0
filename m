From: akpm@linux-foundation.org
Subject: + wait_task_stopped-remove-unneeded-delay_group_leader-check.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:05:15 -0800
Message-ID: <200711270705.lAR75FJc032336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbXK0HGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:06:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mika.penttila@kolumbus.fi, roland@redhat.com


The patch titled
     wait_task_stopped(): remove unneeded delay_group_leader check
has been added to the -mm tree.  Its filename is
     wait_task_stopped-remove-unneeded-delay_group_leader-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_stopped(): remove unneeded delay_group_leader check
From: Oleg Nesterov <oleg@tv-sign.ru>

wait_task_stopped() doesn't need the "delay_group_leader" parameter.  If
the child is not traced it must be a group leader.  With or without
subthreads ->group_stop_count == 0 when the whole task is stopped.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Mika Penttila <mika.penttila@kolumbus.fi>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~wait_task_stopped-remove-unneeded-delay_group_leader-check kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-remove-unneeded-delay_group_leader-check
+++ a/kernel/exit.c
@@ -1348,7 +1348,7 @@ static int wait_task_zombie(struct task_
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
+static int wait_task_stopped(struct task_struct *p,
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1362,8 +1362,7 @@ static int wait_task_stopped(struct task
 	if (unlikely(!is_task_stopped_or_traced(p)))
 		goto unlock_sig;
 
-	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
-	    p->signal->group_stop_count > 0)
+	if (!(p->ptrace & PT_PTRACED) && p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
@@ -1519,7 +1518,7 @@ repeat:
 				    !(options & WUNTRACED))
 					continue;
 
-				retval = wait_task_stopped(p, ret == 2,
+				retval = wait_task_stopped(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
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
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
