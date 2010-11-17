From: akpm@linux-foundation.org
Subject: + writeback-account-per-bdi-accumulated-written-pages.patch added to -mm tree
Date: Wed, 17 Nov 2010 15:03:14 -0800
Message-ID: <201011172303.oAHN3Euu010602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759019Ab0KQXE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 18:04:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@lst.de, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mrubin@google.com, richard@rsk.demon.co.uk, riel@redhat.com, shaohua.li@intel.com, tytso@mit.edu


The patch titled
     writeback: account per-bdi accumulated written pages
has been added to the -mm tree.  Its filename is
     writeback-account-per-bdi-accumulated-written-pages.patch

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
Subject: writeback: account per-bdi accumulated written pages
From: Jan Kara <jack@suse.cz>

Introduce the BDI_WRITTEN counter.  It will be used for estimating the
bdi's write bandwidth.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    6 ++++--
 mm/page-writeback.c         |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/backing-dev.h~writeback-account-per-bdi-accumulated-written-pages include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~writeback-account-per-bdi-accumulated-written-pages
+++ a/include/linux/backing-dev.h
@@ -40,6 +40,7 @@ typedef int (congested_fn)(void *, int);
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
 	BDI_WRITEBACK,
+	BDI_WRITTEN,
 	NR_BDI_STAT_ITEMS
 };
 
diff -puN mm/backing-dev.c~writeback-account-per-bdi-accumulated-written-pages mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-account-per-bdi-accumulated-written-pages
+++ a/mm/backing-dev.c
@@ -92,6 +92,7 @@ static int bdi_debug_stats_show(struct s
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
 		   "BackgroundThresh: %8lu kB\n"
+		   "BdiWritten:       %8lu kB\n"
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"
@@ -99,8 +100,9 @@ static int bdi_debug_stats_show(struct s
 		   "state:            %8lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_dirty, nr_io, nr_more_io,
+		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
+		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
+		   nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
 
diff -puN mm/page-writeback.c~writeback-account-per-bdi-accumulated-written-pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-account-per-bdi-accumulated-written-pages
+++ a/mm/page-writeback.c
@@ -1292,6 +1292,7 @@ int test_clear_page_writeback(struct pag
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
 				__dec_bdi_stat(bdi, BDI_WRITEBACK);
+				__inc_bdi_stat(bdi, BDI_WRITTEN);
 				__bdi_writeout_inc(bdi);
 			}
 		}
_

Patches currently in -mm which might be from jack@suse.cz are

writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch

