Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F4DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiEJEPb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiEJEOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AB9205F0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6039761738
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F61C385C5;
        Tue, 10 May 2022 04:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155853;
        bh=TX4j/x73IdY0Z07JIZvHhgX2ldK4FCMcYKtpXOFZYfw=;
        h=Date:To:From:Subject:From;
        b=TKPPslWObjbBTKrH7G52BHvewsdeCM4hq6FF8RmzgR5Rx67ZfqpJEIUf5UqeB0dq2
         z9HgJBrhwGtp+pzwEb9aVzx6BCg5l+JyFkOU3h6m2SDx7yaIvmlNiRF41bmIDLIEWZ
         v/KYzbrY5gS0LLQxL4s8f27TVe9IqcqPig8a2SxE=
Date:   Mon, 09 May 2022 21:10:53 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch removed from -mm tree
Message-Id: <20220510041053.B0F61C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: simplify pageblock migratetype check in __free_one_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_alloc: simplify pageblock migratetype check in __free_one_page()

Move pageblock migratetype check code in the while loop to simplify the
logic. It also saves redundant buddy page checking code.

Link: https://lkml.kernel.org/r/20220401230804.1658207-1-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/27ff69f9-60c5-9e59-feb2-295250077551@suse.cz/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page
+++ a/mm/page_alloc.c
@@ -1053,7 +1053,6 @@ static inline void __free_one_page(struc
 		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
-	unsigned int max_order = pageblock_order;
 	unsigned long buddy_pfn;
 	unsigned long combined_pfn;
 	struct page *buddy;
@@ -1069,8 +1068,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-continue_merging:
-	while (order < max_order) {
+	while (order < MAX_ORDER - 1) {
 		if (compaction_capture(capc, page, order, migratetype)) {
 			__mod_zone_freepage_state(zone, -(1 << order),
 								migratetype);
@@ -1081,6 +1079,22 @@ continue_merging:
 
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
+
+		if (unlikely(order >= pageblock_order)) {
+			/*
+			 * We want to prevent merge between freepages on pageblock
+			 * without fallbacks and normal pageblock. Without this,
+			 * pageblock isolation could cause incorrect freepage or CMA
+			 * accounting or HIGHATOMIC accounting.
+			 */
+			int buddy_mt = get_pageblock_migratetype(buddy);
+
+			if (migratetype != buddy_mt
+					&& (!migratetype_is_mergeable(migratetype) ||
+						!migratetype_is_mergeable(buddy_mt)))
+				goto done_merging;
+		}
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -1094,32 +1108,6 @@ continue_merging:
 		pfn = combined_pfn;
 		order++;
 	}
-	if (order < MAX_ORDER - 1) {
-		/* If we are here, it means order is >= pageblock_order.
-		 * We want to prevent merge between freepages on pageblock
-		 * without fallbacks and normal pageblock. Without this,
-		 * pageblock isolation could cause incorrect freepage or CMA
-		 * accounting or HIGHATOMIC accounting.
-		 *
-		 * We don't want to hit this code for the more frequent
-		 * low-order merging.
-		 */
-		int buddy_mt;
-
-		buddy_pfn = __find_buddy_pfn(pfn, order);
-		buddy = page + (buddy_pfn - pfn);
-
-		if (!page_is_buddy(page, buddy, order))
-			goto done_merging;
-		buddy_mt = get_pageblock_migratetype(buddy);
-
-		if (migratetype != buddy_mt
-				&& (!migratetype_is_mergeable(migratetype) ||
-					!migratetype_is_mergeable(buddy_mt)))
-			goto done_merging;
-		max_order = order + 1;
-		goto continue_merging;
-	}
 
 done_merging:
 	set_buddy_order(page, order);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-move-has_unmovable_pages-to-mm-page_isolationc.patch
mm-page_isolation-check-specified-range-for-unmovable-pages.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity-fix.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

