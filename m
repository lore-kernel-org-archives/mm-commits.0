From: akpm@linux-foundation.org
Subject: [merged] mm-oom-introduce-helper-function-to-process-threads-during-scan.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:06 -0700
Message-ID: <20120801201507.2728A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:60388 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HAUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:09 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so345221bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: introduce helper function to process threads during scan
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-helper-function-to-process-threads-during-scan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: introduce helper function to process threads during scan

This patch introduces a helper function to process each thread during the
iteration over the tasklist.  A new return type, enum oom_scan_t, is
defined to determine the future behavior of the iteration:

 - OOM_SCAN_OK: continue scanning the thread and find its badness,

 - OOM_SCAN_CONTINUE: do not consider this thread for oom kill, it's
   ineligible,

 - OOM_SCAN_ABORT: abort the iteration and return, or

 - OOM_SCAN_SELECT: always select this thread with the highest badness
   possible.

There is no functional change with this patch.  This new helper function
will be used in the next patch in the memory controller.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |  111 ++++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 46 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-introduce-helper-function-to-process-threads-during-scan mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-helper-function-to-process-threads-during-scan
+++ a/mm/oom_kill.c
@@ -288,6 +288,59 @@ static enum oom_constraint constrained_a
 }
 #endif
 
+enum oom_scan_t {
+	OOM_SCAN_OK,		/* scan thread and find its badness */
+	OOM_SCAN_CONTINUE,	/* do not consider thread for oom kill */
+	OOM_SCAN_ABORT,		/* abort the iteration and return */
+	OOM_SCAN_SELECT,	/* always select this thread first */
+};
+
+static enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
+		struct mem_cgroup *memcg, unsigned long totalpages,
+		const nodemask_t *nodemask, bool force_kill)
+{
+	if (task->exit_state)
+		return OOM_SCAN_CONTINUE;
+	if (oom_unkillable_task(task, memcg, nodemask))
+		return OOM_SCAN_CONTINUE;
+
+	/*
+	 * This task already has access to memory reserves and is being killed.
+	 * Don't allow any other task to have access to the reserves.
+	 */
+	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
+		if (unlikely(frozen(task)))
+			__thaw_task(task);
+		if (!force_kill)
+			return OOM_SCAN_ABORT;
+	}
+	if (!task->mm)
+		return OOM_SCAN_CONTINUE;
+
+	if (task->flags & PF_EXITING) {
+		/*
+		 * If task is current and is in the process of releasing memory,
+		 * allow the "kill" to set TIF_MEMDIE, which will allow it to
+		 * access memory reserves.  Otherwise, it may stall forever.
+		 *
+		 * The iteration isn't broken here, however, in case other
+		 * threads are found to have already been oom killed.
+		 */
+		if (task == current)
+			return OOM_SCAN_SELECT;
+		else if (!force_kill) {
+			/*
+			 * If this task is not being ptraced on exit, then wait
+			 * for it to finish before killing some other task
+			 * unnecessarily.
+			 */
+			if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
+				return OOM_SCAN_ABORT;
+		}
+	}
+	return OOM_SCAN_OK;
+}
+
 /*
  * Simple selection loop. We chose the process with the highest
  * number of 'points'. We expect the caller will lock the tasklist.
@@ -305,53 +358,19 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
-		if (p->exit_state)
-			continue;
-		if (oom_unkillable_task(p, memcg, nodemask))
-			continue;
-
-		/*
-		 * This task already has access to memory reserves and is
-		 * being killed. Don't allow any other task access to the
-		 * memory reserve.
-		 *
-		 * Note: this may have a chance of deadlock if it gets
-		 * blocked waiting for another task which itself is waiting
-		 * for memory. Is there a better alternative?
-		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
-			if (unlikely(frozen(p)))
-				__thaw_task(p);
-			if (!force_kill)
-				return ERR_PTR(-1UL);
-		}
-		if (!p->mm)
+		switch (oom_scan_process_thread(p, memcg, totalpages, nodemask,
+						force_kill)) {
+		case OOM_SCAN_SELECT:
+			chosen = p;
+			chosen_points = ULONG_MAX;
+			/* fall through */
+		case OOM_SCAN_CONTINUE:
 			continue;
-
-		if (p->flags & PF_EXITING) {
-			/*
-			 * If p is the current task and is in the process of
-			 * releasing memory, we allow the "kill" to set
-			 * TIF_MEMDIE, which will allow it to gain access to
-			 * memory reserves.  Otherwise, it may stall forever.
-			 *
-			 * The loop isn't broken here, however, in case other
-			 * threads are found to have already been oom killed.
-			 */
-			if (p == current) {
-				chosen = p;
-				chosen_points = ULONG_MAX;
-			} else if (!force_kill) {
-				/*
-				 * If this task is not being ptraced on exit,
-				 * then wait for it to finish before killing
-				 * some other task unnecessarily.
-				 */
-				if (!(p->group_leader->ptrace & PT_TRACE_EXIT))
-					return ERR_PTR(-1UL);
-			}
-		}
