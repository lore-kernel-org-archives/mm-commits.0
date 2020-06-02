From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 075/128] include/linux/swap.h: delete meaningless
 __add_to_swap_cache() declaration
Date: Mon, 01 Jun 2020 21:49:29 -0700
Message-ID: <20200602044929.4-NyFRyWH%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEta (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:30 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linmiaohe@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ying.huang@intel.com

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
@@ -414,7 +414,6 @@ extern unsigned long total_swapcache_pag
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
-extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *, swp_entry_t entry);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
_
