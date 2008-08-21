From: akpm@linux-foundation.org
Subject: + filesystem-freezing-implement-generic-freeze-feature.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:20:21 -0700
Message-ID: <200808212020.m7LKKLQN024056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095AbYHUUUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t-sato@yk.jp.nec.com, dgc@sgi.com, hch@lst.de, lachlan@sgi.com, m-hamaguchi@ys.jp.nec.com, mtk.manpages@googlemail.com, tes@sgi.com, viro@zeniv.linux.org.uk


The patch titled
     filesystem freezing: implement generic freeze feature
has been added to the -mm tree.  Its filename is
     filesystem-freezing-implement-generic-freeze-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: filesystem freezing: implement generic freeze feature
From: Takashi Sato <t-sato@yk.jp.nec.com>

Currently, ext3 in mainline Linux doesn't have the freeze feature which
suspends write requests.  So, we cannot take a backup which keeps the
filesystem's consistency with the storage device's features (snapshot and
replication) while it is mounted.

In many case, a commercial filesystem (e.g.  VxFS) has the freeze feature
and it would be used to get the consistent backup.

If Linux's standard filesytem ext3 has the freeze feature, we can do it
without a commercial filesystem.

So I have implemented the ioctls of the freeze feature.
I think we can take the consistent backup with the following steps.
1. Freeze the filesystem with the freeze ioctl.
2. Separate the replication volume or create the snapshot
   with the storage device's feature.
3. Unfreeze the filesystem with the unfreeze ioctl.
4. Take the backup from the separated replication volume
   or the snapshot.



This patch:

The ioctls for the generic freeze feature are below.
o Freeze the filesystem
  int ioctl(int fd, int FIFREEZE, arg)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    arg: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1

o Unfreeze the filesystem
  int ioctl(int fd, int FITHAW, arg)
    fd: The file descriptor of the mountpoint
    FITHAW: request code for unfreeze
    arg: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
Cc: Dave Chinner <dgc@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c              |    2 +
 fs/buffer.c                 |   27 ++++++++++++++-
 fs/ioctl.c                  |   61 ++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 -
 include/linux/fs.h          |    6 +++
 5 files changed, 96 insertions(+), 2 deletions(-)

diff -puN fs/block_dev.c~filesystem-freezing-implement-generic-freeze-feature fs/block_dev.c
--- a/fs/block_dev.c~filesystem-freezing-implement-generic-freeze-feature
+++ a/fs/block_dev.c
@@ -285,6 +285,8 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	/* Initialize semaphore for freeze. */
+	sema_init(&bdev->bd_freeze_sem, 1);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -puN fs/buffer.c~filesystem-freezing-implement-generic-freeze-feature fs/buffer.c
--- a/fs/buffer.c~filesystem-freezing-implement-generic-freeze-feature
+++ a/fs/buffer.c
@@ -200,6 +200,15 @@ struct super_block *freeze_bdev(struct b
 {
 	struct super_block *sb;
 
+	down(&bdev->bd_freeze_sem);
+	bdev->bd_freeze_count++;
+	if (bdev->bd_freeze_count > 1) {
+		sb = get_super(bdev);
+		drop_super(sb);
+		up(&bdev->bd_freeze_sem);
+		return sb;
+	}
+
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
@@ -218,6 +227,8 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
+	up(&bdev->bd_freeze_sem);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -229,8 +240,20 @@ EXPORT_SYMBOL(freeze_bdev);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-void thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+
+	down(&bdev->bd_freeze_sem);
+	if (!bdev->bd_freeze_count) {
+		up(&bdev->bd_freeze_sem);
+		return 0;
+	}
+	bdev->bd_freeze_count--;
+	if (bdev->bd_freeze_count > 0) {
+		up(&bdev->bd_freeze_sem);
+		return 0;
+	}
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
@@ -243,6 +266,8 @@ void thaw_bdev(struct block_device *bdev
 	}
 
 	up(&bdev->bd_mount_sem);
+	up(&bdev->bd_freeze_sem);
+	return 0;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -puN fs/ioctl.c~filesystem-freezing-implement-generic-freeze-feature fs/ioctl.c
--- a/fs/ioctl.c~filesystem-freezing-implement-generic-freeze-feature
+++ a/fs/ioctl.c
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -141,6 +142,57 @@ static int ioctl_fioasync(unsigned int f
 }
 
 /*
+ * ioctl_freeze - Freeze the filesystem.
+ *
+ * @filp:	target file
+ *
+ * Call freeze_bdev() to freeze the filesystem.
+ */
+static int ioctl_freeze(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If filesystem doesn't support freeze feature, return. */
+	if (sb->s_op->write_super_lockfs == NULL)
+		return -EOPNOTSUPP;
+
+	/* If a regular file or a directory isn't specified, return. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Freeze */
+	sb = freeze_bdev(sb->s_bdev);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+	return 0;
+}
+
+/*
+ * ioctl_thaw - Thaw the filesystem.
+ *
+ * @filp:	target file
+ *
+ * Call thaw_bdev() to thaw the filesystem.
+ */
+static int ioctl_thaw(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a regular file or a directory isn't specified, return EINVAL. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Thaw */
+	return thaw_bdev(sb->s_bdev, sb);
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -181,6 +233,15 @@ int do_vfs_ioctl(struct file *filp, unsi
 		} else
 			error = -ENOTTY;
 		break;
+
+	case FIFREEZE:
+		error = ioctl_freeze(filp);
+		break;
+
+	case FITHAW:
+		error = ioctl_thaw(filp);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -puN include/linux/buffer_head.h~filesystem-freezing-implement-generic-freeze-feature include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freezing-implement-generic-freeze-feature
+++ a/include/linux/buffer_head.h
@@ -170,7 +170,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-void thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -puN include/linux/fs.h~filesystem-freezing-implement-generic-freeze-feature include/linux/fs.h
--- a/include/linux/fs.h~filesystem-freezing-implement-generic-freeze-feature
+++ a/include/linux/fs.h
@@ -229,6 +229,8 @@ extern int dir_notify_enable;
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -578,6 +580,10 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+	/* The counter of freeze processes */
+	int			bd_freeze_count;
+	/* Semaphore for freeze */
+	struct semaphore	bd_freeze_sem;
 };
 
 /*
_

Patches currently in -mm which might be from t-sato@yk.jp.nec.com are

filesystem-freezing-implement-generic-freeze-feature.patch
filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch
filesystem-freezing-add-timeout-feature.patch

