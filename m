From: akpm@linux-foundation.org
Subject: [merged] memcg-enum-lru_list-lru.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:34 -0700
Message-ID: <20120322201934.70099A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35764 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2CVUTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:36 -0400
Received: by vcbfk26 with SMTP id fk26so402357vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enum lru_list lru
has been removed from the -mm tree.  Its filename was
     memcg-enum-lru_list-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: enum lru_list lru

Mostly we use "enum lru_list lru": change those few "l"s to "lru"s.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-enum-lru_list-lru mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-enum-lru_list-lru
+++ a/mm/memcontrol.c
@@ -719,14 +719,14 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
 			unsigned int lru_mask)
 {
 	struct mem_cgroup_per_zone *mz;
-	enum lru_list l;
+	enum lru_list lru;
 	unsigned long ret = 0;
 
 	mz = mem_cgroup_zoneinfo(memcg, nid, zid);
 
-	for_each_lru(l) {
-		if (BIT(l) & lru_mask)
-			ret += mz->lru_size[l];
+	for_each_lru(lru) {
+		if (BIT(lru) & lru_mask)
+			ret += mz->lru_size[lru];
 	}
 	return ret;
 }
@@ -3701,10 +3701,10 @@ move_account:
 		mem_cgroup_start_move(memcg);
 		for_each_node_state(node, N_HIGH_MEMORY) {
 			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
-				enum lru_list l;
-				for_each_lru(l) {
+				enum lru_list lru;
+				for_each_lru(lru) {
 					ret = mem_cgroup_force_empty_list(memcg,
-							node, zid, l);
+							node, zid, lru);
 					if (ret)
 						break;
 				}
@@ -4734,7 +4734,7 @@ static int alloc_mem_cgroup_per_zone_inf
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
-	enum lru_list l;
+	enum lru_list lru;
 	int zone, tmp = node;
 	/*
 	 * This routine is called against possible nodes.
@@ -4752,8 +4752,8 @@ static int alloc_mem_cgroup_per_zone_inf
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-		for_each_lru(l)
-			INIT_LIST_HEAD(&mz->lruvec.lists[l]);
+		for_each_lru(lru)
+			INIT_LIST_HEAD(&mz->lruvec.lists[lru]);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

