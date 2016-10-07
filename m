From: akpm@linux-foundation.org
Subject: [patch 023/127] mm, compaction: use proper alloc_flags in
 __compaction_suitable()
Date: Fri, 07 Oct 2016 16:57:57 -0700
Message-ID: <57f83685.lvfHTdEJuAkDJvBH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@kernel.org, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: use proper alloc_flags in __compaction_suitable()

The __compaction_suitable() function checks the low watermark plus a
compact_gap() gap to decide if there's enough free memory to perform
compaction.  This check uses direct compactor's alloc_flags, but that's
wrong, since these flags are not applicable for freepage isolation.

For example, alloc_flags may indicate access to memory reserves, making
compaction proceed, and then fail watermark check during the isolation.

A similar problem exists for ALLOC_CMA, which may be part of alloc_flags,
but not during freepage isolation.  In this case however it makes sense to
use ALLOC_CMA both in __compaction_suitable() and __isolate_free_page(),
since there's actually nothing preventing the freepage scanner to isolate
from CMA pageblocks, with the assumption that a page that could be
migrated once by compaction can be migrated also later by CMA allocation. 
Thus we should count pages in CMA pageblocks when considering compaction
suitability and when isolating freepages.

To sum up, this patch should remove some false positives from
__compaction_suitable(), and allow compaction to proceed when free pages
required for compaction reside in the CMA pageblocks.

Link: http://lkml.kernel.org/r/20160810091226.6709-10-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   12 ++++++++++--
 mm/page_alloc.c |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-use-proper-alloc_flags-in-__compaction_suitable mm/compaction.c
--- a/mm/compaction.c~mm-compaction-use-proper-alloc_flags-in-__compaction_suitable
+++ a/mm/compaction.c
@@ -1392,11 +1392,19 @@ static enum compact_result __compaction_
 
 	/*
 	 * Watermarks for order-0 must be met for compaction to be able to
-	 * isolate free pages for migration targets.
+	 * isolate free pages for migration targets. This means that the
+	 * watermark and alloc_flags have to match, or be more pessimistic than
+	 * the check in __isolate_free_page(). We don't use the direct
+	 * compactor's alloc_flags, as they are not relevant for freepage
+	 * isolation. We however do use the direct compactor's classzone_idx to
+	 * skip over zones where lowmem reserves would prevent allocation even
+	 * if compaction succeeds.
+	 * ALLOC_CMA is used, as pages in CMA pageblocks are considered
+	 * suitable migration targets
 	 */
 	watermark = low_wmark_pages(zone) + compact_gap(order);
 	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
-				 alloc_flags, wmark_target))
+						ALLOC_CMA, wmark_target))
 		return COMPACT_SKIPPED;
 
 	/*
diff -puN mm/page_alloc.c~mm-compaction-use-proper-alloc_flags-in-__compaction_suitable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-use-proper-alloc_flags-in-__compaction_suitable
+++ a/mm/page_alloc.c
@@ -2491,7 +2491,7 @@ int __isolate_free_page(struct page *pag
 	if (!is_migrate_isolate(mt)) {
 		/* Obey watermarks as if the page was being allocated */
 		watermark = low_wmark_pages(zone) + (1 << order);
-		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
 			return 0;
 
 		__mod_zone_freepage_state(zone, -(1UL << order), mt);
_
