From: akpm@linux-foundation.org
Subject: [merged] mm-remove-function-free_hot_page.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:35 -0800
Message-ID: <201003091903.o29J3Z62030976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693Ab0CITFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lihong.hi@gmail.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, xiyou.wangcong@gmail.c


The patch titled
     mm: remove free_hot_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-function-free_hot_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove free_hot_page()
From: Li Hong <lihong.hi@gmail.com>

free_hot_page() is just a wrapper around free_hot_cold_page() with
parameter 'cold = 0'.  After adding a clear comment for
free_hot_cold_page(), it is reasonable to remove a level of call.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Li Hong <lihong.hi@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/page_alloc.c     |   10 +++-------
 mm/swap.c           |    2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

diff -puN include/linux/gfp.h~mm-remove-function-free_hot_page include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-function-free_hot_page
+++ a/include/linux/gfp.h
@@ -325,7 +325,7 @@ void free_pages_exact(void *virt, size_t
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_hot_page(struct page *page);
+extern void free_hot_cold_page(struct page *page, int cold);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff -puN mm/page_alloc.c~mm-remove-function-free_hot_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-function-free_hot_page
+++ a/mm/page_alloc.c
@@ -1074,8 +1074,9 @@ void mark_free_pages(struct zone *zone)
 
 /*
  * Free a 0-order page
+ * cold == 1 ? free a cold page : free a hot page
  */
-static void free_hot_cold_page(struct page *page, int cold)
+void free_hot_cold_page(struct page *page, int cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -1135,11 +1136,6 @@ out:
 	local_irq_restore(flags);
 }
 
-void free_hot_page(struct page *page)
-{
-	free_hot_cold_page(page, 0);
-}
-	
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
@@ -2010,7 +2006,7 @@ void __free_pages(struct page *page, uns
 {
 	if (put_page_testzero(page)) {
 		if (order == 0)
-			free_hot_page(page);
+			free_hot_cold_page(page, 0);
 		else
 			__free_pages_ok(page, order);
 	}
diff -puN mm/swap.c~mm-remove-function-free_hot_page mm/swap.c
--- a/mm/swap.c~mm-remove-function-free_hot_page
+++ a/mm/swap.c
@@ -55,7 +55,7 @@ static void __page_cache_release(struct 
 		del_page_from_lru(zone, page);
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
-	free_hot_page(page);
+	free_hot_cold_page(page, 0);
 }
 
 static void put_compound_page(struct page *page)
_

Patches currently in -mm which might be from lihong.hi@gmail.com are


