From: akpm@osdl.org
Subject: - lookup_one_len_nd-lookup_one_len-with-nameidata-argument.patch removed from -mm tree
Date: Mon, 08 Jan 2007 13:09:32 -0800
Message-ID: <200701082109.l08L9WS0018966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbXAHVJl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:09:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     lookup_one_len_nd - lookup_one_len with nameidata argument
has been removed from the -mm tree.  Its filename was
     lookup_one_len_nd-lookup_one_len-with-nameidata-argument.patch

This patch was dropped because I'll use the git tree

------------------------------------------------------
Subject: lookup_one_len_nd - lookup_one_len with nameidata argument
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Rename lookup_one_len to lookup_one_len_nd, and adds a nameidata argument.  An
inline function, lookup_one_len (which calls lookup_one_len_nd with nd ==
NULL) preserves original behavior.

The following Unionfs patches depend on this one.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namei.c            |    8 ++++----
 include/linux/namei.h |   10 +++++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~lookup_one_len_nd-lookup_one_len-with-nameidata-argument fs/namei.c
--- a/fs/namei.c~lookup_one_len_nd-lookup_one_len-with-nameidata-argument
+++ a/fs/namei.c
@@ -1296,8 +1296,8 @@ static struct dentry *lookup_hash(struct
 	return __lookup_hash(&nd->last, nd->dentry, nd);
 }
 
-/* SMP-safe */
-struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
+struct dentry *lookup_one_len_nd(const char *name, struct dentry *base,
+				  int len, struct nameidata *nd)
 {
 	unsigned long hash;
 	struct qstr this;
@@ -1317,7 +1317,7 @@ struct dentry * lookup_one_len(const cha
 	}
 	this.hash = end_name_hash(hash);
 
-	return __lookup_hash(&this, base, NULL);
+	return __lookup_hash(&this, base, nd);
 access:
 	return ERR_PTR(-EACCES);
 }
@@ -2761,7 +2761,7 @@ EXPORT_SYMBOL(follow_up);
 EXPORT_SYMBOL(get_write_access); /* binfmt_aout */
 EXPORT_SYMBOL(getname);
 EXPORT_SYMBOL(lock_rename);
-EXPORT_SYMBOL(lookup_one_len);
+EXPORT_SYMBOL(lookup_one_len_nd);
 EXPORT_SYMBOL(page_follow_link_light);
 EXPORT_SYMBOL(page_put_link);
 EXPORT_SYMBOL(page_readlink);
diff -puN include/linux/namei.h~lookup_one_len_nd-lookup_one_len-with-nameidata-argument include/linux/namei.h
--- a/include/linux/namei.h~lookup_one_len_nd-lookup_one_len-with-nameidata-argument
+++ a/include/linux/namei.h
@@ -81,7 +81,15 @@ extern struct file *lookup_instantiate_f
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
-extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len_nd(const char *,
+			struct dentry *, int, struct nameidata *);
+
+/* SMP-safe */
+static inline struct dentry *lookup_one_len(const char *name,
+			struct dentry *dir, int len)
+{
+	return lookup_one_len_nd(name, dir, len, NULL);
+}
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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
