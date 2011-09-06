From: akpm@linux-foundation.org
Subject: + drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd.patch added to -mm tree
Date: Tue, 06 Sep 2011 13:33:32 -0700
Message-ID: <201109062033.p86KXWKl029548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071Ab1IFUdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 16:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ayan@ayan.net, axboe@kernel.dk, ayan.george@canonical.com, psusi@cfl.rr.com


The patch titled
     drivers/block/loop.c: remove unnecessary bdev argument from loop_clr_fd()
has been added to the -mm tree.  Its filename is
     drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd.patch

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
Subject: drivers/block/loop.c: remove unnecessary bdev argument from loop_clr_fd()
From: Ayan George <ayan@ayan.net>

If the loop device is associated (lo->lo_state == Lo_bound), it will have
a valid bdev pointed to by lo->lo_device.  There is no reason to ever pass
an additional block_device pointer.

Signed-off-by: Ayan George <ayan.george@canonical.com>
Cc: Phillip Susi <psusi@cfl.rr.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

drivers-block-loopc-emit-uevent-on-auto-release.patch
drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd.patch

