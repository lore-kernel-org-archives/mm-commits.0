From: akpm@linux-foundation.org
Subject: + do_wait-remove-one-else-if-branch.patch added to -mm tree
Date: Tue, 20 Nov 2007 13:04:39 -0800
Message-ID: <200711202104.lAKL4d7R023430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbXKTVF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 16:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     do_wait: remove one "else if" branch
has been added to the -mm tree.  Its filename is
     do_wait-remove-one-else-if-branch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_wait: remove one "else if" branch
From: Oleg Nesterov <oleg@tv-sign.ru>

Minor cleanup. We can remove one "else if" branch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/exit.c~do_wait-remove-one-else-if-branch kernel/exit.c
--- a/kernel/exit.c~do_wait-remove-one-else-if-branch
+++ a/kernel/exit.c
@@ -1563,8 +1563,6 @@ repeat:
 					goto repeat;
 				if (retval != 0) /* He released the lock.  */
 					goto end;
-			} else if (p->exit_state == EXIT_DEAD) {
-				continue;
 			} else if (p->exit_state == EXIT_ZOMBIE) {
 				/*
 				 * Eligible but we cannot release it yet:
@@ -1579,7 +1577,7 @@ repeat:
 				/* He released the lock.  */
 				if (retval != 0)
 					goto end;
-			} else {
+			} else if (p->exit_state != EXIT_DEAD) {
 check_continued:
 				/*
 				 * It's running now, so it might later
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
kill-pt_ptraced.patch
kill-my_ptrace_child.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
