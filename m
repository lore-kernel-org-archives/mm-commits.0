Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B825C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 19:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbiEQTsE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 15:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbiEQTsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 15:48:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917D537BC5
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 12:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DD0661680
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 19:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85817C385B8;
        Tue, 17 May 2022 19:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652816881;
        bh=nUDQB906uOS+TChlNmpUaXV3Jm2pFCCB8/Xvlw9arfI=;
        h=Date:To:From:Subject:From;
        b=O4YiwsbngJCnni7zUTCPH8q1OXRLngHxtTj0FHy2wtf9hO5IjaUuftVxJR4B5oMdR
         nCBgo1IjvkTmEP8dKHnSgXWiZkfqgNA0iGzDIt8qFgcSyHC2H6i/F8pmHIdYnMioJG
         Te8PRAPTK9hEauOX63qYGzFIdxUHVjqj0EeS4JBU=
Date:   Tue, 17 May 2022 12:48:00 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        paulmck@kernel.org, joaodias@google.com, jhubbard@nvidia.com,
        david@redhat.com, minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-fix-is_pinnable_page-against-on-cma-page.patch removed from -mm tree
Message-Id: <20220517194801.85817C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix is_pinnable_page against on cma page
has been removed from the -mm tree.  Its filename was
     mm-fix-is_pinnable_page-against-on-cma-page.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix is_pinnable_page against on cma page

Pages on CMA area could have MIGRATE_ISOLATE as well as MIGRATE_CMA so
current is_pinnable_page could miss CMA pages which has MIGRATE_ ISOLATE. 
It ends up pinning CMA pages as longterm at pin_user_pages APIs so CMA
allocation keep failed until the pin is released.

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

[akpm@linux-foundation.org: MIGRATE_CMA and MIGRATE_ISOLATE are not bitwise, per Minchan]
[minchan@kernel.org: restore __mt definition]
[minchan@kernel.org: changes per Paul and John]
  Link: https://lkml.kernel.org/r/20220512204143.3961150-1-minchan@kernel.org
Link: https://lkml.kernel.org/r/20220510211743.95831-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Dias <joaodias@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page
+++ a/include/linux/mm.h
@@ -1625,8 +1625,21 @@ static inline bool page_needs_cow_for_dm
 #ifdef CONFIG_MIGRATION
 static inline bool is_pinnable_page(struct page *page)
 {
-	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
-		is_zero_pfn(page_to_pfn(page));
+#ifdef CONFIG_CMA
+	/*
+	 * Defend against future compiler LTO features, or code refactoring
+	 * that inlines the above function, by forcing a single read. Because,
+	 * this routine races with set_pageblock_migratetype(), and we want to
+	 * avoid reading zero, when actually one or the other flags was set.
+	 */
+	int __mt = get_pageblock_migratetype(page);
+	int mt = __READ_ONCE(__mt);
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+
+	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

