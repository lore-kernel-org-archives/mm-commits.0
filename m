From: akpm@linux-foundation.org
Subject: - fs-remove-wb_sync_hold.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:38 -0800
Message-ID: <200901072214.n07MEcPi014532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761043AbZAGWOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: remove WB_SYNC_HOLD
has been removed from the -mm tree.  Its filename was
     fs-remove-wb_sync_hold.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: remove WB_SYNC_HOLD
From: Nick Piggin <npiggin@suse.de>

Remove WB_SYNC_HOLD.  The primary motiviation is the design of my
anti-starvation code for fsync.  It requires taking an inode lock over the
sync operation, so we could run into lock ordering problems with multiple
inodes.  It is possible to take a single global lock to solve the ordering
problem, but then that would prevent a future nice implementation of "sync
multiple inodes" based on lock order via inode address.

Seems like a backward step to remove this, but actually it is busted
anyway: we can't use the inode lists for data integrity wait: an inode can
be taken off the dirty lists but still be under writeback.  In order to
satisfy data integrity semantics, we should wait for it to finish
writeback, but if we only search the dirty lists, we'll miss it.

It would be possible to have a "writeback" list, for sys_sync, I suppose. 
But why complicate things by prematurely optimise?  For unmounting, we
could avoid the "livelock avoidance" code, which would be easier, but
again premature IMO.

Fixing the existing data integrity problem will come next.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   12 ++----------
 include/linux/writeback.h |    1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

diff -puN fs/fs-writeback.c~fs-remove-wb_sync_hold fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-remove-wb_sync_hold
+++ a/fs/fs-writeback.c
@@ -421,9 +421,6 @@ __writeback_single_inode(struct inode *i
  * If we're a pdlfush thread, then implement pdflush collision avoidance
  * against the entire list.
  *
- * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
- * that it can be located for waiting on in __writeback_single_inode().
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -499,10 +496,6 @@ void generic_sync_sb_inodes(struct super
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		__writeback_single_inode(inode, wbc);
-		if (wbc->sync_mode == WB_SYNC_HOLD) {
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-		}
 		if (current_is_pdflush())
 			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -588,8 +581,7 @@ restart:
 
 /*
  * writeback and wait upon the filesystem's dirty inodes.  The caller will
- * do this in two passes - one to write, and one to wait.  WB_SYNC_HOLD is
- * used to park the written inodes on sb->s_dirty for the wait pass.
+ * do this in two passes - one to write, and one to wait.
  *
  * A finite limit is set on the number of pages which will be written.
  * To prevent infinite livelock of sys_sync().
@@ -600,7 +592,7 @@ restart:
 void sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
-		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
+		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 	};
diff -puN include/linux/writeback.h~fs-remove-wb_sync_hold include/linux/writeback.h
--- a/include/linux/writeback.h~fs-remove-wb_sync_hold
+++ a/include/linux/writeback.h
@@ -30,7 +30,6 @@ static inline int task_is_pdflush(struct
 enum writeback_sync_modes {
 	WB_SYNC_NONE,	/* Don't wait on anything */
 	WB_SYNC_ALL,	/* Wait on every mapping */
-	WB_SYNC_HOLD,	/* Hold the inode on sb_dirty for sys_sync() */
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

