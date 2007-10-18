From: akpm@linux-foundation.org
Subject: - nbd-set-uninitialized-devices-to-size-0.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:22 -0700
Message-ID: <200710180657.l9I6vM1x030810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759259AbXJRHPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     NBD: set uninitialized devices to size 0
has been removed from the -mm tree.  Its filename was
     nbd-set-uninitialized-devices-to-size-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NBD: set uninitialized devices to size 0
From: Paul Clements <paul.clements@steeleye.com>

This fixes errors with utilities (such as LVM's vgscan) that try to scan all
devices.  Previously this would generate read errors when uninitialized nbd
devices were scanned:

# vgscan
   Reading all physical volumes.  This may take a while...
   /dev/nbd0: read failed after 0 of 1024 at 0: Input/output error
   /dev/nbd0: read failed after 0 of 1024 at 509804544: Input/output error
   /dev/nbd0: read failed after 0 of 2048 at 0: Input/output error
   /dev/nbd1: read failed after 0 of 1024 at 509804544: Input/output error
   /dev/nbd1: read failed after 0 of 2048 at 0: Input/output error

 From now on, uninitialized nbd devices will have size zero, which
prevents these errors.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/block/nbd.c~nbd-set-uninitialized-devices-to-size-0 drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-set-uninitialized-devices-to-size-0
+++ a/drivers/block/nbd.c
@@ -578,6 +578,9 @@ static int nbd_ioctl(struct inode *inode
 		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
 		if (file)
 			fput(file);
+		lo->bytesize = 0;
+		inode->i_bdev->bd_inode->i_size = 0;
+		set_capacity(lo->disk, 0);
 		return lo->harderror;
 	case NBD_CLEAR_QUE:
 		/*
@@ -655,14 +658,14 @@ static int __init nbd_init(void)
 		mutex_init(&nbd_dev[i].tx_lock);
 		init_waitqueue_head(&nbd_dev[i].active_wq);
 		nbd_dev[i].blksize = 1024;
-		nbd_dev[i].bytesize = 0x7ffffc00ULL << 10; /* 2TB */
+		nbd_dev[i].bytesize = 0;
 		disk->major = NBD_MAJOR;
 		disk->first_minor = i;
 		disk->fops = &nbd_fops;
 		disk->private_data = &nbd_dev[i];
 		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 		sprintf(disk->disk_name, "nbd%d", i);
-		set_capacity(disk, 0x7ffffc00ULL << 1); /* 2 TB */
+		set_capacity(disk, 0);
 		add_disk(disk);
 	}
 
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

origin.patch
