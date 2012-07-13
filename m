From: akpm@linux-foundation.org
Subject: + mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:29:52 -0700
Message-ID: <20120713212953.6586C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56447 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab2GMV3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:29:54 -0400
Received: by mail-yw0-f74.google.com with SMTP id 10so389548yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:29:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: remove needless !mm fixup to init_mm when charging
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch

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
Subject: mm: memcg: remove needless !mm fixup to init_mm when charging

It does not matter to __mem_cgroup_try_charge() if the passed mm is NULL
or init_mm, it will charge the root memcg in either case.

Also fix up the comment in __mem_cgroup_try_charge() that claimed the
init_mm would be charged when no mm was passed.  It's not really
incorrect, but confusing.  Clarify that the root memcg is charged in this
case.

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

 mm/memcontrol.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging
+++ a/mm/memcontrol.c
@@ -2334,7 +2334,7 @@ static int __mem_cgroup_try_charge(struc
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
 	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the init_mm (happens for pagecache usage).
+	 * set, if so charge the root memcg (happens for pagecache usage).
 	 */
 	if (!*ptr && !mm)
 		*ptr = root_mem_cgroup;
@@ -2834,8 +2834,6 @@ int mem_cgroup_try_charge_swapin(struct 
 		ret = 0;
 	return ret;
 charge_cur_mm:
-	if (unlikely(!mm))
-		mm = &init_mm;
 	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
 	if (ret == -EINTR)
 		ret = 0;
@@ -2900,9 +2898,6 @@ int mem_cgroup_cache_charge(struct page 
 	if (PageCompound(page))
 		return 0;
 
-	if (unlikely(!mm))
-		mm = &init_mm;
-
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
 	else { /* page is swapcache/shmem */
_
Subject: Subject: mm: memcg: remove needless !mm fixup to init_mm when charging

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

