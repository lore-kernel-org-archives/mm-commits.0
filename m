From: akpm@linux-foundation.org
Subject: + uml-hostfs-style-fixes.patch added to -mm tree
Date: Fri, 04 May 2007 15:02:25 -0700
Message-ID: <200705042202.l44M2PgX019855@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161597AbXEDWCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 18:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: hostfs style fixes
has been added to the -mm tree.  Its filename is
     uml-hostfs-style-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: hostfs style fixes
From: Jeff Dike <jdike@addtoit.com>

hostfs needed some style goodness.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs.h      |   11 --
 fs/hostfs/hostfs_kern.c |  186 +++++++++++++++++++-------------------
 fs/hostfs/hostfs_user.c |  141 ++++++++++++++--------------
 3 files changed, 167 insertions(+), 171 deletions(-)

diff -puN fs/hostfs/hostfs.h~uml-hostfs-style-fixes fs/hostfs/hostfs.h
--- a/fs/hostfs/hostfs.h~uml-hostfs-style-fixes
+++ a/fs/hostfs/hostfs.h
@@ -87,14 +87,3 @@ extern int do_statfs(char *root, long *b
 		     long *spare_out);
 
 #endif
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
diff -puN fs/hostfs/hostfs_kern.c~uml-hostfs-style-fixes fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-hostfs-style-fixes
+++ a/fs/hostfs/hostfs_kern.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  *
  * Ported the filesystem routines to 2.5.
@@ -31,14 +31,14 @@ struct hostfs_inode_info {
 
 static inline struct hostfs_inode_info *HOSTFS_I(struct inode *inode)
 {
-	return(list_entry(inode, struct hostfs_inode_info, vfs_inode));
+	return list_entry(inode, struct hostfs_inode_info, vfs_inode);
 }
 
 #define FILE_HOSTFS_I(file) HOSTFS_I((file)->f_path.dentry->d_inode)
 
 int hostfs_d_delete(struct dentry *dentry)
 {
-	return(1);
+	return 1;
 }
 
 struct dentry_operations hostfs_dentry_ops = {
@@ -79,7 +79,7 @@ static int __init hostfs_args(char *opti
 		}
 		options = ptr;
 	}
-	return(0);
+	return 0;
 }
 
 __uml_setup("hostfs=", hostfs_args,
@@ -110,7 +110,8 @@ static char *dentry_name(struct dentry *
 	root = HOSTFS_I(parent->d_inode)->host_filename;
 	len += strlen(root);
 	name = kmalloc(len + extra + 1, GFP_KERNEL);
-	if(name == NULL) return(NULL);
+	if(name == NULL)
+		return NULL;
 
 	name[len] = '\0';
 	parent = dentry;
@@ -122,7 +123,7 @@ static char *dentry_name(struct dentry *
 		parent = parent->d_parent;
 	}
 	strncpy(name, root, strlen(root));
-	return(name);
+	return name;
 }
 
 static char *inode_name(struct inode *ino, int extra)
@@ -130,7 +131,7 @@ static char *inode_name(struct inode *in
 	struct dentry *dentry;
 
 	dentry = list_entry(ino->i_dentry.next, struct dentry, d_alias);
-	return(dentry_name(dentry, extra));
+	return dentry_name(dentry, extra);
 }
 
 static int read_name(struct inode *ino, char *name)
@@ -149,14 +150,14 @@ static int read_name(struct inode *ino, 
 			&ino->i_gid, &i_size, &ino->i_atime, &ino->i_mtime,
 			&ino->i_ctime, &i_blksize, &i_blocks, -1);
 	if(err)
-		return(err);
+		return err;
 
 	ino->i_ino = i_ino;
 	ino->i_mode = i_mode;
 	ino->i_nlink = i_nlink;
 	ino->i_size = i_size;
 	ino->i_blocks = i_blocks;
-	return(0);
+	return 0;
 }
 
 static char *follow_link(char *link)
@@ -181,11 +182,11 @@ static char *follow_link(char *link)
 		goto out_free;
 
 	if(*name == '/')
-		return(name);
+		return name;
 
 	end = strrchr(link, '/');
 	if(end == NULL)
-		return(name);
+		return name;
 
 	*(end + 1) = '\0';
 	len = strlen(link) + strlen(name) + 1;
@@ -199,12 +200,12 @@ static char *follow_link(char *link)
 	sprintf(resolved, "%s%s", link, name);
 	kfree(name);
 	kfree(link);
-	return(resolved);
+	return resolved;
 
  out_free:
 	kfree(name);
  out:
-	return(ERR_PTR(n));
+	return ERR_PTR(n);
 }
 
 static int read_inode(struct inode *ino)
@@ -234,7 +235,7 @@ static int read_inode(struct inode *ino)
 	err = read_name(ino, name);
 	kfree(name);
  out:
-	return(err);
+	return err;
 }
 
 int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
@@ -254,14 +255,15 @@ int hostfs_statfs(struct dentry *dentry,
 			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
 			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
 			&sf->f_namelen, sf->f_spare);
-	if(err) return(err);
+	if(err)
+		return err;
 	sf->f_blocks = f_blocks;
 	sf->f_bfree = f_bfree;
 	sf->f_bavail = f_bavail;
 	sf->f_files = f_files;
 	sf->f_ffree = f_ffree;
 	sf->f_type = HOSTFS_SUPER_MAGIC;
-	return(0);
+	return 0;
 }
 
 static struct inode *hostfs_alloc_inode(struct super_block *sb)
@@ -270,13 +272,13 @@ static struct inode *hostfs_alloc_inode(
 
 	hi = kmalloc(sizeof(*hi), GFP_KERNEL);
 	if(hi == NULL)
-		return(NULL);
+		return NULL;
 
 	*hi = ((struct hostfs_inode_info) { .host_filename	= NULL,
 					    .fd			= -1,
 					    .mode		= 0 });
 	inode_init_once(&hi->vfs_inode);
-	return(&hi->vfs_inode);
+	return &hi->vfs_inode;
 }
 
 static void hostfs_delete_inode(struct inode *inode)
@@ -325,10 +327,12 @@ int hostfs_readdir(struct file *file, vo
 	int error, len;
 
 	name = dentry_name(file->f_path.dentry, 0);
-	if(name == NULL) return(-ENOMEM);
+	if(name == NULL)
+		return -ENOMEM;
 	dir = open_dir(name, &error);
 	kfree(name);
-	if(dir == NULL) return(-error);
+	if(dir == NULL)
+		return -error;
 	next = file->f_pos;
 	while((name = read_dir(dir, &next, &ino, &len)) != NULL){
 		error = (*filldir)(ent, name, len, file->f_pos,
@@ -337,7 +341,7 @@ int hostfs_readdir(struct file *file, vo
 		file->f_pos = next;
 	}
 	close_dir(dir);
-	return(0);
+	return 0;
 }
 
 int hostfs_file_open(struct inode *ino, struct file *file)
@@ -347,7 +351,7 @@ int hostfs_file_open(struct inode *ino, 
 
 	mode = file->f_mode & (FMODE_READ | FMODE_WRITE);
 	if((mode & HOSTFS_I(ino)->mode) == mode)
-		return(0);
+		return 0;
 
 	/* The file may already have been opened, but with the wrong access,
 	 * so this resets things and reopens the file with the new access.
@@ -367,14 +371,15 @@ int hostfs_file_open(struct inode *ino, 
 
 	name = dentry_name(file->f_path.dentry, 0);
 	if(name == NULL)
-		return(-ENOMEM);
+		return -ENOMEM;
 
 	fd = open_file(name, r, w, append);
 	kfree(name);
-	if(fd < 0) return(fd);
+	if(fd < 0)
+		return fd;
 	FILE_HOSTFS_I(file)->fd = fd;
 
-	return(0);
+	return 0;
 }
 
 int hostfs_fsync(struct file *file, struct dentry *dentry, int datasync)
@@ -458,7 +463,7 @@ int hostfs_readpage(struct file *file, s
  out:
 	kunmap(page);
 	unlock_page(page);
-	return(err);
+	return err;
 }
 
 int hostfs_prepare_write(struct file *file, struct page *page,
@@ -485,7 +490,7 @@ int hostfs_prepare_write(struct file *fi
 	err = 0;
  out:
 	kunmap(page);
-	return(err);
+	return err;
 }
 
 int hostfs_commit_write(struct file *file, struct page *page, unsigned from,
@@ -511,7 +516,7 @@ int hostfs_commit_write(struct file *fil
 		inode->i_size = start;
 
 	kunmap(page);
-	return(err);
+	return err;
 }
 
 static const struct address_space_operations hostfs_aops = {
@@ -569,7 +574,7 @@ static int init_inode(struct inode *inod
 		break;
 	}
  out:
-	return(err);
+	return err;
 }
 
 int hostfs_create(struct inode *dir, struct dentry *dentry, int mode,
@@ -607,16 +612,16 @@ int hostfs_create(struct inode *dir, str
 	HOSTFS_I(inode)->fd = fd;
 	HOSTFS_I(inode)->mode = FMODE_READ | FMODE_WRITE;
 	d_instantiate(dentry, inode);
-	return(0);
+	return 0;
 
  out_put:
 	iput(inode);
  out:
-	return(error);
+	return error;
 }
 
 struct dentry *hostfs_lookup(struct inode *ino, struct dentry *dentry,
-                            struct nameidata *nd)
+			     struct nameidata *nd)
 {
 	struct inode *inode;
 	char *name;
@@ -647,44 +652,45 @@ struct dentry *hostfs_lookup(struct inod
 
 	d_add(dentry, inode);
 	dentry->d_op = &hostfs_dentry_ops;
-	return(NULL);
+	return NULL;
 
  out_put:
 	iput(inode);
  out:
-	return(ERR_PTR(err));
+	return ERR_PTR(err);
 }
 
 static char *inode_dentry_name(struct inode *ino, struct dentry *dentry)
 {
-        char *file;
+	char *file;
 	int len;
 
 	file = inode_name(ino, dentry->d_name.len + 1);
-	if(file == NULL) return(NULL);
-        strcat(file, "/");
+	if(file == NULL)
+		return NULL;
+	strcat(file, "/");
 	len = strlen(file);
-        strncat(file, dentry->d_name.name, dentry->d_name.len);
+	strncat(file, dentry->d_name.name, dentry->d_name.len);
 	file[len + dentry->d_name.len] = '\0';
-        return(file);
+	return file;
 }
 
 int hostfs_link(struct dentry *to, struct inode *ino, struct dentry *from)
 {
-        char *from_name, *to_name;
-        int err;
+	char *from_name, *to_name;
+	int err;
 
-        if((from_name = inode_dentry_name(ino, from)) == NULL)
-                return(-ENOMEM);
-        to_name = dentry_name(to, 0);
+	if((from_name = inode_dentry_name(ino, from)) == NULL)
+		return -ENOMEM;
+	to_name = dentry_name(to, 0);
 	if(to_name == NULL){
 		kfree(from_name);
-		return(-ENOMEM);
+		return -ENOMEM;
 	}
-        err = link_file(to_name, from_name);
-        kfree(from_name);
-        kfree(to_name);
-        return(err);
+	err = link_file(to_name, from_name);
+	kfree(from_name);
+	kfree(to_name);
+	return err;
 }
 
 int hostfs_unlink(struct inode *ino, struct dentry *dentry)
@@ -692,13 +698,14 @@ int hostfs_unlink(struct inode *ino, str
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL) return(-ENOMEM);
+	if((file = inode_dentry_name(ino, dentry)) == NULL)
+		return -ENOMEM;
 	if(append)
-		return(-EPERM);
+		return -EPERM;
 
 	err = unlink_file(file);
 	kfree(file);
-	return(err);
+	return err;
 }
 
 int hostfs_symlink(struct inode *ino, struct dentry *dentry, const char *to)
@@ -706,10 +713,11 @@ int hostfs_symlink(struct inode *ino, st
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL) return(-ENOMEM);
+	if((file = inode_dentry_name(ino, dentry)) == NULL)
+		return -ENOMEM;
 	err = make_symlink(file, to);
 	kfree(file);
-	return(err);
+	return err;
 }
 
 int hostfs_mkdir(struct inode *ino, struct dentry *dentry, int mode)
@@ -717,10 +725,11 @@ int hostfs_mkdir(struct inode *ino, stru
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL) return(-ENOMEM);
+	if((file = inode_dentry_name(ino, dentry)) == NULL)
+		return -ENOMEM;
 	err = do_mkdir(file, mode);
 	kfree(file);
-	return(err);
+	return err;
 }
 
 int hostfs_rmdir(struct inode *ino, struct dentry *dentry)
@@ -728,10 +737,11 @@ int hostfs_rmdir(struct inode *ino, stru
 	char *file;
 	int err;
 
-	if((file = inode_dentry_name(ino, dentry)) == NULL) return(-ENOMEM);
+	if((file = inode_dentry_name(ino, dentry)) == NULL)
+		return -ENOMEM;
 	err = do_rmdir(file);
 	kfree(file);
-	return(err);
+	return err;
 }
 
 int hostfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
@@ -764,14 +774,14 @@ int hostfs_mknod(struct inode *dir, stru
 		goto out_put;
 
 	d_instantiate(dentry, inode);
-	return(0);
+	return 0;
 
  out_free:
 	kfree(name);
  out_put:
 	iput(inode);
  out:
-	return(err);
+	return err;
 }
 
 int hostfs_rename(struct inode *from_ino, struct dentry *from,
@@ -781,15 +791,15 @@ int hostfs_rename(struct inode *from_ino
 	int err;
 
 	if((from_name = inode_dentry_name(from_ino, from)) == NULL)
-		return(-ENOMEM);
+		return -ENOMEM;
 	if((to_name = inode_dentry_name(to_ino, to)) == NULL){
 		kfree(from_name);
-		return(-ENOMEM);
+		return -ENOMEM;
 	}
 	err = rename_file(from_name, to_name);
 	kfree(from_name);
 	kfree(to_name);
-	return(err);
+	return err;
 }
 
 int hostfs_permission(struct inode *ino, int desired, struct nameidata *nd)
@@ -801,7 +811,8 @@ int hostfs_permission(struct inode *ino,
 	if (desired & MAY_WRITE) w = 1;
 	if (desired & MAY_EXEC) x = 1;
 	name = inode_name(ino, 0);
-	if (name == NULL) return(-ENOMEM);
+	if (name == NULL)
+		return -ENOMEM;
 
 	if (S_ISCHR(ino->i_mode) || S_ISBLK(ino->i_mode) ||
 			S_ISFIFO(ino->i_mode) || S_ISSOCK(ino->i_mode))
@@ -865,20 +876,21 @@ int hostfs_setattr(struct dentry *dentry
 		attrs.ia_valid |= HOSTFS_ATTR_MTIME_SET;
 	}
 	name = dentry_name(dentry, 0);
-	if(name == NULL) return(-ENOMEM);
+	if(name == NULL)
+		return -ENOMEM;
 	err = set_attr(name, &attrs, fd);
 	kfree(name);
 	if(err)
-		return(err);
+		return err;
 
-	return(inode_setattr(dentry->d_inode, attr));
+	return inode_setattr(dentry->d_inode, attr);
 }
 
 int hostfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	   struct kstat *stat)
 {
 	generic_fillattr(dentry->d_inode, stat);
-	return(0);
+	return 0;
 }
 
 static const struct inode_operations hostfs_iops = {
@@ -917,7 +929,8 @@ int hostfs_link_readpage(struct file *fi
 
 	buffer = kmap(page);
 	name = inode_name(page->mapping->host, 0);
-	if(name == NULL) return(-ENOMEM);
+	if(name == NULL)
+		return -ENOMEM;
 	err = do_readlink(name, buffer, PAGE_CACHE_SIZE);
 	kfree(name);
 	if(err == PAGE_CACHE_SIZE)
@@ -930,7 +943,7 @@ int hostfs_link_readpage(struct file *fi
 	}
 	kunmap(page);
 	unlock_page(page);
-	return(err);
+	return err;
 }
 
 static const struct address_space_operations hostfs_link_aops = {
@@ -980,20 +993,20 @@ static int hostfs_fill_sb_common(struct 
 
 	err = read_inode(root_inode);
 	if(err){
-                /* No iput in this case because the dput does that for us */
-                dput(sb->s_root);
-                sb->s_root = NULL;
+		/* No iput in this case because the dput does that for us */
+		dput(sb->s_root);
+		sb->s_root = NULL;
 		goto out;
-        }
+	}
 
-	return(0);
+	return 0;
 
- out_put:
-        iput(root_inode);
- out_free:
+out_put:
+	iput(root_inode);
+out_free:
 	kfree(host_root_path);
- out:
-	return(err);
+out:
+	return err;
 }
 
 static int hostfs_read_sb(struct file_system_type *type,
@@ -1013,7 +1026,7 @@ static struct file_system_type hostfs_ty
 
 static int __init init_hostfs(void)
 {
-	return(register_filesystem(&hostfs_type));
+	return register_filesystem(&hostfs_type);
 }
 
 static void __exit exit_hostfs(void)
@@ -1024,14 +1037,3 @@ static void __exit exit_hostfs(void)
 module_init(init_hostfs)
 module_exit(exit_hostfs)
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
diff -puN fs/hostfs/hostfs_user.c~uml-hostfs-style-fixes fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~uml-hostfs-style-fixes
+++ a/fs/hostfs/hostfs_user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -27,9 +27,9 @@ int stat_file(const char *path, unsigned
 
 	if(fd >= 0) {
 		if (fstat64(fd, &buf) < 0)
-			return(-errno);
+			return -errno;
 	} else if(lstat64(path, &buf) < 0) {
-		return(-errno);
+		return -errno;
 	}
 
 	if(inode_out != NULL) *inode_out = buf.st_ino;
@@ -52,7 +52,7 @@ int stat_file(const char *path, unsigned
 	}
 	if(blksize_out != NULL) *blksize_out = buf.st_blksize;
 	if(blocks_out != NULL) *blocks_out = buf.st_blocks;
-	return(0);
+	return 0;
 }
 
 int file_type(const char *path, int *maj, int *min)
@@ -60,7 +60,7 @@ int file_type(const char *path, int *maj
  	struct stat64 buf;
 
 	if(lstat64(path, &buf) < 0)
-		return(-errno);
+		return -errno;
 	/*We cannot pass rdev as is because glibc and the kernel disagree
 	 *about its definition.*/
 	if(maj != NULL)
@@ -68,13 +68,13 @@ int file_type(const char *path, int *maj
 	if(min != NULL)
 		*min = minor(buf.st_rdev);
 
-	if(S_ISDIR(buf.st_mode)) return(OS_TYPE_DIR);
-	else if(S_ISLNK(buf.st_mode)) return(OS_TYPE_SYMLINK);
-	else if(S_ISCHR(buf.st_mode)) return(OS_TYPE_CHARDEV);
-	else if(S_ISBLK(buf.st_mode)) return(OS_TYPE_BLOCKDEV);
-	else if(S_ISFIFO(buf.st_mode))return(OS_TYPE_FIFO);
-	else if(S_ISSOCK(buf.st_mode))return(OS_TYPE_SOCK);
-	else return(OS_TYPE_FILE);
+	if(S_ISDIR(buf.st_mode)) return OS_TYPE_DIR;
+	else if(S_ISLNK(buf.st_mode)) return OS_TYPE_SYMLINK;
+	else if(S_ISCHR(buf.st_mode)) return OS_TYPE_CHARDEV;
+	else if(S_ISBLK(buf.st_mode)) return OS_TYPE_BLOCKDEV;
+	else if(S_ISFIFO(buf.st_mode))return OS_TYPE_FIFO;
+	else if(S_ISSOCK(buf.st_mode))return OS_TYPE_SOCK;
+	else return OS_TYPE_FILE;
 }
 
 int access_file(char *path, int r, int w, int x)
@@ -84,8 +84,9 @@ int access_file(char *path, int r, int w
 	if(r) mode = R_OK;
 	if(w) mode |= W_OK;
 	if(x) mode |= X_OK;
-	if(access(path, mode) != 0) return(-errno);
-	else return(0);
+	if(access(path, mode) != 0)
+		return -errno;
+	else return 0;
 }
 
 int open_file(char *path, int r, int w, int append)
@@ -103,8 +104,9 @@ int open_file(char *path, int r, int w, 
 	if(append)
 		mode |= O_APPEND;
 	fd = open64(path, mode);
-	if(fd < 0) return(-errno);
-	else return(fd);
+	if(fd < 0)
+		return -errno;
+	else return fd;
 }
 
 void *open_dir(char *path, int *err_out)
@@ -113,8 +115,9 @@ void *open_dir(char *path, int *err_out)
 
 	dir = opendir(path);
 	*err_out = errno;
-	if(dir == NULL) return(NULL);
-	return(dir);
+	if(dir == NULL)
+		return NULL;
+	return dir;
 }
 
 char *read_dir(void *stream, unsigned long long *pos,
@@ -125,11 +128,12 @@ char *read_dir(void *stream, unsigned lo
 
 	seekdir(dir, *pos);
 	ent = readdir(dir);
-	if(ent == NULL) return(NULL);
+	if(ent == NULL)
+		return NULL;
 	*len_out = strlen(ent->d_name);
 	*ino_out = ent->d_ino;
 	*pos = telldir(dir);
-	return(ent->d_name);
+	return ent->d_name;
 }
 
 int read_file(int fd, unsigned long long *offset, char *buf, int len)
@@ -137,9 +141,10 @@ int read_file(int fd, unsigned long long
 	int n;
 
 	n = pread64(fd, buf, len, *offset);
-	if(n < 0) return(-errno);
+	if(n < 0)
+		return -errno;
 	*offset += n;
-	return(n);
+	return n;
 }
 
 int write_file(int fd, unsigned long long *offset, const char *buf, int len)
@@ -147,9 +152,10 @@ int write_file(int fd, unsigned long lon
 	int n;
 
 	n = pwrite64(fd, buf, len, *offset);
-	if(n < 0) return(-errno);
+	if(n < 0)
+		return -errno;
 	*offset += n;
-	return(n);
+	return n;
 }
 
 int lseek_file(int fd, long long offset, int whence)
@@ -158,8 +164,8 @@ int lseek_file(int fd, long long offset,
 
 	ret = lseek64(fd, offset, whence);
 	if(ret < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 int fsync_file(int fd, int datasync)
@@ -202,8 +208,8 @@ int file_create(char *name, int ur, int 
 	mode |= ox ? S_IXOTH : 0;
 	fd = open64(name, O_CREAT | O_RDWR, mode);
 	if(fd < 0)
-		return(-errno);
-	return(fd);
+		return -errno;
+	return fd;
 }
 
 int set_attr(const char *file, struct hostfs_iattr *attrs, int fd)
@@ -217,31 +223,31 @@ int set_attr(const char *file, struct ho
 			if (fchmod(fd, attrs->ia_mode) != 0)
 				return (-errno);
 		} else if (chmod(file, attrs->ia_mode) != 0) {
-			return (-errno);
+			return -errno;
 		}
 	}
 	if (attrs->ia_valid & HOSTFS_ATTR_UID) {
 		if (fd >= 0) {
 			if (fchown(fd, attrs->ia_uid, -1))
-				return (-errno);
+				return -errno;
 		} else if(chown(file, attrs->ia_uid, -1)) {
-			return (-errno);
+			return -errno;
 		}
 	}
 	if (attrs->ia_valid & HOSTFS_ATTR_GID) {
 		if (fd >= 0) {
 			if (fchown(fd, -1, attrs->ia_gid))
-				return (-errno);
+				return -errno;
 		} else if (chown(file, -1, attrs->ia_gid)) {
-			return (-errno);
+			return -errno;
 		}
 	}
 	if (attrs->ia_valid & HOSTFS_ATTR_SIZE) {
 		if (fd >= 0) {
 			if (ftruncate(fd, attrs->ia_size))
-				return (-errno);
+				return -errno;
 		} else if (truncate(file, attrs->ia_size)) {
-			return (-errno);
+			return -errno;
 		}
 	}
 
@@ -271,9 +277,9 @@ int set_attr(const char *file, struct ho
 
 		if (fd >= 0) {
 			if (futimes(fd, times) != 0)
-				return (-errno);
+				return -errno;
 		} else if (utimes(file, times) != 0) {
-			return (-errno);
+			return -errno;
 		}
 	}
 
@@ -282,9 +288,10 @@ int set_attr(const char *file, struct ho
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
 				NULL, NULL, fd);
-		if(err != 0) return(err);
+		if(err != 0)
+			return err;
 	}
-	return(0);
+	return 0;
 }
 
 int make_symlink(const char *from, const char *to)
@@ -292,8 +299,9 @@ int make_symlink(const char *from, const
 	int err;
 
 	err = symlink(to, from);
-	if(err) return(-errno);
-	return(0);
+	if(err)
+		return -errno;
+	return 0;
 }
 
 int unlink_file(const char *file)
@@ -301,8 +309,9 @@ int unlink_file(const char *file)
 	int err;
 
 	err = unlink(file);
-	if(err) return(-errno);
-	return(0);
+	if(err)
+		return -errno;
+	return 0;
 }
 
 int do_mkdir(const char *file, int mode)
@@ -310,8 +319,9 @@ int do_mkdir(const char *file, int mode)
 	int err;
 
 	err = mkdir(file, mode);
-	if(err) return(-errno);
-	return(0);
+	if(err)
+		return -errno;
+	return 0;
 }
 
 int do_rmdir(const char *file)
@@ -319,8 +329,9 @@ int do_rmdir(const char *file)
 	int err;
 
 	err = rmdir(file);
-	if(err) return(-errno);
-	return(0);
+	if(err)
+		return -errno;
+	return 0;
 }
 
 int do_mknod(const char *file, int mode, unsigned int major, unsigned int minor)
@@ -328,8 +339,9 @@ int do_mknod(const char *file, int mode,
 	int err;
 
 	err = mknod(file, mode, makedev(major, minor));
-	if(err) return(-errno);
-	return(0);
+	if(err)
+		return -errno;
+	return 0;
 }
 
 int link_file(const char *to, const char *from)
@@ -337,8 +349,9 @@ int link_file(const char *to, const char
 	int err;
 
 	err = link(to, from);
-	if(err) return(-errno);
-	return(0);
+	if(err)
+		return -errno;
+	return 0;
 }
 
 int do_readlink(char *file, char *buf, int size)
@@ -347,10 +360,10 @@ int do_readlink(char *file, char *buf, i
 
 	n = readlink(file, buf, size);
 	if(n < 0)
-		return(-errno);
+		return -errno;
 	if(n < size)
 		buf[n] = '\0';
-	return(n);
+	return n;
 }
 
 int rename_file(char *from, char *to)
@@ -358,8 +371,9 @@ int rename_file(char *from, char *to)
 	int err;
 
 	err = rename(from, to);
-	if(err < 0) return(-errno);
-	return(0);
+	if(err < 0)
+		return -errno;
+	return 0;
 }
 
 int do_statfs(char *root, long *bsize_out, long long *blocks_out,
@@ -372,7 +386,9 @@ int do_statfs(char *root, long *bsize_ou
 	int err;
 
 	err = statfs64(root, &buf);
-	if(err < 0) return(-errno);
+	if(err < 0)
+		return -errno;
+
 	*bsize_out = buf.f_bsize;
 	*blocks_out = buf.f_blocks;
 	*bfree_out = buf.f_bfree;
@@ -388,16 +404,5 @@ int do_statfs(char *root, long *bsize_ou
 	spare_out[2] = buf.f_spare[2];
 	spare_out[3] = buf.f_spare[3];
 	spare_out[4] = buf.f_spare[4];
-	return(0);
+	return 0;
 }
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

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
uml-fix-prototypes.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
