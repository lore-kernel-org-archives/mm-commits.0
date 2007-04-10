From: akpm@linux-foundation.org
Subject: + sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:47:50 -0700
Message-ID: <200704102047.l3AKlo7f016953@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030657AbXDJUs0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: reimplement symlink using sysfs_dirent tree
has been added to the -mm tree.  Its filename is
     sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: reimplement symlink using sysfs_dirent tree
From: Tejun Heo <htejun@gmail.com>

sysfs symlink is implemented by referencing dentry and kobject from
sysfs_dirent - symlink entry references kobject, dentry is used to walk the
tree.  This complicates object lifetimes rules and is dangerous - for example,
there is no way to tell to which module the target of a symlink belongs and
referencing that kobject can make it linger after the module is gone.

This patch reimplements symlink using only sysfs_dirent tree.  sd for a
symlink points and holds reference to the target sysfs_dirent and all walking
is done using sysfs_dirent tree.  Simpler and safer.

Please read the following message for more info.

  http://article.gmane.org/gmane.linux.kernel/510293

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c     |    2 
 fs/sysfs/symlink.c |   88 ++++++++++++++++++++++---------------------
 fs/sysfs/sysfs.h   |    9 ++--
 3 files changed, 53 insertions(+), 46 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-reimplement-symlink-using-sysfs_dirent-tree fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-reimplement-symlink-using-sysfs_dirent-tree
+++ a/fs/sysfs/dir.c
@@ -23,7 +23,7 @@ void release_sysfs_dirent(struct sysfs_d
 	parent_sd = sd->s_parent;
 
 	if (sd->s_type & SYSFS_KOBJ_LINK)
-		kobject_put(sd->s_elem.symlink.target_kobj);
+		sysfs_put(sd->s_elem.symlink.target_sd);
 	if (sd->s_type & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
diff -puN fs/sysfs/symlink.c~sysfs-reimplement-symlink-using-sysfs_dirent-tree fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~sysfs-reimplement-symlink-using-sysfs_dirent-tree
+++ a/fs/sysfs/symlink.c
@@ -11,50 +11,49 @@
 
 #include "sysfs.h"
 
-static int object_depth(struct kobject * kobj)
+static int object_depth(struct sysfs_dirent *sd)
 {
-	struct kobject * p = kobj;
 	int depth = 0;
-	do { depth++; } while ((p = p->parent));
+
+	for (; sd->s_parent; sd = sd->s_parent)
+		depth++;
+
 	return depth;
 }
 
-static int object_path_length(struct kobject * kobj)
+static int object_path_length(struct sysfs_dirent * sd)
 {
-	struct kobject * p = kobj;
 	int length = 1;
-	do {
-		length += strlen(kobject_name(p)) + 1;
-		p = p->parent;
-	} while (p);
+
+	for (; sd->s_parent; sd = sd->s_parent)
+		length += strlen(sd->s_name) + 1;
+
 	return length;
 }
 
-static void fill_object_path(struct kobject * kobj, char * buffer, int length)
+static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
 {
-	struct kobject * p;
-
 	--length;
-	for (p = kobj; p; p = p->parent) {
-		int cur = strlen(kobject_name(p));
+	for (; sd->s_parent; sd = sd->s_parent) {
+		int cur = strlen(sd->s_name);
 
 		/* back up enough to print this bus id with '/' */
 		length -= cur;
-		strncpy(buffer + length,kobject_name(p),cur);
+		strncpy(buffer + length, sd->s_name, cur);
 		*(buffer + --length) = '/';
 	}
 }
 
-static int sysfs_add_link(struct dentry * parent, const char * name, struct kobject * target)
+static int sysfs_add_link(struct sysfs_dirent * parent_sd, const char * name,
+			  struct sysfs_dirent * target_sd)
 {
-	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_dirent * sd;
 
 	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		return -ENOMEM;
 
-	sd->s_elem.symlink.target_kobj = kobject_get(target);
+	sd->s_elem.symlink.target_sd = target_sd;
 	sysfs_attach_dirent(sd, parent_sd, NULL);
 	return 0;
 }
@@ -68,6 +67,8 @@ static int sysfs_add_link(struct dentry 
 int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name)
 {
 	struct dentry *dentry = NULL;
+	struct sysfs_dirent *parent_sd = NULL;
+	struct sysfs_dirent *target_sd = NULL;
 	int error = -EEXIST;
 
 	BUG_ON(!name);
@@ -80,11 +81,27 @@ int sysfs_create_link(struct kobject * k
 
 	if (!dentry)
 		return -EFAULT;
+	parent_sd = dentry->d_fsdata;
+
+	/* target->dentry can go away beneath us but is protected with
+	 * kobj_sysfs_assoc_lock.  Fetch target_sd from it.
+	 */
+	spin_lock(&kobj_sysfs_assoc_lock);
+	if (target->dentry)
+		target_sd = sysfs_get(target->dentry->d_fsdata);
+	spin_unlock(&kobj_sysfs_assoc_lock);
+
+	if (!target_sd)
+		return -ENOENT;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	if (!sysfs_dirent_exist(dentry->d_fsdata, name))
-		error = sysfs_add_link(dentry, name, target);
+		error = sysfs_add_link(parent_sd, name, target_sd);
 	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	if (error)
+		sysfs_put(target_sd);
+
 	return error;
 }
 
@@ -100,14 +117,14 @@ void sysfs_remove_link(struct kobject * 
 	sysfs_hash_and_remove(kobj->dentry,name);
 }
 
-static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
-				 char *path)
+static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
+				 struct sysfs_dirent * target_sd, char *path)
 {
 	char * s;
 	int depth, size;
 
-	depth = object_depth(kobj);
-	size = object_path_length(target) + depth * 3 - 1;
+	depth = object_depth(parent_sd);
+	size = object_path_length(target_sd) + depth * 3 - 1;
 	if (size > PATH_MAX)
 		return -ENAMETOOLONG;
 
@@ -116,7 +133,7 @@ static int sysfs_get_target_path(struct 
 	for (s = path; depth--; s += 3)
 		strcpy(s,"../");
 
-	fill_object_path(target, path, size);
+	fill_object_path(target_sd, path, size);
 	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
 
 	return 0;
@@ -124,27 +141,16 @@ static int sysfs_get_target_path(struct 
 
 static int sysfs_getlink(struct dentry *dentry, char * path)
 {
-	struct kobject *kobj, *target_kobj;
-	int error = 0;
-
-	kobj = sysfs_get_kobject(dentry->d_parent);
-	if (!kobj)
-		return -EINVAL;
-
-	target_kobj = sysfs_get_kobject(dentry);
-	if (!target_kobj) {
-		kobject_put(kobj);
-		return -EINVAL;
-	}
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_dirent *parent_sd = sd->s_parent;
+	struct sysfs_dirent *target_sd = sd->s_elem.symlink.target_sd;
+	int error;
 
 	down_read(&sysfs_rename_sem);
-	error = sysfs_get_target_path(kobj, target_kobj, path);
+	error = sysfs_get_target_path(parent_sd, target_sd, path);
 	up_read(&sysfs_rename_sem);
-	
-	kobject_put(kobj);
-	kobject_put(target_kobj);
-	return error;
 
+	return error;
 }
 
 static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
diff -puN fs/sysfs/sysfs.h~sysfs-reimplement-symlink-using-sysfs_dirent-tree fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-reimplement-symlink-using-sysfs_dirent-tree
+++ a/fs/sysfs/sysfs.h
@@ -3,7 +3,7 @@ struct sysfs_elem_dir {
 };
 
 struct sysfs_elem_symlink {
-	struct kobject		* target_kobj;
+	struct sysfs_dirent	* target_sd;
 };
 
 struct sysfs_elem_attr {
@@ -98,10 +98,11 @@ static inline struct kobject *sysfs_get_
 	spin_lock(&dcache_lock);
 	if (!d_unhashed(dentry)) {
 		struct sysfs_dirent * sd = dentry->d_fsdata;
+
 		if (sd->s_type & SYSFS_KOBJ_LINK)
-			kobj = kobject_get(sd->s_elem.symlink.target_kobj);
-		else
-			kobj = kobject_get(sd->s_elem.dir.kobj);
+			sd = sd->s_elem.symlink.target_sd;
+
+		kobj = kobject_get(sd->s_elem.dir.kobj);
 	}
 	spin_unlock(&dcache_lock);
 
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
