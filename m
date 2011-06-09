From: akpm@linux-foundation.org
Subject: [merged] writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:41 -0700
Message-ID: <201106091904.p59J4ST7025475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab1FITFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     writeback: update dirtied_when for synced inode to prevent livelock
has been removed from the -mm tree.  Its filename was
     writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

