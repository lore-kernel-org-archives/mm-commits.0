Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D25C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 22:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiDDW2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 18:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346325AbiDDW1J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 18:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562D326CC
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 14:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6712614B3
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 21:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0ADC2BBE4;
        Mon,  4 Apr 2022 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649109046;
        bh=O9Yz85uC5e8r0zVPip4gvQ8nAh4c3Lc/TlzctT4QCtc=;
        h=Date:To:From:Subject:From;
        b=YfQdbR/EPfpA3zRrq/729PgNTzZawB6PhSrVWJPIwWhoj0tHEK+1kOizRtOcNaqv2
         7F20iRXtO7BejvPyK0/mAnWmAV6HsDvkwtWk34nbmzmi+mQ36HL3aPQP7IUTCf+Zgd
         pxeBnO43rI4A5yhILD8A1OSQlbkOOY2u0PDv2m/0=
Date:   Mon, 04 Apr 2022 14:50:45 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch added to -mm tree
Message-Id: <20220404215046.0B0ADC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: simplify pageblock migratetype check in __free_one_page()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch

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
Subject: mm: page_alloc: simplify pageblock migratetype check in __free_one_page()

Move pageblock migratetype check code in the while loop to simplify the
logic. It also saves redundant buddy page checking code.

Link: https://lkml.kernel.org/r/20220401230804.1658207-1-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/27ff69f9-60c5-9e59-feb2-295250077551@suse.cz/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
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
@@ -1054,7 +1054,6 @@ static inline void __free_one_page(struc
 		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
-	unsigned int max_order = pageblock_order;
 	unsigned long buddy_pfn;
 	unsigned long combined_pfn;
 	struct page *buddy;
@@ -1070,8 +1069,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-continue_merging:
-	while (order < max_order) {
+	while (order < MAX_ORDER - 1) {
 		if (compaction_capture(capc, page, order, migratetype)) {
 			__mod_zone_freepage_state(zone, -(1 << order),
 								migratetype);
@@ -1082,6 +1080,22 @@ continue_merging:
 
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
@@ -1095,32 +1109,6 @@ continue_merging:
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

mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch
mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch

