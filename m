From: akpm@linux-foundation.org
Subject: - wait_task_stopped-remove-unneeded-delay_group_leader-check.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:38 -0800
Message-ID: <200802082013.m18KDJpL010283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbYBHU6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mika.penttila@kolumbus.fi, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_stopped(): remove unneeded delay_group_leader check
has been removed from the -mm tree.  Its filename was
     wait_task_stopped-remove-unneeded-delay_group_leader-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_stopped(): remove unneeded delay_group_leader check
From: Oleg Nesterov <oleg@tv-sign.ru>

wait_task_stopped() doesn't need the "delay_group_leader" parameter.  If
the child is not traced it must be a group leader.  With or without
subthreads ->group_stop_count == 0 when the whole task is stopped.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Mika Penttila <mika.penttila@kolumbus.fi>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~wait_task_stopped-remove-unneeded-delay_group_leader-check kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-remove-unneeded-delay_group_leader-check
+++ a/kernel/exit.c
@@ -1351,7 +1351,7 @@ static int wait_task_zombie(struct task_
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
+static int wait_task_stopped(struct task_struct *p,
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1365,8 +1365,7 @@ static int wait_task_stopped(struct task
 	if (unlikely(!task_is_stopped_or_traced(p)))
 		goto unlock_sig;
 
-	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
-	    p->signal->group_stop_count > 0)
+	if (!(p->ptrace & PT_PTRACED) && p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
@@ -1522,7 +1521,7 @@ repeat:
 				    !(options & WUNTRACED))
 					continue;
 
-				retval = wait_task_stopped(p, ret == 2,
+				retval = wait_task_stopped(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
 			} else if (p->exit_state == EXIT_ZOMBIE) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
