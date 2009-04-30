From: akpm@linux-foundation.org
Subject: + oom-prevent-livelock-when-oom_kill_allocating_task-is-set.patch added to -mm tree
Date: Thu, 30 Apr 2009 15:50:14 -0700
Message-ID: <200904302250.n3UMoEUd006948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbZD3WwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 18:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, npiggin@suse.de


The patch titled
     oom: prevent livelock when oom_kill_allocating_task is set
has been added to the -mm tree.  Its filename is
     oom-prevent-livelock-when-oom_kill_allocating_task-is-set.patch

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

memcg-fix-mem_cgroup_shrink_usage.patch
mm-prevent-divide-error-for-small-values-of-vm_dirty_bytes.patch
linux-next.patch
oom-prevent-livelock-when-oom_kill_allocating_task-is-set.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

