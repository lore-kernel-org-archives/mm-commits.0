From: akpm@linux-foundation.org
Subject: - brd-fix-name-argument-of-unregister_blkdev.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:23 -0700
Message-ID: <200808210349.m7L3nNgW015635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbYHUDt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     brd: fix name argument of unregister_blkdev()
has been removed from the -mm tree.  Its filename was
     brd-fix-name-argument-of-unregister_blkdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brd: fix name argument of unregister_blkdev()
From: Akinobu Mita <akinobu.mita@gmail.com>

The name of brd block device is "ramdisk", it's not "brd".
(The block device is registered by register_blkdev(RAMDISK_MAJOR, "ramdisk")
So it should be unregistered by unregister_blkdev(RAMDISK_MAJOR, "ramdisk")

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Nick Piggin <npiggin@suse.de>
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

