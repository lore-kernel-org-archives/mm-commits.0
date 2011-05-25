From: akpm@linux-foundation.org
Subject: [merged] readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:48 -0700
Message-ID: <201105252028.p4PKSB2T014721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932779Ab1EYUsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ak@linux.intel.com, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     readahead: trigger mmap sequential readahead on PG_readahead
has been removed from the -mm tree.  Its filename was
     readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: trigger mmap sequential readahead on PG_readahead
From: Wu Fengguang <fengguang.wu@intel.com>

Previously the mmap sequential readahead is triggered by updating
ra->prev_pos on each page fault and compare it with current page offset.

It costs dirtying the cache line on each _minor_ page fault.  So remove
the ra->prev_pos recording, and instead tag PG_readahead to trigger the
possible sequential readahead.  It's not only more simple, but also will
work more reliably and reduce cache line bouncing on concurrent page
faults on shared struct file.

In the mosbench exim benchmark which does multi-threaded page faults on
shared struct file, the ra->mmap_miss and ra->prev_pos updates are found
to cause excessive cache line bouncing on tmpfs, which actually disabled
readahead totally (shmem_backing_dev_info.ra_pages == 0).

So remove the ra->prev_pos recording, and instead tag PG_readahead to
trigger the possible sequential readahead.  It's not only more simple, but
also will work more reliably on concurrent reads on shared struct file.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Tim Chen <tim.c.chen@intel.com>
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~readahead-trigger-mmap-sequential-readahead-on-pg_readahead mm/filemap.c
--- a/mm/filemap.c~readahead-trigger-mmap-sequential-readahead-on-pg_readahead
+++ a/mm/filemap.c
@@ -1559,8 +1559,7 @@ static void do_sync_mmap_readahead(struc
 	if (!ra->ra_pages)
 		return;
 
-	if (VM_SequentialReadHint(vma) ||
-			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
+	if (VM_SequentialReadHint(vma)) {
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1583,7 +1582,7 @@ static void do_sync_mmap_readahead(struc
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	ra->start = max_t(long, 0, offset - ra_pages / 2);
 	ra->size = ra_pages;
-	ra->async_size = 0;
+	ra->async_size = ra_pages / 4;
 	ra_submit(ra, mapping, file);
 }
 
@@ -1689,7 +1688,6 @@ retry_find:
 		return VM_FAULT_SIGBUS;
 	}
 
-	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
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

