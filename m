From: akpm@linux-foundation.org
Subject: [patch 021/127] mm, compaction: use correct watermark when
 checking compaction success
Date: Fri, 07 Oct 2016 16:57:50 -0700
Message-ID: <57f8367e.rpVjPia+k/c07YsM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: use correct watermark when checking compaction success

The __compact_finished() function uses low watermark in a check that has
to pass if the direct compaction is to finish and allocation should
succeed.  This is too pessimistic, as the allocation will typically use
min watermark.  It may happen that during compaction, we drop below the
low watermark (due to parallel activity), but still form the target
high-order page.  By checking against low watermark, we might needlessly
continue compaction.

Similarly, __compaction_suitable() uses low watermark in a check whether
allocation can succeed without compaction.  Again, this is unnecessarily
pessimistic.

After this patch, these check will use direct compactor's alloc_flags to
determine the watermark, which is effectively the min watermark.

Link: http://lkml.kernel.org/r/20160810091226.6709-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-use-correct-watermark-when-checking-compaction-success mm/compaction.c
--- a/mm/compaction.c~mm-compaction-use-correct-watermark-when-checking-compaction-success
+++ a/mm/compaction.c
@@ -1316,7 +1316,7 @@ static enum compact_result __compact_fin
 		return COMPACT_CONTINUE;
 
 	/* Compaction run is not finished if the watermark is not met */
-	watermark = low_wmark_pages(zone);
+	watermark = zone->watermark[cc->alloc_flags & ALLOC_WMARK_MASK];
 
 	if (!zone_watermark_ok(zone, cc->order, watermark, cc->classzone_idx,
 							cc->alloc_flags))
@@ -1381,7 +1381,7 @@ static enum compact_result __compaction_
 	if (is_via_compact_memory(order))
 		return COMPACT_CONTINUE;
 
-	watermark = low_wmark_pages(zone);
+	watermark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 	/*
 	 * If watermarks for high-order allocation are already met, there
 	 * should be no need for compaction at all.
@@ -1395,7 +1395,7 @@ static enum compact_result __compaction_
 	 * This is because during migration, copies of pages need to be
 	 * allocated and for a short time, the footprint is higher
 	 */
-	watermark += (2UL << order);
+	watermark = low_wmark_pages(zone) + (2UL << order);
 	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
 				 alloc_flags, wmark_target))
 		return COMPACT_SKIPPED;
_
