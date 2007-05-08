From: akpm@linux-foundation.org
Subject: - mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:18 -0700
Message-ID: <200705080003.l4803IAR008936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967332AbXEHADj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: remove destroy_dirty_buffers from invalidate_bdev()
has been removed from the -mm tree.  Its filename was
     mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: remove destroy_dirty_buffers from invalidate_bdev()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Remove the destroy_dirty_buffers argument from invalidate_bdev(), it hasn't
been used in 6 years (so akpm says).

find * -name \*.[ch] | xargs grep -l invalidate_bdev |
while read file; do
	quilt add $file;
	sed -ie 's/invalidate_bdev(\([^,]*\),[^)]*)/invalidate_bdev(\1)/g' $file;
done

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioctl.c               |    4 ++--
 drivers/block/amiflop.c     |    2 +-
 drivers/block/loop.c        |    4 ++--
 drivers/block/rd.c          |    2 +-
 drivers/cdrom/cdrom.c       |    2 +-
 drivers/md/md.c             |    2 +-
 fs/block_dev.c              |    4 ++--
 fs/buffer.c                 |    7 +------
 fs/dquot.c                  |    4 ++--
 fs/ext3/super.c             |    4 ++--
 fs/ext4/super.c             |    4 ++--
 fs/partitions/acorn.c       |    2 +-
 include/linux/buffer_head.h |    4 ++--
 13 files changed, 20 insertions(+), 25 deletions(-)

diff -puN block/ioctl.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev block/ioctl.c
--- a/block/ioctl.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/block/ioctl.c
@@ -80,7 +80,7 @@ static int blkpg_ioctl(struct block_devi
 			}
 			/* all seems OK */
 			fsync_bdev(bdevp);
-			invalidate_bdev(bdevp, 0);
+			invalidate_bdev(bdevp);
 
 			mutex_lock_nested(&bdev->bd_mutex, 1);
 			delete_partition(disk, part);
@@ -236,7 +236,7 @@ int blkdev_ioctl(struct inode *inode, st
 
 		lock_kernel();
 		fsync_bdev(bdev);
-		invalidate_bdev(bdev, 0);
+		invalidate_bdev(bdev);
 		unlock_kernel();
 		return 0;
 
diff -puN drivers/block/amiflop.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev drivers/block/amiflop.c
--- a/drivers/block/amiflop.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/drivers/block/amiflop.c
@@ -1480,7 +1480,7 @@ static int fd_ioctl(struct inode *inode,
 		break;
 	case FDFMTEND:
 		floppy_off(drive);
-		invalidate_bdev(inode->i_bdev, 0);
+		invalidate_bdev(inode->i_bdev);
 		break;
 	case FDGETPRM:
 		memset((void *)&getprm, 0, sizeof (getprm));
diff -puN drivers/block/loop.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev drivers/block/loop.c
--- a/drivers/block/loop.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/drivers/block/loop.c
@@ -833,7 +833,7 @@ out_clr:
 	lo->lo_backing_file = NULL;
 	lo->lo_flags = 0;
 	set_capacity(disks[lo->lo_number], 0);
-	invalidate_bdev(bdev, 0);
+	invalidate_bdev(bdev);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
 	lo->lo_state = Lo_unbound;
@@ -917,7 +917,7 @@ static int loop_clr_fd(struct loop_devic
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	invalidate_bdev(bdev, 0);
+	invalidate_bdev(bdev);
 	set_capacity(disks[lo->lo_number], 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
diff -puN drivers/block/rd.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev drivers/block/rd.c
--- a/drivers/block/rd.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/drivers/block/rd.c
@@ -403,7 +403,7 @@ static void __exit rd_cleanup(void)
 		struct block_device *bdev = rd_bdev[i];
 		rd_bdev[i] = NULL;
 		if (bdev) {
-			invalidate_bdev(bdev, 1);
+			invalidate_bdev(bdev);
 			blkdev_put(bdev);
 		}
 		del_gendisk(rd_disks[i]);
diff -puN drivers/cdrom/cdrom.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/drivers/cdrom/cdrom.c
@@ -2384,7 +2384,7 @@ static int cdrom_ioctl_reset(struct cdro
 		return -EACCES;
 	if (!CDROM_CAN(CDC_RESET))
 		return -ENOSYS;
-	invalidate_bdev(bdev, 0);
+	invalidate_bdev(bdev);
 	return cdi->ops->reset(cdi);
 }
 
diff -puN drivers/md/md.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev drivers/md/md.c
--- a/drivers/md/md.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/drivers/md/md.c
@@ -3080,7 +3080,7 @@ static int do_md_run(mddev_t * mddev)
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
-		invalidate_bdev(rdev->bdev, 0);
+		invalidate_bdev(rdev->bdev);
 	}
 
 	md_probe(mddev->unit, NULL, NULL);
diff -puN fs/block_dev.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev fs/block_dev.c
--- a/fs/block_dev.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/fs/block_dev.c
@@ -58,7 +58,7 @@ static sector_t max_block(struct block_d
 /* Kill _all_ buffers, dirty or not.. */
 static void kill_bdev(struct block_device *bdev)
 {
-	invalidate_bdev(bdev, 1);
+	invalidate_bdev(bdev);
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
 }	
 
@@ -1478,7 +1478,7 @@ int __invalidate_device(struct block_dev
 		res = invalidate_inodes(sb);
 		drop_super(sb);
 	}
-	invalidate_bdev(bdev, 0);
+	invalidate_bdev(bdev);
 	return res;
 }
 EXPORT_SYMBOL(__invalidate_device);
diff -puN fs/buffer.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev fs/buffer.c
--- a/fs/buffer.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/fs/buffer.c
@@ -333,7 +333,7 @@ out:
    we think the disk contains more recent information than the buffercache.
    The update == 1 pass marks the buffers we need to update, the update == 2
    pass does the actual I/O. */
-void invalidate_bdev(struct block_device *bdev, int destroy_dirty_buffers)
+void invalidate_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
 
@@ -341,11 +341,6 @@ void invalidate_bdev(struct block_device
 		return;
 
 	invalidate_bh_lrus();
-	/*
-	 * FIXME: what about destroy_dirty_buffers?
-	 * We really want to use invalidate_inode_pages2() for
-	 * that, but not until that's cleaned up.
-	 */
 	invalidate_mapping_pages(mapping, 0, -1);
 }
 
diff -puN fs/dquot.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev fs/dquot.c
--- a/fs/dquot.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/fs/dquot.c
@@ -1432,7 +1432,7 @@ int vfs_quota_off(struct super_block *sb
 			mutex_unlock(&dqopt->dqonoff_mutex);
 		}
 	if (sb->s_bdev)
-		invalidate_bdev(sb->s_bdev, 0);
+		invalidate_bdev(sb->s_bdev);
 	return 0;
 }
 
@@ -1468,7 +1468,7 @@ static int vfs_quota_on_inode(struct ino
 	 * we see all the changes from userspace... */
 	write_inode_now(inode, 1);
 	/* And now flush the block cache so that kernel sees the changes */
-	invalidate_bdev(sb->s_bdev, 0);
+	invalidate_bdev(sb->s_bdev);
 	mutex_lock(&inode->i_mutex);
 	mutex_lock(&dqopt->dqonoff_mutex);
 	if (sb_has_quota_enabled(sb, type)) {
diff -puN fs/ext3/super.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev fs/ext3/super.c
--- a/fs/ext3/super.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/fs/ext3/super.c
@@ -420,7 +420,7 @@ static void ext3_put_super (struct super
 		dump_orphan_list(sb, sbi);
 	J_ASSERT(list_empty(&sbi->s_orphan));
 
-	invalidate_bdev(sb->s_bdev, 0);
+	invalidate_bdev(sb->s_bdev);
 	if (sbi->journal_bdev && sbi->journal_bdev != sb->s_bdev) {
 		/*
 		 * Invalidate the journal device's buffers.  We don't want them
@@ -428,7 +428,7 @@ static void ext3_put_super (struct super
 		 * hotswapped, and it breaks the `ro-after' testing code.
 		 */
 		sync_blockdev(sbi->journal_bdev);
-		invalidate_bdev(sbi->journal_bdev, 0);
+		invalidate_bdev(sbi->journal_bdev);
 		ext3_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
diff -puN fs/ext4/super.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev fs/ext4/super.c
--- a/fs/ext4/super.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/fs/ext4/super.c
@@ -470,7 +470,7 @@ static void ext4_put_super (struct super
 		dump_orphan_list(sb, sbi);
 	J_ASSERT(list_empty(&sbi->s_orphan));
 
-	invalidate_bdev(sb->s_bdev, 0);
+	invalidate_bdev(sb->s_bdev);
 	if (sbi->journal_bdev && sbi->journal_bdev != sb->s_bdev) {
 		/*
 		 * Invalidate the journal device's buffers.  We don't want them
@@ -478,7 +478,7 @@ static void ext4_put_super (struct super
 		 * hotswapped, and it breaks the `ro-after' testing code.
 		 */
 		sync_blockdev(sbi->journal_bdev);
-		invalidate_bdev(sbi->journal_bdev, 0);
+		invalidate_bdev(sbi->journal_bdev);
 		ext4_blkdev_remove(sbi);
 	}
 	sb->s_fs_info = NULL;
diff -puN fs/partitions/acorn.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev fs/partitions/acorn.c
--- a/fs/partitions/acorn.c~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/fs/partitions/acorn.c
@@ -271,7 +271,7 @@ adfspart_check_ADFS(struct parsed_partit
 		extern void xd_set_geometry(struct block_device *,
 			unsigned char, unsigned char, unsigned int);
 		xd_set_geometry(bdev, dr->secspertrack, heads, 1);
-		invalidate_bdev(bdev, 1);
+		invalidate_bdev(bdev);
 		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
 	}
 #endif
diff -puN include/linux/buffer_head.h~mm-remove-destroy_dirty_buffers-from-invalidate_bdev include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-remove-destroy_dirty_buffers-from-invalidate_bdev
+++ a/include/linux/buffer_head.h
@@ -165,7 +165,7 @@ int sync_mapping_buffers(struct address_
 void unmap_underlying_metadata(struct block_device *bdev, sector_t block);
 
 void mark_buffer_async_write(struct buffer_head *bh);
-void invalidate_bdev(struct block_device *, int);
+void invalidate_bdev(struct block_device *);
 int sync_blockdev(struct block_device *bdev);
 void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
@@ -319,7 +319,7 @@ static inline int inode_has_buffers(stru
 static inline void invalidate_inode_buffers(struct inode *inode) {}
 static inline int remove_inode_buffers(struct inode *inode) { return 1; }
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
-static inline void invalidate_bdev(struct block_device *bdev, int destroy_dirty_buffers) {}
+static inline void invalidate_bdev(struct block_device *bdev) {}
 
 
 #endif /* CONFIG_BLOCK */
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
exec-fix-remove_arg_zero.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
