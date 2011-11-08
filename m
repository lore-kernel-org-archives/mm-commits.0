From: akpm@linux-foundation.org
Subject: + mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch added to -mm tree
Date: Tue, 08 Nov 2011 13:39:19 -0800
Message-ID: <201111082139.pA8LdJvF000654@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1KHVk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 16:40:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com


The patch titled
     Subject: mm: memcg: per-priority per-zone hierarchy scan generations
has been added to the -mm tree.  Its filename is
     mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch

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
@@ -121,6 +121,13 @@ struct mem_cgroup_stat_cpu {
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
@@ -131,6 +138,8 @@ struct mem_cgroup_per_zone {
 	struct list_head	lists[NR_LRU_LISTS];
 	unsigned long		count[NR_LRU_LISTS];
 
+	struct mem_cgroup_reclaim_iter reclaim_iter[DEF_PRIORITY + 1];
+
 	struct zone_reclaim_stat reclaim_stat;
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long long	usage_in_excess;/* Set to the value by which */
@@ -231,11 +240,6 @@ struct mem_cgroup {
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
@@ -787,9 +791,16 @@ struct mem_cgroup *try_get_mem_cgroup_fr
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
@@ -810,10 +821,20 @@ static struct mem_cgroup *mem_cgroup_ite
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
@@ -825,8 +846,13 @@ static struct mem_cgroup *mem_cgroup_ite
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
@@ -849,14 +875,14 @@ static void mem_cgroup_iter_break(struct
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
@@ -1626,6 +1652,10 @@ static int mem_cgroup_hierarchical_recla
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
 	unsigned long excess;
 	unsigned long nr_scanned;
+	struct mem_cgroup_reclaim_cookie reclaim = {
+		.zone = zone,
+		.priority = 0,
+	};
 
 	excess = res_counter_soft_limit_excess(&root_memcg->res) >> PAGE_SHIFT;
 
@@ -1634,7 +1664,7 @@ static int mem_cgroup_hierarchical_recla
 		noswap = true;
 
 	while (1) {
-		victim = mem_cgroup_iter(root_memcg, victim, true);
+		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
 		if (!victim) {
 			loop++;
 			/*
@@ -4887,7 +4917,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
 	}
-	memcg->last_scanned_child = 0;
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
 
_
Subject: Subject: mm: memcg: per-priority per-zone hierarchy scan generations

Patches currently in -mm which might be from jweiner@redhat.com are

mm-add-extra-free-kbytes-tunable.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch

