From: akpm@linux-foundation.org
Subject: + block-ioctlc-and-fs-partition-checkc.patch added to -mm tree
Date: Mon, 02 Jun 2008 15:05:48 -0700
Message-ID: <200806022205.m52M5mqw002280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbYFBWHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 18:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: draconux@gmail.com, jens.axboe@oracle.com


The patch titled
     block/ioctl.c and fs/partition/check.c: check value returned by add_partition()
has been added to the -mm tree.  Its filename is
     block-ioctlc-and-fs-partition-checkc.patch

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
Subject: block/ioctl.c and fs/partition/check.c: check value returned by add_partition()
From: Abdel Benamrouche <draconux@gmail.com>

Now that add_partition() has been aught to propagate errors, let's check them.

Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioctl.c         |    5 +++--
 fs/partitions/check.c |    8 +++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

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
@@ -501,8 +501,14 @@ int rescan_partitions(struct gendisk *di
 		if (from + size > get_capacity(disk)) {
 			printk(" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
+			continue;
+		}
+		res = add_partition(disk, p, from, size, state->parts[p].flags);
+		if (res) {
+			printk(" %s: p%d could not be added. got error %d\n",
+				disk->disk_name, p, -res);
+			continue;
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
 			md_autodetect_dev(bdev->bd_dev+p);
_

Patches currently in -mm which might be from draconux@gmail.com are

fs-partition-checkc-fix-return-value-warning-v2.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc.patch

