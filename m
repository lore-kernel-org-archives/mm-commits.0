From: akpm@linux-foundation.org
Subject: [merged] do_wait-fix-the-theoretical-race-with-stop-trace-cont.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:02 -0700
Message-ID: <200906182247.n5IMl2c8006160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759058AbZFRWrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait: fix the theoretical race with stop/trace/cont
has been removed from the -mm tree.  Its filename was
     do_wait-fix-the-theoretical-race-with-stop-trace-cont.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait: fix the theoretical race with stop/trace/cont
From: Oleg Nesterov <oleg@redhat.com>

do_wait:

	current->state = TASK_INTERRUPTIBLE;

	read_lock(&tasklist_lock);
	... search for the task to reap ...

In theory, the ->state changing can leak into the critical section.  Since
the child can change its status under read_lock(tasklist) in parallel
(finish_stop/ptrace_stop), we can miss the wakeup if __wake_up_parent()
sees us in TASK_RUNNING state.  Add the barrier.

Also, use __set_current_state() to set TASK_RUNNING.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~do_wait-fix-the-theoretical-race-with-stop-trace-cont kernel/exit.c
--- a/kernel/exit.c~do_wait-fix-the-theoretical-race-with-stop-trace-cont
+++ a/kernel/exit.c
@@ -1581,7 +1581,7 @@ repeat:
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
 		goto notask;
 
-	current->state = TASK_INTERRUPTIBLE;
+	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
@@ -1608,7 +1608,7 @@ notask:
 		}
 	}
 end:
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
 	if (wo->wo_info) {
 		struct siginfo __user *infop = wo->wo_info;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

