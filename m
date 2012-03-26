From: akpm@linux-foundation.org
Subject: [merged] magich-move-some-fs-magic-numbers-into-magich.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:11 -0700
Message-ID: <20120326192811.60F8BA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39289 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZT2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:13 -0400
Received: by wibhj13 with SMTP id hj13so233174wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muthu.lkml@gmail.com, muthur@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: magic.h: move some FS magic numbers into magic.h
has been removed from the -mm tree.  Its filename was
     magich-move-some-fs-magic-numbers-into-magich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: magic.h: move some FS magic numbers into magic.h

- Move open-coded filesystem magic numbers into magic.h

- Rearrange magic.h so that the filesystem-related constants are grouped
  together.

Signed-off-by: Muthukumar R <muthur@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c     |    2 +-
 fs/binfmt_misc.c          |    3 ++-
 fs/block_dev.c            |    3 ++-
 fs/pipe.c                 |    1 +
 include/linux/magic.h     |   18 ++++++++++++------
 include/linux/pipe_fs_i.h |    2 --
 6 files changed, 18 insertions(+), 11 deletions(-)

diff -puN drivers/mtd/mtdchar.c~magich-move-some-fs-magic-numbers-into-magich drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~magich-move-some-fs-magic-numbers-into-magich
+++ a/drivers/mtd/mtdchar.c
@@ -31,13 +31,13 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/blkpg.h>
+#include <linux/magic.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/map.h>
 
 #include <asm/uaccess.h>
 
-#define MTD_INODE_FS_MAGIC 0x11307854
 static DEFINE_MUTEX(mtd_mutex);
 static struct vfsmount *mtd_inode_mnt __read_mostly;
 
diff -puN fs/binfmt_misc.c~magich-move-some-fs-magic-numbers-into-magich fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~magich-move-some-fs-magic-numbers-into-magich
+++ a/fs/binfmt_misc.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/magic.h>
 #include <linux/binfmts.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
@@ -699,7 +700,7 @@ static int bm_fill_super(struct super_bl
 		[3] = {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
-	int err = simple_fill_super(sb, 0x42494e4d, bm_files);
+	int err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)
 		sb->s_op = &s_ops;
 	return err;
diff -puN fs/block_dev.c~magich-move-some-fs-magic-numbers-into-magich fs/block_dev.c
--- a/fs/block_dev.c~magich-move-some-fs-magic-numbers-into-magich
+++ a/fs/block_dev.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/blkpg.h>
+#include <linux/magic.h>
 #include <linux/buffer_head.h>
 #include <linux/swap.h>
 #include <linux/pagevec.h>
@@ -506,7 +507,7 @@ static const struct super_operations bde
 static struct dentry *bd_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, 0x62646576);
+	return mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, BDEVFS_MAGIC);
 }
 
 static struct file_system_type bd_type = {
diff -puN fs/pipe.c~magich-move-some-fs-magic-numbers-into-magich fs/pipe.c
--- a/fs/pipe.c~magich-move-some-fs-magic-numbers-into-magich
+++ a/fs/pipe.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/log2.h>
 #include <linux/mount.h>
+#include <linux/magic.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/uio.h>
 #include <linux/highmem.h>
diff -puN include/linux/magic.h~magich-move-some-fs-magic-numbers-into-magich include/linux/magic.h
--- a/include/linux/magic.h~magich-move-some-fs-magic-numbers-into-magich
+++ a/include/linux/magic.h
@@ -9,7 +9,6 @@
 #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
 #define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define DEBUGFS_MAGIC          0x64626720
-#define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
 #define RAMFS_MAGIC		0x858458f6	/* some random number */
@@ -27,7 +26,6 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
-#define ANON_INODE_FS_MAGIC	0x09041934
 #define PSTOREFS_MAGIC		0x6165676C
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
@@ -40,7 +38,6 @@
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
 #define NFS_SUPER_MAGIC		0x6969
 #define OPENPROM_SUPER_MAGIC	0x9fa1
-#define PROC_SUPER_MAGIC	0x9fa0
 #define QNX4_SUPER_MAGIC	0x002f		/* qnx4 fs detection */
 #define QNX6_SUPER_MAGIC	0x68191122	/* qnx6 fs detection */
 
@@ -52,15 +49,24 @@
 #define REISER2FS_JR_SUPER_MAGIC_STRING	"ReIsEr3Fs"
 
 #define SMB_SUPER_MAGIC		0x517B
-#define USBDEVICE_SUPER_MAGIC	0x9fa2
 #define CGROUP_SUPER_MAGIC	0x27e0eb
 
-#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
 
 #define STACK_END_MAGIC		0x57AC6E9D
 
+#define V9FS_MAGIC		0x01021997
+
+#define BDEVFS_MAGIC            0x62646576
+#define BINFMTFS_MAGIC          0x42494e4d
 #define DEVPTS_SUPER_MAGIC	0x1cd1
+#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
+#define PIPEFS_MAGIC            0x50495045
+#define PROC_SUPER_MAGIC	0x9fa0
 #define SOCKFS_MAGIC		0x534F434B
-#define V9FS_MAGIC		0x01021997
+#define SYSFS_MAGIC		0x62656572
+#define USBDEVICE_SUPER_MAGIC	0x9fa2
+#define MTD_INODE_FS_MAGIC      0x11307854
+#define ANON_INODE_FS_MAGIC	0x09041934
+
 
 #endif /* __LINUX_MAGIC_H__ */
diff -puN include/linux/pipe_fs_i.h~magich-move-some-fs-magic-numbers-into-magich include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~magich-move-some-fs-magic-numbers-into-magich
+++ a/include/linux/pipe_fs_i.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_PIPE_FS_I_H
 #define _LINUX_PIPE_FS_I_H
 
-#define PIPEFS_MAGIC 0x50495045
