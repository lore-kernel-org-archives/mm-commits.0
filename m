From: akpm@linux-foundation.org
Subject: + mm-remove-function-free_hot_page.patch added to -mm tree
Date: Thu, 14 Jan 2010 14:53:00 -0800
Message-ID: <201001142253.o0EMr1Ym003857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab0ANWyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 17:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lihong.hi@gmail.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, xiyou.wangcong@gmail.com


The patch titled
     mm: remove free_hot_page()
has been added to the -mm tree.  Its filename is
     mm-remove-function-free_hot_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove free_hot_page()
From: Li Hong <lihong.hi@gmail.com>

free_hot_page() is just a wrapper around free_hot_cold_page() with
parameter 'cold = 0'.  After adding a clear comment for
free_hot_cold_page(), it is reasonable to remove a level of call.

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

 mm/page_alloc.c |    8 ++------
 mm/swap.c       |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-function-free_hot_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-function-free_hot_page
+++ a/mm/page_alloc.c
@@ -1092,6 +1092,7 @@ void mark_free_pages(struct zone *zone)
 
 /*
  * Free a 0-order page
+ * cold == 1 ? free a cold page : free a hot page
  */
 static void free_hot_cold_page(struct page *page, int cold)
 {
@@ -1153,11 +1154,6 @@ out:
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
@@ -2028,7 +2024,7 @@ void __free_pages(struct page *page, uns
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

mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch

