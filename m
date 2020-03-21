From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-swap_statec-use-the-same-way-to-count-page-in-_swap_cache.patch added to
 -mm tree
Date: Sat, 21 Mar 2020 13:24:07 -0700
Message-ID: <20200321202407.v8RmO0nNB%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgCUUYJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 16:24:09 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard.weiyang@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/swap_state.c: use the same way to count page in [add_to|delete_from]_swap_cache
has been added to the -mm tree.  Its filename is
     mm-swap_statec-use-the-same-way-to-count-page-in-_swap_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap_statec-use-the-same-way-to-count-page-in-_swap_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_statec-use-the-same-way-to-count-page-in-_swap_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swap_state.c: use the same way to count page in [add_to|delete_from]_swap_cache

add_to_swap_cache() and delete_from_swap_cache() are counterparts, while
currently they use different ways to count pages.

It doesn't break anything because we only have two sizes for PageAnon, but
this is confusing and not good practice.

This patch corrects it by making both functions use hpage_nr_pages().

Link: http://lkml.kernel.org/r/20200315012920.2687-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
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

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-swap_statec-use-the-same-way-to-count-page-in-_swap_cache.patch
