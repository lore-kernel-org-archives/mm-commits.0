From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-use-smp_mb__after_atomic-to-order-lru-bit-set.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:37:13 -0700
Message-ID: <20200403203713.1XSwUkNWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUhO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: swap: use smp_mb__after_atomic() to order LRU bit set
has been removed from the -mm tree.  Its filename was
     mm-swap-use-smp_mb__after_atomic-to-order-lru-bit-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-migratec-migrate-pg_readahead-flag.patch
