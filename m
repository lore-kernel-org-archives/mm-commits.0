From: akpm@linux-foundation.org
Subject: + ptrace_stop-fix-the-race-with-ptrace-detachattach.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:17:53 -0800
Message-ID: <200711270517.lAR5HrEL028607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbXK0FSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, rolandd@cisco.com


The patch titled
     ptrace_stop: fix the race with ptrace detach+attach
has been added to the -mm tree.  Its filename is
     ptrace_stop-fix-the-race-with-ptrace-detachattach.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ptrace_stop: fix the race with ptrace detach+attach
From: Oleg Nesterov <oleg@tv-sign.ru>

If the tracer went away (may_ptrace_stop() failed), ptrace_stop() drops
tasklist and then changes the ->state from TASK_TRACED to TASK_RUNNING.

This can fool another tracer which attaches to us in between.  Change the
->state under tasklist_lock to ensure that ptrace_check_attach() can't wrongly
succeed.  Also, remove the unnecessary mb().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~ptrace_stop-fix-the-race-with-ptrace-detachattach kernel/signal.c
--- a/kernel/signal.c~ptrace_stop-fix-the-race-with-ptrace-detachattach
+++ a/kernel/signal.c
@@ -1628,11 +1628,11 @@ static void ptrace_stop(int exit_code, i
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.
-		 * Don't stop here.
+		 * Don't drop the lock yet, another tracer may come.
 		 */
-		read_unlock(&tasklist_lock);
-		set_current_state(TASK_RUNNING);
+		__set_current_state(TASK_RUNNING);
 		current->exit_code = nostop_code;
+		read_unlock(&tasklist_lock);
 	}
 
 	/*
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
