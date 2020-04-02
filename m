From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 059/155] mm/swap_state.c: use the same way to
 count page in [add_to|delete_from]_swap_cache
Date: Wed, 01 Apr 2020 21:06:26 -0700
Message-ID: <20200402040626.BH45PPJxR%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:28 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swap_state.c: use the same way to count page in [add_to|delete_from]_swap_cache

add_to_swap_cache() and delete_from_swap_cache() are counterparts, while
currently they use different ways to count pages.

It doesn't break anything because we only have two sizes for PageAnon, but
this is confusing and not good practice.

This patch corrects it by making both functions use hpage_nr_pages().

Link: http://lkml.kernel.org/r/20200315012920.2687-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap_statec-use-the-same-way-to-count-page-in-_swap_cache
+++ a/mm/swap_state.c
@@ -116,7 +116,7 @@ int add_to_swap_cache(struct page *page,
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE_ORDER(xas, &address_space->i_pages, idx, compound_order(page));
-	unsigned long i, nr = compound_nr(page);
+	unsigned long i, nr = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapCache(page), page);
_
