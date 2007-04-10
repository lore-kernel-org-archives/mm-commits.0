From: akpm@linux-foundation.org
Subject: + sysfs-kill-attribute-file-orphaning.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:47:57 -0700
Message-ID: <200704102047.l3AKlvPf016964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030649AbXDJUsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: kill attribute file orphaning
has been added to the -mm tree.  Its filename is
     sysfs-kill-attribute-file-orphaning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: kill attribute file orphaning
From: Tejun Heo <htejun@gmail.com>

Now that sysfs_dirent can be disconnected from kobject on deletion, there is
no need to orphan each attribute files.  All [bin_]attribute nodes are
automatically orphaned when the parent node is deleted.  Kill attribute file
orphaning.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c  |   65 +++++++++------------------------------------
 fs/sysfs/inode.c |   25 -----------------
 fs/sysfs/mount.c |    8 -----
 fs/sysfs/sysfs.h |   16 -----------
 4 files changed, 13 insertions(+), 101 deletions(-)

diff -puN fs/sysfs/file.c~sysfs-kill-attribute-file-orphaning fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-kill-attribute-file-orphaning
+++ a/fs/sysfs/file.c
@@ -51,29 +51,15 @@ static struct sysfs_ops subsys_sysfs_ops
 	.store	= subsys_attr_store,
 };
 
-/**
- *	add_to_collection - add buffer to a collection
- *	@buffer:	buffer to be added
- *	@node:		inode of set to add to
- */
-
-static inline void
-add_to_collection(struct sysfs_buffer *buffer, struct inode *node)
-{
-	struct sysfs_buffer_collection *set = node->i_private;
-
-	mutex_lock(&node->i_mutex);
-	list_add(&buffer->associates, &set->associates);
-	mutex_unlock(&node->i_mutex);
-}
-
-static inline void
-remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
-{
-	mutex_lock(&node->i_mutex);
-	list_del(&buffer->associates);
-	mutex_unlock(&node->i_mutex);
-}
+struct sysfs_buffer {
+	size_t			count;
+	loff_t			pos;
+	char			* page;
+	struct sysfs_ops	* ops;
+	struct semaphore	sem;
+	int			needs_read_fill;
+	int			event;
+};
 
 /**
  *	fill_read_buffer - allocate and fill buffer from object.
@@ -175,10 +161,7 @@ sysfs_read_file(struct file *file, char 
 
 	down(&buffer->sem);
 	if (buffer->needs_read_fill) {
-		if (buffer->orphaned)
-			retval = -ENODEV;
-		else
-			retval = fill_read_buffer(file->f_path.dentry,buffer);
+		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
 			goto out;
 	}
@@ -276,16 +259,11 @@ sysfs_write_file(struct file *file, cons
 	ssize_t len;
 
 	down(&buffer->sem);
-	if (buffer->orphaned) {
-		len = -ENODEV;
-		goto out;
-	}
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
-out:
 	up(&buffer->sem);
 	return len;
 }
@@ -295,7 +273,6 @@ static int sysfs_open_file(struct inode 
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
-	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
@@ -319,26 +296,14 @@ static int sysfs_open_file(struct inode 
 	else
 		ops = &subsys_sysfs_ops;
 
+	error = -EACCES;
+
 	/* No sysfs operations, either from having no subsystem,
 	 * or the subsystem have no operations.
 	 */
-	error = -EACCES;
 	if (!ops)
 		goto err_mput;
 
-	/* make sure we have a collection to add our buffers to */
-	mutex_lock(&inode->i_mutex);
-	if (!(set = inode->i_private)) {
-		error = -ENOMEM;
-		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL)))
-			goto err_mput;
-		else
-			INIT_LIST_HEAD(&set->associates);
-	}
-	mutex_unlock(&inode->i_mutex);
-
-	error = -EACCES;
-
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
 	 * and we must have a store method.
@@ -365,11 +330,9 @@ static int sysfs_open_file(struct inode 
 	if (!buffer)
 		goto err_mput;
 
-	INIT_LIST_HEAD(&buffer->associates);
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
-	add_to_collection(buffer, inode);
 	file->private_data = buffer;
 
 	/* open succeeded, put active references and pin attr_sd */
@@ -388,10 +351,8 @@ static int sysfs_release(struct inode * 
 {
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
-	struct sysfs_buffer * buffer = filp->private_data;
+	struct sysfs_buffer *buffer = filp->private_data;
 
-	if (buffer)
-		remove_from_collection(buffer, inode);
 	sysfs_put(attr_sd);
 	/* After this point, attr should not be accessed. */
 	module_put(attr->owner);
diff -puN fs/sysfs/inode.c~sysfs-kill-attribute-file-orphaning fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-kill-attribute-file-orphaning
+++ a/fs/sysfs/inode.c
@@ -190,24 +190,6 @@ int sysfs_create(struct dentry * dentry,
 	return error;
 }
 
-static inline void orphan_all_buffers(struct inode *node)
-{
-	struct sysfs_buffer_collection *set;
-	struct sysfs_buffer *buf;
-
-	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
-	set = node->i_private;
-	if (set) {
-		list_for_each_entry(buf, &set->associates, associates) {
-			down(&buf->sem);
-			buf->orphaned = 1;
-			up(&buf->sem);
-		}
-	}
-	mutex_unlock(&node->i_mutex);
-}
-
-
 /*
  * Unhashes the dentry corresponding to given sysfs_dirent
  * Called with parent inode's i_mutex held.
@@ -215,23 +197,16 @@ static inline void orphan_all_buffers(st
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
 	struct dentry * dentry = sd->s_dentry;
-	struct inode *inode;
 
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			inode = dentry->d_inode;
-			spin_lock(&inode->i_lock);
-			__iget(inode);
-			spin_unlock(&inode->i_lock);
 			dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			simple_unlink(parent->d_inode, dentry);
-			orphan_all_buffers(inode);
-			iput(inode);
 		} else {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
diff -puN fs/sysfs/mount.c~sysfs-kill-attribute-file-orphaning fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~sysfs-kill-attribute-file-orphaning
+++ a/fs/sysfs/mount.c
@@ -19,12 +19,9 @@ struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
-static void sysfs_clear_inode(struct inode *inode);
-
 static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= sysfs_delete_inode,
-	.clear_inode	= sysfs_clear_inode,
 };
 
 static struct sysfs_dirent sysfs_root = {
@@ -35,11 +32,6 @@ static struct sysfs_dirent sysfs_root = 
 	.s_iattr	= NULL,
 };
 
-static void sysfs_clear_inode(struct inode *inode)
-{
-	kfree(inode->i_private);
-}
-
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
diff -puN fs/sysfs/sysfs.h~sysfs-kill-attribute-file-orphaning fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-kill-attribute-file-orphaning
+++ a/fs/sysfs/sysfs.h
@@ -75,22 +75,6 @@ extern const struct file_operations bin_
 extern const struct inode_operations sysfs_dir_inode_operations;
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
-struct sysfs_buffer {
-	struct list_head		associates;
-	size_t				count;
-	loff_t				pos;
-	char				* page;
-	struct sysfs_ops		* ops;
-	struct semaphore		sem;
-	int				orphaned;
-	int				needs_read_fill;
-	int				event;
-};
-
-struct sysfs_buffer_collection {
-	struct list_head	associates;
-};
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
