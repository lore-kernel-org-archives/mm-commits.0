From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch added to -mm tree
Date: Wed, 30 Sep 2015 14:04:00 -0700
Message-ID: <560c4e40.6MQRt360PXxHwzq4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbbI3VEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix.patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

