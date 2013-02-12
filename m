From: akpm@linux-foundation.org
Subject: + nbd-support-flush-requests.patch added to -mm tree
Date: Tue, 12 Feb 2013 13:43:02 -0800
Message-ID: <20130212214303.415D75A4214@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:53871 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3BLVnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 16:43:05 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so61377vbb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 13:43:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex@alex.org.uk, Paul.Clements@steeleye.com, pbonzini@redhat.com


The patch titled
     Subject: nbd: support FLUSH requests
has been added to the -mm tree.  Its filename is
     nbd-support-flush-requests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Bligh <alex@alex.org.uk>
Subject: nbd: support FLUSH requests

The NBD device does not support writeback caching, thus it is not safe
against power losses unless the client opens the target with O_DSYNC or
O_SYNC.

Add support for a new flag that the server can pass.  If the flag is
enabled, we translate REQ_FLUSH requests into the NBD_CMD_FLUSH command.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alex Bligh <alex@alex.org.uk>
Cc: Paul Clements <Paul.Clements@steeleye.com>
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

nbd-support-flush-requests.patch
nbd-fsync-and-kill-block-device-on-shutdown.patch
nbd-show-read-only-state-in-sysfs.patch

