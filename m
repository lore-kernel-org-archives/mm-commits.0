From: akpm@linux-foundation.org
Subject: - nbd-add-partition-support.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:57 -0700
Message-ID: <200804300547.m3U5lv0I029745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760496AbYD3GMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Laurent.Vivier@bull.net, paul.clements@steeleye.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     NBD: add partition support
has been removed from the -mm tree.  Its filename was
     nbd-add-partition-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NBD: add partition support
From: Laurent Vivier <Laurent.Vivier@bull.net>

Permit the use of partitions with network block devices (NBD).

A new parameter is introduced to define how many partition we want to be able
to manage per network block device.  This parameter is "max_part".

For instance, to manage 63 partitions / loop device, we will do:

   [on the server side]
# nbd-server 1234 /dev/sdb
   [on the client side]
# modprobe nbd max_part=63
# ls -l /dev/nbd*
brw-rw---- 1 root disk 43,   0 2008-03-25 11:14 /dev/nbd0
brw-rw---- 1 root disk 43,  64 2008-03-25 11:11 /dev/nbd1
brw-rw---- 1 root disk 43, 640 2008-03-25 11:11 /dev/nbd10
brw-rw---- 1 root disk 43, 704 2008-03-25 11:11 /dev/nbd11
brw-rw---- 1 root disk 43, 768 2008-03-25 11:11 /dev/nbd12
brw-rw---- 1 root disk 43, 832 2008-03-25 11:11 /dev/nbd13
brw-rw---- 1 root disk 43, 896 2008-03-25 11:11 /dev/nbd14
brw-rw---- 1 root disk 43, 960 2008-03-25 11:11 /dev/nbd15
brw-rw---- 1 root disk 43, 128 2008-03-25 11:11 /dev/nbd2
brw-rw---- 1 root disk 43, 192 2008-03-25 11:11 /dev/nbd3
brw-rw---- 1 root disk 43, 256 2008-03-25 11:11 /dev/nbd4
brw-rw---- 1 root disk 43, 320 2008-03-25 11:11 /dev/nbd5
brw-rw---- 1 root disk 43, 384 2008-03-25 11:11 /dev/nbd6
brw-rw---- 1 root disk 43, 448 2008-03-25 11:11 /dev/nbd7
brw-rw---- 1 root disk 43, 512 2008-03-25 11:11 /dev/nbd8
brw-rw---- 1 root disk 43, 576 2008-03-25 11:11 /dev/nbd9
# nbd-client localhost 1234 /dev/nbd0
Negotiation: ..size = 80418240KB
bs=1024, sz=80418240

-------NOTE, RFC: partition table is not automatically read.
The driver sets bdev->bd_invalidated to 1 to force the read of the partition
table of the device, but this is done only on an open of the device.
So we have to do a "touch /dev/nbdX" or something like that.
It can't be done from the nbd-client or nbd driver because at this
level we can't ask to read the partition table and to serve the request
at the same time (-> deadlock)

If someone has a better idea, I'm open to any suggestion.
-------NOTE, RFC

# fdisk -l /dev/nbd0

Disk /dev/nbd0: 82.3 GB, 82348277760 bytes
255 heads, 63 sectors/track, 10011 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

     Device Boot      Start         End      Blocks   Id  System
/dev/nbd0p1   *           1        9965    80043831   83  Linux
/dev/nbd0p2            9966       10011      369495    5  Extended
/dev/nbd0p5            9966       10011      369463+  82  Linux swap / Solaris

# ls -l /dev/nbd0*
brw-rw---- 1 root disk 43,   0 2008-03-25 11:16 /dev/nbd0
brw-rw---- 1 root disk 43,   1 2008-03-25 11:16 /dev/nbd0p1
brw-rw---- 1 root disk 43,   2 2008-03-25 11:16 /dev/nbd0p2
brw-rw---- 1 root disk 43,   5 2008-03-25 11:16 /dev/nbd0p5
# mount /dev/nbd0p1 /mnt
# ls /mnt
bin    dev   initrd      lost+found  opt   sbin     sys  var
boot   etc   initrd.img  media       proc  selinux  tmp  vmlinuz
cdrom  home  lib         mnt         root  srv      usr
# umount /mnt
# nbd-client -d /dev/nbd0
# ls -l /dev/nbd0*
brw-rw---- 1 root disk 43, 0 2008-03-25 11:16 /dev/nbd0
-------NOTE
On "nbd-client -d", we can do an iocl(BLKRRPART) to update partition table:
as the size of the device is 0, we don't have to serve the partition manager
request (-> no deadlock).
-------NOTE

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff -puN drivers/block/nbd.c~nbd-add-partition-support drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-add-partition-support
+++ a/drivers/block/nbd.c
@@ -56,6 +56,7 @@ static unsigned int debugflags;
 
 static unsigned int nbds_max = 16;
 static struct nbd_device *nbd_dev;
+static int max_part;
 
 /*
  * Use just one lock (or at most 1 per NIC). Two arguments for this:
@@ -610,10 +611,13 @@ static int nbd_ioctl(struct inode *inode
 		error = -EINVAL;
 		file = fget(arg);
 		if (file) {
+			struct block_device *bdev = inode->i_bdev;
 			inode = file->f_path.dentry->d_inode;
 			if (S_ISSOCK(inode->i_mode)) {
 				lo->file = file;
 				lo->sock = SOCKET_I(inode);
+				if (max_part > 0)
+					bdev->bd_invalidated = 1;
 				error = 0;
 			} else {
 				fput(file);
@@ -663,6 +667,8 @@ static int nbd_ioctl(struct inode *inode
 		lo->bytesize = 0;
 		inode->i_bdev->bd_inode->i_size = 0;
 		set_capacity(lo->disk, 0);
+		if (max_part > 0)
+			ioctl_by_bdev(inode->i_bdev, BLKRRPART, 0);
 		return lo->harderror;
 	case NBD_CLEAR_QUE:
 		/*
@@ -696,6 +702,7 @@ static int __init nbd_init(void)
 {
 	int err = -ENOMEM;
 	int i;
+	int part_shift;
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
@@ -703,8 +710,17 @@ static int __init nbd_init(void)
 	if (!nbd_dev)
 		return -ENOMEM;
 
+	if (max_part < 0) {
+		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
+		return -EINVAL;
+	}
+
+	part_shift = 0;
+	if (max_part > 0)
+		part_shift = fls(max_part);
+
 	for (i = 0; i < nbds_max; i++) {
-		struct gendisk *disk = alloc_disk(1);
+		struct gendisk *disk = alloc_disk(1 << part_shift);
 		elevator_t *old_e;
 		if (!disk)
 			goto out;
@@ -748,10 +764,9 @@ static int __init nbd_init(void)
 		nbd_dev[i].blksize = 1024;
 		nbd_dev[i].bytesize = 0;
 		disk->major = NBD_MAJOR;
-		disk->first_minor = i;
+		disk->first_minor = i << part_shift;
 		disk->fops = &nbd_fops;
 		disk->private_data = &nbd_dev[i];
-		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 		sprintf(disk->disk_name, "nbd%d", i);
 		set_capacity(disk, 0);
 		add_disk(disk);
@@ -789,7 +804,9 @@ MODULE_DESCRIPTION("Network Block Device
 MODULE_LICENSE("GPL");
 
 module_param(nbds_max, int, 0444);
-MODULE_PARM_DESC(nbds_max, "How many network block devices to initialize.");
+MODULE_PARM_DESC(nbds_max, "number of network block devices to initialize (default: 16)");
+module_param(max_part, int, 0444);
+MODULE_PARM_DESC(max_part, "number of partitions per device (default: 0)");
 #ifndef NDEBUG
 module_param(debugflags, int, 0644);
 MODULE_PARM_DESC(debugflags, "flags for controlling debug output");
_

Patches currently in -mm which might be from Laurent.Vivier@bull.net are

origin.patch
git-kvm.patch
modify-ramdisk-brd-device-to-be-able-to-manage-partitions.patch

