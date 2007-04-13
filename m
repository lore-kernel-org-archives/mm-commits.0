From: akpm@linux-foundation.org
Subject: - sysfs-consolidate-sysfs_dirent-creation-functions.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:00 -0700
Message-ID: <200704132329.l3DNT0uS012566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60467 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161113AbXDMX3Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: consolidate sysfs_dirent creation functions
has been removed from the -mm tree.  Its filename was
     sysfs-consolidate-sysfs_dirent-creation-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: consolidate sysfs_dirent creation functions
From: Tejun Heo <htejun@gmail.com>

Currently there are four functions to create sysfs_dirent -
__sysfs_new_dirent(), sysfs_new_dirent(), __sysfs_make_dirent() and
sysfs_make_dirent().  Other than sysfs_make_dirent(), no function has two
users if calls to implement other functions are excluded.

This patch consolidates sysfs_dirent creation functions into the
following two.

* sysfs_new_dirent() : allocate and initialize
* sysfs_attach_dirent() : attach to sysfs_dirent hierarchy and/or
			  associate with dentry

This simplifies interface and gives callers more flexibility.  This is
in preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c     |   82 +++++++++++++------------------------------
 fs/sysfs/file.c    |   21 ++++++++---
 fs/sysfs/symlink.c |    7 ++-
 fs/sysfs/sysfs.h   |    7 ++-
 4 files changed, 50 insertions(+), 67 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-consolidate-sysfs_dirent-creation-functions fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-consolidate-sysfs_dirent-creation-functions
+++ a/fs/sysfs/dir.c
@@ -42,10 +42,7 @@ static struct dentry_operations sysfs_de
 	.d_iput		= sysfs_d_iput,
 };
 
-/*
- * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
- */
-static struct sysfs_dirent * __sysfs_new_dirent(void * element)
+struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode, int type)
 {
 	struct sysfs_dirent * sd;
 
@@ -57,25 +54,25 @@ static struct sysfs_dirent * __sysfs_new
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
+
 	sd->s_element = element;
+	sd->s_mode = mode;
+	sd->s_type = type;
 
 	return sd;
 }
 
-static void __sysfs_list_dirent(struct sysfs_dirent *parent_sd,
-			      struct sysfs_dirent *sd)
+void sysfs_attach_dirent(struct sysfs_dirent *sd,
+			 struct sysfs_dirent *parent_sd, struct dentry *dentry)
 {
-	if (sd)
-		list_add(&sd->s_sibling, &parent_sd->s_children);
-}
+	if (dentry) {
+		sd->s_dentry = dentry;
+		dentry->d_fsdata = sysfs_get(sd);
+		dentry->d_op = &sysfs_dentry_ops;
+	}
 
-static struct sysfs_dirent * sysfs_new_dirent(struct sysfs_dirent *parent_sd,
-						void * element)
-{
-	struct sysfs_dirent *sd;
-	sd = __sysfs_new_dirent(element);
-	__sysfs_list_dirent(parent_sd, sd);
-	return sd;
+	if (parent_sd)
+		list_add(&sd->s_sibling, &parent_sd->s_children);
 }
 
 /*
@@ -103,39 +100,6 @@ int sysfs_dirent_exist(struct sysfs_dire
 	return 0;
 }
 
-
-static struct sysfs_dirent *
-__sysfs_make_dirent(struct dentry *dentry, void *element, mode_t mode, int type)
-{
-	struct sysfs_dirent * sd;
-
-	sd = __sysfs_new_dirent(element);
-	if (!sd)
-		goto out;
-
-	sd->s_mode = mode;
-	sd->s_type = type;
-	sd->s_dentry = dentry;
-	if (dentry) {
-		dentry->d_fsdata = sysfs_get(sd);
-		dentry->d_op = &sysfs_dentry_ops;
-	}
-
-out:
-	return sd;
-}
-
-int sysfs_make_dirent(struct sysfs_dirent * parent_sd, struct dentry * dentry,
-			void * element, umode_t mode, int type)
-{
-	struct sysfs_dirent *sd;
-
-	sd = __sysfs_make_dirent(dentry, element, mode, type);
-	__sysfs_list_dirent(parent_sd, sd);
-
-	return sd ? 0 : -ENOMEM;
-}
-
 static int init_dir(struct inode * inode)
 {
 	inode->i_op = &sysfs_dir_inode_operations;
@@ -179,10 +143,11 @@ static int create_dir(struct kobject *ko
 	if (sysfs_dirent_exist(parent->d_fsdata, name))
 		goto out_dput;
 
-	error = sysfs_make_dirent(parent->d_fsdata, dentry, kobj, mode,
-				  SYSFS_DIR);
-	if (error)
+	error = -ENOMEM;
+	sd = sysfs_new_dirent(kobj, mode, SYSFS_DIR);
+	if (!sd)
 		goto out_drop;
+	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
 
 	error = sysfs_create(dentry, mode, init_dir);
 	if (error)
@@ -197,7 +162,6 @@ static int create_dir(struct kobject *ko
 	goto out_dput;
 
  out_sput:
-	sd = dentry->d_fsdata;
 	list_del_init(&sd->s_sibling);
 	sysfs_put(sd);
  out_drop:
@@ -494,13 +458,16 @@ static int sysfs_dir_open(struct inode *
 {
 	struct dentry * dentry = file->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
+	struct sysfs_dirent * sd;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	file->private_data = sysfs_new_dirent(parent_sd, NULL);
+	sd = sysfs_new_dirent(NULL, 0, 0);
+	if (sd)
+		sysfs_attach_dirent(sd, parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	return file->private_data ? 0 : -ENOMEM;
-
+	file->private_data = sd;
+	return sd ? 0 : -ENOMEM;
 }
 
 static int sysfs_dir_close(struct inode *inode, struct file *file)
@@ -673,9 +640,10 @@ struct dentry *sysfs_create_shadow_dir(s
 	if (!shadow)
 		goto nomem;
 
-	sd = __sysfs_make_dirent(shadow, kobj, inode->i_mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
+	sysfs_attach_dirent(sd, NULL, shadow);
 
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
diff -puN fs/sysfs/file.c~sysfs-consolidate-sysfs_dirent-creation-functions fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-consolidate-sysfs_dirent-creation-functions
+++ a/fs/sysfs/file.c
@@ -474,14 +474,25 @@ int sysfs_add_file(struct dentry * dir, 
 {
 	struct sysfs_dirent * parent_sd = dir->d_fsdata;
 	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
-	int error = -EEXIST;
+	struct sysfs_dirent *sd;
+	int error = 0;
 
 	mutex_lock(&dir->d_inode->i_mutex);
-	if (!sysfs_dirent_exist(parent_sd, attr->name))
-		error = sysfs_make_dirent(parent_sd, NULL, (void *)attr,
-					  mode, type);
-	mutex_unlock(&dir->d_inode->i_mutex);
 
+	if (sysfs_dirent_exist(parent_sd, attr->name)) {
+		error = -EEXIST;
+		goto out_unlock;
+	}
+
+	sd = sysfs_new_dirent((void *)attr, mode, type);
+	if (!sd) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+	sysfs_attach_dirent(sd, parent_sd, NULL);
+
+ out_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 	return error;
 }
 
diff -puN fs/sysfs/symlink.c~sysfs-consolidate-sysfs_dirent-creation-functions fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~sysfs-consolidate-sysfs_dirent-creation-functions
+++ a/fs/sysfs/symlink.c
@@ -49,6 +49,7 @@ static int sysfs_add_link(struct dentry 
 {
 	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_symlink * sl;
+	struct sysfs_dirent * sd;
 	int error;
 
 	error = -ENOMEM;
@@ -63,10 +64,10 @@ static int sysfs_add_link(struct dentry 
 	strcpy(sl->link_name, name);
 	sl->target_kobj = kobject_get(target);
 
-	error = sysfs_make_dirent(parent_sd, NULL, sl, S_IFLNK|S_IRWXUGO,
-				SYSFS_KOBJ_LINK);
-	if (error)
+	sd = sysfs_new_dirent(sl, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	if (!sd)
 		goto err_out;
+	sysfs_attach_dirent(sd, parent_sd, NULL);
 
 	return 0;
 
diff -puN fs/sysfs/sysfs.h~sysfs-consolidate-sysfs_dirent-creation-functions fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-consolidate-sysfs_dirent-creation-functions
+++ a/fs/sysfs/sysfs.h
@@ -19,8 +19,11 @@ extern int sysfs_create(struct dentry *,
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
-extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
-				umode_t, int);
+extern struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode,
+					     int type);
+extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
+				struct sysfs_dirent *parent_sd,
+				struct dentry *dentry);
 
 extern int sysfs_add_file(struct dentry *, const struct attribute *, int);
 extern int sysfs_hash_and_remove(struct dentry * dir, const char * name);
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
