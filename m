From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:01 -0700
Message-ID: <201111012109.pA1L91Ne016872@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15494 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1KAVKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, min


The patch titled
     Subject: mm: vmscan: remove dead code related to lumpy reclaim waiting on pages under writeback
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: remove dead code related to lumpy reclaim waiting on pages under writeback

Lumpy reclaim worked with two passes - the first which queued pages for IO
and the second which waited on writeback.  As direct reclaim can no longer
write pages there is some dead code.  This patch removes it but direct
reclaim will continue to wait on pages under writeback while in
synchronous reclaim mode.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback
+++ a/mm/vmscan.c
@@ -495,15 +495,6 @@ static pageout_t pageout(struct page *pa
 			return PAGE_ACTIVATE;
 		}
 
-		/*
-		 * Wait on writeback if requested to. This happens when
-		 * direct reclaiming a large contiguous area and the
-		 * first attempt to free a range of pages fails.
-		 */
-		if (PageWriteback(page) &&
-		    (sc->reclaim_mode & RECLAIM_MODE_SYNC))
-			wait_on_page_writeback(page);
-
 		if (!PageWriteback(page)) {
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
@@ -804,12 +795,10 @@ static unsigned long shrink_page_list(st
 
 		if (PageWriteback(page)) {
 			/*
-			 * Synchronous reclaim is performed in two passes,
-			 * first an asynchronous pass over the list to
-			 * start parallel writeback, and a second synchronous
-			 * pass to wait for the IO to complete.  Wait here
-			 * for any page for which writeback has already
-			 * started.
+			 * Synchronous reclaim cannot queue pages for
+			 * writeback due to the possibility of stack overflow
+			 * but if it encounters a page under writeback, wait
+			 * for the IO to complete.
 			 */
 			if ((sc->reclaim_mode & RECLAIM_MODE_SYNC) &&
 			    may_enter_fs)
@@ -1414,7 +1403,7 @@ static noinline_for_stack void update_is
 }
 
 /*
- * Returns true if the caller should wait to clean dirty/writeback pages.
+ * Returns true if a direct reclaim should wait on pages under writeback.
  *
  * If we are direct reclaiming for contiguous pages and we do not reclaim
  * everything in the list, try again and wait for writeback IO to complete.
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

