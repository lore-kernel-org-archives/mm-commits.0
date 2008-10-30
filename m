From: akpm@linux-foundation.org
Subject: + mm-write_cache_pages-early-loop-termination.patch added to -mm tree
Date: Thu, 30 Oct 2008 16:14:31 -0700
Message-ID: <200810302314.m9UNEVHD027488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbYJ3XPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 19:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, jowens@hp.com


The patch titled
     mm: write_cache_pages early loop termination
has been added to the -mm tree.  Its filename is
     mm-write_cache_pages-early-loop-termination.patch

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
Cc: jim owens <jowens@hp.com>
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

