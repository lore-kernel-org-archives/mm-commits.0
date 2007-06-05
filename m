From: akpm@linux-foundation.org
Subject: - partitions-check-the-return-value-of-kobject_add-etc.patch removed from -mm tree
Date: Tue, 05 Jun 2007 00:03:23 -0700
Message-ID: <200706050703.l5573MFB031162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761634AbXFEHDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 03:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, cornelia.huck@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     partitions: check the return value of kobject_add etc
has been removed from the -mm tree.  Its filename was
     partitions-check-the-return-value-of-kobject_add-etc.patch

This patch was dropped because changes in Greg's tree broke it for the 17th time and I'm tired of fixing it

------------------------------------------------------
Subject: partitions: check the return value of kobject_add etc
From: WANG Cong <xiyou.wangcong@gmail.com>

Since kobject_add, sysfs_create_link and sysfs_create_file are marked as
'__must_check', we must always check their return values.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN fs/partitions/check.c~partitions-check-the-return-value-of-kobject_add-etc fs/partitions/check.c
--- a/fs/partitions/check.c~partitions-check-the-return-value-of-kobject_add-etc
+++ a/fs/partitions/check.c
@@ -383,26 +383,41 @@ void add_partition(struct gendisk *disk,
 	p->policy = disk->policy;
 
 	if (isdigit(disk->kobj.name[strlen(disk->kobj.name)-1]))
-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%sp%d",disk->kobj.name,part);
+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%sp%d",
+				disk->kobj.name, part);
 	else
-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%s%d",disk->kobj.name,part);
+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%s%d",
+				disk->kobj.name, part);
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	if (kobject_add(&p->kobj))
+		goto out_put;
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	if (sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem"))
+		goto out_uevent;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		if (sysfs_create_file(&p->kobj, &addpartattr))
+			goto out_link;
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;
+	return;
+
+out_link:
+	sysfs_remove_link(&p->kobj, "subsystem");
+out_uevent:
+	if (!disk->part_uevent_suppress)
+		kobject_uevent(&p->kobj, KOBJ_REMOVE);
+	kobject_del(&p->kobj);
+out_put:
+	kobject_put(&p->kobj);
 }
 
 static char *make_block_name(struct gendisk *disk)
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

partitions-check-the-return-value-of-kobject_add-etc.patch
