From: akpm@linux-foundation.org
Subject: + oom-only-oom-kill-exiting-tasks-with-attached-memory.patch added to -mm tree
Date: Tue, 09 Jun 2009 14:29:22 -0700
Message-ID: <200906092129.n59LTMKV016682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbZFIWDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 18:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     oom: only oom kill exiting tasks with attached memory
has been added to the -mm tree.  Its filename is
     oom-only-oom-kill-exiting-tasks-with-attached-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
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

linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct-fix.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
oom-only-oom-kill-exiting-tasks-with-attached-memory.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

