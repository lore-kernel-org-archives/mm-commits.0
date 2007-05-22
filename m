From: akpm@linux-foundation.org
Subject: - integrity-new-hooks.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:31 -0700
Message-ID: <200705222124.l4MLOVSs010109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916AbXEVV0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: new hooks
has been removed from the -mm tree.  Its filename was
     integrity-new-hooks.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: integrity: new hooks
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch adds integrity hooks used to implement an integrity service
provider and updates the previously submitted dummy provider to support these
new hooks.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/integrity.h  |  149 +++++++++++++++++++++++++++++++++--
 security/integrity.c       |    3 
 security/integrity_dummy.c |   99 ++++++++++++++++++++---
 security/integrity_dummy.h |    3 
 4 files changed, 233 insertions(+), 21 deletions(-)

diff -puN include/linux/integrity.h~integrity-new-hooks include/linux/integrity.h
--- a/include/linux/integrity.h~integrity-new-hooks
+++ a/include/linux/integrity.h
@@ -1,7 +1,7 @@
 /*
  * integrity.h
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -45,6 +45,45 @@
  *	@filename either contains the full pathname/short file name.
  *	@mask contains the filename permission status(i.e. read, write, append).
  *
+ * @inode_setxattr:
+ *	Check permission before permitting an integrity extended attribute
+ * 	to be set.
+ *	@value identified by @name for @dentry.
+ *	Return 0 if permission is granted.
+ *
+ * @inode_post_setxattr:
+ *	Update inode integrity xattr after successful setxattr operation.
+ * 	identified by @name for @dentry.
+ *
+ * @inode_alloc_integrity:
+ *	Allocate and attach an integrity structure to @inode->i_integrity.  The
+ * 	i_integrity field is initialized to NULL when the inode structure is
+ * 	allocated.
+ * 	@inode contains the inode structure.
+ * 	Return 0 if operation was successful.
+ *
+ * @inode_free_integrity:
+ *	@inode contains the inode structure.
+ * 	Deallocate the inode integrity structure and set @inode->i_integrity to
+ * 	NULL.
+ *
+ * @inode_init_integrity:
+ *	Create inode integrity xattr for a new inode based on the new security
+ * 	xattr information.
+ *	@inode contains the inode structure of the newly created inode.
+ *	@dir contains the inode structure of the parent directory.
+ * 	@name contains the security xattr name suffix.
+ *	@value contains the security attribute value.
+ *	@len contains the length of the security attribute value.
+ *
+ * @file_free_integrity:
+ *	Update the integrity xattr value as necessary.
+ * 	*file contains the file structure being closed.
+ *
+ * @d_instantiate:
+ *	Initialize the integrity structure of an inode for a dentry.
+ *	@dentry to complete.
+ *	@inode to attach to this dentry.
  */
 
 #define PASS_STR "INTEGRITY_PASS"
@@ -57,13 +96,22 @@ struct integrity_operations {
 	int (*verify_data) (struct dentry *dentry, int *status);
 	void (*measure) (struct dentry *dentry,
 			const unsigned char *filename, int mask);
+	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
+			       size_t size, int flags);
+	void (*inode_post_setxattr) (struct dentry *dentry, char *name);
+	int (*inode_alloc_integrity) (struct inode *inode);
+	void (*inode_free_integrity) (struct inode *inode);
+	void (*inode_init_integrity) (struct inode *inode, struct inode *dir,
+				    char **name, void **value, size_t *len);
+	void (*file_free_integrity) (struct file * file);
+	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 };
 extern int register_integrity(struct integrity_operations *ops);
 extern int unregister_integrity(struct integrity_operations *ops);
 
 /* global variables */
 extern struct integrity_operations *integrity_ops;
-enum integrity_verify_status {
+enum integrity_status {
 	INTEGRITY_PASS = 0, INTEGRITY_FAIL = -1, INTEGRITY_NOLABEL = -2
 };
 
@@ -77,8 +125,7 @@ static inline int integrity_verify_metad
 			xattr_value, xattr_val_len, status);
 }
 
-static inline int integrity_verify_data(struct dentry *dentry,
-					int *status)
+static inline int integrity_verify_data(struct dentry *dentry, int *status)
 {
 	return integrity_ops->verify_data(dentry, status);
 }
@@ -88,6 +135,55 @@ static inline void integrity_measure(str
 {
 	integrity_ops->measure(dentry, filename, mask);
 }
+
+static inline int integrity_inode_setxattr(struct dentry *dentry, char *name,
+					   void *value, size_t size, int flags)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return integrity_ops->inode_setxattr(dentry, name, value, size, flags);
+}
+
+static inline void integrity_inode_post_setxattr(struct dentry *dentry, char *name)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return;
+ 	integrity_ops->inode_post_setxattr(dentry, name);
+}
+
+static inline int integrity_inode_alloc(struct inode *inode)
+{
+	return integrity_ops->inode_alloc_integrity(inode);
+}
+
+static inline void integrity_inode_free(struct inode *inode)
+{
+	integrity_ops->inode_free_integrity(inode);
+}
+
+static inline void integrity_inode_init_integrity(struct inode *inode,
+						struct inode *dir,
+						char **name,
+						void **value,
+						size_t *len)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return;
+	integrity_ops->inode_init_integrity(inode, dir, name, value, len);
+	return;
+}
+
+static inline void integrity_file_free(struct file *file)
+{
+	integrity_ops->file_free_integrity(file);
+}
+
+static inline void integrity_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	if (unlikely (inode && IS_PRIVATE(inode)))
+		return;
+	integrity_ops->d_instantiate(dentry, inode);
+}
 #else
 static inline int integrity_verify_metadata(struct dentry *dentry,
 			char *xattr_name, char **xattr_value,
@@ -97,8 +193,7 @@ static inline int integrity_verify_metad
 	return 0;
 }
 
-static inline int integrity_verify_data(struct dentry *dentry,
-					int *status)
+static inline int integrity_verify_data(struct dentry *dentry, int *status)
 {
 	status = INTEGRITY_PASS;
 	return 0;
@@ -108,5 +203,47 @@ static inline void integrity_measure(str
 			const unsigned char *filename, int mask)
 {
 }
+
+static inline int integrity_inode_setxattr(struct dentry *dentry, char *name,
+					   void *value, size_t size, int flags)
+{
+	return 0;
+}
+
+static inline void integrity_inode_post_setxattr(struct dentry *dentry, char *name)
+{ }
+
+static inline int integrity_inode_alloc(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void integrity_inode_free(struct inode *inode)
+{ }
+
+static inline int integrity_inode_init_integrity(struct inode *inode,
+						struct inode *dir,
+						char **name,
+						void **value,
+						size_t *len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int integrity_file_permission(struct file *file, int mask)
+{
+	return 0;
+}
+
+static inline void integrity_file_free(struct file *file)
+{
+	return;
+}
+
+static inline void integrity_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	return;
+}
+
 #endif
 #endif
diff -puN security/integrity.c~integrity-new-hooks security/integrity.c
--- a/security/integrity.c~integrity-new-hooks
+++ a/security/integrity.c
@@ -3,7 +3,7 @@
  *
  * register integrity subsystem
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -27,6 +27,7 @@ int register_integrity(struct integrity_
 		return -EAGAIN;
 
 	integrity_ops = ops;
+	integrity_fixup_ops(integrity_ops);
 	return 0;
 }
 
diff -puN security/integrity_dummy.c~integrity-new-hooks security/integrity_dummy.c
--- a/security/integrity_dummy.c~integrity-new-hooks
+++ a/security/integrity_dummy.c
@@ -3,7 +3,7 @@
  *
  * Instantiate integrity subsystem
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/capability.h>
 #include <linux/integrity.h>
 #include <linux/xattr.h>
 
@@ -28,21 +29,24 @@ static int dummy_verify_metadata(struct 
 	int size = 0;
 	int error = 0;
 
-	if (!xattr_value || !xattr_value_len || !status)
+	if (!status)
 		return -EINVAL;
 
-	size = vfs_getxattr(dentry, xattr_name, NULL, 0);
-	if (size < 0) {
-		if (size == -ENODATA)
-			*status = INTEGRITY_NOLABEL;
-		return size;
+	/* get requested extended attribute */
+	if (xattr_name && xattr_value && xattr_value_len) {
+		size = vfs_getxattr(dentry, xattr_name, NULL, 0);
+		if (size < 0) {
+			if (size == -ENODATA)
+				*status = INTEGRITY_NOLABEL;
+			return size;
+		}
+
+		value = kzalloc(size + 1, GFP_KERNEL);
+		if (!value)
+			return -ENOMEM;
+		error = vfs_getxattr(dentry, xattr_name, value, size);
 	}
 
-	value = kzalloc(size + 1, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-	error = vfs_getxattr(dentry, xattr_name, value, size);
-
 	*xattr_value_len = size;
 	*xattr_value = value;
 	*status = INTEGRITY_PASS;
@@ -62,9 +66,78 @@ static void dummy_measure(struct dentry 
 	return;
 }
 
+static int dummy_inode_alloc_integrity(struct inode *inode)
+{
+	return 0;
+}
+
+static void dummy_inode_free_integrity(struct inode *inode)
+{
+	return;
+}
+
+static void dummy_inode_init_integrity(struct inode *inode, struct inode *dir,
+				      char **name, void **value, size_t * len)
+{
+	return;
+}
+
+static void dummy_file_free_integrity(struct file *file)
+{
+	return;
+}
+
+static int dummy_inode_setxattr(struct dentry *dentry, char *name, void *value,
+				size_t size, int flags)
+{
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	return 0;
+}
+
+static void dummy_inode_post_setxattr(struct dentry *dentry, char *name)
+{
+}
+
+static void dummy_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	return;
+}
+
 struct integrity_operations dummy_integrity_ops = {
 	.verify_metadata = dummy_verify_metadata,
 	.verify_data = dummy_verify_data,
-	.measure = dummy_measure
+	.measure = dummy_measure,
+	.inode_setxattr = dummy_inode_setxattr,
+	.inode_post_setxattr = dummy_inode_post_setxattr,
+	.inode_alloc_integrity = dummy_inode_alloc_integrity,
+	.inode_init_integrity = dummy_inode_init_integrity,
+	.inode_free_integrity = dummy_inode_free_integrity,
+	.file_free_integrity = dummy_file_free_integrity,
+	.d_instantiate = dummy_d_instantiate
 };
 
+#define set_to_dummy_if_null(ops, function)				\
+	do {								\
+		if (!ops->function) {					\
+			ops->function = dummy_##function;		\
+			printk(KERN_INFO "Had to override the " #function \
+			" security operation with the dummy one.\n");\
+			}						\
+	} while (0)
+
+void integrity_fixup_ops(struct integrity_operations *ops)
+{
+	set_to_dummy_if_null(ops, verify_metadata);
+	set_to_dummy_if_null(ops, verify_data);
+	set_to_dummy_if_null(ops, measure);
+	set_to_dummy_if_null(ops, inode_setxattr);
+	set_to_dummy_if_null(ops, inode_post_setxattr);
+	set_to_dummy_if_null(ops, inode_alloc_integrity);
+	set_to_dummy_if_null(ops, inode_init_integrity);
+	set_to_dummy_if_null(ops, inode_free_integrity);
+	set_to_dummy_if_null(ops, file_free_integrity);
+	set_to_dummy_if_null(ops, d_instantiate);
+}
diff -puN security/integrity_dummy.h~integrity-new-hooks security/integrity_dummy.h
--- a/security/integrity_dummy.h~integrity-new-hooks
+++ a/security/integrity_dummy.h
@@ -1,7 +1,7 @@
 /*
  * integrity_dummy.h
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  *
  *      This program is free software; you can redistribute it and/or modify
@@ -10,3 +10,4 @@
  */
 
 extern struct integrity_operations dummy_integrity_ops;
+extern void integrity_fixup_ops(struct integrity_operations *ops);
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-identifiers.patch
integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch
