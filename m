From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:34 -0700
Message-ID: <20120801201140.270FC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54952 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:42 -0400
Received: by eaao12 with SMTP id o12so293185eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rename MEM_CGROUP_CHARGE_TYPE_MAPPED as MEM_CGROUP_CHARGE_TYPE_ANON
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: rename MEM_CGROUP_CHARGE_TYPE_MAPPED as MEM_CGROUP_CHARGE_TYPE_ANON

Now, in memcg, 2 "MAPPED" enum/macro are found
 MEM_CGROUP_CHARGE_TYPE_MAPPED
 MEM_CGROUP_STAT_FILE_MAPPED

Thier names looks similar to each other but the former is used for
accounting anonymous memory. rename it as TYPE_ANON.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon
+++ a/mm/memcontrol.c
@@ -378,7 +378,7 @@ static bool move_file(void)
 
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
-	MEM_CGROUP_CHARGE_TYPE_MAPPED,
+	MEM_CGROUP_CHARGE_TYPE_ANON,
 	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
@@ -2519,7 +2519,7 @@ static void __mem_cgroup_commit_charge(s
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_ANON)
 		anon = true;
 	else
 		anon = false;
@@ -2728,7 +2728,7 @@ int mem_cgroup_newpage_charge(struct pag
 	VM_BUG_ON(page->mapping && !PageAnon(page));
 	VM_BUG_ON(!mm);
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-					MEM_CGROUP_CHARGE_TYPE_MAPPED);
+					MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
 static void
@@ -2842,7 +2842,7 @@ void mem_cgroup_commit_charge_swapin(str
 				     struct mem_cgroup *memcg)
 {
 	__mem_cgroup_commit_charge_swapin(page, memcg,
-					  MEM_CGROUP_CHARGE_TYPE_MAPPED);
+					  MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
@@ -2945,7 +2945,7 @@ __mem_cgroup_uncharge_common(struct page
 	anon = PageAnon(page);
 
 	switch (ctype) {
-	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+	case MEM_CGROUP_CHARGE_TYPE_ANON:
 		/*
 		 * Generally PageAnon tells if it's the anon statistics to be
 		 * updated; but sometimes e.g. mem_cgroup_uncharge_page() is
@@ -3005,7 +3005,7 @@ void mem_cgroup_uncharge_page(struct pag
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
-	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
 void mem_cgroup_uncharge_cache_page(struct page *page)
@@ -3248,7 +3248,7 @@ int mem_cgroup_prepare_migration(struct 
 	 * mapcount will be finally 0 and we call uncharge in end_migration().
 	 */
 	if (PageAnon(page))
-		ctype = MEM_CGROUP_CHARGE_TYPE_MAPPED;
+		ctype = MEM_CGROUP_CHARGE_TYPE_ANON;
 	else if (page_is_file_cache(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
@@ -3287,7 +3287,7 @@ void mem_cgroup_end_migration(struct mem
 	unlock_page_cgroup(pc);
 	anon = PageAnon(used);
 	__mem_cgroup_uncharge_common(unused,
-		anon ? MEM_CGROUP_CHARGE_TYPE_MAPPED
+		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
 		     : MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

