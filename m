From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:18:57 -0700
Message-ID: <200804300618.m3U6Ivut031413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbYD3GTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: use MAJOR:MINOR in /sys/class/bdi
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch

This patch was dropped because it was folded into mm-bdi-export-bdi-attributes-in-sysfs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: use MAJOR:MINOR in /sys/class/bdi
From: Miklos Szeredi <mszeredi@suse.cz>

Uniformly use MAJOR:MINOR in /sys/class/bdi/ for both block devices
and non-block device backed filesystems: FUSE and NFS.

Add symlink for block devices:

    /sys/block/<name>/bdi -> /sys/class/bdi/<bdi>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN block/genhd.c~mm-bdi-export-bdi-attributes-in-sysfs-fix-2 block/genhd.c
--- a/block/genhd.c~mm-bdi-export-bdi-attributes-in-sysfs-fix-2
+++ a/block/genhd.c
@@ -182,13 +182,17 @@ static int exact_lock(dev_t devt, void *
  */
 void add_disk(struct gendisk *disk)
 {
+	struct backing_dev_info *bdi;
+
 	disk->flags |= GENHD_FL_UP;
 	blk_register_region(MKDEV(disk->major, disk->first_minor),
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
-	bdi_register(&disk->queue->backing_dev_info, NULL,
-		"blk-%s", disk->disk_name);
+
+	bdi = &disk->queue->backing_dev_info;
+	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
+	sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -196,8 +200,9 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 
 void unlink_gendisk(struct gendisk *disk)
 {
-	blk_unregister_queue(disk);
+	sysfs_remove_link(&disk->dev.kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
+	blk_unregister_queue(disk);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

