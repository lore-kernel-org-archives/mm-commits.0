From: akpm@linux-foundation.org
Subject: +
 memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
 added to -mm tree
Date: Thu, 13 Nov 2014 13:44:38 -0800
Message-ID: <54652646.A2eXfFJ6v0FTMKRB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934141AbaKMVoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: only check memcg_kmem_skip_account in __memcg_kmem_get_cache
has been added to the -mm tree.  Its filename is
     memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: only check memcg_kmem_skip_account in __memcg_kmem_get_cache

__memcg_kmem_get_cache can recurse if it calls kmalloc (which it does if
the cgroup's kmem cache doesn't exist), because kmalloc may call
__memcg_kmem_get_cache internally again.  To avoid the recursion, we use
the task_struct->memcg_kmem_skip_account flag.

However, there's no need checking the flag in memcg_kmem_newpage_charge,
because there's no way how this function could result in recursion, if
called from memcg_kmem_get_cache.  So let's remove the redundant code.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN mm/memcontrol.c~memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -2905,34 +2905,6 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 
 	*_memcg = NULL;
 
-	/*
-	 * Disabling accounting is only relevant for some specific memcg
-	 * internal allocations. Therefore we would initially not have such
-	 * check here, since direct calls to the page allocator that are
-	 * accounted to kmemcg (alloc_kmem_pages and friends) only happen
-	 * outside memcg core. We are mostly concerned with cache allocations,
-	 * and by having this test at memcg_kmem_get_cache, we are already able
-	 * to relay the allocation to the root cache and bypass the memcg cache
-	 * altogether.
-	 *
-	 * There is one exception, though: the SLUB allocator does not create
-	 * large order caches, but rather service large kmallocs directly from
-	 * the page allocator. Therefore, the following sequence when backed by
-	 * the SLUB allocator:
-	 *
-	 *	memcg_stop_kmem_account();
-	 *	kmalloc(<large_number>)
-	 *	memcg_resume_kmem_account();
-	 *
-	 * would effectively ignore the fact that we should skip accounting,
-	 * since it will drive us directly to this function without passing
-	 * through the cache selector memcg_kmem_get_cache. Such large
-	 * allocations are extremely rare but can happen, for instance, for the
-	 * cache arrays. We bring this test here.
-	 */
-	if (current->memcg_kmem_skip_account)
-		return true;
-
 	memcg = get_mem_cgroup_from_mm(current->mm);
 
 	if (!memcg_kmem_is_active(memcg)) {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

