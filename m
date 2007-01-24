From: akpm@osdl.org
Subject: + mark-struct-super_operations-const.patch added to -mm tree
Date: Tue, 23 Jan 2007 17:12:09 -0800
Message-ID: <200701240112.l0O1C9af004679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXAXBMW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 20:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu


The patch titled
     Mark struct super_operations const
has been added to the -mm tree.  Its filename is
     mark-struct-super_operations-const.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Mark struct super_operations const
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

This patch is inspired by Arjan's "Patch series to mark struct
file_operations and struct inode_operations const".

Compile tested with gcc & sparse.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/vfs_super.c             |    4 ++--
 fs/adfs/super.c               |    2 +-
 fs/affs/super.c               |    2 +-
 fs/afs/super.c                |    2 +-
 fs/autofs/inode.c             |    2 +-
 fs/autofs4/inode.c            |    2 +-
 fs/bfs/inode.c                |    2 +-
 fs/binfmt_misc.c              |    2 +-
 fs/block_dev.c                |    2 +-
 fs/cifs/cifsfs.c              |    4 ++--
 fs/cifs/cifsfs.h              |    2 +-
 fs/coda/inode.c               |    2 +-
 fs/configfs/mount.c           |    2 +-
 fs/cramfs/inode.c             |    4 ++--
 fs/devpts/inode.c             |    2 +-
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 fs/ecryptfs/super.c           |    2 +-
 fs/efs/super.c                |    2 +-
 fs/ext2/super.c               |    2 +-
 fs/ext3/super.c               |    2 +-
 fs/ext4/super.c               |    2 +-
 fs/fat/inode.c                |    2 +-
 fs/freevxfs/vxfs_super.c      |    2 +-
 fs/fuse/inode.c               |    2 +-
 fs/gfs2/ops_super.c           |    2 +-
 fs/gfs2/ops_super.h           |    2 +-
 fs/hfs/super.c                |    2 +-
 fs/hfsplus/super.c            |    2 +-
 fs/hostfs/hostfs_kern.c       |    2 +-
 fs/hpfs/super.c               |    2 +-
 fs/hppfs/hppfs_kern.c         |    4 ++--
 fs/hugetlbfs/inode.c          |    4 ++--
 fs/inode.c                    |    6 +++---
 fs/isofs/inode.c              |    2 +-
 fs/jffs/inode-v23.c           |    4 ++--
 fs/jffs2/super.c              |    2 +-
 fs/jfs/super.c                |    4 ++--
 fs/libfs.c                    |    4 ++--
 fs/minix/inode.c              |    2 +-
 fs/ncpfs/inode.c              |    2 +-
 fs/nfs/super.c                |    4 ++--
 fs/ntfs/super.c               |    2 +-
 fs/ocfs2/dlm/dlmfs.c          |    4 ++--
 fs/ocfs2/super.c              |    2 +-
 fs/openpromfs/inode.c         |    2 +-
 fs/proc/inode.c               |    2 +-
 fs/qnx4/inode.c               |    4 ++--
 fs/ramfs/inode.c              |    4 ++--
 fs/reiserfs/super.c           |    2 +-
 fs/romfs/inode.c              |    4 ++--
 fs/smbfs/inode.c              |    2 +-
 fs/super.c                    |    2 +-
 fs/sysfs/mount.c              |    2 +-
 fs/sysv/inode.c               |    2 +-
 fs/sysv/sysv.h                |    2 +-
 fs/udf/super.c                |    2 +-
 fs/ufs/super.c                |    4 ++--
 include/linux/fs.h            |    4 ++--
 58 files changed, 75 insertions(+), 75 deletions(-)

diff -puN fs/9p/vfs_super.c~mark-struct-super_operations-const fs/9p/vfs_super.c
--- a/fs/9p/vfs_super.c~mark-struct-super_operations-const
+++ a/fs/9p/vfs_super.c
@@ -45,7 +45,7 @@
 #include "fid.h"
 
 static void v9fs_clear_inode(struct inode *);
-static struct super_operations v9fs_super_ops;
+static const struct super_operations v9fs_super_ops;
 
 /**
  * v9fs_clear_inode - release an inode
@@ -263,7 +263,7 @@ v9fs_umount_begin(struct vfsmount *vfsmn
 		v9fs_session_cancel(v9ses);
 }
 
-static struct super_operations v9fs_super_ops = {
+static const struct super_operations v9fs_super_ops = {
 	.statfs = simple_statfs,
 	.clear_inode = v9fs_clear_inode,
 	.show_options = v9fs_show_options,
diff -puN fs/adfs/super.c~mark-struct-super_operations-const fs/adfs/super.c
--- a/fs/adfs/super.c~mark-struct-super_operations-const
+++ a/fs/adfs/super.c
@@ -254,7 +254,7 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(adfs_inode_cachep);
 }
 
-static struct super_operations adfs_sops = {
+static const struct super_operations adfs_sops = {
 	.alloc_inode	= adfs_alloc_inode,
 	.destroy_inode	= adfs_destroy_inode,
 	.write_inode	= adfs_write_inode,
diff -puN fs/affs/super.c~mark-struct-super_operations-const fs/affs/super.c
--- a/fs/affs/super.c~mark-struct-super_operations-const
+++ a/fs/affs/super.c
@@ -112,7 +112,7 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(affs_inode_cachep);
 }
 
-static struct super_operations affs_sops = {
+static const struct super_operations affs_sops = {
 	.alloc_inode	= affs_alloc_inode,
 	.destroy_inode	= affs_destroy_inode,
 	.read_inode	= affs_read_inode,
diff -puN fs/afs/super.c~mark-struct-super_operations-const fs/afs/super.c
--- a/fs/afs/super.c~mark-struct-super_operations-const
+++ a/fs/afs/super.c
@@ -56,7 +56,7 @@ struct file_system_type afs_fs_type = {
 	.fs_flags	= FS_BINARY_MOUNTDATA,
 };
 
-static struct super_operations afs_super_ops = {
+static const struct super_operations afs_super_ops = {
 	.statfs		= simple_statfs,
 	.alloc_inode	= afs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
diff -puN fs/autofs/inode.c~mark-struct-super_operations-const fs/autofs/inode.c
--- a/fs/autofs/inode.c~mark-struct-super_operations-const
+++ a/fs/autofs/inode.c
@@ -52,7 +52,7 @@ out_kill_sb:
 
 static void autofs_read_inode(struct inode *inode);
 
-static struct super_operations autofs_sops = {
+static const struct super_operations autofs_sops = {
 	.read_inode	= autofs_read_inode,
 	.statfs		= simple_statfs,
 };
diff -puN fs/autofs4/inode.c~mark-struct-super_operations-const fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~mark-struct-super_operations-const
+++ a/fs/autofs4/inode.c
@@ -196,7 +196,7 @@ static int autofs4_show_options(struct s
 	return 0;
 }
 
-static struct super_operations autofs4_sops = {
+static const struct super_operations autofs4_sops = {
 	.statfs		= simple_statfs,
 	.show_options	= autofs4_show_options,
 };
diff -puN fs/bfs/inode.c~mark-struct-super_operations-const fs/bfs/inode.c
--- a/fs/bfs/inode.c~mark-struct-super_operations-const
+++ a/fs/bfs/inode.c
@@ -270,7 +270,7 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(bfs_inode_cachep);
 }
 
-static struct super_operations bfs_sops = {
+static const struct super_operations bfs_sops = {
 	.alloc_inode	= bfs_alloc_inode,
 	.destroy_inode	= bfs_destroy_inode,
 	.read_inode	= bfs_read_inode,
diff -puN fs/binfmt_misc.c~mark-struct-super_operations-const fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~mark-struct-super_operations-const
+++ a/fs/binfmt_misc.c
@@ -719,7 +719,7 @@ static const struct file_operations bm_s
 
 /* Superblock handling */
 
-static struct super_operations s_ops = {
+static const struct super_operations s_ops = {
 	.statfs		= simple_statfs,
 	.clear_inode	= bm_clear_inode,
 };
diff -puN fs/block_dev.c~mark-struct-super_operations-const fs/block_dev.c
--- a/fs/block_dev.c~mark-struct-super_operations-const
+++ a/fs/block_dev.c
@@ -447,7 +447,7 @@ static void bdev_clear_inode(struct inod
 	spin_unlock(&bdev_lock);
 }
 
-static struct super_operations bdev_sops = {
+static const struct super_operations bdev_sops = {
 	.statfs = simple_statfs,
 	.alloc_inode = bdev_alloc_inode,
 	.destroy_inode = bdev_destroy_inode,
diff -puN fs/cifs/cifsfs.c~mark-struct-super_operations-const fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~mark-struct-super_operations-const
+++ a/fs/cifs/cifsfs.c
@@ -64,7 +64,7 @@ extern struct task_struct * oplockThread
 struct task_struct * oplockThread = NULL;
 extern struct task_struct * dnotifyThread; /* remove sparse warning */
 struct task_struct * dnotifyThread = NULL;
-static struct super_operations cifs_super_ops; 
+static const struct super_operations cifs_super_ops;
 unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
 module_param(CIFSMaxBufSize, int, 0);
 MODULE_PARM_DESC(CIFSMaxBufSize,"Network buffer size (not including header). Default: 16384 Range: 8192 to 130048");
@@ -453,7 +453,7 @@ static int cifs_remount(struct super_blo
 	return 0;
 }
 
-static struct super_operations cifs_super_ops = {
+static const struct super_operations cifs_super_ops = {
 	.read_inode = cifs_read_inode,
 	.put_super = cifs_put_super,
 	.statfs = cifs_statfs,
diff -puN fs/cifs/cifsfs.h~mark-struct-super_operations-const fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~mark-struct-super_operations-const
+++ a/fs/cifs/cifsfs.h
@@ -36,7 +36,7 @@ extern const struct address_space_operat
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
 /* Functions related to super block operations */
-/* extern struct super_operations cifs_super_ops;*/
+/* extern const struct super_operations cifs_super_ops;*/
 extern void cifs_read_inode(struct inode *);
 extern void cifs_delete_inode(struct inode *);
 /* extern void cifs_write_inode(struct inode *); *//* BB not needed yet */
diff -puN fs/coda/inode.c~mark-struct-super_operations-const fs/coda/inode.c
--- a/fs/coda/inode.c~mark-struct-super_operations-const
+++ a/fs/coda/inode.c
@@ -90,7 +90,7 @@ static int coda_remount(struct super_blo
 }
 
 /* exported operations */
-static struct super_operations coda_super_operations =
+static const struct super_operations coda_super_operations =
 {
 	.alloc_inode	= coda_alloc_inode,
 	.destroy_inode	= coda_destroy_inode,
diff -puN fs/configfs/mount.c~mark-struct-super_operations-const fs/configfs/mount.c
--- a/fs/configfs/mount.c~mark-struct-super_operations-const
+++ a/fs/configfs/mount.c
@@ -41,7 +41,7 @@ struct super_block * configfs_sb = NULL;
 struct kmem_cache *configfs_dir_cachep;
 static int configfs_mnt_count = 0;
 
-static struct super_operations configfs_ops = {
+static const struct super_operations configfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 };
diff -puN fs/cramfs/inode.c~mark-struct-super_operations-const fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~mark-struct-super_operations-const
+++ a/fs/cramfs/inode.c
@@ -27,7 +27,7 @@
 
 #include <asm/uaccess.h>
 
-static struct super_operations cramfs_ops;
+static const struct super_operations cramfs_ops;
 static const struct inode_operations cramfs_dir_inode_operations;
 static const struct file_operations cramfs_directory_operations;
 static const struct address_space_operations cramfs_aops;
@@ -522,7 +522,7 @@ static const struct inode_operations cra
 	.lookup		= cramfs_lookup,
 };
 
-static struct super_operations cramfs_ops = {
+static const struct super_operations cramfs_ops = {
 	.put_super	= cramfs_put_super,
 	.remount_fs	= cramfs_remount,
 	.statfs		= cramfs_statfs,
diff -puN fs/devpts/inode.c~mark-struct-super_operations-const fs/devpts/inode.c
--- a/fs/devpts/inode.c~mark-struct-super_operations-const
+++ a/fs/devpts/inode.c
@@ -91,7 +91,7 @@ static int devpts_remount(struct super_b
 	return 0;
 }
 
-static struct super_operations devpts_sops = {
+static const struct super_operations devpts_sops = {
 	.statfs		= simple_statfs,
 	.remount_fs	= devpts_remount,
 };
diff -puN fs/ecryptfs/ecryptfs_kernel.h~mark-struct-super_operations-const fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~mark-struct-super_operations-const
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -465,7 +465,7 @@ extern const struct file_operations ecry
 extern const struct inode_operations ecryptfs_main_iops;
 extern const struct inode_operations ecryptfs_dir_iops;
 extern const struct inode_operations ecryptfs_symlink_iops;
-extern struct super_operations ecryptfs_sops;
+extern const struct super_operations ecryptfs_sops;
 extern struct dentry_operations ecryptfs_dops;
 extern struct address_space_operations ecryptfs_aops;
 extern int ecryptfs_verbosity;
diff -puN fs/ecryptfs/super.c~mark-struct-super_operations-const fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~mark-struct-super_operations-const
+++ a/fs/ecryptfs/super.c
@@ -168,7 +168,7 @@ out:
 	return rc;
 }
 
-struct super_operations ecryptfs_sops = {
+const struct super_operations ecryptfs_sops = {
 	.alloc_inode = ecryptfs_alloc_inode,
 	.destroy_inode = ecryptfs_destroy_inode,
 	.drop_inode = generic_delete_inode,
diff -puN fs/efs/super.c~mark-struct-super_operations-const fs/efs/super.c
--- a/fs/efs/super.c~mark-struct-super_operations-const
+++ a/fs/efs/super.c
@@ -105,7 +105,7 @@ static int efs_remount(struct super_bloc
 	return 0;
 }
 
-static struct super_operations efs_superblock_operations = {
+static const struct super_operations efs_superblock_operations = {
 	.alloc_inode	= efs_alloc_inode,
 	.destroy_inode	= efs_destroy_inode,
 	.read_inode	= efs_read_inode,
diff -puN fs/ext2/super.c~mark-struct-super_operations-const fs/ext2/super.c
--- a/fs/ext2/super.c~mark-struct-super_operations-const
+++ a/fs/ext2/super.c
@@ -237,7 +237,7 @@ static ssize_t ext2_quota_read(struct su
 static ssize_t ext2_quota_write(struct super_block *sb, int type, const char *data, size_t len, loff_t off);
 #endif
 
-static struct super_operations ext2_sops = {
+static const struct super_operations ext2_sops = {
 	.alloc_inode	= ext2_alloc_inode,
 	.destroy_inode	= ext2_destroy_inode,
 	.read_inode	= ext2_read_inode,
diff -puN fs/ext3/super.c~mark-struct-super_operations-const fs/ext3/super.c
--- a/fs/ext3/super.c~mark-struct-super_operations-const
+++ a/fs/ext3/super.c
@@ -639,7 +639,7 @@ static struct quotactl_ops ext3_qctl_ope
 };
 #endif
 
-static struct super_operations ext3_sops = {
+static const struct super_operations ext3_sops = {
 	.alloc_inode	= ext3_alloc_inode,
 	.destroy_inode	= ext3_destroy_inode,
 	.read_inode	= ext3_read_inode,
diff -puN fs/ext4/super.c~mark-struct-super_operations-const fs/ext4/super.c
--- a/fs/ext4/super.c~mark-struct-super_operations-const
+++ a/fs/ext4/super.c
@@ -690,7 +690,7 @@ static struct quotactl_ops ext4_qctl_ope
 };
 #endif
 
-static struct super_operations ext4_sops = {
+static const struct super_operations ext4_sops = {
 	.alloc_inode	= ext4_alloc_inode,
 	.destroy_inode	= ext4_destroy_inode,
 	.read_inode	= ext4_read_inode,
diff -puN fs/fat/inode.c~mark-struct-super_operations-const fs/fat/inode.c
--- a/fs/fat/inode.c~mark-struct-super_operations-const
+++ a/fs/fat/inode.c
@@ -617,7 +617,7 @@ int fat_sync_inode(struct inode *inode)
 EXPORT_SYMBOL_GPL(fat_sync_inode);
 
 static int fat_show_options(struct seq_file *m, struct vfsmount *mnt);
-static struct super_operations fat_sops = {
+static const struct super_operations fat_sops = {
 	.alloc_inode	= fat_alloc_inode,
 	.destroy_inode	= fat_destroy_inode,
 	.write_inode	= fat_write_inode,
diff -puN fs/freevxfs/vxfs_super.c~mark-struct-super_operations-const fs/freevxfs/vxfs_super.c
--- a/fs/freevxfs/vxfs_super.c~mark-struct-super_operations-const
+++ a/fs/freevxfs/vxfs_super.c
@@ -59,7 +59,7 @@ static void		vxfs_put_super(struct super
 static int		vxfs_statfs(struct dentry *, struct kstatfs *);
 static int		vxfs_remount(struct super_block *, int *, char *);
 
-static struct super_operations vxfs_super_ops = {
+static const struct super_operations vxfs_super_ops = {
 	.read_inode =		vxfs_read_inode,
 	.clear_inode =		vxfs_clear_inode,
 	.put_super =		vxfs_put_super,
diff -puN fs/fuse/inode.c~mark-struct-super_operations-const fs/fuse/inode.c
--- a/fs/fuse/inode.c~mark-struct-super_operations-const
+++ a/fs/fuse/inode.c
@@ -445,7 +445,7 @@ static struct inode *get_root_inode(stru
 	return fuse_iget(sb, 1, 0, &attr);
 }
 
-static struct super_operations fuse_super_operations = {
+static const struct super_operations fuse_super_operations = {
 	.alloc_inode    = fuse_alloc_inode,
 	.destroy_inode  = fuse_destroy_inode,
 	.read_inode	= fuse_read_inode,
diff -puN fs/gfs2/ops_super.c~mark-struct-super_operations-const fs/gfs2/ops_super.c
--- a/fs/gfs2/ops_super.c~mark-struct-super_operations-const
+++ a/fs/gfs2/ops_super.c
@@ -468,7 +468,7 @@ static void gfs2_destroy_inode(struct in
 	kmem_cache_free(gfs2_inode_cachep, inode);
 }
 
-struct super_operations gfs2_super_ops = {
+const struct super_operations gfs2_super_ops = {
 	.alloc_inode		= gfs2_alloc_inode,
 	.destroy_inode		= gfs2_destroy_inode,
 	.write_inode		= gfs2_write_inode,
diff -puN fs/gfs2/ops_super.h~mark-struct-super_operations-const fs/gfs2/ops_super.h
--- a/fs/gfs2/ops_super.h~mark-struct-super_operations-const
+++ a/fs/gfs2/ops_super.h
@@ -12,6 +12,6 @@
 
 #include <linux/fs.h>
 
-extern struct super_operations gfs2_super_ops;
+extern const struct super_operations gfs2_super_ops;
 
 #endif /* __OPS_SUPER_DOT_H__ */
diff -puN fs/hfs/super.c~mark-struct-super_operations-const fs/hfs/super.c
--- a/fs/hfs/super.c~mark-struct-super_operations-const
+++ a/fs/hfs/super.c
@@ -154,7 +154,7 @@ static void hfs_destroy_inode(struct ino
 	kmem_cache_free(hfs_inode_cachep, HFS_I(inode));
 }
 
-static struct super_operations hfs_super_operations = {
+static const struct super_operations hfs_super_operations = {
 	.alloc_inode	= hfs_alloc_inode,
 	.destroy_inode	= hfs_destroy_inode,
 	.write_inode	= hfs_write_inode,
diff -puN fs/hfsplus/super.c~mark-struct-super_operations-const fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~mark-struct-super_operations-const
+++ a/fs/hfsplus/super.c
@@ -259,7 +259,7 @@ static int hfsplus_remount(struct super_
 	return 0;
 }
 
-static struct super_operations hfsplus_sops = {
+static const struct super_operations hfsplus_sops = {
 	.alloc_inode	= hfsplus_alloc_inode,
 	.destroy_inode	= hfsplus_destroy_inode,
 	.read_inode	= hfsplus_read_inode,
diff -puN fs/hostfs/hostfs_kern.c~mark-struct-super_operations-const fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~mark-struct-super_operations-const
+++ a/fs/hostfs/hostfs_kern.c
@@ -309,7 +309,7 @@ static void hostfs_read_inode(struct ino
 	read_inode(inode);
 }
 
-static struct super_operations hostfs_sbops = {
+static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode   = hostfs_delete_inode,
diff -puN fs/hpfs/super.c~mark-struct-super_operations-const fs/hpfs/super.c
--- a/fs/hpfs/super.c~mark-struct-super_operations-const
+++ a/fs/hpfs/super.c
@@ -426,7 +426,7 @@ static int hpfs_remount_fs(struct super_
 
 /* Super operations */
 
-static struct super_operations hpfs_sops =
+static const struct super_operations hpfs_sops =
 {
 	.alloc_inode	= hpfs_alloc_inode,
 	.destroy_inode	= hpfs_destroy_inode,
diff -puN fs/hppfs/hppfs_kern.c~mark-struct-super_operations-const fs/hppfs/hppfs_kern.c
--- a/fs/hppfs/hppfs_kern.c~mark-struct-super_operations-const
+++ a/fs/hppfs/hppfs_kern.c
@@ -43,7 +43,7 @@ static inline struct hppfs_inode_info *H
 
 #define HPPFS_SUPER_MAGIC 0xb00000ee
 
-static struct super_operations hppfs_sbops;
+static const struct super_operations hppfs_sbops;
 
 static int is_pid(struct dentry *dentry)
 {
@@ -649,7 +649,7 @@ static void hppfs_destroy_inode(struct i
 	kfree(HPPFS_I(inode));
 }
 
-static struct super_operations hppfs_sbops = {
+static const struct super_operations hppfs_sbops = {
 	.alloc_inode	= hppfs_alloc_inode,
 	.destroy_inode	= hppfs_destroy_inode,
 	.read_inode	= hppfs_read_inode,
diff -puN fs/hugetlbfs/inode.c~mark-struct-super_operations-const fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mark-struct-super_operations-const
+++ a/fs/hugetlbfs/inode.c
@@ -33,7 +33,7 @@
 /* some random number */
 #define HUGETLBFS_MAGIC	0x958458f6
 
-static struct super_operations hugetlbfs_ops;
+static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
 static const struct inode_operations hugetlbfs_dir_inode_operations;
@@ -577,7 +577,7 @@ static const struct inode_operations hug
 	.setattr	= hugetlbfs_setattr,
 };
 
-static struct super_operations hugetlbfs_ops = {
+static const struct super_operations hugetlbfs_ops = {
 	.alloc_inode    = hugetlbfs_alloc_inode,
 	.destroy_inode  = hugetlbfs_destroy_inode,
 	.statfs		= hugetlbfs_statfs,
diff -puN fs/inode.c~mark-struct-super_operations-const fs/inode.c
--- a/fs/inode.c~mark-struct-super_operations-const
+++ a/fs/inode.c
@@ -1000,7 +1000,7 @@ EXPORT_SYMBOL(remove_inode_hash);
  */
 void generic_delete_inode(struct inode *inode)
 {
-	struct super_operations *op = inode->i_sb->s_op;
+	const struct super_operations *op = inode->i_sb->s_op;
 
 	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
@@ -1093,7 +1093,7 @@ EXPORT_SYMBOL_GPL(generic_drop_inode);
  */
 static inline void iput_final(struct inode *inode)
 {
-	struct super_operations *op = inode->i_sb->s_op;
+	const struct super_operations *op = inode->i_sb->s_op;
 	void (*drop)(struct inode *) = generic_drop_inode;
 
 	if (op && op->drop_inode)
@@ -1113,7 +1113,7 @@ static inline void iput_final(struct ino
 void iput(struct inode *inode)
 {
 	if (inode) {
-		struct super_operations *op = inode->i_sb->s_op;
+		const struct super_operations *op = inode->i_sb->s_op;
 
 		BUG_ON(inode->i_state == I_CLEAR);
 
diff -puN fs/isofs/inode.c~mark-struct-super_operations-const fs/isofs/inode.c
--- a/fs/isofs/inode.c~mark-struct-super_operations-const
+++ a/fs/isofs/inode.c
@@ -106,7 +106,7 @@ static int isofs_remount(struct super_bl
 	return 0;
 }
 
-static struct super_operations isofs_sops = {
+static const struct super_operations isofs_sops = {
 	.alloc_inode	= isofs_alloc_inode,
 	.destroy_inode	= isofs_destroy_inode,
 	.read_inode	= isofs_read_inode,
diff -puN fs/jffs/inode-v23.c~mark-struct-super_operations-const fs/jffs/inode-v23.c
--- a/fs/jffs/inode-v23.c~mark-struct-super_operations-const
+++ a/fs/jffs/inode-v23.c
@@ -54,7 +54,7 @@
 
 static int jffs_remove(struct inode *dir, struct dentry *dentry, int type);
 
-static struct super_operations jffs_ops;
+static const struct super_operations jffs_ops;
 static const struct file_operations jffs_file_operations;
 static const struct inode_operations jffs_file_inode_operations;
 static const struct file_operations jffs_dir_operations;
@@ -1774,7 +1774,7 @@ static int jffs_remount(struct super_blo
 	return 0;
 }
 
-static struct super_operations jffs_ops =
+static const struct super_operations jffs_ops =
 {
 	.read_inode	= jffs_read_inode,
 	.delete_inode 	= jffs_delete_inode,
diff -puN fs/jffs2/super.c~mark-struct-super_operations-const fs/jffs2/super.c
--- a/fs/jffs2/super.c~mark-struct-super_operations-const
+++ a/fs/jffs2/super.c
@@ -66,7 +66,7 @@ static int jffs2_sync_fs(struct super_bl
 	return 0;
 }
 
-static struct super_operations jffs2_super_operations =
+static const struct super_operations jffs2_super_operations =
 {
 	.alloc_inode =	jffs2_alloc_inode,
 	.destroy_inode =jffs2_destroy_inode,
diff -puN fs/jfs/super.c~mark-struct-super_operations-const fs/jfs/super.c
--- a/fs/jfs/super.c~mark-struct-super_operations-const
+++ a/fs/jfs/super.c
@@ -46,7 +46,7 @@ MODULE_LICENSE("GPL");
 
 static struct kmem_cache * jfs_inode_cachep;
 
-static struct super_operations jfs_super_operations;
+static const struct super_operations jfs_super_operations;
 static struct export_operations jfs_export_operations;
 static struct file_system_type jfs_fs_type;
 
@@ -716,7 +716,7 @@ out:
 
 #endif
 
-static struct super_operations jfs_super_operations = {
+static const struct super_operations jfs_super_operations = {
 	.alloc_inode	= jfs_alloc_inode,
 	.destroy_inode	= jfs_destroy_inode,
 	.read_inode	= jfs_read_inode,
diff -puN fs/libfs.c~mark-struct-super_operations-const fs/libfs.c
--- a/fs/libfs.c~mark-struct-super_operations-const
+++ a/fs/libfs.c
@@ -195,11 +195,11 @@ const struct inode_operations simple_dir
  * will never be mountable)
  */
 int get_sb_pseudo(struct file_system_type *fs_type, char *name,
-	struct super_operations *ops, unsigned long magic,
+	const struct super_operations *ops, unsigned long magic,
 	struct vfsmount *mnt)
 {
 	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
-	static struct super_operations default_ops = {.statfs = simple_statfs};
+	static const struct super_operations default_ops = {.statfs = simple_statfs};
 	struct dentry *dentry;
 	struct inode *root;
 	struct qstr d_name = {.name = name, .len = strlen(name)};
diff -puN fs/minix/inode.c~mark-struct-super_operations-const fs/minix/inode.c
--- a/fs/minix/inode.c~mark-struct-super_operations-const
+++ a/fs/minix/inode.c
@@ -95,7 +95,7 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(minix_inode_cachep);
 }
 
-static struct super_operations minix_sops = {
+static const struct super_operations minix_sops = {
 	.alloc_inode	= minix_alloc_inode,
 	.destroy_inode	= minix_destroy_inode,
 	.read_inode	= minix_read_inode,
diff -puN fs/ncpfs/inode.c~mark-struct-super_operations-const fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~mark-struct-super_operations-const
+++ a/fs/ncpfs/inode.c
@@ -90,7 +90,7 @@ static int ncp_remount(struct super_bloc
 	return 0;
 }
 
-static struct super_operations ncp_sops =
+static const struct super_operations ncp_sops =
 {
 	.alloc_inode	= ncp_alloc_inode,
 	.destroy_inode	= ncp_destroy_inode,
diff -puN fs/nfs/super.c~mark-struct-super_operations-const fs/nfs/super.c
--- a/fs/nfs/super.c~mark-struct-super_operations-const
+++ a/fs/nfs/super.c
@@ -82,7 +82,7 @@ struct file_system_type nfs_xdev_fs_type
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
 };
 
-static struct super_operations nfs_sops = {
+static const struct super_operations nfs_sops = {
 	.alloc_inode	= nfs_alloc_inode,
 	.destroy_inode	= nfs_destroy_inode,
 	.write_inode	= nfs_write_inode,
@@ -126,7 +126,7 @@ struct file_system_type nfs4_referral_fs
 	.fs_flags	= FS_RENAME_DOES_D_MOVE|FS_REVAL_DOT|FS_BINARY_MOUNTDATA,
 };
 
-static struct super_operations nfs4_sops = {
+static const struct super_operations nfs4_sops = {
 	.alloc_inode	= nfs_alloc_inode,
 	.destroy_inode	= nfs_destroy_inode,
 	.write_inode	= nfs_write_inode,
diff -puN fs/ntfs/super.c~mark-struct-super_operations-const fs/ntfs/super.c
--- a/fs/ntfs/super.c~mark-struct-super_operations-const
+++ a/fs/ntfs/super.c
@@ -2699,7 +2699,7 @@ static int ntfs_statfs(struct dentry *de
 /**
  * The complete super operations.
  */
-static struct super_operations ntfs_sops = {
+static const struct super_operations ntfs_sops = {
 	.alloc_inode	= ntfs_alloc_big_inode,	  /* VFS: Allocate new inode. */
 	.destroy_inode	= ntfs_destroy_big_inode, /* VFS: Deallocate inode. */
 #ifdef NTFS_RW
diff -puN fs/ocfs2/dlm/dlmfs.c~mark-struct-super_operations-const fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~mark-struct-super_operations-const
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -61,7 +61,7 @@
 #define MLOG_MASK_PREFIX ML_DLMFS
 #include "cluster/masklog.h"
 
-static struct super_operations dlmfs_ops;
+static const struct super_operations dlmfs_ops;
 static const struct file_operations dlmfs_file_operations;
 static const struct inode_operations dlmfs_dir_inode_operations;
 static const struct inode_operations dlmfs_root_inode_operations;
@@ -560,7 +560,7 @@ static const struct inode_operations dlm
 	.rmdir		= simple_rmdir,
 };
 
-static struct super_operations dlmfs_ops = {
+static const struct super_operations dlmfs_ops = {
 	.statfs		= simple_statfs,
 	.alloc_inode	= dlmfs_alloc_inode,
 	.destroy_inode	= dlmfs_destroy_inode,
diff -puN fs/ocfs2/super.c~mark-struct-super_operations-const fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~mark-struct-super_operations-const
+++ a/fs/ocfs2/super.c
@@ -116,7 +116,7 @@ static void ocfs2_destroy_inode(struct i
 
 static unsigned long long ocfs2_max_file_offset(unsigned int blockshift);
 
-static struct super_operations ocfs2_sops = {
+static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
 	.destroy_inode	= ocfs2_destroy_inode,
diff -puN fs/openpromfs/inode.c~mark-struct-super_operations-const fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~mark-struct-super_operations-const
+++ a/fs/openpromfs/inode.c
@@ -364,7 +364,7 @@ static int openprom_remount(struct super
 	return 0;
 }
 
-static struct super_operations openprom_sops = { 
+static const struct super_operations openprom_sops = {
 	.alloc_inode	= openprom_alloc_inode,
 	.destroy_inode	= openprom_destroy_inode,
 	.read_inode	= openprom_read_inode,
diff -puN fs/proc/inode.c~mark-struct-super_operations-const fs/proc/inode.c
--- a/fs/proc/inode.c~mark-struct-super_operations-const
+++ a/fs/proc/inode.c
@@ -125,7 +125,7 @@ static int proc_remount(struct super_blo
 	return 0;
 }
 
-static struct super_operations proc_sops = { 
+static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.read_inode	= proc_read_inode,
diff -puN fs/qnx4/inode.c~mark-struct-super_operations-const fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~mark-struct-super_operations-const
+++ a/fs/qnx4/inode.c
@@ -30,7 +30,7 @@
 #define QNX4_VERSION  4
 #define QNX4_BMNAME   ".bitmap"
 
-static struct super_operations qnx4_sops;
+static const struct super_operations qnx4_sops;
 
 #ifdef CONFIG_QNX4FS_RW
 
@@ -129,7 +129,7 @@ static void qnx4_read_inode(struct inode
 static int qnx4_remount(struct super_block *sb, int *flags, char *data);
 static int qnx4_statfs(struct dentry *, struct kstatfs *);
 
-static struct super_operations qnx4_sops =
+static const struct super_operations qnx4_sops =
 {
 	.alloc_inode	= qnx4_alloc_inode,
 	.destroy_inode	= qnx4_destroy_inode,
diff -puN fs/ramfs/inode.c~mark-struct-super_operations-const fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~mark-struct-super_operations-const
+++ a/fs/ramfs/inode.c
@@ -40,7 +40,7 @@
 /* some random number */
 #define RAMFS_MAGIC	0x858458f6
 
-static struct super_operations ramfs_ops;
+static const struct super_operations ramfs_ops;
 static const struct inode_operations ramfs_dir_inode_operations;
 
 static struct backing_dev_info ramfs_backing_dev_info = {
@@ -155,7 +155,7 @@ static const struct inode_operations ram
 	.rename		= simple_rename,
 };
 
-static struct super_operations ramfs_ops = {
+static const struct super_operations ramfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 };
diff -puN fs/reiserfs/super.c~mark-struct-super_operations-const fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~mark-struct-super_operations-const
+++ a/fs/reiserfs/super.c
@@ -593,7 +593,7 @@ static ssize_t reiserfs_quota_read(struc
 				   loff_t);
 #endif
 
-static struct super_operations reiserfs_sops = {
+static const struct super_operations reiserfs_sops = {
 	.alloc_inode = reiserfs_alloc_inode,
 	.destroy_inode = reiserfs_destroy_inode,
 	.write_inode = reiserfs_write_inode,
diff -puN fs/romfs/inode.c~mark-struct-super_operations-const fs/romfs/inode.c
--- a/fs/romfs/inode.c~mark-struct-super_operations-const
+++ a/fs/romfs/inode.c
@@ -110,7 +110,7 @@ romfs_checksum(void *data, int size)
 	return sum;
 }
 
-static struct super_operations romfs_ops;
+static const struct super_operations romfs_ops;
 
 static int romfs_fill_super(struct super_block *s, void *data, int silent)
 {
@@ -598,7 +598,7 @@ static int romfs_remount(struct super_bl
 	return 0;
 }
 
-static struct super_operations romfs_ops = {
+static const struct super_operations romfs_ops = {
 	.alloc_inode	= romfs_alloc_inode,
 	.destroy_inode	= romfs_destroy_inode,
 	.read_inode	= romfs_read_inode,
diff -puN fs/smbfs/inode.c~mark-struct-super_operations-const fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~mark-struct-super_operations-const
+++ a/fs/smbfs/inode.c
@@ -98,7 +98,7 @@ static int smb_remount(struct super_bloc
 	return 0;
 }
 
-static struct super_operations smb_sops =
+static const struct super_operations smb_sops =
 {
 	.alloc_inode	= smb_alloc_inode,
 	.destroy_inode	= smb_destroy_inode,
diff -puN fs/super.c~mark-struct-super_operations-const fs/super.c
--- a/fs/super.c~mark-struct-super_operations-const
+++ a/fs/super.c
@@ -285,7 +285,7 @@ int fsync_super(struct super_block *sb)
  */
 void generic_shutdown_super(struct super_block *sb)
 {
-	struct super_operations *sop = sb->s_op;
+	const struct super_operations *sop = sb->s_op;
 
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
diff -puN fs/sysfs/mount.c~mark-struct-super_operations-const fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~mark-struct-super_operations-const
+++ a/fs/sysfs/mount.c
@@ -20,7 +20,7 @@ struct kmem_cache *sysfs_dir_cachep;
 
 static void sysfs_clear_inode(struct inode *inode);
 
-static struct super_operations sysfs_ops = {
+static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.clear_inode	= sysfs_clear_inode,
diff -puN fs/sysv/inode.c~mark-struct-super_operations-const fs/sysv/inode.c
--- a/fs/sysv/inode.c~mark-struct-super_operations-const
+++ a/fs/sysv/inode.c
@@ -327,7 +327,7 @@ static void init_once(void *p, struct km
 		inode_init_once(&si->vfs_inode);
 }
 
-struct super_operations sysv_sops = {
+const struct super_operations sysv_sops = {
 	.alloc_inode	= sysv_alloc_inode,
 	.destroy_inode	= sysv_destroy_inode,
 	.read_inode	= sysv_read_inode,
diff -puN fs/sysv/sysv.h~mark-struct-super_operations-const fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~mark-struct-super_operations-const
+++ a/fs/sysv/sysv.h
@@ -165,7 +165,7 @@ extern const struct inode_operations sys
 extern const struct file_operations sysv_file_operations;
 extern const struct file_operations sysv_dir_operations;
 extern const struct address_space_operations sysv_aops;
-extern struct super_operations sysv_sops;
+extern const struct super_operations sysv_sops;
 extern struct dentry_operations sysv_dentry_operations;
 
 
diff -puN fs/udf/super.c~mark-struct-super_operations-const fs/udf/super.c
--- a/fs/udf/super.c~mark-struct-super_operations-const
+++ a/fs/udf/super.c
@@ -160,7 +160,7 @@ static void destroy_inodecache(void)
 }
 
 /* Superblock operations */
-static struct super_operations udf_sb_ops = {
+static const struct super_operations udf_sb_ops = {
 	.alloc_inode		= udf_alloc_inode,
 	.destroy_inode		= udf_destroy_inode,
 	.write_inode		= udf_write_inode,
diff -puN fs/ufs/super.c~mark-struct-super_operations-const fs/ufs/super.c
--- a/fs/ufs/super.c~mark-struct-super_operations-const
+++ a/fs/ufs/super.c
@@ -203,7 +203,7 @@ static void ufs_print_cylinder_stuff(str
 #  define ufs_print_cylinder_stuff(sb, cg) /**/
 #endif /* CONFIG_UFS_DEBUG */
 
-static struct super_operations ufs_super_ops;
+static const struct super_operations ufs_super_ops;
 
 static char error_buf[1024];
 
@@ -1252,7 +1252,7 @@ static ssize_t ufs_quota_read(struct sup
 static ssize_t ufs_quota_write(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 
-static struct super_operations ufs_super_ops = {
+static const struct super_operations ufs_super_ops = {
 	.alloc_inode	= ufs_alloc_inode,
 	.destroy_inode	= ufs_destroy_inode,
 	.read_inode	= ufs_read_inode,
diff -puN include/linux/fs.h~mark-struct-super_operations-const include/linux/fs.h
--- a/include/linux/fs.h~mark-struct-super_operations-const
+++ a/include/linux/fs.h
@@ -949,7 +949,7 @@ struct super_block {
 	unsigned char		s_dirt;
 	unsigned long long	s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
-	struct super_operations	*s_op;
+	const struct super_operations	*s_op;
 	struct dquot_operations	*dq_op;
  	struct quotactl_ops	*s_qcop;
 	struct export_operations *s_export_op;
@@ -1427,7 +1427,7 @@ struct super_block *sget(struct file_sys
 			int (*set)(struct super_block *,void *),
 			void *data);
 extern int get_sb_pseudo(struct file_system_type *, char *,
-	struct super_operations *ops, unsigned long,
+	const struct super_operations *ops, unsigned long,
 	struct vfsmount *mnt);
 extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super(struct super_block *sb);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

git-unionfs.patch
mark-struct-super_operations-const.patch
