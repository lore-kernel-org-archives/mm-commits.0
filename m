From: akpm@linux-foundation.org
Subject: - modify-ramdisk-brd-device-to-be-able-to-manage-partitions.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:04 -0700
Message-ID: <200805010933.m419X4v6031107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296AbYEAJdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Laurent.Vivier@bull.net, jens.axboe@oracle.com, nickpiggin@yahoo.com.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     brd: modify ramdisk device to be able to manage partitions
has been removed from the -mm tree.  Its filename was
     modify-ramdisk-brd-device-to-be-able-to-manage-partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brd: modify ramdisk device to be able to manage partitions
From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch adds partition management for Block RAM Device (BRD).

This patch is done to keep in sync BRD and loop device drivers.

This patch adds a parameter to the module, max_part, to specify
the maximum number of partitions per RAM device.

Example:

# modprobe brd max_part=63
# ls -l /dev/ram*
brw-rw---- 1 root disk 1,   0 2008-04-03 13:39 /dev/ram0
brw-rw---- 1 root disk 1,  64 2008-04-03 13:39 /dev/ram1
brw-rw---- 1 root disk 1, 640 2008-04-03 13:39 /dev/ram10
brw-rw---- 1 root disk 1, 704 2008-04-03 13:39 /dev/ram11
brw-rw---- 1 root disk 1, 768 2008-04-03 13:39 /dev/ram12
brw-rw---- 1 root disk 1, 832 2008-04-03 13:39 /dev/ram13
brw-rw---- 1 root disk 1, 896 2008-04-03 13:39 /dev/ram14
brw-rw---- 1 root disk 1, 960 2008-04-03 13:39 /dev/ram15
brw-rw---- 1 root disk 1, 128 2008-04-03 13:39 /dev/ram2
brw-rw---- 1 root disk 1, 192 2008-04-03 13:39 /dev/ram3
brw-rw---- 1 root disk 1, 256 2008-04-03 13:39 /dev/ram4
brw-rw---- 1 root disk 1, 320 2008-04-03 13:39 /dev/ram5
brw-rw---- 1 root disk 1, 384 2008-04-03 13:39 /dev/ram6
brw-rw---- 1 root disk 1, 448 2008-04-03 13:39 /dev/ram7
brw-rw---- 1 root disk 1, 512 2008-04-03 13:39 /dev/ram8
brw-rw---- 1 root disk 1, 576 2008-04-03 13:39 /dev/ram9
# fdisk /dev/ram0
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel. Changes will remain in memory only,
until you decide to write them. After that, of course, the previous
content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): o
Building a new DOS disklabel. Changes will remain in memory only,
until you decide to write them. After that, of course, the previous
content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-2, default 1): 1
Last cylinder or +size or +sizeM or +sizeK (1-2, default 2): 2

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
# ls -l /dev/ram0*
brw-rw---- 1 root disk 1, 0 2008-04-03 13:40 /dev/ram0
brw-rw---- 1 root disk 1, 1 2008-04-03 13:40 /dev/ram0p1
# mkfs /dev/ram0p1
mke2fs 1.40-WIP (14-Nov-2006)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
4016 inodes, 16032 blocks
801 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=16515072
2 block groups
8192 blocks per group, 8192 fragments per group
2008 inodes per group
Superblock backups stored on blocks:
	8193

Writing inode tables: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 26 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
# mount /dev/ram0p1 /mnt
df /mnt
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/ram0p1              15521       138     14582   1% /mnt
# ls -l /mnt
total 12
drwx------ 2 root root 12288 2008-04-03 13:41 lost+found
# umount /mnt
# rmmod brd

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/block/brd.c~modify-ramdisk-brd-device-to-be-able-to-manage-partitions drivers/block/brd.c
--- a/drivers/block/brd.c~modify-ramdisk-brd-device-to-be-able-to-manage-partitions
+++ a/drivers/block/brd.c
@@ -387,10 +387,14 @@ static struct block_device_operations br
  */
 static int rd_nr;
 int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static int max_part;
+static int part_shift;
 module_param(rd_nr, int, 0);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 module_param(rd_size, int, 0);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
+module_param(max_part, int, 0);
+MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 
@@ -435,11 +439,11 @@ static struct brd_device *brd_alloc(int 
 	blk_queue_max_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
-	disk = brd->brd_disk = alloc_disk(1);
+	disk = brd->brd_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
 	disk->major		= RAMDISK_MAJOR;
-	disk->first_minor	= i;
+	disk->first_minor	= i << part_shift;
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
@@ -523,7 +527,12 @@ static int __init brd_init(void)
 	 *     themselves and have kernel automatically instantiate actual
 	 *     device on-demand.
 	 */
-	if (rd_nr > 1UL << MINORBITS)
+
+	part_shift = 0;
+	if (max_part > 0)
+		part_shift = fls(max_part);
+
+	if (rd_nr > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (rd_nr) {
@@ -531,7 +540,7 @@ static int __init brd_init(void)
 		range = rd_nr;
 	} else {
 		nr = CONFIG_BLK_DEV_RAM_COUNT;
-		range = 1UL << MINORBITS;
+		range = 1UL << (MINORBITS - part_shift);
 	}
 
 	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
@@ -570,7 +579,7 @@ static void __exit brd_exit(void)
 	unsigned long range;
 	struct brd_device *brd, *next;
 
-	range = rd_nr ? rd_nr :  1UL << MINORBITS;
+	range = rd_nr ? rd_nr :  1UL << (MINORBITS - part_shift);
 
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
_

Patches currently in -mm which might be from Laurent.Vivier@bull.net are

origin.patch
git-kvm.patch

