From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:21:49 -0800
Message-ID: <201011091921.oA9JLnJ6002244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab0KITWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:22:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: add mem_cgroup parameter to mem_cgroup_page_stat()
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch

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
Subject: memcg: add mem_cgroup parameter to mem_cgroup_page_stat()
From: Greg Thelen <gthelen@google.com>

This new parameter can be used to query dirty memory usage from a given
memcg rather than the current task's memcg.

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

 include/linux/memcontrol.h |    6 +++--
 mm/memcontrol.c            |   37 +++++++++++++++++++----------------
 mm/page-writeback.c        |    2 -
 3 files changed, 26 insertions(+), 19 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat
+++ a/include/linux/memcontrol.h
@@ -157,7 +157,8 @@ static inline void mem_cgroup_dec_page_s
 bool mem_cgroup_has_dirty_limit(void);
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			   struct dirty_info *info);
-long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item);
+long mem_cgroup_page_stat(struct mem_cgroup *mem,
+			  enum mem_cgroup_nr_pages_item item);
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
@@ -351,7 +352,8 @@ static inline bool mem_cgroup_dirty_info
 	return false;
 }
 
-static inline long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
+static inline long mem_cgroup_page_stat(struct mem_cgroup *mem,
+					enum mem_cgroup_nr_pages_item item)
 {
 	return -ENOSYS;
 }
diff -puN mm/memcontrol.c~memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat
+++ a/mm/memcontrol.c
@@ -1245,22 +1245,20 @@ bool mem_cgroup_dirty_info(unsigned long
 	unsigned long available_mem;
 	struct mem_cgroup *memcg;
 	long value;
+	bool valid = false;
 
 	if (mem_cgroup_disabled())
 		return false;
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
-	if (!__mem_cgroup_has_dirty_limit(memcg)) {
-		rcu_read_unlock();
-		return false;
-	}
+	if (!__mem_cgroup_has_dirty_limit(memcg))
+		goto done;
 	__mem_cgroup_dirty_param(&dirty_param, memcg);
-	rcu_read_unlock();
 
-	value = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
+	value = mem_cgroup_page_stat(memcg, MEMCG_NR_DIRTYABLE_PAGES);
 	if (value < 0)
-		return false;
+		goto done;
 
 	available_mem = min((unsigned long)value, sys_available_mem);
 
@@ -1280,17 +1278,21 @@ bool mem_cgroup_dirty_info(unsigned long
 			(dirty_param.dirty_background_ratio *
 			       available_mem) / 100;
 
-	value = mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
+	value = mem_cgroup_page_stat(memcg, MEMCG_NR_RECLAIM_PAGES);
 	if (value < 0)
-		return false;
+		goto done;
 	info->nr_reclaimable = value;
 
-	value = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
+	value = mem_cgroup_page_stat(memcg, MEMCG_NR_WRITEBACK);
 	if (value < 0)
-		return false;
+		goto done;
 	info->nr_writeback = value;
 
-	return true;
+	valid = true;
+
+done:
+	rcu_read_unlock();
+	return valid;
 }
 
 static inline bool mem_cgroup_can_swap(struct mem_cgroup *memcg)
@@ -1361,20 +1363,23 @@ memcg_hierarchical_free_pages(struct mem
 
 /*
  * mem_cgroup_page_stat() - get memory cgroup file cache statistics
- * @item:      memory statistic item exported to the kernel
+ * @mem:	optional memory cgroup to query.  If NULL, use current task's
+ *		cgroup.
+ * @item:	memory statistic item exported to the kernel
  *
  * Return the accounted statistic value or negative value if current task is
  * root cgroup.
  */
-long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
+long mem_cgroup_page_stat(struct mem_cgroup *mem,
+			  enum mem_cgroup_nr_pages_item item)
 {
 	struct mem_cgroup *iter;
-	struct mem_cgroup *mem;
 	long value;
 
 	get_online_cpus();
 	rcu_read_lock();
-	mem = mem_cgroup_from_task(current);
+	if (!mem)
+		mem = mem_cgroup_from_task(current);
 	if (__mem_cgroup_has_dirty_limit(mem)) {
 		/*
 		 * If we're looking for dirtyable pages we need to evaluate
diff -puN mm/page-writeback.c~memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat
+++ a/mm/page-writeback.c
@@ -135,7 +135,7 @@ static unsigned long dirty_writeback_pag
 {
 	unsigned long ret;
 
-	ret = mem_cgroup_page_stat(MEMCG_NR_DIRTY_WRITEBACK_PAGES);
+	ret = mem_cgroup_page_stat(NULL, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
 	if ((long)ret < 0)
 		ret = global_page_state(NR_UNSTABLE_NFS) +
 			global_page_state(NR_WRITEBACK);
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

