From: akpm@linux-foundation.org
Subject: - sysfs-implement-kobj_sysfs_assoc_lock.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:11 -0700
Message-ID: <200704132329.l3DNTBaO012583@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161095AbXDMX3X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: implement kobj_sysfs_assoc_lock
has been removed from the -mm tree.  Its filename was
     sysfs-implement-kobj_sysfs_assoc_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: implement kobj_sysfs_assoc_lock
From: Tejun Heo <htejun@gmail.com>

kobj->dentry can go away anytime unless the user controls when the associated
sysfs node is deleted.  This patch implements kobj_sysfs_assoc_lock which
protects kobj->dentry.  This will be used to maintain kobj based API when
converting sysfs to use sysfs_dirent tree instead of dentry/kobject.

Note that this lock belongs to kobject/driver-model not sysfs.  Once sysfs is
converted to not use kobject in its interface, this can be removed from sysfs.

This is in preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c   |    8 +++++++-
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/sysfs/dir.c~sysfs-implement-kobj_sysfs_assoc_lock fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-implement-kobj_sysfs_assoc_lock
+++ a/fs/sysfs/dir.c
@@ -13,6 +13,7 @@
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
+spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 void release_sysfs_dirent(struct sysfs_dirent * sd)
 {
@@ -371,8 +372,13 @@ static void __sysfs_remove_dir(struct de
 
 void sysfs_remove_dir(struct kobject * kobj)
 {
-	__sysfs_remove_dir(kobj->dentry);
+	struct dentry *d = kobj->dentry;
+
+	spin_lock(&kobj_sysfs_assoc_lock);
 	kobj->dentry = NULL;
+	spin_unlock(&kobj_sysfs_assoc_lock);
+
+	__sysfs_remove_dir(d);
 }
 
 int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
diff -puN fs/sysfs/sysfs.h~sysfs-implement-kobj_sysfs_assoc_lock fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-implement-kobj_sysfs_assoc_lock
+++ a/fs/sysfs/sysfs.h
@@ -60,6 +60,7 @@ extern void sysfs_remove_subdir(struct d
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
+extern spinlock_t kobj_sysfs_assoc_lock;
 extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
