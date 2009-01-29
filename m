From: akpm@linux-foundation.org
Subject: + nbd-add-locking-to-nbd_ioctl.patch added to -mm tree
Date: Wed, 28 Jan 2009 17:14:17 -0800
Message-ID: <200901290114.n0T1EHJY006589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZA2BO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 20:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, jens.axboe@oracle.com, paul.clements@steeleye.com


The patch titled
     nbd: add locking to nbd_ioctl
has been added to the -mm tree.  Its filename is
     nbd-add-locking-to-nbd_ioctl.patch

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
Subject: nbd: add locking to nbd_ioctl
From: Pavel Machek <pavel@suse.cz>

The code was written to rely on big kernel lock to protect it from races. 
It mostly works when interface is not abused.

So this uses tx_lock to protect data structures from concurrent use
between ioctl and worker threads.

Next step will be moving from ioctl to unlocked_ioctl.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |  203 ++++++++++++++++++++++++------------------
 1 file changed, 119 insertions(+), 84 deletions(-)

diff -puN drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl
+++ a/drivers/block/nbd.c
@@ -559,74 +559,68 @@ static void do_nbd_request(struct reques
 	}
 }
 
-static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
-		     unsigned int cmd, unsigned long arg)
-{
-	struct nbd_device *lo = bdev->bd_disk->private_data;
-	struct file *file;
-	int error;
-	struct request sreq ;
-	struct task_struct *thread;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	BUG_ON(lo->magic != LO_MAGIC);
-
-	/* Anyone capable of this syscall can do *real bad* things */
-	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
-			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
+/* Must be called with tx_lock held */
 
+static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
+		       unsigned int cmd, unsigned long arg)
+{
 	switch (cmd) {
 	case NBD_DISCONNECT:
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
-		blk_rq_init(NULL, &sreq);
-		sreq.cmd_type = REQ_TYPE_SPECIAL;
-		nbd_cmd(&sreq) = NBD_CMD_DISC;
-		/*
-		 * Set these to sane values in case server implementation
-		 * fails to check the request type first and also to keep
-		 * debugging output cleaner.
-		 */
-		sreq.sector = 0;
-		sreq.nr_sectors = 0;
-                if (!lo->sock)
-			return -EINVAL;
-		mutex_lock(&lo->tx_lock);
-                nbd_send_req(lo, &sreq);
-		mutex_unlock(&lo->tx_lock);
+		{
+			struct request sreq;
+
+			blk_rq_init(NULL, &sreq);
+			sreq.cmd_type = REQ_TYPE_SPECIAL;
+			nbd_cmd(&sreq) = NBD_CMD_DISC;
+			/*
+			 * Set these to sane values in case server implementation
+			 * fails to check the request type first and also to keep
+			 * debugging output cleaner.
+			 */
+			sreq.sector = 0;
+			sreq.nr_sectors = 0;
+			if (!lo->sock)
+				return -EINVAL;
+			nbd_send_req(lo, &sreq);
+		}
                 return 0;
  
 	case NBD_CLEAR_SOCK:
-		error = 0;
-		mutex_lock(&lo->tx_lock);
-		lo->sock = NULL;
-		mutex_unlock(&lo->tx_lock);
-		file = lo->file;
-		lo->file = NULL;
-		nbd_clear_que(lo);
-		BUG_ON(!list_empty(&lo->queue_head));
-		if (file)
-			fput(file);
-		return error;
-	case NBD_SET_SOCK:
-		if (lo->file)
-			return -EBUSY;
-		error = -EINVAL;
-		file = fget(arg);
-		if (file) {
-			struct inode *inode = file->f_path.dentry->d_inode;
-			if (S_ISSOCK(inode->i_mode)) {
-				lo->file = file;
-				lo->sock = SOCKET_I(inode);
-				if (max_part > 0)
-					bdev->bd_invalidated = 1;
-				error = 0;
-			} else {
+		{
+			struct file *file;
+
+			lo->sock = NULL;
+			file = lo->file;
+			lo->file = NULL;
+			nbd_clear_que(lo);
+			BUG_ON(!list_empty(&lo->queue_head));
+			if (file)
 				fput(file);
+		}
+	return 0;
+
+	case NBD_SET_SOCK:
+		{
+			struct file *file;
+			if (lo->file)
+				return -EBUSY;
+			file = fget(arg);
+			if (file) {
+				struct inode *inode = file->f_path.dentry->d_inode;
+				if (S_ISSOCK(inode->i_mode)) {
+					lo->file = file;
+					lo->sock = SOCKET_I(inode);
+					if (max_part > 0)
+						bdev->bd_invalidated = 1;
+					return 0;
+				} else {
+					fput(file);
+				}
 			}
 		}
-		return error;
+		return -EINVAL;
+
 	case NBD_SET_BLKSIZE:
 		lo->blksize = arg;
 		lo->bytesize &= ~(lo->blksize-1);
@@ -634,47 +628,65 @@ static int nbd_ioctl(struct block_device
 		set_blocksize(bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+
 	case NBD_SET_SIZE:
 		lo->bytesize = arg & ~(lo->blksize-1);
 		bdev->bd_inode->i_size = lo->bytesize;
 		set_blocksize(bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+
 	case NBD_SET_TIMEOUT:
 		lo->xmit_timeout = arg * HZ;
 		return 0;
+
 	case NBD_SET_SIZE_BLOCKS:
 		lo->bytesize = ((u64) arg) * lo->blksize;
 		bdev->bd_inode->i_size = lo->bytesize;
 		set_blocksize(bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+
 	case NBD_DO_IT:
-		if (lo->pid)
-			return -EBUSY;
-		if (!lo->file)
-			return -EINVAL;
-		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
-		if (IS_ERR(thread))
-			return PTR_ERR(thread);
-		wake_up_process(thread);
-		error = nbd_do_it(lo);
-		kthread_stop(thread);
-		if (error)
-			return error;
-		sock_shutdown(lo, 1);
-		file = lo->file;
-		lo->file = NULL;
-		nbd_clear_que(lo);
-		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
-		if (file)
-			fput(file);
-		lo->bytesize = 0;
-		bdev->bd_inode->i_size = 0;
-		set_capacity(lo->disk, 0);
-		if (max_part > 0)
-			ioctl_by_bdev(bdev, BLKRRPART, 0);
-		return lo->harderror;
+		{
+			struct task_struct *thread;
+			struct file *file;
+			int error;
+
+			if (lo->pid)
+				return -EBUSY;
+			if (!lo->file)
+				return -EINVAL;
+
+			mutex_unlock(&lo->tx_lock);
+
+			thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+			if (IS_ERR(thread)) {
+				mutex_lock(&lo->tx_lock);
+				return PTR_ERR(thread);
+			}
+			wake_up_process(thread);
+			error = nbd_do_it(lo);
+			kthread_stop(thread);
+
+			mutex_lock(&lo->tx_lock);
+			if (error)
+				return error;
+			sock_shutdown(lo, 0);
+			file = lo->file;
+			lo->file = NULL;
+			nbd_clear_que(lo);
+			printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+			if (file)
+				fput(file);
+			lo->bytesize = 0;
+			bdev->bd_inode->i_size = 0;
+			set_capacity(lo->disk, 0);
+			if (max_part > 0)
+				ioctl_by_bdev(bdev, BLKRRPART, 0);
+			return lo->harderror;
+		}
+
 	case NBD_CLEAR_QUE:
 		/*
 		 * This is for compatibility only.  The queue is always cleared
@@ -682,6 +694,7 @@ static int nbd_ioctl(struct block_device
 		 */
 		BUG_ON(!lo->sock && !list_empty(&lo->queue_head));
 		return 0;
+
 	case NBD_PRINT_DEBUG:
 		printk(KERN_INFO "%s: next = %p, prev = %p, head = %p\n",
 			bdev->bd_disk->disk_name,
@@ -689,7 +702,29 @@ static int nbd_ioctl(struct block_device
 			&lo->queue_head);
 		return 0;
 	}
-	return -EINVAL;
+}
+
+
+static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
+		     unsigned int cmd, unsigned long arg)
+{
+	struct nbd_device *lo = bdev->bd_disk->private_data;
+	int error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	BUG_ON(lo->magic != LO_MAGIC);
+
+	/* Anyone capable of this syscall can do *real bad* things */
+	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
+			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
+
+	mutex_lock(&lo->tx_lock);
+	error = __nbd_ioctl(bdev, lo, cmd, arg);
+	mutex_unlock(&lo->tx_lock);
+
+	return error;
 }
 
 static struct block_device_operations nbd_fops =
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
lis3lv02d-add-axes-knowledge-for-hp-6510b.patch
lis3lv02d-add-axes-knowledge-for-hp-6530.patch
lis3lv02d-add-axes-knowledge-for-hp-6730.patch
lis3lv02d-add-axes-knowledge-for-hp-6710.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
hp-accelerometer-add-freefall-detection.patch
nbd-add-locking-to-nbd_ioctl.patch
nbd-trivial-cleanups.patch

