Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2CAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3912F64F0E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhBXUJV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235372AbhBXUIr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8176464F1D;
        Wed, 24 Feb 2021 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197310;
        bh=Y0+LHY/h97swDRw6Vb+0jE85/g2oXqbQ5XEZhkLKnok=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=If8bOR32/MNwHofCUdN07MzYq8bIuxZKKqY6mCUA9F9ots/zDe4zD+wzSASCr2VvI
         PckfHxCr7M+LQoMI9crhuul9mhgBGI52IWKAa8MBiXO8g14mqSvBrHQT3QVcrpd4d6
         DnZvV9EWpq+UGmGAZi+WPupcRWR17Fhv7zkghlTc=
Date:   Wed, 24 Feb 2021 12:08:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org, yuzhao@google.com
Subject:  [patch 140/173] mm: add __clear_page_lru_flags() to
 replace page_off_lru()
Message-ID: <20210224200828.TIcm2MbA8%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: mm: add __clear_page_lru_flags() to replace page_off_lru()

Similar to page_off_lru(), the new function does non-atomic clearing
of PageLRU() in addition to PageActive() and PageUnevictable(), on a
page that has no references left.

If PageActive() and PageUnevictable() are both set, refuse to clear
either and leave them to bad_page(). This is a behavior change that
is meant to help debug.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-7-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-7-yuzhao@google.com
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

 include/linux/mm_inline.h |   28 ++++++++++------------------
 mm/swap.c                 |    6 ++----
 mm/vmscan.c               |    3 +--
 3 files changed, 13 insertions(+), 24 deletions(-)

--- a/include/linux/mm_inline.h~mm-add-__clear_page_lru_flags-to-replace-page_off_lru
+++ a/include/linux/mm_inline.h
@@ -61,27 +61,19 @@ static inline enum lru_list page_lru_bas
 }
 
 /**
- * page_off_lru - which LRU list was page on? clearing its lru flags.
- * @page: the page to test
- *
- * Returns the LRU list a page was on, as an index into the array of LRU
- * lists; and clears its Unevictable or Active flags, ready for freeing.
+ * __clear_page_lru_flags - clear page lru flags before releasing a page
+ * @page: the page that was on lru and now has a zero reference
  */
-static __always_inline enum lru_list page_off_lru(struct page *page)
+static __always_inline void __clear_page_lru_flags(struct page *page)
 {
-	enum lru_list lru;
+	__ClearPageLRU(page);
 
-	if (PageUnevictable(page)) {
-		__ClearPageUnevictable(page);
-		lru = LRU_UNEVICTABLE;
-	} else {
-		lru = page_lru_base_type(page);
-		if (PageActive(page)) {
-			__ClearPageActive(page);
-			lru += LRU_ACTIVE;
-		}
-	}
-	return lru;
+	/* this shouldn't happen, so leave the flags to bad_page() */
+	if (PageActive(page) && PageUnevictable(page))
+		return;
+
+	__ClearPageActive(page);
+	__ClearPageUnevictable(page);
 }
 
 /**
--- a/mm/swap.c~mm-add-__clear_page_lru_flags-to-replace-page_off_lru
+++ a/mm/swap.c
@@ -84,9 +84,8 @@ static void __page_cache_release(struct
 
 		lruvec = lock_page_lruvec_irqsave(page, &flags);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
-		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec);
-		page_off_lru(page);
+		__clear_page_lru_flags(page);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
 	__ClearPageWaiters(page);
@@ -911,9 +910,8 @@ void release_pages(struct page **pages,
 				lock_batch = 0;
 
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
-			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec);
-			page_off_lru(page);
+			__clear_page_lru_flags(page);
 		}
 
 		__ClearPageWaiters(page);
--- a/mm/vmscan.c~mm-add-__clear_page_lru_flags-to-replace-page_off_lru
+++ a/mm/vmscan.c
@@ -1849,8 +1849,7 @@ static unsigned noinline_for_stack move_
 		SetPageLRU(page);
 
 		if (unlikely(put_page_testzero(page))) {
-			__ClearPageLRU(page);
-			__ClearPageActive(page);
+			__clear_page_lru_flags(page);
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&lruvec->lru_lock);
_
