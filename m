From: akpm@linux-foundation.org
Subject: [merged] nbd-rename-the-nbd_device-variable-from-lo-to-nbd.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:09 -0700
Message-ID: <20120329191409.5C1C3A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41279 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739Ab2C2TON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:13 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so21845wib.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaowanlong@cn.fujitsu.com, axboe@kernel.dk, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: rename the nbd_device variable from lo to nbd
has been removed from the -mm tree.  Its filename was
     nbd-rename-the-nbd_device-variable-from-lo-to-nbd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: nbd: rename the nbd_device variable from lo to nbd

rename the nbd_device variable from "lo" to "nbd", since "lo" is just a name
copied from loop.c.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |  295 +++++++++++++++++++++---------------------
 1 file changed, 148 insertions(+), 147 deletions(-)

diff -puN drivers/block/nbd.c~nbd-rename-the-nbd_device-variable-from-lo-to-nbd drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-rename-the-nbd_device-variable-from-lo-to-nbd
+++ a/drivers/block/nbd.c
@@ -39,7 +39,7 @@
 
 #include <linux/nbd.h>
 
-#define LO_MAGIC 0x68797548
+#define NBD_MAGIC 0x68797548
 
 #ifdef NDEBUG
 #define dprintk(flags, fmt...)
@@ -116,7 +116,7 @@ static void nbd_end_request(struct reque
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void sock_shutdown(struct nbd_device *lo, int lock)
+static void sock_shutdown(struct nbd_device *nbd, int lock)
 {
 	/* Forcibly shutdown the socket causing all listeners
 	 * to error
@@ -125,14 +125,14 @@ static void sock_shutdown(struct nbd_dev
 	 * there should be a more generic interface rather than
 	 * calling socket ops directly here */
 	if (lock)
-		mutex_lock(&lo->tx_lock);
-	if (lo->sock) {
-		dev_warn(disk_to_dev(lo->disk), "shutting down socket\n");
-		kernel_sock_shutdown(lo->sock, SHUT_RDWR);
-		lo->sock = NULL;
+		mutex_lock(&nbd->tx_lock);
+	if (nbd->sock) {
+		dev_warn(disk_to_dev(nbd->disk), "shutting down socket\n");
+		kernel_sock_shutdown(nbd->sock, SHUT_RDWR);
+		nbd->sock = NULL;
 	}
 	if (lock)
-		mutex_unlock(&lo->tx_lock);
+		mutex_unlock(&nbd->tx_lock);
 }
 
 static void nbd_xmit_timeout(unsigned long arg)
@@ -147,17 +147,17 @@ static void nbd_xmit_timeout(unsigned lo
 /*
  *  Send or receive packet.
  */
-static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
+static int sock_xmit(struct nbd_device *nbd, int send, void *buf, int size,
 		int msg_flags)
 {
-	struct socket *sock = lo->sock;
+	struct socket *sock = nbd->sock;
 	int result;
 	struct msghdr msg;
 	struct kvec iov;
 	sigset_t blocked, oldset;
 
 	if (unlikely(!sock)) {
-		dev_err(disk_to_dev(lo->disk),
+		dev_err(disk_to_dev(nbd->disk),
 			"Attempted %s on closed socket in sock_xmit\n",
 			(send ? "send" : "recv"));
 		return -EINVAL;
@@ -181,15 +181,15 @@ static int sock_xmit(struct nbd_device *
 		if (send) {
 			struct timer_list ti;
 
-			if (lo->xmit_timeout) {
+			if (nbd->xmit_timeout) {
 				init_timer(&ti);
 				ti.function = nbd_xmit_timeout;
 				ti.data = (unsigned long)current;
-				ti.expires = jiffies + lo->xmit_timeout;
+				ti.expires = jiffies + nbd->xmit_timeout;
 				add_timer(&ti);
 			}
 			result = kernel_sendmsg(sock, &msg, &iov, 1, size);
-			if (lo->xmit_timeout)
+			if (nbd->xmit_timeout)
 				del_timer_sync(&ti);
 		} else
 			result = kernel_recvmsg(sock, &msg, &iov, 1, size,
@@ -201,7 +201,7 @@ static int sock_xmit(struct nbd_device *
 				task_pid_nr(current), current->comm,
 				dequeue_signal_lock(current, &current->blocked, &info));
 			result = -EINTR;
-			sock_shutdown(lo, !send);
+			sock_shutdown(nbd, !send);
 			break;
 		}
 
@@ -219,18 +219,19 @@ static int sock_xmit(struct nbd_device *
 	return result;
 }
 
-static inline int sock_send_bvec(struct nbd_device *lo, struct bio_vec *bvec,
+static inline int sock_send_bvec(struct nbd_device *nbd, struct bio_vec *bvec,
 		int flags)
 {
 	int result;
 	void *kaddr = kmap(bvec->bv_page);
-	result = sock_xmit(lo, 1, kaddr + bvec->bv_offset, bvec->bv_len, flags);
+	result = sock_xmit(nbd, 1, kaddr + bvec->bv_offset,
+			   bvec->bv_len, flags);
 	kunmap(bvec->bv_page);
 	return result;
 }
 
 /* always call with the tx_lock held */
-static int nbd_send_req(struct nbd_device *lo, struct request *req)
+static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 {
 	int result, flags;
 	struct nbd_request request;
@@ -243,14 +244,14 @@ static int nbd_send_req(struct nbd_devic
 	memcpy(request.handle, &req, sizeof(req));
 
 	dprintk(DBG_TX, "%s: request %p: sending control (%s@%llu,%uB)\n",
-			lo->disk->disk_name, req,
+			nbd->disk->disk_name, req,
 			nbdcmd_to_ascii(nbd_cmd(req)),
 			(unsigned long long)blk_rq_pos(req) << 9,
 			blk_rq_bytes(req));
-	result = sock_xmit(lo, 1, &request, sizeof(request),
+	result = sock_xmit(nbd, 1, &request, sizeof(request),
 			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
-		dev_err(disk_to_dev(lo->disk),
+		dev_err(disk_to_dev(nbd->disk),
 			"Send control failed (result %d)\n", result);
 		goto error_out;
 	}
@@ -267,10 +268,10 @@ static int nbd_send_req(struct nbd_devic
 			if (!rq_iter_last(req, iter))
 				flags = MSG_MORE;
 			dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
-					lo->disk->disk_name, req, bvec->bv_len);
-			result = sock_send_bvec(lo, bvec, flags);
+					nbd->disk->disk_name, req, bvec->bv_len);
+			result = sock_send_bvec(nbd, bvec, flags);
 			if (result <= 0) {
-				dev_err(disk_to_dev(lo->disk),
+				dev_err(disk_to_dev(nbd->disk),
 					"Send data failed (result %d)\n",
 					result);
 				goto error_out;
@@ -283,25 +284,25 @@ error_out:
 	return -EIO;
 }
 
-static struct request *nbd_find_request(struct nbd_device *lo,
+static struct request *nbd_find_request(struct nbd_device *nbd,
 					struct request *xreq)
 {
 	struct request *req, *tmp;
 	int err;
 
-	err = wait_event_interruptible(lo->active_wq, lo->active_req != xreq);
+	err = wait_event_interruptible(nbd->active_wq, nbd->active_req != xreq);
 	if (unlikely(err))
 		goto out;
 
-	spin_lock(&lo->queue_lock);
-	list_for_each_entry_safe(req, tmp, &lo->queue_head, queuelist) {
+	spin_lock(&nbd->queue_lock);
+	list_for_each_entry_safe(req, tmp, &nbd->queue_head, queuelist) {
 		if (req != xreq)
 			continue;
 		list_del_init(&req->queuelist);
-		spin_unlock(&lo->queue_lock);
+		spin_unlock(&nbd->queue_lock);
 		return req;
 	}
-	spin_unlock(&lo->queue_lock);
+	spin_unlock(&nbd->queue_lock);
 
 	err = -ENOENT;
 
@@ -309,78 +310,78 @@ out:
 	return ERR_PTR(err);
 }
 
-static inline int sock_recv_bvec(struct nbd_device *lo, struct bio_vec *bvec)
+static inline int sock_recv_bvec(struct nbd_device *nbd, struct bio_vec *bvec)
 {
 	int result;
 	void *kaddr = kmap(bvec->bv_page);
-	result = sock_xmit(lo, 0, kaddr + bvec->bv_offset, bvec->bv_len,
+	result = sock_xmit(nbd, 0, kaddr + bvec->bv_offset, bvec->bv_len,
 			MSG_WAITALL);
 	kunmap(bvec->bv_page);
 	return result;
 }
 
 /* NULL returned = something went wrong, inform userspace */
-static struct request *nbd_read_stat(struct nbd_device *lo)
+static struct request *nbd_read_stat(struct nbd_device *nbd)
 {
 	int result;
 	struct nbd_reply reply;
 	struct request *req;
 
 	reply.magic = 0;
-	result = sock_xmit(lo, 0, &reply, sizeof(reply), MSG_WAITALL);
+	result = sock_xmit(nbd, 0, &reply, sizeof(reply), MSG_WAITALL);
 	if (result <= 0) {
-		dev_err(disk_to_dev(lo->disk),
+		dev_err(disk_to_dev(nbd->disk),
 			"Receive control failed (result %d)\n", result);
 		goto harderror;
 	}
 
 	if (ntohl(reply.magic) != NBD_REPLY_MAGIC) {
-		dev_err(disk_to_dev(lo->disk), "Wrong magic (0x%lx)\n",
+		dev_err(disk_to_dev(nbd->disk), "Wrong magic (0x%lx)\n",
 				(unsigned long)ntohl(reply.magic));
 		result = -EPROTO;
 		goto harderror;
 	}
 
-	req = nbd_find_request(lo, *(struct request **)reply.handle);
+	req = nbd_find_request(nbd, *(struct request **)reply.handle);
 	if (IS_ERR(req)) {
 		result = PTR_ERR(req);
 		if (result != -ENOENT)
 			goto harderror;
 
-		dev_err(disk_to_dev(lo->disk), "Unexpected reply (%p)\n",
+		dev_err(disk_to_dev(nbd->disk), "Unexpected reply (%p)\n",
 			reply.handle);
 		result = -EBADR;
 		goto harderror;
 	}
 
 	if (ntohl(reply.error)) {
-		dev_err(disk_to_dev(lo->disk), "Other side returned error (%d)\n",
+		dev_err(disk_to_dev(nbd->disk), "Other side returned error (%d)\n",
 			ntohl(reply.error));
 		req->errors++;
 		return req;
 	}
 
 	dprintk(DBG_RX, "%s: request %p: got reply\n",
-			lo->disk->disk_name, req);
+			nbd->disk->disk_name, req);
 	if (nbd_cmd(req) == NBD_CMD_READ) {
 		struct req_iterator iter;
 		struct bio_vec *bvec;
 
 		rq_for_each_segment(bvec, req, iter) {
-			result = sock_recv_bvec(lo, bvec);
+			result = sock_recv_bvec(nbd, bvec);
 			if (result <= 0) {
-				dev_err(disk_to_dev(lo->disk), "Receive data failed (result %d)\n",
+				dev_err(disk_to_dev(nbd->disk), "Receive data failed (result %d)\n",
 					result);
 				req->errors++;
 				return req;
 			}
 			dprintk(DBG_RX, "%s: request %p: got %d bytes data\n",
-				lo->disk->disk_name, req, bvec->bv_len);
+				nbd->disk->disk_name, req, bvec->bv_len);
 		}
 	}
 	return req;
 harderror:
-	lo->harderror = result;
+	nbd->harderror = result;
 	return NULL;
 }
 
@@ -398,48 +399,48 @@ static struct device_attribute pid_attr 
 	.show = pid_show,
 };
 
-static int nbd_do_it(struct nbd_device *lo)
+static int nbd_do_it(struct nbd_device *nbd)
 {
 	struct request *req;
 	int ret;
 
-	BUG_ON(lo->magic != LO_MAGIC);
+	BUG_ON(nbd->magic != NBD_MAGIC);
 
-	lo->pid = task_pid_nr(current);
-	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
+	nbd->pid = task_pid_nr(current);
+	ret = device_create_file(disk_to_dev(nbd->disk), &pid_attr);
 	if (ret) {
-		dev_err(disk_to_dev(lo->disk), "device_create_file failed!\n");
-		lo->pid = 0;
+		dev_err(disk_to_dev(nbd->disk), "device_create_file failed!\n");
+		nbd->pid = 0;
 		return ret;
 	}
 
-	while ((req = nbd_read_stat(lo)) != NULL)
+	while ((req = nbd_read_stat(nbd)) != NULL)
 		nbd_end_request(req);
 
-	device_remove_file(disk_to_dev(lo->disk), &pid_attr);
-	lo->pid = 0;
+	device_remove_file(disk_to_dev(nbd->disk), &pid_attr);
+	nbd->pid = 0;
 	return 0;
 }
 
-static void nbd_clear_que(struct nbd_device *lo)
+static void nbd_clear_que(struct nbd_device *nbd)
 {
 	struct request *req;
 
-	BUG_ON(lo->magic != LO_MAGIC);
+	BUG_ON(nbd->magic != NBD_MAGIC);
 
 	/*
-	 * Because we have set lo->sock to NULL under the tx_lock, all
+	 * Because we have set nbd->sock to NULL under the tx_lock, all
 	 * modifications to the list must have completed by now.  For
 	 * the same reason, the active_req must be NULL.
 	 *
 	 * As a consequence, we don't need to take the spin lock while
 	 * purging the list here.
 	 */
-	BUG_ON(lo->sock);
-	BUG_ON(lo->active_req);
+	BUG_ON(nbd->sock);
+	BUG_ON(nbd->active_req);
 
-	while (!list_empty(&lo->queue_head)) {
-		req = list_entry(lo->queue_head.next, struct request,
+	while (!list_empty(&nbd->queue_head)) {
+		req = list_entry(nbd->queue_head.next, struct request,
 				 queuelist);
 		list_del_init(&req->queuelist);
 		req->errors++;
@@ -448,7 +449,7 @@ static void nbd_clear_que(struct nbd_dev
 }
 
 
-static void nbd_handle_req(struct nbd_device *lo, struct request *req)
+static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
 {
 	if (req->cmd_type != REQ_TYPE_FS)
 		goto error_out;
@@ -456,8 +457,8 @@ static void nbd_handle_req(struct nbd_de
 	nbd_cmd(req) = NBD_CMD_READ;
 	if (rq_data_dir(req) == WRITE) {
 		nbd_cmd(req) = NBD_CMD_WRITE;
-		if (lo->flags & NBD_READ_ONLY) {
-			dev_err(disk_to_dev(lo->disk),
+		if (nbd->flags & NBD_READ_ONLY) {
+			dev_err(disk_to_dev(nbd->disk),
 				"Write on read-only\n");
 			goto error_out;
 		}
@@ -465,29 +466,29 @@ static void nbd_handle_req(struct nbd_de
 
 	req->errors = 0;
 
-	mutex_lock(&lo->tx_lock);
-	if (unlikely(!lo->sock)) {
-		mutex_unlock(&lo->tx_lock);
-		dev_err(disk_to_dev(lo->disk),
+	mutex_lock(&nbd->tx_lock);
+	if (unlikely(!nbd->sock)) {
+		mutex_unlock(&nbd->tx_lock);
+		dev_err(disk_to_dev(nbd->disk),
 			"Attempted send on closed socket\n");
 		goto error_out;
 	}
 
-	lo->active_req = req;
+	nbd->active_req = req;
 
-	if (nbd_send_req(lo, req) != 0) {
-		dev_err(disk_to_dev(lo->disk), "Request send failed\n");
+	if (nbd_send_req(nbd, req) != 0) {
+		dev_err(disk_to_dev(nbd->disk), "Request send failed\n");
 		req->errors++;
 		nbd_end_request(req);
 	} else {
-		spin_lock(&lo->queue_lock);
-		list_add(&req->queuelist, &lo->queue_head);
-		spin_unlock(&lo->queue_lock);
+		spin_lock(&nbd->queue_lock);
+		list_add(&req->queuelist, &nbd->queue_head);
+		spin_unlock(&nbd->queue_lock);
 	}
 
-	lo->active_req = NULL;
-	mutex_unlock(&lo->tx_lock);
-	wake_up_all(&lo->active_wq);
+	nbd->active_req = NULL;
+	mutex_unlock(&nbd->tx_lock);
+	wake_up_all(&nbd->active_wq);
 
 	return;
 
@@ -498,28 +499,28 @@ error_out:
 
 static int nbd_thread(void *data)
 {
-	struct nbd_device *lo = data;
+	struct nbd_device *nbd = data;
 	struct request *req;
 
 	set_user_nice(current, -20);
-	while (!kthread_should_stop() || !list_empty(&lo->waiting_queue)) {
+	while (!kthread_should_stop() || !list_empty(&nbd->waiting_queue)) {
 		/* wait for something to do */
-		wait_event_interruptible(lo->waiting_wq,
+		wait_event_interruptible(nbd->waiting_wq,
 					 kthread_should_stop() ||
-					 !list_empty(&lo->waiting_queue));
+					 !list_empty(&nbd->waiting_queue));
 
 		/* extract request */
-		if (list_empty(&lo->waiting_queue))
+		if (list_empty(&nbd->waiting_queue))
 			continue;
 
-		spin_lock_irq(&lo->queue_lock);
-		req = list_entry(lo->waiting_queue.next, struct request,
+		spin_lock_irq(&nbd->queue_lock);
+		req = list_entry(nbd->waiting_queue.next, struct request,
 				 queuelist);
 		list_del_init(&req->queuelist);
-		spin_unlock_irq(&lo->queue_lock);
+		spin_unlock_irq(&nbd->queue_lock);
 
 		/* handle request */
-		nbd_handle_req(lo, req);
+		nbd_handle_req(nbd, req);
 	}
 	return 0;
 }
@@ -527,7 +528,7 @@ static int nbd_thread(void *data)
 /*
  * We always wait for result of write, for now. It would be nice to make it optional
  * in future
- * if ((rq_data_dir(req) == WRITE) && (lo->flags & NBD_WRITE_NOCHK))
+ * if ((rq_data_dir(req) == WRITE) && (nbd->flags & NBD_WRITE_NOCHK))
  *   { printk( "Warning: Ignoring result!\n"); nbd_end_request( req ); }
  */
 
@@ -536,19 +537,19 @@ static void do_nbd_request(struct reques
 	struct request *req;
 	
 	while ((req = blk_fetch_request(q)) != NULL) {
-		struct nbd_device *lo;
+		struct nbd_device *nbd;
 
 		spin_unlock_irq(q->queue_lock);
 
 		dprintk(DBG_BLKDEV, "%s: request %p: dequeued (flags=%x)\n",
 				req->rq_disk->disk_name, req, req->cmd_type);
 
-		lo = req->rq_disk->private_data;
+		nbd = req->rq_disk->private_data;
 
-		BUG_ON(lo->magic != LO_MAGIC);
+		BUG_ON(nbd->magic != NBD_MAGIC);
 
-		if (unlikely(!lo->sock)) {
-			dev_err(disk_to_dev(lo->disk),
+		if (unlikely(!nbd->sock)) {
+			dev_err(disk_to_dev(nbd->disk),
 				"Attempted send on closed socket\n");
 			req->errors++;
 			nbd_end_request(req);
@@ -556,11 +557,11 @@ static void do_nbd_request(struct reques
 			continue;
 		}
 
-		spin_lock_irq(&lo->queue_lock);
-		list_add_tail(&req->queuelist, &lo->waiting_queue);
-		spin_unlock_irq(&lo->queue_lock);
+		spin_lock_irq(&nbd->queue_lock);
+		list_add_tail(&req->queuelist, &nbd->waiting_queue);
+		spin_unlock_irq(&nbd->queue_lock);
 
-		wake_up(&lo->waiting_wq);
+		wake_up(&nbd->waiting_wq);
 
 		spin_lock_irq(q->queue_lock);
 	}
@@ -568,32 +569,32 @@ static void do_nbd_request(struct reques
 
 /* Must be called with tx_lock held */
 
-static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
+static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		       unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case NBD_DISCONNECT: {
 		struct request sreq;
 
-		dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");
+		dev_info(disk_to_dev(nbd->disk), "NBD_DISCONNECT\n");
 
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
-		if (!lo->sock)
+		if (!nbd->sock)
 			return -EINVAL;
-		nbd_send_req(lo, &sreq);
+		nbd_send_req(nbd, &sreq);
                 return 0;
 	}
  
 	case NBD_CLEAR_SOCK: {
 		struct file *file;
 
-		lo->sock = NULL;
-		file = lo->file;
-		lo->file = NULL;
-		nbd_clear_que(lo);
-		BUG_ON(!list_empty(&lo->queue_head));
+		nbd->sock = NULL;
+		file = nbd->file;
+		nbd->file = NULL;
+		nbd_clear_que(nbd);
+		BUG_ON(!list_empty(&nbd->queue_head));
 		if (file)
 			fput(file);
 		return 0;
@@ -601,14 +602,14 @@ static int __nbd_ioctl(struct block_devi
 
 	case NBD_SET_SOCK: {
 		struct file *file;
-		if (lo->file)
+		if (nbd->file)
 			return -EBUSY;
 		file = fget(arg);
 		if (file) {
 			struct inode *inode = file->f_path.dentry->d_inode;
 			if (S_ISSOCK(inode->i_mode)) {
-				lo->file = file;
-				lo->sock = SOCKET_I(inode);
+				nbd->file = file;
+				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
 				return 0;
@@ -620,29 +621,29 @@ static int __nbd_ioctl(struct block_devi
 	}
 
 	case NBD_SET_BLKSIZE:
-		lo->blksize = arg;
-		lo->bytesize &= ~(lo->blksize-1);
-		bdev->bd_inode->i_size = lo->bytesize;
-		set_blocksize(bdev, lo->blksize);
-		set_capacity(lo->disk, lo->bytesize >> 9);
+		nbd->blksize = arg;
+		nbd->bytesize &= ~(nbd->blksize-1);
+		bdev->bd_inode->i_size = nbd->bytesize;
+		set_blocksize(bdev, nbd->blksize);
+		set_capacity(nbd->disk, nbd->bytesize >> 9);
 		return 0;
 
 	case NBD_SET_SIZE:
-		lo->bytesize = arg & ~(lo->blksize-1);
-		bdev->bd_inode->i_size = lo->bytesize;
-		set_blocksize(bdev, lo->blksize);
-		set_capacity(lo->disk, lo->bytesize >> 9);
+		nbd->bytesize = arg & ~(nbd->blksize-1);
+		bdev->bd_inode->i_size = nbd->bytesize;
+		set_blocksize(bdev, nbd->blksize);
+		set_capacity(nbd->disk, nbd->bytesize >> 9);
 		return 0;
 
 	case NBD_SET_TIMEOUT:
-		lo->xmit_timeout = arg * HZ;
+		nbd->xmit_timeout = arg * HZ;
 		return 0;
 
 	case NBD_SET_SIZE_BLOCKS:
-		lo->bytesize = ((u64) arg) * lo->blksize;
-		bdev->bd_inode->i_size = lo->bytesize;
-		set_blocksize(bdev, lo->blksize);
-		set_capacity(lo->disk, lo->bytesize >> 9);
+		nbd->bytesize = ((u64) arg) * nbd->blksize;
+		bdev->bd_inode->i_size = nbd->bytesize;
+		set_blocksize(bdev, nbd->blksize);
+		set_capacity(nbd->disk, nbd->bytesize >> 9);
 		return 0;
 
 	case NBD_DO_IT: {
@@ -650,38 +651,38 @@ static int __nbd_ioctl(struct block_devi
 		struct file *file;
 		int error;
 
-		if (lo->pid)
+		if (nbd->pid)
 			return -EBUSY;
-		if (!lo->file)
+		if (!nbd->file)
 			return -EINVAL;
 
-		mutex_unlock(&lo->tx_lock);
+		mutex_unlock(&nbd->tx_lock);
 
-		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
-			mutex_lock(&lo->tx_lock);
+			mutex_lock(&nbd->tx_lock);
 			return PTR_ERR(thread);
 		}
 		wake_up_process(thread);
-		error = nbd_do_it(lo);
+		error = nbd_do_it(nbd);
 		kthread_stop(thread);
 
-		mutex_lock(&lo->tx_lock);
+		mutex_lock(&nbd->tx_lock);
 		if (error)
 			return error;
-		sock_shutdown(lo, 0);
-		file = lo->file;
-		lo->file = NULL;
-		nbd_clear_que(lo);
-		dev_warn(disk_to_dev(lo->disk), "queue cleared\n");
+		sock_shutdown(nbd, 0);
+		file = nbd->file;
+		nbd->file = NULL;
+		nbd_clear_que(nbd);
+		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
 		if (file)
 			fput(file);
-		lo->bytesize = 0;
+		nbd->bytesize = 0;
 		bdev->bd_inode->i_size = 0;
-		set_capacity(lo->disk, 0);
+		set_capacity(nbd->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
-		return lo->harderror;
+		return nbd->harderror;
 	}
 
 	case NBD_CLEAR_QUE:
@@ -689,14 +690,14 @@ static int __nbd_ioctl(struct block_devi
 		 * This is for compatibility only.  The queue is always cleared
 		 * by NBD_DO_IT or NBD_CLEAR_SOCK.
 		 */
-		BUG_ON(!lo->sock && !list_empty(&lo->queue_head));
+		BUG_ON(!nbd->sock && !list_empty(&nbd->queue_head));
 		return 0;
 
 	case NBD_PRINT_DEBUG:
-		dev_info(disk_to_dev(lo->disk),
+		dev_info(disk_to_dev(nbd->disk),
 			"next = %p, prev = %p, head = %p\n",
-			lo->queue_head.next, lo->queue_head.prev,
-			&lo->queue_head);
+			nbd->queue_head.next, nbd->queue_head.prev,
+			&nbd->queue_head);
 		return 0;
 	}
 	return -ENOTTY;
@@ -705,21 +706,21 @@ static int __nbd_ioctl(struct block_devi
 static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 		     unsigned int cmd, unsigned long arg)
 {
-	struct nbd_device *lo = bdev->bd_disk->private_data;
+	struct nbd_device *nbd = bdev->bd_disk->private_data;
 	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	BUG_ON(lo->magic != LO_MAGIC);
+	BUG_ON(nbd->magic != NBD_MAGIC);
 
 	/* Anyone capable of this syscall can do *real bad* things */
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
-			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
+		nbd->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
-	mutex_lock(&lo->tx_lock);
-	error = __nbd_ioctl(bdev, lo, cmd, arg);
-	mutex_unlock(&lo->tx_lock);
+	mutex_lock(&nbd->tx_lock);
+	error = __nbd_ioctl(bdev, nbd, cmd, arg);
+	mutex_unlock(&nbd->tx_lock);
 
 	return error;
 }
@@ -805,7 +806,7 @@ static int __init nbd_init(void)
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = nbd_dev[i].disk;
 		nbd_dev[i].file = NULL;
-		nbd_dev[i].magic = LO_MAGIC;
+		nbd_dev[i].magic = NBD_MAGIC;
 		nbd_dev[i].flags = 0;
 		INIT_LIST_HEAD(&nbd_dev[i].waiting_queue);
 		spin_lock_init(&nbd_dev[i].queue_lock);
_

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch

