From: akpm@linux-foundation.org
Subject: [merged] fs-fat-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:20 -0700
Message-ID: <200904061938.n36JcKIe013329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbZDFTky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fs/fat: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-fat-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

