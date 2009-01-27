From: akpm@linux-foundation.org
Subject: + fs-fat-return-f_fsid-for-statfs2.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:00:11 -0800
Message-ID: <200901270800.n0R80B73032346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZA0IAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de, hirofumi@mail.parknet.co.jp


The patch titled
     fs/fat: return f_fsid for statfs(2)
has been added to the -mm tree.  Its filename is
     fs-fat-return-f_fsid-for-statfs2.patch

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
Subject: fs/fat: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make fat return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fs-fat-return-f_fsid-for-statfs2 fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-return-f_fsid-for-statfs2
+++ a/fs/fat/inode.c
@@ -523,7 +523,9 @@ static int fat_remount(struct super_bloc
 
 static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	/* If the count of free cluster is still unknown, counts it here. */
 	if (sbi->free_clusters == -1 || !sbi->free_clus_valid) {
@@ -537,6 +539,8 @@ static int fat_statfs(struct dentry *den
 	buf->f_blocks = sbi->max_cluster - FAT_START_ENT;
 	buf->f_bfree = sbi->free_clusters;
 	buf->f_bavail = sbi->free_clusters;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = sbi->options.isvfat ? 260 : 12;
 
 	return 0;
_

Patches currently in -mm which might be from coly.li@suse.de are

fs-adfs-return-f_fsid-for-statfs2.patch
fs-affs-return-f_fsid-for-statfs2.patch
fs-befs-return-f_fsid-for-statfs2.patch
fs-cramfs-return-f_fsid-for-statfs2.patch
fs-efs-return-f_fsid-for-statfs2.patch
fs-fat-return-f_fsid-for-statfs2.patch
fs-hfs-return-f_fsid-for-statfs2.patch
fs-hfsplus-return-f_fsid-for-statfs2.patch
fs-hpfs-return-f_fsid-for-statfs2.patch
fs-isofs-return-f_fsid-for-statfs2.patch
fs-jfs-return-f_fsid-for-statfs2.patch
fs-minix-return-f_fsid-for-statfs2.patch
fs-omfs-return-f_fsid-for-statfs2.patch
fs-qnx4-return-f_fsid-for-statfs2.patch
fs-reiserfs-return-f_fsid-for-statfs2.patch
fs-romfs-return-f_fsid-for-statfs2.patch
fs-squashfs-return-f_fsid-for-statfs2.patch
fs-sysv-return-f_fsid-for-statfs2.patch
fs-udf-return-f_fsid-for-statfs2.patch
fs-ufs-return-f_fsid-for-statfs2.patch

