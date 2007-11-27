From: akpm@linux-foundation.org
Subject: + ptrace_check_attach-remove-unneeded-signal-=-null-check.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:20:10 -0800
Message-ID: <200711270420.lAR4KAdp026579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbXK0EVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, hch@lst.de, roland@redhat.com


The patch titled
     ptrace_check_attach: remove unneeded ->signal != NULL check
has been added to the -mm tree.  Its filename is
     ptrace_check_attach-remove-unneeded-signal-=-null-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ptrace_check_attach: remove unneeded ->signal != NULL check
From: Oleg Nesterov <oleg@tv-sign.ru>

It is not possible to see the PT_PTRACED task without ->signal/sighand under
tasklist_lock, release_task() does ptrace_unlink() first.  If the task was
already released before, ptrace_attach() can't succeed and set PT_PTRACED. 
Remove this check.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/ptrace.c~ptrace_check_attach-remove-unneeded-signal-=-null-check kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace_check_attach-remove-unneeded-signal-=-null-check
+++ a/kernel/ptrace.c
@@ -99,9 +99,12 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent == current &&
-	     child->signal != NULL) {
+	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
 		ret = 0;
+		/*
+		 * child->sighand can't be NULL, release_task()
+		 * does ptrace_unlink() before __exit_signal().
+		 */
 		spin_lock_irq(&child->sighand->siglock);
 		if (is_task_stopped(child))
 			__set_task_state(child, TASK_TRACED);
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
