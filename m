From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:37 -0800
Message-ID: <20120113203237.F3A7610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52529 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab2AMUcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:39 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so355515ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: per-priority per-zone hierarchy scan generations
has been removed from the -mm tree.  Its filename was
     mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: per-priority per-zone hierarchy scan generations

Memory cgroup limit reclaim currently picks one memory cgroup out of the
target hierarchy, remembers it as the last scanned child, and reclaims all
zones in it with decreasing priority levels.

The new hierarchy reclaim code will pick memory cgroups from the same
hierarchy concurrently from different zones and priority levels, it
becomes necessary that hierarchy roots not only remember the last scanned
child, but do so for each zone and priority level.

Until now, we reclaimed memcgs like this:

    mem = mem_cgroup_iter(root)
    for each priority level:
      for each zone in zonelist:
        reclaim(mem, zone)

But subsequent patches will move the memcg iteration inside the loop over
the zones:

    for each priority level:
      for each zone in zonelist:
        mem = mem_cgroup_iter(root)
        reclaim(mem, zone)

And to keep with the original scan order - memcg -> priority -> zone - the
last scanned memcg has to be remembered per zone and per priority level.

Furthermore, global reclaim will be switched to the hierarchy walk as
well.  Different from limit reclaim, which can just recheck the limit
after some reclaim progress, its target is to scan all memcgs for the
desired zone pages, proportional to the memcg size, and so reliably
detecting a full hierarchy round-trip will become crucial.

Currently, the code relies on one reclaimer encountering the same memcg
twice, but that is error-prone with concurrent reclaimers.  Instead, use a
generation counter that is increased every time the child with the highest
ID has been visited, so that reclaimers can stop when the generation
changes.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   65 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-per-priority-per-zone-hierarchy-scan-generations mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-per-priority-per-zone-hierarchy-scan-generations
+++ a/mm/memcontrol.c
@@ -123,6 +123,13 @@ struct mem_cgroup_stat_cpu {
 	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
+struct mem_cgroup_reclaim_iter {
+	/* css_id of the last scanned hierarchy member */
+	int position;
+	/* scan generation, increased every round-trip */
+	unsigned int generation;
+};
+
 /*
  * per-zone information in memory controller.
  */
@@ -133,6 +140,8 @@ struct mem_cgroup_per_zone {
 	struct list_head	lists[NR_LRU_LISTS];
 	unsigned long		count[NR_LRU_LISTS];
 
+	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
+
 	struct zone_reclaim_stat reclaim_stat;
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long long	usage_in_excess;/* Set to the value by which */
@@ -233,11 +242,6 @@ struct mem_cgroup {
 	 * per zone LRU lists.
 	 */
 	struct mem_cgroup_lru_info info;
-	/*
-	 * While reclaiming in a hierarchy, we cache the last child we
-	 * reclaimed from.
-	 */
-	int last_scanned_child;
 	int last_scanned_node;
 #if MAX_NUMNODES > 1
 	nodemask_t	scan_nodes;
@@ -853,9 +857,16 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return memcg;
 }
 
-static struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
-					  struct mem_cgroup *prev,
-					  bool reclaim)
+struct mem_cgroup_reclaim_cookie {
+	struct zone *zone;
+	int priority;
+	unsigned int generation;
+};
+
+static struct mem_cgroup *
+mem_cgroup_iter(struct mem_cgroup *root,
+		struct mem_cgroup *prev,
+		struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup *memcg = NULL;
 	int id = 0;
@@ -876,10 +887,20 @@ static struct mem_cgroup *mem_cgroup_ite
 	}
 
 	while (!memcg) {
+		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
 		struct cgroup_subsys_state *css;
 
-		if (reclaim)
-			id = root->last_scanned_child;
+		if (reclaim) {
+			int nid = zone_to_nid(reclaim->zone);
+			int zid = zone_idx(reclaim->zone);
+			struct mem_cgroup_per_zone *mz;
+
+			mz = mem_cgroup_zoneinfo(root, nid, zid);
+			iter = &mz->reclaim_iter[reclaim->priority];
+			if (prev && reclaim->generation != iter->generation)
+				return NULL;
+			id = iter->position;
+		}
 
 		rcu_read_lock();
 		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
@@ -891,8 +912,13 @@ static struct mem_cgroup *mem_cgroup_ite
 			id = 0;
 		rcu_read_unlock();
 
-		if (reclaim)
-			root->last_scanned_child = id;
+		if (reclaim) {
+			iter->position = id;
+			if (!css)
+				iter->generation++;
+			else if (!prev && memcg)
+				reclaim->generation = iter->generation;
+		}
 
 		if (prev && !css)
 			return NULL;
@@ -915,14 +941,14 @@ static void mem_cgroup_iter_break(struct
  * be used for reference counting.
  */
 #define for_each_mem_cgroup_tree(iter, root)		\
-	for (iter = mem_cgroup_iter(root, NULL, false);	\
+	for (iter = mem_cgroup_iter(root, NULL, NULL);	\
 	     iter != NULL;				\
-	     iter = mem_cgroup_iter(root, iter, false))
+	     iter = mem_cgroup_iter(root, iter, NULL))
 
 #define for_each_mem_cgroup(iter)			\
-	for (iter = mem_cgroup_iter(NULL, NULL, false);	\
+	for (iter = mem_cgroup_iter(NULL, NULL, NULL);	\
 	     iter != NULL;				\
-	     iter = mem_cgroup_iter(NULL, iter, false))
+	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
@@ -1692,6 +1718,10 @@ static int mem_cgroup_hierarchical_recla
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
 	unsigned long excess;
 	unsigned long nr_scanned;
+	struct mem_cgroup_reclaim_cookie reclaim = {
+		.zone = zone,
+		.priority = 0,
+	};
 
 	excess = res_counter_soft_limit_excess(&root_memcg->res) >> PAGE_SHIFT;
 
@@ -1700,7 +1730,7 @@ static int mem_cgroup_hierarchical_recla
 		noswap = true;
 
 	while (1) {
-		victim = mem_cgroup_iter(root_memcg, victim, true);
+		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
 		if (!victim) {
 			loop++;
 			/*
@@ -5028,7 +5058,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
 	}
-	memcg->last_scanned_child = 0;
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

