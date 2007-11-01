From: akpm@linux-foundation.org
Subject: + vfs-security-rework-inode_getsecurity-and-callers-to.patch added to -mm tree
Date: Thu, 01 Nov 2007 12:35:54 -0700
Message-ID: <20071101193554.8CDDF432BDC@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49114 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbXKATh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 15:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dpquigl@tycho.nsa.gov, casey@schaufler-ca.com, chrisw@sous-sol.org, hch@lst.de, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     VFS/Security: Rework inode_getsecurity and callers to return resulting buffer
has been added to the -mm tree.  Its filename is
     vfs-security-rework-inode_getsecurity-and-callers-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS/Security: Rework inode_getsecurity and callers to return resulting buffer
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>

This patch modifies the interface to inode_getsecurity to have the function
return a buffer containing the security blob and its length via parameters
instead of relying on the calling function to give it an appropriately sized
buffer.

Security blobs obtained with this function should be freed using the
release_secctx LSM hook.  This alleviates the problem of the caller having to
guess a length and preallocate a buffer for this function allowing it to be
used elsewhere for Labeled NFS.

The patch also removed the unused err parameter.  The conversion is similar to
the one performed by Al Viro for the security_getprocattr hook.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c               |   30 ++++++++++++++++++++++++-
 include/linux/security.h |   21 +++++++-----------
 include/linux/xattr.h    |    1 
 mm/shmem.c               |    3 --
 security/dummy.c         |    2 -
 security/security.c      |    4 +--
 security/selinux/hooks.c |   43 ++++++++++++-------------------------
 7 files changed, 57 insertions(+), 47 deletions(-)

diff -puN fs/xattr.c~vfs-security-rework-inode_getsecurity-and-callers-to fs/xattr.c
--- a/fs/xattr.c~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/fs/xattr.c
@@ -105,6 +105,33 @@ out:
 EXPORT_SYMBOL_GPL(vfs_setxattr);
 
 ssize_t
+xattr_getsecurity(struct inode *inode, const char *name, void *value,
+			size_t size)
+{
+	void *buffer = NULL;
+	ssize_t len;
+
+	if (!value || !size) {
+		len = security_inode_getsecurity(inode, name, &buffer, false);
+		goto out_noalloc;
+	}
+
+	len = security_inode_getsecurity(inode, name, &buffer, true);
+	if (len < 0)
+		return len;
+	if (size < len) {
+		len = -ERANGE;
+		goto out;
+	}
+	memcpy(value, buffer, len);
+out:
+	security_release_secctx(buffer, len);
+out_noalloc:
+	return len;
+}
+EXPORT_SYMBOL_GPL(xattr_getsecurity);
+
+ssize_t
 vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
@@ -126,8 +153,7 @@ vfs_getxattr(struct dentry *dentry, char
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 				XATTR_SECURITY_PREFIX_LEN)) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
-		int ret = security_inode_getsecurity(inode, suffix, value,
-						     size, error);
+		int ret = xattr_getsecurity(inode, suffix, value, size);
 		/*
 		 * Only overwrite the return value if a security module
 		 * is actually active.
diff -puN include/linux/security.h~vfs-security-rework-inode_getsecurity-and-callers-to include/linux/security.h
--- a/include/linux/security.h~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/include/linux/security.h
@@ -404,15 +404,12 @@ struct request_sock;
  * 	identified by @name for @dentry.
  * 	Return 0 if permission is granted.
  * @inode_getsecurity:
- *	Copy the extended attribute representation of the security label 
- *	associated with @name for @inode into @buffer.  @buffer may be
- *	NULL to request the size of the buffer required.  @size indicates
- *	the size of @buffer in bytes.  Note that @name is the remainder
- *	of the attribute name after the security. prefix has been removed.
- *	@err is the return value from the preceding fs getxattr call,
- *	and can be used by the security module to determine whether it
- *	should try and canonicalize the attribute value.
- *	Return number of bytes used/required on success.
+ *	Retrieve a copy of the extended attribute representation of the
+ *	security label associated with @name for @inode via @buffer.  Note that
+ *	@name is the remainder of the attribute name after the security prefix
+ *	has been removed. @alloc is used to specify of the call should return a
+ *	value via the buffer or just the value length Return size of buffer on
+ *	success.
  * @inode_setsecurity:
  *	Set the security label associated with @name for @inode from the
  *	extended attribute value @value.  @size indicates the size of the
@@ -1275,7 +1272,7 @@ struct security_operations {
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
-  	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
+	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
 
@@ -1529,7 +1526,7 @@ int security_inode_listxattr(struct dent
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
-int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
+int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 int security_file_permission(struct file *file, int mask);
@@ -1933,7 +1930,7 @@ static inline int security_inode_killpri
 	return cap_inode_killpriv(dentry);
 }
 
-static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
 {
 	return -EOPNOTSUPP;
 }
diff -puN include/linux/xattr.h~vfs-security-rework-inode_getsecurity-and-callers-to include/linux/xattr.h
--- a/include/linux/xattr.h~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/include/linux/xattr.h
@@ -46,6 +46,7 @@ struct xattr_handler {
 		   size_t size, int flags);
 };
 
+ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
diff -puN mm/shmem.c~vfs-security-rework-inode_getsecurity-and-callers-to mm/shmem.c
--- a/mm/shmem.c~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/mm/shmem.c
@@ -1870,8 +1870,7 @@ static int shmem_xattr_security_get(stru
 {
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
-	return security_inode_getsecurity(inode, name, buffer, size,
-					  -EOPNOTSUPP);
+	return xattr_getsecurity(inode, name, buffer, size);
 }
 
 static int shmem_xattr_security_set(struct inode *inode, const char *name,
diff -puN security/dummy.c~vfs-security-rework-inode_getsecurity-and-callers-to security/dummy.c
--- a/security/dummy.c~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/security/dummy.c
@@ -384,7 +384,7 @@ static int dummy_inode_killpriv(struct d
 	return 0;
 }
 
-static int dummy_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+static int dummy_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
 {
 	return -EOPNOTSUPP;
 }
diff -puN security/security.c~vfs-security-rework-inode_getsecurity-and-callers-to security/security.c
--- a/security/security.c~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/security/security.c
@@ -479,11 +479,11 @@ int security_inode_killpriv(struct dentr
 	return security_ops->inode_killpriv(dentry);
 }
 
-int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_getsecurity(inode, name, buffer, size, err);
+	return security_ops->inode_getsecurity(inode, name, buffer, alloc);
 }
 
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
diff -puN security/selinux/hooks.c~vfs-security-rework-inode_getsecurity-and-callers-to security/selinux/hooks.c
--- a/security/selinux/hooks.c~vfs-security-rework-inode_getsecurity-and-callers-to
+++ a/security/selinux/hooks.c
@@ -127,32 +127,6 @@ static DEFINE_SPINLOCK(sb_security_lock)
 
 static struct kmem_cache *sel_inode_cache;
 
-/* Return security context for a given sid or just the context 
-   length if the buffer is null or length is 0 */
-static int selinux_getsecurity(u32 sid, void *buffer, size_t size)
-{
-	char *context;
-	unsigned len;
-	int rc;
-
-	rc = security_sid_to_context(sid, &context, &len);
-	if (rc)
-		return rc;
-
-	if (!buffer || !size)
-		goto getsecurity_exit;
-
-	if (size < len) {
-		len = -ERANGE;
-		goto getsecurity_exit;
-	}
-	memcpy(buffer, context, len);
-
-getsecurity_exit:
-	kfree(context);
-	return len;
-}
-
 /* Allocate and free functions for each kind of security blob. */
 
 static int task_alloc_security(struct task_struct *task)
@@ -2416,14 +2390,27 @@ static int selinux_inode_removexattr (st
  *
  * Permission check is handled by selinux_inode_getxattr hook.
  */
-static int selinux_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+static int selinux_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc)
 {
+	u32 size;
+	int error;
+	char *context = NULL;
 	struct inode_security_struct *isec = inode->i_security;
 
 	if (strcmp(name, XATTR_SELINUX_SUFFIX))
 		return -EOPNOTSUPP;
 
-	return selinux_getsecurity(isec->sid, buffer, size);
+	error = security_sid_to_context(isec->sid, &context, &size);
+	if (error)
+		return error;
+	error = size;
+	if (alloc) {
+		*buffer = context;
+		goto out_nofree;
+	}
+	kfree(context);
+out_nofree:
+	return error;
 }
 
 static int selinux_inode_setsecurity(struct inode *inode, const char *name,
_

Patches currently in -mm which might be from dpquigl@tycho.nsa.gov are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls.patch
