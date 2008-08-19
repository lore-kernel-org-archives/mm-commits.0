From: akpm@linux-foundation.org
Subject: + brd-fix-name-argument-of-unregister_blkdev.patch added to -mm tree
Date: Tue, 19 Aug 2008 02:47:24 -0700
Message-ID: <200808190947.m7J9lOKj010188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbYHSJrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 05:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, npiggin@suse.de


The patch titled
     brd: fix name argument of unregister_blkdev()
has been added to the -mm tree.  Its filename is
     brd-fix-name-argument-of-unregister_blkdev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brd: fix name argument of unregister_blkdev()
From: Akinobu Mita <akinobu.mita@gmail.com>

The name of brd block device is "ramdisk", it's not "brd".
(The block device is registered by register_blkdev(RAMDISK_MAJOR, "ramdisk")
So it should be unregistered by unregister_blkdev(RAMDISK_MAJOR, "ramdisk")

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/brd.c~brd-fix-name-argument-of-unregister_blkdev drivers/block/brd.c
--- a/drivers/block/brd.c~brd-fix-name-argument-of-unregister_blkdev
+++ a/drivers/block/brd.c
@@ -571,8 +571,8 @@ out_free:
 		list_del(&brd->brd_list);
 		brd_free(brd);
 	}
+	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
-	unregister_blkdev(RAMDISK_MAJOR, "brd");
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ipr-use-memory_read_from_buffer.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
brd-fix-name-argument-of-unregister_blkdev.patch

