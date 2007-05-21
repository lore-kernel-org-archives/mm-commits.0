From: akpm@linux-foundation.org
Subject: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Date: Mon, 21 May 2007 15:00:55 -0700
Message-ID: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546AbXEUWCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, viro@zeniv.linux.org.uk


The patch titled
     loop: preallocate eight loop devices
has been added to the -mm tree.  Its filename is
     loop-preallocate-eight-loop-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: loop: preallocate eight loop devices
From: "Ken Chen" <kenchen@google.com>

The kernel on-demand loop device instantiation breaks several user space
tools as the tools are not ready to cope with the "on-demand feature".  Fix
it by instantiate default 8 loop devices and also reinstate max_loop module
parameter.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   68 ++++++++++++++++++++++++++++++-----------
 1 files changed, 50 insertions(+), 18 deletions(-)

diff -puN drivers/block/loop.c~loop-preallocate-eight-loop-devices drivers/block/loop.c
--- a/drivers/block/loop.c~loop-preallocate-eight-loop-devices
+++ a/drivers/block/loop.c
@@ -1354,7 +1354,7 @@ static struct block_device_operations lo
  */
 static int max_loop;
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
+MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1462,34 +1462,66 @@ static struct kobject *loop_probe(dev_t 
 	return kobj;
 }
 
-static int __init loop_init(void)
-{
-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
-				  THIS_MODULE, loop_probe, NULL, NULL);
-
-	if (max_loop) {
-		printk(KERN_INFO "loop: the max_loop option is obsolete "
-				 "and will be removed in March 2008\n");
-
-	}
-	printk(KERN_INFO "loop: module loaded\n");
-	return 0;
-}
-
 static void __exit loop_exit(void)
 {
+	unsigned long range;
 	struct loop_device *lo, *next;
 
+	range = max_loop ? max_loop :  1UL << MINORBITS;
+
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
 
-	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
+	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
 }
 
+static int __init loop_init(void)
+{
+	int i, nr;
+	unsigned long range;
+
+	/*
+	 * loop module now has a feature to instantiate underlying device
+	 * structure on-demand, provided that there is an access dev node.
+	 * However, this will not work well with user space tool that doesn't
+	 * know about such "feature".  In order to not break any existing
+	 * tool, we do the following:
+	 *
+	 * (1) if max_loop is specified, create that many upfront, and this
+	 *     also becomes a hard limit.
+	 * (2) if max_loop is not specified, create 8 loop device on module
+	 *     load, user can further extend loop device by create dev node
+	 *     themselves and have kernel automatically instantiate actual
+	 *     device on-demand.
+	 */
+	if (max_loop) {
+		nr = max_loop;
+		range = max_loop;
+	} else {
+		nr = 8;
+		range = 1UL << MINORBITS;
+	}
+
+	if (register_blkdev(LOOP_MAJOR, "loop"))
+		return -EIO;
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
+				  THIS_MODULE, loop_probe, NULL, NULL);
+
+	for (i = 0; i < nr; i++) {
+		if (!loop_init_one(i))
+			goto err;
+	}
+
+	printk(KERN_INFO "loop: module loaded\n");
+	return 0;
+err:
+	loop_exit();
+	printk(KERN_INFO "loop: out of memory\n");
+	return -ENOMEM;
+}
+
 module_init(loop_init);
 module_exit(loop_exit);
 
_

Patches currently in -mm which might be from kenchen@google.com are

loop-preallocate-eight-loop-devices.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
