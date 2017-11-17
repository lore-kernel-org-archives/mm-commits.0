From: akpm@linux-foundation.org
Subject: [patch 07/94] mm, compaction: extend
 pageblock_skip_persistent() to all compound pages
Date: Fri, 17 Nov 2017 15:26:34 -0800
Message-ID: <20171117232634.zDuy8h6im%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdKQX0g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: extend pageblock_skip_persistent() to all compound pages

pageblock_skip_persistent() checks for HugeTLB pages of pageblock order. 
When clearing pageblock skip bits for compaction, the bits are not cleared
for such pageblocks, because they cannot contain base pages suitable for
migration, nor free pages to use as migration targets.

This optimization can be simply extended to all compound pages of order
equal or larger than pageblock order, because migrating such pages (if
they support it) cannot help sub-pageblock fragmentation.  This includes
THP's and also gigantic HugeTLB pages, which the current implementation
doesn't persistently skip due to a strict pageblock_order equality check
and not recognizing tail pages.

While THP pages are generally less "persistent" than HugeTLB, we can still
expect that if a THP exists at the point of __reset_isolation_suitable(),
it will exist also during the subsequent compaction run.  The time
difference here could be actually smaller than between a compaction run
that sets a (non-persistent) skip bit on a THP, and the next compaction
run that observes it.

Link: http://lkml.kernel.org/r/20171102121706.21504-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/compaction.c~mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages
+++ a/mm/compaction.c
@@ -219,17 +219,21 @@ static void reset_cached_positions(struc
 }
 
 /*
- * Hugetlbfs pages should consistenly be skipped until updated by the hugetlb
- * subsystem.  It is always pointless to compact pages of pageblock_order and
- * the free scanner can reconsider when no longer huge.
+ * Compound pages of >= pageblock_order should consistenly be skipped until
+ * released. It is always pointless to compact pages of such order (if they are
+ * migratable), and the pageblocks they occupy cannot contain any free pages.
  */
-static bool pageblock_skip_persistent(struct page *page, unsigned int order)
+static bool pageblock_skip_persistent(struct page *page)
 {
-	if (!PageHuge(page))
+	if (!PageCompound(page))
 		return false;
-	if (order != pageblock_order)
-		return false;
-	return true;
+
+	page = compound_head(page);
+
+	if (compound_order(page) >= pageblock_order)
+		return true;
+
+	return false;
 }
 
 /*
@@ -256,7 +260,7 @@ static void __reset_isolation_suitable(s
 			continue;
 		if (zone != page_zone(page))
 			continue;
-		if (pageblock_skip_persistent(page, compound_order(page)))
+		if (pageblock_skip_persistent(page))
 			continue;
 
 		clear_pageblock_skip(page);
@@ -323,8 +327,7 @@ static inline bool isolation_suitable(st
 	return true;
 }
 
-static inline bool pageblock_skip_persistent(struct page *page,
-					     unsigned int order)
+static inline bool pageblock_skip_persistent(struct page *page)
 {
 	return false;
 }
_
