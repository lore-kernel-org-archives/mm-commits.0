From: akpm@linux-foundation.org
Subject: + mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:58 -0700
Message-ID: <20120713212959.5CB7F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43466 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2GMVaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:30:01 -0400
Received: by qabg24 with SMTP id g24so101531qab.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:30:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: only check swap cache pages for repeated charging
has been added to the -mm tree.  Its filename is
     mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch

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
Subject: mm: memcg: only check swap cache pages for repeated charging

Only anon and shmem pages in the swap cache are attempted to be charged
multiple times, from every swap pte fault or from shmem_unuse().  No other
pages require checking PageCgroupUsed().

Charging pages in the swap cache is also serialized by the page lock, and
since both the try_charge and commit_charge are called under the same page
lock section, the PageCgroupUsed() check might as well happen before the
counter charging, let alone reclaim.

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

 mm/memcontrol.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-only-check-swap-cache-pages-for-repeated-charging mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-only-check-swap-cache-pages-for-repeated-charging
+++ a/mm/memcontrol.c
@@ -2539,11 +2539,7 @@ static void __mem_cgroup_commit_charge(s
 	bool anon;
 
 	lock_page_cgroup(pc);
-	if (unlikely(PageCgroupUsed(pc))) {
-		unlock_page_cgroup(pc);
-		__mem_cgroup_cancel_charge(memcg, nr_pages);
-		return;
-	}
+	VM_BUG_ON(PageCgroupUsed(pc));
 	/*
 	 * we don't need page_cgroup_lock about tail pages, becase they are not
 	 * accessed by any other context at this point.
@@ -2808,8 +2804,19 @@ static int __mem_cgroup_try_charge_swapi
 					  struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
 	int ret;
 
+	pc = lookup_page_cgroup(page);
+	/*
+	 * Every swap fault against a single page tries to charge the
+	 * page, bail as early as possible.  shmem_unuse() encounters
+	 * already charged pages, too.  The USED bit is protected by
+	 * the page lock, which serializes swap cache removal, which
+	 * in turn serializes uncharging.
+	 */
+	if (PageCgroupUsed(pc))
+		return 0;
 	if (!do_swap_account)
 		goto charge_cur_mm;
 	/*
_
Subject: Subject: mm: memcg: only check swap cache pages for repeated charging

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

