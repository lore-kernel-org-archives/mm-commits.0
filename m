Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08238C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbiE0QfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349000AbiE0QfQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C43527C1
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09CB161DE5
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EB4C34113;
        Fri, 27 May 2022 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669314;
        bh=R9mqctzkLLKauIi7/GhbO5HZGp8TJWjAaQvPmlUbSMY=;
        h=Date:To:From:Subject:From;
        b=WBKP+UqmUODuKGlgVRCNJodrIUrdJrH3i2KEv/jX0z2nUsv7H1V4AQz+8AIdL3vLu
         HmJgG7kiyJLhmS9JVc68/jfP8QpuFATwO+7LYJVVukQ8ETNbwY/YnBhxSpM/87Jv0E
         C8X1w57vI/gCzE2rfn0Tt5EU//QWGnYRYNxrFuic=
Date:   Fri, 27 May 2022 09:35:13 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        jhubbard@nvidia.com, david@redhat.com, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-is_pinnable_page-against-a-cma-page.patch removed from -mm tree
Message-Id: <20220527163514.64EB4C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix is_pinnable_page against a cma page
has been removed from the -mm tree.  Its filename was
     mm-fix-is_pinnable_page-against-a-cma-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix is_pinnable_page against a cma page
Date: Tue, 24 May 2022 10:15:25 -0700

Pages in the CMA area could have MIGRATE_ISOLATE as well as MIGRATE_CMA so
the current is_pinnable_page() could miss CMA pages which have
MIGRATE_ISOLATE.  It ends up pinning CMA pages as longterm for the
pin_user_pages() API so CMA allocations keep failing until the pin is
released.

     CPU 0                                   CPU 1 - Task B

cma_alloc
alloc_contig_range
                                        pin_user_pages_fast(FOLL_LONGTERM)
change pageblock as MIGRATE_ISOLATE
                                        internal_get_user_pages_fast
                                        lockless_pages_from_mm
                                        gup_pte_range
                                        try_grab_folio
                                        is_pinnable_page
                                          return true;
                                        So, pinned the page successfully.
page migration failure with pinned page
                                        ..
                                        .. After 30 sec
                                        unpin_user_page(page)

CMA allocation succeeded after 30 sec.

The CMA allocation path protects the migration type change race using
zone->lock but what GUP path need to know is just whether the page is on
CMA area or not rather than exact migration type.  Thus, we don't need
zone->lock but just checks migration type in either of (MIGRATE_ISOLATE
and MIGRATE_CMA).

Adding the MIGRATE_ISOLATE check in is_pinnable_page could cause rejecting
of pinning pages on MIGRATE_ISOLATE pageblocks even though it's neither
CMA nor movable zone if the page is temporarily unmovable.  However, such
a migration failure by unexpected temporal refcount holding is general
issue, not only come from MIGRATE_ISOLATE and the MIGRATE_ISOLATE is also
transient state like other temporal elevated refcount problem.

Link: https://lkml.kernel.org/r/20220524171525.976723-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++++--
 mm/page_alloc.c    |    8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-a-cma-page
+++ a/include/linux/mm.h
@@ -1594,8 +1594,13 @@ static inline bool page_needs_cow_for_dm
 #ifdef CONFIG_MIGRATION
 static inline bool is_pinnable_page(struct page *page)
 {
-	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
-		is_zero_pfn(page_to_pfn(page));
+#ifdef CONFIG_CMA
+	int mt = get_pageblock_migratetype(page);
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
--- a/mm/page_alloc.c~mm-fix-is_pinnable_page-against-a-cma-page
+++ a/mm/page_alloc.c
@@ -482,8 +482,12 @@ unsigned long __get_pfnblock_flags_mask(
 	bitidx = pfn_to_bitidx(page, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
 	bitidx &= (BITS_PER_LONG-1);
-
-	word = bitmap[word_bitidx];
+	/*
+	 * This races, without locks, with set_pfnblock_flags_mask(). Ensure
+	 * a consistent read of the memory array, so that results, even though
+	 * racy, are not corrupted.
+	 */
+	word = READ_ONCE(bitmap[word_bitidx]);
 	return (word >> bitidx) & mask;
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are


