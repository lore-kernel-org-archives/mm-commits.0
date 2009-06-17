From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:15 -0700
Message-ID: <200906171834.n5HIYFuu032760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbZFQSep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, penberg@cs.h


The patch titled
     page allocator: do not check for compound pages during the page allocator sanity checks
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: do not check for compound pages during the page allocator sanity checks
From: Nick Piggin <nickpiggin@yahoo.com.au>

A number of sanity checks are made on each page allocation and free
including that the page count is zero.  page_count() checks for compound
pages and checks the count of the head page if true.  However, in these
paths, we do not care if the page is compound or not as the count of each
tail page should also be zero.

This patch makes two changes to the use of page_count() in the free path. 
It converts one check of page_count() to a VM_BUG_ON() as the count should
have been unconditionally checked earlier in the free path.  It also
avoids checking for compound pages.

[mel@csn.ul.ie: Wrote changelog]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks
+++ a/mm/page_alloc.c
@@ -421,7 +421,7 @@ static inline int page_is_buddy(struct p
 		return 0;
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		BUG_ON(page_count(buddy) != 0);
+		VM_BUG_ON(page_count(buddy) != 0);
 		return 1;
 	}
 	return 0;
@@ -497,7 +497,7 @@ static inline int free_pages_check(struc
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
+		(atomic_read(&page->_count) != 0) |
 		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
 		bad_page(page);
 		return 1;
@@ -642,7 +642,7 @@ static int prep_new_page(struct page *pa
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
+		(atomic_read(&page->_count) != 0)  |
 		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
 		bad_page(page);
 		return 1;
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
vfs-take-2add-set_page_dirty_notag.patch
reiser4.patch

