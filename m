From: akpm@linux-foundation.org
Subject: + mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:55 -0700
Message-ID: <20120713212956.5C3B91E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57210 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab2GMV36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:58 -0400
Received: by vcqp1 with SMTP id p1so137224vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: split swapin charge function into private and public part
has been added to the -mm tree.  Its filename is
     mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch

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
Subject: mm: memcg: split swapin charge function into private and public part

When shmem is charged upon swapin, it does not need to check twice whether
the memory controller is enabled.

Also, shmem pages do not have to be checked for everything that regular
anon pages have to be checked for, so let shmem use the internal version
directly and allow future patches to move around checks that are only
required when swapping in anon pages.

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

 mm/memcontrol.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-split-swapin-charge-function-into-private-and-public-part mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-split-swapin-charge-function-into-private-and-public-part
+++ a/mm/memcontrol.c
@@ -2802,18 +2802,14 @@ int mem_cgroup_newpage_charge(struct pag
  * struct page_cgroup is acquired. This refcnt will be consumed by
  * "commit()" or removed by "cancel()"
  */
-int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
-				 struct page *page,
-				 gfp_t mask, struct mem_cgroup **memcgp)
+static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
+					  struct page *page,
+					  gfp_t mask,
+					  struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
-	*memcgp = NULL;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
 	if (!do_swap_account)
 		goto charge_cur_mm;
 	/*
@@ -2840,6 +2836,15 @@ charge_cur_mm:
 	return ret;
 }
 
+int mem_cgroup_try_charge_swapin(struct mm_struct *mm, struct page *page,
+				 gfp_t gfp_mask, struct mem_cgroup **memcgp)
+{
+	*memcgp = NULL;
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
+}
+
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
@@ -2901,7 +2906,8 @@ int mem_cgroup_cache_charge(struct page 
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
 	else { /* page is swapcache/shmem */
-		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
+		ret = __mem_cgroup_try_charge_swapin(mm, page,
+						     gfp_mask, &memcg);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, memcg, type);
 	}
_
Subject: Subject: mm: memcg: split swapin charge function into private and public part

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

