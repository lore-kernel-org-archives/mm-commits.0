Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04E0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383721AbiEMTWR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383761AbiEMTVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7A837A09
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6998162245
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC38EC34113;
        Fri, 13 May 2022 19:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469685;
        bh=YqdUYOl5Hn/oMz9nEMA1yOqcWbw9zCjSCcTM1uydFMs=;
        h=Date:To:From:Subject:From;
        b=TyUVfPUSWB2ESFkedvjzDz1cK0fEcnXql9c+kqAw32AuIa0zmnbwSTsTrh+WqYriW
         BAgJsgQ+7uSxH6eSnE8tKXLs61Ffmnvl9GdUuUs8OcnF45VrWFVdc+Rh4abkuGvfVd
         ppfLJwkVP/4pHSXIbvhVWbHw5z5YvqgYucVL2d5g=
Date:   Fri, 13 May 2022 12:21:25 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-enable-arbitrary-range-page-isolation.patch removed from -mm tree
Message-Id: <20220513192125.BC38EC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_isolation: enable arbitrary range page isolation.
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-enable-arbitrary-range-page-isolation.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_isolation: enable arbitrary range page isolation.

Now start_isolate_page_range() is ready to handle arbitrary range
isolation, so move the alignment check/adjustment into the function body. 
Do the same for its counterpart undo_isolate_page_range(). 
alloc_contig_range(), its caller, can pass an arbitrary range instead of a
MAX_ORDER_NR_PAGES aligned one.

Link: https://lkml.kernel.org/r/20220425143118.2850746-5-zi.yan@sent.com
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

 mm/page_alloc.c     |   16 ++--------------
 mm/page_isolation.c |   33 ++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 31 deletions(-)

--- a/mm/page_alloc.c~mm-page_isolation-enable-arbitrary-range-page-isolation
+++ a/mm/page_alloc.c
@@ -8956,16 +8956,6 @@ void *__init alloc_large_system_hash(con
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
-static unsigned long pfn_max_align_down(unsigned long pfn)
-{
-	return ALIGN_DOWN(pfn, MAX_ORDER_NR_PAGES);
-}
-
-static unsigned long pfn_max_align_up(unsigned long pfn)
-{
-	return ALIGN(pfn, MAX_ORDER_NR_PAGES);
-}
-
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
 	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
@@ -9107,8 +9097,7 @@ int alloc_contig_range(unsigned long sta
 	 * put back to page allocator so that buddy can use them.
 	 */
 
-	ret = start_isolate_page_range(pfn_max_align_down(start),
-				pfn_max_align_up(end), migratetype, 0, gfp_mask);
+	ret = start_isolate_page_range(start, end, migratetype, 0, gfp_mask);
 	if (ret)
 		goto done;
 
@@ -9189,8 +9178,7 @@ int alloc_contig_range(unsigned long sta
 		free_contig_range(end, outer_end - end);
 
 done:
-	undo_isolate_page_range(pfn_max_align_down(start),
-				pfn_max_align_up(end), migratetype);
+	undo_isolate_page_range(start, end, migratetype);
 	return ret;
 }
 EXPORT_SYMBOL(alloc_contig_range);
--- a/mm/page_isolation.c~mm-page_isolation-enable-arbitrary-range-page-isolation
+++ a/mm/page_isolation.c
@@ -444,7 +444,6 @@ failed:
  * be MIGRATE_ISOLATE.
  * @start_pfn:		The lower PFN of the range to be isolated.
  * @end_pfn:		The upper PFN of the range to be isolated.
- *			start_pfn/end_pfn must be aligned to pageblock_order.
  * @migratetype:	Migrate type to set in error recovery.
  * @flags:		The following flags are allowed (they can be combined in
  *			a bit mask)
@@ -491,33 +490,33 @@ int start_isolate_page_range(unsigned lo
 {
 	unsigned long pfn;
 	struct page *page;
+	/* isolation is done at page block granularity */
+	unsigned long isolate_start = ALIGN_DOWN(start_pfn, pageblock_nr_pages);
+	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
 	int ret;
 
-	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
-	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
-
-	/* isolate [start_pfn, start_pfn + pageblock_nr_pages) pageblock */
-	ret = isolate_single_pageblock(start_pfn, gfp_flags, false);
+	/* isolate [isolate_start, isolate_start + pageblock_nr_pages) pageblock */
+	ret = isolate_single_pageblock(isolate_start, gfp_flags, false);
 	if (ret)
 		return ret;
 
-	/* isolate [end_pfn - pageblock_nr_pages, end_pfn) pageblock */
-	ret = isolate_single_pageblock(end_pfn, gfp_flags, true);
+	/* isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock */
+	ret = isolate_single_pageblock(isolate_end, gfp_flags, true);
 	if (ret) {
-		unset_migratetype_isolate(pfn_to_page(start_pfn), migratetype);
+		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
 		return ret;
 	}
 
 	/* skip isolated pageblocks at the beginning and end */
-	for (pfn = start_pfn + pageblock_nr_pages;
-	     pfn < end_pfn - pageblock_nr_pages;
+	for (pfn = isolate_start + pageblock_nr_pages;
+	     pfn < isolate_end - pageblock_nr_pages;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (page && set_migratetype_isolate(page, migratetype, flags,
 					start_pfn, end_pfn)) {
-			undo_isolate_page_range(start_pfn, pfn, migratetype);
+			undo_isolate_page_range(isolate_start, pfn, migratetype);
 			unset_migratetype_isolate(
-				pfn_to_page(end_pfn - pageblock_nr_pages),
+				pfn_to_page(isolate_end - pageblock_nr_pages),
 				migratetype);
 			return -EBUSY;
 		}
@@ -533,12 +532,12 @@ void undo_isolate_page_range(unsigned lo
 {
 	unsigned long pfn;
 	struct page *page;
+	unsigned long isolate_start = ALIGN_DOWN(start_pfn, pageblock_nr_pages);
+	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
 
-	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
-	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
 
-	for (pfn = start_pfn;
-	     pfn < end_pfn;
+	for (pfn = isolate_start;
+	     pfn < isolate_end;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (!page || !is_migrate_isolate_page(page))
_

Patches currently in -mm which might be from ziy@nvidia.com are


