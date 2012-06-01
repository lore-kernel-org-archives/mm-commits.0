From: akpm@linux-foundation.org
Subject: [merged] fat-introduce-special-inode-for-managing-the-fsinfo-block.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:22 -0700
Message-ID: <20120601193322.7394AA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57700 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab2FATdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:23 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so248161yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: introduce special inode for managing the FSINFO block
has been removed from the -mm tree.  Its filename was
     fat-introduce-special-inode-for-managing-the-fsinfo-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fat: introduce special inode for managing the FSINFO block

This is patchset makes fatfs stop using the VFS '->write_super()' method
for writing out the FSINFO block.

The final goal is to get rid of the 'sync_supers()' kernel thread.  This
kernel thread wakes up every 5 seconds (by default) and calls
'->write_super()' for all mounted file-systems.  And the bad thing is that
this is done even if all the superblocks are clean.  Moreover, some
file-systems do not even need this end they do not register the
'->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes
power.  I am trying to make all file-systems independent of
'->write_super()' and plan to remove 'sync_supers()' and '->write_super'
completely once there are no more users.

The '->write_supers()' method is mostly used by baroque file-systems like
hfs, udf, etc.  Modern file-systems like btrfs and xfs do not use it. 
This justifies removing this stuff from VFS completely and make every FS
self-manage own superblock.

Tested with xfstests.


This patch:

Preparation for further changes.  It introduces a special inode
('fsinfo_inode') in FAT file-system which we'll later use for managing the
FSINFO block.  Note, this there is already one special inode ('fat_inode')
which is used for managing the FAT tables.

Introduce new 'MSDOS_FSINFO_INO' constant for this special inode.  It is
safe to do because FAT file-system does not store inode numbers on the
media but generates them run-time.

I've also cleaned up the comment to existing 'MSDOS_ROOT_INO' constant,
while on it.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h             |    1 +
 fs/fat/inode.c           |   12 ++++++++++++
 include/linux/msdos_fs.h |    3 ++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/fat/fat.h~fat-introduce-special-inode-for-managing-the-fsinfo-block fs/fat/fat.h
--- a/fs/fat/fat.h~fat-introduce-special-inode-for-managing-the-fsinfo-block
+++ a/fs/fat/fat.h
@@ -82,6 +82,7 @@ struct msdos_sb_info {
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
 	struct inode *fat_inode;
+	struct inode *fsinfo_inode;
 
 	struct ratelimit_state ratelimit;
 
diff -puN fs/fat/inode.c~fat-introduce-special-inode-for-managing-the-fsinfo-block fs/fat/inode.c
--- a/fs/fat/inode.c~fat-introduce-special-inode-for-managing-the-fsinfo-block
+++ a/fs/fat/inode.c
@@ -490,6 +490,7 @@ static void fat_put_super(struct super_b
 	if (sb->s_dirt)
 		fat_write_super(sb);
 
+	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
 	unload_nls(sbi->nls_disk);
@@ -1244,6 +1245,7 @@ int fat_fill_super(struct super_block *s
 		   void (*setup)(struct super_block *))
 {
 	struct inode *root_inode = NULL, *fat_inode = NULL;
+	struct inode *fsinfo_inode = NULL;
 	struct buffer_head *bh;
 	struct fat_boot_sector *b;
 	struct msdos_sb_info *sbi;
@@ -1490,6 +1492,14 @@ int fat_fill_super(struct super_block *s
 		goto out_fail;
 	MSDOS_I(fat_inode)->i_pos = 0;
 	sbi->fat_inode = fat_inode;
+
+	fsinfo_inode = new_inode(sb);
+	if (!fsinfo_inode)
+		goto out_fail;
+	fsinfo_inode->i_ino = MSDOS_FSINFO_INO;
+	sbi->fsinfo_inode = fsinfo_inode;
+	insert_inode_hash(fsinfo_inode);
+
 	root_inode = new_inode(sb);
 	if (!root_inode)
 		goto out_fail;
@@ -1516,6 +1526,8 @@ out_invalid:
 		fat_msg(sb, KERN_INFO, "Can't find a valid FAT filesystem");
 
 out_fail:
+	if (fsinfo_inode)
+		iput(fsinfo_inode);
 	if (fat_inode)
 		iput(fat_inode);
 	unload_nls(sbi->nls_io);
diff -puN include/linux/msdos_fs.h~fat-introduce-special-inode-for-managing-the-fsinfo-block include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat-introduce-special-inode-for-managing-the-fsinfo-block
+++ a/include/linux/msdos_fs.h
@@ -21,8 +21,9 @@
 #define CT_LE_W(v)	cpu_to_le16(v)
 #define CT_LE_L(v)	cpu_to_le32(v)
 
+#define MSDOS_ROOT_INO	 1	/* The root inode number */
+#define MSDOS_FSINFO_INO 2	/* Used for managing the FSINFO block */
 
-#define MSDOS_ROOT_INO	1	/* == MINIX_ROOT_INO */
 #define MSDOS_DIR_BITS	5	/* log2(sizeof(struct msdos_dir_entry)) */
 
 /* directory limit */
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

origin.patch
linux-next.patch
fat-introduce-mark_fsinfo_dirty-helper.patch
fat-mark-superblock-as-dirty-less-often.patch
fat-switch-to-fsinfo_inode.patch

