From: akpm@linux-foundation.org
Subject: + nbd-allow-hung-network-i-o-to-be-cancelled.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:59:29 -0700
Message-ID: <200708242359.l7ONxTiK021347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756172AbXHYAAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 20:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.clements@steeleye.com


The patch titled
     NBD: allow hung network I/O to be cancelled
has been added to the -mm tree.  Its filename is
     nbd-allow-hung-network-i-o-to-be-cancelled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NBD: allow hung network I/O to be cancelled
From: Paul Clements <paul.clements@steeleye.com>

Allow NBD I/O to be cancelled when a network outage occurs.  Previously, I/O
would just hang, and if enough I/O was hung in nbd, the system (at least
user-level) would completely hang until a TCP timeout (default, 15 minutes)
occurred.

The patch introduces a new ioctl NBD_SET_TIMEOUT that allows a transmit
timeout value (in seconds) to be specified.  Any network send that exceeds the
timeout will be cancelled and the nbd connection will be shut down.  I've
tested with various timeout values and 6 seconds seems to be a good choice for
the timeout.  If the NBD_SET_TIMEOUT ioctl is not called, you get the old (I/O
hang) behavior.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   93 ++++++++++++++++++++++++++++--------------
 include/linux/nbd.h |    2 
 2 files changed, 64 insertions(+), 31 deletions(-)

diff -puN drivers/block/nbd.c~nbd-allow-hung-network-i-o-to-be-cancelled drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-allow-hung-network-i-o-to-be-cancelled
+++ a/drivers/block/nbd.c
@@ -113,12 +113,42 @@ static void nbd_end_request(struct reque
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+static void sock_shutdown(struct nbd_device *lo, int lock)
+{
+	/* Forcibly shutdown the socket causing all listeners
+	 * to error
+	 *
+	 * FIXME: This code is duplicated from sys_shutdown, but
+	 * there should be a more generic interface rather than
+	 * calling socket ops directly here */
+	if (lock)
+		mutex_lock(&lo->tx_lock);
+	if (lo->sock) {
+		printk(KERN_WARNING "%s: shutting down socket\n",
+			lo->disk->disk_name);
+		lo->sock->ops->shutdown(lo->sock, SEND_SHUTDOWN|RCV_SHUTDOWN);
+		lo->sock = NULL;
+	}
+	if (lock)
+		mutex_unlock(&lo->tx_lock);
+}
+
+static void nbd_xmit_timeout(unsigned long arg)
+{
+	struct task_struct *task = (struct task_struct *)arg;
+
+	printk(KERN_WARNING "nbd: killing hung xmit (%s, pid: %d)\n",
+		task->comm, task->pid);
+	force_sig(SIGKILL, task);
+}
+
 /*
  *  Send or receive packet.
  */
-static int sock_xmit(struct socket *sock, int send, void *buf, int size,
+static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
 		int msg_flags)
 {
+	struct socket *sock = lo->sock;
 	int result;
 	struct msghdr msg;
 	struct kvec iov;
@@ -139,9 +169,20 @@ static int sock_xmit(struct socket *sock
 		msg.msg_controllen = 0;
 		msg.msg_flags = msg_flags | MSG_NOSIGNAL;
 
-		if (send)
+		if (send) {
+			struct timer_list ti;
+
+			if (lo->xmit_timeout) {
+				init_timer(&ti);
+				ti.function = nbd_xmit_timeout;
+				ti.data = (unsigned long)current;
+				ti.expires = jiffies + lo->xmit_timeout;
+				add_timer(&ti);
+			}
 			result = kernel_sendmsg(sock, &msg, &iov, 1, size);
-		else
+			if (lo->xmit_timeout)
+				del_timer_sync(&ti);
+		} else
 			result = kernel_recvmsg(sock, &msg, &iov, 1, size, 0);
 
 		if (signal_pending(current)) {
@@ -150,6 +191,7 @@ static int sock_xmit(struct socket *sock
 				current->pid, current->comm,
 				dequeue_signal_lock(current, &current->blocked, &info));
 			result = -EINTR;
+			sock_shutdown(lo, !send);
 			break;
 		}
 
@@ -167,23 +209,22 @@ static int sock_xmit(struct socket *sock
 	return result;
 }
 
-static inline int sock_send_bvec(struct socket *sock, struct bio_vec *bvec,
+static inline int sock_send_bvec(struct nbd_device *lo, struct bio_vec *bvec,
 		int flags)
 {
 	int result;
 	void *kaddr = kmap(bvec->bv_page);
-	result = sock_xmit(sock, 1, kaddr + bvec->bv_offset, bvec->bv_len,
-			flags);
+	result = sock_xmit(lo, 1, kaddr + bvec->bv_offset, bvec->bv_len, flags);
 	kunmap(bvec->bv_page);
 	return result;
 }
 
+/* always call with the tx_lock held */
 static int nbd_send_req(struct nbd_device *lo, struct request *req)
 {
 	int result, i, flags;
 	struct nbd_request request;
 	unsigned long size = req->nr_sectors << 9;
-	struct socket *sock = lo->sock;
 
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
@@ -196,8 +237,8 @@ static int nbd_send_req(struct nbd_devic
 			nbdcmd_to_ascii(nbd_cmd(req)),
 			(unsigned long long)req->sector << 9,
 			req->nr_sectors << 9);
-	result = sock_xmit(sock, 1, &request, sizeof(request),
-			(nbd_cmd(req) == NBD_CMD_WRITE)? MSG_MORE: 0);
+	result = sock_xmit(lo, 1, &request, sizeof(request),
+			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
 		printk(KERN_ERR "%s: Send control failed (result %d)\n",
 				lo->disk->disk_name, result);
@@ -219,7 +260,7 @@ static int nbd_send_req(struct nbd_devic
 				dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
 						lo->disk->disk_name, req,
 						bvec->bv_len);
-				result = sock_send_bvec(sock, bvec, flags);
+				result = sock_send_bvec(lo, bvec, flags);
 				if (result <= 0) {
 					printk(KERN_ERR "%s: Send data failed (result %d)\n",
 							lo->disk->disk_name,
@@ -261,11 +302,11 @@ out:
 	return ERR_PTR(err);
 }
 
-static inline int sock_recv_bvec(struct socket *sock, struct bio_vec *bvec)
+static inline int sock_recv_bvec(struct nbd_device *lo, struct bio_vec *bvec)
 {
 	int result;
 	void *kaddr = kmap(bvec->bv_page);
-	result = sock_xmit(sock, 0, kaddr + bvec->bv_offset, bvec->bv_len,
+	result = sock_xmit(lo, 0, kaddr + bvec->bv_offset, bvec->bv_len,
 			MSG_WAITALL);
 	kunmap(bvec->bv_page);
 	return result;
@@ -277,10 +318,9 @@ static struct request *nbd_read_stat(str
 	int result;
 	struct nbd_reply reply;
 	struct request *req;
-	struct socket *sock = lo->sock;
 
 	reply.magic = 0;
-	result = sock_xmit(sock, 0, &reply, sizeof(reply), MSG_WAITALL);
+	result = sock_xmit(lo, 0, &reply, sizeof(reply), MSG_WAITALL);
 	if (result <= 0) {
 		printk(KERN_ERR "%s: Receive control failed (result %d)\n",
 				lo->disk->disk_name, result);
@@ -322,7 +362,7 @@ static struct request *nbd_read_stat(str
 		rq_for_each_bio(bio, req) {
 			struct bio_vec *bvec;
 			bio_for_each_segment(bvec, bio, i) {
-				result = sock_recv_bvec(sock, bvec);
+				result = sock_recv_bvec(lo, bvec);
 				if (result <= 0) {
 					printk(KERN_ERR "%s: Receive data failed (result %d)\n",
 							lo->disk->disk_name,
@@ -399,6 +439,7 @@ static void nbd_clear_que(struct nbd_dev
 	}
 }
 
+
 /*
  * We always wait for result of write, for now. It would be nice to make it optional
  * in future
@@ -507,7 +548,9 @@ static int nbd_ioctl(struct inode *inode
 		sreq.nr_sectors = 0;
                 if (!lo->sock)
 			return -EINVAL;
+		mutex_lock(&lo->tx_lock);
                 nbd_send_req(lo, &sreq);
+		mutex_unlock(&lo->tx_lock);
                 return 0;
  
 	case NBD_CLEAR_SOCK:
@@ -551,6 +594,9 @@ static int nbd_ioctl(struct inode *inode
 		set_blocksize(inode->i_bdev, lo->blksize);
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
+	case NBD_SET_TIMEOUT:
+		lo->xmit_timeout = arg * HZ;
+		return 0;
 	case NBD_SET_SIZE_BLOCKS:
 		lo->bytesize = ((u64) arg) * lo->blksize;
 		inode->i_bdev->bd_inode->i_size = lo->bytesize;
@@ -563,22 +609,7 @@ static int nbd_ioctl(struct inode *inode
 		error = nbd_do_it(lo);
 		if (error)
 			return error;
-		/* on return tidy up in case we have a signal */
-		/* Forcibly shutdown the socket causing all listeners
-		 * to error
-		 *
-		 * FIXME: This code is duplicated from sys_shutdown, but
-		 * there should be a more generic interface rather than
-		 * calling socket ops directly here */
-		mutex_lock(&lo->tx_lock);
-		if (lo->sock) {
-			printk(KERN_WARNING "%s: shutting down socket\n",
-				lo->disk->disk_name);
-			lo->sock->ops->shutdown(lo->sock,
-				SEND_SHUTDOWN|RCV_SHUTDOWN);
-			lo->sock = NULL;
-		}
-		mutex_unlock(&lo->tx_lock);
+		sock_shutdown(lo, 1);
 		file = lo->file;
 		lo->file = NULL;
 		nbd_clear_que(lo);
diff -puN include/linux/nbd.h~nbd-allow-hung-network-i-o-to-be-cancelled include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-allow-hung-network-i-o-to-be-cancelled
+++ a/include/linux/nbd.h
@@ -26,6 +26,7 @@
 #define NBD_PRINT_DEBUG	_IO( 0xab, 6 )
 #define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
 #define NBD_DISCONNECT  _IO( 0xab, 8 )
+#define NBD_SET_TIMEOUT _IO( 0xab, 9 )
 
 enum {
 	NBD_CMD_READ = 0,
@@ -65,6 +66,7 @@ struct nbd_device {
 	int blksize;
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
+	int xmit_timeout;
 };
 
 #endif
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch
nbd-set-uninitialized-devices-to-size-0.patch
nbd-allow-hung-network-i-o-to-be-cancelled.patch
