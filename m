From: akpm@linux-foundation.org
Subject: [merged] nbd-add-locking-to-nbd_ioctl.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:33 -0700
Message-ID: <200904061936.n36JaXmR012496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757778AbZDFTjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, jens.axboe@oracle.com, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: add locking to nbd_ioctl
has been removed from the -mm tree.  Its filename was
     nbd-add-locking-to-nbd_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: add locking to nbd_ioctl
From: Pavel Machek <pavel@suse.cz>

The code was written to rely on big kernel lock to protect it from races. 
It mostly works when interface is not abused.

So this uses tx_lock to protect data structures from concurrent use
between ioctl and worker threads.

Next step will be moving from ioctl to unlocked_ioctl.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: add missing return]
Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |  102 +++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 35 deletions(-)

diff -puN drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl
+++ a/drivers/block/nbd.c
@@ -568,27 +568,17 @@ static void do_nbd_request(struct reques
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
-	case NBD_DISCONNECT:
+	case NBD_DISCONNECT: {
+		struct request sreq;
+
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
+
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
@@ -599,29 +589,29 @@ static int nbd_ioctl(struct block_device
 		 */
 		sreq.sector = 0;
 		sreq.nr_sectors = 0;
-                if (!lo->sock)
+		if (!lo->sock)
 			return -EINVAL;
-		mutex_lock(&lo->tx_lock);
-                nbd_send_req(lo, &sreq);
-		mutex_unlock(&lo->tx_lock);
+		nbd_send_req(lo, &sreq);
                 return 0;
+	}
  
-	case NBD_CLEAR_SOCK:
-		error = 0;
-		mutex_lock(&lo->tx_lock);
+	case NBD_CLEAR_SOCK: {
+		struct file *file;
+
 		lo->sock = NULL;
-		mutex_unlock(&lo->tx_lock);
 		file = lo->file;
 		lo->file = NULL;
 		nbd_clear_que(lo);
 		BUG_ON(!list_empty(&lo->queue_head));
 		if (file)
 			fput(file);
-		return error;
-	case NBD_SET_SOCK:
+		return 0;
+	}
+
+	case NBD_SET_SOCK: {
+		struct file *file;
 		if (lo->file)
 			return -EBUSY;
-		error = -EINVAL;
 		file = fget(arg);
 		if (file) {
 			struct inode *inode = file->f_path.dentry->d_inode;
@@ -630,12 +620,14 @@ static int nbd_ioctl(struct block_device
 				lo->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
-				error = 0;
+				return 0;
 			} else {
 				fput(file);
 			}
 		}
-		return error;
+		return -EINVAL;
+	}
+
 	case NBD_SET_BLKSIZE:
 		lo->blksize = arg;
 		lo->bytesize &= ~(lo->blksize-1);
@@ -643,35 +635,50 @@ static int nbd_ioctl(struct block_device
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
-	case NBD_DO_IT:
+
+	case NBD_DO_IT: {
+		struct task_struct *thread;
+		struct file *file;
+		int error;
+
 		if (lo->pid)
 			return -EBUSY;
 		if (!lo->file)
 			return -EINVAL;
+
+		mutex_unlock(&lo->tx_lock);
+
 		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
-		if (IS_ERR(thread))
+		if (IS_ERR(thread)) {
+			mutex_lock(&lo->tx_lock);
 			return PTR_ERR(thread);
+		}
 		wake_up_process(thread);
 		error = nbd_do_it(lo);
 		kthread_stop(thread);
+
+		mutex_lock(&lo->tx_lock);
 		if (error)
 			return error;
-		sock_shutdown(lo, 1);
+		sock_shutdown(lo, 0);
 		file = lo->file;
 		lo->file = NULL;
 		nbd_clear_que(lo);
@@ -684,6 +691,8 @@ static int nbd_ioctl(struct block_device
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
 		return lo->harderror;
+	}
+
 	case NBD_CLEAR_QUE:
 		/*
 		 * This is for compatibility only.  The queue is always cleared
@@ -691,6 +700,7 @@ static int nbd_ioctl(struct block_device
 		 */
 		BUG_ON(!lo->sock && !list_empty(&lo->queue_head));
 		return 0;
+
 	case NBD_PRINT_DEBUG:
 		printk(KERN_INFO "%s: next = %p, prev = %p, head = %p\n",
 			bdev->bd_disk->disk_name,
@@ -698,7 +708,29 @@ static int nbd_ioctl(struct block_device
 			&lo->queue_head);
 		return 0;
 	}
-	return -EINVAL;
+	return -ENOTTY;
+}
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

origin.patch
linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch

