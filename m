From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch removed from -mm tree
Date: Fri, 06 Nov 2015 16:09:20 -0800
Message-ID: <563d4130.UWlmyBqaycVsMg3z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbbKGAJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch

This patch was dropped because it was folded into mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand -fix

nr_reserved_highatomic is checked outside the zone lock so there is a race
whereby the reserve is larger than the limit allows.  This patch rechecks
the count under the zone lock.

During unreserving, there is a possibility we could underflow if there
ever was a race between per-cpu drains, reserve and unreserving.  This
patch adds a comment about the potential race and protects against it.

These are two fixes to the mmotm patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
.  They are not separate patches and they should all be folded together.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix
+++ a/mm/page_alloc.c
@@ -1633,9 +1633,13 @@ static void reserve_highatomic_pageblock
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	/* Yoink! */
 	spin_lock_irqsave(&zone->lock, flags);
 
+	/* Recheck the nr_reserved_highatomic limit under the lock */
+	if (zone->nr_reserved_highatomic >= max_managed)
+		goto out_unlock;
+
+	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	if (mt != MIGRATE_HIGHATOMIC &&
 			!is_migrate_isolate(mt) && !is_migrate_cma(mt)) {
@@ -1643,6 +1647,8 @@ static void reserve_highatomic_pageblock
 		set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
 		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC);
 	}
+
+out_unlock:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
@@ -1677,7 +1683,14 @@ static void unreserve_highatomic_pageblo
 			page = list_entry(area->free_list[MIGRATE_HIGHATOMIC].next,
 						struct page, lru);
 
-			zone->nr_reserved_highatomic -= pageblock_nr_pages;
+			/*
+			 * It should never happen but changes to locking could
+			 * inadvertently allow a per-cpu drain to add pages
+			 * to MIGRATE_HIGHATOMIC while unreserving so be safe
+			 * and watch for underflows.
+			 */
+			zone->nr_reserved_highatomic -= min(pageblock_nr_pages,
+				zone->nr_reserved_highatomic);
 
 			/*
 			 * Convert to ac->migratetype and avoid the normal
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch
mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix.patch

