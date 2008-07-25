From: akpm@linux-foundation.org
Subject: - fs-partition-checkc-fix-return-value-warning.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:59 -0700
Message-ID: <200807252301.m6PN1xqw003760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611AbYGYXGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: draconux@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/partition/check.c: fix return value warning
has been removed from the -mm tree.  Its filename was
     fs-partition-checkc-fix-return-value-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partition/check.c: fix return value warning
From: Abdel Benamrouche <draconux@gmail.com>

fs/partitions/check.c:381: warning: ignoring return value of ___device_add___,
  declared with attribute warn_unused_result

[akpm@linux-foundation.org: multiple-return-statements-per-function are evil]
Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |   28 ++++++++++++++++++++++------
 include/linux/genhd.h |    2 +-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff -puN fs/partitions/check.c~fs-partition-checkc-fix-return-value-warning fs/partitions/check.c
--- a/fs/partitions/check.c~fs-partition-checkc-fix-return-value-warning
+++ a/fs/partitions/check.c
@@ -344,18 +344,18 @@ static ssize_t whole_disk_show(struct de
 static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
-void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
+int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
 	int err;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return;
+		return -ENOMEM;
 
 	if (!init_part_stats(p)) {
-		kfree(p);
-		return;
+		err = -ENOMEM;
+		goto out0;
 	}
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -378,15 +378,31 @@ void add_partition(struct gendisk *disk,
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
-	device_add(&p->dev);
+	err = device_add(&p->dev);
+	if (err)
+		goto out1;
 	partition_sysfs_add_subdir(p);
 	p->dev.uevent_suppress = 0;
-	if (flags & ADDPART_FLAG_WHOLEDISK)
+	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		err = device_create_file(&p->dev, &dev_attr_whole_disk);
+		if (err)
+			goto out2;
+	}
 
 	/* suppress uevent if the disk supresses it */
 	if (!disk->dev.uevent_suppress)
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
+
+	return 0;
+
+out2:
+	device_del(&p->dev);
+out1:
+	put_device(&p->dev);
+	free_part_stats(p);
+out0:
+	kfree(p);
+	return err;
 }
 
 /* Not exported, helper to add_disk(). */
diff -puN include/linux/genhd.h~fs-partition-checkc-fix-return-value-warning include/linux/genhd.h
--- a/include/linux/genhd.h~fs-partition-checkc-fix-return-value-warning
+++ a/include/linux/genhd.h
@@ -541,7 +541,7 @@ extern dev_t blk_lookup_devt(const char 
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern int __must_check add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
_

Patches currently in -mm which might be from draconux@gmail.com are

origin.patch

