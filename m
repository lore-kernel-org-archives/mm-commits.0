From: akpm@linux-foundation.org
Subject: - fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:21 -0800
Message-ID: <200901050641.n056fLID005365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbZAEGlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/block_dev.c: __read_mostly improvement and sb_is_blkdev_sb utilization
has been removed from the -mm tree.  Its filename was
     fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/block_dev.c: __read_mostly improvement and sb_is_blkdev_sb utilization
From: Denis ChengRq <crquan@gmail.com>

- iget5_locked in bdget really needs blockdev_superblock, instead of
  bd_mnt, so bd_mnt could be just a local variable;

- blockdev_superblock really needs __read_mostly, while local var bd_mnt
  not;

- make use of sb_is_blkdev_sb in bd_forget, instead of direct reference
  to blockdev_superblock.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization
+++ a/fs/block_dev.c
@@ -326,12 +326,13 @@ static struct file_system_type bd_type =
 	.kill_sb	= kill_anon_super,
 };
 
-static struct vfsmount *bd_mnt __read_mostly;
-struct super_block *blockdev_superblock;
+struct super_block *blockdev_superblock __read_mostly;
 
 void __init bdev_cache_init(void)
 {
 	int err;
+	struct vfsmount *bd_mnt;
+
 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct bdev_inode),
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 				SLAB_MEM_SPREAD|SLAB_PANIC),
@@ -373,7 +374,7 @@ struct block_device *bdget(dev_t dev)
 	struct block_device *bdev;
 	struct inode *inode;
 
-	inode = iget5_locked(bd_mnt->mnt_sb, hash(dev),
+	inode = iget5_locked(blockdev_superblock, hash(dev),
 			bdev_test, bdev_set, &dev);
 
 	if (!inode)
@@ -463,7 +464,7 @@ void bd_forget(struct inode *inode)
 
 	spin_lock(&bdev_lock);
 	if (inode->i_bdev) {
-		if (inode->i_sb != blockdev_superblock)
+		if (!sb_is_blkdev_sb(inode->i_sb))
 			bdev = inode->i_bdev;
 		__bd_forget(inode);
 	}
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
linux-next.patch

