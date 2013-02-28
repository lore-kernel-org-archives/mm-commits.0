From: akpm@linux-foundation.org
Subject: [merged] nbd-support-flush-requests.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:56 -0800
Message-ID: <20130228201656.C1D0731C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55716 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3B1UQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:57 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245475yen.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@alex.org.uk, Paul.Clements@steeleye.com, pbonzini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: support FLUSH requests
has been removed from the -mm tree.  Its filename was
     nbd-support-flush-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Bligh <alex@alex.org.uk>
Subject: nbd: support FLUSH requests

Currently, the NBD device does not accept flush requests from the Linux
block layer.  If the NBD server opened the target with neither O_SYNC nor
O_DSYNC, however, the device will be effectively backed by a writeback
cache.  Without issuing flushes properly, operation of the NBD device will
not be safe against power losses.

The NBD protocol has support for both a cache flush command and a FUA
command flag; the server will also pass a flag to note its support for
these features.  This patch adds support for the cache flush command and
flag.  In the kernel, we receive the flags via the NBD_SET_FLAGS ioctl,
and map NBD_FLAG_SEND_FLUSH to the argument of blk_queue_flush.  When the
flag is active the block layer will send REQ_FLUSH requests, which we
translate to NBD_CMD_FLUSH commands.

FUA support is not included in this patch because all free software
servers implement it with a full fdatasync; thus it has no advantage over
supporting flush only.  Because I [Paolo] cannot really benchmark it in a
realistic scenario, I cannot tell if it is a good idea or not.  It is also
not clear if it is valid for an NBD server to support FUA but not flush. 
The Linux block layer gives a warning for this combination, the NBD
protocol documentation says nothing about it.

The patch also fixes a small problem in the handling of flags: nbd->flags
must be cleared at the end of NBD_DO_IT, but the driver was not doing
that.  The bug manifests itself as follows.  Suppose you two different
client/server pairs to start the NBD device.  Suppose also that the first
client supports NBD_SET_FLAGS, and the first server sends
NBD_FLAG_SEND_FLUSH; the second pair instead does neither of these two
things.  Before this patch, the second invocation of NBD_DO_IT will use a
stale value of nbd->flags, and the second server will issue an error every
time it receives an NBD_CMD_FLUSH command.

This bug is pre-existing, but it becomes much more important after this
patch; flush failures make the device pretty much unusable, unlike

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alex Bligh <alex@alex.org.uk>
Acked-by: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c      |   22 ++++++++++++++++++++--
 include/uapi/linux/nbd.h |    3 ++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -puN drivers/block/nbd.c~nbd-support-flush-requests drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-support-flush-requests
+++ a/drivers/block/nbd.c
@@ -98,6 +98,7 @@ static const char *nbdcmd_to_ascii(int c
 	case  NBD_CMD_READ: return "read";
 	case NBD_CMD_WRITE: return "write";
 	case  NBD_CMD_DISC: return "disconnect";
+	case NBD_CMD_FLUSH: return "flush";
 	case  NBD_CMD_TRIM: return "trim/discard";
 	}
 	return "invalid";
@@ -244,8 +245,15 @@ static int nbd_send_req(struct nbd_devic
 
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
-	request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
-	request.len = htonl(size);
+
+	if (nbd_cmd(req) == NBD_CMD_FLUSH) {
+		/* Other values are reserved for FLUSH requests.  */
+		request.from = 0;
+		request.len = 0;
+	} else {
+		request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
+		request.len = htonl(size);
+	}
 	memcpy(request.handle, &req, sizeof(req));
 
 	dprintk(DBG_TX, "%s: request %p: sending control (%s@%llu,%uB)\n",
@@ -482,6 +490,11 @@ static void nbd_handle_req(struct nbd_de
 		}
 	}
 
+	if (req->cmd_flags & REQ_FLUSH) {
+		BUG_ON(unlikely(blk_rq_sectors(req)));
+		nbd_cmd(req) = NBD_CMD_FLUSH;
+	}
+
 	req->errors = 0;
 
 	mutex_lock(&nbd->tx_lock);
@@ -684,6 +697,10 @@ static int __nbd_ioctl(struct block_devi
 		if (nbd->flags & NBD_FLAG_SEND_TRIM)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 				nbd->disk->queue);
+		if (nbd->flags & NBD_FLAG_SEND_FLUSH)
+			blk_queue_flush(nbd->disk->queue, REQ_FLUSH);
+		else
+			blk_queue_flush(nbd->disk->queue, 0);
 
 		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
@@ -705,6 +722,7 @@ static int __nbd_ioctl(struct block_devi
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 		if (file)
 			fput(file);
+		nbd->flags = 0;
 		nbd->bytesize = 0;
 		bdev->bd_inode->i_size = 0;
 		set_capacity(nbd->disk, 0);
diff -puN include/uapi/linux/nbd.h~nbd-support-flush-requests include/uapi/linux/nbd.h
--- a/include/uapi/linux/nbd.h~nbd-support-flush-requests
+++ a/include/uapi/linux/nbd.h
@@ -33,13 +33,14 @@ enum {
 	NBD_CMD_READ = 0,
 	NBD_CMD_WRITE = 1,
 	NBD_CMD_DISC = 2,
-	/* there is a gap here to match userspace */
+	NBD_CMD_FLUSH = 3,
 	NBD_CMD_TRIM = 4
 };
 
 /* values for flags field */
 #define NBD_FLAG_HAS_FLAGS    (1 << 0) /* nbd-server supports flags */
 #define NBD_FLAG_READ_ONLY    (1 << 1) /* device is read-only */
+#define NBD_FLAG_SEND_FLUSH   (1 << 2) /* can flush writeback cache */
 /* there is a gap here to match userspace */
 #define NBD_FLAG_SEND_TRIM    (1 << 5) /* send trim/discard */
 
_

Patches currently in -mm which might be from alex@alex.org.uk are

origin.patch

