From: akpm@osdl.org
Subject: + unionfs-extended-attributes-support.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:09:01 -0800
Message-ID: <200701082109.l08L91jp018943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXAHVJO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, dquigley@fsl.cs.sunysb.edu, ezk@cs.sunysb.edu


The patch titled
     unionfs: extended Attributes support
has been added to the -mm tree.  Its filename is
     unionfs-extended-attributes-support.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unionfs: extended Attributes support
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Extended attribute support.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: David Quigley <dquigley@fsl.cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/Kconfig          |    9 +++
 fs/unionfs/Makefile |    2 
 fs/unionfs/copyup.c |   75 +++++++++++++++++++++++++
 fs/unionfs/inode.c  |   12 ++++
 fs/unionfs/union.h  |   15 +++++
 fs/unionfs/xattr.c  |  123 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 236 insertions(+)

diff -puN fs/Kconfig~unionfs-extended-attributes-support fs/Kconfig
--- a/fs/Kconfig~unionfs-extended-attributes-support
+++ a/fs/Kconfig
@@ -1564,6 +1564,15 @@ config UNION_FS
 
 	  See <http://www.unionfs.org> for details
 
+config UNION_FS_XATTR
+	bool "Unionfs extended attributes"
+	depends on UNION_FS
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page).
+
+	  If unsure, say N.
+
 endmenu
 
 menu "Network File Systems"
diff -puN fs/unionfs/Makefile~unionfs-extended-attributes-support fs/unionfs/Makefile
--- a/fs/unionfs/Makefile~unionfs-extended-attributes-support
+++ a/fs/unionfs/Makefile
@@ -3,3 +3,5 @@ obj-$(CONFIG_UNION_FS) += unionfs.o
 unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
 	stale_inode.o branchman.o rdstate.o copyup.o dirhelper.o \
 	rename.o unlink.o lookup.o commonfops.o dirfops.o sioq.o
+
+unionfs-$(CONFIG_UNION_FS_XATTR) += xattr.o
diff -puN fs/unionfs/copyup.c~unionfs-extended-attributes-support fs/unionfs/copyup.c
--- a/fs/unionfs/copyup.c~unionfs-extended-attributes-support
+++ a/fs/unionfs/copyup.c
@@ -18,6 +18,75 @@
 
 #include "union.h"
 
+#ifdef CONFIG_UNION_FS_XATTR
+/* copyup all extended attrs for a given dentry */
+static int copyup_xattrs(struct dentry *old_hidden_dentry,
+			 struct dentry *new_hidden_dentry)
+{
+	int err = 0;
+	ssize_t list_size = -1;
+	char *name_list = NULL;
+	char *attr_value = NULL;
+	char *name_list_orig = NULL;
+
+	list_size = vfs_listxattr(old_hidden_dentry, NULL, 0);
+
+	if (list_size <= 0) {
+		err = list_size;
+		goto out;
+	}
+
+	name_list = unionfs_xattr_alloc(list_size + 1, XATTR_LIST_MAX);
+	if (!name_list || IS_ERR(name_list)) {
+		err = PTR_ERR(name_list);
+		goto out;
+	}
+	list_size = vfs_listxattr(old_hidden_dentry, name_list, list_size);
+	attr_value = unionfs_xattr_alloc(XATTR_SIZE_MAX, XATTR_SIZE_MAX);
+	if (!attr_value || IS_ERR(attr_value)) {
+		err = PTR_ERR(name_list);
+		goto out;
+	}
+	name_list_orig = name_list;
+	while (*name_list) {
+		ssize_t size;
+
+		/* Lock here since vfs_getxattr doesn't lock for us */
+		mutex_lock(&old_hidden_dentry->d_inode->i_mutex);
+		size = vfs_getxattr(old_hidden_dentry, name_list,
+				    attr_value, XATTR_SIZE_MAX);
+		mutex_unlock(&old_hidden_dentry->d_inode->i_mutex);
+		if (size < 0) {
+			err = size;
+			goto out;
+		}
+
+		if (size > XATTR_SIZE_MAX) {
+			err = -E2BIG;
+			goto out;
+		}
+		/* Don't lock here since vfs_setxattr does it for us. */
+		err = vfs_setxattr(new_hidden_dentry, name_list, attr_value,
+				   size, 0);
+
+		if (err < 0)
+			goto out;
+		name_list += strlen(name_list) + 1;
+	}
+      out:
+	name_list = name_list_orig;
+
+	if (name_list)
+		unionfs_xattr_free(name_list, list_size + 1);
+	if (attr_value)
+		unionfs_xattr_free(attr_value, XATTR_SIZE_MAX);
+	/* It is no big deal if this fails, we just roll with the punches. */
+	if (err == -ENOTSUPP || err == -EOPNOTSUPP)
+		err = 0;
+	return err;
+}
+#endif /* CONFIG_UNION_FS_XATTR */
+
 /* Determine the mode based on the copyup flags, and the existing dentry. */
 static int copyup_permissions(struct super_block *sb,
 			      struct dentry *old_hidden_dentry,
@@ -344,6 +413,12 @@ int copyup_named_dentry(struct inode *di
 	if ((err = copyup_permissions(sb, old_hidden_dentry, new_hidden_dentry)))
 		goto out_unlink;
 
+#ifdef CONFIG_UNION_FS_XATTR
+	/* Selinux uses extended attributes for permissions. */
+	if ((err = copyup_xattrs(old_hidden_dentry, new_hidden_dentry)))
+		goto out_unlink;
+#endif
+
 	/* do not allow files getting deleted to be reinterposed */
 	if (!d_deleted(dentry))
 		unionfs_reinterpose(dentry);
diff -puN fs/unionfs/inode.c~unionfs-extended-attributes-support fs/unionfs/inode.c
--- a/fs/unionfs/inode.c~unionfs-extended-attributes-support
+++ a/fs/unionfs/inode.c
@@ -930,10 +930,22 @@ struct inode_operations unionfs_dir_iops
 	.rename		= unionfs_rename,
 	.permission	= unionfs_permission,
 	.setattr	= unionfs_setattr,
+#ifdef CONFIG_UNION_FS_XATTR
+	.setxattr	= unionfs_setxattr,
+	.getxattr	= unionfs_getxattr,
+	.removexattr	= unionfs_removexattr,
+	.listxattr	= unionfs_listxattr,
+#endif
 };
 
 struct inode_operations unionfs_main_iops = {
 	.permission	= unionfs_permission,
 	.setattr	= unionfs_setattr,
+#ifdef CONFIG_UNION_FS_XATTR
+	.setxattr	= unionfs_setxattr,
+	.getxattr	= unionfs_getxattr,
+	.removexattr	= unionfs_removexattr,
+	.listxattr	= unionfs_listxattr,
+#endif
 };
 
diff -puN fs/unionfs/union.h~unionfs-extended-attributes-support fs/unionfs/union.h
--- a/fs/unionfs/union.h~unionfs-extended-attributes-support
+++ a/fs/unionfs/union.h
@@ -38,6 +38,7 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/writeback.h>
+#include <linux/xattr.h>
 #include <linux/fs_stack.h>
 #include <linux/magic.h>
 
@@ -327,6 +328,20 @@ int unionfs_ioctl_queryfile(struct file 
 /* Verify that a branch is valid. */
 int check_branch(struct nameidata *nd);
 
+#ifdef CONFIG_UNION_FS_XATTR
+/* Extended attribute functions. */
+extern void *unionfs_xattr_alloc(size_t size, size_t limit);
+extern void unionfs_xattr_free(void *ptr, size_t size);
+
+extern ssize_t unionfs_getxattr(struct dentry *dentry, const char *name,
+		void *value, size_t size);
+extern int unionfs_removexattr(struct dentry *dentry, const char *name);
+extern ssize_t unionfs_listxattr(struct dentry *dentry, char *list,
+		size_t size);
+extern int unionfs_setxattr(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags);
+#endif /* CONFIG_UNION_FS_XATTR */
+
 /* The root directory is unhashed, but isn't deleted. */
 static inline int d_deleted(struct dentry *d)
 {
diff -puN /dev/null fs/unionfs/xattr.c
--- /dev/null
+++ a/fs/unionfs/xattr.c
@@ -0,0 +1,123 @@
+/*
+ * Copyright (c) 2003-2006 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2006 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2006 Stony Brook University
+ * Copyright (c) 2003-2006 The Research Foundation of State University of New York*
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/* This is lifted from fs/xattr.c */
+void *unionfs_xattr_alloc(size_t size, size_t limit)
+{
+	void *ptr;
+
+	if (size > limit)
+		return ERR_PTR(-E2BIG);
+
+	if (!size)		/* size request, no buffer is needed */
+		return NULL;
+	else if (size <= PAGE_SIZE)
+		ptr = kmalloc(size, GFP_KERNEL);
+	else
+		ptr = vmalloc(size);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+	return ptr;
+}
+
+void unionfs_xattr_free(void *ptr, size_t size)
+{
+	if (!size)		/* size request, no buffer was needed */
+		return;
+	else if (size <= PAGE_SIZE)
+		kfree(ptr);
+	else
+		vfree(ptr);
+}
+
+/* BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+ssize_t unionfs_getxattr(struct dentry * dentry, const char *name, void *value,
+		size_t size)
+{
+	struct dentry *hidden_dentry = NULL;
+	int err = -EOPNOTSUPP;
+
+	lock_dentry(dentry);
+
+	hidden_dentry = unionfs_lower_dentry(dentry);
+
+	err = vfs_getxattr(hidden_dentry, (char*) name, value, size);
+
+	unlock_dentry(dentry);
+	return err;
+}
+
+/* BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+int unionfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags)
+{
+	struct dentry *hidden_dentry = NULL;
+	int err = -EOPNOTSUPP;
+
+	lock_dentry(dentry);
+	hidden_dentry = unionfs_lower_dentry(dentry);
+
+	err = vfs_setxattr(hidden_dentry, (char*) name, (void*) value, size, flags);
+
+	unlock_dentry(dentry);
+	return err;
+}
+
+/* BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+int unionfs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct dentry *hidden_dentry = NULL;
+	int err = -EOPNOTSUPP;
+
+	lock_dentry(dentry);
+	hidden_dentry = unionfs_lower_dentry(dentry);
+
+	err = vfs_removexattr(hidden_dentry, (char*) name);
+
+	unlock_dentry(dentry);
+	return err;
+}
+
+/* BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+ssize_t unionfs_listxattr(struct dentry * dentry, char *list, size_t size)
+{
+	struct dentry *hidden_dentry = NULL;
+	int err = -EOPNOTSUPP;
+	char *encoded_list = NULL;
+
+	lock_dentry(dentry);
+
+	hidden_dentry = unionfs_lower_dentry(dentry);
+
+	encoded_list = list;
+	err = vfs_listxattr(hidden_dentry, encoded_list, size);
+
+	unlock_dentry(dentry);
+	return err;
+}
+
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

unionfs-documentation.patch
lookup_one_len_nd-lookup_one_len-with-nameidata-argument.patch
unionfs-branch-management-functionality.patch
unionfs-common-file-operations.patch
unionfs-copyup-functionality.patch
unionfs-dentry-operations.patch
unionfs-file-operations.patch
unionfs-directory-file-operations.patch
unionfs-directory-manipulation-helper-functions.patch
unionfs-inode-operations.patch
unionfs-lookup-helper-functions.patch
unionfs-main-module-functions.patch
unionfs-readdir-state.patch
unionfs-rename.patch
unionfs-privileged-operations-workqueue.patch
unionfs-handling-of-stale-inodes.patch
unionfs-miscellaneous-helper-functions.patch
unionfs-superblock-operations.patch
unionfs-helper-macros-inlines.patch
unionfs-internal-include-file.patch
unionfs-include-file.patch
unionfs-unlink.patch
unionfs-kconfig-and-makefile.patch
unionfs-extended-attributes-support.patch
