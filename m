From: akpm@linux-foundation.org
Subject: + wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:15:30 -0800
Message-ID: <200711270715.lAR7FUEf032714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbXK0HQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     wait_task_zombie: remove ->exit_state/exit_signal checks for WNOWAIT
has been added to the -mm tree.  Its filename is
     wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_zombie: remove ->exit_state/exit_signal checks for WNOWAIT
From: Oleg Nesterov <oleg@tv-sign.ru>

The first "p->exit_state != EXIT_ZOMBIE" check doesn't make too much sense. 
The exit_state was EXIT_ZOMBIE when the function was called, and another
thread can change it to EXIT_DEAD right after the check.

The second condition is not possible, detached non-traced threads were already
filtered out by eligible_child(), we didn't drop tasklist since then.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/exit.c~wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait kernel/exit.c
--- a/kernel/exit.c~wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait
+++ a/kernel/exit.c
@@ -1193,10 +1193,6 @@ static int wait_task_zombie(struct task_
 		int exit_code = p->exit_code;
 		int why, status;
 
-		if (unlikely(p->exit_state != EXIT_ZOMBIE))
-			return 0;
-		if (unlikely(p->exit_signal == -1 && p->ptrace == 0))
-			return 0;
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
 		if ((exit_code & 0x7f) == 0) {
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
