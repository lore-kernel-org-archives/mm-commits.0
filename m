From: akpm@linux-foundation.org
Subject: [merged] tmpfs-security-xattr-setting-on-inode-creation.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:31 -0700
Message-ID: <20120322201831.77E3BA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61078 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab2CVUSc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:32 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so401674yen.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.sakkinen@intel.com, hughd@google.com, james.l.morris@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: security xattr setting on inode creation
has been removed from the -mm tree.  Its filename was
     tmpfs-security-xattr-setting-on-inode-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: tmpfs: security xattr setting on inode creation

Adds to generic xattr support introduced in Linux 3.0 by implementing
initxattrs callback.  This enables consulting of security attributes from
LSM and EVM when inode is created.

[hughd@google.com: moved under CONFIG_TMPFS_XATTR, with memcpy in shmem_xattr_alloc]
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Reviewed-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   88 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 72 insertions(+), 16 deletions(-)

diff -puN mm/shmem.c~tmpfs-security-xattr-setting-on-inode-creation mm/shmem.c
--- a/mm/shmem.c~tmpfs-security-xattr-setting-on-inode-creation
+++ a/mm/shmem.c
@@ -1178,6 +1178,12 @@ static struct inode *shmem_get_inode(str
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
 
+#ifdef CONFIG_TMPFS_XATTR
+static int shmem_initxattrs(struct inode *, const struct xattr *, void *);
+#else
+#define shmem_initxattrs NULL
+#endif
+
 static int
 shmem_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
@@ -1490,7 +1496,7 @@ shmem_mknod(struct inode *dir, struct de
 	if (inode) {
 		error = security_inode_init_security(inode, dir,
 						     &dentry->d_name,
-						     NULL, NULL);
+						     shmem_initxattrs, NULL);
 		if (error) {
 			if (error != -EOPNOTSUPP) {
 				iput(inode);
@@ -1630,7 +1636,7 @@ static int shmem_symlink(struct inode *d
 		return -ENOSPC;
 
 	error = security_inode_init_security(inode, dir, &dentry->d_name,
-					     NULL, NULL);
+					     shmem_initxattrs, NULL);
 	if (error) {
 		if (error != -EOPNOTSUPP) {
 			iput(inode);
@@ -1704,6 +1710,66 @@ static void shmem_put_link(struct dentry
  * filesystem level, though.
  */
 
+/*
+ * Allocate new xattr and copy in the value; but leave the name to callers.
+ */
+static struct shmem_xattr *shmem_xattr_alloc(const void *value, size_t size)
+{
+	struct shmem_xattr *new_xattr;
+	size_t len;
+
+	/* wrap around? */
+	len = sizeof(*new_xattr) + size;
+	if (len <= sizeof(*new_xattr))
+		return NULL;
+
+	new_xattr = kmalloc(len, GFP_KERNEL);
+	if (!new_xattr)
+		return NULL;
+
+	new_xattr->size = size;
+	memcpy(new_xattr->value, value, size);
+	return new_xattr;
+}
+
+/*
+ * Callback for security_inode_init_security() for acquiring xattrs.
+ */
+static int shmem_initxattrs(struct inode *inode,
+			    const struct xattr *xattr_array,
+			    void *fs_info)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	const struct xattr *xattr;
+	struct shmem_xattr *new_xattr;
+	size_t len;
+
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		new_xattr = shmem_xattr_alloc(xattr->value, xattr->value_len);
+		if (!new_xattr)
+			return -ENOMEM;
+
+		len = strlen(xattr->name) + 1;
+		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
+					  GFP_KERNEL);
+		if (!new_xattr->name) {
+			kfree(new_xattr);
+			return -ENOMEM;
+		}
+
+		memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
+		       XATTR_SECURITY_PREFIX_LEN);
+		memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
+		       xattr->name, len);
+
+		spin_lock(&info->lock);
+		list_add(&new_xattr->list, &info->xattr_list);
+		spin_unlock(&info->lock);
+	}
+
+	return 0;
+}
+
 static int shmem_xattr_get(struct dentry *dentry, const char *name,
 			   void *buffer, size_t size)
 {
@@ -1731,24 +1797,17 @@ static int shmem_xattr_get(struct dentry
 	return ret;
 }
 
-static int shmem_xattr_set(struct dentry *dentry, const char *name,
+static int shmem_xattr_set(struct inode *inode, const char *name,
 			   const void *value, size_t size, int flags)
 {
-	struct inode *inode = dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_xattr *xattr;
 	struct shmem_xattr *new_xattr = NULL;
-	size_t len;
 	int err = 0;
 
 	/* value == NULL means remove */
 	if (value) {
-		/* wrap around? */
-		len = sizeof(*new_xattr) + size;
-		if (len <= sizeof(*new_xattr))
-			return -ENOMEM;
-
-		new_xattr = kmalloc(len, GFP_KERNEL);
+		new_xattr = shmem_xattr_alloc(value, size);
 		if (!new_xattr)
 			return -ENOMEM;
 
@@ -1757,9 +1816,6 @@ static int shmem_xattr_set(struct dentry
 			kfree(new_xattr);
 			return -ENOMEM;
 		}
-
-		new_xattr->size = size;
-		memcpy(new_xattr->value, value, size);
 	}
 
 	spin_lock(&info->lock);
@@ -1858,7 +1914,7 @@ static int shmem_setxattr(struct dentry 
 	if (size == 0)
 		value = "";  /* empty EA, do not remove */
 
-	return shmem_xattr_set(dentry, name, value, size, flags);
+	return shmem_xattr_set(dentry->d_inode, name, value, size, flags);
 
 }
 
@@ -1878,7 +1934,7 @@ static int shmem_removexattr(struct dent
 	if (err)
 		return err;
 
-	return shmem_xattr_set(dentry, name, NULL, 0, XATTR_REPLACE);
+	return shmem_xattr_set(dentry->d_inode, name, NULL, 0, XATTR_REPLACE);
 }
 
 static bool xattr_is_trusted(const char *name)
_

Patches currently in -mm which might be from jarkko.sakkinen@intel.com are

origin.patch

