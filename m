From: akpm@linux-foundation.org
Subject: - block-ioctlc-and-fs-partition-checkc.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:01 -0700
Message-ID: <200807252302.m6PN21Ml003763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbYGYXGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: draconux@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block/ioctl.c and fs/partition/check.c: check value returned by add_partition()
has been removed from the -mm tree.  Its filename was
     block-ioctlc-and-fs-partition-checkc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/ioctl.c and fs/partition/check.c: check value returned by add_partition()
From: Abdel Benamrouche <draconux@gmail.com>

Now that add_partition() has been aught to propagate errors, let's check them.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioctl.c         |    5 +++--
 fs/partitions/check.c |   10 ++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN block/ioctl.c~block-ioctlc-and-fs-partition-checkc block/ioctl.c
--- a/block/ioctl.c~block-ioctlc-and-fs-partition-checkc
+++ a/block/ioctl.c
@@ -17,6 +17,7 @@ static int blkpg_ioctl(struct block_devi
 	long long start, length;
 	int part;
 	int i;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -61,9 +62,9 @@ static int blkpg_ioctl(struct block_devi
 				}
 			}
 			/* all seems OK */
-			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
+			err = add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
 			mutex_unlock(&bdev->bd_mutex);
-			return 0;
+			return err;
 		case BLKPG_DEL_PARTITION:
 			if (!disk->part[part-1])
 				return -ENXIO;
diff -puN fs/partitions/check.c~block-ioctlc-and-fs-partition-checkc fs/partitions/check.c
--- a/fs/partitions/check.c~block-ioctlc-and-fs-partition-checkc
+++ a/fs/partitions/check.c
@@ -499,10 +499,16 @@ int rescan_partitions(struct gendisk *di
 		if (!size)
 			continue;
 		if (from + size > get_capacity(disk)) {
-			printk(" %s: p%d exceeds device capacity\n",
+			printk(KERN_ERR " %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
+			continue;
+		}
+		res = add_partition(disk, p, from, size, state->parts[p].flags);
+		if (res) {
+			printk(KERN_ERR " %s: p%d could not be added: %d\n",
+				disk->disk_name, p, -res);
+			continue;
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
 			md_autodetect_dev(bdev->bd_dev+p);
_

Patches currently in -mm which might be from draconux@gmail.com are

origin.patch

