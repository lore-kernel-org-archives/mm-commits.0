From: akpm@linux-foundation.org
Subject: + mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:41 -0700
Message-ID: <20120713212942.5DD2A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:60987 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2GMV3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:43 -0400
Received: by ghbz15 with SMTP id z15so386750ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: only check for PageSwapCache when uncharging anon
has been added to the -mm tree.  Its filename is
     mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch

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
Subject: mm: memcg: only check for PageSwapCache when uncharging anon

Only anon pages that are uncharged at the time of the last page table
mapping vanishing may be in swapcache.

When shmem pages, file pages, swap-freed anon pages, or just migrated
pages are uncharged, they are known for sure to be not in swapcache.

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

 mm/memcontrol.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-only-check-for-pageswapcache-when-uncharging-anon mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-only-check-for-pageswapcache-when-uncharging-anon
+++ a/mm/memcontrol.c
@@ -3094,8 +3094,6 @@ void mem_cgroup_uncharge_cache_page(stru
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
-	if (PageSwapCache(page))
-		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -3160,8 +3158,6 @@ mem_cgroup_uncharge_swapcache(struct pag
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
-	if (PageSwapCache(page))
-		return;
 	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
@@ -3351,11 +3347,10 @@ void mem_cgroup_end_migration(struct mem
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	if (!PageSwapCache(unused))
-		__mem_cgroup_uncharge_common(unused,
-					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
-					     true);
+	__mem_cgroup_uncharge_common(unused,
+				     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+				     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+				     true);
 	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
_
Subject: Subject: mm: memcg: only check for PageSwapCache when uncharging anon

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

