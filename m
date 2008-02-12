From: akpm@linux-foundation.org
Subject: + efs-move-headers-out-of-include-linux.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:20:31 -0800
Message-ID: <200802122320.m1CNKVll028151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbYBLXUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     efs: move headers out of include/linux/
has been added to the -mm tree.  Its filename is
     efs-move-headers-out-of-include-linux.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efs: move headers out of include/linux/
From: Christoph Hellwig <hch@lst.de>

Merge include/linux/efs_fs{_i,_dir}.h into fs/efs/efs.h.  efs_vh.h remains
there because this is the IRIX volume header and shouldn't really be
handled by efs but by the partitioning code.  efs_sb.h remains there for
now because it's exported to userspace.  Of course this wrong and aboot
should have a copy of it's own, but I'll leave that to a separate patch to
avoid any contention.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/dir.c             |    2 
 fs/efs/efs.h             |  140 +++++++++++++++++++++++++++++++++++++
 fs/efs/file.c            |    2 
 fs/efs/inode.c           |    4 -
 fs/efs/namei.c           |    2 
 fs/efs/super.c           |    7 +
 fs/efs/symlink.c         |    2 
 include/linux/efs_dir.h  |   42 -----------
 include/linux/efs_fs.h   |   56 --------------
 include/linux/efs_fs_i.h |   68 -----------------
 10 files changed, 150 insertions(+), 175 deletions(-)

diff -puN fs/efs/dir.c~efs-move-headers-out-of-include-linux fs/efs/dir.c
--- a/fs/efs/dir.c~efs-move-headers-out-of-include-linux
+++ a/fs/efs/dir.c
@@ -5,8 +5,8 @@
  */
 
 #include <linux/buffer_head.h>
-#include <linux/efs_fs.h>
 #include <linux/smp_lock.h>
+#include "efs.h"
 
 static int efs_readdir(struct file *, void *, filldir_t);
 
diff -puN /dev/null fs/efs/efs.h
--- /dev/null
+++ a/fs/efs/efs.h
@@ -0,0 +1,140 @@
+/*
+ * Copyright (c) 1999 Al Smith
+ *
+ * Portions derived from work (c) 1995,1996 Christian Vogelgsang.
+ * Portions derived from IRIX header files (c) 1988 Silicon Graphics
+ */
+#ifndef _EFS_EFS_H_
+#define _EFS_EFS_H_
+
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+
+#define EFS_VERSION "1.0a"
+
+static const char cprt[] = "EFS: "EFS_VERSION" - (c) 1999 Al Smith <Al.Smith@aeschi.ch.eu.org>";
+
+
+/* 1 block is 512 bytes */
+#define	EFS_BLOCKSIZE_BITS	9
+#define	EFS_BLOCKSIZE		(1 << EFS_BLOCKSIZE_BITS)
+
+typedef	int32_t		efs_block_t;
+typedef uint32_t	efs_ino_t;
+
+#define	EFS_DIRECTEXTENTS	12
+
+/*
+ * layout of an extent, in memory and on disk. 8 bytes exactly.
+ */
+typedef union extent_u {
+	unsigned char raw[8];
+	struct extent_s {
+		unsigned int	ex_magic:8;	/* magic # (zero) */
+		unsigned int	ex_bn:24;	/* basic block */
+		unsigned int	ex_length:8;	/* numblocks in this extent */
+		unsigned int	ex_offset:24;	/* logical offset into file */
+	} cooked;
+} efs_extent;
+
+typedef struct edevs {
+	__be16		odev;
+	__be32		ndev;
+} efs_devs;
+
+/*
+ * extent based filesystem inode as it appears on disk.  The efs inode
+ * is exactly 128 bytes long.
+ */
+struct	efs_dinode {
+	__be16		di_mode;	/* mode and type of file */
+	__be16		di_nlink;	/* number of links to file */
+	__be16		di_uid;		/* owner's user id */
+	__be16		di_gid;		/* owner's group id */
+	__be32		di_size;	/* number of bytes in file */
+	__be32		di_atime;	/* time last accessed */
+	__be32		di_mtime;	/* time last modified */
+	__be32		di_ctime;	/* time created */
+	__be32		di_gen;		/* generation number */
+	__be16		di_numextents;	/* # of extents */
+	u_char		di_version;	/* version of inode */
+	u_char		di_spare;	/* spare - used by AFS */
+	union di_addr {
+		efs_extent	di_extents[EFS_DIRECTEXTENTS];
+		efs_devs	di_dev;	/* device for IFCHR/IFBLK */
+	} di_u;
+};
+
+/* efs inode storage in memory */
+struct efs_inode_info {
+	int		numextents;
+	int		lastextent;
+
+	efs_extent	extents[EFS_DIRECTEXTENTS];
+	struct inode	vfs_inode;
+};
+
+#include <linux/efs_fs_sb.h>
+
+#define EFS_DIRBSIZE_BITS	EFS_BLOCKSIZE_BITS
+#define EFS_DIRBSIZE		(1 << EFS_DIRBSIZE_BITS)
+
+struct efs_dentry {
+	__be32		inode;
+	unsigned char	namelen;
+	char		name[3];
+};
+
+#define EFS_DENTSIZE	(sizeof(struct efs_dentry) - 3 + 1)
+#define EFS_MAXNAMELEN  ((1 << (sizeof(char) * 8)) - 1)
+
+#define EFS_DIRBLK_HEADERSIZE	4
+#define EFS_DIRBLK_MAGIC	0xbeef	/* moo */
+
+struct efs_dir {
+	__be16	magic;
+	unsigned char	firstused;
+	unsigned char	slots;
+
+	unsigned char	space[EFS_DIRBSIZE - EFS_DIRBLK_HEADERSIZE];
+};
+
+#define EFS_MAXENTS \
+	((EFS_DIRBSIZE - EFS_DIRBLK_HEADERSIZE) / \
+	 (EFS_DENTSIZE + sizeof(char)))
+
+#define EFS_SLOTAT(dir, slot) EFS_REALOFF((dir)->space[slot])
+
+#define EFS_REALOFF(offset) ((offset << 1))
+
+
+static inline struct efs_inode_info *INODE_INFO(struct inode *inode)
+{
+	return container_of(inode, struct efs_inode_info, vfs_inode);
+}
+
+static inline struct efs_sb_info *SUPER_INFO(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+struct statfs;
+struct fid;
+
+extern const struct inode_operations efs_dir_inode_operations;
+extern const struct file_operations efs_dir_operations;
+extern const struct address_space_operations efs_symlink_aops;
+
+extern struct inode *efs_iget(struct super_block *, unsigned long);
+extern efs_block_t efs_map_block(struct inode *, efs_block_t);
+extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
+
+extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *efs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type);
+extern struct dentry *efs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type);
+extern struct dentry *efs_get_parent(struct dentry *);
+extern int efs_bmap(struct inode *, int);
+
+#endif /* _EFS_EFS_H_ */
diff -puN fs/efs/file.c~efs-move-headers-out-of-include-linux fs/efs/file.c
--- a/fs/efs/file.c~efs-move-headers-out-of-include-linux
+++ a/fs/efs/file.c
@@ -7,7 +7,7 @@
  */
 
 #include <linux/buffer_head.h>
-#include <linux/efs_fs.h>
+#include "efs.h"
 
 int efs_get_block(struct inode *inode, sector_t iblock,
 		  struct buffer_head *bh_result, int create)
diff -puN fs/efs/inode.c~efs-move-headers-out-of-include-linux fs/efs/inode.c
--- a/fs/efs/inode.c~efs-move-headers-out-of-include-linux
+++ a/fs/efs/inode.c
@@ -7,11 +7,11 @@
  *              and from work (c) 1998 Mike Shaver.
  */
 
-#include <linux/efs_fs.h>
-#include <linux/efs_fs_sb.h>
 #include <linux/buffer_head.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include "efs.h"
+#include <linux/efs_fs_sb.h>
 
 static int efs_readpage(struct file *file, struct page *page)
 {
diff -puN fs/efs/namei.c~efs-move-headers-out-of-include-linux fs/efs/namei.c
--- a/fs/efs/namei.c~efs-move-headers-out-of-include-linux
+++ a/fs/efs/namei.c
@@ -8,9 +8,9 @@
 
 #include <linux/buffer_head.h>
 #include <linux/string.h>
-#include <linux/efs_fs.h>
 #include <linux/smp_lock.h>
 #include <linux/exportfs.h>
+#include "efs.h"
 
 
 static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len) {
diff -puN fs/efs/super.c~efs-move-headers-out-of-include-linux fs/efs/super.c
--- a/fs/efs/super.c~efs-move-headers-out-of-include-linux
+++ a/fs/efs/super.c
@@ -8,14 +8,15 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/efs_fs.h>
-#include <linux/efs_vh.h>
-#include <linux/efs_fs_sb.h>
 #include <linux/exportfs.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 
+#include "efs.h"
+#include <linux/efs_vh.h>
+#include <linux/efs_fs_sb.h>
+
 static int efs_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int efs_fill_super(struct super_block *s, void *d, int silent);
 
diff -puN fs/efs/symlink.c~efs-move-headers-out-of-include-linux fs/efs/symlink.c
--- a/fs/efs/symlink.c~efs-move-headers-out-of-include-linux
+++ a/fs/efs/symlink.c
@@ -7,10 +7,10 @@
  */
 
 #include <linux/string.h>
-#include <linux/efs_fs.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/smp_lock.h>
+#include "efs.h"
 
 static int efs_symlink_readpage(struct file *file, struct page *page)
 {
diff -puN include/linux/efs_dir.h~efs-move-headers-out-of-include-linux /dev/null
--- a/include/linux/efs_dir.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * efs_dir.h
- *
- * Copyright (c) 1999 Al Smith
- */
-
-#ifndef __EFS_DIR_H__
-#define __EFS_DIR_H__
-
-#define EFS_DIRBSIZE_BITS	EFS_BLOCKSIZE_BITS
-#define EFS_DIRBSIZE		(1 << EFS_DIRBSIZE_BITS)
-
-struct efs_dentry {
-	__be32		inode;
-	unsigned char	namelen;
-	char		name[3];
-};
-
-#define EFS_DENTSIZE	(sizeof(struct efs_dentry) - 3 + 1)
-#define EFS_MAXNAMELEN  ((1 << (sizeof(char) * 8)) - 1)
-
-#define EFS_DIRBLK_HEADERSIZE	4
-#define EFS_DIRBLK_MAGIC	0xbeef	/* moo */
-
-struct efs_dir {
-	__be16	magic;
-	unsigned char	firstused;
-	unsigned char	slots;
-
-	unsigned char	space[EFS_DIRBSIZE - EFS_DIRBLK_HEADERSIZE];
-};
-
-#define EFS_MAXENTS \
-	((EFS_DIRBSIZE - EFS_DIRBLK_HEADERSIZE) / \
-	 (EFS_DENTSIZE + sizeof(char)))
-
-#define EFS_SLOTAT(dir, slot) EFS_REALOFF((dir)->space[slot])
-
-#define EFS_REALOFF(offset) ((offset << 1))
-
-#endif /* __EFS_DIR_H__ */
-
diff -puN include/linux/efs_fs.h~efs-move-headers-out-of-include-linux /dev/null
--- a/include/linux/efs_fs.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * efs_fs.h
- *
- * Copyright (c) 1999 Al Smith
- *
- * Portions derived from work (c) 1995,1996 Christian Vogelgsang.
- */
-
-#ifndef __EFS_FS_H__
-#define __EFS_FS_H__
-
-#define EFS_VERSION "1.0a"
-
-static const char cprt[] = "EFS: "EFS_VERSION" - (c) 1999 Al Smith <Al.Smith@aeschi.ch.eu.org>";
-
-#include <asm/uaccess.h>
-
-/* 1 block is 512 bytes */
-#define	EFS_BLOCKSIZE_BITS	9
-#define	EFS_BLOCKSIZE		(1 << EFS_BLOCKSIZE_BITS)
-
-#include <linux/fs.h>
-#include <linux/efs_fs_i.h>
-#include <linux/efs_fs_sb.h>
-#include <linux/efs_dir.h>
-
-static inline struct efs_inode_info *INODE_INFO(struct inode *inode)
-{
-	return container_of(inode, struct efs_inode_info, vfs_inode);
-}
-
-static inline struct efs_sb_info *SUPER_INFO(struct super_block *sb)
-{
-	return sb->s_fs_info;
-}
-
-struct statfs;
-struct fid;
-
-extern const struct inode_operations efs_dir_inode_operations;
-extern const struct file_operations efs_dir_operations;
-extern const struct address_space_operations efs_symlink_aops;
-
-extern struct inode *efs_iget(struct super_block *, unsigned long);
-extern efs_block_t efs_map_block(struct inode *, efs_block_t);
-extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
-
-extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct nameidata *);
-extern struct dentry *efs_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type);
-extern struct dentry *efs_fh_to_parent(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type);
-extern struct dentry *efs_get_parent(struct dentry *);
-extern int efs_bmap(struct inode *, int);
-
-#endif /* __EFS_FS_H__ */
diff -puN include/linux/efs_fs_i.h~efs-move-headers-out-of-include-linux /dev/null
--- a/include/linux/efs_fs_i.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * efs_fs_i.h
- *
- * Copyright (c) 1999 Al Smith
- *
- * Portions derived from IRIX header files (c) 1988 Silicon Graphics
- */
-
-#ifndef	__EFS_FS_I_H__
-#define	__EFS_FS_I_H__
-
-typedef	int32_t		efs_block_t;
-typedef uint32_t	efs_ino_t;
-
-#define	EFS_DIRECTEXTENTS	12
-
-/*
- * layout of an extent, in memory and on disk. 8 bytes exactly.
- */
-typedef union extent_u {
-	unsigned char raw[8];
-	struct extent_s {
-		unsigned int	ex_magic:8;	/* magic # (zero) */
-		unsigned int	ex_bn:24;	/* basic block */
-		unsigned int	ex_length:8;	/* numblocks in this extent */
-		unsigned int	ex_offset:24;	/* logical offset into file */
-	} cooked;
-} efs_extent;
-
-typedef struct edevs {
-	__be16		odev;
-	__be32		ndev;
-} efs_devs;
-
-/*
- * extent based filesystem inode as it appears on disk.  The efs inode
- * is exactly 128 bytes long.
- */
-struct	efs_dinode {
-	__be16		di_mode;	/* mode and type of file */
-	__be16		di_nlink;	/* number of links to file */
-	__be16		di_uid;		/* owner's user id */
-	__be16		di_gid;		/* owner's group id */
-	__be32		di_size;	/* number of bytes in file */
-	__be32		di_atime;	/* time last accessed */
-	__be32		di_mtime;	/* time last modified */
-	__be32		di_ctime;	/* time created */
-	__be32		di_gen;		/* generation number */
-	__be16		di_numextents;	/* # of extents */
-	u_char		di_version;	/* version of inode */
-	u_char		di_spare;	/* spare - used by AFS */
-	union di_addr {
-		efs_extent	di_extents[EFS_DIRECTEXTENTS];
-		efs_devs	di_dev;	/* device for IFCHR/IFBLK */
-	} di_u;
-};
-
-/* efs inode storage in memory */
-struct efs_inode_info {
-	int		numextents;
-	int		lastextent;
-
-	efs_extent	extents[EFS_DIRECTEXTENTS];
-	struct inode	vfs_inode;
-};
-
-#endif	/* __EFS_FS_I_H__ */
-
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
fix-up-kerneldoc-in-fs-ioctlc-a-little-bit.patch
git-unionfs.patch
git-xfs.patch
efs-move-headers-out-of-include-linux.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
mxser-convert-large-macros-to-functions.patch
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
