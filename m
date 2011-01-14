From: akpm@linux-foundation.org
Subject: [merged] thp-clear-compound-mapping.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:32 -0800
Message-ID: <201101142249.p0EMnMMW005287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: clear compound mapping
has been removed from the -mm tree.  Its filename was
     thp-clear-compound-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: clear compound mapping
From: Andrea Arcangeli <aarcange@redhat.com>

Clear compound mapping for anonymous compound pages like it already
happens for regular anonymous pages.  But crash if mapping is set for any
tail page, also the PageAnon check is meaningless for tail pages.  This
check only makes sense for the head page, for tail page it can only hide
bugs and we definitely don't want to hide bugs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~thp-clear-compound-mapping mm/page_alloc.c
--- a/mm/page_alloc.c~thp-clear-compound-mapping
+++ a/mm/page_alloc.c
@@ -651,13 +651,10 @@ static bool free_pages_prepare(struct pa
 	trace_mm_page_free_direct(page, order);
 	kmemcheck_free_shadow(page, order);
 
-	for (i = 0; i < (1 << order); i++) {
-		struct page *pg = page + i;
