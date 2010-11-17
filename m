From: akpm@linux-foundation.org
Subject: + writeback-consolidate-variable-names-in-balance_dirty_pages.patch added to -mm tree
Date: Wed, 17 Nov 2010 15:03:06 -0800
Message-ID: <201011172303.oAHN37r6010578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935669Ab0KQXEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 18:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mrubin@google.com, richard@rsk.demon.co.uk, riel@redhat.com, shaohua.li@intel.com, tytso@mit.edu


The patch titled
     writeback: consolidate variable names in balance_dirty_pages()
has been added to the -mm tree.  Its filename is
     writeback-consolidate-variable-names-in-balance_dirty_pages.patch

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
Subject: writeback: consolidate variable names in balance_dirty_pages()
From: Wu Fengguang <fengguang.wu@intel.com>

Lots of lenthy tests.. Let's compact the names

	*_dirty = NR_FILE_DIRTY + NR_WRITEBACK + NR_UNSTABLE_NFS

balance_dirty_pages() only cares about the above dirty sum except in one
place -- on starting background writeback.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN mm/page-writeback.c~writeback-consolidate-variable-names-in-balance_dirty_pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-consolidate-variable-names-in-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -461,8 +461,8 @@ unsigned long bdi_dirty_limit(struct bac
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long pages_dirtied)
 {
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
+	long nr_reclaimable;
+	long nr_dirty, bdi_dirty;  /* = file_dirty + writeback + unstable_nfs */
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
@@ -480,7 +480,7 @@ static void balance_dirty_pages(struct a
 		 */
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
@@ -489,8 +489,7 @@ static void balance_dirty_pages(struct a
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <=
-				(background_thresh + dirty_thresh) / 2)
+		if (nr_dirty <= (background_thresh + dirty_thresh) / 2)
 			break;
 
 		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
@@ -507,21 +506,21 @@ static void balance_dirty_pages(struct a
 		 * deltas.
 		 */
 		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+			bdi_dirty = bdi_stat_sum(bdi, BDI_RECLAIMABLE) +
+				    bdi_stat_sum(bdi, BDI_WRITEBACK);
 		} else {
-			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+			bdi_dirty = bdi_stat(bdi, BDI_RECLAIMABLE) +
+				    bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh) {
+		if (bdi_dirty >= bdi_thresh) {
 			pause = HZ/10;
 			goto pause;
 		}
 
 		bw = 100 << 20; /* use static 100MB/s for the moment */
 
-		bw = bw * (bdi_thresh - (bdi_nr_reclaimable + bdi_nr_writeback));
+		bw = bw * (bdi_thresh - bdi_dirty);
 		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
 
 		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);
@@ -537,9 +536,8 @@ pause:
 		 * bdi or process from holding back light ones; The latter is
 		 * the last resort safeguard.
 		 */
-		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
-			|| (nr_reclaimable + nr_writeback > dirty_thresh);
+		dirty_exceeded = (bdi_dirty > bdi_thresh) ||
+				  (nr_dirty > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
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
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

