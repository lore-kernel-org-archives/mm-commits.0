From: akpm@linux-foundation.org
Subject: [merged] writeback-skip-new-or-to-be-freed-inodes.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:34 -0700
Message-ID: <200906171836.n5HIaYVR002656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758126AbZFQS4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, dedekind1@gmail.com, hch@infradead.org, jack@suse.cz, jlayton@redhat.com, m.mizuma@jp.fujitsu.com, sandeen@sandeen.net, viro@zeniv.linux.org.uk, mm-commits@vge


The patch titled
     writeback: skip new or to-be-freed inodes
has been removed from the -mm tree.  Its filename was
     writeback-skip-new-or-to-be-freed-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: skip new or to-be-freed inodes
From: Wu Fengguang <fengguang.wu@intel.com>

1) I_FREEING tests should be coupled with I_CLEAR

The two I_FREEING tests are racy because clear_inode() can set i_state to
I_CLEAR between the clear of I_SYNC and the test of I_FREEING.

2) skip I_WILL_FREE inodes in generic_sync_sb_inodes() to avoid possible
   races with generic_forget_inode()

generic_forget_inode() sets I_WILL_FREE call writeback on its own, so
generic_sync_sb_inodes() shall not try to step in and create possible races:

  generic_forget_inode
    inode->i_state |= I_WILL_FREE;
    spin_unlock(&inode_lock);
                                       generic_sync_sb_inodes()
                                         spin_lock(&inode_lock);
                                         __iget(inode);
                                         __writeback_single_inode
                                           // see non zero i_count
 may WARN here ==>                         WARN_ON(inode->i_state & I_WILL_FREE);
                                         spin_unlock(&inode_lock);
 may call generic_forget_inode again ==> iput(inode);

The above race and warning didn't turn up because writeback_inodes() holds
the s_umount lock, so generic_forget_inode() finds MS_ACTIVE and returns
early.  But we are not sure the UBIFS calls and future callers will
guarantee that.  So skip I_WILL_FREE inodes for the sake of safety.

Cc: Eric Sandeen <sandeen@sandeen.net>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~writeback-skip-new-or-to-be-freed-inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-skip-new-or-to-be-freed-inodes
+++ a/fs/fs-writeback.c
@@ -321,7 +321,7 @@ __sync_single_inode(struct inode *inode,
 
 	spin_lock(&inode_lock);
 	inode->i_state &= ~I_SYNC;
-	if (!(inode->i_state & I_FREEING)) {
+	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
 		if (!(inode->i_state & I_DIRTY) &&
 		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
@@ -492,7 +492,7 @@ void generic_sync_sb_inodes(struct super
 			break;
 		}
 
-		if (inode->i_state & I_NEW) {
+		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
 			requeue_io(inode);
 			continue;
 		}
@@ -523,7 +523,7 @@ void generic_sync_sb_inodes(struct super
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;
 
-		BUG_ON(inode->i_state & I_FREEING);
+		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		__writeback_single_inode(inode, wbc);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

