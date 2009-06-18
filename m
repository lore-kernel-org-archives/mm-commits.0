From: akpm@linux-foundation.org
Subject: [merged] do_wait-simplify-retval-tsk_result-notask_error-mess.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:58 -0700
Message-ID: <200906182246.n5IMkwq2006058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758594AbZFRW6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait: simplify retval/tsk_result/notask_error mess
has been removed from the -mm tree.  Its filename was
     do_wait-simplify-retval-tsk_result-notask_error-mess.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait: simplify retval/tsk_result/notask_error mess
From: Oleg Nesterov <oleg@redhat.com>

Now that we don't pass &retval down to other helpers we can simplify
the code more.

- kill tsk_result, just use retval

- add the "notask" label right after the main loop, and
  s/got end/goto notask/ after the fastpath pid check.

  This way we don't need to initialize retval before this
  check and the code becomes a bit more clean, if this pid
  has no attached tasks we should just skip the list search.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN kernel/exit.c~do_wait-simplify-retval-tsk_result-notask_error-mess kernel/exit.c
--- a/kernel/exit.c~do_wait-simplify-retval-tsk_result-notask_error-mess
+++ a/kernel/exit.c
@@ -1576,27 +1576,22 @@ repeat:
 	 * might later match our criteria, even if we are not able to reap
 	 * it yet.
 	 */
-	retval = wo->notask_error = -ECHILD;
+	wo->notask_error = -ECHILD;
 	if ((wo->wo_type < PIDTYPE_MAX) &&
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
-		goto end;
+		goto notask;
 
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		int tsk_result = do_wait_thread(wo, tsk);
-
-		if (!tsk_result)
-			tsk_result = ptrace_do_wait(wo, tsk);
+		retval = do_wait_thread(wo, tsk);
+		if (retval)
+			goto end;
 
-		if (tsk_result) {
-			/*
-			 * tasklist_lock is unlocked and we have a final result.
-			 */
-			retval = tsk_result;
+		retval = ptrace_do_wait(wo, tsk);
+		if (retval)
 			goto end;
-		}
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
@@ -1605,6 +1600,7 @@ repeat:
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
+notask:
 	retval = wo->notask_error;
 	if (!retval && !(wo->wo_flags & WNOHANG)) {
 		retval = -ERESTARTSYS;
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

