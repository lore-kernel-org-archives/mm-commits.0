From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch added to -mm tree
Date: Thu, 18 Aug 2011 16:54:44 -0700
Message-ID: <201108182354.p7INsi84002674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab1HRXzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 19:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, riel@redhat.com, tytso@mit.edu


The patch titled
     mm: vmscan: remove dead code related to lumpy reclaim waiting on pages under writeback
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch

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
Subject: mm: vmscan: remove dead code related to lumpy reclaim waiting on pages under writeback
From: Mel Gorman <mgorman@suse.de>

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
Signed-off-by: Andrew Morton <>
---

 mm/vmscan.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback
+++ a/mm/vmscan.c
@@ -496,15 +496,6 @@ static pageout_t pageout(struct page *pa
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
@@ -805,12 +796,10 @@ static unsigned long shrink_page_list(st
 
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
@@ -1421,7 +1410,7 @@ static noinline_for_stack void update_is
 }
 
 /*
- * Returns true if the caller should wait to clean dirty/writeback pages.
+ * Returns true if a direct reclaim should wait on pages under writeback.
  *
  * If we are direct reclaiming for contiguous pages and we do not reclaim
  * everything in the list, try again and wait for writeback IO to complete.
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
hugepages-fix-race-between-hugetlbfs-umount-and-quota-update-checkpatch-fixes.patch

