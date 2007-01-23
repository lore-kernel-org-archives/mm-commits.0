From: akpm@osdl.org
Subject: + mark-struct-inode_operations-const-2.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:20 -0800
Message-ID: <200701231932.l0NJWKJI029012@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50788 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138AbXAWTc2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct inode_operations const 2
has been added to the -mm tree.  Its filename is
     mark-struct-inode_operations-const-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct inode_operations const 2
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct inode_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/gfs2/ops_inode.c     |    8 ++++----
 fs/gfs2/ops_inode.h     |    8 ++++----
 fs/hfs/dir.c            |    2 +-
 fs/hfs/hfs_fs.h         |    2 +-
 fs/hfs/inode.c          |    4 ++--
 fs/hfsplus/dir.c        |    2 +-
 fs/hfsplus/inode.c      |    4 ++--
 fs/hostfs/hostfs_kern.c |    8 ++++----
 fs/hpfs/file.c          |    2 +-
 fs/hpfs/hpfs_fn.h       |    4 ++--
 fs/hpfs/namei.c         |    2 +-
 fs/hppfs/hppfs_kern.c   |    6 +++---
 fs/hugetlbfs/inode.c    |    8 ++++----
 fs/isofs/dir.c          |    2 +-
 fs/isofs/isofs.h        |    2 +-
 fs/jffs/inode-v23.c     |    8 ++++----
 fs/jffs2/dir.c          |    2 +-
 fs/jffs2/file.c         |    2 +-
 fs/jffs2/os-linux.h     |    6 +++---
 fs/jffs2/symlink.c      |    2 +-
 fs/jfs/file.c           |    2 +-
 fs/jfs/jfs_inode.h      |    6 +++---
 fs/jfs/namei.c          |    2 +-
 fs/jfs/symlink.c        |    2 +-
 fs/libfs.c              |    2 +-
 fs/minix/file.c         |    2 +-
 fs/minix/inode.c        |    2 +-
 fs/minix/minix.h        |    4 ++--
 fs/minix/namei.c        |    2 +-
 fs/msdos/namei.c        |    2 +-
 fs/namei.c              |    2 +-
 fs/ncpfs/dir.c          |    2 +-
 fs/ncpfs/file.c         |    2 +-
 fs/ncpfs/inode.c        |    2 +-
 fs/nfs/dir.c            |    6 +++---
 fs/nfs/file.c           |    4 ++--
 fs/nfs/namespace.c      |    4 ++--
 fs/nfs/nfs4_fs.h        |    2 +-
 fs/nfs/nfs4proc.c       |    2 +-
 fs/nfs/symlink.c        |    2 +-
 fs/ntfs/file.c          |    4 ++--
 fs/ntfs/namei.c         |    2 +-
 fs/ntfs/ntfs.h          |    6 +++---
 fs/ocfs2/dlm/dlmfs.c    |   12 ++++++------
 fs/ocfs2/file.c         |    4 ++--
 fs/ocfs2/file.h         |    4 ++--
 fs/ocfs2/namei.c        |    2 +-
 fs/ocfs2/namei.h        |    2 +-
 fs/ocfs2/symlink.c      |    4 ++--
 fs/ocfs2/symlink.h      |    4 ++--
 fs/openpromfs/inode.c   |    2 +-
 ipc/mqueue.c            |    4 ++--
 kernel/cpuset.c         |    2 +-
 mm/shmem.c              |   20 ++++++++++----------
 54 files changed, 105 insertions(+), 105 deletions(-)

diff -puN fs/gfs2/ops_inode.c~mark-struct-inode_operations-const-2 fs/gfs2/ops_inode.c
--- a/fs/gfs2/ops_inode.c~mark-struct-inode_operations-const-2
+++ a/fs/gfs2/ops_inode.c
@@ -1083,7 +1083,7 @@ static int gfs2_removexattr(struct dentr
 	return gfs2_ea_remove(GFS2_I(dentry->d_inode), &er);
 }
 
-struct inode_operations gfs2_file_iops = {
+const struct inode_operations gfs2_file_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
@@ -1093,7 +1093,7 @@ struct inode_operations gfs2_file_iops =
 	.removexattr = gfs2_removexattr,
 };
 
-struct inode_operations gfs2_dev_iops = {
+const struct inode_operations gfs2_dev_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
@@ -1103,7 +1103,7 @@ struct inode_operations gfs2_dev_iops = 
 	.removexattr = gfs2_removexattr,
 };
 
-struct inode_operations gfs2_dir_iops = {
+const struct inode_operations gfs2_dir_iops = {
 	.create = gfs2_create,
 	.lookup = gfs2_lookup,
 	.link = gfs2_link,
@@ -1122,7 +1122,7 @@ struct inode_operations gfs2_dir_iops = 
 	.removexattr = gfs2_removexattr,
 };
 
-struct inode_operations gfs2_symlink_iops = {
+const struct inode_operations gfs2_symlink_iops = {
 	.readlink = gfs2_readlink,
 	.follow_link = gfs2_follow_link,
 	.permission = gfs2_permission,
diff -puN fs/gfs2/ops_inode.h~mark-struct-inode_operations-const-2 fs/gfs2/ops_inode.h
--- a/fs/gfs2/ops_inode.h~mark-struct-inode_operations-const-2
+++ a/fs/gfs2/ops_inode.h
@@ -12,9 +12,9 @@
 
 #include <linux/fs.h>
 
-extern struct inode_operations gfs2_file_iops;
-extern struct inode_operations gfs2_dir_iops;
-extern struct inode_operations gfs2_symlink_iops;
-extern struct inode_operations gfs2_dev_iops;
+extern const struct inode_operations gfs2_file_iops;
+extern const struct inode_operations gfs2_dir_iops;
+extern const struct inode_operations gfs2_symlink_iops;
+extern const struct inode_operations gfs2_dev_iops;
 
 #endif /* __OPS_INODE_DOT_H__ */
diff -puN fs/hfs/dir.c~mark-struct-inode_operations-const-2 fs/hfs/dir.c
--- a/fs/hfs/dir.c~mark-struct-inode_operations-const-2
+++ a/fs/hfs/dir.c
@@ -320,7 +320,7 @@ const struct file_operations hfs_dir_ope
 	.release	= hfs_dir_release,
 };
 
-struct inode_operations hfs_dir_inode_operations = {
+const struct inode_operations hfs_dir_inode_operations = {
 	.create		= hfs_create,
 	.lookup		= hfs_lookup,
 	.unlink		= hfs_unlink,
diff -puN fs/hfs/hfs_fs.h~mark-struct-inode_operations-const-2 fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~mark-struct-inode_operations-const-2
+++ a/fs/hfs/hfs_fs.h
@@ -170,7 +170,7 @@ extern void hfs_cat_build_key(struct sup
 
 /* dir.c */
 extern const struct file_operations hfs_dir_operations;
-extern struct inode_operations hfs_dir_inode_operations;
+extern const struct inode_operations hfs_dir_inode_operations;
 
 /* extent.c */
 extern int hfs_ext_keycmp(const btree_key *, const btree_key *);
diff -puN fs/hfs/inode.c~mark-struct-inode_operations-const-2 fs/hfs/inode.c
--- a/fs/hfs/inode.c~mark-struct-inode_operations-const-2
+++ a/fs/hfs/inode.c
@@ -18,7 +18,7 @@
 #include "btree.h"
 
 static const struct file_operations hfs_file_operations;
-static struct inode_operations hfs_file_inode_operations;
+static const struct inode_operations hfs_file_inode_operations;
 
 /*================ Variable-like macros ================*/
 
@@ -610,7 +610,7 @@ static const struct file_operations hfs_
 	.release	= hfs_file_release,
 };
 
-static struct inode_operations hfs_file_inode_operations = {
+static const struct inode_operations hfs_file_inode_operations = {
 	.lookup		= hfs_file_lookup,
 	.truncate	= hfs_file_truncate,
 	.setattr	= hfs_inode_setattr,
diff -puN fs/hfsplus/dir.c~mark-struct-inode_operations-const-2 fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~mark-struct-inode_operations-const-2
+++ a/fs/hfsplus/dir.c
@@ -470,7 +470,7 @@ static int hfsplus_rename(struct inode *
 	return res;
 }
 
-struct inode_operations hfsplus_dir_inode_operations = {
+const struct inode_operations hfsplus_dir_inode_operations = {
 	.lookup		= hfsplus_lookup,
 	.create		= hfsplus_create,
 	.link		= hfsplus_link,
diff -puN fs/hfsplus/inode.c~mark-struct-inode_operations-const-2 fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~mark-struct-inode_operations-const-2
+++ a/fs/hfsplus/inode.c
@@ -266,10 +266,10 @@ static int hfsplus_file_release(struct i
 	return 0;
 }
 
-extern struct inode_operations hfsplus_dir_inode_operations;
+extern const struct inode_operations hfsplus_dir_inode_operations;
 extern struct file_operations hfsplus_dir_operations;
 
-static struct inode_operations hfsplus_file_inode_operations = {
+static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,
 	.permission	= hfsplus_permission,
diff -puN fs/hostfs/hostfs_kern.c~mark-struct-inode_operations-const-2 fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~mark-struct-inode_operations-const-2
+++ a/fs/hostfs/hostfs_kern.c
@@ -52,8 +52,8 @@ static int append = 0;
 
 #define HOSTFS_SUPER_MAGIC 0x00c0ffee
 
-static struct inode_operations hostfs_iops;
-static struct inode_operations hostfs_dir_iops;
+static const struct inode_operations hostfs_iops;
+static const struct inode_operations hostfs_dir_iops;
 static const struct address_space_operations hostfs_link_aops;
 
 #ifndef MODULE
@@ -880,7 +880,7 @@ int hostfs_getattr(struct vfsmount *mnt,
 	return(0);
 }
 
-static struct inode_operations hostfs_iops = {
+static const struct inode_operations hostfs_iops = {
 	.create		= hostfs_create,
 	.link		= hostfs_link,
 	.unlink		= hostfs_unlink,
@@ -894,7 +894,7 @@ static struct inode_operations hostfs_io
 	.getattr	= hostfs_getattr,
 };
 
-static struct inode_operations hostfs_dir_iops = {
+static const struct inode_operations hostfs_dir_iops = {
 	.create		= hostfs_create,
 	.lookup		= hostfs_lookup,
 	.link		= hostfs_link,
diff -puN fs/hpfs/file.c~mark-struct-inode_operations-const-2 fs/hpfs/file.c
--- a/fs/hpfs/file.c~mark-struct-inode_operations-const-2
+++ a/fs/hpfs/file.c
@@ -131,7 +131,7 @@ const struct file_operations hpfs_file_o
 	.sendfile	= generic_file_sendfile,
 };
 
-struct inode_operations hpfs_file_iops =
+const struct inode_operations hpfs_file_iops =
 {
 	.truncate	= hpfs_truncate,
 	.setattr	= hpfs_notify_change,
diff -puN fs/hpfs/hpfs_fn.h~mark-struct-inode_operations-const-2 fs/hpfs/hpfs_fn.h
--- a/fs/hpfs/hpfs_fn.h~mark-struct-inode_operations-const-2
+++ a/fs/hpfs/hpfs_fn.h
@@ -266,7 +266,7 @@ void hpfs_set_ea(struct inode *, struct 
 
 int hpfs_file_fsync(struct file *, struct dentry *, int);
 extern const struct file_operations hpfs_file_ops;
-extern struct inode_operations hpfs_file_iops;
+extern const struct inode_operations hpfs_file_iops;
 extern const struct address_space_operations hpfs_aops;
 
 /* inode.c */
@@ -302,7 +302,7 @@ void hpfs_decide_conv(struct inode *, un
 
 /* namei.c */
 
-extern struct inode_operations hpfs_dir_iops;
+extern const struct inode_operations hpfs_dir_iops;
 extern const struct address_space_operations hpfs_symlink_aops;
 
 static inline struct hpfs_inode_info *hpfs_i(struct inode *inode)
diff -puN fs/hpfs/namei.c~mark-struct-inode_operations-const-2 fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/hpfs/namei.c
@@ -659,7 +659,7 @@ end1:
 	return err;
 }
 
-struct inode_operations hpfs_dir_iops =
+const struct inode_operations hpfs_dir_iops =
 {
 	.create		= hpfs_create,
 	.lookup		= hpfs_lookup,
diff -puN fs/hppfs/hppfs_kern.c~mark-struct-inode_operations-const-2 fs/hppfs/hppfs_kern.c
--- a/fs/hppfs/hppfs_kern.c~mark-struct-inode_operations-const-2
+++ a/fs/hppfs/hppfs_kern.c
@@ -212,7 +212,7 @@ static struct dentry *hppfs_lookup(struc
 	return(ERR_PTR(err));
 }
 
-static struct inode_operations hppfs_file_iops = {
+static const struct inode_operations hppfs_file_iops = {
 };
 
 static ssize_t read_proc(struct file *file, char __user *buf, ssize_t count,
@@ -693,11 +693,11 @@ static void* hppfs_follow_link(struct de
 	return ret;
 }
 
-static struct inode_operations hppfs_dir_iops = {
+static const struct inode_operations hppfs_dir_iops = {
 	.lookup		= hppfs_lookup,
 };
 
-static struct inode_operations hppfs_link_iops = {
+static const struct inode_operations hppfs_link_iops = {
 	.readlink	= hppfs_readlink,
 	.follow_link	= hppfs_follow_link,
 };
diff -puN fs/hugetlbfs/inode.c~mark-struct-inode_operations-const-2 fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mark-struct-inode_operations-const-2
+++ a/fs/hugetlbfs/inode.c
@@ -36,8 +36,8 @@
 static struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
-static struct inode_operations hugetlbfs_dir_inode_operations;
-static struct inode_operations hugetlbfs_inode_operations;
+static const struct inode_operations hugetlbfs_dir_inode_operations;
+static const struct inode_operations hugetlbfs_inode_operations;
 
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
@@ -560,7 +560,7 @@ const struct file_operations hugetlbfs_f
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
 };
 
-static struct inode_operations hugetlbfs_dir_inode_operations = {
+static const struct inode_operations hugetlbfs_dir_inode_operations = {
 	.create		= hugetlbfs_create,
 	.lookup		= simple_lookup,
 	.link		= simple_link,
@@ -573,7 +573,7 @@ static struct inode_operations hugetlbfs
 	.setattr	= hugetlbfs_setattr,
 };
 
-static struct inode_operations hugetlbfs_inode_operations = {
+static const struct inode_operations hugetlbfs_inode_operations = {
 	.setattr	= hugetlbfs_setattr,
 };
 
diff -puN fs/isofs/dir.c~mark-struct-inode_operations-const-2 fs/isofs/dir.c
--- a/fs/isofs/dir.c~mark-struct-inode_operations-const-2
+++ a/fs/isofs/dir.c
@@ -24,7 +24,7 @@ const struct file_operations isofs_dir_o
 /*
  * directories can handle most operations...
  */
-struct inode_operations isofs_dir_inode_operations =
+const struct inode_operations isofs_dir_inode_operations =
 {
 	.lookup		= isofs_lookup,
 };
diff -puN fs/isofs/isofs.h~mark-struct-inode_operations-const-2 fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~mark-struct-inode_operations-const-2
+++ a/fs/isofs/isofs.h
@@ -174,7 +174,7 @@ isofs_normalize_block_and_offset(struct 
 	}
 }
 
-extern struct inode_operations isofs_dir_inode_operations;
+extern const struct inode_operations isofs_dir_inode_operations;
 extern const struct file_operations isofs_dir_operations;
 extern const struct address_space_operations isofs_symlink_aops;
 extern struct export_operations isofs_export_ops;
diff -puN fs/jffs/inode-v23.c~mark-struct-inode_operations-const-2 fs/jffs/inode-v23.c
--- a/fs/jffs/inode-v23.c~mark-struct-inode_operations-const-2
+++ a/fs/jffs/inode-v23.c
@@ -56,9 +56,9 @@ static int jffs_remove(struct inode *dir
 
 static struct super_operations jffs_ops;
 static const struct file_operations jffs_file_operations;
-static struct inode_operations jffs_file_inode_operations;
+static const struct inode_operations jffs_file_inode_operations;
 static const struct file_operations jffs_dir_operations;
-static struct inode_operations jffs_dir_inode_operations;
+static const struct inode_operations jffs_dir_inode_operations;
 static const struct address_space_operations jffs_address_operations;
 
 struct kmem_cache     *node_cache = NULL;
@@ -1642,7 +1642,7 @@ static const struct file_operations jffs
 };
 
 
-static struct inode_operations jffs_file_inode_operations =
+static const struct inode_operations jffs_file_inode_operations =
 {
 	.lookup		= jffs_lookup,          /* lookup */
 	.setattr	= jffs_setattr,
@@ -1655,7 +1655,7 @@ static const struct file_operations jffs
 };
 
 
-static struct inode_operations jffs_dir_inode_operations =
+static const struct inode_operations jffs_dir_inode_operations =
 {
 	.create		= jffs_create,
 	.lookup		= jffs_lookup,
diff -puN fs/jffs2/dir.c~mark-struct-inode_operations-const-2 fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~mark-struct-inode_operations-const-2
+++ a/fs/jffs2/dir.c
@@ -45,7 +45,7 @@ const struct file_operations jffs2_dir_o
 };
 
 
-struct inode_operations jffs2_dir_inode_operations =
+const struct inode_operations jffs2_dir_inode_operations =
 {
 	.create =	jffs2_create,
 	.lookup =	jffs2_lookup,
diff -puN fs/jffs2/file.c~mark-struct-inode_operations-const-2 fs/jffs2/file.c
--- a/fs/jffs2/file.c~mark-struct-inode_operations-const-2
+++ a/fs/jffs2/file.c
@@ -54,7 +54,7 @@ const struct file_operations jffs2_file_
 
 /* jffs2_file_inode_operations */
 
-struct inode_operations jffs2_file_inode_operations =
+const struct inode_operations jffs2_file_inode_operations =
 {
 	.permission =	jffs2_permission,
 	.setattr =	jffs2_setattr,
diff -puN fs/jffs2/os-linux.h~mark-struct-inode_operations-const-2 fs/jffs2/os-linux.h
--- a/fs/jffs2/os-linux.h~mark-struct-inode_operations-const-2
+++ a/fs/jffs2/os-linux.h
@@ -159,11 +159,11 @@ void jffs2_garbage_collect_trigger(struc
 
 /* dir.c */
 extern const struct file_operations jffs2_dir_operations;
-extern struct inode_operations jffs2_dir_inode_operations;
+extern const struct inode_operations jffs2_dir_inode_operations;
 
 /* file.c */
 extern const struct file_operations jffs2_file_operations;
-extern struct inode_operations jffs2_file_inode_operations;
+extern const struct inode_operations jffs2_file_inode_operations;
 extern const struct address_space_operations jffs2_file_address_operations;
 int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
@@ -172,7 +172,7 @@ int jffs2_do_readpage_unlock (struct ino
 int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
 
 /* symlink.c */
-extern struct inode_operations jffs2_symlink_inode_operations;
+extern const struct inode_operations jffs2_symlink_inode_operations;
 
 /* fs.c */
 int jffs2_setattr (struct dentry *, struct iattr *);
diff -puN fs/jffs2/symlink.c~mark-struct-inode_operations-const-2 fs/jffs2/symlink.c
--- a/fs/jffs2/symlink.c~mark-struct-inode_operations-const-2
+++ a/fs/jffs2/symlink.c
@@ -20,7 +20,7 @@
 
 static void *jffs2_follow_link(struct dentry *dentry, struct nameidata *nd);
 
-struct inode_operations jffs2_symlink_inode_operations =
+const struct inode_operations jffs2_symlink_inode_operations =
 {
 	.readlink =	generic_readlink,
 	.follow_link =	jffs2_follow_link,
diff -puN fs/jfs/file.c~mark-struct-inode_operations-const-2 fs/jfs/file.c
--- a/fs/jfs/file.c~mark-struct-inode_operations-const-2
+++ a/fs/jfs/file.c
@@ -88,7 +88,7 @@ static int jfs_release(struct inode *ino
 	return 0;
 }
 
-struct inode_operations jfs_file_inode_operations = {
+const struct inode_operations jfs_file_inode_operations = {
 	.truncate	= jfs_truncate,
 	.setxattr	= jfs_setxattr,
 	.getxattr	= jfs_getxattr,
diff -puN fs/jfs/jfs_inode.h~mark-struct-inode_operations-const-2 fs/jfs/jfs_inode.h
--- a/fs/jfs/jfs_inode.h~mark-struct-inode_operations-const-2
+++ a/fs/jfs/jfs_inode.h
@@ -35,10 +35,10 @@ extern void jfs_set_inode_flags(struct i
 extern int jfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
 extern const struct address_space_operations jfs_aops;
-extern struct inode_operations jfs_dir_inode_operations;
+extern const struct inode_operations jfs_dir_inode_operations;
 extern const struct file_operations jfs_dir_operations;
-extern struct inode_operations jfs_file_inode_operations;
+extern const struct inode_operations jfs_file_inode_operations;
 extern const struct file_operations jfs_file_operations;
-extern struct inode_operations jfs_symlink_inode_operations;
+extern const struct inode_operations jfs_symlink_inode_operations;
 extern struct dentry_operations jfs_ci_dentry_operations;
 #endif				/* _H_JFS_INODE */
diff -puN fs/jfs/namei.c~mark-struct-inode_operations-const-2 fs/jfs/namei.c
--- a/fs/jfs/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/jfs/namei.c
@@ -1503,7 +1503,7 @@ struct dentry *jfs_get_parent(struct den
 	return parent;
 }
 
-struct inode_operations jfs_dir_inode_operations = {
+const struct inode_operations jfs_dir_inode_operations = {
 	.create		= jfs_create,
 	.lookup		= jfs_lookup,
 	.link		= jfs_link,
diff -puN fs/jfs/symlink.c~mark-struct-inode_operations-const-2 fs/jfs/symlink.c
--- a/fs/jfs/symlink.c~mark-struct-inode_operations-const-2
+++ a/fs/jfs/symlink.c
@@ -29,7 +29,7 @@ static void *jfs_follow_link(struct dent
 	return NULL;
 }
 
-struct inode_operations jfs_symlink_inode_operations = {
+const struct inode_operations jfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= jfs_follow_link,
 	.setxattr	= jfs_setxattr,
diff -puN fs/libfs.c~mark-struct-inode_operations-const-2 fs/libfs.c
--- a/fs/libfs.c~mark-struct-inode_operations-const-2
+++ a/fs/libfs.c
@@ -186,7 +186,7 @@ const struct file_operations simple_dir_
 	.fsync		= simple_sync_file,
 };
 
-struct inode_operations simple_dir_inode_operations = {
+const struct inode_operations simple_dir_inode_operations = {
 	.lookup		= simple_lookup,
 };
 
diff -puN fs/minix/file.c~mark-struct-inode_operations-const-2 fs/minix/file.c
--- a/fs/minix/file.c~mark-struct-inode_operations-const-2
+++ a/fs/minix/file.c
@@ -26,7 +26,7 @@ const struct file_operations minix_file_
 	.sendfile	= generic_file_sendfile,
 };
 
-struct inode_operations minix_file_inode_operations = {
+const struct inode_operations minix_file_inode_operations = {
 	.truncate	= minix_truncate,
 	.getattr	= minix_getattr,
 };
diff -puN fs/minix/inode.c~mark-struct-inode_operations-const-2 fs/minix/inode.c
--- a/fs/minix/inode.c~mark-struct-inode_operations-const-2
+++ a/fs/minix/inode.c
@@ -368,7 +368,7 @@ static const struct address_space_operat
 	.bmap = minix_bmap
 };
 
-static struct inode_operations minix_symlink_inode_operations = {
+static const struct inode_operations minix_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
diff -puN fs/minix/minix.h~mark-struct-inode_operations-const-2 fs/minix/minix.h
--- a/fs/minix/minix.h~mark-struct-inode_operations-const-2
+++ a/fs/minix/minix.h
@@ -75,8 +75,8 @@ extern struct minix_dir_entry *minix_dot
 extern ino_t minix_inode_by_name(struct dentry*);
 extern int minix_sync_file(struct file *, struct dentry *, int);
 
-extern struct inode_operations minix_file_inode_operations;
-extern struct inode_operations minix_dir_inode_operations;
+extern const struct inode_operations minix_file_inode_operations;
+extern const struct inode_operations minix_dir_inode_operations;
 extern const struct file_operations minix_file_operations;
 extern const struct file_operations minix_dir_operations;
 extern struct dentry_operations minix_dentry_operations;
diff -puN fs/minix/namei.c~mark-struct-inode_operations-const-2 fs/minix/namei.c
--- a/fs/minix/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/minix/namei.c
@@ -291,7 +291,7 @@ out:
 /*
  * directories can handle most operations...
  */
-struct inode_operations minix_dir_inode_operations = {
+const struct inode_operations minix_dir_inode_operations = {
 	.create		= minix_create,
 	.lookup		= minix_lookup,
 	.link		= minix_link,
diff -puN fs/msdos/namei.c~mark-struct-inode_operations-const-2 fs/msdos/namei.c
--- a/fs/msdos/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/msdos/namei.c
@@ -646,7 +646,7 @@ out:
 	return err;
 }
 
-static struct inode_operations msdos_dir_inode_operations = {
+static const struct inode_operations msdos_dir_inode_operations = {
 	.create		= msdos_create,
 	.lookup		= msdos_lookup,
 	.unlink		= msdos_unlink,
diff -puN fs/namei.c~mark-struct-inode_operations-const-2 fs/namei.c
--- a/fs/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/namei.c
@@ -2748,7 +2748,7 @@ int page_symlink(struct inode *inode, co
 			mapping_gfp_mask(inode->i_mapping));
 }
 
-struct inode_operations page_symlink_inode_operations = {
+const struct inode_operations page_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
diff -puN fs/ncpfs/dir.c~mark-struct-inode_operations-const-2 fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~mark-struct-inode_operations-const-2
+++ a/fs/ncpfs/dir.c
@@ -58,7 +58,7 @@ const struct file_operations ncp_dir_ope
 #endif
 };
 
-struct inode_operations ncp_dir_inode_operations =
+const struct inode_operations ncp_dir_inode_operations =
 {
 	.create		= ncp_create,
 	.lookup		= ncp_lookup,
diff -puN fs/ncpfs/file.c~mark-struct-inode_operations-const-2 fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~mark-struct-inode_operations-const-2
+++ a/fs/ncpfs/file.c
@@ -297,7 +297,7 @@ const struct file_operations ncp_file_op
 	.fsync		= ncp_fsync,
 };
 
-struct inode_operations ncp_file_inode_operations =
+const struct inode_operations ncp_file_inode_operations =
 {
 	.setattr	= ncp_notify_change,
 };
diff -puN fs/ncpfs/inode.c~mark-struct-inode_operations-const-2 fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~mark-struct-inode_operations-const-2
+++ a/fs/ncpfs/inode.c
@@ -229,7 +229,7 @@ static void ncp_set_attr(struct inode *i
 }
 
 #if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
-static struct inode_operations ncp_symlink_inode_operations = {
+static const struct inode_operations ncp_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
diff -puN fs/nfs/dir.c~mark-struct-inode_operations-const-2 fs/nfs/dir.c
--- a/fs/nfs/dir.c~mark-struct-inode_operations-const-2
+++ a/fs/nfs/dir.c
@@ -64,7 +64,7 @@ const struct file_operations nfs_dir_ope
 	.fsync		= nfs_fsync_dir,
 };
 
-struct inode_operations nfs_dir_inode_operations = {
+const struct inode_operations nfs_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_lookup,
 	.link		= nfs_link,
@@ -80,7 +80,7 @@ struct inode_operations nfs_dir_inode_op
 };
 
 #ifdef CONFIG_NFS_V3
-struct inode_operations nfs3_dir_inode_operations = {
+const struct inode_operations nfs3_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_lookup,
 	.link		= nfs_link,
@@ -103,7 +103,7 @@ struct inode_operations nfs3_dir_inode_o
 #ifdef CONFIG_NFS_V4
 
 static struct dentry *nfs_atomic_lookup(struct inode *, struct dentry *, struct nameidata *);
-struct inode_operations nfs4_dir_inode_operations = {
+const struct inode_operations nfs4_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_atomic_lookup,
 	.link		= nfs_link,
diff -puN fs/nfs/file.c~mark-struct-inode_operations-const-2 fs/nfs/file.c
--- a/fs/nfs/file.c~mark-struct-inode_operations-const-2
+++ a/fs/nfs/file.c
@@ -68,14 +68,14 @@ const struct file_operations nfs_file_op
 	.check_flags	= nfs_check_flags,
 };
 
-struct inode_operations nfs_file_inode_operations = {
+const struct inode_operations nfs_file_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
 };
 
 #ifdef CONFIG_NFS_V3
-struct inode_operations nfs3_file_inode_operations = {
+const struct inode_operations nfs3_file_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
diff -puN fs/nfs/namespace.c~mark-struct-inode_operations-const-2 fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~mark-struct-inode_operations-const-2
+++ a/fs/nfs/namespace.c
@@ -155,12 +155,12 @@ out_follow:
 	goto out;
 }
 
-struct inode_operations nfs_mountpoint_inode_operations = {
+const struct inode_operations nfs_mountpoint_inode_operations = {
 	.follow_link	= nfs_follow_mountpoint,
 	.getattr	= nfs_getattr,
 };
 
-struct inode_operations nfs_referral_inode_operations = {
+const struct inode_operations nfs_referral_inode_operations = {
 	.follow_link	= nfs_follow_mountpoint,
 };
 
diff -puN fs/nfs/nfs4_fs.h~mark-struct-inode_operations-const-2 fs/nfs/nfs4_fs.h
--- a/fs/nfs/nfs4_fs.h~mark-struct-inode_operations-const-2
+++ a/fs/nfs/nfs4_fs.h
@@ -151,7 +151,7 @@ struct nfs4_state_recovery_ops {
 };
 
 extern struct dentry_operations nfs4_dentry_operations;
-extern struct inode_operations nfs4_dir_inode_operations;
+extern const struct inode_operations nfs4_dir_inode_operations;
 
 /* inode.c */
 extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t);
diff -puN fs/nfs/nfs4proc.c~mark-struct-inode_operations-const-2 fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~mark-struct-inode_operations-const-2
+++ a/fs/nfs/nfs4proc.c
@@ -3625,7 +3625,7 @@ struct nfs4_state_recovery_ops nfs4_netw
 	.recover_lock	= nfs4_lock_expired,
 };
 
-static struct inode_operations nfs4_file_inode_operations = {
+static const struct inode_operations nfs4_file_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
diff -puN fs/nfs/symlink.c~mark-struct-inode_operations-const-2 fs/nfs/symlink.c
--- a/fs/nfs/symlink.c~mark-struct-inode_operations-const-2
+++ a/fs/nfs/symlink.c
@@ -76,7 +76,7 @@ read_failed:
 /*
  * symlinks can't do much...
  */
-struct inode_operations nfs_symlink_inode_operations = {
+const struct inode_operations nfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= nfs_follow_link,
 	.put_link	= page_put_link,
diff -puN fs/ntfs/file.c~mark-struct-inode_operations-const-2 fs/ntfs/file.c
--- a/fs/ntfs/file.c~mark-struct-inode_operations-const-2
+++ a/fs/ntfs/file.c
@@ -2328,7 +2328,7 @@ const struct file_operations ntfs_file_o
 						    the data source. */
 };
 
-struct inode_operations ntfs_file_inode_ops = {
+const struct inode_operations ntfs_file_inode_ops = {
 #ifdef NTFS_RW
 	.truncate	= ntfs_truncate_vfs,
 	.setattr	= ntfs_setattr,
@@ -2337,4 +2337,4 @@ struct inode_operations ntfs_file_inode_
 
 const struct file_operations ntfs_empty_file_ops = {};
 
-struct inode_operations ntfs_empty_inode_ops = {};
+const struct inode_operations ntfs_empty_inode_ops = {};
diff -puN fs/ntfs/namei.c~mark-struct-inode_operations-const-2 fs/ntfs/namei.c
--- a/fs/ntfs/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/ntfs/namei.c
@@ -359,7 +359,7 @@ err_out:
 /**
  * Inode operations for directories.
  */
-struct inode_operations ntfs_dir_inode_ops = {
+const struct inode_operations ntfs_dir_inode_ops = {
 	.lookup	= ntfs_lookup,	/* VFS: Lookup directory. */
 };
 
diff -puN fs/ntfs/ntfs.h~mark-struct-inode_operations-const-2 fs/ntfs/ntfs.h
--- a/fs/ntfs/ntfs.h~mark-struct-inode_operations-const-2
+++ a/fs/ntfs/ntfs.h
@@ -61,13 +61,13 @@ extern const struct address_space_operat
 extern const struct address_space_operations ntfs_mst_aops;
 
 extern const struct  file_operations ntfs_file_ops;
-extern struct inode_operations ntfs_file_inode_ops;
+extern const struct inode_operations ntfs_file_inode_ops;
 
 extern const struct  file_operations ntfs_dir_ops;
-extern struct inode_operations ntfs_dir_inode_ops;
+extern const struct inode_operations ntfs_dir_inode_ops;
 
 extern const struct  file_operations ntfs_empty_file_ops;
-extern struct inode_operations ntfs_empty_inode_ops;
+extern const struct inode_operations ntfs_empty_inode_ops;
 
 extern struct export_operations ntfs_export_ops;
 
diff -puN fs/ocfs2/dlm/dlmfs.c~mark-struct-inode_operations-const-2 fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -63,9 +63,9 @@
 
 static struct super_operations dlmfs_ops;
 static const struct file_operations dlmfs_file_operations;
-static struct inode_operations dlmfs_dir_inode_operations;
-static struct inode_operations dlmfs_root_inode_operations;
-static struct inode_operations dlmfs_file_inode_operations;
+static const struct inode_operations dlmfs_dir_inode_operations;
+static const struct inode_operations dlmfs_root_inode_operations;
+static const struct inode_operations dlmfs_file_inode_operations;
 static struct kmem_cache *dlmfs_inode_cache;
 
 struct workqueue_struct *user_dlm_worker;
@@ -547,14 +547,14 @@ static const struct file_operations dlmf
 	.write		= dlmfs_file_write,
 };
 
-static struct inode_operations dlmfs_dir_inode_operations = {
+static const struct inode_operations dlmfs_dir_inode_operations = {
 	.create		= dlmfs_create,
 	.lookup		= simple_lookup,
 	.unlink		= dlmfs_unlink,
 };
 
 /* this way we can restrict mkdir to only the toplevel of the fs. */
-static struct inode_operations dlmfs_root_inode_operations = {
+static const struct inode_operations dlmfs_root_inode_operations = {
 	.lookup		= simple_lookup,
 	.mkdir		= dlmfs_mkdir,
 	.rmdir		= simple_rmdir,
@@ -568,7 +568,7 @@ static struct super_operations dlmfs_ops
 	.drop_inode	= generic_delete_inode,
 };
 
-static struct inode_operations dlmfs_file_inode_operations = {
+static const struct inode_operations dlmfs_file_inode_operations = {
 	.getattr	= simple_getattr,
 };
 
diff -puN fs/ocfs2/file.c~mark-struct-inode_operations-const-2 fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/file.c
@@ -1365,13 +1365,13 @@ bail:
 	return ret;
 }
 
-struct inode_operations ocfs2_file_iops = {
+const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
 };
 
-struct inode_operations ocfs2_special_file_iops = {
+const struct inode_operations ocfs2_special_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
diff -puN fs/ocfs2/file.h~mark-struct-inode_operations-const-2 fs/ocfs2/file.h
--- a/fs/ocfs2/file.h~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/file.h
@@ -28,8 +28,8 @@
 
 extern const struct file_operations ocfs2_fops;
 extern const struct file_operations ocfs2_dops;
-extern struct inode_operations ocfs2_file_iops;
-extern struct inode_operations ocfs2_special_file_iops;
+extern const struct inode_operations ocfs2_file_iops;
+extern const struct inode_operations ocfs2_special_file_iops;
 struct ocfs2_alloc_context;
 
 enum ocfs2_alloc_restarted {
diff -puN fs/ocfs2/namei.c~mark-struct-inode_operations-const-2 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/namei.c
@@ -2306,7 +2306,7 @@ leave:
 	return status;
 }
 
-struct inode_operations ocfs2_dir_iops = {
+const struct inode_operations ocfs2_dir_iops = {
 	.create		= ocfs2_create,
 	.lookup		= ocfs2_lookup,
 	.link		= ocfs2_link,
diff -puN fs/ocfs2/namei.h~mark-struct-inode_operations-const-2 fs/ocfs2/namei.h
--- a/fs/ocfs2/namei.h~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/namei.h
@@ -26,7 +26,7 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H
 
-extern struct inode_operations ocfs2_dir_iops;
+extern const struct inode_operations ocfs2_dir_iops;
 
 struct dentry *ocfs2_get_parent(struct dentry *child);
 
diff -puN fs/ocfs2/symlink.c~mark-struct-inode_operations-const-2 fs/ocfs2/symlink.c
--- a/fs/ocfs2/symlink.c~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/symlink.c
@@ -170,12 +170,12 @@ bail:
 	return ERR_PTR(status);
 }
 
-struct inode_operations ocfs2_symlink_inode_operations = {
+const struct inode_operations ocfs2_symlink_inode_operations = {
 	.readlink	= page_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
 };
-struct inode_operations ocfs2_fast_symlink_inode_operations = {
+const struct inode_operations ocfs2_fast_symlink_inode_operations = {
 	.readlink	= ocfs2_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
diff -puN fs/ocfs2/symlink.h~mark-struct-inode_operations-const-2 fs/ocfs2/symlink.h
--- a/fs/ocfs2/symlink.h~mark-struct-inode_operations-const-2
+++ a/fs/ocfs2/symlink.h
@@ -26,8 +26,8 @@
 #ifndef OCFS2_SYMLINK_H
 #define OCFS2_SYMLINK_H
 
-extern struct inode_operations ocfs2_symlink_inode_operations;
-extern struct inode_operations ocfs2_fast_symlink_inode_operations;
+extern const struct inode_operations ocfs2_symlink_inode_operations;
+extern const struct inode_operations ocfs2_fast_symlink_inode_operations;
 
 /*
  * Test whether an inode is a fast symlink.
diff -puN fs/openpromfs/inode.c~mark-struct-inode_operations-const-2 fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~mark-struct-inode_operations-const-2
+++ a/fs/openpromfs/inode.c
@@ -169,7 +169,7 @@ static const struct file_operations open
 
 static struct dentry *openpromfs_lookup(struct inode *, struct dentry *, struct nameidata *);
 
-static struct inode_operations openprom_inode_operations = {
+static const struct inode_operations openprom_inode_operations = {
 	.lookup		= openpromfs_lookup,
 };
 
diff -puN ipc/mqueue.c~mark-struct-inode_operations-const-2 ipc/mqueue.c
--- a/ipc/mqueue.c~mark-struct-inode_operations-const-2
+++ a/ipc/mqueue.c
@@ -84,7 +84,7 @@ struct mqueue_inode_info {
 	unsigned long qsize; /* size of queue in memory (sum of all msgs) */
 };
 
-static struct inode_operations mqueue_dir_inode_operations;
+static const struct inode_operations mqueue_dir_inode_operations;
 static const struct file_operations mqueue_file_operations;
 static struct super_operations mqueue_super_ops;
 static void remove_notification(struct mqueue_inode_info *info);
@@ -1160,7 +1160,7 @@ out:
 	return ret;
 }
 
-static struct inode_operations mqueue_dir_inode_operations = {
+static const struct inode_operations mqueue_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.create = mqueue_create,
 	.unlink = mqueue_unlink,
diff -puN kernel/cpuset.c~mark-struct-inode_operations-const-2 kernel/cpuset.c
--- a/kernel/cpuset.c~mark-struct-inode_operations-const-2
+++ a/kernel/cpuset.c
@@ -1478,7 +1478,7 @@ static const struct file_operations cpus
 	.release = cpuset_file_release,
 };
 
-static struct inode_operations cpuset_dir_inode_operations = {
+static const struct inode_operations cpuset_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.mkdir = cpuset_mkdir,
 	.rmdir = cpuset_rmdir,
diff -puN mm/shmem.c~mark-struct-inode_operations-const-2 mm/shmem.c
--- a/mm/shmem.c~mark-struct-inode_operations-const-2
+++ a/mm/shmem.c
@@ -178,9 +178,9 @@ static inline void shmem_unacct_blocks(u
 static struct super_operations shmem_ops;
 static const struct address_space_operations shmem_aops;
 static const struct file_operations shmem_file_operations;
-static struct inode_operations shmem_inode_operations;
-static struct inode_operations shmem_dir_inode_operations;
-static struct inode_operations shmem_special_inode_operations;
+static const struct inode_operations shmem_inode_operations;
+static const struct inode_operations shmem_dir_inode_operations;
+static const struct inode_operations shmem_special_inode_operations;
 static struct vm_operations_struct shmem_vm_ops;
 
 static struct backing_dev_info shmem_backing_dev_info  __read_mostly = {
@@ -1409,8 +1409,8 @@ shmem_get_inode(struct super_block *sb, 
 }
 
 #ifdef CONFIG_TMPFS
-static struct inode_operations shmem_symlink_inode_operations;
-static struct inode_operations shmem_symlink_inline_operations;
+static const struct inode_operations shmem_symlink_inode_operations;
+static const struct inode_operations shmem_symlink_inline_operations;
 
 /*
  * Normally tmpfs makes no use of shmem_prepare_write, but it
@@ -1903,12 +1903,12 @@ static void shmem_put_link(struct dentry
 	}
 }
 
-static struct inode_operations shmem_symlink_inline_operations = {
+static const struct inode_operations shmem_symlink_inline_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= shmem_follow_link_inline,
 };
 
-static struct inode_operations shmem_symlink_inode_operations = {
+static const struct inode_operations shmem_symlink_inode_operations = {
 	.truncate	= shmem_truncate,
 	.readlink	= generic_readlink,
 	.follow_link	= shmem_follow_link,
@@ -2334,7 +2334,7 @@ static const struct file_operations shme
 #endif
 };
 
-static struct inode_operations shmem_inode_operations = {
+static const struct inode_operations shmem_inode_operations = {
 	.truncate	= shmem_truncate,
 	.setattr	= shmem_notify_change,
 	.truncate_range	= shmem_truncate_range,
@@ -2348,7 +2348,7 @@ static struct inode_operations shmem_ino
 
 };
 
-static struct inode_operations shmem_dir_inode_operations = {
+static const struct inode_operations shmem_dir_inode_operations = {
 #ifdef CONFIG_TMPFS
 	.create		= shmem_create,
 	.lookup		= simple_lookup,
@@ -2370,7 +2370,7 @@ static struct inode_operations shmem_dir
 #endif
 };
 
-static struct inode_operations shmem_special_inode_operations = {
+static const struct inode_operations shmem_special_inode_operations = {
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
 	.setxattr	= generic_setxattr,
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
