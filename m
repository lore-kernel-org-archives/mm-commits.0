From: akpm@linux-foundation.org
Subject: + mm-write_cache_pages-cleanups.patch added to -mm tree
Date: Thu, 30 Oct 2008 16:14:38 -0700
Message-ID: <200810302314.m9UNEcqg027552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469AbYJ3XPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 19:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, jowens@hp.com


The patch titled
     mm: write_cache_pages cleanups
has been added to the -mm tree.  Its filename is
     mm-write_cache_pages-cleanups.patch

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
Subject: mm: write_cache_pages cleanups
From: Nick Piggin <npiggin@suse.de>

Get rid of some complex expressions from flow control statements, add a
comment, remove some duplicate code.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: jim owens <jowens@hp.com>
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

mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
reiser4.patch

