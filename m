Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840A8C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 19:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244810AbiDYTFW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 15:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243635AbiDYTFO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 15:05:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E4F12C411
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 12:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E22FB81A0D
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 19:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E72BC385AC;
        Mon, 25 Apr 2022 19:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650913326;
        bh=3bLEZUmLcidqhAtwZKz0JLaX+AvNU2io9SqabMAeRfI=;
        h=Date:To:From:Subject:From;
        b=Vk8fH6PjP8UzMLoxn/pKHgR6eDprYApZXZa8BEPBA4U8sQRSvUQolwy0wobvGjOYa
         R+fp0+e5U+kiKQzPGDASFESAHF9u4L2QSa6d9Hy/88+EO9HfOoilLPNg1AMFQCdA7z
         M6oCO5ML4NBBMVY+7hzSApyRET4afpyYR0/kXZYU=
Date:   Mon, 25 Apr 2022 12:02:05 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-check-specified-range-for-unmovable-pages.patch added to -mm tree
Message-Id: <20220425190206.1E72BC385AC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_isolation: check specified range for unmovable pages
has been added to the -mm tree.  Its filename is
     mm-page_isolation-check-specified-range-for-unmovable-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-check-specified-range-for-unmovable-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-check-specified-range-for-unmovable-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_isolation: check specified range for unmovable pages

Enable set_migratetype_isolate() to check specified range for unmovable
pages during isolation to prepare arbitrary range page isolation.  The
functionality will take effect in upcoming commits by adjusting the
callers of start_isolate_page_range(), which uses
set_migratetype_isolate().

For example, alloc_contig_range(), which calls start_isolate_page_range(),
accepts unaligned ranges, but because page isolation is currently done at
MAX_ORDER_NR_PAEGS granularity, pages that are out of the specified range
but withint MAX_ORDER_NR_PAEGS alignment might be attempted for isolation
and the failure of isolating these unrelated pages fails the whole
operation undesirably.

Link: https://lkml.kernel.org/r/20220425143118.2850746-3-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   47 ++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 13 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-check-specified-range-for-unmovable-pages
+++ a/mm/page_isolation.c
@@ -16,7 +16,9 @@
 #include <trace/events/page_isolation.h>
 
 /*
- * This function checks whether pageblock includes unmovable pages or not.
+ * This function checks whether the range [start_pfn, end_pfn) includes
+ * unmovable pages or not. The range must fall into a single pageblock and
+ * consequently belong to a single zone.
  *
  * PageLRU check without isolation or lru_lock could race so that
  * MIGRATE_MOVABLE block might include unmovable pages. And __PageMovable
@@ -28,12 +30,15 @@
  * cannot get removed (e.g., via memory unplug) concurrently.
  *
  */
-static struct page *has_unmovable_pages(struct zone *zone, struct page *page,
-				 int migratetype, int flags)
+static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long end_pfn,
+				int migratetype, int flags)
 {
-	unsigned long iter = 0;
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long offset = pfn % pageblock_nr_pages;
+	struct page *page = pfn_to_page(start_pfn);
+	struct zone *zone = page_zone(page);
+	unsigned long pfn;
+
+	VM_BUG_ON(ALIGN_DOWN(start_pfn, pageblock_nr_pages) !=
+		  ALIGN_DOWN(end_pfn - 1, pageblock_nr_pages));
 
 	if (is_migrate_cma_page(page)) {
 		/*
@@ -47,8 +52,8 @@ static struct page *has_unmovable_pages(
 		return page;
 	}
 
-	for (; iter < pageblock_nr_pages - offset; iter++) {
-		page = pfn_to_page(pfn + iter);
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		page = pfn_to_page(pfn);
 
 		/*
 		 * Both, bootmem allocations and memory holes are marked
@@ -85,7 +90,7 @@ static struct page *has_unmovable_pages(
 			}
 
 			skip_pages = compound_nr(head) - (page - head);
-			iter += skip_pages - 1;
+			pfn += skip_pages - 1;
 			continue;
 		}
 
@@ -97,7 +102,7 @@ static struct page *has_unmovable_pages(
 		 */
 		if (!page_ref_count(page)) {
 			if (PageBuddy(page))
-				iter += (1 << buddy_order(page)) - 1;
+				pfn += (1 << buddy_order(page)) - 1;
 			continue;
 		}
 
@@ -134,11 +139,18 @@ static struct page *has_unmovable_pages(
 	return NULL;
 }
 
-static int set_migratetype_isolate(struct page *page, int migratetype, int isol_flags)
+/*
+ * This function set pageblock migratetype to isolate if no unmovable page is
+ * present in [start_pfn, end_pfn). The pageblock must intersect with
+ * [start_pfn, end_pfn).
+ */
+static int set_migratetype_isolate(struct page *page, int migratetype, int isol_flags,
+			unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
 	unsigned long flags;
+	unsigned long check_unmovable_start, check_unmovable_end;
 
 	spin_lock_irqsave(&zone->lock, flags);
 
@@ -155,8 +167,16 @@ static int set_migratetype_isolate(struc
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
+	 *
+	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
+	 * to avoid redundant checks.
 	 */
-	unmovable = has_unmovable_pages(zone, page, migratetype, isol_flags);
+	check_unmovable_start = max(page_to_pfn(page), start_pfn);
+	check_unmovable_end = min(ALIGN(page_to_pfn(page) + 1, pageblock_nr_pages),
+				  end_pfn);
+
+	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
+			migratetype, isol_flags);
 	if (!unmovable) {
 		unsigned long nr_pages;
 		int mt = get_pageblock_migratetype(page);
@@ -313,7 +333,8 @@ int start_isolate_page_range(unsigned lo
 	     pfn < end_pfn;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (page && set_migratetype_isolate(page, migratetype, flags)) {
+		if (page && set_migratetype_isolate(page, migratetype, flags,
+					start_pfn, end_pfn)) {
 			undo_isolate_page_range(start_pfn, pfn, migratetype);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch
mm-page_isolation-move-has_unmovable_pages-to-mm-page_isolationc.patch
mm-page_isolation-check-specified-range-for-unmovable-pages.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

