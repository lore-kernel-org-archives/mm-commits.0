From: akpm@linux-foundation.org
Subject: + mm-write_cache_pages-writepage-error-fix.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:06:02 -0700
Message-ID: <200810212206.m9LM62tA031009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYJUWGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, matthew@wil.cx


The patch titled
     mm: write_cache_pages() writepage error fix
has been added to the -mm tree.  Its filename is
     mm-write_cache_pages-writepage-error-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages() writepage error fix
From: Nick Piggin <npiggin@suse.de>

In write_cache_pages(), if ret signals a real error, but we still have
some pages left in the pagevec, done would be set to 1, but the remaining
pages would continue to be processed and ret will be overwritten in the
process.  It could easily be overwritten with success, and thus success
will be returned even if there is an error.  Thus the caller is told all
writes succeeded, wheras in reality some did not.

Fix this by bailing immediately if there is an error, and retaining the
first error code.

This is a data interity bug.

[akpm@linux-foundation.org: fix all the other done=1 cases too]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-writepage-error-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-writepage-error-fix
+++ a/mm/page-writeback.c
@@ -865,7 +865,6 @@ int write_cache_pages(struct address_spa
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
-	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
 	pgoff_t index;
@@ -891,10 +890,10 @@ int write_cache_pages(struct address_spa
 		scanned = 1;
 	}
 retry:
-	while (!done && (index <= end) &&
+	while ((index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+				PAGECACHE_TAG_DIRTY,
+				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
 		scanned = 1;
@@ -903,9 +902,9 @@ retry:
 
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
-			 * lock on the page itself: the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or even
-			 * swizzled back from swapper_space to tmpfs file
+			 * lock on the page itself: the page may be truncated
+			 * or invalidated (changing page->mapping to NULL), or
+			 * even swizzled back from swapper_space to tmpfs file
 			 * mapping
 			 */
 			lock_page(page);
@@ -916,8 +915,8 @@ retry:
 			}
 
 			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
 				unlock_page(page);
+				goto bail;
 				continue;
 			}
 
@@ -937,16 +936,16 @@ retry:
 				ret = 0;
 			}
 			if (ret || (--nr_to_write <= 0))
-				done = 1;
+				goto bail;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
-				done = 1;
+				goto bail;
 			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!scanned && !done) {
+	if (!scanned) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
@@ -961,7 +960,11 @@ retry:
 		wbc->nr_to_write = nr_to_write;
 	}
 
+out:
 	return ret;
+bail:
+	pagevec_release(&pvec);
+	goto out;
 }
 EXPORT_SYMBOL(write_cache_pages);
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
mm-write_cache_pages-writepage-error-fix.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

