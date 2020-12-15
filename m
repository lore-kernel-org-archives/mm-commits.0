Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26561C49ECB
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E204622D03
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgLOX7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbgLOXZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:40 -0500
Date:   Tue, 15 Dec 2020 15:23:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074602;
        bh=vu3DO6Xy5FGzdiPMkrs8p/KdypHjQtFCOBRQpA4jkSY=;
        h=From:To:Subject:From;
        b=sT2TSW2XrQgtxJFr4i3BQ5UDemyZe13FosYvRhFBMLx62ilQhgTTevlS+WGzhu1b3
         FRxl4m0o4L/nk/kHbjCLDMo2keNms3qmao31tESXP9/nAh3Nq+5Vfe1FagNdvQ+KD8
         l+KRzhdBqoo9ZNX4u61Lkdui/JElcoJ67FaCtTqc=
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-truncate_complete_page-is-not-existed-anymore.patch removed from -mm
 tree
Message-ID: <20201215232322.y9rhO8R0X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: truncate_complete_page() does not exist any more
has been removed from the -mm tree.  Its filename was
     mm-truncate_complete_page-is-not-existed-anymore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: truncate_complete_page() does not exist any more

Patch series "mm: misc migrate cleanup and improvement", v3.


This patch (of 5):

The commit 9f4e41f4717832e ("mm: refactor truncate_complete_page()")
refactored truncate_complete_page(), and it is not existed anymore,
correct the comment in vmscan and migrate to avoid confusion.

Link: https://lkml.kernel.org/r/20201113205359.556831-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20201113205359.556831-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 mm/vmscan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-truncate_complete_page-is-not-existed-anymore
+++ a/mm/migrate.c
@@ -1106,7 +1106,7 @@ static int __unmap_and_move(struct page
 	 * and treated as swapcache but it has no rmap yet.
 	 * Calling try_to_unmap() against a page->mapping==NULL page will
 	 * trigger a BUG.  So handle it here.
-	 * 2. An orphaned page (see truncate_complete_page) might have
+	 * 2. An orphaned page (see truncate_cleanup_page) might have
 	 * fs-private metadata. The page can be picked up due to memory
 	 * offlining.  Everywhere else except page reclaim, the page is
 	 * invisible to the vm, so the page can not be migrated.  So try to
--- a/mm/vmscan.c~mm-truncate_complete_page-is-not-existed-anymore
+++ a/mm/vmscan.c
@@ -1390,7 +1390,7 @@ static unsigned int shrink_page_list(str
 		 *
 		 * Rarely, pages can have buffers and no ->mapping.  These are
 		 * the pages which were not successfully invalidated in
-		 * truncate_complete_page().  We try to drop those buffers here
+		 * truncate_cleanup_page().  We try to drop those buffers here
 		 * and if that worked, and the page is no longer mapped into
 		 * process address space (page_count == 1) it can be freed.
 		 * Otherwise, leave the page on the LRU so it is swappable.
_

Patches currently in -mm which might be from shy828301@gmail.com are


