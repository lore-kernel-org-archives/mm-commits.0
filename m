From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:40:41 -0700
Message-ID: <20200602214041.HaMBfJfpp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBVkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linmiaohe@huawei.com, mm-commits@vger.kernel.org, ying.huang@intel.com


The patch titled
     Subject: include/linux/swap.h: delete meaningless __add_to_swap_cache() declaration
has been removed from the -mm tree.  Its filename was
     mm-swap-delete-meaningless-__add_to_swap_cache-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: include/linux/swap.h: delete meaningless __add_to_swap_cache() declaration

Since commit 8d93b41c09d1 ("mm: Convert add_to_swap_cache to XArray"),
__add_to_swap_cache and add_to_swap_cache are combined into one function. 
There is no __add_to_swap_cache() anymore.

Link: http://lkml.kernel.org/r/1590810326-2493-1-git-send-email-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-delete-meaningless-__add_to_swap_cache-declaration
+++ a/include/linux/swap.h
@@ -415,7 +415,6 @@ extern unsigned long total_swapcache_pag
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
-extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *, swp_entry_t entry);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are
