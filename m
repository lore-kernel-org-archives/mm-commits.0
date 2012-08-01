From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-move-swapin-charge-functions-above-callsites.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:01 -0700
Message-ID: <20120801201802.5B8BA200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43672 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2HAUSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:05 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so345285bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: move swapin charge functions above callsites
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-swapin-charge-functions-above-callsites.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: move swapin charge functions above callsites

Charging cache pages may require swapin in the shmem case.  Save the
forward declaration and just move the swapin functions above the cache
charging functions.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   68 +++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-move-swapin-charge-functions-above-callsites mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-move-swapin-charge-functions-above-callsites
+++ a/mm/memcontrol.c
@@ -2796,37 +2796,6 @@ int mem_cgroup_newpage_charge(struct pag
 					MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
-static void
-__mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
-					enum charge_type ctype);
-
-int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
-				gfp_t gfp_mask)
-{
-	struct mem_cgroup *memcg = NULL;
-	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
-	int ret;
-
-	if (mem_cgroup_disabled())
-		return 0;
-	if (PageCompound(page))
-		return 0;
-
-	if (unlikely(!mm))
-		mm = &init_mm;
-	if (!page_is_file_cache(page))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-
-	if (!PageSwapCache(page))
-		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-	else { /* page is swapcache/shmem */
-		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
-		if (!ret)
-			__mem_cgroup_commit_charge_swapin(page, memcg, type);
-	}
-	return ret;
-}
-
 /*
  * While swap-in, try_charge -> commit or cancel, the page is locked.
  * And when try_charge() successfully returns, one refcnt to memcg without
@@ -2873,6 +2842,15 @@ charge_cur_mm:
 	return ret;
 }
 
+void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return;
+	if (!memcg)
+		return;
+	__mem_cgroup_cancel_charge(memcg, 1);
+}
+
 static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
@@ -2910,13 +2888,31 @@ void mem_cgroup_commit_charge_swapin(str
 					  MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
-void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
+int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
+				gfp_t gfp_mask)
 {
+	struct mem_cgroup *memcg = NULL;
+	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
+	int ret;
+
 	if (mem_cgroup_disabled())
-		return;
-	if (!memcg)
-		return;
-	__mem_cgroup_cancel_charge(memcg, 1);
+		return 0;
+	if (PageCompound(page))
+		return 0;
+
+	if (unlikely(!mm))
+		mm = &init_mm;
+	if (!page_is_file_cache(page))
+		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+
+	if (!PageSwapCache(page))
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
+	else { /* page is swapcache/shmem */
+		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
+		if (!ret)
+			__mem_cgroup_commit_charge_swapin(page, memcg, type);
+	}
+	return ret;
 }
 
 static void mem_cgroup_do_uncharge(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

