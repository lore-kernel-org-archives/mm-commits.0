From: akpm@linux-foundation.org
Subject: + mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch added to -mm tree
Date: Thu, 21 Mar 2013 13:32:15 -0700
Message-ID: <20130321203215.8890D5A4232@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45122 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3CUUcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 16:32:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so12066qcs.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 13:32:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, hedi@sgi.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: mm: page_alloc: avoid marking zones full prematurely after zone_reclaim()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Hedi Berriche <hedi@sgi.com>
Tested-by: Hedi Berriche <hedi@sgi.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim
+++ a/mm/page_alloc.c
@@ -1941,9 +1941,24 @@ zonelist_scan:
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
+				if ((alloc_flags & ALLOC_WMARK_MIN) ||
+				    ret == ZONE_RECLAIM_SOME)
 					goto this_zone_full;
+
+				continue;
 			}
 		}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-merging-memory-blocks-resets-mempolicy.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch
mm-memmap_init_zone-performance-improvement.patch

