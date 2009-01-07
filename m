From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-terminate-quickly.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:41 -0800
Message-ID: <200901072211.n07MBf9K011995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754487AbZAGWLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages terminate quickly
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-terminate-quickly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages terminate quickly
From: Nick Piggin <npiggin@suse.de>

Terminate the write_cache_pages loop upon encountering the first page past
end, without locking the page.  Pages cannot have their index change when
we have a reference on them (truncate, eg truncate_inode_pages_range
performs the same check without the page lock).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-terminate-quickly mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-terminate-quickly
+++ a/mm/page-writeback.c
@@ -911,15 +911,24 @@ retry:
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			done_index = page->index + 1;
-
 			/*
-			 * At this point we hold neither mapping->tree_lock nor
-			 * lock on the page itself: the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or even
-			 * swizzled back from swapper_space to tmpfs file
-			 * mapping
+			 * At this point, the page may be truncated or
+			 * invalidated (changing page->mapping to NULL), or
+			 * even swizzled back from swapper_space to tmpfs file
+			 * mapping. However, page->index will not change
+			 * because we have a reference on the page.
 			 */
+			if (page->index > end) {
+				/*
+				 * can't be range_cyclic (1st pass) because
+				 * end == -1 in that case.
+				 */
+				done = 1;
+				break;
+			}
+
+			done_index = page->index + 1;
+
 			lock_page(page);
 
 			/*
@@ -936,15 +945,6 @@ continue_unlock:
 				continue;
 			}
 
-			if (page->index > end) {
-				/*
-				 * can't be range_cyclic (1st pass) because
-				 * end == -1 in that case.
-				 */
-				done = 1;
-				goto continue_unlock;
-			}
