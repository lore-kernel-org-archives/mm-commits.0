From: akpm@linux-foundation.org
Subject: + drivers-block-loopc-emit-uevent-on-auto-release.patch added to -mm tree
Date: Tue, 06 Sep 2011 13:33:30 -0700
Message-ID: <201109062033.p86KXURX029545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071Ab1IFUdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 16:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: psusi@cfl.rr.com, axboe@kernel.dk, ayan@ayan.net


The patch titled
     drivers/block/loop.c: emit uevent on auto release
has been added to the -mm tree.  Its filename is
     drivers-block-loopc-emit-uevent-on-auto-release.patch

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
Subject: drivers/block/loop.c: emit uevent on auto release
From: Phillip Susi <psusi@cfl.rr.com>

The loopback driver failed to emit the change uevent when auto releasing
the device.  Fixed lo_release() to pass the bdev to loop_clr_fd() so it
can emit the event.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ayan George <ayan@ayan.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/loop.c~drivers-block-loopc-emit-uevent-on-auto-release drivers/block/loop.c
--- a/drivers/block/loop.c~drivers-block-loopc-emit-uevent-on-auto-release
+++ a/drivers/block/loop.c
@@ -1588,7 +1588,7 @@ static int lo_release(struct gendisk *di
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

drivers-block-loopc-emit-uevent-on-auto-release.patch
drivers-block-loopc-remove-unnecessary-bdev-argument-from-loop_clr_fd.patch

