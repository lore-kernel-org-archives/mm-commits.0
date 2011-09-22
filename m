From: akpm@google.com
Subject: [merged] drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:43 -0700
Message-ID: <201109222100.p8ML0hAl026896@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:34723 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ayan@ayan.net, axboe@kernel.dk, ayan.george@canonical.com, psusi@cfl.rr.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/loop.c: remove unnecessary bdev argument from loop_clr_fd()
has been removed from the -mm tree.  Its filename was
     drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ayan George <ayan@ayan.net>
Subject: drivers/block/loop.c: remove unnecessary bdev argument from loop_clr_fd()

If the loop device is associated (lo->lo_state == Lo_bound), it will have
a valid bdev pointed to by lo->lo_device.  There is no reason to ever pass
an additional block_device pointer.

Signed-off-by: Ayan George <ayan.george@canonical.com>
Cc: Phillip Susi <psusi@cfl.rr.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/block/loop.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/block/loop.c~drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd drivers/block/loop.c
--- a/drivers/block/loop.c~drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd
+++ a/drivers/block/loop.c
@@ -1045,10 +1045,11 @@ loop_init_xfer(struct loop_device *lo, s
 	return err;
 }
 
-static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
+static int loop_clr_fd(struct loop_device *lo)
 {
 	struct file *filp = lo->lo_backing_file;
 	gfp_t gfp = lo->old_gfp_mask;
+	struct block_device *bdev = lo->lo_device;
 
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
@@ -1368,7 +1369,7 @@ static int lo_ioctl(struct block_device 
 		break;
 	case LOOP_CLR_FD:
 		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
-		err = loop_clr_fd(lo, bdev);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 		break;
@@ -1588,7 +1589,7 @@ static int lo_release(struct gendisk *di
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err = loop_clr_fd(lo, lo->lo_device);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 	} else {
_

Patches currently in -mm which might be from ayan@ayan.net are

linux-next.patch

