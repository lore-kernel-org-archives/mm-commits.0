From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-block-loopc-emit-uevent-on-auto-release.patch removed from -mm tree
Date: Tue, 06 Sep 2011 13:31:22 -0700
Message-ID: <201109062031.p86KVMkQ029435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755040Ab1IFUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 16:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: psusi@cfl.rr.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/block/loop.c: emit uevent on auto release
has been removed from the -mm tree.  Its filename was
     drivers-block-loopc-emit-uevent-on-auto-release.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/loop.c: emit uevent on auto release
From: Phillip Susi <psusi@cfl.rr.com>

Fix the loopback device to emit a uevent on auto release.  The loopback
driver failed to emit the change uevent when auto releasing the device. 
Fix lo_release() to pass the bdev to loop_clr_fd() so it can emit the
event.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/loop.c~drivers-block-loopc-emit-uevent-on-auto-release drivers/block/loop.c
--- a/drivers/block/loop.c~drivers-block-loopc-emit-uevent-on-auto-release
+++ a/drivers/block/loop.c
@@ -1509,7 +1509,7 @@ static int lo_release(struct gendisk *di
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err = loop_clr_fd(lo, NULL);
+		err = loop_clr_fd(lo, lo->lo_device);
 		if (!err)
 			goto out_unlocked;
 	} else {
_

Patches currently in -mm which might be from psusi@cfl.rr.com are

fixed-loopback-device-to-emit-uevent-on-auto-release.patch

