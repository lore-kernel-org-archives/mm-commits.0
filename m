From: akpm@osdl.org
Subject: - fix-check_partition-routines.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:46 -0800
Message-ID: <200612072300.kB7N0kgV029670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163839AbWLGXE1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix check_partition routines
has been removed from the -mm tree.  Its filename was
     fix-check_partition-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix check_partition routines
From: Suzuki K P <suzuki@in.ibm.com>

check_partition() stops its probe once it hits an I/O error from the
partition checkers.  This would prevent the actual partition checker
getting a chance to verify the partition.

So this patch lets check_partition() continue probing untill it hits a
success while recording the I/O error which might have been reported by the
checking routines.

Also, it does some cleanup of the partition methods for ibm, atari and
amiga to return -1 upon hitting an I/O error.

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/partitions/amiga.c |    2 ++
 fs/partitions/atari.c |    2 +-
 fs/partitions/check.c |   15 +++++++++++++--
 fs/partitions/ibm.c   |   29 +++++++++++++++++------------
 4 files changed, 33 insertions(+), 15 deletions(-)

diff -puN fs/partitions/amiga.c~fix-check_partition-routines fs/partitions/amiga.c
--- a/fs/partitions/amiga.c~fix-check_partition-routines
+++ a/fs/partitions/amiga.c
@@ -43,6 +43,7 @@ amiga_partition(struct parsed_partitions
 			if (warn_no_part)
 				printk("Dev %s: unable to read RDB block %d\n",
 				       bdevname(bdev, b), blk);
+			res = -1;
 			goto rdb_done;
 		}
 		if (*(__be32 *)data != cpu_to_be32(IDNAME_RIGIDDISK))
@@ -79,6 +80,7 @@ amiga_partition(struct parsed_partitions
 			if (warn_no_part)
 				printk("Dev %s: unable to read partition block %d\n",
 				       bdevname(bdev, b), blk);
+			res = -1;
 			goto rdb_done;
 		}
 		pb  = (struct PartitionBlock *)data;
diff -puN fs/partitions/atari.c~fix-check_partition-routines fs/partitions/atari.c
--- a/fs/partitions/atari.c~fix-check_partition-routines
+++ a/fs/partitions/atari.c
@@ -88,7 +88,7 @@ int atari_partition(struct parsed_partit
 			if (!xrs) {
 				printk (" block %ld read failed\n", partsect);
 				put_dev_sector(sect);
-				return 0;
+				return -1;
 			}
 
 			/* ++roman: sanity check: bit 0 of flg field must be set */
diff -puN fs/partitions/check.c~fix-check_partition-routines fs/partitions/check.c
--- a/fs/partitions/check.c~fix-check_partition-routines
+++ a/fs/partitions/check.c
@@ -153,7 +153,7 @@ static struct parsed_partitions *
 check_partition(struct gendisk *hd, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
-	int i, res;
+	int i, res, err;
 
 	state = kmalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
 	if (!state)
@@ -165,13 +165,24 @@ check_partition(struct gendisk *hd, stru
 		sprintf(state->name, "p");
 
 	state->limit = hd->minors;
-	i = res = 0;
+	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));
 		res = check_part[i++](state, bdev);
+		if (res < 0) {
+			/* We have hit an I/O error which we don't report now.
+		 	* But record it, and let the others do their job.
+		 	*/
+			err = res;
+			res = 0;
+		}
+
 	}
 	if (res > 0)
 		return state;
+	if (!err)
+	/* The partition is unrecognized. So report I/O errors if there were any */
+		res = err;
 	if (!res)
 		printk(" unknown partition table\n");
 	else if (warn_no_part)
diff -puN fs/partitions/ibm.c~fix-check_partition-routines fs/partitions/ibm.c
--- a/fs/partitions/ibm.c~fix-check_partition-routines
+++ a/fs/partitions/ibm.c
@@ -43,7 +43,7 @@ cchhb2blk (struct vtoc_cchhb *ptr, struc
 int
 ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-	int blocksize, offset, size;
+	int blocksize, offset, size,res;
 	loff_t i_size;
 	dasd_information_t *info;
 	struct hd_geometry *geo;
@@ -56,15 +56,16 @@ ibm_partition(struct parsed_partitions *
 	unsigned char *data;
 	Sector sect;
 
+	res = 0;
 	blocksize = bdev_hardsect_size(bdev);
 	if (blocksize <= 0)
-		return 0;
+		goto out_exit;
 	i_size = i_size_read(bdev->bd_inode);
 	if (i_size == 0)
-		return 0;
+		goto out_exit;
 
 	if ((info = kmalloc(sizeof(dasd_information_t), GFP_KERNEL)) == NULL)
-		goto out_noinfo;
+		goto out_exit;
 	if ((geo = kmalloc(sizeof(struct hd_geometry), GFP_KERNEL)) == NULL)
 		goto out_nogeo;
 	if ((label = kmalloc(sizeof(union label_t), GFP_KERNEL)) == NULL)
@@ -72,7 +73,7 @@ ibm_partition(struct parsed_partitions *
 
 	if (ioctl_by_bdev(bdev, BIODASDINFO, (unsigned long)info) != 0 ||
 	    ioctl_by_bdev(bdev, HDIO_GETGEO, (unsigned long)geo) != 0)
-		goto out_noioctl;
+		goto out_freeall;
 
 	/*
 	 * Get volume label, extract name and type.
@@ -92,6 +93,8 @@ ibm_partition(struct parsed_partitions *
 	EBCASC(type, 4);
 	EBCASC(name, 6);
 
+	res = 1;
+
 	/*
 	 * Three different types: CMS1, VOL1 and LNX1/unlabeled
 	 */
@@ -156,6 +159,9 @@ ibm_partition(struct parsed_partitions *
 			counter++;
 			blk++;
 		}
+		if (!data)
+		/* Are we not supposed to report this ? */
+			goto out_readerr;
 	} else {
 		/*
 		 * Old style LNX1 or unlabeled disk
@@ -171,18 +177,17 @@ ibm_partition(struct parsed_partitions *
 	}
 
 	printk("\n");
-	kfree(label);
-	kfree(geo);
-	kfree(info);
-	return 1;
+	goto out_freeall;
+
 
 out_readerr:
-out_noioctl:
+	res = -1;
+out_freeall:
 	kfree(label);
 out_nolab:
 	kfree(geo);
 out_nogeo:
 	kfree(info);
-out_noinfo:
-	return 0;
+out_exit:
+	return res;
 }
_

Patches currently in -mm which might be from suzuki@in.ibm.com are

origin.patch

