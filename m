From: akpm@linux-foundation.org
Subject: - do_wait-cleanup-delay_group_leader-usage.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:41 -0800
Message-ID: <200802082013.m18KDMWT010286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763218AbYBHVDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, eparis@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     do_wait: cleanup delay_group_leader() usage
has been removed from the -mm tree.  Its filename was
     do_wait-cleanup-delay_group_leader-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1140,12 +1140,6 @@ static int eligible_child(pid_t pid, int
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
@@ -1497,10 +1491,9 @@ repeat:
 	tsk = current;
 	do {
 		struct task_struct *p;
-		int ret;
 
 		list_for_each_entry(p, &tsk->children, sibling) {
-			ret = eligible_child(pid, options, p);
+			int ret = eligible_child(pid, options, p);
 			if (!ret)
 				continue;
 
@@ -1524,19 +1517,17 @@ repeat:
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

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
