Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941B2C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5638D64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhBXUJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235052AbhBXUIt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48C6F64E7A;
        Wed, 24 Feb 2021 20:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197314;
        bh=sylk1bvGCaTJ5Qua3xWqLf5tDYuM1TisyKVRzm9pXdo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TwSKAyX3rsJsdBfH1iN3WFEsc+IpsOhWyJyAQoQYD0ufkUFk8vY28lLmcSb9ZcfBq
         rEJanW8UETr4HgNU8N9aBSCbtMtYRIZLnFCPIVvuhSmUJnA8nacaOGWpmAqZ2O4v7W
         E7zRBjbFQ+YO+g/MaOjpRmu56dgZ3WjAX0//Xq2Q=
Date:   Wed, 24 Feb 2021 12:08:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org, yuzhao@google.com
Subject:  [patch 141/173] mm: VM_BUG_ON lru page flags
Message-ID: <20210224200832.cfPceYDI1%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: mm: VM_BUG_ON lru page flags

Move scattered VM_BUG_ONs to two essential places that cover all
lru list additions and deletions.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-8-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-8-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    4 ++++
 mm/swap.c                 |    2 --
 mm/vmscan.c               |    1 -
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/mm_inline.h~mm-vm_bug_on-lru-page-flags
+++ a/include/linux/mm_inline.h
@@ -66,6 +66,8 @@ static inline enum lru_list page_lru_bas
  */
 static __always_inline void __clear_page_lru_flags(struct page *page)
 {
+	VM_BUG_ON_PAGE(!PageLRU(page), page);
+
 	__ClearPageLRU(page);
 
 	/* this shouldn't happen, so leave the flags to bad_page() */
@@ -87,6 +89,8 @@ static __always_inline enum lru_list pag
 {
 	enum lru_list lru;
 
+	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
+
 	if (PageUnevictable(page))
 		lru = LRU_UNEVICTABLE;
 	else {
--- a/mm/swap.c~mm-vm_bug_on-lru-page-flags
+++ a/mm/swap.c
@@ -83,7 +83,6 @@ static void __page_cache_release(struct
 		unsigned long flags;
 
 		lruvec = lock_page_lruvec_irqsave(page, &flags);
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		del_page_from_lru_list(page, lruvec);
 		__clear_page_lru_flags(page);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
@@ -909,7 +908,6 @@ void release_pages(struct page **pages,
 			if (prev_lruvec != lruvec)
 				lock_batch = 0;
 
-			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			del_page_from_lru_list(page, lruvec);
 			__clear_page_lru_flags(page);
 		}
--- a/mm/vmscan.c~mm-vm_bug_on-lru-page-flags
+++ a/mm/vmscan.c
@@ -4281,7 +4281,6 @@ void check_move_unevictable_pages(struct
 
 		lruvec = relock_page_lruvec_irq(page, lruvec);
 		if (page_evictable(page) && PageUnevictable(page)) {
-			VM_BUG_ON_PAGE(PageActive(page), page);
 			del_page_from_lru_list(page, lruvec);
 			ClearPageUnevictable(page);
 			add_page_to_lru_list(page, lruvec);
_
