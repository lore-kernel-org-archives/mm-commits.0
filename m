From: akpm@linux-foundation.org
Subject: + tmpfs-implement-xattr-support-for-the-entire-security-namespace.patch added to -mm tree
Date: Tue, 10 May 2011 17:17:17 -0700
Message-ID: <201105110017.p4B0HH9h031338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab1EKARc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 20:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, akpm@linux-foundation.org, hch@lst.de, hughd@google.com, jmorris@namei.org, serge.hallyn@ubuntu.com


The patch titled
     tmpfs: implement xattr support for the entire security namespace
has been added to the -mm tree.  Its filename is
     tmpfs-implement-xattr-support-for-the-entire-security-namespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: implement xattr support for the entire security namespace
From: Eric Paris <eparis@redhat.com>

Implement security namespace xattrs for tmpfs filesystems.  The feodra
project, while trying to replace suid apps with file capabilities,
realized that tmpfs, which is used on the build systems, does not support
file capabilities and thus cannot be used to build packages which use file
capabilities.

The xattr interface is a bit odd.  If a filesystem does not implement any
{get,set,list}xattr functions the VFS will call into some random LSM hooks
and the running LSM can then implement some method for handling xattrs. 
SELinux for example provides a method to support security.selinux but no
other security.* xattrs.

As it stands today when one enables CONFIG_TMPFS_POSIX_ACL tmpfs will have
xattr handler routines specifically to handle acls.  Because of this tmpfs
would loose the VFS/LSM helpers to support the running LSM.  To make up
for that tmpfs had stub functions that did nothing but call into the LSM
hooks which implement the helpers.

This new patch does not use the LSM fallback functions and instead just
implements a native get/set/list xattr feature for the full security.*
namespace like a normal filesystem.  This means that tmpfs can now support
both security.selinux and security.capability, which was not previously
possible.

The basic implementation is that I attach a:

struct shmem_xattr {
	struct list_head list; /* anchored by shmem_inode_info->xattr_list */
	char *name;
	size_t size;
	char value[0];
};

Into the struct shmem_inode_info for each xattr that is set.  This
implementation could easily be turned into 2d array with one dimention
being the xattr prefix and one the xattr suffix.  That could result in an
easy implementation for user.* if we ever want it.  As it stands today
though I assume the prefix is always security.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig               |    4 +
 include/linux/shmem_fs.h |    1 
 mm/shmem.c               |  116 +++++++++++++++++++++++++++++++++----
 3 files changed, 111 insertions(+), 10 deletions(-)

diff -puN fs/Kconfig~tmpfs-implement-xattr-support-for-the-entire-security-namespace fs/Kconfig
--- a/fs/Kconfig~tmpfs-implement-xattr-support-for-the-entire-security-namespace
+++ a/fs/Kconfig
@@ -132,6 +132,10 @@ config TMPFS_POSIX_ACL
 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.
 
+	  Enablings this option will also enable support for the entire
+	  security.* xattr namespace.  This is to make up for support lost
+	  from the VFS/LSM when a filesystem has any xattr handler.
+
 	  If you don't know what Access Control Lists are, say N.
 
 config HUGETLBFS
diff -puN include/linux/shmem_fs.h~tmpfs-implement-xattr-support-for-the-entire-security-namespace include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-implement-xattr-support-for-the-entire-security-namespace
+++ a/include/linux/shmem_fs.h
@@ -19,6 +19,7 @@ struct shmem_inode_info {
 	struct page		*i_indirect;	/* top indirect blocks page */
 	swp_entry_t		i_direct[SHMEM_NR_DIRECT]; /* first blocks */
 	struct list_head	swaplist;	/* chain of maybes on swap */
+	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
 };
 
diff -puN mm/shmem.c~tmpfs-implement-xattr-support-for-the-entire-security-namespace mm/shmem.c
--- a/mm/shmem.c~tmpfs-implement-xattr-support-for-the-entire-security-namespace
+++ a/mm/shmem.c
@@ -99,6 +99,13 @@ static struct vfsmount *shm_mnt;
 /* Pretend that each entry is of this size in directory's i_size */
 #define BOGO_DIRENT_SIZE 20
 
+struct shmem_xattr {
+	struct list_head list;	/* anchored by shmem_inode_info->xattr_list */
+	char *name;		/* xattr suffix */
+	size_t size;
+	char value[0];
+};
+
 /* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
@@ -822,6 +829,7 @@ static int shmem_notify_change(struct de
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_xattr *xattr, *nxattr;
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
 		truncate_inode_pages(inode->i_mapping, 0);
@@ -834,6 +842,11 @@ static void shmem_evict_inode(struct ino
 			mutex_unlock(&shmem_swaplist_mutex);
 		}
 	}
+
+	list_for_each_entry_safe(xattr, nxattr, &info->xattr_list, list) {
+		kfree(xattr->name);
+		kfree(xattr);
+	}
 	BUG_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	end_writeback(inode);
@@ -1616,6 +1629,7 @@ static struct inode *shmem_get_inode(str
 		spin_lock_init(&info->lock);
 		info->flags = vm_flags & VM_NORESERVE;
 		INIT_LIST_HEAD(&info->swaplist);
+		INIT_LIST_HEAD(&info->xattr_list);
 		cache_no_acl(inode);
 
 		switch (mode & S_IFMT) {
@@ -2080,8 +2094,8 @@ static const struct inode_operations shm
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
 /*
- * Superblocks without xattr inode operations will get security.* xattr
- * support from the VFS "for free". As soon as we have any other xattrs
+ * Superblocks without xattr inode operations may get some security.* xattr
+ * support from the LSM "for free". As soon as we have any other xattrs
  * like ACLs, we also need to implement the security.* handlers at
  * filesystem level, though.
  */
@@ -2090,24 +2104,106 @@ static size_t shmem_xattr_security_list(
 					size_t list_len, const char *name,
 					size_t name_len, int handler_flags)
 {
-	return security_inode_listsecurity(dentry->d_inode, list, list_len);
+	struct shmem_xattr *xattr;
+	struct shmem_inode_info *info;
+	size_t used = 0;
+
+	info = SHMEM_I(dentry->d_inode);
+
+	spin_lock(&dentry->d_inode->i_lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		used += XATTR_SECURITY_PREFIX_LEN;
+		used += strlen(xattr->name) + 1;
+
+		if (list) {
+			if (list_len < used) {
+				used = -ERANGE;
+				break;
+			}
+			strncpy(list, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN);
+			list += XATTR_SECURITY_PREFIX_LEN;
+			strncpy(list, xattr->name, strlen(xattr->name) + 1);
+			list += strlen(xattr->name) + 1;
+		}
+	}
+	spin_unlock(&dentry->d_inode->i_lock);
+
+	return used;
 }
 
 static int shmem_xattr_security_get(struct dentry *dentry, const char *name,
 		void *buffer, size_t size, int handler_flags)
 {
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	return xattr_getsecurity(dentry->d_inode, name, buffer, size);
+	struct shmem_inode_info *info;
+	struct shmem_xattr *xattr;
+	int ret = -ENODATA;
+
+	info = SHMEM_I(dentry->d_inode);
+
+	spin_lock(&dentry->d_inode->i_lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		if (strcmp(name, xattr->name))
+			continue;
+
+		ret = xattr->size;
+		if (buffer) {
+			if (size < xattr->size)
+				ret = -ERANGE;
+			else
+				memcpy(buffer, xattr->value, xattr->size);
+		}
+		break;
+	}
+	spin_unlock(&dentry->d_inode->i_lock);
+	return ret;
 }
 
+/*
+ * We only handle security.* but we could potentially store the prefix
+ * as well as the suffix in struct shmem_xattr and support *.*
+ */
 static int shmem_xattr_security_set(struct dentry *dentry, const char *name,
 		const void *value, size_t size, int flags, int handler_flags)
 {
-	if (strcmp(name, "") == 0)
-		return -EINVAL;
-	return security_inode_setsecurity(dentry->d_inode, name, value,
-					  size, flags);
+	struct inode *inode = dentry->d_inode;
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct shmem_xattr *xattr;
+	struct shmem_xattr *new_xattr;
+	size_t len;
+
+	/* wrap around? */
+	len = sizeof(*new_xattr) + size;
+	if (len <= sizeof(*new_xattr))
+		return -ENOMEM;
+
+	new_xattr = kmalloc(len, GFP_NOFS);
+	if (!new_xattr)
+		return -ENOMEM;
+
+	new_xattr->name = kstrdup(name, GFP_NOFS);
+	if (!new_xattr->name) {
+		kfree(new_xattr);
+		return -ENOMEM;
+	}
+
+	new_xattr->size = size;
+	memcpy(new_xattr->value, value, size);
+
+	spin_lock(&inode->i_lock);
+	list_for_each_entry(xattr, &info->xattr_list, list) {
+		if (!strcmp(name, xattr->name)) {
+			list_replace(&xattr->list, &new_xattr->list);
+			goto out;
+		}
+	}
+	list_add(&new_xattr->list, &info->xattr_list);
+	xattr = NULL;
+out:
+	spin_unlock(&inode->i_lock);
+	if (xattr)
+		kfree(xattr->name);
+	kfree(xattr);
+	return 0;
 }
 
 static const struct xattr_handler shmem_xattr_security_handler = {
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
tmpfs-implement-xattr-support-for-the-entire-security-namespace.patch
xattrh-expose-string-defines-to-userspace.patch
flex_array-avoid-divisions-when-accessing-elements.patch

