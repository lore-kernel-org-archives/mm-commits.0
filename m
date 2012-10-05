From: akpm@linux-foundation.org
Subject: [merged] nbd-handle-discard-requests.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:57 -0700
Message-ID: <20121005202058.176EC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60969 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:00 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so140000wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: handle discard requests
has been removed from the -mm tree.  Its filename was
     nbd-handle-discard-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Clements <paul.clements@steeleye.com>
Subject: nbd: handle discard requests

Add discard support to nbd.  If the nbd-server supports discard, it will
send NBD_FLAG_SEND_TRIM to the client.  The client will then set the flag
in the kernel via NBD_SET_FLAGS, which tells the kernel to enable discards
for the device (QUEUE_FLAG_DISCARD).

If discard support is enabled, then when the nbd client system receives a
discard request, this will be passed along to the nbd-server.  When the
discard request is received by the nbd-server, it will perform:

	fallocate(.. FALLOC_FL_PUNCH_HOLE ..)

To punch a hole in the backend storage, which is no longer needed.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   15 ++++++++++++++-
 include/linux/nbd.h |    6 +++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/block/nbd.c~nbd-handle-discard-requests drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-handle-discard-requests
+++ a/drivers/block/nbd.c
@@ -98,6 +98,7 @@ static const char *nbdcmd_to_ascii(int c
 	case  NBD_CMD_READ: return "read";
 	case NBD_CMD_WRITE: return "write";
 	case  NBD_CMD_DISC: return "disconnect";
+	case  NBD_CMD_TRIM: return "trim/discard";
 	}
 	return "invalid";
 }
@@ -469,7 +470,11 @@ static void nbd_handle_req(struct nbd_de
 
 	nbd_cmd(req) = NBD_CMD_READ;
 	if (rq_data_dir(req) == WRITE) {
-		nbd_cmd(req) = NBD_CMD_WRITE;
+		if ((req->cmd_flags & REQ_DISCARD)) {
+			WARN_ON(!(nbd->flags & NBD_FLAG_SEND_TRIM));
+			nbd_cmd(req) = NBD_CMD_TRIM;
+		} else
+			nbd_cmd(req) = NBD_CMD_WRITE;
 		if (nbd->flags & NBD_FLAG_READ_ONLY) {
 			dev_err(disk_to_dev(nbd->disk),
 				"Write on read-only\n");
@@ -676,6 +681,10 @@ static int __nbd_ioctl(struct block_devi
 
 		mutex_unlock(&nbd->tx_lock);
 
+		if (nbd->flags & NBD_FLAG_SEND_TRIM)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+				nbd->disk->queue);
+
 		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
@@ -693,6 +702,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 		if (file)
 			fput(file);
 		nbd->bytesize = 0;
@@ -811,6 +821,9 @@ static int __init nbd_init(void)
 		 * Tell the block layer that we are not a rotational device
 		 */
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		disk->queue->limits.discard_granularity = 512;
+		disk->queue->limits.max_discard_sectors = UINT_MAX;
+		disk->queue->limits.discard_zeroes_data = 0;
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
diff -puN include/linux/nbd.h~nbd-handle-discard-requests include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-handle-discard-requests
+++ a/include/linux/nbd.h
@@ -32,12 +32,16 @@
 enum {
 	NBD_CMD_READ = 0,
 	NBD_CMD_WRITE = 1,
-	NBD_CMD_DISC = 2
+	NBD_CMD_DISC = 2,
+	/* there is a gap here to match userspace */
+	NBD_CMD_TRIM = 4
 };
 
 /* values for flags field */
 #define NBD_FLAG_HAS_FLAGS    (1 << 0) /* nbd-server supports flags */
 #define NBD_FLAG_READ_ONLY    (1 << 1) /* device is read-only */
+/* there is a gap here to match userspace */
+#define NBD_FLAG_SEND_TRIM    (1 << 5) /* send trim/discard */
 
 #define nbd_cmd(req) ((req)->cmd[0])
 
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

origin.patch

