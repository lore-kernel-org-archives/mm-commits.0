From: akpm@linux-foundation.org
Subject: + oom-filter-tasks-not-sharing-the-same-cpuset.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:21:26 -0700
Message-ID: <201003222021.o2MKLQmq025185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769Ab0CVUWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: filter tasks not sharing the same cpuset
has been added to the -mm tree.  Its filename is
     oom-filter-tasks-not-sharing-the-same-cpuset.patch

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
Subject: oom: filter tasks not sharing the same cpuset
From: David Rientjes <rientjes@google.com>

Tasks that do not share the same set of allowed nodes with the task that
triggered the oom should not be considered as candidates for oom kill.

Tasks in other cpusets with a disjoint set of mems would be unfairly
penalized otherwise because of oom conditions elsewhere; an extreme
example could unfairly kill all other applications on the system if a
single task in a user's cpuset sets itself to OOM_DISABLE and then uses
more memory than allowed.

Killing tasks outside of current's cpuset rarely would free memory for
current anyway.  To use a sane heuristic, we must ensure that killing a
task would likely free memory for current and avoid needlessly killing
others at all costs just because their potential memory freeing is
unknown.  It is better to kill current than another task needlessly.

Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN mm/oom_kill.c~oom-filter-tasks-not-sharing-the-same-cpuset mm/oom_kill.c
--- a/mm/oom_kill.c~oom-filter-tasks-not-sharing-the-same-cpuset
+++ a/mm/oom_kill.c
@@ -35,7 +35,7 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
 /*
- * Is all threads of the target process nodes overlap ours?
+ * Do all threads of the target process overlap our allowed nodes?
  */
 static int has_intersects_mems_allowed(struct task_struct *tsk)
 {
@@ -167,14 +167,6 @@ unsigned long badness(struct task_struct
 		points /= 4;
 
 	/*
-	 * If p's nodes don't overlap ours, it may still help to kill p
-	 * because p may have allocated or otherwise mapped memory on
-	 * this node before. However it will be less likely.
-	 */
-	if (!has_intersects_mems_allowed(p))
-		points /= 8;
-
-	/*
 	 * Adjust the score by oom_adj.
 	 */
 	if (oom_adj) {
@@ -266,6 +258,8 @@ static struct task_struct *select_bad_pr
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
+		if (!has_intersects_mems_allowed(p))
+			continue;
 
 		/*
 		 * This task already has access to memory reserves and is
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

