From: akpm@linux-foundation.org
Subject: + mm-memcg-move-swapin-charge-functions-above-callsites.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:44 -0700
Message-ID: <20120713212945.B88255C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38275 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab2GMV3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:48 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so149058eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: move swapin charge functions above callsites
has been added to the -mm tree.  Its filename is
     mm-memcg-move-swapin-charge-functions-above-callsites.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2797,37 +2797,6 @@ int mem_cgroup_newpage_charge(struct pag
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
@@ -2874,6 +2843,15 @@ charge_cur_mm:
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
@@ -2911,13 +2889,31 @@ void mem_cgroup_commit_charge_swapin(str
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
Subject: Subject: mm: memcg: move swapin charge functions above callsites

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-slab-remove-duplicate-check.patch
vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
memcg-remove-check-for-signal_pending-during-rmdir.patch
memcg-clean-up-force_empty_list-return-value-check.patch
memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
memcg-fix-bad-behavior-in-use_hierarchy-file.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch
mm-swapfile-clean-up-unuse_pte-race-handling.patch
mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch
mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch
mm-memcg-move-swapin-charge-functions-above-callsites.patch
mm-memcg-remove-unneeded-shmem-charge-type.patch
mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch
mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch
mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch
mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch

