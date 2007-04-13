From: akpm@linux-foundation.org
Subject: - sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:58 -0700
Message-ID: <200704132328.l3DNSwCU012563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107AbXDMX3U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: flatten cleanup paths in sysfs_add_link() and create_dir()
has been removed from the -mm tree.  Its filename was
     sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: flatten cleanup paths in sysfs_add_link() and create_dir()
From: Tejun Heo <htejun@gmail.com>

Flatten cleanup paths in sysfs_add_link() and create_dir() to improve
readability and ease further changes to these functions.  This is in
preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c     |   73 +++++++++++++++++++++++++------------------
 fs/sysfs/symlink.c |   25 ++++++++------
 2 files changed, 57 insertions(+), 41 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir
+++ a/fs/sysfs/dir.c
@@ -159,40 +159,53 @@ static int init_symlink(struct inode * i
 	return 0;
 }
 
-static int create_dir(struct kobject * k, struct dentry * p,
-		      const char * n, struct dentry ** d)
+static int create_dir(struct kobject *kobj, struct dentry *parent,
+		      const char *name, struct dentry **p_dentry)
 {
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
+	struct dentry *dentry;
+	struct sysfs_dirent *sd;
 
-	mutex_lock(&p->d_inode->i_mutex);
-	*d = lookup_one_len(n, p, strlen(n));
-	if (!IS_ERR(*d)) {
- 		if (sysfs_dirent_exist(p->d_fsdata, n))
-  			error = -EEXIST;
-  		else
-			error = sysfs_make_dirent(p->d_fsdata, *d, k, mode,
-								SYSFS_DIR);
-		if (!error) {
-			error = sysfs_create(*d, mode, init_dir);
-			if (!error) {
-				inc_nlink(p->d_inode);
-				(*d)->d_op = &sysfs_dentry_ops;
-				d_rehash(*d);
-			}
-		}
-		if (error && (error != -EEXIST)) {
-			struct sysfs_dirent *sd = (*d)->d_fsdata;
-			if (sd) {
- 				list_del_init(&sd->s_sibling);
-				sysfs_put(sd);
-			}
-			d_drop(*d);
-		}
-		dput(*d);
-	} else
-		error = PTR_ERR(*d);
-	mutex_unlock(&p->d_inode->i_mutex);
+	mutex_lock(&parent->d_inode->i_mutex);
+
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	error = -EEXIST;
+	if (sysfs_dirent_exist(parent->d_fsdata, name))
+		goto out_dput;
+
+	error = sysfs_make_dirent(parent->d_fsdata, dentry, kobj, mode,
+				  SYSFS_DIR);
+	if (error)
+		goto out_drop;
+
+	error = sysfs_create(dentry, mode, init_dir);
+	if (error)
+		goto out_sput;
+
+	inc_nlink(parent->d_inode);
+	dentry->d_op = &sysfs_dentry_ops;
+	d_rehash(dentry);
+
+	*p_dentry = dentry;
+	error = 0;
+	goto out_dput;
+
+ out_sput:
+	sd = dentry->d_fsdata;
+	list_del_init(&sd->s_sibling);
+	sysfs_put(sd);
+ out_drop:
+	d_drop(dentry);
+ out_dput:
+	dput(dentry);
+ out_unlock:
+	mutex_unlock(&parent->d_inode->i_mutex);
 	return error;
 }
 
diff -puN fs/sysfs/symlink.c~sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir
+++ a/fs/sysfs/symlink.c
@@ -49,30 +49,33 @@ static int sysfs_add_link(struct dentry 
 {
 	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_symlink * sl;
-	int error = 0;
+	int error;
 
 	error = -ENOMEM;
-	sl = kmalloc(sizeof(*sl), GFP_KERNEL);
+	sl = kzalloc(sizeof(*sl), GFP_KERNEL);
 	if (!sl)
-		goto exit1;
+		goto err_out;
 
 	sl->link_name = kmalloc(strlen(name) + 1, GFP_KERNEL);
 	if (!sl->link_name)
-		goto exit2;
+		goto err_out;
 
 	strcpy(sl->link_name, name);
 	sl->target_kobj = kobject_get(target);
 
 	error = sysfs_make_dirent(parent_sd, NULL, sl, S_IFLNK|S_IRWXUGO,
 				SYSFS_KOBJ_LINK);
-	if (!error)
-		return 0;
+	if (error)
+		goto err_out;
+
+	return 0;
 
-	kobject_put(target);
-	kfree(sl->link_name);
-exit2:
-	kfree(sl);
-exit1:
+ err_out:
+	if (sl) {
+		kobject_put(sl->target_kobj);
+		kfree(sl->link_name);
+		kfree(sl);
+	}
 	return error;
 }
 
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
