From: akpm@linux-foundation.org
Subject: + writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch added to -mm tree
Date: Fri, 24 Sep 2010 12:44:44 -0700
Message-ID: <201009241944.o8OJiisv021466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757966Ab0IXTpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 15:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, jack@suse.cz, kernel@kolivas.org, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, neilb@suse.de, riel@redhat.com


The patch titled
     writeback: remove the internal 5% low bound on dirty_ratio
has been added to the -mm tree.  Its filename is
     writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch

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
Subject: writeback: remove the internal 5% low bound on dirty_ratio
From: Wu Fengguang <fengguang.wu@intel.com>

The dirty_ratio was silently limited in global_dirty_limits() to >= 5%. 
This is not a user expected behavior.  And it's inconsistent with
calc_period_shift(), which uses the plain vm_dirty_ratio value.

Let's remove the internal bound.

At the same time, fix balance_dirty_pages() to work with the
dirty_thresh=0 case.  This allows applications to proceed when
dirty+writeback pages are all cleaned.

And ">" fits with the name "exceeded" better than ">=" does.  Neil thinks
it is an aesthetic improvement as well as a functional one :)

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Proposed-by: Con Kolivas <kernel@kolivas.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Neil Brown <neilb@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c   |    2 +-
 mm/page-writeback.c |   16 +++++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -puN fs/fs-writeback.c~writeback-remove-the-internal-5%-low-bound-on-dirty_ratio fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-remove-the-internal-5%-low-bound-on-dirty_ratio
+++ a/fs/fs-writeback.c
@@ -593,7 +593,7 @@ static inline bool over_bground_thresh(v
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
 	return (global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
+		global_page_state(NR_UNSTABLE_NFS) > background_thresh);
 }
 
 /*
diff -puN mm/page-writeback.c~writeback-remove-the-internal-5%-low-bound-on-dirty_ratio mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-the-internal-5%-low-bound-on-dirty_ratio
+++ a/mm/page-writeback.c
@@ -415,14 +415,8 @@ void global_dirty_limits(unsigned long *
 
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
-	else {
-		int dirty_ratio;
-
-		dirty_ratio = vm_dirty_ratio;
-		if (dirty_ratio < 5)
-			dirty_ratio = 5;
-		dirty = (dirty_ratio * available_memory) / 100;
-	}
+	else
+		dirty = (vm_dirty_ratio * available_memory) / 100;
 
 	if (dirty_background_bytes)
 		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
@@ -510,7 +504,7 @@ static void balance_dirty_pages(struct a
 		 * catch-up. This avoids (excessively) small writeouts
 		 * when the bdi limits are ramping up.
 		 */
-		if (nr_reclaimable + nr_writeback <
+		if (nr_reclaimable + nr_writeback <=
 				(background_thresh + dirty_thresh) / 2)
 			break;
 
@@ -542,8 +536,8 @@ static void balance_dirty_pages(struct a
 		 * the last resort safeguard.
 		 */
 		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
-			|| (nr_reclaimable + nr_writeback >= dirty_thresh);
+			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
+			|| (nr_reclaimable + nr_writeback > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
fs-inodec-work-around-bug.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch
writeback-remove-nonblocking-encountered_congestion-references.patch
mm-compaction-fix-compactpagefailed-counting.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch

