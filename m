From: akpm@linux-foundation.org
Subject: [to-be-updated] tmpfs-implement-xattr-support-for-the-entire-security-namespace-update.patch removed from -mm tree
Date: Wed, 11 May 2011 15:56:31 -0700
Message-ID: <201105112332.p4BNWutt001186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab1EKXdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 19:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, eparis@redhat.com, hch@lst.de, hughd@google.com, jmorris@namei.org, mszeredi@suse.cz, serge.hallyn@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs-implement-xattr-support-for-the-entire-security-namespace-update
has been removed from the -mm tree.  Its filename was
     tmpfs-implement-xattr-support-for-the-entire-security-namespace-update.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs-implement-xattr-support-for-the-entire-security-namespace-update
From: Miklos Szeredi <miklos@szeredi.hu>

new config option, suport trusted.*, support symlinks]

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   22 ++-
 mm/shmem.c |  298 +++++++++++++++++++++++++++++++++++----------------
 2 files changed, 224 insertions(+), 96 deletions(-)

diff -puN fs/Kconfig~tmpfs-implement-xattr-support-for-the-entire-security-namespace-update fs/Kconfig
--- a/fs/Kconfig~tmpfs-implement-xattr-support-for-the-entire-security-namespace-update
+++ a/fs/Kconfig
@@ -121,9 +121,25 @@ config TMPFS
 
 	  See <file:Documentation/filesystems/tmpfs.txt> for details.
 
+config TMPFS_XATTR
+	bool "Tmpfs extended attributes"
+	depends on TMPFS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  Currently this enables support for the trusted.* and
+	  security.* namespaces.
+
+	  If unsure, say N.
+
+	  You need this for POSIX ACL support on tmpfs.
+
 config TMPFS_POSIX_ACL
 	bool "Tmpfs POSIX Access Control Lists"
-	depends on TMPFS
+	depends on TMPFS_XATTR
 	select GENERIC_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
@@ -132,10 +148,6 @@ config TMPFS_POSIX_ACL
 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.
 
-	  Enablings this option will also enable support for the entire
-	  security.* xattr namespace.  This is to make up for support lost
-	  from the VFS/LSM when a filesystem has any xattr handler.
-
 	  If you don't know what Access Control Lists are, say N.
 
 config HUGETLBFS
diff -puN mm/shmem.c~tmpfs-implement-xattr-support-for-the-entire-security-namespace-update mm/shmem.c
--- a/mm/shmem.c~tmpfs-implement-xattr-support-for-the-entire-security-namespace-update
+++ a/mm/shmem.c
@@ -101,7 +101,7 @@ static struct vfsmount *shm_mnt;
 
 struct shmem_xattr {
 	struct list_head list;	/* anchored by shmem_inode_info->xattr_list */
-	char *name;		/* xattr suffix */
+	char *name;		/* xattr name */
 	size_t size;
 	char value[0];
 };
@@ -2081,18 +2081,7 @@ static void shmem_put_link(struct dentry
 	}
 }
 
-static const struct inode_operations shmem_symlink_inline_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= shmem_follow_link_inline,
-};
-
-static const struct inode_operations shmem_symlink_inode_operations = {
-	.readlink	= generic_readlink,
-	.follow_link	= shmem_follow_link,
-	.put_link	= shmem_put_link,
-};
-
-#ifdef CONFIG_TMPFS_POSIX_ACL
+#ifdef CONFIG_TMPFS_XATTR
 /*
  * Superblocks without xattr inode operations may get some security.* xattr
  * support from the LSM "for free". As soon as we have any other xattrs
@@ -2100,39 +2089,8 @@ static const struct inode_operations shm
  * filesystem level, though.
  */
 
-static size_t shmem_xattr_security_list(struct dentry *dentry, char *list,
-					size_t list_len, const char *name,
-					size_t name_len, int handler_flags)
-{
-	struct shmem_xattr *xattr;
-	struct shmem_inode_info *info;
-	size_t used = 0;
-
-	info = SHMEM_I(dentry->d_inode);
-
-	spin_lock(&dentry->d_inode->i_lock);
-	list_for_each_entry(xattr, &info->xattr_list, list) {
-		used += XATTR_SECURITY_PREFIX_LEN;
-		used += strlen(xattr->name) + 1;
-
-		if (list) {
-			if (list_len < used) {
-				used = -ERANGE;
-				break;
-			}
-			strncpy(list, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN);
-			list += XATTR_SECURITY_PREFIX_LEN;
-			strncpy(list, xattr->name, strlen(xattr->name) + 1);
-			list += strlen(xattr->name) + 1;
-		}
-	}
-	spin_unlock(&dentry->d_inode->i_lock);
-
-	return used;
-}
-
-static int shmem_xattr_security_get(struct dentry *dentry, const char *name,
-		void *buffer, size_t size, int handler_flags)
+static int shmem_xattr_get(struct dentry *dentry, const char *name,
+			   void *buffer, size_t size)
 {
 	struct shmem_inode_info *info;
 	struct shmem_xattr *xattr;
@@ -2158,46 +2116,58 @@ static int shmem_xattr_security_get(stru
 	return ret;
 }
 
-/*
- * We only handle security.* but we could potentially store the prefix
- * as well as the suffix in struct shmem_xattr and support *.*
- */
-static int shmem_xattr_security_set(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags, int handler_flags)
+static int shmem_xattr_set(struct dentry *dentry, const char *name,
+			   const void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_xattr *xattr;
-	struct shmem_xattr *new_xattr;
+	struct shmem_xattr *new_xattr = NULL;
 	size_t len;
+	int err = 0;
 
-	/* wrap around? */
-	len = sizeof(*new_xattr) + size;
-	if (len <= sizeof(*new_xattr))
-		return -ENOMEM;
-
-	new_xattr = kmalloc(len, GFP_NOFS);
-	if (!new_xattr)
-		return -ENOMEM;
+	/* value == NULL means remove */
+	if (value) {
+		/* wrap around? */
+		len = sizeof(*new_xattr) + size;
+		if (len <= sizeof(*new_xattr))
+			return -ENOMEM;
+
+		new_xattr = kmalloc(len, GFP_NOFS);
+		if (!new_xattr)
+			return -ENOMEM;
+
+		new_xattr->name = kstrdup(name, GFP_NOFS);
+		if (!new_xattr->name) {
+			kfree(new_xattr);
+			return -ENOMEM;
+		}
 
-	new_xattr->name = kstrdup(name, GFP_NOFS);
-	if (!new_xattr->name) {
-		kfree(new_xattr);
-		return -ENOMEM;
+		new_xattr->size = size;
+		memcpy(new_xattr->value, value, size);
 	}
 
-	new_xattr->size = size;
-	memcpy(new_xattr->value, value, size);
-
 	spin_lock(&inode->i_lock);
 	list_for_each_entry(xattr, &info->xattr_list, list) {
 		if (!strcmp(name, xattr->name)) {
-			list_replace(&xattr->list, &new_xattr->list);
+			if (flags & XATTR_CREATE) {
+				xattr = new_xattr;
+				err = -EEXIST;
+			} else if (new_xattr) {
+				list_replace(&xattr->list, &new_xattr->list);
+			} else {
+				list_del(&xattr->list);
+			}
 			goto out;
 		}
 	}
-	list_add(&new_xattr->list, &info->xattr_list);
-	xattr = NULL;
+	if (flags & XATTR_REPLACE) {
+		xattr = new_xattr;
+		err = -ENODATA;
+	} else {
+		list_add(&new_xattr->list, &info->xattr_list);
+		xattr = NULL;
+	}
 out:
 	spin_unlock(&inode->i_lock);
 	if (xattr)
@@ -2206,19 +2176,134 @@ out:
 	return 0;
 }
 
-static const struct xattr_handler shmem_xattr_security_handler = {
-	.prefix = XATTR_SECURITY_PREFIX,
-	.list   = shmem_xattr_security_list,
-	.get    = shmem_xattr_security_get,
-	.set    = shmem_xattr_security_set,
-};
 
 static const struct xattr_handler *shmem_xattr_handlers[] = {
+#ifdef CONFIG_TMPFS_POSIX_ACL
 	&generic_acl_access_handler,
 	&generic_acl_default_handler,
-	&shmem_xattr_security_handler,
+#endif
 	NULL
 };
+
+static int shmem_xattr_validate(const char *name)
+{
+	struct { const char *prefix; size_t len; } arr[] = {
+		{ XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN },
+		{ XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN }
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(arr); i++) {
+		size_t preflen = arr[i].len;
+		if (strncmp(name, arr[i].prefix, preflen) == 0) {
+			if (!name[preflen])
+				return -EINVAL;
+			return 0;
+		}
+	}
+	return -EOPNOTSUPP;
+}
+
+static ssize_t shmem_getxattr(struct dentry *dentry, const char *name,
+			      void *buffer, size_t size)
+{
+	int err;
+
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_getxattr(dentry, name, buffer, size);
+
+	err = shmem_xattr_validate(name);
+	if (err)
+		return err;
+
+	return shmem_xattr_get(dentry, name, buffer, size);
+}
+
+static int shmem_setxattr(struct dentry *dentry, const char *name,
+			  const void *value, size_t size, int flags)
+{
+	int err;
+
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_setxattr(dentry, name, value, size, flags);
+
+	err = shmem_xattr_validate(name);
+	if (err)
+		return err;
+
+	if (size == 0)
+		value = "";  /* empty EA, do not remove */
+
+	return shmem_xattr_set(dentry, name, value, size, flags);
+
+}
+
+static int shmem_removexattr(struct dentry *dentry, const char *name)
+{
+	int err;
+
+	/*
+	 * If this is a request for a synthetic attribute in the system.*
+	 * namespace use the generic infrastructure to resolve a handler
+	 * for it via sb->s_xattr.
+	 */
+	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
+		return generic_removexattr(dentry, name);
+
+	err = shmem_xattr_validate(name);
+	if (err)
+		return err;
+
+	return shmem_xattr_set(dentry, name, NULL, 0, XATTR_REPLACE);
+}
+
+static bool xattr_is_trusted(const char *name)
+{
+	return !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
+}
+
+static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
+{
+	bool trusted = capable(CAP_SYS_ADMIN);
+	struct shmem_xattr *xattr;
+	struct shmem_inode_info *info;
+	size_t used = 0;
+
+	info = SHMEM_I(dentry->d_inode);
+
+	spin_lock(&dentry->d_inode->i_lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		size_t len;
+
+		/* skip "trusted." attributes for unprivileged callers */
+		if (!trusted && xattr_is_trusted(xattr->name))
+			continue;
+
+		len = strlen(xattr->name) + 1;
+		used += len;
+		if (buffer) {
+			if (size < used) {
+				used = -ERANGE;
+				break;
+			}
+			memcpy(buffer, xattr->name, len);
+			buffer += len;
+		}
+	}
+	spin_unlock(&dentry->d_inode->i_lock);
+
+	return used;
+}
 #endif
 
 static struct dentry *shmem_get_parent(struct dentry *child)
@@ -2499,8 +2584,10 @@ int shmem_fill_super(struct super_block 
 	sb->s_magic = TMPFS_MAGIC;
 	sb->s_op = &shmem_ops;
 	sb->s_time_gran = 1;
-#ifdef CONFIG_TMPFS_POSIX_ACL
+#ifdef CONFIG_TMPFS_XATTR
 	sb->s_xattr = shmem_xattr_handlers;
+#endif
+#ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
 
@@ -2598,16 +2685,41 @@ static const struct file_operations shme
 static const struct inode_operations shmem_inode_operations = {
 	.setattr	= shmem_notify_change,
 	.truncate_range	= shmem_truncate_range,
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
 	.check_acl	= generic_check_acl,
 #endif
 
 };
 
+static const struct inode_operations shmem_symlink_inline_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= shmem_follow_link_inline,
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
+};
+
+static const struct inode_operations shmem_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= shmem_follow_link,
+	.put_link	= shmem_put_link,
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
+};
+
 static const struct inode_operations shmem_dir_inode_operations = {
 #ifdef CONFIG_TMPFS
 	.create		= shmem_create,
@@ -2620,23 +2732,27 @@ static const struct inode_operations shm
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
 #endif
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
 
 static const struct inode_operations shmem_special_inode_operations = {
+#ifdef CONFIG_TMPFS_XATTR
+	.setxattr	= shmem_setxattr,
+	.getxattr	= shmem_getxattr,
+	.listxattr	= shmem_listxattr,
+	.removexattr	= shmem_removexattr,
+#endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.listxattr	= generic_listxattr,
-	.removexattr	= generic_removexattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
_

Patches currently in -mm which might be from miklos@szeredi.hu are

tmpfs-implement-xattr-support-for-the-entire-security-namespace-update-fix.patch

