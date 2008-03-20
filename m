From: akpm@linux-foundation.org
Subject: + loop-modify-loop-device-to-be-able-to-manage-partitions-of-the-disk-image.patch added to -mm tree
Date: Thu, 20 Mar 2008 14:51:53 -0700
Message-ID: <200803202151.m2KLpr7A025908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757434AbYCTVxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 17:53:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Laurent.Vivier@bull.net, Andries.Brouwer@cwi.nl, jens.axboe@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     loop: modify loop device to be able to manage partitions of the disk image
has been added to the -mm tree.  Its filename is
     loop-modify-loop-device-to-be-able-to-manage-partitions-of-the-disk-image.patch

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
Subject: loop: modify loop device to be able to manage partitions of the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch allows to use loop device with partitioned disk image.

Original behavior of loop is not modified.

A new parameter is introduced to define how many partition we want to be able
to manage per loop device.  This parameter is "max_part".

For instance, to manage 63 partitions / loop device, we will do:
# modprobe loop max_part=63
# ls -l /dev/loop?*
brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7

And to attach a raw partitionned disk image, the original losetup is used:

# losetup -f etch.img
# ls -l /dev/loop?*
brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
brw-rw---- 1 root disk 7,   1 2008-03-05 14:57 /dev/loop0p1
brw-rw---- 1 root disk 7,   2 2008-03-05 14:57 /dev/loop0p2
brw-rw---- 1 root disk 7,   5 2008-03-05 14:57 /dev/loop0p5
brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
# mount /dev/loop0p1 /mnt
# ls /mnt
bench  cdrom  home        lib         mnt   root     srv  usr
bin    dev    initrd      lost+found  opt   sbin     sys  var
boot   etc    initrd.img  media       proc  selinux  tmp  vmlinuz
# umount /mnt
# losetup -d /dev/loop0

Of course, the same behavior can be done using kpartx on a loop device, but
modifying loop avoids to stack several layers of block device (loop + device
mapper), this is a very light modification (40% of modifications are to manage
the new parameter).

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/block/loop.c~loop-modify-loop-device-to-be-able-to-manage-partitions-of-the-disk-image drivers/block/loop.c
--- a/drivers/block/loop.c~loop-modify-loop-device-to-be-able-to-manage-partitions-of-the-disk-image
+++ a/drivers/block/loop.c
@@ -82,6 +82,9 @@
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
+static int max_part;
+static int part_shift;
+
 /*
  * Transfer functions
  */
@@ -692,6 +695,8 @@ static int loop_change_fd(struct loop_de
 		goto out_putf;
 
 	fput(old_file);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
  out_putf:
@@ -819,6 +824,8 @@ static int loop_set_fd(struct loop_devic
 	}
 	lo->lo_state = Lo_bound;
 	wake_up_process(lo->lo_thread);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
 out_clr:
@@ -919,6 +926,8 @@ static int loop_clr_fd(struct loop_devic
 	fput(filp);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 }
 
@@ -1360,6 +1369,8 @@ static struct block_device_operations lo
 static int max_loop;
 module_param(max_loop, int, 0);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
+module_param(max_part, int, 0);
+MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1412,7 +1423,7 @@ static struct loop_device *loop_alloc(in
 	if (!lo->lo_queue)
 		goto out_free_dev;
 
-	disk = lo->lo_disk = alloc_disk(1);
+	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
 
@@ -1422,7 +1433,7 @@ static struct loop_device *loop_alloc(in
 	init_waitqueue_head(&lo->lo_event);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
-	disk->first_minor	= i;
+	disk->first_minor	= i << part_shift;
 	disk->fops		= &lo_fops;
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
@@ -1502,7 +1513,12 @@ static int __init loop_init(void)
 	 *     themselves and have kernel automatically instantiate actual
 	 *     device on-demand.
 	 */
-	if (max_loop > 1UL << MINORBITS)
+
+	part_shift = 0;
+	if (max_part > 0)
+		part_shift = fls(max_part);
+
+	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (max_loop) {
@@ -1510,7 +1526,7 @@ static int __init loop_init(void)
 		range = max_loop;
 	} else {
 		nr = 8;
-		range = 1UL << MINORBITS;
+		range = 1UL << (MINORBITS - part_shift);
 	}
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
@@ -1549,7 +1565,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << MINORBITS;
+	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
_

Patches currently in -mm which might be from Laurent.Vivier@bull.net are

git-kvm.patch
nbd-allow-nbd-to-be-used-locally.patch
loop-modify-loop-device-to-be-able-to-manage-partitions-of-the-disk-image.patch

