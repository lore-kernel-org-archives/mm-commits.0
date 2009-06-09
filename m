From: akpm@linux-foundation.org
Subject: [wrecked] ext2-add-blk_issue_flush-to-syncing-paths.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:10:17 -0700
Message-ID: <200906091810.n59IAHxp016820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbZFISKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext2: add blk_issue_flush() to syncing paths
has been removed from the -mm tree.  Its filename was
     ext2-add-blk_issue_flush-to-syncing-paths.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: add blk_issue_flush() to syncing paths
From: Jan Kara <jack@suse.cz>

To be really safe that the data hit the platter, we should also flush
drive's writeback caches on fsync and for O_SYNC files or O_DIRSYNC
inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c   |    5 ++++-
 fs/ext2/fsync.c |    7 +++++--
 fs/ext2/inode.c |    7 +++++++
 fs/ext2/xattr.c |    6 +++++-
 4 files changed, 21 insertions(+), 4 deletions(-)

diff -puN fs/ext2/dir.c~ext2-add-blk_issue_flush-to-syncing-paths fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-add-blk_issue_flush-to-syncing-paths
+++ a/fs/ext2/dir.c
@@ -25,6 +25,7 @@
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
@@ -97,8 +98,10 @@ static int ext2_commit_chunk(struct page
 
 	if (IS_DIRSYNC(dir)) {
 		err = write_one_page(page, 1);
-		if (!err)
+		if (!err) {
 			err = ext2_sync_inode(dir);
+			blkdev_issue_flush(dir->i_sb->s_bdev, NULL);
+		}
 	} else {
 		unlock_page(page);
 	}
diff -puN fs/ext2/fsync.c~ext2-add-blk_issue_flush-to-syncing-paths fs/ext2/fsync.c
--- a/fs/ext2/fsync.c~ext2-add-blk_issue_flush-to-syncing-paths
+++ a/fs/ext2/fsync.c
@@ -24,6 +24,7 @@
 
 #include "ext2.h"
 #include <linux/buffer_head.h>		/* for sync_mapping_buffers() */
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 
 
 /*
@@ -39,12 +40,14 @@ int ext2_sync_file(struct file *file, st
 
 	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode->i_state & I_DIRTY))
-		return ret;
+		goto out;
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return ret;
+		goto out;
 
 	err = ext2_sync_inode(inode);
 	if (ret == 0)
 		ret = err;
+out:
+	blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
 }
diff -puN fs/ext2/inode.c~ext2-add-blk_issue_flush-to-syncing-paths fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-add-blk_issue_flush-to-syncing-paths
+++ a/fs/ext2/inode.c
@@ -33,6 +33,7 @@
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/blkdev.h>	/* for blkdev_issue_flush() */
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
@@ -68,9 +69,14 @@ void ext2_delete_inode (struct inode * i
 	mark_inode_dirty(inode);
 	ext2_update_inode(inode, inode_needs_sync(inode));
 
+	/* Make sure inode deletion really gets to disk. Disk write caches
+	 * are flushed either in ext2_truncate() or we do it explicitly */
 	inode->i_size = 0;
 	if (inode->i_blocks)
 		ext2_truncate (inode);
+	else if (inode_needs_sync(inode))
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+
 	ext2_free_inode (inode);
 
 	return;
@@ -1126,6 +1132,7 @@ do_indirects:
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		ext2_sync_inode (inode);
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	} else {
 		mark_inode_dirty(inode);
 	}
diff -puN fs/ext2/xattr.c~ext2-add-blk_issue_flush-to-syncing-paths fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~ext2-add-blk_issue_flush-to-syncing-paths
+++ a/fs/ext2/xattr.c
@@ -60,6 +60,7 @@
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
 #include <linux/rwsem.h>
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -702,6 +703,7 @@ ext2_xattr_set2(struct inode *inode, str
 				vfs_dq_free_block(inode, 1);
 			goto cleanup;
 		}
+		blkdev_issue_flush(sb->s_bdev, NULL);
 	} else
 		mark_inode_dirty(inode);
 
@@ -792,8 +794,10 @@ ext2_xattr_delete_inode(struct inode *in
 			le32_to_cpu(HDR(bh)->h_refcount));
 		unlock_buffer(bh);
 		mark_buffer_dirty(bh);
-		if (IS_SYNC(inode))
+		if (IS_SYNC(inode)) {
 			sync_dirty_buffer(bh);
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		}
 		vfs_dq_free_block(inode, 1);
 	}
 	EXT2_I(inode)->i_file_acl = 0;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
jbd-fix-race-in-buffer-processing-in-commit-code.patch
linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
mm-remove-__invalidate_mapping_pages-variant.patch
ext2-do-not-update-mtime-of-a-moved-directory.patch
ext3-fix-chain-verification-in-ext3_get_blocks.patch
isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting.patch
isofs-fix-setting-of-uid-and-gid-to-0.patch
isofs-cleanup-mount-option-processing.patch
reiser4-update-names-of-quota-methods.patch

