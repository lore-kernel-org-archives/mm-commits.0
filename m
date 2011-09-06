From: akpm@linux-foundation.org
Subject: [merged] nbd-replace-printk-kern_err-with-dev_err.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:16:52 -0700
Message-ID: <201109061912.p86JCelj022208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab1IFTMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:12:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, Paul.Clements@steeleye.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     nbd: replace printk KERN_ERR with dev_err()
has been removed from the -mm tree.  Its filename was
     nbd-replace-printk-kern_err-with-dev_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: replace printk KERN_ERR with dev_err()
From: WANG Cong <amwang@redhat.com>

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   50 +++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff -puN drivers/block/nbd.c~nbd-replace-printk-kern_err-with-dev_err drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-replace-printk-kern_err-with-dev_err
+++ a/drivers/block/nbd.c
@@ -158,8 +158,9 @@ static int sock_xmit(struct nbd_device *
 	sigset_t blocked, oldset;
 
 	if (unlikely(!sock)) {
-		printk(KERN_ERR "%s: Attempted %s on closed socket in sock_xmit\n",
-		       lo->disk->disk_name, (send ? "send" : "recv"));
+		dev_err(disk_to_dev(lo->disk),
+			"Attempted %s on closed socket in sock_xmit\n",
+			(send ? "send" : "recv"));
 		return -EINVAL;
 	}
 
@@ -250,8 +251,8 @@ static int nbd_send_req(struct nbd_devic
 	result = sock_xmit(lo, 1, &request, sizeof(request),
 			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
-		printk(KERN_ERR "%s: Send control failed (result %d)\n",
-				lo->disk->disk_name, result);
+		dev_err(disk_to_dev(lo->disk),
+			"Send control failed (result %d)\n", result);
 		goto error_out;
 	}
 
@@ -270,8 +271,9 @@ static int nbd_send_req(struct nbd_devic
 					lo->disk->disk_name, req, bvec->bv_len);
 			result = sock_send_bvec(lo, bvec, flags);
 			if (result <= 0) {
-				printk(KERN_ERR "%s: Send data failed (result %d)\n",
-						lo->disk->disk_name, result);
+				dev_err(disk_to_dev(lo->disk),
+					"Send data failed (result %d)\n",
+					result);
 				goto error_out;
 			}
 		}
@@ -328,14 +330,13 @@ static struct request *nbd_read_stat(str
 	reply.magic = 0;
 	result = sock_xmit(lo, 0, &reply, sizeof(reply), MSG_WAITALL);
 	if (result <= 0) {
-		printk(KERN_ERR "%s: Receive control failed (result %d)\n",
-				lo->disk->disk_name, result);
+		dev_err(disk_to_dev(lo->disk),
+			"Receive control failed (result %d)\n", result);
 		goto harderror;
 	}
 
 	if (ntohl(reply.magic) != NBD_REPLY_MAGIC) {
-		printk(KERN_ERR "%s: Wrong magic (0x%lx)\n",
-				lo->disk->disk_name,
+		dev_err(disk_to_dev(lo->disk), "Wrong magic (0x%lx)\n",
 				(unsigned long)ntohl(reply.magic));
 		result = -EPROTO;
 		goto harderror;
@@ -347,15 +348,15 @@ static struct request *nbd_read_stat(str
 		if (result != -ENOENT)
 			goto harderror;
 
-		printk(KERN_ERR "%s: Unexpected reply (%p)\n",
-				lo->disk->disk_name, reply.handle);
+		dev_err(disk_to_dev(lo->disk), "Unexpected reply (%p)\n",
+			reply.handle);
 		result = -EBADR;
 		goto harderror;
 	}
 
 	if (ntohl(reply.error)) {
-		printk(KERN_ERR "%s: Other side returned error (%d)\n",
-				lo->disk->disk_name, ntohl(reply.error));
+		dev_err(disk_to_dev(lo->disk), "Other side returned error (%d)\n",
+			ntohl(reply.error));
 		req->errors++;
 		return req;
 	}
@@ -369,8 +370,8 @@ static struct request *nbd_read_stat(str
 		rq_for_each_segment(bvec, req, iter) {
 			result = sock_recv_bvec(lo, bvec);
 			if (result <= 0) {
-				printk(KERN_ERR "%s: Receive data failed (result %d)\n",
-						lo->disk->disk_name, result);
+				dev_err(disk_to_dev(lo->disk), "Receive data failed (result %d)\n",
+					result);
 				req->errors++;
 				return req;
 			}
@@ -408,7 +409,7 @@ static int nbd_do_it(struct nbd_device *
 	lo->pid = task_pid_nr(current);
 	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
 	if (ret) {
-		printk(KERN_ERR "nbd: device_create_file failed!");
+		dev_err(disk_to_dev(lo->disk), "device_create_file failed!\n");
 		lo->pid = 0;
 		return ret;
 	}
@@ -457,8 +458,8 @@ static void nbd_handle_req(struct nbd_de
 	if (rq_data_dir(req) == WRITE) {
 		nbd_cmd(req) = NBD_CMD_WRITE;
 		if (lo->flags & NBD_READ_ONLY) {
-			printk(KERN_ERR "%s: Write on read-only\n",
-					lo->disk->disk_name);
+			dev_err(disk_to_dev(lo->disk),
+				"Write on read-only\n");
 			goto error_out;
 		}
 	}
@@ -468,16 +469,15 @@ static void nbd_handle_req(struct nbd_de
 	mutex_lock(&lo->tx_lock);
 	if (unlikely(!lo->sock)) {
 		mutex_unlock(&lo->tx_lock);
-		printk(KERN_ERR "%s: Attempted send on closed socket\n",
-		       lo->disk->disk_name);
+		dev_err(disk_to_dev(lo->disk),
+			"Attempted send on closed socket\n");
 		goto error_out;
 	}
 
 	lo->active_req = req;
 
 	if (nbd_send_req(lo, req) != 0) {
-		printk(KERN_ERR "%s: Request send failed\n",
-				lo->disk->disk_name);
+		dev_err(disk_to_dev(lo->disk), "Request send failed\n");
 		req->errors++;
 		nbd_end_request(req);
 	} else {
@@ -549,8 +549,8 @@ static void do_nbd_request(struct reques
 		BUG_ON(lo->magic != LO_MAGIC);
 
 		if (unlikely(!lo->sock)) {
-			printk(KERN_ERR "%s: Attempted send on closed socket\n",
-				lo->disk->disk_name);
+			dev_err(disk_to_dev(lo->disk),
+				"Attempted send on closed socket\n");
 			req->errors++;
 			nbd_end_request(req);
 			spin_lock_irq(q->queue_lock);
_

Patches currently in -mm which might be from amwang@redhat.com are

numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
sched-fix-a-memory-leak-in-__sdt_free.patch
sysctl-make-config_sysctl_syscall-default-to-n.patch

