From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:14:37 -0800
Message-ID: <5488d3dd.GlK9HTdO3LSTFxFg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395AbaLJXOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch

This patch was dropped because it was folded into mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix

This patch-fix changes zone watermark checking in compaction_suitable() as
we discussed with Joonsoo Kim.  First, it moves up the watermark check for
answering the question "does the zone need compaction at all?".  Before
this change, the check is preceded by a check that answers the question
"does the zone have enough free pages to succeed compaction".  So it might
happen that there is already a high-order page available, but not enough
pages for performing the compaction (which assumes extra pages for the
migrations).  Before the patch, compaction_suitable() would return
COMPACT_SKIPPED which means "compaction cannot succeed, reclaim more",
after this change it returns COMPACT_PARTIAL which means "compaction not
needed, try allocating".

Second, the check for answering "can the compaction succeed?" now also
includes classzone_idx and alloc_flags parameters.  This prevents starting
compaction that would not lead to successful allocation due to not having
enough free pages.  The addition of extra pages for migration is left in
the check.  Although these are temporary allocations and thus should not
be affected by alloc_flags and classzone_idx, it only matters when we are
close to the watermark, where it does not hurt to be a bit pessimistic.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix
+++ a/mm/compaction.c
@@ -1127,21 +1127,30 @@ unsigned long compaction_suitable(struct
 	if (order == -1)
 		return COMPACT_CONTINUE;
 
+	watermark = low_wmark_pages(zone);
+	/*
+	 * If watermarks for high-order allocation are already met, there
+	 * should be no need for compaction at all.
+	 */
+	if (zone_watermark_ok(zone, order, watermark, classzone_idx,
+								alloc_flags))
+		return COMPACT_PARTIAL;
+
 	/*
 	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
 	 * This is because during migration, copies of pages need to be
 	 * allocated and for a short time, the footprint is higher
 	 */
-	watermark = low_wmark_pages(zone) + (2UL << order);
-	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+	watermark += (2UL << order);
+	if (!zone_watermark_ok(zone, 0, watermark, classzone_idx, alloc_flags))
 		return COMPACT_SKIPPED;
 
 	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
 	 *
-	 * index of -1000 implies allocations might succeed depending on
-	 * watermarks
+	 * index of -1000 would imply allocations might succeed depending on
+	 * watermarks, but we already failed the high-order watermark check
 	 * index towards 0 implies failure is due to lack of memory
 	 * index towards 1000 implies failure is due to fragmentation
 	 *
@@ -1151,10 +1160,6 @@ unsigned long compaction_suitable(struct
 	if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
 		return COMPACT_SKIPPED;
 
-	if (fragindex == -1000 && zone_watermark_ok(zone, order, watermark,
-	    classzone_idx, alloc_flags))
-		return COMPACT_PARTIAL;
