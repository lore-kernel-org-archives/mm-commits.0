From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-use-node-page-state-naming-scheme-for-memcg.patch removed
 from -mm tree
Date: Thu, 04 May 2017 12:12:43 -0700
Message-ID: <20170504191243.bC95Wxf_Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756505AbdEDTMp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: memcontrol: use node page state naming scheme for memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-node-page-state-naming-scheme-for-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use node page state naming scheme for memcg

The memory controllers stat function names are awkwardly long and
arbitrarily different from the zone and node stat functions.

The current interface is named:

  mem_cgroup_read_stat()
  mem_cgroup_update_stat()
  mem_cgroup_inc_stat()
  mem_cgroup_dec_stat()
  mem_cgroup_update_page_stat()
  mem_cgroup_inc_page_stat()
  mem_cgroup_dec_page_stat()

This patch renames it to match the corresponding node stat functions:

  memcg_page_state()		[node_page_state()]
  mod_memcg_state()		[mod_node_state()]
  inc_memcg_state()		[inc_node_state()]
  dec_memcg_state()		[dec_node_state()]
  mod_memcg_page_state()	[mod_node_page_state()]
  inc_memcg_page_state()	[inc_node_page_state()]
  dec_memcg_page_state()	[dec_node_page_state()]

Link: http://lkml.kernel.org/r/20170404220148.28338-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   73 +++++++++++++++++------------------
 mm/memcontrol.c            |   38 +++++++++---------
 mm/page-writeback.c        |   10 ++--
 mm/rmap.c                  |    4 -
 mm/vmscan.c                |    5 --
 mm/workingset.c            |    6 +-
 6 files changed, 68 insertions(+), 68 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg
+++ a/include/linux/memcontrol.h
@@ -472,8 +472,8 @@ extern int do_swap_account;
 void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
-static inline unsigned long mem_cgroup_read_stat(struct mem_cgroup *memcg,
-						 enum memcg_stat_item idx)
+static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
+					     enum memcg_stat_item idx)
 {
 	long val = 0;
 	int cpu;
@@ -487,27 +487,27 @@ static inline unsigned long mem_cgroup_r
 	return val;
 }
 
-static inline void mem_cgroup_update_stat(struct mem_cgroup *memcg,
-					  enum memcg_stat_item idx, int val)
+static inline void mod_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx, int val)
 {
 	if (!mem_cgroup_disabled())
 		this_cpu_add(memcg->stat->count[idx], val);
 }
 
-static inline void mem_cgroup_inc_stat(struct mem_cgroup *memcg,
-				       enum memcg_stat_item idx)
+static inline void inc_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx)
 {
-	mem_cgroup_update_stat(memcg, idx, 1);
+	mod_memcg_state(memcg, idx, 1);
 }
 
-static inline void mem_cgroup_dec_stat(struct mem_cgroup *memcg,
-				       enum memcg_stat_item idx)
+static inline void dec_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx)
 {
-	mem_cgroup_update_stat(memcg, idx, -1);
+	mod_memcg_state(memcg, idx, -1);
 }
 
 /**
- * mem_cgroup_update_page_stat - update page state statistics
+ * mod_memcg_page_state - update page state statistics
  * @page: the page
  * @idx: page state item to account
  * @val: number of pages (positive or negative)
@@ -518,28 +518,28 @@ static inline void mem_cgroup_dec_stat(s
  *
  *   lock_page(page) or lock_page_memcg(page)
  *   if (TestClearPageState(page))
- *     mem_cgroup_update_page_stat(page, state, -1);
+ *     mod_memcg_page_state(page, state, -1);
  *   unlock_page(page) or unlock_page_memcg(page)
  *
  * Kernel pages are an exception to this, since they'll never move.
  */
-static inline void mem_cgroup_update_page_stat(struct page *page,
-				 enum memcg_stat_item idx, int val)
+static inline void mod_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx, int val)
 {
 	if (page->mem_cgroup)
-		mem_cgroup_update_stat(page->mem_cgroup, idx, val);
+		mod_memcg_state(page->mem_cgroup, idx, val);
 }
 
-static inline void mem_cgroup_inc_page_stat(struct page *page,
-					    enum memcg_stat_item idx)
+static inline void inc_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx)
 {
-	mem_cgroup_update_page_stat(page, idx, 1);
+	mod_memcg_page_state(page, idx, 1);
 }
 
-static inline void mem_cgroup_dec_page_stat(struct page *page,
-					    enum memcg_stat_item idx)
+static inline void dec_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx)
 {
-	mem_cgroup_update_page_stat(page, idx, -1);
+	mod_memcg_page_state(page, idx, -1);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -739,40 +739,41 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
-static inline unsigned long mem_cgroup_read_stat(struct mem_cgroup *memcg,
-						 enum mem_cgroup_stat_index idx)
+static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
+					     enum memcg_stat_item idx)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_update_stat(struct mem_cgroup *memcg,
-					  enum memcg_stat_item idx, int val)
+static inline void mod_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx,
+				   int nr)
 {
 }
 
-static inline void mem_cgroup_inc_stat(struct mem_cgroup *memcg,
-				       enum memcg_stat_item idx)
+static inline void inc_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx)
 {
 }
 
-static inline void mem_cgroup_dec_stat(struct mem_cgroup *memcg,
-				       enum memcg_stat_item idx)
+static inline void dec_memcg_state(struct mem_cgroup *memcg,
+				   enum memcg_stat_item idx)
 {
 }
 
-static inline void mem_cgroup_update_page_stat(struct page *page,
-					       enum memcg_stat_item idx,
-					       int nr)
+static inline void mod_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx,
+					int nr)
 {
 }
 
-static inline void mem_cgroup_inc_page_stat(struct page *page,
-					    enum memcg_stat_item idx)
+static inline void inc_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx)
 {
 }
 
-static inline void mem_cgroup_dec_page_stat(struct page *page,
-					    enum memcg_stat_item idx)
+static inline void dec_memcg_page_state(struct page *page,
+					enum memcg_stat_item idx)
 {
 }
 
diff -puN mm/memcontrol.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg
+++ a/mm/memcontrol.c
@@ -552,8 +552,8 @@ mem_cgroup_largest_soft_limit_node(struc
  * implemented.
  */
 
-static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
-					    enum memcg_event_item event)
+static unsigned long memcg_sum_events(struct mem_cgroup *memcg,
+				      enum memcg_event_item event)
 {
 	unsigned long val = 0;
 	int cpu;
@@ -1180,7 +1180,7 @@ void mem_cgroup_print_oom_info(struct me
 			if (memcg1_stats[i] == MEMCG_SWAP && !do_swap_account)
 				continue;
 			pr_cont(" %s:%luKB", memcg1_stat_names[i],
-				K(mem_cgroup_read_stat(iter, memcg1_stats[i])));
+				K(memcg_page_state(iter, memcg1_stats[i])));
 		}
 
 		for (i = 0; i < NR_LRU_LISTS; i++)
@@ -2713,7 +2713,7 @@ static void tree_stat(struct mem_cgroup
 
 	for_each_mem_cgroup_tree(iter, memcg) {
 		for (i = 0; i < MEMCG_NR_STAT; i++)
-			stat[i] += mem_cgroup_read_stat(iter, i);
+			stat[i] += memcg_page_state(iter, i);
 	}
 }
 
@@ -2726,7 +2726,7 @@ static void tree_events(struct mem_cgrou
 
 	for_each_mem_cgroup_tree(iter, memcg) {
 		for (i = 0; i < MEMCG_NR_EVENTS; i++)
-			events[i] += mem_cgroup_read_events(iter, i);
+			events[i] += memcg_sum_events(iter, i);
 	}
 }
 
@@ -2738,10 +2738,10 @@ static unsigned long mem_cgroup_usage(st
 		struct mem_cgroup *iter;
 
 		for_each_mem_cgroup_tree(iter, memcg) {
-			val += mem_cgroup_read_stat(iter, MEMCG_CACHE);
-			val += mem_cgroup_read_stat(iter, MEMCG_RSS);
+			val += memcg_page_state(iter, MEMCG_CACHE);
+			val += memcg_page_state(iter, MEMCG_RSS);
 			if (swap)
-				val += mem_cgroup_read_stat(iter, MEMCG_SWAP);
+				val += memcg_page_state(iter, MEMCG_SWAP);
 		}
 	} else {
 		if (!swap)
@@ -3145,13 +3145,13 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
-			   mem_cgroup_read_stat(memcg, memcg1_stats[i]) *
+			   memcg_page_state(memcg, memcg1_stats[i]) *
 			   PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
 		seq_printf(m, "%s %lu\n", memcg1_event_names[i],
-			   mem_cgroup_read_events(memcg, memcg1_events[i]));
+			   memcg_sum_events(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
@@ -3175,7 +3175,7 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		for_each_mem_cgroup_tree(mi, memcg)
-			val += mem_cgroup_read_stat(mi, memcg1_stats[i]) *
+			val += memcg_page_state(mi, memcg1_stats[i]) *
 			PAGE_SIZE;
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i], val);
 	}
@@ -3184,7 +3184,7 @@ static int memcg_stat_show(struct seq_fi
 		unsigned long long val = 0;
 
 		for_each_mem_cgroup_tree(mi, memcg)
-			val += mem_cgroup_read_events(mi, memcg1_events[i]);
+			val += memcg_sum_events(mi, memcg1_events[i]);
 		seq_printf(m, "total_%s %llu\n", memcg1_event_names[i], val);
 	}
 
@@ -3650,10 +3650,10 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	*pdirty = mem_cgroup_read_stat(memcg, NR_FILE_DIRTY);
+	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 
 	/* this should eventually include NR_UNSTABLE_NFS */
-	*pwriteback = mem_cgroup_read_stat(memcg, NR_WRITEBACK);
+	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
 	*pfilepages = mem_cgroup_nr_lru_pages(memcg, (1 << LRU_INACTIVE_FILE) |
 						     (1 << LRU_ACTIVE_FILE));
 	*pheadroom = PAGE_COUNTER_MAX;
@@ -4515,7 +4515,7 @@ static int mem_cgroup_move_account(struc
 
 	/*
 	 * move_lock grabbed above and caller set from->moving_account, so
-	 * mem_cgroup_update_page_stat() will serialize updates to PageDirty.
+	 * mod_memcg_page_state will serialize updates to PageDirty.
 	 * So mapping should be stable for dirty pages.
 	 */
 	if (!anon && PageDirty(page)) {
@@ -5161,10 +5161,10 @@ static int memory_events_show(struct seq
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 
-	seq_printf(m, "low %lu\n", mem_cgroup_read_events(memcg, MEMCG_LOW));
-	seq_printf(m, "high %lu\n", mem_cgroup_read_events(memcg, MEMCG_HIGH));
-	seq_printf(m, "max %lu\n", mem_cgroup_read_events(memcg, MEMCG_MAX));
-	seq_printf(m, "oom %lu\n", mem_cgroup_read_events(memcg, MEMCG_OOM));
+	seq_printf(m, "low %lu\n", memcg_sum_events(memcg, MEMCG_LOW));
+	seq_printf(m, "high %lu\n", memcg_sum_events(memcg, MEMCG_HIGH));
+	seq_printf(m, "max %lu\n", memcg_sum_events(memcg, MEMCG_MAX));
+	seq_printf(m, "oom %lu\n", memcg_sum_events(memcg, MEMCG_OOM));
 
 	return 0;
 }
diff -puN mm/page-writeback.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg mm/page-writeback.c
--- a/mm/page-writeback.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg
+++ a/mm/page-writeback.c
@@ -2427,7 +2427,7 @@ void account_page_dirtied(struct page *p
 		inode_attach_wb(inode, page);
 		wb = inode_to_wb(inode);
 
-		mem_cgroup_inc_page_stat(page, NR_FILE_DIRTY);
+		inc_memcg_page_state(page, NR_FILE_DIRTY);
 		__inc_node_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		__inc_node_page_state(page, NR_DIRTIED);
@@ -2449,7 +2449,7 @@ void account_page_cleaned(struct page *p
 			  struct bdi_writeback *wb)
 {
 	if (mapping_cap_account_dirty(mapping)) {
-		mem_cgroup_dec_page_stat(page, NR_FILE_DIRTY);
+		dec_memcg_page_state(page, NR_FILE_DIRTY);
 		dec_node_page_state(page, NR_FILE_DIRTY);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		dec_wb_stat(wb, WB_RECLAIMABLE);
@@ -2706,7 +2706,7 @@ int clear_page_dirty_for_io(struct page
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		if (TestClearPageDirty(page)) {
-			mem_cgroup_dec_page_stat(page, NR_FILE_DIRTY);
+			dec_memcg_page_state(page, NR_FILE_DIRTY);
 			dec_node_page_state(page, NR_FILE_DIRTY);
 			dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 			dec_wb_stat(wb, WB_RECLAIMABLE);
@@ -2753,7 +2753,7 @@ int test_clear_page_writeback(struct pag
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
-		mem_cgroup_dec_page_stat(page, NR_WRITEBACK);
+		dec_memcg_page_state(page, NR_WRITEBACK);
 		dec_node_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
@@ -2808,7 +2808,7 @@ int __test_set_page_writeback(struct pag
 		ret = TestSetPageWriteback(page);
 	}
 	if (!ret) {
-		mem_cgroup_inc_page_stat(page, NR_WRITEBACK);
+		inc_memcg_page_state(page, NR_WRITEBACK);
 		inc_node_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 	}
diff -puN mm/rmap.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg mm/rmap.c
--- a/mm/rmap.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg
+++ a/mm/rmap.c
@@ -1158,7 +1158,7 @@ void page_add_file_rmap(struct page *pag
 			goto out;
 	}
 	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
-	mem_cgroup_update_page_stat(page, NR_FILE_MAPPED, nr);
+	mod_memcg_page_state(page, NR_FILE_MAPPED, nr);
 out:
 	unlock_page_memcg(page);
 }
@@ -1198,7 +1198,7 @@ static void page_remove_file_rmap(struct
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, -nr);
-	mem_cgroup_update_page_stat(page, NR_FILE_MAPPED, -nr);
+	mod_memcg_page_state(page, NR_FILE_MAPPED, -nr);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
diff -puN mm/vmscan.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg
+++ a/mm/vmscan.c
@@ -2046,7 +2046,7 @@ static bool inactive_list_is_low(struct
 	active = lruvec_lru_size(lruvec, active_lru, sc->reclaim_idx);
 
 	if (memcg)
-		refaults = mem_cgroup_read_stat(memcg, WORKINGSET_ACTIVATE);
+		refaults = memcg_page_state(memcg, WORKINGSET_ACTIVATE);
 	else
 		refaults = node_page_state(pgdat, WORKINGSET_ACTIVATE);
 
@@ -2733,8 +2733,7 @@ static void snapshot_refaults(struct mem
 		struct lruvec *lruvec;
 
 		if (memcg)
-			refaults = mem_cgroup_read_stat(memcg,
-							WORKINGSET_ACTIVATE);
+			refaults = memcg_page_state(memcg, WORKINGSET_ACTIVATE);
 		else
 			refaults = node_page_state(pgdat, WORKINGSET_ACTIVATE);
 
diff -puN mm/workingset.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg mm/workingset.c
--- a/mm/workingset.c~mm-memcontrol-use-node-page-state-naming-scheme-for-memcg
+++ a/mm/workingset.c
@@ -289,11 +289,11 @@ bool workingset_refault(void *shadow)
 	refault_distance = (refault - eviction) & EVICTION_MASK;
 
 	inc_node_state(pgdat, WORKINGSET_REFAULT);
-	mem_cgroup_inc_stat(memcg, WORKINGSET_REFAULT);
+	inc_memcg_state(memcg, WORKINGSET_REFAULT);
 
 	if (refault_distance <= active_file) {
 		inc_node_state(pgdat, WORKINGSET_ACTIVATE);
-		mem_cgroup_inc_stat(memcg, WORKINGSET_ACTIVATE);
+		inc_memcg_state(memcg, WORKINGSET_ACTIVATE);
 		rcu_read_unlock();
 		return true;
 	}
@@ -475,7 +475,7 @@ static enum lru_status shadow_lru_isolat
 	if (WARN_ON_ONCE(node->exceptional))
 		goto out_invalid;
 	inc_node_state(page_pgdat(virt_to_page(node)), WORKINGSET_NODERECLAIM);
-	mem_cgroup_inc_page_stat(virt_to_page(node), WORKINGSET_NODERECLAIM);
+	inc_memcg_page_state(virt_to_page(node), WORKINGSET_NODERECLAIM);
 	__radix_tree_delete_node(&mapping->page_tree, node,
 				 workingset_update_node, mapping);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


