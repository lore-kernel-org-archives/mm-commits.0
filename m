From: akpm@linux-foundation.org
Subject: - prevent-kswapd-from-freeing-excessive-amounts-of-lowmem.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:46 -0700
Message-ID: <200710162031.l9GKVkAn014530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966048AbXJPVpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: prevent kswapd from freeing excessive amounts of lowmem
has been removed from the -mm tree.  Its filename was
     prevent-kswapd-from-freeing-excessive-amounts-of-lowmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: prevent kswapd from freeing excessive amounts of lowmem
From: Rik van Riel <riel@redhat.com>

The current VM can get itself into trouble fairly easily on systems with a
small ZONE_HIGHMEM, which is common on i686 computers with 1GB of memory.

On one side, page_alloc() will allocate down to zone->pages_low, while on
the other side, kswapd() and balance_pgdat() will try to free memory from
every zone, until every zone has more free pages than zone->pages_high.

Highmem can be filled up to zone->pages_low with page tables, ramfs,
vmalloc allocations and other unswappable things quite easily and without
many bad side effects, since we still have a huge ZONE_NORMAL to do future
allocations from.

However, as long as the number of free pages in the highmem zone is below
zone->pages_high, kswapd will continue swapping things out from
ZONE_NORMAL, too!

Sami Farin managed to get his system into a stage where kswapd had freed
about 700MB of low memory and was still "going strong".

The attached patch will make kswapd stop paging out data from zones when
there is more than enough memory free.  We do go above zone->pages_high in
order to keep pressure between zones equal in normal circumstances, but the
patch should prevent the kind of excesses that made Sami's computer totally
unusable.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~prevent-kswapd-from-freeing-excessive-amounts-of-lowmem mm/vmscan.c
--- a/mm/vmscan.c~prevent-kswapd-from-freeing-excessive-amounts-of-lowmem
+++ a/mm/vmscan.c
@@ -1371,7 +1371,13 @@ loop_again:
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
-			nr_reclaimed += shrink_zone(priority, zone, &sc);
+			/*
+			 * We put equal pressure on every zone, unless one
+			 * zone has way too many pages free already.
+			 */
+			if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
+						end_zone, 0))
+				nr_reclaimed += shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
kswapd-should-only-wait-on-io-if-there-is-io.patch
