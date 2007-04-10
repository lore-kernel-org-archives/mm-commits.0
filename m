From: akpm@linux-foundation.org
Subject: + sysfs-move-release_sysfs_dirent-to-dirc.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:47:27 -0700
Message-ID: <200704102047.l3AKlRRu016929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44709 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbXDJUrl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: move release_sysfs_dirent() to dir.c
has been added to the -mm tree.  Its filename is
     sysfs-move-release_sysfs_dirent-to-dirc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: move release_sysfs_dirent() to dir.c
From: Tejun Heo <htejun@gmail.com>

There is no reason this function should be inlined and soon to follow sysfs
object reference simplification will make it heavier.  Move it to dir.c.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c   |   12 ++++++++++++
 fs/sysfs/sysfs.h |   13 +------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-move-release_sysfs_dirent-to-dirc fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-move-release_sysfs_dirent-to-dirc
+++ a/fs/sysfs/dir.c
@@ -14,6 +14,18 @@
 
 DECLARE_RWSEM(sysfs_rename_sem);
 
+void release_sysfs_dirent(struct sysfs_dirent * sd)
+{
+	if (sd->s_type & SYSFS_KOBJ_LINK) {
+		struct sysfs_symlink * sl = sd->s_element;
+		kfree(sl->link_name);
+		kobject_put(sl->target_kobj);
+		kfree(sl);
+	}
+	kfree(sd->s_iattr);
+	kmem_cache_free(sysfs_dir_cachep, sd);
+}
+
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
diff -puN fs/sysfs/sysfs.h~sysfs-move-release_sysfs_dirent-to-dirc fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-move-release_sysfs_dirent-to-dirc
+++ a/fs/sysfs/sysfs.h
@@ -17,6 +17,7 @@ extern void sysfs_delete_inode(struct in
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
+extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
 extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
 				umode_t, int);
@@ -97,18 +98,6 @@ static inline struct kobject *sysfs_get_
 	return kobj;
 }
 
-static inline void release_sysfs_dirent(struct sysfs_dirent * sd)
-{
-	if (sd->s_type & SYSFS_KOBJ_LINK) {
-		struct sysfs_symlink * sl = sd->s_element;
-		kfree(sl->link_name);
-		kobject_put(sl->target_kobj);
-		kfree(sl);
-	}
-	kfree(sd->s_iattr);
-	kmem_cache_free(sysfs_dir_cachep, sd);
-}
-
 static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 {
 	if (sd) {
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
revert-gregkh-driver-sysfs-crash-debugging.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
