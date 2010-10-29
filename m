From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-limits-to-mem_cgroup.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:53 -0700
Message-ID: <201010292019.o9TKJrBG014975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761858Ab0J2U05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: add dirty limits to mem_cgroup
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-limits-to-mem_cgroup.patch

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
Subject: memcg: add dirty limits to mem_cgroup
From: Greg Thelen <gthelen@google.com>

Extend mem_cgroup to contain dirty page limits.  Also add routines
allowing the kernel to query the dirty usage of a memcg.

These interfaces not used by the kernel yet.  A subsequent commit will add
kernel calls to utilize these new routines.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   30 ++++
 mm/memcontrol.c            |  248 ++++++++++++++++++++++++++++++++++-
 2 files changed, 277 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-add-dirty-limits-to-mem_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-dirty-limits-to-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -19,6 +19,7 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
+#include <linux/writeback.h>
 #include <linux/cgroup.h>
 struct mem_cgroup;
 struct page_cgroup;
@@ -33,6 +34,14 @@ enum mem_cgroup_page_stat_item {
 	MEMCG_NR_FILE_UNSTABLE_NFS, /* # of NFS unstable pages */
 };
 
+/* Cgroup memory statistics items exported to the kernel. */
+enum mem_cgroup_nr_pages_item {
+	MEMCG_NR_DIRTYABLE_PAGES,
+	MEMCG_NR_RECLAIM_PAGES,
+	MEMCG_NR_WRITEBACK,
+	MEMCG_NR_DIRTY_WRITEBACK_PAGES,
+};
+
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -145,6 +154,11 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
+bool mem_cgroup_has_dirty_limit(void);
+bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
+			   struct dirty_info *info);
+s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item);
+
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
 u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
@@ -326,6 +340,22 @@ static inline void mem_cgroup_dec_page_s
 {
 }
 
+static inline bool mem_cgroup_has_dirty_limit(void)
+{
+	return false;
+}
+
+static inline bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
+					 struct dirty_info *info)
+{
+	return false;
+}
+
+static inline s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
+{
+	return -ENOSYS;
+}
+
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 					    gfp_t gfp_mask)
diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup
+++ a/mm/memcontrol.c
@@ -188,6 +188,14 @@ struct mem_cgroup_eventfd_list {
 static void mem_cgroup_threshold(struct mem_cgroup *mem);
 static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
 
+/* Dirty memory parameters */
+struct vm_dirty_param {
+	int dirty_ratio;
+	int dirty_background_ratio;
+	unsigned long dirty_bytes;
+	unsigned long dirty_background_bytes;
+};
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -233,6 +241,10 @@ struct mem_cgroup {
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
+
+	/* control memory cgroup dirty pages */
+	struct vm_dirty_param dirty_param;
+
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
@@ -1132,6 +1144,232 @@ static unsigned int get_swappiness(struc
 	return swappiness;
 }
 
+/*
+ * Return true if the current memory cgroup has local dirty memory settings.
+ * There is an allowed race between the current task migrating in-to/out-of the
+ * root cgroup while this routine runs.  So the return value may be incorrect if
+ * the current task is being simultaneously migrated.
+ */
+static bool __mem_cgroup_has_dirty_limit(struct mem_cgroup *mem)
+{
+	if (!mem)
+		return false;
+	if (mem_cgroup_is_root(mem))
+		return false;
+	/*
+	 * The current memcg implementation does not yet support hierarchical
+	 * dirty limits.
+	 */
+	if (mem->use_hierarchy)
+		return false;
+	return true;
+}
+
+bool mem_cgroup_has_dirty_limit(void)
+{
+	struct mem_cgroup *mem;
+	bool ret;
+
+	if (mem_cgroup_disabled())
+		return false;
+
+	rcu_read_lock();
+	mem = mem_cgroup_from_task(current);
+	ret = __mem_cgroup_has_dirty_limit(mem);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+/*
+ * Returns a snapshot of the current dirty limits which is not synchronized with
+ * the routines that change the dirty limits.  If this routine races with an
+ * update to the dirty bytes/ratio value, then the caller must handle the case
+ * where both dirty_[background_]_ratio and _bytes are set.
+ */
+static void __mem_cgroup_dirty_param(struct vm_dirty_param *param,
+				     struct mem_cgroup *mem)
+{
+	if (__mem_cgroup_has_dirty_limit(mem)) {
+		param->dirty_ratio = mem->dirty_param.dirty_ratio;
+		param->dirty_bytes = mem->dirty_param.dirty_bytes;
+		param->dirty_background_ratio =
+			mem->dirty_param.dirty_background_ratio;
+		param->dirty_background_bytes =
+			mem->dirty_param.dirty_background_bytes;
+	} else {
+		param->dirty_ratio = vm_dirty_ratio;
+		param->dirty_bytes = vm_dirty_bytes;
+		param->dirty_background_ratio = dirty_background_ratio;
+		param->dirty_background_bytes = dirty_background_bytes;
+	}
+}
+
+/*
+ * Return the background-writeback and dirty-throttling thresholds as well as
+ * dirty usage metrics.
+ *
+ * The current task may be moved to another cgroup while this routine accesses
+ * the dirty limit.  But a precise check is meaningless because the task can be
+ * moved after our access and writeback tends to take long time.  At least,
+ * "memcg" will not be freed while holding rcu_read_lock().
+ */
+bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
+			   struct dirty_info *info)
+{
+	s64 available_mem;
+	struct vm_dirty_param dirty_param;
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return false;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+	if (!__mem_cgroup_has_dirty_limit(memcg)) {
+		rcu_read_unlock();
+		return false;
+	}
+	__mem_cgroup_dirty_param(&dirty_param, memcg);
+	rcu_read_unlock();
+
+	available_mem = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
+	if (available_mem < 0)
+		return false;
+
+	available_mem = min((unsigned long)available_mem, sys_available_mem);
+
+	if (dirty_param.dirty_bytes)
+		info->dirty_thresh =
+			DIV_ROUND_UP(dirty_param.dirty_bytes, PAGE_SIZE);
+	else
+		info->dirty_thresh =
+			(dirty_param.dirty_ratio * available_mem) / 100;
+
+	if (dirty_param.dirty_background_bytes)
+		info->background_thresh =
+			DIV_ROUND_UP(dirty_param.dirty_background_bytes,
+				     PAGE_SIZE);
+	else
+		info->background_thresh =
+			(dirty_param.dirty_background_ratio *
+			       available_mem) / 100;
+
+	info->nr_reclaimable =
+		mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
+	if (info->nr_reclaimable < 0)
+		return false;
+
+	info->nr_writeback = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
+	if (info->nr_writeback < 0)
+		return false;
+
+	return true;
+}
+
+static inline bool mem_cgroup_can_swap(struct mem_cgroup *memcg)
+{
+	if (!do_swap_account)
+		return nr_swap_pages > 0;
+	return !memcg->memsw_is_minimum &&
+		(res_counter_read_u64(&memcg->memsw, RES_LIMIT) > 0);
+}
+
+static s64 mem_cgroup_local_page_stat(struct mem_cgroup *mem,
+				      enum mem_cgroup_nr_pages_item item)
+{
+	s64 ret;
+
+	switch (item) {
+	case MEMCG_NR_DIRTYABLE_PAGES:
+		ret = mem_cgroup_read_stat(mem, LRU_ACTIVE_FILE) +
+			mem_cgroup_read_stat(mem, LRU_INACTIVE_FILE);
+		if (mem_cgroup_can_swap(mem))
+			ret += mem_cgroup_read_stat(mem, LRU_ACTIVE_ANON) +
+				mem_cgroup_read_stat(mem, LRU_INACTIVE_ANON);
+		break;
+	case MEMCG_NR_RECLAIM_PAGES:
+		ret = mem_cgroup_read_stat(mem,	MEM_CGROUP_STAT_FILE_DIRTY) +
+			mem_cgroup_read_stat(mem,
+					     MEM_CGROUP_STAT_FILE_UNSTABLE_NFS);
+		break;
+	case MEMCG_NR_WRITEBACK:
+		ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_WRITEBACK);
+		break;
+	case MEMCG_NR_DIRTY_WRITEBACK_PAGES:
+		ret = mem_cgroup_read_stat(mem,
+					   MEM_CGROUP_STAT_FILE_WRITEBACK) +
+			mem_cgroup_read_stat(mem,
+					     MEM_CGROUP_STAT_FILE_UNSTABLE_NFS);
+		break;
+	default:
+		BUG();
+		break;
+	}
+	return ret;
+}
+
+/*
+ * Return the number of pages that the @mem cgroup could allocate.  If
+ * use_hierarchy is set, then this involves parent mem cgroups to find the
+ * cgroup with the smallest free space.
+ */
+static unsigned long long
+memcg_hierarchical_free_pages(struct mem_cgroup *mem)
+{
+	unsigned long free, min_free;
+
+	min_free = global_page_state(NR_FREE_PAGES) << PAGE_SHIFT;
+
+	while (mem) {
+		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
+			res_counter_read_u64(&mem->res, RES_USAGE);
+		min_free = min(min_free, free);
+		mem = parent_mem_cgroup(mem);
+	}
+
+	/* Translate free memory in pages */
+	return min_free >> PAGE_SHIFT;
+}
+
+/*
+ * mem_cgroup_page_stat() - get memory cgroup file cache statistics
+ * @item:      memory statistic item exported to the kernel
+ *
+ * Return the accounted statistic value or negative value if current task is
+ * root cgroup.
+ */
+s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
+{
+	struct mem_cgroup *mem;
+	struct mem_cgroup *iter;
+	s64 value;
+
+	rcu_read_lock();
+	mem = mem_cgroup_from_task(current);
+	if (__mem_cgroup_has_dirty_limit(mem)) {
+		/*
+		 * If we're looking for dirtyable pages we need to evaluate
+		 * free pages depending on the limit and usage of the parents
+		 * first of all.
+		 */
+		if (item == MEMCG_NR_DIRTYABLE_PAGES)
+			value = memcg_hierarchical_free_pages(mem);
+		else
+			value = 0;
+		/*
+		 * Recursively evaluate page statistics against all cgroup
+		 * under hierarchy tree
+		 */
+		for_each_mem_cgroup_tree(iter, mem)
+			value += mem_cgroup_local_page_stat(iter, item);
+	} else
+		value = -EINVAL;
+	rcu_read_unlock();
+
+	return value;
+}
+
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
 {
 	int cpu;
@@ -4440,8 +4678,16 @@ mem_cgroup_create(struct cgroup_subsys *
 	spin_lock_init(&mem->reclaim_param_lock);
 	INIT_LIST_HEAD(&mem->oom_notify);
 
-	if (parent)
+	if (parent) {
 		mem->swappiness = get_swappiness(parent);
+		__mem_cgroup_dirty_param(&mem->dirty_param, parent);
+	} else {
+		/*
+		 * The root cgroup dirty_param field is not used, instead,
+		 * system-wide dirty limits are used.
+		 */
+	}
+
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch

