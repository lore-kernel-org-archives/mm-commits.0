From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
 added to -mm tree
Date: Fri, 26 Jul 2013 15:59:55 -0700
Message-ID: <51f2ff6b.S8+CHB49jiWYlz7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab3GZW74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: + mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch added to -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 15:59:55 -0700


The patch titled
     Subject: mm: page_alloc: rearrange watermark checking in get_page_from_freelist
has been added to the -mm tree.  Its filename is
     mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch

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
Subject: mm: page_alloc: rearrange watermark checking in get_page_from_freelist

Allocations that do not have to respect the watermarks are rare
high-priority events.  Reorder the code such that per-zone dirty limits
and future checks important only to regular page allocations are ignored
in these extraordinary situations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -1889,12 +1889,17 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
+		unsigned long mark;
+
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 		if ((alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
+		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
+		if (alloc_flags & ALLOC_NO_WATERMARKS)
+			goto try_this_zone;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
@@ -1925,16 +1930,11 @@ zonelist_scan:
 		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
 			goto this_zone_full;
 
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
-			unsigned long mark;
+		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
+		if (!zone_watermark_ok(zone, order, mark,
+				       classzone_idx, alloc_flags)) {
 			int ret;
 
-			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-			if (zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags))
-				goto try_this_zone;
