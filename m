From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:19 -0700
Message-ID: <20130430184819.968965A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:41531 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3SsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:21 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86556qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hedi@sgi.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: avoid marking zones full prematurely after zone_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: avoid marking zones full prematurely after zone_reclaim()

The following problem was reported against a distribution kernel when
zone_reclaim was enabled but the same problem applies to the mainline
kernel.  The reproduction case was as follows

1. Run numactl -m +0 dd if=largefile of=/dev/null
   This allocates a large number of clean pages in node 0

2. numactl -N +0 memhog 0.5*Mg
   This start a memory-using application in node 0.

The expected behaviour is that the clean pages get reclaimed and the
application uses node 0 for its memory.  The observed behaviour was that
the memory for the memhog application was allocated off-node since commits
cd38b11 ("mm: page allocator: initialise ZLC for first zone eligible for
zone_reclaim") and commit 76d3fbf ("mm: page allocator: reconsider zones
for allocation after direct reclaim").

The assumption of those patches was that it was always preferable to
allocate quickly than stall for long periods of time and they were meant
to take care that the zone was only marked full when necessary but an
important case was missed.

In the allocator fast path, only the low watermarks are checked.  If the
zones free pages are between the low and min watermark then allocations
from the allocators slow path will succeed.  However, zone_reclaim will
only reclaim SWAP_CLUSTER_MAX or 1<<order pages.  There is no guarantee
that this will meet the low watermark causing the zone to be marked full
prematurely.

This patch will only mark the zone full after zone_reclaim if it the min
watermarks are checked or if page reclaim failed to make sufficient
progress.

[mhocko@suse.cz: fix alloc_flags test]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Hedi Berriche <hedi@sgi.com>
Tested-by: Hedi Berriche <hedi@sgi.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim
+++ a/mm/page_alloc.c
@@ -1942,9 +1942,24 @@ zonelist_scan:
 				continue;
 			default:
 				/* did we reclaim enough */
-				if (!zone_watermark_ok(zone, order, mark,
+				if (zone_watermark_ok(zone, order, mark,
 						classzone_idx, alloc_flags))
+					goto try_this_zone;
+
+				/*
+				 * Failed to reclaim enough to meet watermark.
+				 * Only mark the zone full if checking the min
+				 * watermark or if we failed to reclaim just
+				 * 1<<order pages or else the page allocator
+				 * fastpath will prematurely mark zones full
+				 * when the watermark is between the low and
+				 * min watermarks.
+				 */
+				if (((alloc_flags & ALLOC_WMARK_MASK) == ALLOC_WMARK_MIN) ||
+				    ret == ZONE_RECLAIM_SOME)
 					goto this_zone_full;
+
+				continue;
 			}
 		}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-memmap_init_zone-performance-improvement.patch

