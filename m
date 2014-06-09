From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:40:51 -0700
Message-ID: <53960dc3.BfvTpDnf9OSx5M4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaFITkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, nasa4836@gmail.com

Subject: [merged] mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch removed from -mm tree
To: nasa4836@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:51 -0700


The patch titled
     Subject: mm: memcontrol: clean up memcg zoneinfo lookup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm: memcontrol: clean up memcg zoneinfo lookup

Memcg zoneinfo lookup sites have either the page, the zone, or the node id
and zone index, but sites that only have the zone have to look up the node
id and zone index themselves, whereas sites that already have those two
integers use a function for a simple pointer chase.

Provide mem_cgroup_zone_zoneinfo() that takes a zone pointer and let sites
that already have node id and zone index - all for each node, for each
zone iterators - use &memcg->nodeinfo[nid]->zoneinfo[zid].

Rename page_cgroup_zoneinfo() to mem_cgroup_page_zoneinfo() to match.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   89 ++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 50 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-clean-up-memcg-zoneinfo-lookup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clean-up-memcg-zoneinfo-lookup
+++ a/mm/memcontrol.c
@@ -676,9 +676,11 @@ static void disarm_static_keys(struct me
 static void drain_all_stock_async(struct mem_cgroup *memcg);
 
 static struct mem_cgroup_per_zone *
-mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
+mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
 {
-	VM_BUG_ON((unsigned)nid >= nr_node_ids);
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+
 	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
@@ -688,12 +690,12 @@ struct cgroup_subsys_state *mem_cgroup_c
 }
 
 static struct mem_cgroup_per_zone *
-page_cgroup_zoneinfo(struct mem_cgroup *memcg, struct page *page)
+mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
 {
 	int nid = page_to_nid(page);
 	int zid = page_zonenum(page);
 
-	return mem_cgroup_zoneinfo(memcg, nid, zid);
+	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
 static struct mem_cgroup_tree_per_zone *
@@ -772,16 +774,14 @@ static void mem_cgroup_update_tree(struc
 	unsigned long long excess;
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup_tree_per_zone *mctz;
-	int nid = page_to_nid(page);
-	int zid = page_zonenum(page);
-	mctz = soft_limit_tree_from_page(page);
 
+	mctz = soft_limit_tree_from_page(page);
 	/*
 	 * Necessary to update all ancestors when hierarchy is used.
 	 * because their event counter is not touched.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+		mz = mem_cgroup_page_zoneinfo(memcg, page);
 		excess = res_counter_soft_limit_excess(&memcg->res);
 		/*
 		 * We have to update the tree if mz is on RB-tree or
@@ -804,14 +804,14 @@ static void mem_cgroup_update_tree(struc
 
 static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 {
-	int node, zone;
-	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup_tree_per_zone *mctz;
+	struct mem_cgroup_per_zone *mz;
+	int nid, zid;
 
-	for_each_node(node) {
-		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-			mz = mem_cgroup_zoneinfo(memcg, node, zone);
-			mctz = soft_limit_tree_node_zone(node, zone);
+	for_each_node(nid) {
+		for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+			mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
+			mctz = soft_limit_tree_node_zone(nid, zid);
 			mem_cgroup_remove_exceeded(memcg, mz, mctz);
 		}
 	}
@@ -946,8 +946,7 @@ static void mem_cgroup_charge_statistics
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
 }
 
-unsigned long
-mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
+unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
 
@@ -955,46 +954,38 @@ mem_cgroup_get_lru_size(struct lruvec *l
 	return mz->lru_size[lru];
 }
 
-static unsigned long
-mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
-			unsigned int lru_mask)
-{
-	struct mem_cgroup_per_zone *mz;
-	enum lru_list lru;
-	unsigned long ret = 0;
-
-	mz = mem_cgroup_zoneinfo(memcg, nid, zid);
-
-	for_each_lru(lru) {
-		if (BIT(lru) & lru_mask)
-			ret += mz->lru_size[lru];
-	}
-	return ret;
-}
-
-static unsigned long
-mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-			int nid, unsigned int lru_mask)
+static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+						  int nid,
+						  unsigned int lru_mask)
 {
-	u64 total = 0;
+	unsigned long nr = 0;
 	int zid;
 
-	for (zid = 0; zid < MAX_NR_ZONES; zid++)
-		total += mem_cgroup_zone_nr_lru_pages(memcg,
-						nid, zid, lru_mask);
+	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 
-	return total;
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		struct mem_cgroup_per_zone *mz;
+		enum lru_list lru;
+
+		for_each_lru(lru) {
+			if (!(BIT(lru) & lru_mask))
+				continue;
+			mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
+			nr += mz->lru_size[lru];
+		}
+	}
+	return nr;
 }
 
 static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 			unsigned int lru_mask)
 {
+	unsigned long nr = 0;
 	int nid;
-	u64 total = 0;
 
 	for_each_node_state(nid, N_MEMORY)
-		total += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
-	return total;
+		nr += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
+	return nr;
 }
 
 static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
@@ -1242,11 +1233,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		int uninitialized_var(seq);
 
 		if (reclaim) {
-			int nid = zone_to_nid(reclaim->zone);
-			int zid = zone_idx(reclaim->zone);
 			struct mem_cgroup_per_zone *mz;
 
-			mz = mem_cgroup_zoneinfo(root, nid, zid);
+			mz = mem_cgroup_zone_zoneinfo(root, reclaim->zone);
 			iter = &mz->reclaim_iter[reclaim->priority];
 			if (prev && reclaim->generation != iter->generation) {
 				iter->last_visited = NULL;
@@ -1353,7 +1342,7 @@ struct lruvec *mem_cgroup_zone_lruvec(st
 		goto out;
 	}
 
-	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
+	mz = mem_cgroup_zone_zoneinfo(memcg, zone);
 	lruvec = &mz->lruvec;
 out:
 	/*
@@ -1412,7 +1401,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
 		pc->mem_cgroup = memcg = root_mem_cgroup;
 
-	mz = page_cgroup_zoneinfo(memcg, page);
+	mz = mem_cgroup_page_zoneinfo(memcg, page);
 	lruvec = &mz->lruvec;
 out:
 	/*
@@ -5305,7 +5294,7 @@ static int memcg_stat_show(struct seq_fi
 
 		for_each_online_node(nid)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+				mz = &memcg->nodeinfo[nid]->zoneinfo[zid];
 				rstat = &mz->lruvec.reclaim_stat;
 
 				recent_rotated[0] += rstat->recent_rotated[0];
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
linux-next.patch

