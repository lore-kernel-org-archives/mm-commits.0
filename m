From: akpm@linux-foundation.org
Subject: - mm-per-device-dirty-threshold-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:40:35 -0700
Message-ID: <200710162140.l9GLeZs0018832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966032AbXJPVlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm per-device dirty threshold fix
has been removed from the -mm tree.  Its filename was
     mm-per-device-dirty-threshold-fix.patch

This patch was dropped because it was folded into mm-per-device-dirty-threshold.patch

------------------------------------------------------
Subject: mm per-device dirty threshold fix
From: Hugh Dickins <hugh@veritas.com>

Fix occasional hang when a task couldn't get out of balance_dirty_pages:
mm-per-device-dirty-threshold.patch needs to reevaluate bdi_nr_writeback
across all cpus when bdi_thresh is low, even in the case when there was no
bdi_nr_reclaimable.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   53 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff -puN mm/page-writeback.c~mm-per-device-dirty-threshold-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-per-device-dirty-threshold-fix
+++ a/mm/page-writeback.c
@@ -340,7 +340,7 @@ static void balance_dirty_pages(struct a
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-				break;
+			break;
 
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
@@ -353,39 +353,34 @@ static void balance_dirty_pages(struct a
 		 */
 		if (bdi_nr_reclaimable) {
 			writeback_inodes(&wbc);
-
+			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+		}
 
-			/*
-			 * In order to avoid the stacked BDI deadlock we need
-			 * to ensure we accurately count the 'dirty' pages when
-			 * the threshold is low.
-			 *
-			 * Otherwise it would be possible to get thresh+n pages
-			 * reported dirty, even though there are thresh-m pages
-			 * actually dirty; with m+n sitting in the percpu
-			 * deltas.
-			 */
-			if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-				bdi_nr_reclaimable =
-					bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-				bdi_nr_writeback =
-					bdi_stat_sum(bdi, BDI_WRITEBACK);
-			} else {
-				bdi_nr_reclaimable =
-					bdi_stat(bdi, BDI_RECLAIMABLE);
-				bdi_nr_writeback =
-					bdi_stat(bdi, BDI_WRITEBACK);
-			}
+		/*
+		 * In order to avoid the stacked BDI deadlock we need
+		 * to ensure we accurately count the 'dirty' pages when
+		 * the threshold is low.
+		 *
+		 * Otherwise it would be possible to get thresh+n pages
+		 * reported dirty, even though there are thresh-m pages
+		 * actually dirty; with m+n sitting in the percpu
+		 * deltas.
+		 */
+		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
+			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+		} else if (bdi_nr_reclaimable) {
+			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+		}
 
-			if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
-				break;
+		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+			break;
+		if (pages_written >= write_chunk)
+			break;		/* We've done our duty */
 
-			pages_written += write_chunk - wbc.nr_to_write;
-			if (pages_written >= write_chunk)
-				break;		/* We've done our duty */
-		}
 		congestion_wait(WRITE, HZ/10);
 	}
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
lib-percpu_counter_sub.patch
mm-per-device-dirty-threshold.patch
mm-per-device-dirty-threshold-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
prio_tree-debugging-patch.patch
