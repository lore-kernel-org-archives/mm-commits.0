From: akpm@linux-foundation.org
Subject: + fs-remove-wb_sync_hold.patch added to -mm tree
Date: Thu, 11 Dec 2008 13:07:27 -0800
Message-ID: <200812112107.mBBL7SeA018166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337AbYLKVHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 16:07:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: remove WB_SYNC_HOLD
has been added to the -mm tree.  Its filename is
     fs-remove-wb_sync_hold.patch

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

linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-direct-io-starvation-improvement.patch
fs-remove-wb_sync_hold.patch
fs-sync_sb_inodes-fix.patch
fs-sys_sync-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-fsync-livelock-avoidance.patch
reiser4.patch

