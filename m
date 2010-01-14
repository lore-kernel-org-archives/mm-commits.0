From: akpm@linux-foundation.org
Subject: + mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch added to -mm tree
Date: Thu, 14 Jan 2010 14:52:57 -0800
Message-ID: <201001142252.o0EMqvrr003853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644Ab0ANWzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 17:55:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lihong.hi@gmail.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, macli@brc.ubc.ca, mel@csn.ul.ie, mingo@elte.hu, peterz@infradead.org, riel@redhat.com


The patch titled
     mm/page_alloc.c: remove duplicate call to trace_mm_page_free_direct
has been added to the -mm tree.  Its filename is
     mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch

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
Subject: mm/page_alloc.c: remove duplicate call to trace_mm_page_free_direct
From: Li Hong <lihong.hi@gmail.com>

trace_mm_page_free_direct() is called in function __free_pages().  But it
is called again in free_hot_page() if order == 0 and produce duplicate
records in trace file for mm_page_free_direct event.  As below:

K-PID    CPU#    TIMESTAMP  FUNCTION
  gnome-terminal-1567  [000]  4415.246466: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
  gnome-terminal-1567  [000]  4415.246468: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
  gnome-terminal-1567  [000]  4415.246506: mm_page_alloc: page=ffffea0003db9f40 pfn=1155800 order=0 migratetype=0 gfp_flags=GFP_KERNEL
  gnome-terminal-1567  [000]  4415.255557: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
  gnome-terminal-1567  [000]  4415.255557: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0

This patch removes the first call and adds a call to
trace_mm_page_free_direct() in __free_pages_ok().

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

diff -puN mm/page_alloc.c~mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct
+++ a/mm/page_alloc.c
@@ -601,6 +601,7 @@ static void __free_pages_ok(struct page 
 	int bad = 0;
 	int wasMlocked = __TestClearPageMlocked(page);
 
+	trace_mm_page_free_direct(page, order);
 	kmemcheck_free_shadow(page, order);
 
 	for (i = 0 ; i < (1 << order) ; ++i)
@@ -2026,7 +2027,6 @@ void __pagevec_free(struct pagevec *pvec
 void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page)) {
-		trace_mm_page_free_direct(page, order);
 		if (order == 0)
 			free_hot_page(page);
 		else
_

Patches currently in -mm which might be from lihong.hi@gmail.com are

mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch

