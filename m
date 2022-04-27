Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4E3C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 03:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357370AbiD0DK3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357309AbiD0DJy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 23:09:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81210338A2
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E4C661C77
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 03:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE51C385A4;
        Wed, 27 Apr 2022 03:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651028804;
        bh=TT7mu2y0bTTXUz3+qNt/1hSrySlyElrlraC2uSDmME4=;
        h=Date:To:From:Subject:From;
        b=LIKbR3zUhXDarcGDXdTqSzS7aCk77MVSLBZYbLPIhdokpXW5pVXSDIZ1olU+hSHtj
         4XBr2ljqpU8wM+byL4+YQcz+wXZgKlmwwr8qIUxQk80ymqONF34/d7LSGbPWyD9Ro1
         DsElP3N3rxRkSXxSKbdV75SBQuYL6izrBizQzchk=
Date:   Tue, 26 Apr 2022 20:06:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch removed from -mm tree
Message-Id: <20220427030644.6CE51C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4
has been removed from the -mm tree.  Its filename was
     mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch

This patch was dropped because it was folded into mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4

updates per David

Link: https://lkml.kernel.org/r/20220401230804.1658207-2-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/CAHk-=wji_AmYygZMTsPMdJ7XksMt7kOur8oDfDdniBRMjm4VkQ@mail.gmail.com/
Link: https://lkml.kernel.org/r/7236E7CA-B5F1-4C04-AB85-E86FA3E9A54B@nvidia.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++--
 mm/page_alloc.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4
+++ a/mm/internal.h
@@ -252,7 +252,7 @@ static inline unsigned int buddy_order(s
  * For recording page's order, we use page_private(page).
  */
 static inline bool page_is_buddy(struct page *page, struct page *buddy,
-							unsigned int order)
+				 unsigned int order)
 {
 	if (!page_is_guard(buddy) && !PageBuddy(buddy))
 		return false;
@@ -312,8 +312,8 @@ __find_buddy_pfn(unsigned long page_pfn,
 static inline struct page *find_buddy_page_pfn(struct page *page,
 			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
 {
-	struct page *buddy;
 	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
+	struct page *buddy;
 
 	buddy = page + (__buddy_pfn - pfn);
 	if (buddy_pfn)
--- a/mm/page_alloc.c~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4
+++ a/mm/page_alloc.c
@@ -976,8 +976,8 @@ static inline bool
 buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
 		   struct page *page, unsigned int order)
 {
-	struct page *higher_page;
 	unsigned long higher_page_pfn;
+	struct page *higher_page;
 
 	if (order >= MAX_ORDER - 2)
 		return false;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
mm-page_isolation-move-has_unmovable_pages-to-mm-page_isolationc.patch
mm-page_isolation-check-specified-range-for-unmovable-pages.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

