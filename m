From: akpm@linux-foundation.org
Subject: [merged]
 revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
 removed from -mm tree
Date: Wed, 07 May 2014 12:05:13 -0700
Message-ID: <536a83e9.XtnQySZq+aQpFPaO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaEGTFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, borntraeger@de.ibm.com, aquini@redhat.com, hannes@cmpxchg.org

Subject: [merged] revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch removed from -mm tree
To: hannes@cmpxchg.org,aquini@redhat.com,borntraeger@de.ibm.com,riel@redhat.com,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:13 -0700


The patch titled
     Subject: revert "mm: vmscan: do not swap anon pages just because free+file is low"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: revert "mm: vmscan: do not swap anon pages just because free+file is low"

This reverts commit 0bf1457f0cfc ("mm: vmscan: do not swap anon pages just
because free+file is low") because it introduced a regression in
mostly-anonymous workloads, where reclaim would become ineffective and
trap every allocating task in direct reclaim.

The problem is that there is a runaway feedback loop in the scan balance
between file and anon, where the balance tips heavily towards a tiny
thrashing file LRU and anonymous pages are no longer being looked at.  The
commit in question removed the safe guard that would detect such
situations and respond with forced anonymous reclaim.

This commit was part of a series to fix premature swapping in loads with
relatively little cache, and while it made a small difference, the cure is
obviously worse than the disease.  Revert it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>		[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN mm/vmscan.c~revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low mm/vmscan.c
--- a/mm/vmscan.c~revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low
+++ a/mm/vmscan.c
@@ -1916,6 +1916,24 @@ static void get_scan_count(struct lruvec
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	/*
+	 * Prevent the reclaimer from falling into the cache trap: as
+	 * cache pages start out inactive, every cache fault will tip
+	 * the scan balance towards the file LRU.  And as the file LRU
+	 * shrinks, so does the window for rotation from references.
+	 * This means we have a runaway feedback loop where a tiny
+	 * thrashing file LRU becomes infinitely more attractive than
+	 * anon pages.  Try to detect this based on file LRU size.
+	 */
+	if (global_reclaim(sc)) {
+		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
+
+		if (unlikely(file + free <= high_wmark_pages(zone))) {
+			scan_balance = SCAN_ANON;
+			goto out;
+		}
+	}
+
+	/*
 	 * There is enough inactive page cache, do not reclaim
 	 * anything from the anonymous working set right now.
 	 */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

