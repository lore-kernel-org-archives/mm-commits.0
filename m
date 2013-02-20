From: akpm@linux-foundation.org
Subject: + hfsplus-integrate-of-implemented-acls-support-into-driver.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:02:26 -0800
Message-ID: <20130220230227.3FDE95A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:60738 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3BTXC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:02:28 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so841713qen.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:02:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de


The patch titled
     Subject: hfsplus: integrate implemented ACLs support into driver
has been added to the -mm tree.  Its filename is
     hfsplus-integrate-of-implemented-acls-support-into-driver.patch

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
Subject: hfsplus: integrate implemented ACLs support into driver

Integrate ACLs support into hfsplus driver.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/Makefile         |    2 +-
 fs/hfsplus/dir.c            |    2 ++
 fs/hfsplus/inode.c          |    9 +++++++++
 fs/hfsplus/xattr.c          |   20 ++++++++++++++------
 fs/hfsplus/xattr.h          |   32 +++++++++++++-------------------
 fs/hfsplus/xattr_security.c |   13 +++++++++++++
 6 files changed, 52 insertions(+), 26 deletions(-)

diff -puN fs/hfsplus/Makefile~hfsplus-integrate-of-implemented-acls-support-into-driver fs/hfsplus/Makefile
--- a/fs/hfsplus/Makefile~hfsplus-integrate-of-implemented-acls-support-into-driver
+++ a/fs/hfsplus/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_HFSPLUS_FS) += hfsplus.o
 
 hfsplus-objs := super.o options.o inode.o ioctl.o extents.o catalog.o dir.o btree.o \
 		bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o part_tbl.o \
-		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o
+		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o acl.o
diff -puN fs/hfsplus/dir.c~hfsplus-integrate-of-implemented-acls-support-into-driver fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-integrate-of-implemented-acls-support-into-driver
+++ a/fs/hfsplus/dir.c
@@ -16,6 +16,7 @@
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 #include "xattr.h"
+#include "acl.h"
 
 static inline void hfsplus_instantiate(struct dentry *dentry,
 				       struct inode *inode, u32 cnid)
@@ -533,6 +534,7 @@ const struct inode_operations hfsplus_di
 	.getxattr		= generic_getxattr,
 	.listxattr		= hfsplus_listxattr,
 	.removexattr		= hfsplus_removexattr,
+	.get_acl		= hfsplus_get_acl,
 };
 
 const struct file_operations hfsplus_dir_operations = {
diff -puN fs/hfsplus/inode.c~hfsplus-integrate-of-implemented-acls-support-into-driver fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-integrate-of-implemented-acls-support-into-driver
+++ a/fs/hfsplus/inode.c
@@ -18,6 +18,7 @@
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 #include "xattr.h"
+#include "acl.h"
 
 static int hfsplus_readpage(struct file *file, struct page *page)
 {
@@ -315,6 +316,13 @@ static int hfsplus_setattr(struct dentry
 
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
+
+	if (attr->ia_valid & ATTR_MODE) {
+		error = hfsplus_acl_chmod(inode);
+		if (unlikely(error))
+			return error;
+	}
+
 	return 0;
 }
 
@@ -382,6 +390,7 @@ static const struct inode_operations hfs
 	.getxattr	= generic_getxattr,
 	.listxattr	= hfsplus_listxattr,
 	.removexattr	= hfsplus_removexattr,
+	.get_acl	= hfsplus_get_acl,
 };
 
 static const struct file_operations hfsplus_file_operations = {
diff -puN fs/hfsplus/xattr.c~hfsplus-integrate-of-implemented-acls-support-into-driver fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-integrate-of-implemented-acls-support-into-driver
+++ a/fs/hfsplus/xattr.c
@@ -8,11 +8,14 @@
 
 #include "hfsplus_fs.h"
 #include "xattr.h"
+#include "acl.h"
 
 const struct xattr_handler *hfsplus_xattr_handlers[] = {
 	&hfsplus_xattr_osx_handler,
 	&hfsplus_xattr_user_handler,
 	&hfsplus_xattr_trusted_handler,
+	&hfsplus_xattr_acl_access_handler,
+	&hfsplus_xattr_acl_default_handler,
 	&hfsplus_xattr_security_handler,
 	NULL
 };
@@ -49,8 +52,15 @@ static inline int is_known_namespace(con
 static int can_set_xattr(struct inode *inode, const char *name,
 				const void *value, size_t value_len)
 {
+	/*
+	 * ACLs handler makes conversion from "system.posix_acl_access"
+	 * and "system.posix_acl_default" into "com.apple.system.Security".
+	 */
 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return -EOPNOTSUPP; /* TODO: implement ACL support */
+		return -EOPNOTSUPP;
+	else if (!strncmp(name, HFSPLUS_XATTR_ACL_NAME,
+				sizeof(HFSPLUS_XATTR_ACL_NAME)))
+		return 0;
 
 	if (!strncmp(name, XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN)) {
 		/*
@@ -253,11 +263,10 @@ static int copy_name(char *buffer, const
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
@@ -304,10 +313,9 @@ end_getxattr_finder_info:
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
@@ -333,7 +341,7 @@ ssize_t hfsplus_getxattr(struct dentry *
 	}
 
 	if (!strcmp_xattr_finder_info(name))
-		return hfsplus_getxattr_finder_info(dentry, value, size);
+		return hfsplus_getxattr_finder_info(inode, value, size);
 
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree)
 		return -EOPNOTSUPP;
diff -puN fs/hfsplus/xattr.h~hfsplus-integrate-of-implemented-acls-support-into-driver fs/hfsplus/xattr.h
--- a/fs/hfsplus/xattr.h~hfsplus-integrate-of-implemented-acls-support-into-driver
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
@@ -39,22 +47,8 @@ int hfsplus_removexattr(struct dentry *d
 int hfsplus_init_security(struct inode *inode, struct inode *dir,
 				const struct qstr *qstr);
 
-static inline int hfsplus_init_acl(struct inode *inode, struct inode *dir)
-{
-	/*TODO: implement*/
-	return 0;
-}
-
-static inline int hfsplus_init_inode_security(struct inode *inode,
+int hfsplus_init_inode_security(struct inode *inode,
 						struct inode *dir,
-						const struct qstr *qstr)
-{
-	int err;
-
-	err = hfsplus_init_acl(inode, dir);
-	if (!err)
-		err = hfsplus_init_security(inode, dir, qstr);
-	return err;
-}
+						const struct qstr *qstr);
 
 #endif
diff -puN fs/hfsplus/xattr_security.c~hfsplus-integrate-of-implemented-acls-support-into-driver fs/hfsplus/xattr_security.c
--- a/fs/hfsplus/xattr_security.c~hfsplus-integrate-of-implemented-acls-support-into-driver
+++ a/fs/hfsplus/xattr_security.c
@@ -8,6 +8,7 @@
 
 #include <linux/security.h>
 #include "hfsplus_fs.h"
+#include "acl.h"
 #include "xattr.h"
 
 static int hfsplus_security_getxattr(struct dentry *dentry, const char *name,
@@ -96,6 +97,18 @@ int hfsplus_init_security(struct inode *
 					&hfsplus_initxattrs, NULL);
 }
 
+int hfsplus_init_inode_security(struct inode *inode,
+						struct inode *dir,
+						const struct qstr *qstr)
+{
+	int err;
+
+	err = hfsplus_init_acl(inode, dir);
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

hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch
hfsplus-add-all-necessary-declarations-for-acls-support.patch
hfsplus-add-implementation-of-the-acls-support.patch
hfsplus-integrate-of-implemented-acls-support-into-driver.patch

