From: akpm@linux-foundation.org
Subject: +
 mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch added to
 -mm tree
Date: Fri, 29 May 2020 21:58:39 -0700
Message-ID: <20200530045839.qwpVXnbGc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgE3E6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 30 May 2020 00:58:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linmiaohe@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/swap.h: delete meaningless __add_to_swap_cache() declaration
has been added to the -mm tree.  Its filename is
     mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: include/linux/swap.h: delete meaningless __add_to_swap_cache() declaration

Since commit 8d93b41c09d1 ("mm: Convert add_to_swap_cache to XArray"),
__add_to_swap_cache and add_to_swap_cache are combined into one function. 
There is no __add_to_swap_cache() anymore.

Link: http://lkml.kernel.org/r/1590810326-2493-1-git-send-email-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-delete-meaningless-__add_to_swap_cache-declaration
+++ a/include/linux/swap.h
@@ -414,7 +414,6 @@ extern unsigned long total_swapcache_pag
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
-extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *, swp_entry_t entry);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch
