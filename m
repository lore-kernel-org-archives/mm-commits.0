From: akpm@linux-foundation.org
Subject: +
 mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages.patch
 added to -mm tree
Date: Thu, 02 Nov 2017 13:40:17 -0700
Message-ID: <59fb82b1.rXa5trKEFBbxEosi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964781AbdKBUke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 16:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: extend pageblock_skip_persistent() to all compound pages
has been added to the -mm tree.  Its filename is
     mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: David Rientjes <rientjes@google.com>
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-simplify-list-handling-in-rmqueue_bulk.patch
mm-page_alloc-fix-potential-false-positive-in-__zone_watermark_ok.patch
mm-compaction-extend-pageblock_skip_persistent-to-all-compound-pages.patch
mm-compaction-split-off-flag-for-not-updating-skip-hints.patch
mm-compaction-remove-unneeded-pageblock_skip_persistent-checks.patch

