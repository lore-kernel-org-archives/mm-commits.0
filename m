From: akpm@linux-foundation.org
Subject: + mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch added to -mm tree
Date: Tue, 21 Jun 2016 15:49:38 -0700
Message-ID: <5769c482.wctA+53lACv0wIlP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbcFUWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 18:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: move memcg limit enforcement from zones to nodes
has been added to the -mm tree.  Its filename is
     mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, memcg: move memcg limit enforcement from zones to nodes

Memcg was broken by the move of all LRUs to nodes because it is tracking
limits on a per-zone basis while receiving reclaim requests on a per-node
basis.  This patch moves limit enforcement to the nodes.  Technically, all
the variable names should also change but people are already familiar by
the meaning of "mz" even if "mn" would be a more appropriate name now.

Link: http://lkml.kernel.org/r/1466518566-30034-14-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   21 +--
 include/linux/swap.h       |    2 
 mm/memcontrol.c            |  212 +++++++++++++++--------------------
 mm/vmscan.c                |   22 +--
 mm/workingset.c            |    6 
 5 files changed, 115 insertions(+), 148 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes
+++ a/include/linux/memcontrol.h
@@ -60,7 +60,7 @@ enum mem_cgroup_stat_index {
 };
 
 struct mem_cgroup_reclaim_cookie {
-	struct zone *zone;
+	pg_data_t *pgdat;
 	int priority;
 	unsigned int generation;
 };
@@ -118,7 +118,7 @@ struct mem_cgroup_reclaim_iter {
 /*
  * per-zone information in memory controller.
  */
-struct mem_cgroup_per_zone {
+struct mem_cgroup_per_node {
 	struct lruvec		lruvec;
 	unsigned long		lru_size[NR_LRU_LISTS];
 
@@ -132,10 +132,6 @@ struct mem_cgroup_per_zone {
 						/* use container_of	   */
 };
 
-struct mem_cgroup_per_node {
-	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
-};
-
 struct mem_cgroup_threshold {
 	struct eventfd_ctx *eventfd;
 	unsigned long threshold;
@@ -314,8 +310,7 @@ void mem_cgroup_uncharge_list(struct lis
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
-struct lruvec *mem_cgroup_lruvec(struct pglist_data *, struct zone *zone,
-				 struct mem_cgroup *);
+struct lruvec *mem_cgroup_lruvec(struct pglist_data *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
@@ -405,9 +400,9 @@ unsigned long mem_cgroup_node_nr_lru_pag
 static inline
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
-	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_per_node *mz;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
+	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	return mz->lru_size[lru];
 }
 
@@ -478,7 +473,7 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
@@ -570,7 +565,7 @@ static inline void mem_cgroup_migrate(st
 }
 
 static inline struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
-				struct zone *zone, struct mem_cgroup *memcg)
+				struct mem_cgroup *memcg)
 {
 	return node_lruvec(pgdat);
 }
@@ -682,7 +677,7 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
 					    unsigned long *total_scanned)
 {
diff -puN include/linux/swap.h~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes include/linux/swap.h
--- a/include/linux/swap.h~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes
+++ a/include/linux/swap.h
@@ -318,7 +318,7 @@ extern unsigned long try_to_free_mem_cgr
 						  bool may_swap);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						struct zone *zone,
+						pg_data_t *pgdat,
 						unsigned long *nr_scanned);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/memcontrol.c~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes
+++ a/mm/memcontrol.c
@@ -132,15 +132,11 @@ static const char * const mem_cgroup_lru
  * their hierarchy representation
  */
 
-struct mem_cgroup_tree_per_zone {
+struct mem_cgroup_tree_per_node {
 	struct rb_root rb_root;
 	spinlock_t lock;
 };
 
-struct mem_cgroup_tree_per_node {
-	struct mem_cgroup_tree_per_zone rb_tree_per_zone[MAX_NR_ZONES];
-};
-
 struct mem_cgroup_tree {
 	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
 };
@@ -323,13 +319,10 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
 #endif /* !CONFIG_SLOB */
 
-static struct mem_cgroup_per_zone *
-mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
+static struct mem_cgroup_per_node *
+mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
 {
-	int nid = zone_to_nid(zone);
-	int zid = zone_idx(zone);
-
-	return &memcg->nodeinfo[nid]->zoneinfo[zid];
+	return memcg->nodeinfo[nid];
 }
 
 /**
@@ -383,37 +376,35 @@ ino_t page_cgroup_ino(struct page *page)
 	return ino;
 }
 
-static struct mem_cgroup_per_zone *
-mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
+static struct mem_cgroup_per_node *
+mem_cgroup_page_nodeinfo(struct mem_cgroup *memcg, struct page *page)
 {
 	int nid = page_to_nid(page);
-	int zid = page_zonenum(page);
 
-	return &memcg->nodeinfo[nid]->zoneinfo[zid];
+	return memcg->nodeinfo[nid];
 }
 
-static struct mem_cgroup_tree_per_zone *
-soft_limit_tree_node_zone(int nid, int zid)
+static struct mem_cgroup_tree_per_node *
+soft_limit_tree_node(int nid)
 {
-	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
+	return soft_limit_tree.rb_tree_per_node[nid];
 }
 
-static struct mem_cgroup_tree_per_zone *
+static struct mem_cgroup_tree_per_node *
 soft_limit_tree_from_page(struct page *page)
 {
 	int nid = page_to_nid(page);
-	int zid = page_zonenum(page);
 
-	return &soft_limit_tree.rb_tree_per_node[nid]->rb_tree_per_zone[zid];
+	return soft_limit_tree.rb_tree_per_node[nid];
 }
 
-static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_zone *mz,
-					 struct mem_cgroup_tree_per_zone *mctz,
+static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
+					 struct mem_cgroup_tree_per_node *mctz,
 					 unsigned long new_usage_in_excess)
 {
 	struct rb_node **p = &mctz->rb_root.rb_node;
 	struct rb_node *parent = NULL;
-	struct mem_cgroup_per_zone *mz_node;
+	struct mem_cgroup_per_node *mz_node;
 
 	if (mz->on_tree)
 		return;
@@ -423,7 +414,7 @@ static void __mem_cgroup_insert_exceeded
 		return;
 	while (*p) {
 		parent = *p;
-		mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
+		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
 					tree_node);
 		if (mz->usage_in_excess < mz_node->usage_in_excess)
 			p = &(*p)->rb_left;
@@ -439,8 +430,8 @@ static void __mem_cgroup_insert_exceeded
 	mz->on_tree = true;
 }
 
-static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
-					 struct mem_cgroup_tree_per_zone *mctz)
+static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
+					 struct mem_cgroup_tree_per_node *mctz)
 {
 	if (!mz->on_tree)
 		return;
@@ -448,8 +439,8 @@ static void __mem_cgroup_remove_exceeded
 	mz->on_tree = false;
 }
 
-static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
-				       struct mem_cgroup_tree_per_zone *mctz)
+static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
+				       struct mem_cgroup_tree_per_node *mctz)
 {
 	unsigned long flags;
 
@@ -473,8 +464,8 @@ static unsigned long soft_limit_excess(s
 static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 {
 	unsigned long excess;
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup_tree_per_zone *mctz;
+	struct mem_cgroup_per_node *mz;
+	struct mem_cgroup_tree_per_node *mctz;
 
 	mctz = soft_limit_tree_from_page(page);
 	/*
@@ -482,7 +473,7 @@ static void mem_cgroup_update_tree(struc
 	 * because their event counter is not touched.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		mz = mem_cgroup_page_zoneinfo(memcg, page);
+		mz = mem_cgroup_page_nodeinfo(memcg, page);
 		excess = soft_limit_excess(memcg);
 		/*
 		 * We have to update the tree if mz is on RB-tree or
@@ -507,24 +498,22 @@ static void mem_cgroup_update_tree(struc
 
 static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup_tree_per_zone *mctz;
-	struct mem_cgroup_per_zone *mz;
-	int nid, zid;
+	struct mem_cgroup_tree_per_node *mctz;
+	struct mem_cgroup_per_node *mz;
+	int nid;
 
 	for_each_node(nid) {
-		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-			mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
-			mctz = soft_limit_tree_node_zone(nid, zid);
-			mem_cgroup_remove_exceeded(mz, mctz);
-		}
+		mz = mem_cgroup_nodeinfo(memcg, nid);
+		mctz = soft_limit_tree_node(nid);
+		mem_cgroup_remove_exceeded(mz, mctz);
 	}
 }
 
-static struct mem_cgroup_per_zone *
-__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
+static struct mem_cgroup_per_node *
+__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 {
 	struct rb_node *rightmost = NULL;
-	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_per_node *mz;
 
 retry:
 	mz = NULL;
@@ -532,7 +521,7 @@ retry:
 	if (!rightmost)
 		goto done;		/* Nothing to reclaim from */
 
-	mz = rb_entry(rightmost, struct mem_cgroup_per_zone, tree_node);
+	mz = rb_entry(rightmost, struct mem_cgroup_per_node, tree_node);
 	/*
 	 * Remove the node now but someone else can add it back,
 	 * we will to add it back at the end of reclaim to its correct
@@ -546,10 +535,10 @@ done:
 	return mz;
 }
 
-static struct mem_cgroup_per_zone *
-mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
+static struct mem_cgroup_per_node *
+mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 {
-	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_per_node *mz;
 
 	spin_lock_irq(&mctz->lock);
 	mz = __mem_cgroup_largest_soft_limit_node(mctz);
@@ -643,20 +632,16 @@ unsigned long mem_cgroup_node_nr_lru_pag
 					   int nid, unsigned int lru_mask)
 {
 	unsigned long nr = 0;
-	int zid;
+	struct mem_cgroup_per_node *mz;
+	enum lru_list lru;
 
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct mem_cgroup_per_zone *mz;
-		enum lru_list lru;
-
-		for_each_lru(lru) {
-			if (!(BIT(lru) & lru_mask))
-				continue;
-			mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
-			nr += mz->lru_size[lru];
-		}
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		mz = mem_cgroup_nodeinfo(memcg, nid);
+		nr += mz->lru_size[lru];
 	}
 	return nr;
 }
@@ -809,9 +794,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	rcu_read_lock();
 
 	if (reclaim) {
-		struct mem_cgroup_per_zone *mz;
+		struct mem_cgroup_per_node *mz;
 
-		mz = mem_cgroup_zone_zoneinfo(root, reclaim->zone);
+		mz = mem_cgroup_nodeinfo(root, reclaim->pgdat->node_id);
 		iter = &mz->iter[reclaim->priority];
 
 		if (prev && reclaim->generation != iter->generation)
@@ -910,19 +895,17 @@ static void invalidate_reclaim_iterators
 {
 	struct mem_cgroup *memcg = dead_memcg;
 	struct mem_cgroup_reclaim_iter *iter;
-	struct mem_cgroup_per_zone *mz;
-	int nid, zid;
+	struct mem_cgroup_per_node *mz;
+	int nid;
 	int i;
 
 	while ((memcg = parent_mem_cgroup(memcg))) {
 		for_each_node(nid) {
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
-				for (i = 0; i <= DEF_PRIORITY; i++) {
-					iter = &mz->iter[i];
-					cmpxchg(&iter->position,
-						dead_memcg, NULL);
-				}
+			mz = mem_cgroup_nodeinfo(memcg, nid);
+			for (i = 0; i <= DEF_PRIORITY; i++) {
+				iter = &mz->iter[i];
+				cmpxchg(&iter->position,
+					dead_memcg, NULL);
 			}
 		}
 	}
@@ -946,7 +929,6 @@ static void invalidate_reclaim_iterators
 /**
  * mem_cgroup_lruvec - get the lru list vector for a node or a memcg zone
  * @node: node of the wanted lruvec
- * @zone: zone of the wanted lruvec
  * @memcg: memcg of the wanted lruvec
  *
  * Returns the lru list vector holding pages for a given @node or a given
@@ -954,9 +936,9 @@ static void invalidate_reclaim_iterators
  * is disabled.
  */
 struct lruvec *mem_cgroup_lruvec(struct pglist_data *pgdat,
-				 struct zone *zone, struct mem_cgroup *memcg)
+				 struct mem_cgroup *memcg)
 {
-	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_per_node *mz;
 	struct lruvec *lruvec;
 
 	if (mem_cgroup_disabled()) {
@@ -964,7 +946,7 @@ struct lruvec *mem_cgroup_lruvec(struct
 		goto out;
 	}
 
-	mz = mem_cgroup_zone_zoneinfo(memcg, zone);
+	mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
 	lruvec = &mz->lruvec;
 out:
 	/*
@@ -972,8 +954,8 @@ out:
 	 * we have to be prepared to initialize lruvec->zone here;
 	 * and if offlined then reonlined, we need to reinitialize it.
 	 */
-	if (unlikely(lruvec->pgdat != zone->zone_pgdat))
-		lruvec->pgdat = zone->zone_pgdat;
+	if (unlikely(lruvec->pgdat != pgdat))
+		lruvec->pgdat = pgdat;
 	return lruvec;
 }
 
@@ -988,7 +970,7 @@ out:
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
 {
-	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_per_node *mz;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
@@ -1005,7 +987,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	mz = mem_cgroup_page_zoneinfo(memcg, page);
+	mz = mem_cgroup_page_nodeinfo(memcg, page);
 	lruvec = &mz->lruvec;
 out:
 	/*
@@ -1032,7 +1014,7 @@ out:
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				enum zone_type zid, int nr_pages)
 {
-	struct mem_cgroup_per_zone *mz;
+	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
 	long size;
 	bool empty;
@@ -1042,7 +1024,7 @@ void mem_cgroup_update_lru_size(struct l
 	if (mem_cgroup_disabled())
 		return;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
+	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	lru_size = mz->lru_size + lru;
 	empty = list_empty(lruvec->lists + lru);
 
@@ -1435,7 +1417,7 @@ int mem_cgroup_select_victim_node(struct
 #endif
 
 static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
-				   struct zone *zone,
+				   pg_data_t *pgdat,
 				   gfp_t gfp_mask,
 				   unsigned long *total_scanned)
 {
@@ -1445,7 +1427,7 @@ static int mem_cgroup_soft_reclaim(struc
 	unsigned long excess;
 	unsigned long nr_scanned;
 	struct mem_cgroup_reclaim_cookie reclaim = {
-		.zone = zone,
+		.pgdat = pgdat,
 		.priority = 0,
 	};
 
@@ -1476,7 +1458,7 @@ static int mem_cgroup_soft_reclaim(struc
 			continue;
 		}
 		total += mem_cgroup_shrink_node(victim, gfp_mask, false,
-					zone, &nr_scanned);
+					pgdat, &nr_scanned);
 		*total_scanned += nr_scanned;
 		if (!soft_limit_excess(root_memcg))
 			break;
@@ -2603,22 +2585,22 @@ static int mem_cgroup_resize_memsw_limit
 	return ret;
 }
 
-unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
 					    unsigned long *total_scanned)
 {
 	unsigned long nr_reclaimed = 0;
-	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
+	struct mem_cgroup_per_node *mz, *next_mz = NULL;
 	unsigned long reclaimed;
 	int loop = 0;
-	struct mem_cgroup_tree_per_zone *mctz;
+	struct mem_cgroup_tree_per_node *mctz;
 	unsigned long excess;
 	unsigned long nr_scanned;
 
 	if (order > 0)
 		return 0;
 
-	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
+	mctz = soft_limit_tree_node(pgdat->node_id);
 	/*
 	 * This loop can run a while, specially if mem_cgroup's continuously
 	 * keep exceeding their soft limit and putting the system under
@@ -2633,7 +2615,7 @@ unsigned long mem_cgroup_soft_limit_recl
 			break;
 
 		nr_scanned = 0;
-		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, zone,
+		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
 						    gfp_mask, &nr_scanned);
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
@@ -3254,22 +3236,21 @@ static int memcg_stat_show(struct seq_fi
 
 #ifdef CONFIG_DEBUG_VM
 	{
-		int nid, zid;
-		struct mem_cgroup_per_zone *mz;
+		pg_data_t *pgdat;
+		struct mem_cgroup_per_node *mz;
 		struct zone_reclaim_stat *rstat;
 		unsigned long recent_rotated[2] = {0, 0};
 		unsigned long recent_scanned[2] = {0, 0};
 
-		for_each_online_node(nid)
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
-				rstat = &mz->lruvec.reclaim_stat;
-
-				recent_rotated[0] += rstat->recent_rotated[0];
-				recent_rotated[1] += rstat->recent_rotated[1];
-				recent_scanned[0] += rstat->recent_scanned[0];
-				recent_scanned[1] += rstat->recent_scanned[1];
-			}
+		for_each_online_pgdat(pgdat) {
+			mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+			rstat = &mz->lruvec.reclaim_stat;
+
+			recent_rotated[0] += rstat->recent_rotated[0];
+			recent_rotated[1] += rstat->recent_rotated[1];
+			recent_scanned[0] += rstat->recent_scanned[0];
+			recent_scanned[1] += rstat->recent_scanned[1];
+		}
 		seq_printf(m, "recent_rotated_anon %lu\n", recent_rotated[0]);
 		seq_printf(m, "recent_rotated_file %lu\n", recent_rotated[1]);
 		seq_printf(m, "recent_scanned_anon %lu\n", recent_scanned[0]);
@@ -4123,11 +4104,10 @@ struct mem_cgroup *mem_cgroup_from_id(un
 	return id > 0 ? idr_find(&mem_cgroup_idr, id) : NULL;
 }
 
-static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
+static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup_per_zone *mz;
-	int zone, tmp = node;
+	int tmp = node;
 	/*
 	 * This routine is called against possible nodes.
 	 * But it's BUG to call kmalloc() against offline node.
@@ -4142,18 +4122,16 @@ static int alloc_mem_cgroup_per_zone_inf
 	if (!pn)
 		return 1;
 
-	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-		mz = &pn->zoneinfo[zone];
-		lruvec_init(&mz->lruvec);
-		mz->usage_in_excess = 0;
-		mz->on_tree = false;
-		mz->memcg = memcg;
-	}
+	lruvec_init(&pn->lruvec);
+	pn->usage_in_excess = 0;
+	pn->on_tree = false;
+	pn->memcg = memcg;
+
 	memcg->nodeinfo[node] = pn;
 	return 0;
 }
 
-static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
+static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	kfree(memcg->nodeinfo[node]);
 }
@@ -4164,7 +4142,7 @@ static void mem_cgroup_free(struct mem_c
 
 	memcg_wb_domain_exit(memcg);
 	for_each_node(node)
-		free_mem_cgroup_per_zone_info(memcg, node);
+		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->stat);
 	kfree(memcg);
 }
@@ -4193,7 +4171,7 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 
 	for_each_node(node)
-		if (alloc_mem_cgroup_per_zone_info(memcg, node))
+		if (alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
 
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
@@ -5796,18 +5774,12 @@ static int __init mem_cgroup_init(void)
 
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
-		int zone;
 
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
 				    node_online(node) ? node : NUMA_NO_NODE);
 
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-			struct mem_cgroup_tree_per_zone *rtpz;
-
-			rtpz = &rtpn->rb_tree_per_zone[zone];
-			rtpz->rb_root = RB_ROOT;
-			spin_lock_init(&rtpz->lock);
-		}
+		rtpn->rb_root = RB_ROOT;
+		spin_lock_init(&rtpn->lock);
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 	}
 
diff -puN mm/vmscan.c~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes
+++ a/mm/vmscan.c
@@ -2229,8 +2229,7 @@ static inline void init_tlb_ubc(void)
 static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memcg,
 			      struct scan_control *sc, unsigned long *lru_pages)
 {
-	struct zone *zone = &pgdat->node_zones[sc->reclaim_idx];
-	struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, zone, memcg);
+	struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, memcg);
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long targets[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
@@ -2437,7 +2436,7 @@ static bool shrink_node(pg_data_t *pgdat
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
 		struct mem_cgroup_reclaim_cookie reclaim = {
-			.zone = &pgdat->node_zones[classzone_idx],
+			.pgdat = pgdat,
 			.priority = sc->priority,
 		};
 		unsigned long node_lru_pages = 0;
@@ -2644,7 +2643,7 @@ static void shrink_zones(struct zonelist
 			 * and balancing, not for a memcg's limit.
 			 */
 			nr_soft_scanned = 0;
-			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone->zone_pgdat,
 						sc->order, sc->gfp_mask,
 						&nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
@@ -2911,7 +2910,7 @@ unsigned long try_to_free_pages(struct z
 
 unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 						gfp_t gfp_mask, bool noswap,
-						struct zone *zone,
+						pg_data_t *pgdat,
 						unsigned long *nr_scanned)
 {
 	struct scan_control sc = {
@@ -2919,7 +2918,7 @@ unsigned long mem_cgroup_shrink_node(str
 		.target_mem_cgroup = memcg,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
-		.reclaim_idx = zone_idx(zone),
+		.reclaim_idx = MAX_NR_ZONES - 1,
 		.may_swap = !noswap,
 	};
 	unsigned long lru_pages;
@@ -2938,7 +2937,7 @@ unsigned long mem_cgroup_shrink_node(str
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_node_memcg(zone->zone_pgdat, memcg, &sc, &lru_pages);
+	shrink_node_memcg(pgdat, memcg, &sc, &lru_pages);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
@@ -2958,6 +2957,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+		.reclaim_idx = MAX_NR_ZONES - 1,
 		.target_mem_cgroup = memcg,
 		.priority = DEF_PRIORITY,
 		.may_writepage = !laptop_mode,
@@ -2987,7 +2987,7 @@ unsigned long try_to_free_mem_cgroup_pag
 #endif
 
 static void age_active_anon(struct pglist_data *pgdat,
-				struct zone *zone, struct scan_control *sc)
+				struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
 
@@ -2996,7 +2996,7 @@ static void age_active_anon(struct pglis
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, zone, memcg);
+		struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, memcg);
 
 		if (inactive_list_is_low(lruvec, false))
 			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
@@ -3184,7 +3184,7 @@ static int balance_pgdat(pg_data_t *pgda
 		 * pages are rotated regardless of classzone as this is
 		 * about consistent aging.
 		 */
-		age_active_anon(pgdat, &pgdat->node_zones[MAX_NR_ZONES - 1], &sc);
+		age_active_anon(pgdat, &sc);
 
 		/*
 		 * If we're getting trouble reclaiming, start doing writepage
@@ -3196,7 +3196,7 @@ static int balance_pgdat(pg_data_t *pgda
 		/* Call soft limit reclaim before calling shrink_node. */
 		sc.nr_scanned = 0;
 		nr_soft_scanned = 0;
-		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone, sc.order,
+		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(pgdat, sc.order,
 						sc.gfp_mask, &nr_soft_scanned);
 		sc.nr_reclaimed += nr_soft_reclaimed;
 
diff -puN mm/workingset.c~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes mm/workingset.c
--- a/mm/workingset.c~mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes
+++ a/mm/workingset.c
@@ -218,7 +218,7 @@ void *workingset_eviction(struct address
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
-	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, zone, memcg);
+	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, memcg);
 	eviction = atomic_long_inc_return(&lruvec->inactive_age);
 	return pack_shadow(memcgid, zone, eviction);
 }
@@ -267,7 +267,7 @@ bool workingset_refault(void *shadow)
 		rcu_read_unlock();
 		return false;
 	}
-	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, zone, memcg);
+	lruvec = mem_cgroup_lruvec(zone->zone_pgdat, memcg);
 	refault = atomic_long_read(&lruvec->inactive_age);
 	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE);
 	rcu_read_unlock();
@@ -317,7 +317,7 @@ void workingset_activation(struct page *
 	 */
 	if (!mem_cgroup_disabled() && !page_memcg(page))
 		goto out;
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), page_zone(page), page_memcg(page));
+	lruvec = mem_cgroup_lruvec(page_pgdat(page), page_memcg(page));
 	atomic_long_inc(&lruvec->inactive_age);
 out:
 	unlock_page_memcg(page);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-update-classzone_idx-if-buffer_heads_over_limit.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch

