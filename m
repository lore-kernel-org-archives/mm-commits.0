From: akpm@linux-foundation.org
Subject: + sysfs-add-sysfs_dirent-s_name.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:47:37 -0700
Message-ID: <200704102047.l3AKliAE016943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44754 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030555AbXDJUsB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: add sysfs_dirent->s_name
has been added to the -mm tree.  Its filename is
     sysfs-add-sysfs_dirent-s_name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: add sysfs_dirent->s_name
From: Tejun Heo <htejun@gmail.com>

Add s_name to sysfs_dirent.  This is to further reduce dependency to the
associated dentry.  Name is copied for directories and symlinks but not for
attributes.

Where possible, name dereferences are converted to use sd->s_name. 
sysfs_symlink->link_name and sysfs_get_name() are unused now and removed.

This change allows symlink to be implemented using sysfs_dirent tree proper,
which is the last remaining dentry-dependent sysfs walk.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c        |   33 +++++++++++++++++++++------------
 fs/sysfs/file.c       |    2 +-
 fs/sysfs/inode.c      |   33 +--------------------------------
 fs/sysfs/symlink.c    |    8 +-------
 fs/sysfs/sysfs.h      |    7 +++----
 include/linux/sysfs.h |    1 +
 6 files changed, 28 insertions(+), 56 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-add-sysfs_dirent-s_name fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-add-sysfs_dirent-s_name
+++ a/fs/sysfs/dir.c
@@ -23,10 +23,11 @@ void release_sysfs_dirent(struct sysfs_d
 
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
 		struct sysfs_symlink * sl = sd->s_element;
-		kfree(sl->link_name);
 		kobject_put(sl->target_kobj);
 		kfree(sl);
 	}
+	if (sd->s_type & SYSFS_COPY_NAME)
+		kfree(sd->s_name);
 	kfree(sd->s_iattr);
 	kmem_cache_free(sysfs_dir_cachep, sd);
 
@@ -51,19 +52,30 @@ static struct dentry_operations sysfs_de
 	.d_iput		= sysfs_d_iput,
 };
 
-struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode, int type)
+struct sysfs_dirent *sysfs_new_dirent(const char *name, void *element,
+				      umode_t mode, int type)
 {
+	char *dup_name = NULL;
 	struct sysfs_dirent * sd;
 
+	if (type & SYSFS_COPY_NAME) {
+		name = dup_name = kstrdup(name, GFP_KERNEL);
+		if (!name)
+			return NULL;
+	}
+
 	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
-	if (!sd)
+	if (!sd) {
+		kfree(dup_name);
 		return NULL;
+	}
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
 
+	sd->s_name = name;
 	sd->s_element = element;
 	sd->s_mode = mode;
 	sd->s_type = type;
@@ -100,8 +112,7 @@ int sysfs_dirent_exist(struct sysfs_dire
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_element) {
-			const unsigned char *existing = sysfs_get_name(sd);
-			if (strcmp(existing, new))
+			if (strcmp(sd->s_name, new))
 				continue;
 			else
 				return -EEXIST;
@@ -155,7 +166,7 @@ static int create_dir(struct kobject *ko
 		goto out_dput;
 
 	error = -ENOMEM;
-	sd = sysfs_new_dirent(kobj, mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(name, kobj, mode, SYSFS_DIR);
 	if (!sd)
 		goto out_drop;
 	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
@@ -280,9 +291,7 @@ static struct dentry * sysfs_lookup(stru
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & SYSFS_NOT_PINNED) {
-			const unsigned char * name = sysfs_get_name(sd);
-
-			if (strcmp(name, dentry->d_name.name))
+			if (strcmp(sd->s_name, dentry->d_name.name))
 				continue;
 
 			if (sd->s_type & SYSFS_KOBJ_LINK)
@@ -472,7 +481,7 @@ static int sysfs_dir_open(struct inode *
 	struct sysfs_dirent * sd;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	sd = sysfs_new_dirent(NULL, 0, 0);
+	sd = sysfs_new_dirent("_DIR_", NULL, 0, 0);
 	if (sd)
 		sysfs_attach_dirent(sd, parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -539,7 +548,7 @@ static int sysfs_readdir(struct file * f
 				if (!next->s_element)
 					continue;
 
-				name = sysfs_get_name(next);
+				name = next->s_name;
 				len = strlen(name);
 				ino = (unsigned long)next;
 
@@ -651,7 +660,7 @@ struct dentry *sysfs_create_shadow_dir(s
 	if (!shadow)
 		goto nomem;
 
-	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
+	sd = sysfs_new_dirent("_SHADOW_", kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
 	/* point to parent_sd but don't attach to it */
diff -puN fs/sysfs/file.c~sysfs-add-sysfs_dirent-s_name fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-add-sysfs_dirent-s_name
+++ a/fs/sysfs/file.c
@@ -484,7 +484,7 @@ int sysfs_add_file(struct dentry * dir, 
 		goto out_unlock;
 	}
 
-	sd = sysfs_new_dirent((void *)attr, mode, type);
+	sd = sysfs_new_dirent(attr->name, (void *)attr, mode, type);
 	if (!sd) {
 		error = -ENOMEM;
 		goto out_unlock;
diff -puN fs/sysfs/inode.c~sysfs-add-sysfs_dirent-s_name fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-add-sysfs_dirent-s_name
+++ a/fs/sysfs/inode.c
@@ -190,37 +190,6 @@ int sysfs_create(struct dentry * dentry,
 	return error;
 }
 
-/*
- * Get the name for corresponding element represented by the given sysfs_dirent
- */
-const unsigned char * sysfs_get_name(struct sysfs_dirent *sd)
-{
-	struct attribute * attr;
-	struct bin_attribute * bin_attr;
-	struct sysfs_symlink  * sl;
-
-	BUG_ON(!sd || !sd->s_element);
-
-	switch (sd->s_type) {
-		case SYSFS_DIR:
-			/* Always have a dentry so use that */
-			return sd->s_dentry->d_name.name;
-
-		case SYSFS_KOBJ_ATTR:
-			attr = sd->s_element;
-			return attr->name;
-
-		case SYSFS_KOBJ_BIN_ATTR:
-			bin_attr = sd->s_element;
-			return bin_attr->attr.name;
-
-		case SYSFS_KOBJ_LINK:
-			sl = sd->s_element;
-			return sl->link_name;
-	}
-	return NULL;
-}
-
 static inline void orphan_all_buffers(struct inode *node)
 {
 	struct sysfs_buffer_collection *set;
@@ -288,7 +257,7 @@ int sysfs_hash_and_remove(struct dentry 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element)
 			continue;
-		if (!strcmp(sysfs_get_name(sd), name)) {
+		if (!strcmp(sd->s_name, name)) {
 			list_del_init(&sd->s_sibling);
 			sysfs_drop_dentry(sd, dir);
 			sysfs_put(sd);
diff -puN fs/sysfs/symlink.c~sysfs-add-sysfs_dirent-s_name fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~sysfs-add-sysfs_dirent-s_name
+++ a/fs/sysfs/symlink.c
@@ -57,14 +57,9 @@ static int sysfs_add_link(struct dentry 
 	if (!sl)
 		goto err_out;
 
-	sl->link_name = kmalloc(strlen(name) + 1, GFP_KERNEL);
-	if (!sl->link_name)
-		goto err_out;
-
-	strcpy(sl->link_name, name);
 	sl->target_kobj = kobject_get(target);
 
-	sd = sysfs_new_dirent(sl, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	sd = sysfs_new_dirent(name, sl, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		goto err_out;
 	sysfs_attach_dirent(sd, parent_sd, NULL);
@@ -74,7 +69,6 @@ static int sysfs_add_link(struct dentry 
  err_out:
 	if (sl) {
 		kobject_put(sl->target_kobj);
-		kfree(sl->link_name);
 		kfree(sl);
 	}
 	return error;
diff -puN fs/sysfs/sysfs.h~sysfs-add-sysfs_dirent-s_name fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-add-sysfs_dirent-s_name
+++ a/fs/sysfs/sysfs.h
@@ -3,6 +3,7 @@ struct sysfs_dirent {
 	struct sysfs_dirent	* s_parent;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
+	const char		* s_name;
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
@@ -20,8 +21,8 @@ extern int sysfs_create(struct dentry *,
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
-extern struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode,
-					     int type);
+extern struct sysfs_dirent *sysfs_new_dirent(const char *name, void *element,
+					     umode_t mode, int type);
 extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
 				struct sysfs_dirent *parent_sd,
 				struct dentry *dentry);
@@ -33,7 +34,6 @@ extern struct sysfs_dirent *sysfs_find(s
 extern int sysfs_create_subdir(struct kobject *, const char *, struct dentry **);
 extern void sysfs_remove_subdir(struct dentry *);
 
-extern const unsigned char * sysfs_get_name(struct sysfs_dirent *sd);
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
@@ -46,7 +46,6 @@ extern const struct inode_operations sys
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
 struct sysfs_symlink {
-	char * link_name;
 	struct kobject * target_kobj;
 };
 
diff -puN include/linux/sysfs.h~sysfs-add-sysfs_dirent-s_name include/linux/sysfs.h
--- a/include/linux/sysfs.h~sysfs-add-sysfs_dirent-s_name
+++ a/include/linux/sysfs.h
@@ -76,6 +76,7 @@ struct sysfs_ops {
 #define SYSFS_KOBJ_BIN_ATTR	0x0008
 #define SYSFS_KOBJ_LINK 	0x0020
 #define SYSFS_NOT_PINNED	(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR | SYSFS_KOBJ_LINK)
+#define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #ifdef CONFIG_SYSFS
 
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
