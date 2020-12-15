Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AE3C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324F02246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgLODOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgLODNV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:21 -0500
Date:   Mon, 14 Dec 2020 19:13:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001983;
        bh=fpiNsoLOeoS2vSVBEdsLdJTZhnoCv2SdFLShqUoTthg=;
        h=From:To:Subject:In-Reply-To:From;
        b=nbFWBpzTLcDsbAfd6qJ84Xd1uGQO5CVJeyFn1apiJtFIVE6n/KDxCkK5U6KfmJI8P
         6ybZAbdTRu5aIcghRdiKEJYJUJKoK7lGdqnRxfF4siCWZHzdIaSx9c/n9PHgZ8/z3X
         ykTt9PlOow1qOQdPtyHPBxt1U6zM8L3NcQy9Dj5w=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack@suse.cz, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 166/200] mm: truncate_complete_page() does not
 exist any more
Message-ID: <20201215031302.NT1syAe_a%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
