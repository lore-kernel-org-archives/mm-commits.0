From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-cleanups.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:37 -0800
Message-ID: <200901072211.n07MBbi3011893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbZAGWLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages cleanups
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages cleanups
From: Nick Piggin <npiggin@suse.de>

Get rid of some complex expressions from flow control statements, add a
comment, remove some duplicate code.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-cleanups mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-cleanups
+++ a/mm/page-writeback.c
@@ -899,11 +899,14 @@ int write_cache_pages(struct address_spa
 	}
 retry:
 	done_index = index;
-	while (!done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
+	while (!done && (index <= end)) {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (nr_pages == 0)
+			break;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -919,7 +922,16 @@ retry:
 			 */
 			lock_page(page);
 
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
 			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
 				unlock_page(page);
 				continue;
 			}
@@ -930,18 +942,15 @@ retry:
 				 * end == -1 in that case.
 				 */
 				done = 1;
-				unlock_page(page);
-				continue;
+				goto continue_unlock;
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE)
 				wait_on_page_writeback(page);
 
 			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page)) {
-				unlock_page(page);
-				continue;
-			}
+			    !clear_page_dirty_for_io(page))
+				goto continue_unlock;
 
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
@@ -964,7 +973,8 @@ retry:
  			}
 
 			if (wbc->sync_mode == WB_SYNC_NONE) {
-				if (--wbc->nr_to_write <= 0)
+				wbc->nr_to_write--;
+				if (wbc->nr_to_write <= 0)
 					done = 1;
 			}
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
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

