From: akpm@linux-foundation.org
Subject: [merged] fat-switch-to-fsinfo_inode.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:28 -0700
Message-ID: <20120601193328.65C46A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57700 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2FATd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:29 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so248161yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: switch to fsinfo_inode
has been removed from the -mm tree.  Its filename was
     fat-switch-to-fsinfo_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fat: switch to fsinfo_inode

Currently FAT file-system maps the VFS "superblock" abstraction to the
FSINFO block.  The FSINFO block contains non-essential data about the
amount of free clusters and the next free cluster.  FAT file-system can
always find out this information by scanning the FAT table, but having it
in the FSINFO block may speed things up sometimes.  So FAT file-system
relies on the VFS superblock write-out services to make sure the FSINFO
block is written out to the media from time to time.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds
and writes out all dirty superblock using the '->write_super()' call-back.
 But the problem with this thread is that it wastes power by waking up the
system every 5 seconds no matter what.  So we want to kill it completely
and thus, we need to make file-systems to stop using the '->write_super'
VFS service, and then remove it together with the kernel thread.

This patch switches the FAT FSINFO block management from
'->write_super()'/'->s_dirt' to 'fsinfo_inode'/'->write_inode'.  Now,
instead of setting the 's_dirt' flag, we just mark the special
'fsinfo_inode' inode as dirty and let VFS invoke the '->write_inode'
call-back when needed, where we write-out the FSINFO block.

This patch also makes sure we do not mark the 'fsinfo_inode' inode as
dirty if we are not FAT32 (FAT16 and FAT12 do not have the FSINFO block)
or if we are in R/O mode.

As a bonus, we can also remove the '->sync_fs()' and '->write_super()' FAT
call-back function because they become unneeded.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    7 ++++++-
 fs/fat/inode.c  |   42 ++++++++++++------------------------------
 2 files changed, 18 insertions(+), 31 deletions(-)

diff -puN fs/fat/fatent.c~fat-switch-to-fsinfo_inode fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-switch-to-fsinfo_inode
+++ a/fs/fat/fatent.c
@@ -310,7 +310,12 @@ void fat_ent_access_init(struct super_bl
 
 static void mark_fsinfo_dirty(struct super_block *sb)
 {
-	sb->s_dirt = 1;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	if (sb->s_flags & MS_RDONLY || sbi->fat_bits != 32)
+		return;
+
+	__mark_inode_dirty(sbi->fsinfo_inode, I_DIRTY_SYNC);
 }
 
 static inline int fat_ent_update_ptr(struct super_block *sb,
diff -puN fs/fat/inode.c~fat-switch-to-fsinfo_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-switch-to-fsinfo_inode
+++ a/fs/fat/inode.c
@@ -459,37 +459,10 @@ static void fat_evict_inode(struct inode
 	fat_detach(inode);
 }
 
-static void fat_write_super(struct super_block *sb)
-{
-	lock_super(sb);
-	sb->s_dirt = 0;
-
-	if (!(sb->s_flags & MS_RDONLY))
-		fat_clusters_flush(sb);
-	unlock_super(sb);
-}
-
-static int fat_sync_fs(struct super_block *sb, int wait)
-{
-	int err = 0;
-
-	if (sb->s_dirt) {
-		lock_super(sb);
-		sb->s_dirt = 0;
-		err = fat_clusters_flush(sb);
-		unlock_super(sb);
-	}
-
-	return err;
-}
-
 static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	if (sb->s_dirt)
-		fat_write_super(sb);
-
 	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
@@ -662,7 +635,18 @@ retry:
 
 static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+	int err;
+
+	if (inode->i_ino == MSDOS_FSINFO_INO) {
+		struct super_block *sb = inode->i_sb;
+
+		lock_super(sb);
+		err = fat_clusters_flush(sb);
+		unlock_super(sb);
+	} else
+		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+
+	return err;
 }
 
 int fat_sync_inode(struct inode *inode)
@@ -679,8 +663,6 @@ static const struct super_operations fat
 	.write_inode	= fat_write_inode,
 	.evict_inode	= fat_evict_inode,
 	.put_super	= fat_put_super,
-	.write_super	= fat_write_super,
-	.sync_fs	= fat_sync_fs,
 	.statfs		= fat_statfs,
 	.remount_fs	= fat_remount,
 
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

origin.patch
linux-next.patch

