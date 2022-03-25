Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BBBC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357346AbiCYBdv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357454AbiCYBdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C395FBF50C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60C4461929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9B2C340ED;
        Fri, 25 Mar 2022 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171875;
        bh=32DOkKPqPd6//x5TT6hEK70Cdk7XS4C5PePl+BAHu2M=;
        h=Date:To:From:Subject:From;
        b=a1reMxAuBWWDCNJ2gxJf04wGT3RM2+2oy10HIV03wcQyGYpxy1Gpmd0ATetjgBxT7
         rZShWYsExxEgSfmPPzHkitg0fBnSPQS8gO6MCFgL7Xv37z6t+ThW7nE5UzhwaYRlA0
         mE2sgZmaboiwRYYtA/xee3gXchOYAoVCk7HNOxOE=
Date:   Thu, 24 Mar 2022 18:31:15 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        rppt@kernel.org, osalvador@suse.de, mgorman@techsingularity.net,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-avoid-merging-non-fallbackable-pageblocks-with-others.patch removed from -mm tree
Message-Id: <20220325013115.BC9B2C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: avoid merging non-fallbackable pageblocks with others
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-merging-non-fallbackable-pageblocks-with-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_alloc: avoid merging non-fallbackable pageblocks with others

This is done in addition to MIGRATE_ISOLATE pageblock merge avoidance.  It
prepares for the upcoming removal of the MAX_ORDER-1 alignment requirement
for CMA and alloc_contig_range().

MIGRATE_HIGHATOMIC should not merge with other migratetypes like
MIGRATE_ISOLATE and MIGRARTE_CMA[1], so this commit prevents that too.

Remove MIGRATE_CMA and MIGRATE_ISOLATE from fallbacks list, since they
are never used.

[1] https://lore.kernel.org/linux-mm/20211130100853.GP3366@techsingularity.net/

Link: https://lkml.kernel.org/r/20220124175957.1261961-1-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++++++
 mm/page_alloc.c        |   46 ++++++++++++++++++---------------------
 2 files changed, 33 insertions(+), 24 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-avoid-merging-non-fallbackable-pageblocks-with-others
+++ a/include/linux/mmzone.h
@@ -83,6 +83,17 @@ static inline bool is_migrate_movable(in
 	return is_migrate_cma(mt) || mt == MIGRATE_MOVABLE;
 }
 
+/*
+ * Check whether a migratetype can be merged with another migratetype.
+ *
+ * It is only mergeable when it can fall back to other migratetypes for
+ * allocation. See fallbacks[MIGRATE_TYPES][3] in page_alloc.c.
+ */
+static inline bool migratetype_is_mergeable(int mt)
+{
+	return mt < MIGRATE_PCPTYPES;
+}
+
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \
 		for (type = 0; type < MIGRATE_TYPES; type++)
--- a/mm/page_alloc.c~mm-page_alloc-avoid-merging-non-fallbackable-pageblocks-with-others
+++ a/mm/page_alloc.c
@@ -1117,25 +1117,24 @@ continue_merging:
 	}
 	if (order < MAX_ORDER - 1) {
 		/* If we are here, it means order is >= pageblock_order.
-		 * We want to prevent merge between freepages on isolate
-		 * pageblock and normal pageblock. Without this, pageblock
-		 * isolation could cause incorrect freepage or CMA accounting.
+		 * We want to prevent merge between freepages on pageblock
+		 * without fallbacks and normal pageblock. Without this,
+		 * pageblock isolation could cause incorrect freepage or CMA
+		 * accounting or HIGHATOMIC accounting.
 		 *
 		 * We don't want to hit this code for the more frequent
 		 * low-order merging.
 		 */
-		if (unlikely(has_isolate_pageblock(zone))) {
-			int buddy_mt;
+		int buddy_mt;
 
-			buddy_pfn = __find_buddy_pfn(pfn, order);
-			buddy = page + (buddy_pfn - pfn);
-			buddy_mt = get_pageblock_migratetype(buddy);
-
-			if (migratetype != buddy_mt
-					&& (is_migrate_isolate(migratetype) ||
-						is_migrate_isolate(buddy_mt)))
-				goto done_merging;
-		}
+		buddy_pfn = __find_buddy_pfn(pfn, order);
+		buddy = page + (buddy_pfn - pfn);
+		buddy_mt = get_pageblock_migratetype(buddy);
+
+		if (migratetype != buddy_mt
+				&& (!migratetype_is_mergeable(migratetype) ||
+					!migratetype_is_mergeable(buddy_mt)))
+			goto done_merging;
 		max_order = order + 1;
 		goto continue_merging;
 	}
@@ -2479,17 +2478,13 @@ struct page *__rmqueue_smallest(struct z
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
+ *
+ * The other migratetypes do not have fallbacks.
  */
 static int fallbacks[MIGRATE_TYPES][3] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_TYPES },
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_TYPES },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_TYPES },
-#ifdef CONFIG_CMA
-	[MIGRATE_CMA]         = { MIGRATE_TYPES }, /* Never used */
-#endif
-#ifdef CONFIG_MEMORY_ISOLATION
-	[MIGRATE_ISOLATE]     = { MIGRATE_TYPES }, /* Never used */
-#endif
 };
 
 #ifdef CONFIG_CMA
@@ -2795,8 +2790,8 @@ static void reserve_highatomic_pageblock
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
-	if (!is_migrate_highatomic(mt) && !is_migrate_isolate(mt)
-	    && !is_migrate_cma(mt)) {
+	/* Only reserve normal pageblocks (i.e., they can merge with others) */
+	if (migratetype_is_mergeable(mt)) {
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 		set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
 		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC, NULL);
@@ -3545,8 +3540,11 @@ int __isolate_free_page(struct page *pag
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
 			int mt = get_pageblock_migratetype(page);
-			if (!is_migrate_isolate(mt) && !is_migrate_cma(mt)
-			    && !is_migrate_highatomic(mt))
+			/*
+			 * Only change normal pageblocks (i.e., they can merge
+			 * with others)
+			 */
+			if (migratetype_is_mergeable(mt))
 				set_pageblock_migratetype(page,
 							  MIGRATE_MOVABLE);
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are


