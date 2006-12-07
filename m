From: akpm@osdl.org
Subject: - fix-rescan_partitions-to-return-errors-properly.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:42 -0800
Message-ID: <200612072300.kB7N0g6w029667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163729AbWLGXBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, erik@harddisk-recovery.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix rescan_partitions to return errors properly
has been removed from the -mm tree.  Its filename was
     fix-rescan_partitions-to-return-errors-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix rescan_partitions to return errors properly
From: Suzuki Kp <suzuki@in.ibm.com>

The current rescan_partition implementation ignores the errors that comes from
the lower layer.  It reports success for unknown partitions as well as I/O
error cases while reading the partition information.

The unknown partition is not (and will not be) considered as an error in the
kernel, since there are legal users of it (e.g, members of a RAID5 MD Device
or a new disk which is not partitioned at all ).  Changing this behaviour
would scare the user about a serious problem with their disk and is not
recommended.  Thus for both "unknown partitions" to the Linux (eg., DEC
VMS,Novell Netware) and the legal users of NULL partition, would still be
reported as "SUCCESS".

The patch attached here, scares the user about something which he does need to
worry about.  i.e, returning -EIO on disk I/O errors while reading the
partition information.

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Cc: Erik Mouw <erik@harddisk-recovery.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/partitions/check.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/partitions/check.c~fix-rescan_partitions-to-return-errors-properly fs/partitions/check.c
--- a/fs/partitions/check.c~fix-rescan_partitions-to-return-errors-properly
+++ a/fs/partitions/check.c
@@ -177,7 +177,7 @@ check_partition(struct gendisk *hd, stru
 	else if (warn_no_part)
 		printk(" unable to read partition table\n");
 	kfree(state);
-	return NULL;
+	return ERR_PTR(res);
 }
 
 /*
@@ -494,6 +494,8 @@ int rescan_partitions(struct gendisk *di
 		disk->fops->revalidate_disk(disk);
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
+	if (IS_ERR(state))	/* I/O error reading the partition table */
+		return PTR_ERR(state);
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
 		sector_t from = state->parts[p].from;
_

Patches currently in -mm which might be from suzuki@in.ibm.com are

origin.patch

