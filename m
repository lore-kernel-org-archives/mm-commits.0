From: akpm@linux-foundation.org
Subject: - uml-fix-hostfs-style.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:10 -0700
Message-ID: <200710162038.l9GKcAwA015419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965818AbXJPVUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix hostfs style
has been removed from the -mm tree.  Its filename was
     uml-fix-hostfs-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix hostfs style
From: Jeff Dike <jdike@addtoit.com>

Style fixes in hostfs.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs.h      |    9 +
 fs/hostfs/hostfs_kern.c |  226 +++++++++++++++++++-------------------
 fs/hostfs/hostfs_user.c |  139 +++++++++++++----------
 3 files changed, 202 insertions(+), 172 deletions(-)

diff -puN fs/hostfs/hostfs.h~uml-fix-hostfs-style fs/hostfs/hostfs.h
--- a/fs/hostfs/hostfs.h~uml-fix-hostfs-style
+++ a/fs/hostfs/hostfs.h
@@ -3,7 +3,8 @@
 
 #include "os.h"
 
-/* These are exactly the same definitions as in fs.h, but the names are
+/*
+ * These are exactly the same definitions as in fs.h, but the names are
  * changed so that this file can be included in both kernel and user files.
  */
 
@@ -21,7 +22,8 @@
 #define HOSTFS_ATTR_FORCE	512	/* Not a change, but a change it */
 #define HOSTFS_ATTR_ATTR_FLAG	1024
 
-/* If you are very careful, you'll notice that these two are missing:
+/*
+ * If you are very careful, you'll notice that these two are missing:
  *
  * #define ATTR_KILL_SUID	2048
  * #define ATTR_KILL_SGID	4096
@@ -76,7 +78,8 @@ extern int make_symlink(const char *from
 extern int unlink_file(const char *file);
 extern int do_mkdir(const char *file, int mode);
 extern int do_rmdir(const char *file);
-extern int do_mknod(const char *file, int mode, unsigned int major, unsigned int minor);
+extern int do_mknod(const char *file, int mode, unsigned int major,
+		    unsigned int minor);
 extern int link_file(const char *from, const char *to);
 extern int do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
diff -puN fs/hostfs/hostfs_kern.c~uml-fix-hostfs-style fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-fix-hostfs-style
+++ a/fs/hostfs/hostfs_kern.c
@@ -6,21 +6,14 @@
  * 2003-02-10 Petr Baudis <pasky@ucw.cz>
  */
 
-#include <linux/stddef.h>
 #include <linux/fs.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/pagemap.h>
-#include <linux/blkdev.h>
-#include <linux/list.h>
 #include <linux/statfs.h>
-#include <linux/kdev_t.h>
-#include <asm/uaccess.h>
 #include "hostfs.h"
-#include "kern_util.h"
-#include "kern.h"
 #include "init.h"
+#include "kern.h"
 
 struct hostfs_inode_info {
 	char *host_filename;
@@ -61,18 +54,18 @@ static int __init hostfs_args(char *opti
 	char *ptr;
 
 	ptr = strchr(options, ',');
-	if(ptr != NULL)
+	if (ptr != NULL)
 		*ptr++ = '\0';
-	if(*options != '\0')
+	if (*options != '\0')
 		root_ino = options;
 
 	options = ptr;
-	while(options){
+	while (options) {
 		ptr = strchr(options, ',');
-		if(ptr != NULL)
+		if (ptr != NULL)
 			*ptr++ = '\0';
-		if(*options != '\0'){
-			if(!strcmp(options, "append"))
+		if (*options != '\0') {
+			if (!strcmp(options, "append"))
 				append = 1;
 			else printf("hostfs_args - unsupported option - %s\n",
 				    options);
@@ -102,7 +95,7 @@ static char *dentry_name(struct dentry *
 
 	len = 0;
 	parent = dentry;
-	while(parent->d_parent != parent){
+	while (parent->d_parent != parent) {
 		len += parent->d_name.len + 1;
 		parent = parent->d_parent;
 	}
@@ -110,12 +103,12 @@ static char *dentry_name(struct dentry *
 	root = HOSTFS_I(parent->d_inode)->host_filename;
 	len += strlen(root);
 	name = kmalloc(len + extra + 1, GFP_KERNEL);
-	if(name == NULL)
+	if (name == NULL)
 		return NULL;
 
 	name[len] = '\0';
 	parent = dentry;
-	while(parent->d_parent != parent){
+	while (parent->d_parent != parent) {
 		len -= parent->d_name.len + 1;
 		name[len] = '/';
 		strncpy(&name[len + 1], parent->d_name.name,
@@ -136,7 +129,8 @@ static char *inode_name(struct inode *in
 
 static int read_name(struct inode *ino, char *name)
 {
-	/* The non-int inode fields are copied into ints by stat_file and
+	/*
+	 * The non-int inode fields are copied into ints by stat_file and
 	 * then copied into the inode because passing the actual pointers
 	 * in and having them treated as int * breaks on big-endian machines
 	 */
@@ -149,7 +143,7 @@ static int read_name(struct inode *ino, 
 	err = stat_file(name, &i_ino, &i_mode, &i_nlink, &ino->i_uid,
 			&ino->i_gid, &i_size, &ino->i_atime, &ino->i_mtime,
 			&ino->i_ctime, &i_blksize, &i_blocks, -1);
-	if(err)
+	if (err)
 		return err;
 
 	ino->i_ino = i_ino;
@@ -166,33 +160,33 @@ static char *follow_link(char *link)
 	char *name, *resolved, *end;
 
 	len = 64;
-	while(1){
+	while (1) {
 		n = -ENOMEM;
 		name = kmalloc(len, GFP_KERNEL);
-		if(name == NULL)
+		if (name == NULL)
 			goto out;
 
 		n = do_readlink(link, name, len);
-		if(n < len)
+		if (n < len)
 			break;
 		len *= 2;
 		kfree(name);
 	}
-	if(n < 0)
+	if (n < 0)
 		goto out_free;
 
-	if(*name == '/')
+	if (*name == '/')
 		return name;
 
 	end = strrchr(link, '/');
-	if(end == NULL)
+	if (end == NULL)
 		return name;
 
 	*(end + 1) = '\0';
 	len = strlen(link) + strlen(name) + 1;
 
 	resolved = kmalloc(len, GFP_KERNEL);
-	if(resolved == NULL){
+	if (resolved == NULL) {
 		n = -ENOMEM;
 		goto out_free;
 	}
@@ -213,20 +207,21 @@ static int read_inode(struct inode *ino)
 	char *name;
 	int err = 0;
 
-	/* Unfortunately, we are called from iget() when we don't have a dentry
+	/*
+	 * Unfortunately, we are called from iget() when we don't have a dentry
 	 * allocated yet.
 	 */
-	if(list_empty(&ino->i_dentry))
+	if (list_empty(&ino->i_dentry))
 		goto out;
 
 	err = -ENOMEM;
 	name = inode_name(ino, 0);
-	if(name == NULL)
+	if (name == NULL)
 		goto out;
 
-	if(file_type(name, NULL, NULL) == OS_TYPE_SYMLINK){
+	if (file_type(name, NULL, NULL) == OS_TYPE_SYMLINK) {
 		name = follow_link(name);
-		if(IS_ERR(name)){
+		if (IS_ERR(name)) {
 			err = PTR_ERR(name);
 			goto out;
 		}
@@ -240,7 +235,8 @@ static int read_inode(struct inode *ino)
 
 int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 {
-	/* do_statfs uses struct statfs64 internally, but the linux kernel
+	/*
+	 * do_statfs uses struct statfs64 internally, but the linux kernel
 	 * struct statfs still has 32-bit versions for most of these fields,
 	 * so we convert them here
 	 */
@@ -255,7 +251,7 @@ int hostfs_statfs(struct dentry *dentry,
 			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
 			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
 			&sf->f_namelen, sf->f_spare);
-	if(err)
+	if (err)
 		return err;
 	sf->f_blocks = f_blocks;
 	sf->f_bfree = f_bfree;
@@ -271,7 +267,7 @@ static struct inode *hostfs_alloc_inode(
 	struct hostfs_inode_info *hi;
 
 	hi = kmalloc(sizeof(*hi), GFP_KERNEL);
-	if(hi == NULL)
+	if (hi == NULL)
 		return NULL;
 
 	*hi = ((struct hostfs_inode_info) { .host_filename	= NULL,
@@ -284,7 +280,7 @@ static struct inode *hostfs_alloc_inode(
 static void hostfs_delete_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	if(HOSTFS_I(inode)->fd != -1) {
+	if (HOSTFS_I(inode)->fd != -1) {
 		close_file(&HOSTFS_I(inode)->fd);
 		HOSTFS_I(inode)->fd = -1;
 	}
@@ -295,9 +291,11 @@ static void hostfs_destroy_inode(struct 
 {
 	kfree(HOSTFS_I(inode)->host_filename);
 
-	/*XXX: This should not happen, probably. The check is here for
-	 * additional safety.*/
-	if(HOSTFS_I(inode)->fd != -1) {
+	/*
+	 * XXX: This should not happen, probably. The check is here for
+	 * additional safety.
+	 */
+	if (HOSTFS_I(inode)->fd != -1) {
 		close_file(&HOSTFS_I(inode)->fd);
 		printk(KERN_DEBUG "Closing host fd in .destroy_inode\n");
 	}
@@ -327,17 +325,17 @@ int hostfs_readdir(struct file *file, vo
 	int error, len;
 
 	name = dentry_name(file->f_path.dentry, 0);
-	if(name == NULL)
+	if (name == NULL)
 		return -ENOMEM;
 	dir = open_dir(name, &error);
 	kfree(name);
-	if(dir == NULL)
+	if (dir == NULL)
 		return -error;
 	next = file->f_pos;
-	while((name = read_dir(dir, &next, &ino, &len)) != NULL){
+	while ((name = read_dir(dir, &next, &ino, &len)) != NULL) {
 		error = (*filldir)(ent, name, len, file->f_pos,
 				   ino, DT_UNKNOWN);
-		if(error) break;
+		if (error) break;
 		file->f_pos = next;
 	}
 	close_dir(dir);
@@ -350,32 +348,33 @@ int hostfs_file_open(struct inode *ino, 
 	int mode = 0, r = 0, w = 0, fd;
 
 	mode = file->f_mode & (FMODE_READ | FMODE_WRITE);
-	if((mode & HOSTFS_I(ino)->mode) == mode)
+	if ((mode & HOSTFS_I(ino)->mode) == mode)
 		return 0;
 
-	/* The file may already have been opened, but with the wrong access,
+	/*
+	 * The file may already have been opened, but with the wrong access,
 	 * so this resets things and reopens the file with the new access.
 	 */
-	if(HOSTFS_I(ino)->fd != -1){
+	if (HOSTFS_I(ino)->fd != -1) {
 		close_file(&HOSTFS_I(ino)->fd);
 		HOSTFS_I(ino)->fd = -1;
 	}
 
 	HOSTFS_I(ino)->mode |= mode;
-	if(HOSTFS_I(ino)->mode & FMODE_READ)
+	if (HOSTFS_I(ino)->mode & FMODE_READ)
 		r = 1;
-	if(HOSTFS_I(ino)->mode & FMODE_WRITE)
+	if (HOSTFS_I(ino)->mode & FMODE_WRITE)
 		w = 1;
-	if(w)
+	if (w)
 		r = 1;
 
 	name = dentry_name(file->f_path.dentry, 0);
-	if(name == NULL)
+	if (name == NULL)
 		return -ENOMEM;
 
 	fd = open_file(name, r, w, append);
 	kfree(name);
-	if(fd < 0)
+	if (fd < 0)
 		return fd;
 	FILE_HOSTFS_I(file)->fd = fd;
 
@@ -423,7 +422,7 @@ int hostfs_writepage(struct page *page, 
 	base = ((unsigned long long) page->index) << PAGE_CACHE_SHIFT;
 
 	err = write_file(HOSTFS_I(inode)->fd, &base, buffer, count);
-	if(err != count){
+	if (err != count) {
 		ClearPageUptodate(page);
 		goto out;
 	}
@@ -452,7 +451,8 @@ int hostfs_readpage(struct file *file, s
 	buffer = kmap(page);
 	err = read_file(FILE_HOSTFS_I(file)->fd, &start, buffer,
 			PAGE_CACHE_SIZE);
-	if(err < 0) goto out;
+	if (err < 0)
+		goto out;
 
 	memset(&buffer[err], 0, PAGE_CACHE_SIZE - err);
 
@@ -494,7 +494,8 @@ int hostfs_write_end(struct file *file, 
 	if (!PageUptodate(page) && err == PAGE_CACHE_SIZE)
 		SetPageUptodate(page);
 
-	/* If err > 0, write_file has added err to pos, so we are comparing
+	/*
+	 * If err > 0, write_file has added err to pos, so we are comparing
 	 * i_size against the last byte written.
 	 */
 	if (err > 0 && (pos > inode->i_size))
@@ -520,28 +521,28 @@ static int init_inode(struct inode *inod
 	int maj, min;
 	dev_t rdev = 0;
 
-	if(dentry){
+	if (dentry) {
 		name = dentry_name(dentry, 0);
-		if(name == NULL)
+		if (name == NULL)
 			goto out;
 		type = file_type(name, &maj, &min);
-		/*Reencode maj and min with the kernel encoding.*/
+		/* Reencode maj and min with the kernel encoding.*/
 		rdev = MKDEV(maj, min);
 		kfree(name);
 	}
 	else type = OS_TYPE_DIR;
 
 	err = 0;
-	if(type == OS_TYPE_SYMLINK)
+	if (type == OS_TYPE_SYMLINK)
 		inode->i_op = &page_symlink_inode_operations;
-	else if(type == OS_TYPE_DIR)
+	else if (type == OS_TYPE_DIR)
 		inode->i_op = &hostfs_dir_iops;
 	else inode->i_op = &hostfs_iops;
 
-	if(type == OS_TYPE_DIR) inode->i_fop = &hostfs_dir_fops;
+	if (type == OS_TYPE_DIR) inode->i_fop = &hostfs_dir_fops;
 	else inode->i_fop = &hostfs_file_fops;
 
-	if(type == OS_TYPE_SYMLINK)
+	if (type == OS_TYPE_SYMLINK)
 		inode->i_mapping->a_ops = &hostfs_link_aops;
 	else inode->i_mapping->a_ops = &hostfs_aops;
 
@@ -564,7 +565,7 @@ static int init_inode(struct inode *inod
 }
 
 int hostfs_create(struct inode *dir, struct dentry *dentry, int mode,
-                 struct nameidata *nd)
+		  struct nameidata *nd)
 {
 	struct inode *inode;
 	char *name;
@@ -572,27 +573,28 @@ int hostfs_create(struct inode *dir, str
 
 	error = -ENOMEM;
 	inode = iget(dir->i_sb, 0);
-	if(inode == NULL) goto out;
+	if (inode == NULL)
+		goto out;
 
 	error = init_inode(inode, dentry);
-	if(error)
+	if (error)
 		goto out_put;
 
 	error = -ENOMEM;
 	name = dentry_name(dentry, 0);
-	if(name == NULL)
+	if (name == NULL)
 		goto out_put;
 
 	fd = file_create(name,
 			 mode & S_IRUSR, mode & S_IWUSR, mode & S_IXUSR,
 			 mode & S_IRGRP, mode & S_IWGRP, mode & S_IXGRP,
 			 mode & S_IROTH, mode & S_IWOTH, mode & S_IXOTH);
-	if(fd < 0)
+	if (fd < 0)
 		error = fd;
 	else error = read_name(inode, name);
 
 	kfree(name);
-	if(error)
+	if (error)
 		goto out_put;
 
 	HOSTFS_I(inode)->fd = fd;
@@ -615,25 +617,25 @@ struct dentry *hostfs_lookup(struct inod
 
 	err = -ENOMEM;
 	inode = iget(ino->i_sb, 0);
-	if(inode == NULL)
+	if (inode == NULL)
 		goto out;
 
 	err = init_inode(inode, dentry);
-	if(err)
+	if (err)
 		goto out_put;
 
 	err = -ENOMEM;
 	name = dentry_name(dentry, 0);
-	if(name == NULL)
+	if (name == NULL)
 		goto out_put;
 
 	err = read_name(inode, name);
 	kfree(name);
-	if(err == -ENOENT){
+	if (err == -ENOENT) {
 		iput(inode);
 		inode = NULL;
 	}
-	else if(err)
+	else if (err)
 		goto out_put;
 
 	d_add(dentry, inode);
@@ -652,7 +654,7 @@ static char *inode_dentry_name(struct in
 	int len;
 
 	file = inode_name(ino, dentry->d_name.len + 1);
-	if(file == NULL)
+	if (file == NULL)
 		return NULL;
 	strcat(file, "/");
 	len = strlen(file);
@@ -666,10 +668,10 @@ int hostfs_link(struct dentry *to, struc
 	char *from_name, *to_name;
 	int err;
 
-	if((from_name = inode_dentry_name(ino, from)) == NULL)
+	if ((from_name = inode_dentry_name(ino, from)) == NULL)
 		return -ENOMEM;
 	to_name = dentry_name(to, 0);
-	if(to_name == NULL){
+	if (to_name == NULL) {
 		kfree(from_name);
 		return -ENOMEM;
 	}
@@ -684,9 +686,9 @@ int hostfs_unlink(struct inode *ino, str
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL)
+	if ((file = inode_dentry_name(ino, dentry)) == NULL)
 		return -ENOMEM;
-	if(append)
+	if (append)
 		return -EPERM;
 
 	err = unlink_file(file);
@@ -699,7 +701,7 @@ int hostfs_symlink(struct inode *ino, st
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL)
+	if ((file = inode_dentry_name(ino, dentry)) == NULL)
 		return -ENOMEM;
 	err = make_symlink(file, to);
 	kfree(file);
@@ -711,7 +713,7 @@ int hostfs_mkdir(struct inode *ino, stru
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL)
+	if ((file = inode_dentry_name(ino, dentry)) == NULL)
 		return -ENOMEM;
 	err = do_mkdir(file, mode);
 	kfree(file);
@@ -723,7 +725,7 @@ int hostfs_rmdir(struct inode *ino, stru
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL)
+	if ((file = inode_dentry_name(ino, dentry)) == NULL)
 		return -ENOMEM;
 	err = do_rmdir(file);
 	kfree(file);
@@ -737,26 +739,26 @@ int hostfs_mknod(struct inode *dir, stru
 	int err = -ENOMEM;
 
 	inode = iget(dir->i_sb, 0);
-	if(inode == NULL)
+	if (inode == NULL)
 		goto out;
 
 	err = init_inode(inode, dentry);
-	if(err)
+	if (err)
 		goto out_put;
 
 	err = -ENOMEM;
 	name = dentry_name(dentry, 0);
-	if(name == NULL)
+	if (name == NULL)
 		goto out_put;
 
 	init_special_inode(inode, mode, dev);
 	err = do_mknod(name, mode, MAJOR(dev), MINOR(dev));
-	if(err)
+	if (err)
 		goto out_free;
 
 	err = read_name(inode, name);
 	kfree(name);
-	if(err)
+	if (err)
 		goto out_put;
 
 	d_instantiate(dentry, inode);
@@ -776,9 +778,9 @@ int hostfs_rename(struct inode *from_ino
 	char *from_name, *to_name;
 	int err;
 
-	if((from_name = inode_dentry_name(from_ino, from)) == NULL)
+	if ((from_name = inode_dentry_name(from_ino, from)) == NULL)
 		return -ENOMEM;
-	if((to_name = inode_dentry_name(to_ino, to)) == NULL){
+	if ((to_name = inode_dentry_name(to_ino, to)) == NULL) {
 		kfree(from_name);
 		return -ENOMEM;
 	}
@@ -801,12 +803,12 @@ int hostfs_permission(struct inode *ino,
 		return -ENOMEM;
 
 	if (S_ISCHR(ino->i_mode) || S_ISBLK(ino->i_mode) ||
-			S_ISFIFO(ino->i_mode) || S_ISSOCK(ino->i_mode))
+	    S_ISFIFO(ino->i_mode) || S_ISSOCK(ino->i_mode))
 		err = 0;
 	else
 		err = access_file(name, r, w, x);
 	kfree(name);
-	if(!err)
+	if (!err)
 		err = generic_permission(ino, desired, NULL);
 	return err;
 }
@@ -823,50 +825,50 @@ int hostfs_setattr(struct dentry *dentry
 	if (err)
 		return err;
 
-	if(append)
+	if (append)
 		attr->ia_valid &= ~ATTR_SIZE;
 
 	attrs.ia_valid = 0;
-	if(attr->ia_valid & ATTR_MODE){
+	if (attr->ia_valid & ATTR_MODE) {
 		attrs.ia_valid |= HOSTFS_ATTR_MODE;
 		attrs.ia_mode = attr->ia_mode;
 	}
-	if(attr->ia_valid & ATTR_UID){
+	if (attr->ia_valid & ATTR_UID) {
 		attrs.ia_valid |= HOSTFS_ATTR_UID;
 		attrs.ia_uid = attr->ia_uid;
 	}
-	if(attr->ia_valid & ATTR_GID){
+	if (attr->ia_valid & ATTR_GID) {
 		attrs.ia_valid |= HOSTFS_ATTR_GID;
 		attrs.ia_gid = attr->ia_gid;
 	}
-	if(attr->ia_valid & ATTR_SIZE){
+	if (attr->ia_valid & ATTR_SIZE) {
 		attrs.ia_valid |= HOSTFS_ATTR_SIZE;
 		attrs.ia_size = attr->ia_size;
 	}
-	if(attr->ia_valid & ATTR_ATIME){
+	if (attr->ia_valid & ATTR_ATIME) {
 		attrs.ia_valid |= HOSTFS_ATTR_ATIME;
 		attrs.ia_atime = attr->ia_atime;
 	}
-	if(attr->ia_valid & ATTR_MTIME){
+	if (attr->ia_valid & ATTR_MTIME) {
 		attrs.ia_valid |= HOSTFS_ATTR_MTIME;
 		attrs.ia_mtime = attr->ia_mtime;
 	}
-	if(attr->ia_valid & ATTR_CTIME){
+	if (attr->ia_valid & ATTR_CTIME) {
 		attrs.ia_valid |= HOSTFS_ATTR_CTIME;
 		attrs.ia_ctime = attr->ia_ctime;
 	}
-	if(attr->ia_valid & ATTR_ATIME_SET){
+	if (attr->ia_valid & ATTR_ATIME_SET) {
 		attrs.ia_valid |= HOSTFS_ATTR_ATIME_SET;
 	}
-	if(attr->ia_valid & ATTR_MTIME_SET){
+	if (attr->ia_valid & ATTR_MTIME_SET) {
 		attrs.ia_valid |= HOSTFS_ATTR_MTIME_SET;
 	}
 	name = dentry_name(dentry, 0);
-	if(name == NULL)
+	if (name == NULL)
 		return -ENOMEM;
 	err = set_attr(name, &attrs, fd);
 	kfree(name);
-	if(err)
+	if (err)
 		return err;
 
 	return inode_setattr(dentry->d_inode, attr);
@@ -906,13 +908,13 @@ int hostfs_link_readpage(struct file *fi
 
 	buffer = kmap(page);
 	name = inode_name(page->mapping->host, 0);
-	if(name == NULL)
+	if (name == NULL)
 		return -ENOMEM;
 	err = do_readlink(name, buffer, PAGE_CACHE_SIZE);
 	kfree(name);
-	if(err == PAGE_CACHE_SIZE)
+	if (err == PAGE_CACHE_SIZE)
 		err = -E2BIG;
-	else if(err > 0){
+	else if (err > 0) {
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		if (PageError(page)) ClearPageError(page);
@@ -945,31 +947,33 @@ static int hostfs_fill_sb_common(struct 
 	err = -ENOMEM;
 	host_root_path = kmalloc(strlen(root_ino) + 1
 				 + strlen(req_root) + 1, GFP_KERNEL);
-	if(host_root_path == NULL)
+	if (host_root_path == NULL)
 		goto out;
 
 	sprintf(host_root_path, "%s/%s", root_ino, req_root);
 
 	root_inode = iget(sb, 0);
-	if(root_inode == NULL)
+	if (root_inode == NULL)
 		goto out_free;
 
 	err = init_inode(root_inode, NULL);
-	if(err)
+	if (err)
 		goto out_put;
 
 	HOSTFS_I(root_inode)->host_filename = host_root_path;
-	/* Avoid that in the error path, iput(root_inode) frees again
-	 * host_root_path through hostfs_destroy_inode! */
+	/*
+	 * Avoid that in the error path, iput(root_inode) frees again
+	 * host_root_path through hostfs_destroy_inode!
+	 */
 	host_root_path = NULL;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
-	if(sb->s_root == NULL)
+	if (sb->s_root == NULL)
 		goto out_put;
 
 	err = read_inode(root_inode);
-	if(err){
+	if (err) {
 		/* No iput in this case because the dput does that for us */
 		dput(sb->s_root);
 		sb->s_root = NULL;
diff -puN fs/hostfs/hostfs_user.c~uml-fix-hostfs-style fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~uml-fix-hostfs-style
+++ a/fs/hostfs/hostfs_user.c
@@ -3,19 +3,21 @@
  * Licensed under the GPL
  */
 
-#include <unistd.h>
 #include <stdio.h>
-#include <fcntl.h>
+#include <stddef.h>
+#include <unistd.h>
 #include <dirent.h>
 #include <errno.h>
-#include <utime.h>
+#include <fcntl.h>
 #include <string.h>
 #include <sys/stat.h>
 #include <sys/time.h>
+#include <sys/types.h>
 #include <sys/vfs.h>
 #include "hostfs.h"
-#include "kern_util.h"
+#include "os.h"
 #include "user.h"
+#include <utime.h>
 
 int stat_file(const char *path, unsigned long long *inode_out, int *mode_out,
 	      int *nlink_out, int *uid_out, int *gid_out,
@@ -25,33 +27,41 @@ int stat_file(const char *path, unsigned
 {
 	struct stat64 buf;
 
-	if(fd >= 0) {
+	if (fd >= 0) {
 		if (fstat64(fd, &buf) < 0)
 			return -errno;
-	} else if(lstat64(path, &buf) < 0) {
+	} else if (lstat64(path, &buf) < 0) {
 		return -errno;
 	}
 
-	if(inode_out != NULL) *inode_out = buf.st_ino;
-	if(mode_out != NULL) *mode_out = buf.st_mode;
-	if(nlink_out != NULL) *nlink_out = buf.st_nlink;
-	if(uid_out != NULL) *uid_out = buf.st_uid;
-	if(gid_out != NULL) *gid_out = buf.st_gid;
-	if(size_out != NULL) *size_out = buf.st_size;
-	if(atime_out != NULL) {
+	if (inode_out != NULL)
+		*inode_out = buf.st_ino;
+	if (mode_out != NULL)
+		*mode_out = buf.st_mode;
+	if (nlink_out != NULL)
+		*nlink_out = buf.st_nlink;
+	if (uid_out != NULL)
+		*uid_out = buf.st_uid;
+	if (gid_out != NULL)
+		*gid_out = buf.st_gid;
+	if (size_out != NULL)
+		*size_out = buf.st_size;
+	if (atime_out != NULL) {
 		atime_out->tv_sec = buf.st_atime;
 		atime_out->tv_nsec = 0;
 	}
-	if(mtime_out != NULL) {
+	if (mtime_out != NULL) {
 		mtime_out->tv_sec = buf.st_mtime;
 		mtime_out->tv_nsec = 0;
 	}
-	if(ctime_out != NULL) {
+	if (ctime_out != NULL) {
 		ctime_out->tv_sec = buf.st_ctime;
 		ctime_out->tv_nsec = 0;
 	}
-	if(blksize_out != NULL) *blksize_out = buf.st_blksize;
-	if(blocks_out != NULL) *blocks_out = buf.st_blocks;
+	if (blksize_out != NULL)
+		*blksize_out = buf.st_blksize;
+	if (blocks_out != NULL)
+		*blocks_out = buf.st_blocks;
 	return 0;
 }
 
@@ -59,21 +69,29 @@ int file_type(const char *path, int *maj
 {
  	struct stat64 buf;
 
-	if(lstat64(path, &buf) < 0)
+	if (lstat64(path, &buf) < 0)
 		return -errno;
-	/*We cannot pass rdev as is because glibc and the kernel disagree
-	 *about its definition.*/
-	if(maj != NULL)
+	/*
+	 * We cannot pass rdev as is because glibc and the kernel disagree
+	 * about its definition.
+	 */
+	if (maj != NULL)
 		*maj = major(buf.st_rdev);
-	if(min != NULL)
+	if (min != NULL)
 		*min = minor(buf.st_rdev);
 
-	if(S_ISDIR(buf.st_mode)) return OS_TYPE_DIR;
-	else if(S_ISLNK(buf.st_mode)) return OS_TYPE_SYMLINK;
-	else if(S_ISCHR(buf.st_mode)) return OS_TYPE_CHARDEV;
-	else if(S_ISBLK(buf.st_mode)) return OS_TYPE_BLOCKDEV;
-	else if(S_ISFIFO(buf.st_mode))return OS_TYPE_FIFO;
-	else if(S_ISSOCK(buf.st_mode))return OS_TYPE_SOCK;
+	if (S_ISDIR(buf.st_mode))
+		return OS_TYPE_DIR;
+	else if (S_ISLNK(buf.st_mode))
+		return OS_TYPE_SYMLINK;
+	else if (S_ISCHR(buf.st_mode))
+		return OS_TYPE_CHARDEV;
+	else if (S_ISBLK(buf.st_mode))
+		return OS_TYPE_BLOCKDEV;
+	else if (S_ISFIFO(buf.st_mode))
+		return OS_TYPE_FIFO;
+	else if (S_ISSOCK(buf.st_mode))
+		return OS_TYPE_SOCK;
 	else return OS_TYPE_FILE;
 }
 
@@ -81,10 +99,13 @@ int access_file(char *path, int r, int w
 {
 	int mode = 0;
 
-	if(r) mode = R_OK;
-	if(w) mode |= W_OK;
-	if(x) mode |= X_OK;
-	if(access(path, mode) != 0)
+	if (r)
+		mode = R_OK;
+	if (w)
+		mode |= W_OK;
+	if (x)
+		mode |= X_OK;
+	if (access(path, mode) != 0)
 		return -errno;
 	else return 0;
 }
@@ -93,18 +114,18 @@ int open_file(char *path, int r, int w, 
 {
 	int mode = 0, fd;
 
-	if(r && !w)
+	if (r && !w)
 		mode = O_RDONLY;
-	else if(!r && w)
+	else if (!r && w)
 		mode = O_WRONLY;
-	else if(r && w)
+	else if (r && w)
 		mode = O_RDWR;
 	else panic("Impossible mode in open_file");
 
-	if(append)
+	if (append)
 		mode |= O_APPEND;
 	fd = open64(path, mode);
-	if(fd < 0)
+	if (fd < 0)
 		return -errno;
 	else return fd;
 }
@@ -115,7 +136,7 @@ void *open_dir(char *path, int *err_out)
 
 	dir = opendir(path);
 	*err_out = errno;
-	if(dir == NULL)
+	if (dir == NULL)
 		return NULL;
 	return dir;
 }
@@ -128,7 +149,7 @@ char *read_dir(void *stream, unsigned lo
 
 	seekdir(dir, *pos);
 	ent = readdir(dir);
-	if(ent == NULL)
+	if (ent == NULL)
 		return NULL;
 	*len_out = strlen(ent->d_name);
 	*ino_out = ent->d_ino;
@@ -141,7 +162,7 @@ int read_file(int fd, unsigned long long
 	int n;
 
 	n = pread64(fd, buf, len, *offset);
-	if(n < 0)
+	if (n < 0)
 		return -errno;
 	*offset += n;
 	return n;
@@ -152,7 +173,7 @@ int write_file(int fd, unsigned long lon
 	int n;
 
 	n = pwrite64(fd, buf, len, *offset);
-	if(n < 0)
+	if (n < 0)
 		return -errno;
 	*offset += n;
 	return n;
@@ -163,7 +184,7 @@ int lseek_file(int fd, long long offset,
 	int ret;
 
 	ret = lseek64(fd, offset, whence);
-	if(ret < 0)
+	if (ret < 0)
 		return -errno;
 	return 0;
 }
@@ -207,7 +228,7 @@ int file_create(char *name, int ur, int 
 	mode |= ow ? S_IWOTH : 0;
 	mode |= ox ? S_IXOTH : 0;
 	fd = open64(name, O_CREAT | O_RDWR, mode);
-	if(fd < 0)
+	if (fd < 0)
 		return -errno;
 	return fd;
 }
@@ -230,7 +251,7 @@ int set_attr(const char *file, struct ho
 		if (fd >= 0) {
 			if (fchown(fd, attrs->ia_uid, -1))
 				return -errno;
-		} else if(chown(file, attrs->ia_uid, -1)) {
+		} else if (chown(file, attrs->ia_uid, -1)) {
 			return -errno;
 		}
 	}
@@ -251,9 +272,11 @@ int set_attr(const char *file, struct ho
 		}
 	}
 
-	/* Update accessed and/or modified time, in two parts: first set
+	/*
+	 * Update accessed and/or modified time, in two parts: first set
 	 * times according to the changes to perform, and then call futimes()
-	 * or utimes() to apply them. */
+	 * or utimes() to apply them.
+	 */
 	ma = (HOSTFS_ATTR_ATIME_SET | HOSTFS_ATTR_MTIME_SET);
 	if (attrs->ia_valid & ma) {
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
@@ -284,11 +307,11 @@ int set_attr(const char *file, struct ho
 	}
 
 	/* Note: ctime is not handled */
-	if(attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
+	if (attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)) {
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
 				NULL, NULL, fd);
-		if(err != 0)
+		if (err != 0)
 			return err;
 	}
 	return 0;
@@ -299,7 +322,7 @@ int make_symlink(const char *from, const
 	int err;
 
 	err = symlink(to, from);
-	if(err)
+	if (err)
 		return -errno;
 	return 0;
 }
@@ -309,7 +332,7 @@ int unlink_file(const char *file)
 	int err;
 
 	err = unlink(file);
-	if(err)
+	if (err)
 		return -errno;
 	return 0;
 }
@@ -319,7 +342,7 @@ int do_mkdir(const char *file, int mode)
 	int err;
 
 	err = mkdir(file, mode);
-	if(err)
+	if (err)
 		return -errno;
 	return 0;
 }
@@ -329,7 +352,7 @@ int do_rmdir(const char *file)
 	int err;
 
 	err = rmdir(file);
-	if(err)
+	if (err)
 		return -errno;
 	return 0;
 }
@@ -339,7 +362,7 @@ int do_mknod(const char *file, int mode,
 	int err;
 
 	err = mknod(file, mode, makedev(major, minor));
-	if(err)
+	if (err)
 		return -errno;
 	return 0;
 }
@@ -349,7 +372,7 @@ int link_file(const char *to, const char
 	int err;
 
 	err = link(to, from);
-	if(err)
+	if (err)
 		return -errno;
 	return 0;
 }
@@ -359,9 +382,9 @@ int do_readlink(char *file, char *buf, i
 	int n;
 
 	n = readlink(file, buf, size);
-	if(n < 0)
+	if (n < 0)
 		return -errno;
-	if(n < size)
+	if (n < size)
 		buf[n] = '\0';
 	return n;
 }
@@ -371,7 +394,7 @@ int rename_file(char *from, char *to)
 	int err;
 
 	err = rename(from, to);
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 	return 0;
 }
@@ -386,7 +409,7 @@ int do_statfs(char *root, long *bsize_ou
 	int err;
 
 	err = statfs64(root, &buf);
-	if(err < 0)
+	if (err < 0)
 		return -errno;
 
 	*bsize_out = buf.f_bsize;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
