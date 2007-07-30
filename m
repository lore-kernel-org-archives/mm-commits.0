From: akpm@linux-foundation.org
Subject: + fs-partitions-checkc-add-add_partition-error-handling.patch added to -mm tree
Date: Mon, 30 Jul 2007 13:58:39 -0700
Message-ID: <200707302058.l6UKwdo4030183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934884AbXG3U6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 16:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugeneteo@kernel.sg


The patch titled
     fs/partitions/check.c: add add_partition() error handling
has been added to the -mm tree.  Its filename is
     fs-partitions-checkc-add-add_partition-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/partitions/check.c: add add_partition() error handling
From: Eugene Teo <eugeneteo@kernel.sg>

Add error handling to add_partition().  Also fixes these warnings:

fs/partitions/check.c: In function `add_partition':
fs/partitions/check.c:391: warning: ignoring return value of `kobject_add',
	declared with attribute warn_unused_result
fs/partitions/check.c:394: warning: ignoring return value of
	`sysfs_create_link', declared with attribute warn_unused_result
fs/partitions/check.c:401: warning: ignoring return value of
	`sysfs_create_file', declared with attribute warn_unused_result

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff -puN fs/partitions/check.c~fs-partitions-checkc-add-add_partition-error-handling fs/partitions/check.c
--- a/fs/partitions/check.c~fs-partitions-checkc-add-add_partition-error-handling
+++ a/fs/partitions/check.c
@@ -371,6 +371,7 @@ void delete_partition(struct gendisk *di
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
+	int err;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -388,20 +389,34 @@ void add_partition(struct gendisk *disk,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	err = kobject_add(&p->kobj);
+	if (err)
+		goto err_out;
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	err = sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	if (err)
+		goto err_out_del_kobj;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		err = sysfs_create_file(&p->kobj, &addpartattr);
+		if (err)
+			goto err_out_del_link;
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;
+	return;
+
+err_out_del_link:
+	sysfs_remove_link(&p->kobj, "subsystem");
+err_out_del_kobj:
+	kobject_del(&p->kobj);
+err_out:
+	kfree(p);
 }
 
 static char *make_block_name(struct gendisk *disk)
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

arch-i386-kernel-apmc-apm_init-warning-fix.patch
fs-partitions-checkc-add-add_partition-error-handling.patch
