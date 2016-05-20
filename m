From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:06:26 -0700
Message-ID: <573f7c52.UATLHSfyQi0aF+j/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbcETVG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: convert nr_fair_skipped to bool
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-nr_fair_skipped-to-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: convert nr_fair_skipped to bool

The number of zones skipped to a zone expiring its fair zone allocation
quota is irrelevant.  Convert to bool.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-convert-nr_fair_skipped-to-bool mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-convert-nr_fair_skipped-to-bool
+++ a/mm/page_alloc.c
@@ -2680,7 +2680,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	struct zoneref *z;
 	struct page *page = NULL;
 	struct zone *zone;
-	int nr_fair_skipped = 0;
+	bool fair_skipped;
 	bool zonelist_rescan;
 
 zonelist_scan:
@@ -2708,7 +2708,7 @@ zonelist_scan:
 			if (!zone_local(ac->preferred_zone, zone))
 				break;
 			if (test_bit(ZONE_FAIR_DEPLETED, &zone->flags)) {
-				nr_fair_skipped++;
+				fair_skipped = true;
 				continue;
 			}
 		}
@@ -2801,7 +2801,7 @@ try_this_zone:
 	 */
 	if (alloc_flags & ALLOC_FAIR) {
 		alloc_flags &= ~ALLOC_FAIR;
-		if (nr_fair_skipped) {
+		if (fair_skipped) {
 			zonelist_rescan = true;
 			reset_alloc_batches(ac->preferred_zone);
 		}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


