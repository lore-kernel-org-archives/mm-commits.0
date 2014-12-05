From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
 added to -mm tree
Date: Fri, 05 Dec 2014 14:38:05 -0800
Message-ID: <548233cd.hm9kNS9SzUMMltvs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLEWiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Dec 2014 17:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: embed OOM killing naturally into allocation slowpath
has been added to the -mm tree.  Its filename is
     mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch

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
Subject: mm: page_alloc: embed OOM killing naturally into allocation slowpath

The OOM killing invocation does a lot of duplicative checks against the
task's allocation context.  Rework it to take advantage of the existing
checks in the allocator slowpath.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    5 --
 mm/page_alloc.c     |   80 ++++++++++++++++++------------------------
 2 files changed, 35 insertions(+), 50 deletions(-)

diff -puN include/linux/oom.h~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath include/linux/oom.h
--- a/include/linux/oom.h~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath
+++ a/include/linux/oom.h
@@ -85,11 +85,6 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
-static inline bool oom_gfp_allowed(gfp_t gfp_mask)
-{
-	return (gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY);
-}
-
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
 /* sysctls */
diff -puN mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath
+++ a/mm/page_alloc.c
@@ -2331,12 +2331,21 @@ static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int classzone_idx, int migratetype)
+	int classzone_idx, int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page;
 
-	/* Acquire the per-zone oom lock for each zone */
+	*did_some_progress = 0;
+
+	if (oom_killer_disabled)
+		return NULL;
+
+	/*
+	 * Acquire the per-zone oom lock for each zone.  If that
+	 * fails, somebody else is making progress for us.
+	 */
 	if (!oom_zonelist_trylock(zonelist, gfp_mask)) {
+		*did_some_progress = 1;
 		schedule_timeout_uninterruptible(1);
 		return NULL;
 	}
@@ -2362,12 +2371,18 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		goto out;
 
 	if (!(gfp_mask & __GFP_NOFAIL)) {
+		/* Coredumps can quickly deplete all memory reserves */
+		if (current->flags & PF_DUMPCORE)
+			goto out;
 		/* The OOM killer will not help higher order allocs */
 		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			goto out;
 		/* The OOM killer does not needlessly kill tasks for lowmem */
 		if (high_zoneidx < ZONE_NORMAL)
 			goto out;
+		/* The OOM killer does not compensate for light reclaim */
+		if (!(gfp_mask & __GFP_FS))
+			goto out;
 		/*
 		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
 		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
@@ -2380,7 +2395,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	}
 	/* Exhausted what can be done so it's blamo time */
 	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
-
+	*did_some_progress = 1;
 out:
 	oom_zonelist_unlock(zonelist, gfp_mask);
 	return page;
@@ -2657,7 +2672,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	    (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
-restart:
 	if (!(gfp_mask & __GFP_NO_KSWAPD))
 		wake_all_kswapds(order, zonelist, high_zoneidx,
 				preferred_zone, nodemask);
@@ -2787,51 +2801,27 @@ rebalance:
 	if (page)
 		goto got_pg;
 
-	/*
-	 * If we failed to make any progress reclaiming, then we are
-	 * running out of options and have to consider going OOM
-	 */
-	if (!did_some_progress) {
-		if (oom_gfp_allowed(gfp_mask)) {
-			if (oom_killer_disabled)
-				goto nopage;
-			/* Coredumps can quickly deplete all memory reserves */
-			if ((current->flags & PF_DUMPCORE) &&
-			    !(gfp_mask & __GFP_NOFAIL))
-				goto nopage;
-			page = __alloc_pages_may_oom(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask, preferred_zone,
-					classzone_idx, migratetype);
-			if (page)
-				goto got_pg;
-
-			if (!(gfp_mask & __GFP_NOFAIL)) {
-				/*
-				 * The oom killer is not called for high-order
-				 * allocations that may fail, so if no progress
-				 * is being made, there are no other options and
-				 * retrying is unlikely to help.
-				 */
-				if (order > PAGE_ALLOC_COSTLY_ORDER)
-					goto nopage;
-				/*
-				 * The oom killer is not called for lowmem
-				 * allocations to prevent needlessly killing
-				 * innocent tasks.
-				 */
-				if (high_zoneidx < ZONE_NORMAL)
-					goto nopage;
-			}
-
-			goto restart;
-		}
-	}
-
 	/* Check if we should retry the allocation */
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, did_some_progress,
 						pages_reclaimed)) {
+		/*
+		 * If we fail to make progress by freeing individual
+		 * pages, but the allocation wants us to keep going,
+		 * start OOM killing tasks.
+		 */
+		if (!did_some_progress) {
+			page = __alloc_pages_may_oom(gfp_mask, order, zonelist,
+						high_zoneidx, nodemask,
+						preferred_zone, classzone_idx,
+						migratetype,&did_some_progress);
+			if (page)
+				goto got_pg;
+			if (!did_some_progress) {
+				BUG_ON(gfp_mask & __GFP_NOFAIL);
+				goto nopage;
+			}
+		}
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
 		goto rebalance;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
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
mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-oom-remove-gfp-helper-function.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch

