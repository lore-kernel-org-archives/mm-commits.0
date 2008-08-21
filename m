From: akpm@linux-foundation.org
Subject: - nbd-fix-memory-leak-of-nbd_dev-array.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:20 -0700
Message-ID: <200808210349.m7L3nKNB015630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbYHUDta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: fix memory leak of nbd_dev array
has been removed from the -mm tree.  Its filename was
     nbd-fix-memory-leak-of-nbd_dev-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: fix memory leak of nbd_dev array
From: Sven Wegener <sven.wegener@stealer.net>

We leak the memory allocated for the nbd_dev array at multiple places. 
Fix them by either adding a kfree() or by rearranging code to return
before we allocate the memory.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/block/nbd.c~nbd-fix-memory-leak-of-nbd_dev-array drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-fix-memory-leak-of-nbd_dev-array
+++ a/drivers/block/nbd.c
@@ -707,15 +707,15 @@ static int __init nbd_init(void)
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
-	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
-	if (!nbd_dev)
-		return -ENOMEM;
-
 	if (max_part < 0) {
 		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
 		return -EINVAL;
 	}
 
+	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
+	if (!nbd_dev)
+		return -ENOMEM;
+
 	part_shift = 0;
 	if (max_part > 0)
 		part_shift = fls(max_part);
@@ -779,6 +779,7 @@ out:
 		blk_cleanup_queue(nbd_dev[i].disk->queue);
 		put_disk(nbd_dev[i].disk);
 	}
+	kfree(nbd_dev);
 	return err;
 }
 
@@ -795,6 +796,7 @@ static void __exit nbd_cleanup(void)
 		}
 	}
 	unregister_blkdev(NBD_MAJOR, "nbd");
+	kfree(nbd_dev);
 	printk(KERN_INFO "nbd: unregistered device at major %d\n", NBD_MAJOR);
 }
 
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch

