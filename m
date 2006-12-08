From: akpm@osdl.org
Subject: - ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:56 -0800
Message-ID: <200612082001.kB8K1unq001923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426219AbWLHUB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     ntfs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ntfs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the ntfs
filesystem code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ntfs/dir.c  |    6 +++---
 fs/ntfs/file.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ntfs/dir.c~ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ntfs/dir.c
--- a/fs/ntfs/dir.c~ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ntfs/dir.c
@@ -1101,7 +1101,7 @@ static int ntfs_readdir(struct file *fil
 {
 	s64 ia_pos, ia_start, prev_ia_pos, bmp_pos;
 	loff_t fpos, i_size;
-	struct inode *bmp_vi, *vdir = filp->f_dentry->d_inode;
+	struct inode *bmp_vi, *vdir = filp->f_path.dentry->d_inode;
 	struct super_block *sb = vdir->i_sb;
 	ntfs_inode *ndir = NTFS_I(vdir);
 	ntfs_volume *vol = NTFS_SB(sb);
@@ -1136,9 +1136,9 @@ static int ntfs_readdir(struct file *fil
 	if (fpos == 1) {
 		ntfs_debug("Calling filldir for .. with len 2, fpos 0x1, "
 				"inode 0x%lx, DT_DIR.",
-				(unsigned long)parent_ino(filp->f_dentry));
+				(unsigned long)parent_ino(filp->f_path.dentry));
 		rc = filldir(dirent, "..", 2, fpos,
-				parent_ino(filp->f_dentry), DT_DIR);
+				parent_ino(filp->f_path.dentry), DT_DIR);
 		if (rc)
 			goto done;
 		fpos++;
diff -puN fs/ntfs/file.c~ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ntfs/file.c
--- a/fs/ntfs/file.c~ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ntfs/file.c
@@ -2162,7 +2162,7 @@ static ssize_t ntfs_file_aio_write_noloc
 		goto out;
 	if (!count)
 		goto out;
-	err = remove_suid(file->f_dentry);
+	err = remove_suid(file->f_path.dentry);
 	if (err)
 		goto out;
 	file_update_time(file);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

