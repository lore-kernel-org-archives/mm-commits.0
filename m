From: akpm@linux-foundation.org
Subject: +
 revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
 added to -mm tree
Date: Wed, 23 Apr 2014 15:21:35 -0700
Message-ID: <53583cef.eA7HS7pP04Dn+QF/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDWWVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 18:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, borntraeger@de.ibm.com, aquini@redhat.com, hannes@cmpxchg.org

Subject: + revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch added to -mm tree
To: hannes@cmpxchg.org,aquini@redhat.com,borntraeger@de.ibm.com,riel@redhat.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 15:21:35 -0700


The patch titled
     Subject: revert "mm: vmscan: do not swap anon pages just because free+file is low"
has been added to the -mm tree.  Its filename is
     revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

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

slub-fix-memcg_propagate_slab_attrs.patch
mm-filemap-update-find_get_pages_tag-to-deal-with-shadow-entries.patch
revert-mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
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
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

