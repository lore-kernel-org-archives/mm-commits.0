From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 058/155] mm: swap: use smp_mb__after_atomic() to
 order LRU bit set
Date: Wed, 01 Apr 2020 21:06:23 -0700
Message-ID: <20200402040623.1OTEIbdDl%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:25 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: swap: use smp_mb__after_atomic() to order LRU bit set

Memory barrier is needed after setting LRU bit, but smp_mb() is too
strong.  Some architectures, i.e.  x86, imply memory barrier with atomic
operations, so replacing it with smp_mb__after_atomic() sounds better,
which is nop on strong ordered machines, and full memory barriers on
others.  With this change the vm-scalability cases would perform better on
x86, I saw total 6% improvement with this patch and previous inline fix.

The test data (lru-file-readtwice throughput) against v5.6-rc4:
	mainline	w/ inline fix	w/ both (adding this)
	150MB		154MB		159MB

Link: http://lkml.kernel.org/r/1584500541-46817-2-git-send-email-yang.shi@linux.alibaba.com
Fixes: 9c4e6b1a7027 ("mm, mlock, vmscan: no more skipping pagevecs")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-swap-use-smp_mb__after_atomic-to-order-lru-bit-set
+++ a/mm/swap.c
@@ -931,7 +931,6 @@ static void __pagevec_lru_add_fn(struct
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	SetPageLRU(page);
 	/*
 	 * Page becomes evictable in two ways:
 	 * 1) Within LRU lock [munlock_vma_page() and __munlock_pagevec()].
@@ -958,7 +957,8 @@ static void __pagevec_lru_add_fn(struct
 	 * looking at the same page) and the evictable page will be stranded
 	 * in an unevictable LRU.
 	 */
-	smp_mb();
+	SetPageLRU(page);
+	smp_mb__after_atomic();
 
 	if (page_evictable(page)) {
 		lru = page_lru(page);
_
