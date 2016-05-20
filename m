From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:06:55 -0700
Message-ID: <573f7c6f.BruUM21ZlBQeG2NO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbcETVG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: pull out side effects from free_pages_check
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: pull out side effects from free_pages_check

Check without side-effects should be easier to maintain.  It also removes
the duplicated cpupid and flags reset done in !DEBUG_VM variant of both
free_pcp_prepare() and then bulkfree_pcp_prepare().  Finally, it enables
the next patch.

It shouldn't result in new branches, thanks to inlining of the check.

!DEBUG_VM bloat-o-meter:

add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-27 (-27)
function                                     old     new   delta
__free_pages_ok                              748     739      -9
free_pcppages_bulk                          1403    1385     -18

DEBUG_VM:

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-28 (-28)
function                                     old     new   delta
free_pages_prepare                           806     778     -28

This is also slightly faster because cpupid information is not set on tail
pages so we can avoid resets there.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-pull-out-side-effects-from-free_pages_check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-pull-out-side-effects-from-free_pages_check
+++ a/mm/page_alloc.c
@@ -833,11 +833,8 @@ static void free_pages_check_bad(struct
 
 static inline int free_pages_check(struct page *page)
 {
-	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE))) {
-		page_cpupid_reset_last(page);
-		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
 		return 0;
-	}
 
 	/* Something has gone sideways, find it */
 	free_pages_check_bad(page);
@@ -1078,7 +1075,11 @@ static bool free_pages_prepare(struct pa
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			bad += free_pages_check(page + i);
+			if (unlikely(free_pages_check(page + i))) {
+				bad++;
+				continue;
+			}
+			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
 	if (PageAnonHead(page))
@@ -1087,6 +1088,8 @@ static bool free_pages_prepare(struct pa
 	if (bad)
 		return false;
 
+	page_cpupid_reset_last(page);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	reset_page_owner(page, order);
 
 	if (!PageHighMem(page)) {
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


