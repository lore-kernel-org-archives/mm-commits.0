From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:32 -0800
Message-ID: <201003091903.o29J3W48030973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab0CITEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lihong.hi@gmail.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: adjust a call site to  trace_mm_page_free_direct
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: adjust a call site to  trace_mm_page_free_direct
From: Li Hong <lihong.hi@gmail.com>

Move a call of trace_mm_page_free_direct() from free_hot_page() to
free_hot_cold_page().  It is clearer and close to kmemcheck_free_shadow(),
as it is done in function __free_pages_ok().

Signed-off-by: Li Hong <lihong.hi@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct
+++ a/mm/page_alloc.c
@@ -1083,6 +1083,7 @@ static void free_hot_cold_page(struct pa
 	int migratetype;
 	int wasMlocked = __TestClearPageMlocked(page);
 
+	trace_mm_page_free_direct(page, 0);
 	kmemcheck_free_shadow(page, 0);
 
 	if (PageAnon(page))
@@ -1136,7 +1137,6 @@ out:
 
 void free_hot_page(struct page *page)
 {
-	trace_mm_page_free_direct(page, 0);
 	free_hot_cold_page(page, 0);
 }
 	
_

Patches currently in -mm which might be from lihong.hi@gmail.com are


