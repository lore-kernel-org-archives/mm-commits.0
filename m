From: akpm@linux-foundation.org
Subject: + mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:30:02 -0700
Message-ID: <20120713213003.0E9B25C006A@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:55434 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2GMVaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:30:05 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so205133wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:30:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: only check anon swapin page charges for swap cache
has been added to the -mm tree.  Its filename is
     mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch

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
Subject: mm: memcg: only check anon swapin page charges for swap cache

shmem knows for sure that the page is in swap cache when attempting to
charge a page, because the cache charge entry function has a check for it.
Only anon pages may be removed from swap cache already when trying to
charge their swapin.

Adjust the comment, though: '4969c11 mm: fix swapin race condition' added
a stable PageSwapCache check under the page lock in the do_swap_page()
before calling the memory controller, so it's unuse_pte()'s pte_same()
that may fail.

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

 mm/memcontrol.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache
+++ a/mm/memcontrol.c
@@ -2819,14 +2819,6 @@ static int __mem_cgroup_try_charge_swapi
 		return 0;
 	if (!do_swap_account)
 		goto charge_cur_mm;
-	/*
-	 * A racing thread's fault, or swapoff, may have already updated
-	 * the pte, and even removed page from swap cache: in those cases
-	 * do_swap_page()'s pte_same() test will fail; but there's also a
-	 * KSM case which does need to charge the page.
-	 */
-	if (!PageSwapCache(page))
-		goto charge_cur_mm;
 	memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		goto charge_cur_mm;
@@ -2849,6 +2841,20 @@ int mem_cgroup_try_charge_swapin(struct 
 	*memcgp = NULL;
 	if (mem_cgroup_disabled())
 		return 0;
+	/*
+	 * A racing thread's fault, or swapoff, may have already
+	 * updated the pte, and even removed page from swap cache: in
+	 * those cases unuse_pte()'s pte_same() test will fail; but
+	 * there's also a KSM case which does need to charge the page.
+	 */
+	if (!PageSwapCache(page)) {
+		int ret;
+
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, memcgp, true);
+		if (ret == -EINTR)
+			ret = 0;
+		return ret;
+	}
 	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
 }
 
_
Subject: Subject: mm: memcg: only check anon swapin page charges for swap cache

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

