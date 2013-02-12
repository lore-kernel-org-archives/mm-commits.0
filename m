From: akpm@linux-foundation.org
Subject: + nbd-fsync-and-kill-block-device-on-shutdown.patch added to -mm tree
Date: Tue, 12 Feb 2013 13:43:05 -0800
Message-ID: <20130212214306.2ABF35A41F1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48133 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3BLVnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 16:43:07 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so783006ghb.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 13:43:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbonzini@redhat.com, Paul.Clements@steeleye.com, alex@alex.org.uk, stable@vger.kernel.org


The patch titled
     Subject: nbd: fsync and kill block device on shutdown
has been added to the -mm tree.  Its filename is
     nbd-fsync-and-kill-block-device-on-shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Paul Clements <Paul.Clements@steeleye.com>
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

linux-next.patch
nbd-support-flush-requests.patch
nbd-fsync-and-kill-block-device-on-shutdown.patch
nbd-show-read-only-state-in-sysfs.patch

