From: akpm@linux-foundation.org
Subject: [merged] oom-only-oom-kill-exiting-tasks-with-attached-memory.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:32 -0700
Message-ID: <200906171836.n5HIaWMX002649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760282AbZFQSws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     oom: only oom kill exiting tasks with attached memory
has been removed from the -mm tree.  Its filename was
     oom-only-oom-kill-exiting-tasks-with-attached-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: only oom kill exiting tasks with attached memory
From: David Rientjes <rientjes@google.com>

When a task is chosen for oom kill and is found to be PF_EXITING,
__oom_kill_task() is called to elevate the task's timeslice and give it
access to memory reserves so that it may quickly exit.

This privilege is unnecessary, however, if the task has already detached
its mm.  Although its possible for the mm to become detached later since
task_lock() is not held, __oom_kill_task() will simply be a no-op in such
circumstances.

Subsequently, it is no longer necessary to warn about killing mm-less
tasks since it is a no-op.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~oom-only-oom-kill-exiting-tasks-with-attached-memory mm/oom_kill.c
--- a/mm/oom_kill.c~oom-only-oom-kill-exiting-tasks-with-attached-memory
+++ a/mm/oom_kill.c
@@ -325,11 +325,8 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
-	if (!p->mm) {
-		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill an mm-less task!\n");
+	if (!p->mm)
 		return;
-	}
 
 	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s)\n",
@@ -397,8 +394,9 @@ static int oom_kill_process(struct task_
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
+	 * if its mm is still attached.
 	 */
-	if (p->flags & PF_EXITING) {
+	if (p->mm && (p->flags & PF_EXITING)) {
 		__oom_kill_task(p, 0);
 		return 0;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

