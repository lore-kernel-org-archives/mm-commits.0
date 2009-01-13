From: akpm@linux-foundation.org
Subject: + ufs-dont-truncate-longer-ufs2-fast-symlinks.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:13:49 -0800
Message-ID: <200901130813.n0D8DnWB011031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758858AbZAMIOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: duaneg@dghda.com


The patch titled
     ufs: don't truncate longer ufs2 fast symlinks
has been added to the -mm tree.  Its filename is
     ufs-dont-truncate-longer-ufs2-fast-symlinks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: don't truncate longer ufs2 fast symlinks
From: Duane Griffin <duaneg@dghda.com>

ufs2 fast symlinks can be twice as long as ufs ones, however the code was
using the ufs size in various places.  Fix that so ufs2 symlinks over 60
characters aren't truncated.

Note that we copy the entire area instead of using the maxsymlinklen field
from the superblock.  This way we will be more robust against corruption
(of the superblock).

While we are at it, use memcpy instead of open-coding it with for loops.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   37 ++++++++++++++++---------------------
 fs/ufs/ufs.h   |    2 +-
 2 files changed, 17 insertions(+), 22 deletions(-)

diff -puN fs/ufs/inode.c~ufs-dont-truncate-longer-ufs2-fast-symlinks fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-dont-truncate-longer-ufs2-fast-symlinks
+++ a/fs/ufs/inode.c
@@ -614,7 +614,6 @@ static int ufs1_read_inode(struct inode 
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	mode_t mode;
-	unsigned i;
 
 	/*
 	 * Copy data to the in-core inode.
@@ -647,11 +646,11 @@ static int ufs1_read_inode(struct inode 
 
 	
 	if (S_ISCHR(mode) || S_ISBLK(mode) || inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufsi->i_u1.i_data[i] = ufs_inode->ui_u2.ui_addr.ui_db[i];
+		memcpy(ufsi->i_u1.i_data, &ufs_inode->ui_u2.ui_addr,
+		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufsi->i_u1.i_symlink[i] = ufs_inode->ui_u2.ui_symlink[i];
+		memcpy(ufsi->i_u1.i_symlink, ufs_inode->ui_u2.ui_symlink,
+		       sizeof(ufs_inode->ui_u2.ui_symlink));
 	}
 	return 0;
 }
@@ -661,7 +660,6 @@ static int ufs2_read_inode(struct inode 
 	struct ufs_inode_info *ufsi = UFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	mode_t mode;
-	unsigned i;
 
 	UFSD("Reading ufs2 inode, ino %lu\n", inode->i_ino);
 	/*
@@ -696,12 +694,11 @@ static int ufs2_read_inode(struct inode 
 	*/
 
 	if (S_ISCHR(mode) || S_ISBLK(mode) || inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufsi->i_u1.u2_i_data[i] =
-				ufs2_inode->ui_u2.ui_addr.ui_db[i];
+		memcpy(ufsi->i_u1.u2_i_data, &ufs2_inode->ui_u2.ui_addr,
+		       sizeof(ufs2_inode->ui_u2.ui_addr));
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
+		memcpy(ufsi->i_u1.i_symlink, ufs2_inode->ui_u2.ui_symlink,
+		       sizeof(ufs2_inode->ui_u2.ui_symlink));
 	}
 	return 0;
 }
@@ -773,7 +770,6 @@ static void ufs1_update_inode(struct ino
 {
 	struct super_block *sb = inode->i_sb;
  	struct ufs_inode_info *ufsi = UFS_I(inode);
- 	unsigned i;
 
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
 	ufs_inode->ui_nlink = cpu_to_fs16(sb, inode->i_nlink);
@@ -801,12 +797,12 @@ static void ufs1_update_inode(struct ino
 		/* ufs_inode->ui_u2.ui_addr.ui_db[0] = cpu_to_fs32(sb, inode->i_rdev); */
 		ufs_inode->ui_u2.ui_addr.ui_db[0] = ufsi->i_u1.i_data[0];
 	} else if (inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.i_data[i];
+		memcpy(&ufs_inode->ui_u2.ui_addr, ufsi->i_u1.i_data,
+		       sizeof(ufs_inode->ui_u2.ui_addr));
 	}
 	else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
+		memcpy(&ufs_inode->ui_u2.ui_symlink, ufsi->i_u1.i_symlink,
+		       sizeof(ufs_inode->ui_u2.ui_symlink));
 	}
 
 	if (!inode->i_nlink)
@@ -817,7 +813,6 @@ static void ufs2_update_inode(struct ino
 {
 	struct super_block *sb = inode->i_sb;
  	struct ufs_inode_info *ufsi = UFS_I(inode);
- 	unsigned i;
 
 	UFSD("ENTER\n");
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
@@ -842,11 +837,11 @@ static void ufs2_update_inode(struct ino
 		/* ufs_inode->ui_u2.ui_addr.ui_db[0] = cpu_to_fs32(sb, inode->i_rdev); */
 		ufs_inode->ui_u2.ui_addr.ui_db[0] = ufsi->i_u1.u2_i_data[0];
 	} else if (inode->i_blocks) {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
-			ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.u2_i_data[i];
+		memcpy(&ufs_inode->ui_u2.ui_addr, ufsi->i_u1.u2_i_data,
+		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
-			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
+		memcpy(&ufs_inode->ui_u2.ui_symlink, ufsi->i_u1.i_symlink,
+		       sizeof(ufs_inode->ui_u2.ui_symlink));
  	}
 
 	if (!inode->i_nlink)
diff -puN fs/ufs/ufs.h~ufs-dont-truncate-longer-ufs2-fast-symlinks fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~ufs-dont-truncate-longer-ufs2-fast-symlinks
+++ a/fs/ufs/ufs.h
@@ -23,7 +23,7 @@ struct ufs_sb_info {
 struct ufs_inode_info {
 	union {
 		__fs32	i_data[15];
-		__u8	i_symlink[4*15];
+		__u8	i_symlink[2 * 4 * 15];
 		__fs64	u2_i_data[15];
 	} i_u1;
 	__u32	i_flags;
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
ufs-validate-maximum-fast-symlink-size-from-superblock.patch
ufs-dont-truncate-longer-ufs2-fast-symlinks.patch
ufs-ensure-fast-symlinks-are-nul-terminated.patch
ufs-copy-symlink-data-into-the-correct-union-member.patch

