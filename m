From: akpm@linux-foundation.org
Subject: [merged] oom-prevent-livelock-when-oom_kill_allocating_task-is-set.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:04 -0700
Message-ID: <200905071916.n47JG4P1020040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbZEGTS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     oom: prevent livelock when oom_kill_allocating_task is set
has been removed from the -mm tree.  Its filename was
     oom-prevent-livelock-when-oom_kill_allocating_task-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: prevent livelock when oom_kill_allocating_task is set
From: David Rientjes <rientjes@google.com>

When /proc/sys/vm/oom_kill_allocating_task is set for large systems that
want to avoid the lengthy tasklist scan, it's possible to livelock if
current is ineligible for oom kill.  This normally happens when it is set
to OOM_DISABLE, but is also possible if any threads are sharing the same
->mm with a different tgid.

So change __out_of_memory() to fall back to the full task-list scan if it
was unable to kill `current'.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff -puN mm/oom_kill.c~oom-prevent-livelock-when-oom_kill_allocating_task-is-set mm/oom_kill.c
--- a/mm/oom_kill.c~oom-prevent-livelock-when-oom_kill_allocating_task-is-set
+++ a/mm/oom_kill.c
@@ -514,34 +514,32 @@ void clear_zonelist_oom(struct zonelist 
  */
 static void __out_of_memory(gfp_t gfp_mask, int order)
 {
-	if (sysctl_oom_kill_allocating_task) {
-		oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"Out of memory (oom_kill_allocating_task)");
-
-	} else {
-		unsigned long points;
-		struct task_struct *p;
+	struct task_struct *p;
+	unsigned long points;
 
+	if (sysctl_oom_kill_allocating_task)
+		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
+				"Out of memory (oom_kill_allocating_task)"))
+			return;
 retry:
-		/*
-		 * Rambo mode: Shoot down a process and hope it solves whatever
-		 * issues we may have.
-		 */
-		p = select_bad_process(&points, NULL);
+	/*
+	 * Rambo mode: Shoot down a process and hope it solves whatever
+	 * issues we may have.
+	 */
+	p = select_bad_process(&points, NULL);
 
-		if (PTR_ERR(p) == -1UL)
-			return;
+	if (PTR_ERR(p) == -1UL)
+		return;
 
-		/* Found nothing?!?! Either we hang forever, or we panic. */
-		if (!p) {
-			read_unlock(&tasklist_lock);
-			panic("Out of memory and no killable processes...\n");
-		}
-
-		if (oom_kill_process(p, gfp_mask, order, points, NULL,
-				     "Out of memory"))
-			goto retry;
+	/* Found nothing?!?! Either we hang forever, or we panic. */
+	if (!p) {
+		read_unlock(&tasklist_lock);
+		panic("Out of memory and no killable processes...\n");
 	}
+
+	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+			     "Out of memory"))
+		goto retry;
 }
 
 /*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-srat-do-not-register-nodes-beyond-e820-map.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

