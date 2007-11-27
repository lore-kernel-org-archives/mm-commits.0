From: akpm@linux-foundation.org
Subject: + do_wait-cleanup-delay_group_leader-usage.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:06:41 -0800
Message-ID: <200711270706.lAR76fc7032347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbXK0HHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, eparis@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov


The patch titled
     do_wait: cleanup delay_group_leader() usage
has been added to the -mm tree.  Its filename is
     do_wait-cleanup-delay_group_leader-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_wait: cleanup delay_group_leader() usage
From: Oleg Nesterov <oleg@tv-sign.ru>

eligible_child() == 2 means delay_group_leader().  With the previous patch
this only matters for EXIT_ZOMBIE task, we can move that special check to
the only place it is really needed.

Also, with this patch we don't skip security_task_wait() for the group
leaders in a non-empty thread group.  I don't really understand the exact
semantics of security_task_wait(), but imho this change is a bugfix.

Also rearrange the code a bit to kill an ugly "check_continued" backdoor.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~do_wait-cleanup-delay_group_leader-usage kernel/exit.c
--- a/kernel/exit.c~do_wait-cleanup-delay_group_leader-usage
+++ a/kernel/exit.c
@@ -1137,12 +1137,6 @@ static int eligible_child(pid_t pid, int
 	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
 	    && !(options & __WALL))
 		return 0;
-	/*
-	 * Do not consider thread group leaders that are
-	 * in a non-empty thread group:
-	 */
-	if (delay_group_leader(p))
-		return 2;
 
 	err = security_task_wait(p);
 	if (err)
@@ -1494,10 +1488,9 @@ repeat:
 	tsk = current;
 	do {
 		struct task_struct *p;
-		int ret;
 
 		list_for_each_entry(p, &tsk->children, sibling) {
-			ret = eligible_child(pid, options, p);
+			int ret = eligible_child(pid, options, p);
 			if (!ret)
 				continue;
 
@@ -1521,19 +1514,17 @@ repeat:
 				retval = wait_task_stopped(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-			} else if (p->exit_state == EXIT_ZOMBIE) {
+			} else if (p->exit_state == EXIT_ZOMBIE &&
+					!delay_group_leader(p)) {
 				/*
-				 * Eligible but we cannot release it yet:
+				 * We don't reap group leaders with subthreads.
 				 */
-				if (ret == 2)
-					goto check_continued;
 				if (!likely(options & WEXITED))
 					continue;
 				retval = wait_task_zombie(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
 			} else if (p->exit_state != EXIT_DEAD) {
-check_continued:
 				/*
 				 * It's running now, so it might later
 				 * exit, stop, or stop and then continue.
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
