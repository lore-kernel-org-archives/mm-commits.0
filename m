From: akpm@linux-foundation.org
Subject: [merged] readahead-return-early-when-readahead-is-disabled.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:44 -0700
Message-ID: <201105252028.p4PKS7Ia014647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab1EYU2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     readahead: return early when readahead is disabled
has been removed from the -mm tree.  Its filename was
     readahead-return-early-when-readahead-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: return early when readahead is disabled
From: Wu Fengguang <fengguang.wu@intel.com>

Reduce readahead overheads by returning early in do_sync_mmap_readahead().

tmpfs has ra_pages=0 and it can page fault really fast (not constraint by
IO if not swapping).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Tim Chen <tim.c.chen@intel.com>
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/filemap.c~readahead-return-early-when-readahead-is-disabled mm/filemap.c
--- a/mm/filemap.c~readahead-return-early-when-readahead-is-disabled
+++ a/mm/filemap.c
@@ -1556,6 +1556,8 @@ static void do_sync_mmap_readahead(struc
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
 		return;
+	if (!ra->ra_pages)
+		return;
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
@@ -1578,12 +1580,10 @@ static void do_sync_mmap_readahead(struc
 	 * mmap read-around
 	 */
 	ra_pages = max_sane_readahead(ra->ra_pages);
-	if (ra_pages) {
-		ra->start = max_t(long, 0, offset - ra_pages/2);
-		ra->size = ra_pages;
-		ra->async_size = 0;
-		ra_submit(ra, mapping, file);
-	}
+	ra->start = max_t(long, 0, offset - ra_pages / 2);
+	ra->size = ra_pages;
+	ra->async_size = 0;
+	ra_submit(ra, mapping, file);
 }
 
 /*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-pass-writeback_control-down-to-move_expired_inodes.patch
writeback-introduce-writeback_controlinodes_cleaned.patch
writeback-try-more-writeback-as-long-as-something-was-written.patch
writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-refill-b_io-iff-empty.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
writeback-elevate-queue_io-into-wb_writeback.patch
writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch
writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch
writeback-avoid-extra-sync-work-at-enqueue-time.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch

