From: akpm@linux-foundation.org
Subject: + oom-remove-special-handling-for-pagefault-ooms.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:21:38 -0700
Message-ID: <201003222021.o2MKLcI2025194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714Ab0CVUWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: remove special handling for pagefault ooms
has been added to the -mm tree.  Its filename is
     oom-remove-special-handling-for-pagefault-ooms.patch

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
Subject: oom: remove special handling for pagefault ooms
From: David Rientjes <rientjes@google.com>

It is possible to remove the special pagefault oom handler by simply oom
locking all system zones and then calling directly into out_of_memory().

All populated zones must have ZONE_OOM_LOCKED set, otherwise there is a
parallel oom killing in progress that will lead to eventual memory freeing
so it's not necessary to needlessly kill another task.  The context in
which the pagefault is allocating memory is unknown to the oom killer, so
this is done on a system-wide level.

If a task has already been oom killed and hasn't fully exited yet, this
will be a no-op since select_bad_process() recognizes tasks across the
system with TIF_MEMDIE set.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   91 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 32 deletions(-)

diff -puN mm/oom_kill.c~oom-remove-special-handling-for-pagefault-ooms mm/oom_kill.c
--- a/mm/oom_kill.c~oom-remove-special-handling-for-pagefault-ooms
+++ a/mm/oom_kill.c
@@ -582,6 +582,44 @@ void clear_zonelist_oom(struct zonelist 
 }
 
 /*
+ * Try to acquire the oom killer lock for all system zones.  Returns zero if a
+ * parallel oom killing is taking place, otherwise locks all zones and returns
+ * non-zero.
+ */
+static int try_set_system_oom(void)
+{
+	struct zone *zone;
+	int ret = 1;
+
+	spin_lock(&zone_scan_lock);
+	for_each_populated_zone(zone)
+		if (zone_is_oom_locked(zone)) {
+			ret = 0;
+			goto out;
+		}
+	for_each_populated_zone(zone)
+		zone_set_flag(zone, ZONE_OOM_LOCKED);
+out:
+	spin_unlock(&zone_scan_lock);
+	return ret;
+}
+
+/*
+ * Clears ZONE_OOM_LOCKED for all system zones so that failed allocation
+ * attempts or page faults may now recall the oom killer, if necessary.
+ */
+static void clear_system_oom(void)
+{
+	struct zone *zone;
+
+	spin_lock(&zone_scan_lock);
+	for_each_populated_zone(zone)
+		zone_clear_flag(zone, ZONE_OOM_LOCKED);
+	spin_unlock(&zone_scan_lock);
+}
+
+
+/*
  * Must be called with tasklist_lock held for read.
  */
 static void __out_of_memory(gfp_t gfp_mask, int order,
@@ -616,38 +654,9 @@ retry:
 		goto retry;
 }
 
-/*
- * pagefault handler calls into here because it is out of memory but
- * doesn't know exactly how or why.
- */
-void pagefault_out_of_memory(void)
-{
-	unsigned long freed = 0;
-
-	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
-	if (freed > 0)
-		/* Got some memory back in the last second. */
-		return;
-
-	if (sysctl_panic_on_oom)
-		panic("out of memory from page fault. panic_on_oom is selected.\n");
-
-	read_lock(&tasklist_lock);
-	/* unknown gfp_mask and order */
-	__out_of_memory(0, 0, CONSTRAINT_NONE, NULL);
-	read_unlock(&tasklist_lock);
-
-	/*
-	 * Give "p" a good chance of killing itself before we
-	 * retry to allocate memory.
-	 */
-	if (!test_thread_flag(TIF_MEMDIE))
-		schedule_timeout_uninterruptible(1);
-}
-
 /**
  * out_of_memory - kill the "best" process when we run out of memory
- * @zonelist: zonelist pointer
+ * @zonelist: zonelist pointer passed to page allocator
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
  * @nodemask: nodemask passed to page allocator
@@ -661,7 +670,7 @@ void out_of_memory(struct zonelist *zone
 		int order, nodemask_t *nodemask)
 {
 	unsigned long freed = 0;
-	enum oom_constraint constraint;
+	enum oom_constraint constraint = CONSTRAINT_NONE;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -677,7 +686,8 @@ void out_of_memory(struct zonelist *zone
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
+	if (zonelist)
+		constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
 	read_lock(&tasklist_lock);
 	if (unlikely(sysctl_panic_on_oom)) {
 		/*
@@ -687,6 +697,7 @@ void out_of_memory(struct zonelist *zone
 		 */
 		if (constraint == CONSTRAINT_NONE) {
 			dump_header(NULL, gfp_mask, order, NULL);
+			read_unlock(&tasklist_lock);
 			panic("Out of memory: panic_on_oom is enabled\n");
 		}
 	}
@@ -700,3 +711,19 @@ void out_of_memory(struct zonelist *zone
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
+
+/*
+ * The pagefault handler calls here because it is out of memory, so kill a
+ * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
+ * oom killing is already in progress so do nothing.  If a task is found with
+ * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
+ */
+void pagefault_out_of_memory(void)
+{
+	if (try_set_system_oom()) {
+		out_of_memory(NULL, 0, 0, NULL);
+		clear_system_oom();
+	}
+	if (!test_thread_flag(TIF_MEMDIE))
+		schedule_timeout_uninterruptible(1);
+}
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

