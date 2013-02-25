From: akpm@linux-foundation.org
Subject: [merged] loopdev-remove-an-user-triggerable-oops.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:44 -0800
Message-ID: <20130225205644.AFB2431C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:48334 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3BYU4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:45 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348367yhz.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: loopdev: remove an user triggerable oops
has been removed from the -mm tree.  Its filename was
     loopdev-remove-an-user-triggerable-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: loopdev: remove an user triggerable oops

When loopdev is built as module and we pass an invalid parameter,
loop_init() will return directly without deregister misc device, which
will cause an oops when insert loop module next time because we left some
garbage in the misc device list.

Test case:
sudo modprobe loop max_part=1024
(failed due to invalid parameter)
sudo modprobe loop
(oops)

Clean up nicely to avoid such oops.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN drivers/block/loop.c~loopdev-remove-an-user-triggerable-oops drivers/block/loop.c
--- a/drivers/block/loop.c~loopdev-remove-an-user-triggerable-oops
+++ a/drivers/block/loop.c
@@ -1844,11 +1844,15 @@ static int __init loop_init(void)
 		max_part = (1UL << part_shift) - 1;
 	}
 
-	if ((1UL << part_shift) > DISK_MAX_PARTS)
-		return -EINVAL;
+	if ((1UL << part_shift) > DISK_MAX_PARTS) {
+		err = -EINVAL;
+		goto misc_out;
+	}
 
-	if (max_loop > 1UL << (MINORBITS - part_shift))
-		return -EINVAL;
+	if (max_loop > 1UL << (MINORBITS - part_shift)) {
+		err = -EINVAL;
+		goto misc_out;
+	}
 
 	/*
 	 * If max_loop is specified, create that many devices upfront.
@@ -1866,8 +1870,10 @@ static int __init loop_init(void)
 		range = 1UL << MINORBITS;
 	}
 
-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
+	if (register_blkdev(LOOP_MAJOR, "loop")) {
+		err = -EIO;
+		goto misc_out;
+	}
 
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
@@ -1880,6 +1886,10 @@ static int __init loop_init(void)
 
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
+
+misc_out:
+	misc_deregister(&loop_misc);
+	return err;
 }
 
 static int loop_exit_cb(int id, void *ptr, void *data)
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

