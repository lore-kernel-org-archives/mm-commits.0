From: akpm@linux-foundation.org
Subject: [merged] memcg-make-mem_cgroup_force_empty_list-return-bool.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:24 -0700
Message-ID: <20120801201324.C7A731E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:25 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make mem_cgroup_force_empty_list() return bool
has been removed from the -mm tree.  Its filename was
     memcg-make-mem_cgroup_force_empty_list-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: make mem_cgroup_force_empty_list() return bool

mem_cgroup_force_empty_list() just returns 0 or -EBUSY and -EBUSY
indicates 'you need to retry'.  Make mem_cgroup_force_empty_list() return
a bool to simplify the logic.

[akpm@linux-foundation.org: rework mem_cgroup_force_empty_list()'s comment]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_force_empty_list-return-bool mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_force_empty_list-return-bool
+++ a/mm/memcontrol.c
@@ -3609,10 +3609,12 @@ unsigned long mem_cgroup_soft_limit_recl
 }
 
 /*
- * This routine traverse page_cgroup in given list and drop them all.
- * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
+ * Traverse a specified page_cgroup list and try to drop them all.  This doesn't
+ * reclaim the pages page themselves - it just removes the page_cgroups.
+ * Returns true if some page_cgroups were not freed, indicating that the caller
+ * must retry this operation.
  */
-static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
+static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 				int node, int zid, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
@@ -3620,7 +3622,6 @@ static int mem_cgroup_force_empty_list(s
 	struct list_head *list;
 	struct page *busy;
 	struct zone *zone;
-	int ret = 0;
 
 	zone = &NODE_DATA(node)->node_zones[zid];
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
@@ -3634,7 +3635,6 @@ static int mem_cgroup_force_empty_list(s
 		struct page_cgroup *pc;
 		struct page *page;
 
-		ret = 0;
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		if (list_empty(list)) {
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -3651,19 +3651,14 @@ static int mem_cgroup_force_empty_list(s
 
 		pc = lookup_page_cgroup(page);
 
-		ret = mem_cgroup_move_parent(page, pc, memcg);
-
-		if (ret == -EBUSY || ret == -EINVAL) {
+		if (mem_cgroup_move_parent(page, pc, memcg)) {
 			/* found lock contention or "pc" is obsolete. */
 			busy = page;
 			cond_resched();
 		} else
 			busy = NULL;
 	}
