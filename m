From: akpm@linux-foundation.org
Subject: + hfsplus-integrate-posix-acls-support-into-driver.patch added to -mm tree
Date: Mon, 29 Jul 2013 13:08:01 -0700
Message-ID: <51f6cba1.IHa+KzcV7EudPQpX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab3G2UIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 16:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-integrate-posix-acls-support-into-driver.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 13:08:01 -0700


The patch titled
     Subject: hfsplus: integrate POSIX ACLs support into driver
has been added to the -mm tree.  Its filename is
     hfsplus-integrate-posix-acls-support-into-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-integrate-posix-acls-support-into-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-integrate-posix-acls-support-into-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: integrate POSIX ACLs support into driver

Integrate implemented POSIX ACLs support into hfsplus driver.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/Makefile         |    2 +
 fs/hfsplus/dir.c            |    4 ++
 fs/hfsplus/inode.c          |   11 ++++++
 fs/hfsplus/xattr.c          |   62 ++++++++++++++++++++++++++++++----
 fs/hfsplus/xattr.h          |   33 +++++++-----------
 fs/hfsplus/xattr_security.c |   13 +++++++
 6 files changed, 99 insertions(+), 26 deletions(-)

diff -puN fs/hfsplus/Makefile~hfsplus-integrate-posix-acls-support-into-driver fs/hfsplus/Makefile
--- a/fs/hfsplus/Makefile~hfsplus-integrate-posix-acls-support-into-driver
+++ a/fs/hfsplus/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_HFSPLUS_FS) += hfsplus.o
 hfsplus-objs := super.o options.o inode.o ioctl.o extents.o catalog.o dir.o btree.o \
 		bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o part_tbl.o \
 		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o
+
+hfsplus-$(CONFIG_HFSPLUS_FS_POSIX_ACL)	+= posix_acl.o
diff -puN fs/hfsplus/dir.c~hfsplus-integrate-posix-acls-support-into-driver fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-integrate-posix-acls-support-into-driver
+++ a/fs/hfsplus/dir.c
@@ -16,6 +16,7 @@
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 #include "xattr.h"
+#include "acl.h"
 
 static inline void hfsplus_instantiate(struct dentry *dentry,
 				       struct inode *inode, u32 cnid)
@@ -529,6 +530,9 @@ const struct inode_operations hfsplus_di
 	.getxattr		= generic_getxattr,
 	.listxattr		= hfsplus_listxattr,
 	.removexattr		= hfsplus_removexattr,
+#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
+	.get_acl		= hfsplus_get_posix_acl,
+#endif
 };
 
 const struct file_operations hfsplus_dir_operations = {
diff -puN fs/hfsplus/inode.c~hfsplus-integrate-posix-acls-support-into-driver fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-integrate-posix-acls-support-into-driver
+++ a/fs/hfsplus/inode.c
@@ -19,6 +19,7 @@
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 #include "xattr.h"
+#include "acl.h"
 
 static int hfsplus_readpage(struct file *file, struct page *page)
 {
@@ -316,6 +317,13 @@ static int hfsplus_setattr(struct dentry
 
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
+
+	if (attr->ia_valid & ATTR_MODE) {
+		error = hfsplus_posix_acl_chmod(inode);
+		if (unlikely(error))
+			return error;
+	}
+
 	return 0;
 }
 
@@ -383,6 +391,9 @@ static const struct inode_operations hfs
 	.getxattr	= generic_getxattr,
 	.listxattr	= hfsplus_listxattr,
 	.removexattr	= hfsplus_removexattr,
+#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
+	.get_acl	= hfsplus_get_posix_acl,
+#endif
 };
 
 static const struct file_operations hfsplus_file_operations = {
diff -puN fs/hfsplus/xattr.c~hfsplus-integrate-posix-acls-support-into-driver fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-integrate-posix-acls-support-into-driver
+++ a/fs/hfsplus/xattr.c
@@ -8,11 +8,16 @@
 
 #include "hfsplus_fs.h"
 #include "xattr.h"
+#include "acl.h"
 
 const struct xattr_handler *hfsplus_xattr_handlers[] = {
 	&hfsplus_xattr_osx_handler,
 	&hfsplus_xattr_user_handler,
 	&hfsplus_xattr_trusted_handler,
+#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
+	&hfsplus_xattr_acl_access_handler,
+	&hfsplus_xattr_acl_default_handler,
+#endif
 	&hfsplus_xattr_security_handler,
 	NULL
 };
@@ -46,11 +51,58 @@ static inline int is_known_namespace(con
 	return true;
 }
 
+static int can_set_system_xattr(struct inode *inode, const char *name,
+				const void *value, size_t size)
+{
+#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
+	struct posix_acl *acl;
+	int err;
+
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	/*
+	 * POSIX_ACL_XATTR_ACCESS is tied to i_mode
+	 */
+	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0) {
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			err = posix_acl_equiv_mode(acl, &inode->i_mode);
+			posix_acl_release(acl);
+			if (err < 0)
+				return err;
+			mark_inode_dirty(inode);
+		}
+		/*
+		 * We're changing the ACL.  Get rid of the cached one
+		 */
+		forget_cached_acl(inode, ACL_TYPE_ACCESS);
+
+		return 0;
+	} else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0) {
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		posix_acl_release(acl);
+
+		/*
+		 * We're changing the default ACL.  Get rid of the cached one
+		 */
+		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
+
+		return 0;
+	}
+#endif /* CONFIG_HFSPLUS_FS_POSIX_ACL */
+	return -EOPNOTSUPP;
+}
+
 static int can_set_xattr(struct inode *inode, const char *name,
 				const void *value, size_t value_len)
 {
 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return -EOPNOTSUPP; /* TODO: implement ACL support */
+		return can_set_system_xattr(inode, name, value, value_len);
 
 	if (!strncmp(name, XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN)) {
 		/*
@@ -253,11 +305,10 @@ static int copy_name(char *buffer, const
 	return len;
 }
 
-static ssize_t hfsplus_getxattr_finder_info(struct dentry *dentry,
+static ssize_t hfsplus_getxattr_finder_info(struct inode *inode,
 						void *value, size_t size)
 {
 	ssize_t res = 0;
-	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
 	u16 entry_type;
 	u16 folder_rec_len = sizeof(struct DInfo) + sizeof(struct DXInfo);
@@ -304,10 +355,9 @@ end_getxattr_finder_info:
 	return res;
 }
 
-ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
+ssize_t __hfsplus_getxattr(struct inode *inode, const char *name,
 			 void *value, size_t size)
 {
-	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
 	hfsplus_attr_entry *entry;
 	__be32 xattr_record_type;
@@ -333,7 +383,7 @@ ssize_t hfsplus_getxattr(struct dentry *
 	}
 
 	if (!strcmp_xattr_finder_info(name))
-		return hfsplus_getxattr_finder_info(dentry, value, size);
+		return hfsplus_getxattr_finder_info(inode, value, size);
 
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
 		return -EOPNOTSUPP;
diff -puN fs/hfsplus/xattr.h~hfsplus-integrate-posix-acls-support-into-driver fs/hfsplus/xattr.h
--- a/fs/hfsplus/xattr.h~hfsplus-integrate-posix-acls-support-into-driver
+++ a/fs/hfsplus/xattr.h
@@ -14,8 +14,8 @@
 extern const struct xattr_handler hfsplus_xattr_osx_handler;
 extern const struct xattr_handler hfsplus_xattr_user_handler;
 extern const struct xattr_handler hfsplus_xattr_trusted_handler;
-/*extern const struct xattr_handler hfsplus_xattr_acl_access_handler;*/
-/*extern const struct xattr_handler hfsplus_xattr_acl_default_handler;*/
+extern const struct xattr_handler hfsplus_xattr_acl_access_handler;
+extern const struct xattr_handler hfsplus_xattr_acl_default_handler;
 extern const struct xattr_handler hfsplus_xattr_security_handler;
 
 extern const struct xattr_handler *hfsplus_xattr_handlers[];
@@ -29,9 +29,17 @@ static inline int hfsplus_setxattr(struc
 	return __hfsplus_setxattr(dentry->d_inode, name, value, size, flags);
 }
 
-ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
+ssize_t __hfsplus_getxattr(struct inode *inode, const char *name,
 			void *value, size_t size);
 
+static inline ssize_t hfsplus_getxattr(struct dentry *dentry,
+					const char *name,
+					void *value,
+					size_t size)
+{
+	return __hfsplus_getxattr(dentry->d_inode, name, value, size);
+}
+
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 int hfsplus_removexattr(struct dentry *dentry, const char *name);
@@ -39,22 +47,7 @@ int hfsplus_removexattr(struct dentry *d
 int hfsplus_init_security(struct inode *inode, struct inode *dir,
 				const struct qstr *qstr);
 
-static inline int hfsplus_init_acl(struct inode *inode, struct inode *dir)
-{
-	/*TODO: implement*/
-	return 0;
-}
-
-static inline int hfsplus_init_inode_security(struct inode *inode,
-						struct inode *dir,
-						const struct qstr *qstr)
-{
-	int err;
-
-	err = hfsplus_init_acl(inode, dir);
-	if (!err)
-		err = hfsplus_init_security(inode, dir, qstr);
-	return err;
-}
+int hfsplus_init_inode_security(struct inode *inode, struct inode *dir,
+				const struct qstr *qstr);
 
 #endif
diff -puN fs/hfsplus/xattr_security.c~hfsplus-integrate-posix-acls-support-into-driver fs/hfsplus/xattr_security.c
--- a/fs/hfsplus/xattr_security.c~hfsplus-integrate-posix-acls-support-into-driver
+++ a/fs/hfsplus/xattr_security.c
@@ -9,6 +9,7 @@
 #include <linux/security.h>
 #include "hfsplus_fs.h"
 #include "xattr.h"
+#include "acl.h"
 
 static int hfsplus_security_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
@@ -96,6 +97,18 @@ int hfsplus_init_security(struct inode *
 					&hfsplus_initxattrs, NULL);
 }
 
+int hfsplus_init_inode_security(struct inode *inode,
+						struct inode *dir,
+						const struct qstr *qstr)
+{
+	int err;
+
+	err = hfsplus_init_posix_acl(inode, dir);
+	if (!err)
+		err = hfsplus_init_security(inode, dir, qstr);
+	return err;
+}
+
 const struct xattr_handler hfsplus_xattr_security_handler = {
 	.prefix	= XATTR_SECURITY_PREFIX,
 	.list	= hfsplus_security_listxattr,
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-necessary-declarations-for-posix-acls-support.patch
hfsplus-implement-posix-acls-support.patch
hfsplus-integrate-posix-acls-support-into-driver.patch

