From: akpm@linux-foundation.org
Subject: + memcg-simplify-mem_cgroup_page_stat.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:21:55 -0800
Message-ID: <201011091921.oA9JLtuD002253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab0KITWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: simplify mem_cgroup_page_stat()
has been added to the -mm tree.  Its filename is
     memcg-simplify-mem_cgroup_page_stat.patch

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
Subject: memcg: simplify mem_cgroup_page_stat()
From: Greg Thelen <gthelen@google.com>

The cgroup given to mem_cgroup_page_stat() is no allowed to be NULL or the
root cgroup.  So there is no need to complicate the code handling those
cases.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   48 +++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-mem_cgroup_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-mem_cgroup_page_stat
+++ a/mm/memcontrol.c
@@ -1364,12 +1364,10 @@ memcg_hierarchical_free_pages(struct mem
 
 /*
  * mem_cgroup_page_stat() - get memory cgroup file cache statistics
- * @mem:	optional memory cgroup to query.  If NULL, use current task's
- *		cgroup.
+ * @mem:	memory cgroup to query
  * @item:	memory statistic item exported to the kernel
  *
- * Return the accounted statistic value or negative value if current task is
- * root cgroup.
+ * Return the accounted statistic value.
  */
 long mem_cgroup_page_stat(struct mem_cgroup *mem,
 			  enum mem_cgroup_nr_pages_item item)
@@ -1377,29 +1375,27 @@ long mem_cgroup_page_stat(struct mem_cgr
 	struct mem_cgroup *iter;
 	long value;
 
+	VM_BUG_ON(!mem);
+	VM_BUG_ON(mem_cgroup_is_root(mem));
+
 	get_online_cpus();
-	rcu_read_lock();
-	if (!mem)
-		mem = mem_cgroup_from_task(current);
-	if (__mem_cgroup_has_dirty_limit(mem)) {
-		/*
-		 * If we're looking for dirtyable pages we need to evaluate
-		 * free pages depending on the limit and usage of the parents
-		 * first of all.
-		 */
-		if (item == MEMCG_NR_DIRTYABLE_PAGES)
-			value = memcg_hierarchical_free_pages(mem);
-		else
-			value = 0;
-		/*
-		 * Recursively evaluate page statistics against all cgroup
-		 * under hierarchy tree
-		 */
-		for_each_mem_cgroup_tree(iter, mem)
-			value += mem_cgroup_local_page_stat(iter, item);
-	} else
-		value = -EINVAL;
-	rcu_read_unlock();
+
+	/*
+	 * If we're looking for dirtyable pages we need to evaluate
+	 * free pages depending on the limit and usage of the parents
+	 * first of all.
+	 */
+	if (item == MEMCG_NR_DIRTYABLE_PAGES)
+		value = memcg_hierarchical_free_pages(mem);
+	else
+		value = 0;
+	/*
+	 * Recursively evaluate page statistics against all cgroup
+	 * under hierarchy tree
+	 */
+	for_each_mem_cgroup_tree(iter, mem)
+		value += mem_cgroup_local_page_stat(iter, item);
+
 	put_online_cpus();
 
 	return value;
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch

