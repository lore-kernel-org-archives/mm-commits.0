From: akpm@linux-foundation.org
Subject: + nbd-remove-module-level-ioctl-mutex.patch added to -mm tree
Date: Thu, 03 Feb 2011 13:41:23 -0800
Message-ID: <201102032141.p13LfOQu026356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213Ab1BCVlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 16:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: soren@linux2go.dk, arnd@arndb.de, axboe@kernel.dk, paul.clements@steeleye.com, serge.hallyn@canonical.com, stable@kernel.org


The patch titled
     nbd: remove module-level ioctl mutex
has been added to the -mm tree.  Its filename is
     nbd-remove-module-level-ioctl-mutex.patch

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
Subject: nbd: remove module-level ioctl mutex
From: Soren Hansen <soren@linux2go.dk>

2a48fc0ab242417 ("block: autoconvert trivial BKL users to private mutex")
replaced uses of the BKL in the nbd driver with mutex operations.  Since
then, I've been been seeing these lock ups:

 INFO: task qemu-nbd:16115 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 qemu-nbd      D 0000000000000001     0 16115  16114 0x00000004
  ffff88007d775d98 0000000000000082 ffff88007d775fd8 ffff88007d774000
  0000000000013a80 ffff8800020347e0 ffff88007d775fd8 0000000000013a80
  ffff880133730000 ffff880002034440 ffffea0004333db8 ffffffffa071c020
 Call Trace:
  [<ffffffff815b9997>] __mutex_lock_slowpath+0xf7/0x180
  [<ffffffff81132f13>] ? handle_mm_fault+0x1c3/0x410
  [<ffffffff815b93eb>] mutex_lock+0x2b/0x50
  [<ffffffffa071a21c>] nbd_ioctl+0x6c/0x1c0 [nbd]
  [<ffffffff812cb970>] blkdev_ioctl+0x230/0x730
  [<ffffffff811967a1>] block_ioctl+0x41/0x50
  [<ffffffff81175c03>] do_vfs_ioctl+0x93/0x370
  [<ffffffff8116fa83>] ? putname+0x33/0x50
  [<ffffffff81175f61>] sys_ioctl+0x81/0xa0
  [<ffffffff8100c0c2>] system_call_fastpath+0x16/0x1b

Instrumenting the nbd module's ioctl handler with some extra logging
clearly shows the NBD_DO_IT ioctl being invoked which is a long-lived
ioctl in the sense that it doesn't return until another ioctl asks the
driver to disconnect.  However, that other ioctl blocks, waiting for the
module-level mutex that replaced the BKL, and then we're stuck.

This patch removes the module-level mutex altogether.  It's clearly wrong,
and as far as I can see, it's entirely unnecessary, since the nbd driver
maintains per-device mutexes, and I don't see anything that would require
a module-level (or kernel-level, for that matter) mutex.

Signed-off-by: Soren Hansen <soren@linux2go.dk>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@kernel.org>		[2.6.37.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/block/nbd.c~nbd-remove-module-level-ioctl-mutex drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-remove-module-level-ioctl-mutex
+++ a/drivers/block/nbd.c
@@ -53,7 +53,6 @@
 #define DBG_BLKDEV      0x0100
 #define DBG_RX          0x0200
 #define DBG_TX          0x0400
-static DEFINE_MUTEX(nbd_mutex);
 static unsigned int debugflags;
 #endif /* NDEBUG */
 
@@ -718,11 +717,9 @@ static int nbd_ioctl(struct block_device
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
-	mutex_lock(&nbd_mutex);
 	mutex_lock(&lo->tx_lock);
 	error = __nbd_ioctl(bdev, lo, cmd, arg);
 	mutex_unlock(&lo->tx_lock);
-	mutex_unlock(&nbd_mutex);
 
 	return error;
 }
_

Patches currently in -mm which might be from soren@linux2go.dk are

nbd-remove-module-level-ioctl-mutex.patch

