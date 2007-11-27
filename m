From: akpm@linux-foundation.org
Subject: + do_wait-factor-out-retval-=-0-checks.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:25:03 -0800
Message-ID: <200711270525.lAR5P3B8028911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbXK0F00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:26:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     do_wait: factor out "retval != 0" checks
has been added to the -mm tree.  Its filename is
     do_wait-factor-out-retval-=-0-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_wait: factor out "retval != 0" checks
From: Oleg Nesterov <oleg@tv-sign.ru>

Every branch if the main "if" statement does the same code at the end.  Move
it down.  Also, fix the indentation.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~do_wait-factor-out-retval-=-0-checks kernel/exit.c
--- a/kernel/exit.c~do_wait-factor-out-retval-=-0-checks
+++ a/kernel/exit.c
@@ -1508,6 +1508,7 @@ repeat:
 			}
 			allowed = 1;
 
+			retval = 0;
 			if (is_task_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
@@ -1521,8 +1522,6 @@ repeat:
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval != 0) /* He released the lock.  */
-					goto end;
 			} else if (p->exit_state == EXIT_ZOMBIE) {
 				/*
 				 * Eligible but we cannot release it yet:
@@ -1534,9 +1533,6 @@ repeat:
 				retval = wait_task_zombie(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				/* He released the lock.  */
-				if (retval != 0)
-					goto end;
 			} else if (p->exit_state != EXIT_DEAD) {
 check_continued:
 				/*
@@ -1549,9 +1545,9 @@ check_continued:
 				retval = wait_task_continued(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval != 0) /* He released the lock.  */
-					goto end;
 			}
+			if (retval != 0) /* tasklist_lock released */
+				goto end;
 		}
 		if (!flag) {
 			list_for_each_entry(p, &tsk->ptrace_children,
@@ -1587,7 +1583,7 @@ end:
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
 	if (infop) {
 		if (retval > 0)
-		retval = 0;
+			retval = 0;
 		else {
 			/*
 			 * For a WNOHANG return, clear out all the fields
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
