From: akpm@linux-foundation.org
Subject: + memcg-enum-lru_list-lru.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:32:25 -0800
Message-ID: <20120117223226.3684D100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42415 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab2AQWc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:32:27 -0500
Received: by yenl12 with SMTP id l12so120180yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:32:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: enum lru_list lru
has been added to the -mm tree.  Its filename is
     memcg-enum-lru_list-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -699,14 +699,14 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
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
@@ -3682,10 +3682,10 @@ move_account:
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
@@ -4714,7 +4714,7 @@ static int alloc_mem_cgroup_per_zone_inf
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
-	enum lru_list l;
+	enum lru_list lru;
 	int zone, tmp = node;
 	/*
 	 * This routine is called against possible nodes.
@@ -4732,8 +4732,8 @@ static int alloc_mem_cgroup_per_zone_inf
 
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
Subject: Subject: memcg: enum lru_list lru

Patches currently in -mm which might be from hughd@google.com are

origin.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
prio_tree-debugging-patch.patch

