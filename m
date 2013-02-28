From: akpm@linux-foundation.org
Subject: [merged] nbd-fsync-and-kill-block-device-on-shutdown.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:59 -0800
Message-ID: <20130228201659.B6A7B5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:55403 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3B1URA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:00 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246964yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbonzini@redhat.com, Paul.Clements@steeleye.com, alex@alex.org.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: fsync and kill block device on shutdown
has been removed from the -mm tree.  Its filename was
     nbd-fsync-and-kill-block-device-on-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: nbd: fsync and kill block device on shutdown

There are two problems with shutdown in the NBD driver.

1: Receiving the NBD_DISCONNECT ioctl does not sync the filesystem. 

   This patch adds the sync operation into __nbd_ioctl()'s
   NBD_DISCONNECT handler.  This is useful because BLKFLSBUF is restricted
   to processes that have CAP_SYS_ADMIN, and the NBD client may not
   possess it (fsync of the block device does not sync the filesystem,
   either).

2: Once we clear the socket we have no guarantee that later reads will
   come from the same backing storage.

   The patch adds calls to kill_bdev() in __nbd_ioctl()'s socket
   clearing code so the page cache is cleaned, lest reads that hit on the
   page cache will return stale data from the previously-accessible disk.

Example:

    # qemu-nbd -r -c/dev/nbd0 /dev/sr0
    # file -s /dev/nbd0
    /dev/stdin: # UDF filesystem data (version 1.5) etc.
    # qemu-nbd -d /dev/nbd0
    # qemu-nbd -r -c/dev/nbd0 /dev/sda
    # file -s /dev/nbd0
    /dev/stdin: # UDF filesystem data (version 1.5) etc.

While /dev/sda has:

    # file -s /dev/sda
    /dev/sda: x86 boot sector; etc.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Paul Clements <Paul.Clements@steeleye.com>
Cc: Alex Bligh <alex@alex.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/block/nbd.c~nbd-fsync-and-kill-block-device-on-shutdown drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-fsync-and-kill-block-device-on-shutdown
+++ a/drivers/block/nbd.c
@@ -608,12 +608,20 @@ static int __nbd_ioctl(struct block_devi
 		struct request sreq;
 
 		dev_info(disk_to_dev(nbd->disk), "NBD_DISCONNECT\n");
+		if (!nbd->sock)
+			return -EINVAL;
 
+		mutex_unlock(&nbd->tx_lock);
+		fsync_bdev(bdev);
+		mutex_lock(&nbd->tx_lock);
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
+
+		/* Check again after getting mutex back.  */
 		if (!nbd->sock)
 			return -EINVAL;
+
 		nbd_send_req(nbd, &sreq);
                 return 0;
 	}
@@ -627,6 +635,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
 		BUG_ON(!list_empty(&nbd->waiting_queue));
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		return 0;
@@ -719,6 +728,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+		kill_bdev(bdev);
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 		if (file)
 			fput(file);
_

Patches currently in -mm which might be from pbonzini@redhat.com are

origin.patch

