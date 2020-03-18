From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-swap-use-smp_mb__after_atomic-to-order-lru-bit-set.patch removed from
 -mm tree
Date: Wed, 18 Mar 2020 14:14:23 -0700
Message-ID: <20200318211423.UChYhoCvL%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRVOY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 17:14:24 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: swap: use smp_mb__after_atomic() to order LRU bit set
has been removed from the -mm tree.  Its filename was
     mm-swap-use-smp_mb__after_atomic-to-order-lru-bit-set.patch

This patch was dropped because an updated version will be merged

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
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
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

mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
mm-vmpressure-use-mem_cgroup_is_root-api.patch
mm-vmscan-replace-open-codings-to-numa_no_node.patch
mm-mempolicy-use-vm_bug_on_vma-in-queue_pages_test_walk.patch
mm-migratec-migrate-pg_readahead-flag.patch
