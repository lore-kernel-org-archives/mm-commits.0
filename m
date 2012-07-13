From: akpm@linux-foundation.org
Subject: + mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:37 -0700
Message-ID: <20120713212938.2D4B05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38275 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab2GMV3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:41 -0400
Received: by eekd4 with SMTP id d4so149058eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions
has been added to the -mm tree.  Its filename is
     mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch

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
Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions

Not all uncharge paths need to check if the page is swapcache, some of
them can know for sure.

Push down the check into all callsites of uncharge_common() so that the
patch that removes some of them is more obvious.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions
+++ a/mm/memcontrol.c
@@ -2988,8 +2988,7 @@ __mem_cgroup_uncharge_common(struct page
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	if (PageSwapCache(page))
-		return NULL;
+	VM_BUG_ON(PageSwapCache(page));
 
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
@@ -3086,6 +3085,8 @@ void mem_cgroup_uncharge_page(struct pag
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
+	if (PageSwapCache(page))
+		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
 }
 
@@ -3093,6 +3094,8 @@ void mem_cgroup_uncharge_cache_page(stru
 {
 	VM_BUG_ON(page_mapped(page));
 	VM_BUG_ON(page->mapping);
+	if (PageSwapCache(page))
+		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
 }
 
@@ -3157,6 +3160,8 @@ mem_cgroup_uncharge_swapcache(struct pag
 	if (!swapout) /* this was a swap cache but the swap is unused ! */
 		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
 
+	if (PageSwapCache(page))
+		return;
 	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
 
 	/*
@@ -3346,10 +3351,11 @@ void mem_cgroup_end_migration(struct mem
 		unused = oldpage;
 	}
 	anon = PageAnon(used);
-	__mem_cgroup_uncharge_common(unused,
-		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
-		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
-		true);
+	if (!PageSwapCache(unused))
+		__mem_cgroup_uncharge_common(unused,
+					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
+					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
+					     true);
 	css_put(&memcg->css);
 	/*
 	 * We disallowed uncharge of pages under migration because mapcount
_
Subject: Subject: mm: memcg: push down PageSwapCache check into uncharge entry functions

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

