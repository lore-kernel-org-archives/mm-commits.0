From: akpm@linux-foundation.org
Subject: - do_wait-factor-out-retval-=-0-checks.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:34 -0800
Message-ID: <200802082013.m18KDFV0010277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbYBHUuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait: factor out "retval != 0" checks
has been removed from the -mm tree.  Its filename was
     do_wait-factor-out-retval-=-0-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1511,6 +1511,7 @@ repeat:
 			}
 			allowed = 1;
 
+			retval = 0;
 			if (task_is_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
@@ -1524,8 +1525,6 @@ repeat:
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval != 0) /* He released the lock.  */
-					goto end;
 			} else if (p->exit_state == EXIT_ZOMBIE) {
 				/*
 				 * Eligible but we cannot release it yet:
@@ -1537,9 +1536,6 @@ repeat:
 				retval = wait_task_zombie(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				/* He released the lock.  */
-				if (retval != 0)
-					goto end;
 			} else if (p->exit_state != EXIT_DEAD) {
 check_continued:
 				/*
@@ -1552,9 +1548,9 @@ check_continued:
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
@@ -1590,7 +1586,7 @@ end:
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

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
