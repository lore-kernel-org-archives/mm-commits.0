From: akpm@linux-foundation.org
Subject: + filesystem-freezing-add-timeout-feature.patch added to -mm tree
Date: Thu, 21 Aug 2008 13:20:26 -0700
Message-ID: <200808212020.m7LKKQ19024064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbYHUUUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 16:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t-sato@yk.jp.nec.com, dgc@sgi.com, hch@lst.de, lachlan@sgi.com, m-hamaguchi@ys.jp.nec.com, mtk.manpages@googlemail.com, tes@sgi.com, viro@zeniv.linux.org.uk


The patch titled
     filesystem freezing: add timeout feature
has been added to the -mm tree.  Its filename is
     filesystem-freezing-add-timeout-feature.patch

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
Subject: filesystem freezing: add timeout feature
From: Takashi Sato <t-sato@yk.jp.nec.com>

The timeout feature is added to freeze ioctl.  And new ioctl
to reset the timeout period is added.
o Freeze the filesystem
  int ioctl(int fd, int FIFREEZE, long *timeout_sec)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    timeout_sec: the timeout period in seconds
             If it's 0 or 1, the timeout isn't set.
             This special case of "1" is implemented to keep
             the compatibility with XFS applications.
    Return value: 0 if the operation succeeds. Otherwise, -1

o Reset the timeout period
  int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeout_sec)
    fd:file descriptor of mountpoint
    FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
    timeout_sec: new timeout period in seconds
    Return value: 0 if the operation succeeds. Otherwise, -1
    Error number: If the filesystem has already been unfrozen,
                  errno is set to EINVAL.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
Cc: Dave Chinner <dgc@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm.c             |    2 
 fs/block_dev.c              |    2 
 fs/buffer.c                 |   16 +++++--
 fs/ioctl.c                  |   77 ++++++++++++++++++++++++++++++++--
 fs/super.c                  |   57 +++++++++++++++++++++++++
 fs/xfs/xfs_fsops.c          |    2 
 include/linux/buffer_head.h |    3 -
 include/linux/fs.h          |   10 ++++
 8 files changed, 160 insertions(+), 9 deletions(-)

diff -puN drivers/md/dm.c~filesystem-freezing-add-timeout-feature drivers/md/dm.c
--- a/drivers/md/dm.c~filesystem-freezing-add-timeout-feature
+++ a/drivers/md/dm.c
@@ -1451,7 +1451,7 @@ static int lock_fs(struct mapped_device 
 
 	WARN_ON(md->frozen_sb);
 
-	md->frozen_sb = freeze_bdev(md->suspended_bdev);
+	md->frozen_sb = freeze_bdev(md->suspended_bdev, 0);
 	if (IS_ERR(md->frozen_sb)) {
 		r = PTR_ERR(md->frozen_sb);
 		md->frozen_sb = NULL;
diff -puN fs/block_dev.c~filesystem-freezing-add-timeout-feature fs/block_dev.c
--- a/fs/block_dev.c~filesystem-freezing-add-timeout-feature
+++ a/fs/block_dev.c
@@ -287,6 +287,8 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize semaphore for freeze. */
 	sema_init(&bdev->bd_freeze_sem, 1);
+	/* Setup freeze timeout function. */
+	INIT_DELAYED_WORK(&bdev->bd_freeze_timeout, freeze_timeout);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -puN fs/buffer.c~filesystem-freezing-add-timeout-feature fs/buffer.c
--- a/fs/buffer.c~filesystem-freezing-add-timeout-feature
+++ a/fs/buffer.c
@@ -189,14 +189,18 @@ int fsync_bdev(struct block_device *bdev
 
 /**
  * freeze_bdev  --  lock a filesystem and force it into a consistent state
- * @bdev:	blockdevice to lock
+ * @bdev:              blockdevice to lock
+ * @timeout_msec:      timeout period
  *
  * This takes the block device bd_mount_sem to make sure no new mounts
  * happen on bdev until thaw_bdev() is called.
  * If a superblock is found on this device, we take the s_umount semaphore
  * on it to make sure nobody unmounts until the snapshot creation is done.
+ * If timeout_msec is bigger than 0, this registers the delayed work for
+ * timeout of the freeze feature.
  */
-struct super_block *freeze_bdev(struct block_device *bdev)
+struct super_block *freeze_bdev(struct block_device *bdev,
+				unsigned int timeout_msec)
 {
 	struct super_block *sb;
 
@@ -227,8 +231,11 @@ struct super_block *freeze_bdev(struct b
 	}
 
 	sync_blockdev(bdev);
-	up(&bdev->bd_freeze_sem);
+	/* Setup unfreeze timer. */
+	if (timeout_msec > 0)
+		add_freeze_timeout(bdev, timeout_msec);
 
+	up(&bdev->bd_freeze_sem);
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -254,6 +261,9 @@ int thaw_bdev(struct block_device *bdev,
 		return 0;
 	}
 
+	/* Delete unfreeze timer. */
+	del_freeze_timeout(bdev);
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
diff -puN fs/ioctl.c~filesystem-freezing-add-timeout-feature fs/ioctl.c
--- a/fs/ioctl.c~filesystem-freezing-add-timeout-feature
+++ a/fs/ioctl.c
@@ -145,12 +145,16 @@ static int ioctl_fioasync(unsigned int f
  * ioctl_freeze - Freeze the filesystem.
  *
  * @filp:	target file
+ * @argp:       timeout value(sec)
  *
  * Call freeze_bdev() to freeze the filesystem.
  */
-static int ioctl_freeze(struct file *filp)
+static int ioctl_freeze(struct file *filp, int __user *argp)
 {
+	int timeout_sec;
+	unsigned int timeout_msec;
 	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -163,8 +167,25 @@ static int ioctl_freeze(struct file *fil
 	if (sb->s_bdev == NULL)
 		return -EINVAL;
 
+	/* arg(sec) to tick value. */
+	error = get_user(timeout_sec, argp);
+	if (error != 0)
+		return error;
+
+	if (timeout_sec < 0 || timeout_sec > UINT_MAX/1000)
+		return -EINVAL;
+
+	/*
+	 * If 1 is specified as the timeout period it is changed into 0
+	 * to retain compatibility with XFS's xfs_freeze.
+	 */
+	if (timeout_sec == 1)
+		timeout_sec = 0;
+
+	timeout_msec = timeout_sec * 1000;
+
 	/* Freeze */
-	sb = freeze_bdev(sb->s_bdev);
+	sb = freeze_bdev(sb->s_bdev, timeout_msec);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 	return 0;
@@ -193,6 +214,52 @@ static int ioctl_thaw(struct file *filp)
 }
 
 /*
+ * ioctl_freeze_reset_timeout - Reset timeout for freeze.
+ *
+ * @filp:       target file
+ * @argp:       timeout value(sec)
+ *
+ * Reset timeout for freeze.
+ */
+static int
+ioctl_freeze_reset_timeout(struct file *filp, int __user *argp)
+{
+	int timeout_sec;
+	unsigned int timeout_msec;
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	struct block_device *bdev = sb->s_bdev;
+	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a regular file or a directory isn't specified, return EINVAL. */
+	if (bdev == NULL)
+		return -EINVAL;
+
+	/* arg(sec) to tick value */
+	error = get_user(timeout_sec, argp);
+	if (error)
+		return error;
+
+	if (timeout_sec <= 0 || timeout_sec > UINT_MAX/1000)
+		return -EINVAL;
+
+	timeout_msec = timeout_sec * 1000;
+
+	down(&bdev->bd_freeze_sem);
+	if (!bdev->bd_freeze_count) {
+		up(&bdev->bd_freeze_sem);
+		return -EINVAL;
+	}
+	/* setup unfreeze timer */
+	add_freeze_timeout(bdev, timeout_msec);
+	up(&bdev->bd_freeze_sem);
+
+	return 0;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -235,13 +302,17 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIFREEZE:
-		error = ioctl_freeze(filp);
+		error = ioctl_freeze(filp, argp);
 		break;
 
 	case FITHAW:
 		error = ioctl_thaw(filp);
 		break;
 
+	case FIFREEZE_RESET_TIMEOUT:
+		error = ioctl_freeze_reset_timeout(filp, argp);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -puN fs/super.c~filesystem-freezing-add-timeout-feature fs/super.c
--- a/fs/super.c~filesystem-freezing-add-timeout-feature
+++ a/fs/super.c
@@ -981,3 +981,60 @@ struct vfsmount *kern_mount_data(struct 
 }
 
 EXPORT_SYMBOL_GPL(kern_mount_data);
+
+/*
+ * freeze_timeout - Thaw the filesystem.
+ *
+ * @work:	work queue (delayed_work.work)
+ *
+ * Called by the delayed work when elapsing the timeout period.
+ * Thaw the filesystem.
+ */
+void freeze_timeout(struct work_struct *work)
+{
+	struct block_device *bd = container_of(work,
+			struct block_device, bd_freeze_timeout.work);
+	struct super_block *sb = get_super(bd);
+
+	thaw_bdev(bd, sb);
+
+	if (sb)
+		drop_super(sb);
+}
+EXPORT_SYMBOL_GPL(freeze_timeout);
+
+/*
+ * add_freeze_timeout - Add timeout for freeze.
+ *
+ * @bdev:		block device struct
+ * @timeout_msec:	timeout period
+ *
+ * Add the delayed work for freeze timeout to the delayed work queue.
+ */
+void add_freeze_timeout(struct block_device *bdev, unsigned int timeout_msec)
+{
+	s64 timeout_jiffies = msecs_to_jiffies(timeout_msec);
+
+	/* Set delayed work queue */
+	cancel_delayed_work_sync(&bdev->bd_freeze_timeout);
+	schedule_delayed_work(&bdev->bd_freeze_timeout, timeout_jiffies);
+}
+
+/*
+ * del_freeze_timeout - Delete timeout for freeze.
+ *
+ * @bdev:	block device struct
+ *
+ * Delete the delayed work for freeze timeout from the delayed work queue.
+ */
+void del_freeze_timeout(struct block_device *bdev)
+{
+	/*
+	 * It's possible that the delayed work task (freeze_timeout()) calls
+	 * del_freeze_timeout().  If the delayed work task calls
+	 * cancel_delayed_work_sync((), the deadlock will occur.
+	 * So we need this check (delayed_work_pending()).
+	 */
+	if (delayed_work_pending(&bdev->bd_freeze_timeout))
+		cancel_delayed_work_sync(&bdev->bd_freeze_timeout);
+}
diff -puN fs/xfs/xfs_fsops.c~filesystem-freezing-add-timeout-feature fs/xfs/xfs_fsops.c
--- a/fs/xfs/xfs_fsops.c~filesystem-freezing-add-timeout-feature
+++ a/fs/xfs/xfs_fsops.c
@@ -621,7 +621,7 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
+		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
 
 		if (sb && !IS_ERR(sb)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
diff -puN include/linux/buffer_head.h~filesystem-freezing-add-timeout-feature include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freezing-add-timeout-feature
+++ a/include/linux/buffer_head.h
@@ -169,7 +169,8 @@ int sync_blockdev(struct block_device *b
 void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
-struct super_block *freeze_bdev(struct block_device *);
+struct super_block *freeze_bdev(struct block_device *,
+				unsigned int timeout_msec);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
diff -puN include/linux/fs.h~filesystem-freezing-add-timeout-feature include/linux/fs.h
--- a/include/linux/fs.h~filesystem-freezing-add-timeout-feature
+++ a/include/linux/fs.h
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/workqueue.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -231,6 +232,7 @@ extern int dir_notify_enable;
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define	FIFREEZE_RESET_TIMEOUT	_IO(0x00, 3)	/* Reset freeze timeout */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -580,10 +582,13 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+
 	/* The counter of freeze processes */
 	int			bd_freeze_count;
 	/* Semaphore for freeze */
 	struct semaphore	bd_freeze_sem;
+	/* Delayed work for freeze */
+	struct delayed_work	bd_freeze_timeout;
 };
 
 /*
@@ -2213,5 +2218,10 @@ int proc_nr_files(struct ctl_table *tabl
 
 int get_filesystem_list(char * buf);
 
+extern void add_freeze_timeout(struct block_device *bdev,
+				unsigned int timeout_msec);
+extern void del_freeze_timeout(struct block_device *bdev);
+extern void freeze_timeout(struct work_struct *work);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
_

Patches currently in -mm which might be from t-sato@yk.jp.nec.com are

filesystem-freezing-implement-generic-freeze-feature.patch
filesystem-freezing-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch
filesystem-freezing-add-timeout-feature.patch

