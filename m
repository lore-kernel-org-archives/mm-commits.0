From: akpm@linux-foundation.org
Subject: [merged] fat-exportfs-move-nfs-support-code.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:13 -0700
Message-ID: <20121005201814.350725C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:46482 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:16 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57952wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat (exportfs): move NFS support code
has been removed from the -mm tree.  Its filename was
     fat-exportfs-move-nfs-support-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: fat (exportfs): move NFS support code

Under memory pressure, the system may evict dentries from cache.  When the
FAT driver receives a NFS request involving an evicted dentry, it is
unable to reconnect it to the filesystem root.  This causes the request to
fail, often with ENOENT.

This is partially due to ineffectiveness of the current FAT NFS
implementation, and partially due to an unimplemented fh_to_parent method.
 The latter can cause file accesses to fail on shares exported with
subtree_check.

This patch set provides the FAT driver with the ability to
reconnect dentries.  NFS file handle generation and lookups are simplified
and made congruent with ext2.

Testing has involved a memory-starved virtual machine running 3.5-rc5 that
exports a ~2 GB vfat filesystem containing a kernel tree (~770 MB, ~40000
files, 9 levels).  Both 'cp -r' and 'ls -lR' operations were performed
from a client, some overlapping, some consecutive.  Exports with
'subtree_check' and 'no_subtree_check' have been tested.

Note that while this patch set improves FAT's NFS support, it does not
eliminate ESTALE errors completely.

The following should be considered for NFS clients who are sensitive to ESTALE:

* Mounting with lookupcache=none
  Unfortunately this can degrade performance severely, particularly for deep
  filesystems.

* Incorporating VFS patches to retry ESTALE failures on the client-side, 
  such as https://lkml.org/lkml/2012/6/29/381

* Handling ESTALE errors in client application code



This patch:

Move NFS-related code into its own C file.  No functional changes.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/Makefile |    2 
 fs/fat/fat.h    |   22 ++++++
 fs/fat/inode.c  |  130 ---------------------------------------
 fs/fat/nfs.c    |  151 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 174 insertions(+), 131 deletions(-)

diff -puN fs/fat/Makefile~fat-exportfs-move-nfs-support-code fs/fat/Makefile
--- a/fs/fat/Makefile~fat-exportfs-move-nfs-support-code
+++ a/fs/fat/Makefile
@@ -6,6 +6,6 @@ obj-$(CONFIG_FAT_FS) += fat.o
 obj-$(CONFIG_VFAT_FS) += vfat.o
 obj-$(CONFIG_MSDOS_FS) += msdos.o
 
-fat-y := cache.o dir.o fatent.o file.o inode.o misc.o
+fat-y := cache.o dir.o fatent.o file.o inode.o misc.o nfs.o
 vfat-y := namei_vfat.o
 msdos-y := namei_msdos.o
diff -puN fs/fat/fat.h~fat-exportfs-move-nfs-support-code fs/fat/fat.h
--- a/fs/fat/fat.h~fat-exportfs-move-nfs-support-code
+++ a/fs/fat/fat.h
@@ -341,6 +341,20 @@ extern int fat_fill_super(struct super_b
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+				    struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 /* fat/misc.c */
 extern __printf(3, 4) __cold
 void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
@@ -366,6 +380,14 @@ extern int fat_sync_bhs(struct buffer_he
 int fat_cache_init(void);
 void fat_cache_destroy(void);
 
+/* fat/nfs.c */
+struct fid;
+extern int fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
+			 struct inode *parent);
+extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type);
+extern struct dentry *fat_get_parent(struct dentry *child_dir);
+
 /* helper for printk */
 typedef unsigned long long	llu;
 
diff -puN fs/fat/inode.c~fat-exportfs-move-nfs-support-code fs/fat/inode.c
--- a/fs/fat/inode.c~fat-exportfs-move-nfs-support-code
+++ a/fs/fat/inode.c
@@ -562,20 +562,6 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
-				    struct inode *inode)
-{
-	loff_t i_pos;
-#if BITS_PER_LONG == 32
-	spin_lock(&sbi->inode_hash_lock);
-#endif
-	i_pos = MSDOS_I(inode)->i_pos;
-#if BITS_PER_LONG == 32
-	spin_unlock(&sbi->inode_hash_lock);
-#endif
-	return i_pos;
-}
-
 static int __fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
@@ -668,122 +654,6 @@ static const struct super_operations fat
 	.show_options	= fat_show_options,
 };
 
-/*
- * a FAT file handle with fhtype 3 is
- *  0/  i_ino - for fast, reliable lookup if still in the cache
- *  1/  i_generation - to see if i_ino is still valid
- *          bit 0 == 0 iff directory
- *  2/  i_pos(8-39) - if ino has changed, but still in cache
- *  3/  i_pos(4-7)|i_logstart - to semi-verify inode found at i_pos
- *  4/  i_pos(0-3)|parent->i_logstart - maybe used to hunt for the file on disc
- *
- * Hack for NFSv2: Maximum FAT entry number is 28bits and maximum
- * i_pos is 40bits (blocknr(32) + dir offset(8)), so two 4bits
- * of i_logstart is used to store the directory entry offset.
- */
-
-static struct dentry *fat_fh_to_dentry(struct super_block *sb,
-		struct fid *fid, int fh_len, int fh_type)
-{
-	struct inode *inode = NULL;
-	u32 *fh = fid->raw;
-
-	if (fh_len < 5 || fh_type != 3)
-		return NULL;
-
-	inode = ilookup(sb, fh[0]);
-	if (!inode || inode->i_generation != fh[1]) {
-		if (inode)
-			iput(inode);
-		inode = NULL;
-	}
-	if (!inode) {
-		loff_t i_pos;
-		int i_logstart = fh[3] & 0x0fffffff;
-
-		i_pos = (loff_t)fh[2] << 8;
-		i_pos |= ((fh[3] >> 24) & 0xf0) | (fh[4] >> 28);
-
-		/* try 2 - see if i_pos is in F-d-c
-		 * require i_logstart to be the same
-		 * Will fail if you truncate and then re-write
-		 */
-
-		inode = fat_iget(sb, i_pos);
-		if (inode && MSDOS_I(inode)->i_logstart != i_logstart) {
-			iput(inode);
-			inode = NULL;
-		}
-	}
-
-	/*
-	 * For now, do nothing if the inode is not found.
-	 *
-	 * What we could do is:
-	 *
-	 *	- follow the file starting at fh[4], and record the ".." entry,
-	 *	  and the name of the fh[2] entry.
-	 *	- then follow the ".." file finding the next step up.
-	 *
-	 * This way we build a path to the root of the tree. If this works, we
-	 * lookup the path and so get this inode into the cache.  Finally try
-	 * the fat_iget lookup again.  If that fails, then we are totally out
-	 * of luck.  But all that is for another day
-	 */
-	return d_obtain_alias(inode);
-}
-
-static int
-fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
-{
-	int len = *lenp;
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
-	loff_t i_pos;
-
-	if (len < 5) {
-		*lenp = 5;
-		return 255; /* no room */
-	}
-
-	i_pos = fat_i_pos_read(sbi, inode);
-	*lenp = 5;
-	fh[0] = inode->i_ino;
-	fh[1] = inode->i_generation;
-	fh[2] = i_pos >> 8;
-	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
-	fh[4] = (i_pos & 0x0f) << 28;
-	if (parent)
-		fh[4] |= MSDOS_I(parent)->i_logstart;
-	return 3;
-}
-
-static struct dentry *fat_get_parent(struct dentry *child)
-{
-	struct super_block *sb = child->d_sb;
-	struct buffer_head *bh;
-	struct msdos_dir_entry *de;
-	loff_t i_pos;
-	struct dentry *parent;
-	struct inode *inode;
-	int err;
-
-	lock_super(sb);
-
-	err = fat_get_dotdot_entry(child->d_inode, &bh, &de, &i_pos);
-	if (err) {
-		parent = ERR_PTR(err);
-		goto out;
-	}
-	inode = fat_build_inode(sb, de, i_pos);
-	brelse(bh);
-
-	parent = d_obtain_alias(inode);
-out:
-	unlock_super(sb);
-
-	return parent;
-}
-
 static const struct export_operations fat_export_ops = {
 	.encode_fh	= fat_encode_fh,
 	.fh_to_dentry	= fat_fh_to_dentry,
diff -puN /dev/null fs/fat/nfs.c
--- /dev/null
+++ a/fs/fat/nfs.c
@@ -0,0 +1,151 @@
+/* fs/fat/nfs.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/exportfs.h>
+#include "fat.h"
+
+/*
+ * a FAT file handle with fhtype 3 is
+ *  0/  i_ino - for fast, reliable lookup if still in the cache
+ *  1/  i_generation - to see if i_ino is still valid
+ *          bit 0 == 0 iff directory
+ *  2/  i_pos(8-39) - if ino has changed, but still in cache
+ *  3/  i_pos(4-7)|i_logstart - to semi-verify inode found at i_pos
+ *  4/  i_pos(0-3)|parent->i_logstart - maybe used to hunt for the file on disc
+ *
+ * Hack for NFSv2: Maximum FAT entry number is 28bits and maximum
+ * i_pos is 40bits (blocknr(32) + dir offset(8)), so two 4bits
+ * of i_logstart is used to store the directory entry offset.
+ */
+
+int
+fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+{
+	int len = *lenp;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	loff_t i_pos;
+
+	if (len < 5) {
+		*lenp = 5;
+		return 255; /* no room */
+	}
+
+	i_pos = fat_i_pos_read(sbi, inode);
+	*lenp = 5;
+	fh[0] = inode->i_ino;
+	fh[1] = inode->i_generation;
+	fh[2] = i_pos >> 8;
+	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
+	fh[4] = (i_pos & 0x0f) << 28;
+	if (parent)
+		fh[4] |= MSDOS_I(parent)->i_logstart;
+	return 3;
+}
+
+static int fat_is_valid_fh(int fh_len, int fh_type)
+{
+	return ((fh_len >= 5) && (fh_type == 3));
+}
+
+/**
+ * Map a NFS file handle to a corresponding dentry.
+ * The dentry may or may not be connected to the filesystem root.
+ */
+struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				int fh_len, int fh_type)
+{
+	struct inode *inode = NULL;
+	u32 *fh = fid->raw;
+	loff_t i_pos;
+	unsigned long i_ino;
+	__u32 i_generation;
+	int i_logstart;
+
+	if (!fat_is_valid_fh(fh_len, fh_type))
+		return NULL;
+
+	i_ino = fh[0];
+	i_generation = fh[1];
+	i_logstart = fh[3] & 0x0fffffff;
+
+	/* Try i_ino lookup first - fastest and most reliable */
+	inode = ilookup(sb, i_ino);
+	if (inode && (inode->i_generation != i_generation)) {
+		iput(inode);
+		inode = NULL;
+	}
+	if (!inode) {
+		i_pos = (loff_t)fh[2] << 8;
+		i_pos |= ((fh[3] >> 24) & 0xf0) | (fh[4] >> 28);
+
+		/* try 2 - see if i_pos is in F-d-c
+		 * require i_logstart to be the same
+		 * Will fail if you truncate and then re-write
+		 */
+
+		inode = fat_iget(sb, i_pos);
+		if (inode && MSDOS_I(inode)->i_logstart != i_logstart) {
+			iput(inode);
+			inode = NULL;
+		}
+	}
+
+	/*
+	 * For now, do nothing if the inode is not found.
+	 *
+	 * What we could do is:
+	 *
+	 *	- follow the file starting at fh[4], and record the ".." entry,
+	 *	  and the name of the fh[2] entry.
+	 *	- then follow the ".." file finding the next step up.
+	 *
+	 * This way we build a path to the root of the tree. If this works, we
+	 * lookup the path and so get this inode into the cache.  Finally try
+	 * the fat_iget lookup again.  If that fails, then we are totally out
+	 * of luck.  But all that is for another day
+	 */
+	return d_obtain_alias(inode);
+}
+
+/*
+ * Find the parent for a directory that is not currently connected to
+ * the filesystem root.
+ *
+ * On entry, the caller holds child_dir->d_inode->i_mutex.
+ */
+struct dentry *fat_get_parent(struct dentry *child_dir)
+{
+	struct super_block *sb = child_dir->d_sb;
+	struct buffer_head *bh = NULL;
+	struct msdos_dir_entry *de;
+	loff_t i_pos;
+	struct dentry *parent;
+	struct inode *inode;
+	int err;
+
+	lock_super(sb);
+
+	err = fat_get_dotdot_entry(child_dir->d_inode, &bh, &de, &i_pos);
+	if (err) {
+		parent = ERR_PTR(err);
+		goto out;
+	}
+	inode = fat_build_inode(sb, de, i_pos);
+
+	parent = d_obtain_alias(inode);
+out:
+	brelse(bh);
+	unlock_super(sb);
+
+	return parent;
+}
_

Patches currently in -mm which might be from steve@digidescorp.com are

origin.patch

