From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 15:24:50 -0700
Message-ID: <53a4b4b2.nvw7j+BOGlRi6OHv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTWYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org


The patch titled
     Subject: mm: vmscan: remove remains of kswapd-managed zone->all_unreclaimable
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch

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
Subject: mm: vmscan: remove remains of kswapd-managed zone->all_unreclaimable

shrink_zones() has a special branch to skip the all_unreclaimable() check
during hibernation, because a frozen kswapd can't mark a zone
unreclaimable.

But ever since 6e543d5780e3 ("mm: vmscan: fix do_try_to_free_pages()
livelock"), determining a zone to be unreclaimable is done by directly
looking at its scan history and no longer relies on kswapd setting the
per-zone flag.

Remove this branch and let shrink_zones() check the reclaimability of the
target zones regardless of hibernation state.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable
+++ a/mm/vmscan.c
@@ -2540,14 +2540,6 @@ out:
 	if (sc->nr_reclaimed)
 		return sc->nr_reclaimed;
 
-	/*
-	 * As hibernation is going on, kswapd is freezed so that it can't mark
-	 * the zone into all_unreclaimable. Thus bypassing all_unreclaimable
-	 * check.
-	 */
-	if (oom_killer_disabled)
-		return 0;
-
 	/* Aborted reclaim to try compaction? don't OOM, then */
 	if (aborted_reclaim)
 		return 1;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

