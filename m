From: akpm@linux-foundation.org
Subject: + hppfs-pass-vfsmount-to-dentry_open.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:48:34 -0800
Message-ID: <200802152248.m1FMmZHB028114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934128AbYBOWsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de, jdike@linux.intel.com, viro@ZenIV.linux.org.uk


The patch titled
     hppfs pass vfsmount to dentry_open()
has been added to the -mm tree.  Its filename is
     hppfs-pass-vfsmount-to-dentry_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hppfs pass vfsmount to dentry_open()
From: Dave Hansen <haveblue@us.ibm.com>

Here's patch for hppfs that uses vfs_kern_mount to make sure it always has a
procfs instance and passed the vfsmount on through the inode private data. 
Also fixes a procfs file_system_type leak for every attempted hppfs mount.

[ jdike - gave this file a style workover, plus deleted hppfs_dentry_ops ]

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hppfs/hppfs_kern.c |  364 ++++++++++++++++++++--------------------
 1 file changed, 188 insertions(+), 176 deletions(-)

diff -puN fs/hppfs/hppfs_kern.c~hppfs-pass-vfsmount-to-dentry_open fs/hppfs/hppfs_kern.c
--- a/fs/hppfs/hppfs_kern.c~hppfs-pass-vfsmount-to-dentry_open
+++ a/fs/hppfs/hppfs_kern.c
@@ -1,23 +1,25 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <linux/fs.h>
+#include <linux/ctype.h>
+#include <linux/dcache.h>
 #include <linux/file.h>
-#include <linux/module.h>
+#include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/list.h>
 #include <linux/kernel.h>
-#include <linux/ctype.h>
-#include <linux/dcache.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/slab.h>
 #include <linux/statfs.h>
+#include <linux/types.h>
 #include <asm/uaccess.h>
-#include <asm/fcntl.h>
 #include "os.h"
 
-static int init_inode(struct inode *inode, struct dentry *dentry);
+static int init_inode(struct inode *inode, struct dentry *dentry,
+		      struct vfsmount *mnt);
 
 struct hppfs_data {
 	struct list_head list;
@@ -33,6 +35,7 @@ struct hppfs_private {
 
 struct hppfs_inode_info {
         struct dentry *proc_dentry;
+	struct vfsmount *proc_mnt;
 	struct inode vfs_inode;
 };
 
@@ -51,14 +54,14 @@ static int is_pid(struct dentry *dentry)
 	int i;
 
 	sb = dentry->d_sb;
-	if((sb->s_op != &hppfs_sbops) || (dentry->d_parent != sb->s_root))
-		return(0);
+	if ((sb->s_op != &hppfs_sbops) || (dentry->d_parent != sb->s_root))
+		return 0;
 
-	for(i = 0; i < dentry->d_name.len; i++){
-		if(!isdigit(dentry->d_name.name[i]))
-			return(0);
+	for (i = 0; i < dentry->d_name.len; i++) {
+		if (!isdigit(dentry->d_name.name[i]))
+			return 0;
 	}
-	return(1);
+	return 1;
 }
 
 static char *dentry_name(struct dentry *dentry, int extra)
@@ -70,8 +73,8 @@ static char *dentry_name(struct dentry *
 
 	len = 0;
 	parent = dentry;
-	while(parent->d_parent != parent){
-		if(is_pid(parent))
+	while (parent->d_parent != parent) {
+		if (is_pid(parent))
 			len += strlen("pid") + 1;
 		else len += parent->d_name.len + 1;
 		parent = parent->d_parent;
@@ -80,12 +83,13 @@ static char *dentry_name(struct dentry *
 	root = "proc";
 	len += strlen(root);
 	name = kmalloc(len + extra + 1, GFP_KERNEL);
-	if(name == NULL) return(NULL);
+	if (name == NULL)
+		return NULL;
 
 	name[len] = '\0';
 	parent = dentry;
-	while(parent->d_parent != parent){
-		if(is_pid(parent)){
+	while (parent->d_parent != parent) {
+		if (is_pid(parent)) {
 			seg_name = "pid";
 			seg_len = strlen("pid");
 		}
@@ -100,27 +104,25 @@ static char *dentry_name(struct dentry *
 		parent = parent->d_parent;
 	}
 	strncpy(name, root, strlen(root));
-	return(name);
+	return name;
 }
 
-struct dentry_operations hppfs_dentry_ops = {
-};
-
 static int file_removed(struct dentry *dentry, const char *file)
 {
 	char *host_file;
 	int extra, fd;
 
 	extra = 0;
-	if(file != NULL) extra += strlen(file) + 1;
+	if (file != NULL)
+		extra += strlen(file) + 1;
 
 	host_file = dentry_name(dentry, extra + strlen("/remove"));
-	if(host_file == NULL){
-		printk("file_removed : allocation failed\n");
-		return(-ENOMEM);
+	if (host_file == NULL) {
+		printk(KERN_ERR "file_removed : allocation failed\n");
+		return -ENOMEM;
 	}
 
-	if(file != NULL){
+	if (file != NULL) {
 		strcat(host_file, "/");
 		strcat(host_file, file);
 	}
@@ -128,18 +130,18 @@ static int file_removed(struct dentry *d
 
 	fd = os_open_file(host_file, of_read(OPENFLAGS()), 0);
 	kfree(host_file);
-	if(fd > 0){
+	if (fd > 0) {
 		os_close_file(fd);
-		return(1);
+		return 1;
 	}
-	return(0);
+	return 0;
 }
 
 static void hppfs_read_inode(struct inode *ino)
 {
 	struct inode *proc_ino;
 
-	if(HPPFS_I(ino)->proc_dentry == NULL)
+	if (HPPFS_I(ino)->proc_dentry == NULL)
 		return;
 
 	proc_ino = HPPFS_I(ino)->proc_dentry->d_inode;
@@ -177,32 +179,32 @@ static struct dentry *hppfs_lookup(struc
 	int err, deleted;
 
 	deleted = file_removed(dentry, NULL);
-	if(deleted < 0)
-		return(ERR_PTR(deleted));
-	else if(deleted)
-		return(ERR_PTR(-ENOENT));
+	if (deleted < 0)
+		return ERR_PTR(deleted);
+	else if (deleted)
+		return ERR_PTR(-ENOENT);
 
 	err = -ENOMEM;
 	parent = HPPFS_I(ino)->proc_dentry;
 	mutex_lock(&parent->d_inode->i_mutex);
 	proc_dentry = d_lookup(parent, &dentry->d_name);
-	if(proc_dentry == NULL){
+	if (proc_dentry == NULL) {
 		proc_dentry = d_alloc(parent, &dentry->d_name);
-		if(proc_dentry == NULL){
+		if (proc_dentry == NULL) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			goto out;
 		}
 		new = (*parent->d_inode->i_op->lookup)(parent->d_inode,
 						       proc_dentry, NULL);
-		if(new){
+		if (new) {
 			dput(proc_dentry);
 			proc_dentry = new;
 		}
 	}
 	mutex_unlock(&parent->d_inode->i_mutex);
 
-	if(IS_ERR(proc_dentry))
-		return(proc_dentry);
+	if (IS_ERR(proc_dentry))
+		return proc_dentry;
 
 	inode = hppfs_iget(ino->i_sb);
 	if (IS_ERR(inode)) {
@@ -210,22 +212,21 @@ static struct dentry *hppfs_lookup(struc
 		goto out_dput;
 	}
 
-	err = init_inode(inode, proc_dentry);
-	if(err)
+	err = init_inode(inode, proc_dentry, HPPFS_I(ino)->proc_mnt);
+	if (err)
 		goto out_put;
 
 	hppfs_read_inode(inode);
 
  	d_add(dentry, inode);
-	dentry->d_op = &hppfs_dentry_ops;
-	return(NULL);
+	return NULL;
 
  out_put:
 	iput(inode);
  out_dput:
 	dput(proc_dentry);
  out:
-	return(ERR_PTR(err));
+	return ERR_PTR(err);
 }
 
 static const struct inode_operations hppfs_file_iops = {
@@ -239,15 +240,16 @@ static ssize_t read_proc(struct file *fi
 
 	read = file->f_path.dentry->d_inode->i_fop->read;
 
-	if(!is_user)
+	if (!is_user)
 		set_fs(KERNEL_DS);
 
 	n = (*read)(file, buf, count, &file->f_pos);
 
-	if(!is_user)
+	if (!is_user)
 		set_fs(USER_DS);
 
-	if(ppos) *ppos = file->f_pos;
+	if (ppos)
+		*ppos = file->f_pos;
 	return n;
 }
 
@@ -259,24 +261,23 @@ static ssize_t hppfs_read_file(int fd, c
 
 	n = -ENOMEM;
 	new_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if(new_buf == NULL){
-		printk("hppfs_read_file : kmalloc failed\n");
+	if (new_buf == NULL) {
+		printk(KERN_ERR "hppfs_read_file : kmalloc failed\n");
 		goto out;
 	}
 	n = 0;
-	while(count > 0){
+	while (count > 0) {
 		cur = min_t(ssize_t, count, PAGE_SIZE);
 		err = os_read_file(fd, new_buf, cur);
-		if(err < 0){
-			printk("hppfs_read : read failed, errno = %d\n",
-			       err);
+		if (err < 0) {
+			printk(KERN_ERR "hppfs_read : read failed, "
+			       "errno = %d\n", err);
 			n = err;
 			goto out_free;
-		}
-		else if(err == 0)
+		} else if (err == 0)
 			break;
 
-		if(copy_to_user(buf, new_buf, err)){
+		if (copy_to_user(buf, new_buf, err)) {
 			n = -EFAULT;
 			goto out_free;
 		}
@@ -297,35 +298,36 @@ static ssize_t hppfs_read(struct file *f
 	loff_t off;
 	int err;
 
-	if(hppfs->contents != NULL){
-		if(*ppos >= hppfs->len) return(0);
+	if (hppfs->contents != NULL) {
+		if (*ppos >= hppfs->len)
+			return 0;
 
 		data = hppfs->contents;
 		off = *ppos;
-		while(off >= sizeof(data->contents)){
+		while (off >= sizeof(data->contents)) {
 			data = list_entry(data->list.next, struct hppfs_data,
 					  list);
 			off -= sizeof(data->contents);
 		}
 
-		if(off + count > hppfs->len)
+		if (off + count > hppfs->len)
 			count = hppfs->len - off;
 		copy_to_user(buf, &data->contents[off], count);
 		*ppos += count;
-	}
-	else if(hppfs->host_fd != -1){
+	} else if (hppfs->host_fd != -1) {
 		err = os_seek_file(hppfs->host_fd, *ppos);
-		if(err){
-			printk("hppfs_read : seek failed, errno = %d\n", err);
-			return(err);
+		if (err) {
+			printk(KERN_ERR "hppfs_read : seek failed, "
+			       "errno = %d\n", err);
+			return err;
 		}
 		count = hppfs_read_file(hppfs->host_fd, buf, count);
-		if(count > 0)
+		if (count > 0)
 			*ppos += count;
 	}
 	else count = read_proc(hppfs->proc_file, buf, count, ppos, 1);
 
-	return(count);
+	return count;
 }
 
 static ssize_t hppfs_write(struct file *file, const char __user *buf, size_t len,
@@ -342,7 +344,7 @@ static ssize_t hppfs_write(struct file *
 	err = (*write)(proc_file, buf, len, &proc_file->f_pos);
 	file->f_pos = proc_file->f_pos;
 
-	return(err);
+	return err;
 }
 
 static int open_host_sock(char *host_file, int *filter_out)
@@ -354,13 +356,13 @@ static int open_host_sock(char *host_fil
 	strcpy(end, "/rw");
 	*filter_out = 1;
 	fd = os_connect_socket(host_file);
-	if(fd > 0)
-		return(fd);
+	if (fd > 0)
+		return fd;
 
 	strcpy(end, "/r");
 	*filter_out = 0;
 	fd = os_connect_socket(host_file);
-	return(fd);
+	return fd;
 }
 
 static void free_contents(struct hppfs_data *head)
@@ -368,9 +370,10 @@ static void free_contents(struct hppfs_d
 	struct hppfs_data *data;
 	struct list_head *ele, *next;
 
-	if(head == NULL) return;
+	if (head == NULL)
+		return;
 
-	list_for_each_safe(ele, next, &head->list){
+	list_for_each_safe(ele, next, &head->list) {
 		data = list_entry(ele, struct hppfs_data, list);
 		kfree(data);
 	}
@@ -387,8 +390,8 @@ static struct hppfs_data *hppfs_get_data
 
 	err = -ENOMEM;
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if(data == NULL){
-		printk("hppfs_get_data : head allocation failed\n");
+	if (data == NULL) {
+		printk(KERN_ERR "hppfs_get_data : head allocation failed\n");
 		goto failed;
 	}
 
@@ -397,36 +400,36 @@ static struct hppfs_data *hppfs_get_data
 	head = data;
 	*size_out = 0;
 
-	if(filter){
-		while((n = read_proc(proc_file, data->contents,
+	if (filter) {
+		while ((n = read_proc(proc_file, data->contents,
 				     sizeof(data->contents), NULL, 0)) > 0)
 			os_write_file(fd, data->contents, n);
 		err = os_shutdown_socket(fd, 0, 1);
-		if(err){
-			printk("hppfs_get_data : failed to shut down "
+		if (err) {
+			printk(KERN_ERR "hppfs_get_data : failed to shut down "
 			       "socket\n");
 			goto failed_free;
 		}
 	}
-	while(1){
+	while (1) {
 		n = os_read_file(fd, data->contents, sizeof(data->contents));
-		if(n < 0){
+		if (n < 0) {
 			err = n;
-			printk("hppfs_get_data : read failed, errno = %d\n",
-			       err);
+			printk(KERN_ERR "hppfs_get_data : read failed, "
+			       "errno = %d\n", err);
 			goto failed_free;
-		}
-		else if(n == 0)
+		} else if (n == 0)
 			break;
 
 		*size_out += n;
 
-		if(n < sizeof(data->contents))
+		if (n < sizeof(data->contents))
 			break;
 
 		new = kmalloc(sizeof(*data), GFP_KERNEL);
-		if(new == 0){
-			printk("hppfs_get_data : data allocation failed\n");
+		if (new == 0) {
+			printk(KERN_ERR "hppfs_get_data : data allocation "
+			       "failed\n");
 			err = -ENOMEM;
 			goto failed_free;
 		}
@@ -435,12 +438,12 @@ static struct hppfs_data *hppfs_get_data
 		list_add(&new->list, &data->list);
 		data = new;
 	}
-	return(head);
+	return head;
 
  failed_free:
 	free_contents(head);
  failed:
-	return(ERR_PTR(err));
+	return ERR_PTR(err);
 }
 
 static struct hppfs_private *hppfs_data(void)
@@ -448,77 +451,79 @@ static struct hppfs_private *hppfs_data(
 	struct hppfs_private *data;
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if(data == NULL)
-		return(data);
+	if (data == NULL)
+		return data;
 
 	*data = ((struct hppfs_private ) { .host_fd  		= -1,
 					   .len  		= -1,
 					   .contents 		= NULL } );
-	return(data);
+	return data;
 }
 
 static int file_mode(int fmode)
 {
-	if(fmode == (FMODE_READ | FMODE_WRITE))
-		return(O_RDWR);
-	if(fmode == FMODE_READ)
-		return(O_RDONLY);
-	if(fmode == FMODE_WRITE)
-		return(O_WRONLY);
-	return(0);
+	if (fmode == (FMODE_READ | FMODE_WRITE))
+		return O_RDWR;
+	if (fmode == FMODE_READ)
+		return O_RDONLY;
+	if (fmode == FMODE_WRITE)
+		return O_WRONLY;
+	return 0;
 }
 
 static int hppfs_open(struct inode *inode, struct file *file)
 {
 	struct hppfs_private *data;
 	struct dentry *proc_dentry;
+	struct vfsmount *proc_mnt;
 	char *host_file;
 	int err, fd, type, filter;
 
 	err = -ENOMEM;
 	data = hppfs_data();
-	if(data == NULL)
+	if (data == NULL)
 		goto out;
 
 	host_file = dentry_name(file->f_path.dentry, strlen("/rw"));
-	if(host_file == NULL)
+	if (host_file == NULL)
 		goto out_free2;
 
 	proc_dentry = HPPFS_I(inode)->proc_dentry;
+	proc_mnt = HPPFS_I(inode)->proc_mnt;
 
 	/* XXX This isn't closed anywhere */
-	data->proc_file = dentry_open(dget(proc_dentry), NULL,
+	data->proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt),
 				      file_mode(file->f_mode));
 	err = PTR_ERR(data->proc_file);
-	if(IS_ERR(data->proc_file))
+	if (IS_ERR(data->proc_file))
 		goto out_free1;
 
 	type = os_file_type(host_file);
-	if(type == OS_TYPE_FILE){
+	if (type == OS_TYPE_FILE) {
 		fd = os_open_file(host_file, of_read(OPENFLAGS()), 0);
-		if(fd >= 0)
+		if (fd >= 0)
 			data->host_fd = fd;
-		else printk("hppfs_open : failed to open '%s', errno = %d\n",
-			    host_file, -fd);
+		else
+			printk(KERN_ERR "hppfs_open : failed to open '%s', "
+			       "errno = %d\n", host_file, -fd);
 
 		data->contents = NULL;
-	}
-	else if(type == OS_TYPE_DIR){
+	} else if (type == OS_TYPE_DIR) {
 		fd = open_host_sock(host_file, &filter);
-		if(fd > 0){
+		if (fd > 0) {
 			data->contents = hppfs_get_data(fd, filter,
 							data->proc_file,
 							file, &data->len);
-			if(!IS_ERR(data->contents))
+			if (!IS_ERR(data->contents))
 				data->host_fd = fd;
-		}
-		else printk("hppfs_open : failed to open a socket in "
-			    "'%s', errno = %d\n", host_file, -fd);
+		} else
+			printk(KERN_ERR "hppfs_open : failed to open a socket "
+			       "in '%s', errno = %d\n", host_file, -fd);
 	}
 	kfree(host_file);
 
 	file->private_data = data;
-	return(0);
+	return 0;
 
  out_free1:
 	kfree(host_file);
@@ -526,34 +531,36 @@ static int hppfs_open(struct inode *inod
 	free_contents(data->contents);
 	kfree(data);
  out:
-	return(err);
+	return err;
 }
 
 static int hppfs_dir_open(struct inode *inode, struct file *file)
 {
 	struct hppfs_private *data;
 	struct dentry *proc_dentry;
+	struct vfsmount *proc_mnt;
 	int err;
 
 	err = -ENOMEM;
 	data = hppfs_data();
-	if(data == NULL)
+	if (data == NULL)
 		goto out;
 
 	proc_dentry = HPPFS_I(inode)->proc_dentry;
-	data->proc_file = dentry_open(dget(proc_dentry), NULL,
+	proc_mnt = HPPFS_I(inode)->proc_mnt;
+	data->proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt),
 				      file_mode(file->f_mode));
 	err = PTR_ERR(data->proc_file);
-	if(IS_ERR(data->proc_file))
+	if (IS_ERR(data->proc_file))
 		goto out_free;
 
 	file->private_data = data;
-	return(0);
+	return 0;
 
  out_free:
 	kfree(data);
  out:
-	return(err);
+	return err;
 }
 
 static loff_t hppfs_llseek(struct file *file, loff_t off, int where)
@@ -564,13 +571,13 @@ static loff_t hppfs_llseek(struct file *
 	loff_t ret;
 
 	llseek = proc_file->f_path.dentry->d_inode->i_fop->llseek;
-	if(llseek != NULL){
+	if (llseek != NULL) {
 		ret = (*llseek)(proc_file, off, where);
-		if(ret < 0)
-			return(ret);
+		if (ret < 0)
+			return ret;
 	}
 
-	return(default_llseek(file, off, where));
+	return default_llseek(file, off, where);
 }
 
 static const struct file_operations hppfs_file_fops = {
@@ -592,11 +599,11 @@ static int hppfs_filldir(void *d, const 
 {
 	struct hppfs_dirent *dirent = d;
 
-	if(file_removed(dirent->dentry, name))
-		return(0);
+	if (file_removed(dirent->dentry, name))
+		return 0;
 
-	return((*dirent->filldir)(dirent->vfs_dirent, name, size, offset,
-				  inode, type));
+	return (*dirent->filldir)(dirent->vfs_dirent, name, size, offset,
+				  inode, type);
 }
 
 static int hppfs_readdir(struct file *file, void *ent, filldir_t filldir)
@@ -607,7 +614,8 @@ static int hppfs_readdir(struct file *fi
 	struct hppfs_dirent dirent = ((struct hppfs_dirent)
 		                      { .vfs_dirent  	= ent,
 					.filldir 	= filldir,
-					.dentry  	= file->f_path.dentry } );
+					.dentry  	= file->f_path.dentry
+				      });
 	int err;
 
 	readdir = proc_file->f_path.dentry->d_inode->i_fop->readdir;
@@ -616,12 +624,12 @@ static int hppfs_readdir(struct file *fi
 	err = (*readdir)(proc_file, &dirent, hppfs_filldir);
 	file->f_pos = proc_file->f_pos;
 
-	return(err);
+	return err;
 }
 
 static int hppfs_fsync(struct file *file, struct dentry *dentry, int datasync)
 {
-	return(0);
+	return 0;
 }
 
 static const struct file_operations hppfs_dir_fops = {
@@ -639,7 +647,7 @@ static int hppfs_statfs(struct dentry *d
 	sf->f_files = 0;
 	sf->f_ffree = 0;
 	sf->f_type = HPPFS_SUPER_MAGIC;
-	return(0);
+	return 0;
 }
 
 static struct inode *hppfs_alloc_inode(struct super_block *sb)
@@ -647,12 +655,13 @@ static struct inode *hppfs_alloc_inode(s
 	struct hppfs_inode_info *hi;
 
 	hi = kmalloc(sizeof(*hi), GFP_KERNEL);
-	if(hi == NULL)
-		return(NULL);
+	if (!hi)
+		return NULL;
 
-	*hi = ((struct hppfs_inode_info) { .proc_dentry	= NULL });
+	hi->proc_dentry = NULL;
+	hi->proc_mnt = NULL;
 	inode_init_once(&hi->vfs_inode);
-	return(&hi->vfs_inode);
+	return &hi->vfs_inode;
 }
 
 void hppfs_delete_inode(struct inode *ino)
@@ -665,21 +674,31 @@ static void hppfs_destroy_inode(struct i
 	kfree(HPPFS_I(inode));
 }
 
+static void hppfs_put_super(struct super_block *sb)
+{
+	mntput(HPPFS_I(sb->s_root->d_inode)->proc_mnt);
+}
+
 static const struct super_operations hppfs_sbops = {
 	.alloc_inode	= hppfs_alloc_inode,
 	.destroy_inode	= hppfs_destroy_inode,
 	.delete_inode	= hppfs_delete_inode,
 	.statfs		= hppfs_statfs,
+	.put_super	= hppfs_put_super,
 };
 
-static int hppfs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+static int hppfs_readlink(struct dentry *dentry, char __user *buffer,
+			  int buflen)
 {
 	struct file *proc_file;
 	struct dentry *proc_dentry;
+	struct vfsmount *proc_mnt;
 	int ret;
 
 	proc_dentry = HPPFS_I(dentry->d_inode)->proc_dentry;
-	proc_file = dentry_open(dget(proc_dentry), NULL, O_RDONLY);
+	proc_mnt = HPPFS_I(dentry->d_inode)->proc_mnt;
+
+	proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt), O_RDONLY);
 	if (IS_ERR(proc_file))
 		return PTR_ERR(proc_file);
 
@@ -694,10 +713,13 @@ static void* hppfs_follow_link(struct de
 {
 	struct file *proc_file;
 	struct dentry *proc_dentry;
+	struct vfsmount *proc_mnt;
 	void *ret;
 
 	proc_dentry = HPPFS_I(dentry->d_inode)->proc_dentry;
-	proc_file = dentry_open(dget(proc_dentry), NULL, O_RDONLY);
+	proc_mnt = HPPFS_I(dentry->d_inode)->proc_mnt;
+
+	proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt), O_RDONLY);
 	if (IS_ERR(proc_file))
 		return proc_file;
 
@@ -717,44 +739,43 @@ static const struct inode_operations hpp
 	.follow_link	= hppfs_follow_link,
 };
 
-static int init_inode(struct inode *inode, struct dentry *dentry)
+static int init_inode(struct inode *inode, struct dentry *dentry,
+		struct vfsmount *mnt)
 {
-	if(S_ISDIR(dentry->d_inode->i_mode)){
+	if (S_ISDIR(dentry->d_inode->i_mode)) {
 		inode->i_op = &hppfs_dir_iops;
 		inode->i_fop = &hppfs_dir_fops;
-	}
-	else if(S_ISLNK(dentry->d_inode->i_mode)){
+	} else if (S_ISLNK(dentry->d_inode->i_mode)) {
 		inode->i_op = &hppfs_link_iops;
 		inode->i_fop = &hppfs_file_fops;
-	}
-	else {
+	} else {
 		inode->i_op = &hppfs_file_iops;
 		inode->i_fop = &hppfs_file_fops;
 	}
 
 	HPPFS_I(inode)->proc_dentry = dentry;
+	HPPFS_I(inode)->proc_mnt = mnt;
 
-	return(0);
+	return 0;
 }
 
 static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
 {
 	struct inode *root_inode;
 	struct file_system_type *procfs;
-	struct super_block *proc_sb;
+	struct vfsmount *proc_mnt;
 	int err;
 
 	err = -ENOENT;
 	procfs = get_fs_type("proc");
-	if(procfs == NULL)
+	if (!procfs)
 		goto out;
 
-	if(list_empty(&procfs->fs_supers))
+	proc_mnt = vfs_kern_mount(procfs, 0, procfs->name, NULL);
+	put_filesystem(procfs);
+	if (IS_ERR(proc_mnt))
 		goto out;
 
-	proc_sb = list_entry(procfs->fs_supers.next, struct super_block,
-			     s_instances);
-
 	sb->s_blocksize = 1024;
 	sb->s_blocksize_bits = 10;
 	sb->s_magic = HPPFS_SUPER_MAGIC;
@@ -766,21 +787,23 @@ static int hppfs_fill_super(struct super
 		goto out;
 	}
 
-	err = init_inode(root_inode, proc_sb->s_root);
-	if(err)
-		goto out_put;
+	err = init_inode(root_inode, proc_mnt->mnt_sb->s_root, proc_mnt);
+	if (err)
+		goto out_iput;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
-	if(sb->s_root == NULL)
-		goto out_put;
+	if (!sb->s_root)
+		goto out_iput;
 
 	hppfs_read_inode(root_inode);
 
-	return(0);
+	return 0;
 
- out_put:
+ out_iput:
 	iput(root_inode);
+ out_mntput:
+	mntput(proc_mnt);
  out:
 	return(err);
 }
@@ -802,7 +825,7 @@ static struct file_system_type hppfs_typ
 
 static int __init init_hppfs(void)
 {
-	return(register_filesystem(&hppfs_type));
+	return register_filesystem(&hppfs_type);
 }
 
 static void __exit exit_hppfs(void)
@@ -813,14 +836,3 @@ static void __exit exit_hppfs(void)
 module_init(init_hppfs)
 module_exit(exit_hppfs)
 MODULE_LICENSE("GPL");
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
