From: akpm@linux-foundation.org
Subject: + mm-memcg-remove-unneeded-shmem-charge-type.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:48 -0700
Message-ID: <20120713212949.CB58F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:55434 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab2GMV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:52 -0400
Received: by wgbdt11 with SMTP id dt11so205133wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: remove unneeded shmem charge type
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-unneeded-shmem-charge-type.patch

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
Subject: mm: memcg: remove unneeded shmem charge type

shmem page charges have not needed a separate charge type to tell them
from regular file pages since 08e552c ("memcg: synchronized LRU").

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

 mm/memcontrol.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-unneeded-shmem-charge-type mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-unneeded-shmem-charge-type
+++ a/mm/memcontrol.c
@@ -379,7 +379,6 @@ static bool move_file(void)
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_ANON,
-	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
 	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
 	NR_CHARGE_TYPE,
@@ -2903,8 +2902,6 @@ int mem_cgroup_cache_charge(struct page 
 
 	if (unlikely(!mm))
 		mm = &init_mm;
-	if (!page_is_file_cache(page))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
@@ -3311,10 +3308,8 @@ void mem_cgroup_prepare_migration(struct
 	 */
 	if (PageAnon(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_ANON;
-	else if (page_is_file_cache(page))
-		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
-		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	/*
 	 * The page is committed to the memcg, but it's not actually
 	 * charged to the res_counter since we plan on replacing the
@@ -3408,10 +3403,6 @@ void mem_cgroup_replace_page_cache(struc
 	 */
 	if (!memcg)
 		return;
-
-	if (PageSwapBacked(oldpage))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-
 	/*
 	 * Even if newpage->mapping was NULL before starting replacement,
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
_
Subject: Subject: mm: memcg: remove unneeded shmem charge type

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

