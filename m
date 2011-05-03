From: akpm@linux-foundation.org
Subject: + writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch added to -mm tree
Date: Tue, 03 May 2011 15:20:33 -0700
Message-ID: <201105032220.p43MKYwr013890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab1ECWVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 18:21:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz


The patch titled
     writeback: update dirtied_when for synced inode to prevent livelock
has been added to the -mm tree.  Its filename is
     writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch

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
Subject: writeback: update dirtied_when for synced inode to prevent livelock
From: Wu Fengguang <fengguang.wu@intel.com>

With the more aggressive "keep writeback as long as we wrote something"
logic in wb_writeback(), the "use LONG_MAX .nr_to_write" trick in commit
b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") is no
longer enough to stop sync livelock.

The fix is to explicitly update .dirtied_when on synced inodes, so that
they are no longer considered for writeback in the next round.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/fs-writeback.c~writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock
+++ a/fs/fs-writeback.c
@@ -431,6 +431,15 @@ writeback_single_inode(struct inode *ino
 				requeue_io(inode, wb);
 			} else {
 				/*
+				 * sync livelock prevention: each inode is
+				 * tagged and synced in one shot. If still
+				 * dirty, move it back to s_dirty with updated
+				 * dirty time to prevent syncing it again.
+				 */
+				if (wbc->sync_mode == WB_SYNC_ALL ||
+				    wbc->tagged_sync)
+					inode->dirtied_when = jiffies;
+				/*
 				 * Writeback blocked by something other than
 				 * congestion. Delay the inode for some time to
 				 * avoid spinning on the CPU (100% iowait)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
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
readahead-readahead-page-allocations-are-ok-to-fail.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

