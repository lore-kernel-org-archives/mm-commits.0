From: akpm@linux-foundation.org
Subject: + mm-memcontrol-per-lruvec-stats-infrastructure.patch added to
 -mm tree
Date: Tue, 30 May 2017 13:53:51 -0700
Message-ID: <592ddbdf.5q9FdMvrjU7cH8qz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdE3Ux5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 16:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: per-lruvec stats infrastructure
has been added to the -mm tree.  Its filename is
     mm-memcontrol-per-lruvec-stats-infrastructure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: per-lruvec stats infrastructure

lruvecs are at the intersection of the NUMA node and memcg, which is the
scope for most paging activity.

Introduce a convenient accounting infrastructure that maintains statistics
per node, per memcg, and the lruvec itself.

Then convert over accounting sites for statistics that are already tracked
in both nodes and memcgs and can be easily switched.

Link: http://lkml.kernel.org/r/20170530181724.27197-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  238 ++++++++++++++++++++++++++++++-----
 include/linux/vmstat.h     |    1 
 mm/memcontrol.c            |    6 
 mm/page-writeback.c        |   15 --
 mm/rmap.c                  |    8 -
 mm/workingset.c            |    9 -
 6 files changed, 225 insertions(+), 52 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure
+++ a/include/linux/memcontrol.h
@@ -26,7 +26,8 @@
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
-#include <linux/mmzone.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 
@@ -98,11 +99,16 @@ struct mem_cgroup_reclaim_iter {
 	unsigned int generation;
 };
 
+struct lruvec_stat {
+	long count[NR_VM_NODE_STAT_ITEMS];
+};
+
 /*
  * per-zone information in memory controller.
  */
 struct mem_cgroup_per_node {
 	struct lruvec		lruvec;
+	struct lruvec_stat __percpu *lruvec_stat;
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 
 	struct mem_cgroup_reclaim_iter	iter[DEF_PRIORITY + 1];
@@ -496,23 +502,18 @@ static inline unsigned long memcg_page_s
 	return val;
 }
 
-static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx, int val)
+static inline void __mod_memcg_state(struct mem_cgroup *memcg,
+				     enum memcg_stat_item idx, int val)
 {
 	if (!mem_cgroup_disabled())
-		this_cpu_add(memcg->stat->count[idx], val);
-}
-
-static inline void inc_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx)
-{
-	mod_memcg_state(memcg, idx, 1);
+		__this_cpu_add(memcg->stat->count[idx], val);
 }
 
-static inline void dec_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx)
+static inline void mod_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx, int val)
 {
-	mod_memcg_state(memcg, idx, -1);
+	if (!mem_cgroup_disabled())
+		this_cpu_add(memcg->stat->count[idx], val);
 }
 
 /**
@@ -532,6 +533,13 @@ static inline void dec_memcg_state(struc
  *
  * Kernel pages are an exception to this, since they'll never move.
  */
+static inline void __mod_memcg_page_state(struct page *page,
+					  enum memcg_stat_item idx, int val)
+{
+	if (page->mem_cgroup)
+		__mod_memcg_state(page->mem_cgroup, idx, val);
+}
+
 static inline void mod_memcg_page_state(struct page *page,
 					enum memcg_stat_item idx, int val)
 {
@@ -539,16 +547,68 @@ static inline void mod_memcg_page_state(
 		mod_memcg_state(page->mem_cgroup, idx, val);
 }
 
-static inline void inc_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx)
+static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+					      enum node_stat_item idx)
 {
-	mod_memcg_page_state(page, idx, 1);
+	struct mem_cgroup_per_node *pn;
+	long val = 0;
+	int cpu;
+
+	if (mem_cgroup_disabled())
+		return node_page_state(lruvec_pgdat(lruvec), idx);
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	for_each_possible_cpu(cpu)
+		val += per_cpu(pn->lruvec_stat->count[idx], cpu);
+
+	if (val < 0)
+		val = 0;
+
+	return val;
 }
 
-static inline void dec_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx)
+static inline void __mod_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx, int val)
 {
-	mod_memcg_page_state(page, idx, -1);
+	struct mem_cgroup_per_node *pn;
+
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	if (mem_cgroup_disabled())
+		return;
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	__mod_memcg_state(pn->memcg, idx, val);
+	__this_cpu_add(pn->lruvec_stat->count[idx], val);
+}
+
+static inline void mod_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+	if (mem_cgroup_disabled())
+		return;
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mod_memcg_state(pn->memcg, idx, val);
+	this_cpu_add(pn->lruvec_stat->count[idx], val);
+}
+
+static inline void __mod_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx, int val)
+{
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), page->mem_cgroup);
+	__mod_lruvec_state(lruvec, idx, val);
+}
+
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), page->mem_cgroup);
+	mod_lruvec_state(lruvec, idx, val);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -777,19 +837,21 @@ static inline unsigned long memcg_page_s
 	return 0;
 }
 
-static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx,
-				   int nr)
+static inline void __mod_memcg_state(struct mem_cgroup *memcg,
+				     enum memcg_stat_item idx,
+				     int nr)
 {
 }
 
-static inline void inc_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx)
+static inline void mod_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx,
+				   int nr)
 {
 }
 
-static inline void dec_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx)
+static inline void __mod_memcg_page_state(struct page *page,
+					  enum memcg_stat_item idx,
+					  int nr)
 {
 }
 
@@ -799,14 +861,34 @@ static inline void mod_memcg_page_state(
 {
 }
 
-static inline void inc_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx)
+static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+					      enum node_stat_item idx)
 {
+	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline void dec_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx)
+static inline void __mod_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx, int val)
 {
+	__mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+}
+
+static inline void mod_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx, int val)
+{
+	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
+}
+
+static inline void __mod_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx, int val)
+{
+	__mod_node_page_state(page_pgdat(page), idx, val);
+}
+
+static inline void mod_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx, int val)
+{
+	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
 static inline
@@ -838,6 +920,102 @@ void count_memcg_event_mm(struct mm_stru
 }
 #endif /* CONFIG_MEMCG */
 
+static inline void __inc_memcg_state(struct mem_cgroup *memcg,
+				     enum memcg_stat_item idx)
+{
+	__mod_memcg_state(memcg, idx, 1);
+}
+
+static inline void __dec_memcg_state(struct mem_cgroup *memcg,
+				     enum memcg_stat_item idx)
+{
+	__mod_memcg_state(memcg, idx, -1);
+}
+
+static inline void __inc_memcg_page_state(struct page *page,
+					  enum memcg_stat_item idx)
+{
+	__mod_memcg_page_state(page, idx, 1);
+}
+
+static inline void __dec_memcg_page_state(struct page *page,
+					  enum memcg_stat_item idx)
+{
+	__mod_memcg_page_state(page, idx, -1);
+}
+
+static inline void __inc_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	__mod_lruvec_state(lruvec, idx, 1);
+}
+
+static inline void __dec_lruvec_state(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	__mod_lruvec_state(lruvec, idx, -1);
+}
+
+static inline void __inc_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx)
+{
+	__mod_lruvec_page_state(page, idx, 1);
+}
+
+static inline void __dec_lruvec_page_state(struct page *page,
+					   enum node_stat_item idx)
+{
+	__mod_lruvec_page_state(page, idx, -1);
+}
+
+static inline void inc_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx)
+{
+	mod_memcg_state(memcg, idx, 1);
+}
+
+static inline void dec_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx)
+{
+	mod_memcg_state(memcg, idx, -1);
+}
+
+static inline void inc_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx)
+{
+	mod_memcg_page_state(page, idx, 1);
+}
+
+static inline void dec_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx)
+{
+	mod_memcg_page_state(page, idx, -1);
+}
+
+static inline void inc_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	mod_lruvec_state(lruvec, idx, 1);
+}
+
+static inline void dec_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	mod_lruvec_state(lruvec, idx, -1);
+}
+
+static inline void inc_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx)
+{
+	mod_lruvec_page_state(page, idx, 1);
+}
+
+static inline void dec_lruvec_page_state(struct page *page,
+					 enum node_stat_item idx)
+{
+	mod_lruvec_page_state(page, idx, -1);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct list_head *mem_cgroup_cgwb_list(struct mem_cgroup *memcg);
diff -puN include/linux/vmstat.h~mm-memcontrol-per-lruvec-stats-infrastructure include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-memcontrol-per-lruvec-stats-infrastructure
+++ a/include/linux/vmstat.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
-#include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/vm_event_item.h>
 #include <linux/atomic.h>
diff -puN mm/memcontrol.c~mm-memcontrol-per-lruvec-stats-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-per-lruvec-stats-infrastructure
+++ a/mm/memcontrol.c
@@ -4122,6 +4122,12 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
 
+	pn->lruvec_stat = alloc_percpu(struct lruvec_stat);
+	if (!pn->lruvec_stat) {
+		kfree(pn);
+		return 1;
+	}
+
 	lruvec_init(&pn->lruvec);
 	pn->usage_in_excess = 0;
 	pn->on_tree = false;
diff -puN mm/page-writeback.c~mm-memcontrol-per-lruvec-stats-infrastructure mm/page-writeback.c
--- a/mm/page-writeback.c~mm-memcontrol-per-lruvec-stats-infrastructure
+++ a/mm/page-writeback.c
@@ -2433,8 +2433,7 @@ void account_page_dirtied(struct page *p
 		inode_attach_wb(inode, page);
 		wb = inode_to_wb(inode);
 
-		inc_memcg_page_state(page, NR_FILE_DIRTY);
-		__inc_node_page_state(page, NR_FILE_DIRTY);
+		__inc_lruvec_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		__inc_node_page_state(page, NR_DIRTIED);
 		__inc_wb_stat(wb, WB_RECLAIMABLE);
@@ -2455,8 +2454,7 @@ void account_page_cleaned(struct page *p
 			  struct bdi_writeback *wb)
 {
 	if (mapping_cap_account_dirty(mapping)) {
-		dec_memcg_page_state(page, NR_FILE_DIRTY);
-		dec_node_page_state(page, NR_FILE_DIRTY);
+		dec_lruvec_page_state(page, NR_FILE_DIRTY);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		dec_wb_stat(wb, WB_RECLAIMABLE);
 		task_io_account_cancelled_write(PAGE_SIZE);
@@ -2712,8 +2710,7 @@ int clear_page_dirty_for_io(struct page
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		if (TestClearPageDirty(page)) {
-			dec_memcg_page_state(page, NR_FILE_DIRTY);
-			dec_node_page_state(page, NR_FILE_DIRTY);
+			dec_lruvec_page_state(page, NR_FILE_DIRTY);
 			dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 			dec_wb_stat(wb, WB_RECLAIMABLE);
 			ret = 1;
@@ -2759,8 +2756,7 @@ int test_clear_page_writeback(struct pag
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
-		dec_memcg_page_state(page, NR_WRITEBACK);
-		dec_node_page_state(page, NR_WRITEBACK);
+		dec_lruvec_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
@@ -2814,8 +2810,7 @@ int __test_set_page_writeback(struct pag
 		ret = TestSetPageWriteback(page);
 	}
 	if (!ret) {
-		inc_memcg_page_state(page, NR_WRITEBACK);
-		inc_node_page_state(page, NR_WRITEBACK);
+		inc_lruvec_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
 	unlock_page_memcg(page);
diff -puN mm/rmap.c~mm-memcontrol-per-lruvec-stats-infrastructure mm/rmap.c
--- a/mm/rmap.c~mm-memcontrol-per-lruvec-stats-infrastructure
+++ a/mm/rmap.c
@@ -1157,8 +1157,7 @@ void page_add_file_rmap(struct page *pag
 		if (!atomic_inc_and_test(&page->_mapcount))
 			goto out;
 	}
-	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
-	mod_memcg_page_state(page, NR_FILE_MAPPED, nr);
+	__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
 out:
 	unlock_page_memcg(page);
 }
@@ -1193,12 +1192,11 @@ static void page_remove_file_rmap(struct
 	}
 
 	/*
-	 * We use the irq-unsafe __{inc|mod}_zone_page_state because
+	 * We use the irq-unsafe __{inc|mod}_lruvec_page_state because
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, -nr);
-	mod_memcg_page_state(page, NR_FILE_MAPPED, -nr);
+	__mod_lruvec_page_state(page, NR_FILE_MAPPED, -nr);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
diff -puN mm/workingset.c~mm-memcontrol-per-lruvec-stats-infrastructure mm/workingset.c
--- a/mm/workingset.c~mm-memcontrol-per-lruvec-stats-infrastructure
+++ a/mm/workingset.c
@@ -288,12 +288,10 @@ bool workingset_refault(void *shadow)
 	 */
 	refault_distance = (refault - eviction) & EVICTION_MASK;
 
-	inc_node_state(pgdat, WORKINGSET_REFAULT);
-	inc_memcg_state(memcg, WORKINGSET_REFAULT);
+	inc_lruvec_state(lruvec, WORKINGSET_REFAULT);
 
 	if (refault_distance <= active_file) {
-		inc_node_state(pgdat, WORKINGSET_ACTIVATE);
-		inc_memcg_state(memcg, WORKINGSET_ACTIVATE);
+		inc_lruvec_state(lruvec, WORKINGSET_ACTIVATE);
 		rcu_read_unlock();
 		return true;
 	}
@@ -474,8 +472,7 @@ static enum lru_status shadow_lru_isolat
 	}
 	if (WARN_ON_ONCE(node->exceptional))
 		goto out_invalid;
-	inc_node_state(page_pgdat(virt_to_page(node)), WORKINGSET_NODERECLAIM);
-	inc_memcg_page_state(virt_to_page(node), WORKINGSET_NODERECLAIM);
+	inc_lruvec_page_state(virt_to_page(node), WORKINGSET_NODERECLAIM);
 	__radix_tree_delete_node(&mapping->page_tree, node,
 				 workingset_update_node, mapping);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

