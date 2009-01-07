From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-cyclic-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:28 -0800
Message-ID: <200901072211.n07MBSYx011719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbZAGWLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages cyclic fix
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-cyclic-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages cyclic fix
From: Nick Piggin <npiggin@suse.de>

In write_cache_pages, scanned == 1 is supposed to mean that cyclic
writeback has circled through zero, thus we should not circle again. 
However it gets set to 1 after the first successful pagevec lookup.  This
leads to cases where not enough data gets written.

Counterexample: file with first 10 pages dirty, writeback_index == 5,
nr_to_write == 10.  Then the 5 last pages will be found, and scanned will
be set to 1, after writing those out, we will not cycle back to get the
first 5.

Rework this logic, now we'll always cycle unless we started off from index
0.  When cycling, only write out as far as 1 page before the start page
from the first cycle (so we don't write parts of the file twice).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-cyclic-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-cyclic-fix
+++ a/mm/page-writeback.c
@@ -868,9 +868,10 @@ int write_cache_pages(struct address_spa
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
+	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
@@ -881,14 +882,19 @@ int write_cache_pages(struct address_spa
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
+		writeback_index = mapping->writeback_index; /* prev offset */
+		index = writeback_index;
+		if (index == 0)
+			cycled = 1;
+		else
+			cycled = 0;
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
+		cycled = 1; /* ignore range_cyclic tests */
 	}
 retry:
 	while (!done && (index <= end) &&
@@ -897,7 +903,6 @@ retry:
 					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -915,7 +920,11 @@ retry:
 				continue;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
+				/*
+				 * can't be range_cyclic (1st pass) because
+				 * end == -1 in that case.
+				 */
 				done = 1;
 				unlock_page(page);
 				continue;
@@ -946,13 +955,15 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!scanned && !done) {
+	if (!cycled) {
 		/*
+		 * range_cyclic:
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		cycled = 1;
 		index = 0;
+		end = writeback_index - 1;
 		goto retry;
 	}
 	if (!wbc->no_nrwrite_index_update) {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

