From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-early-loop-termination.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:31 -0800
Message-ID: <200901072211.n07MBVio011776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbZAGWLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages early loop termination
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-early-loop-termination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages early loop termination
From: Nick Piggin <npiggin@suse.de>

We'd like to break out of the loop early in many situations, however the
existing code has been setting mapping->writeback_index past the final
page in the pagevec lookup for cyclic writeback.  This is a problem if we
don't process all pages up to the final page.

Currently the code mostly keeps writeback_index reasonable and hacked
around this by not breaking out of the loop or writing pages outside the
range in these cases.  Keep track of a real "done index" that enables us
to terminate the loop in a much more flexible manner.

Needed by the subsequent patch to preserve writepage errors, and then
further patches to break out of the loop early for other reasons.  However
there are no functional changes with this patch alone.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-early-loop-termination mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-early-loop-termination
+++ a/mm/page-writeback.c
@@ -871,6 +871,7 @@ int write_cache_pages(struct address_spa
 	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
+	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
@@ -897,6 +898,7 @@ int write_cache_pages(struct address_spa
 		cycled = 1; /* ignore range_cyclic tests */
 	}
 retry:
+	done_index = index;
 	while (!done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 					      PAGECACHE_TAG_DIRTY,
@@ -906,6 +908,8 @@ retry:
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
+			done_index = page->index + 1;
+
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
 			 * lock on the page itself: the page may be truncated or
@@ -968,7 +972,7 @@ retry:
 	}
 	if (!wbc->no_nrwrite_index_update) {
 		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
-			mapping->writeback_index = index;
+			mapping->writeback_index = done_index;
 		wbc->nr_to_write = nr_to_write;
 	}
 
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

