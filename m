From: akpm@linux-foundation.org
Subject: [merged] fs-minix-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:30 -0700
Message-ID: <200904061938.n36JcUsa013398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbZDFTqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/minix: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-minix-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/minix: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make minix file system return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/minix/inode.c~fs-minix-return-f_fsid-for-statfs2 fs/minix/inode.c
--- a/fs/minix/inode.c~fs-minix-return-f_fsid-for-statfs2
+++ a/fs/minix/inode.c
@@ -321,15 +321,20 @@ out:
 
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct minix_sb_info *sbi = minix_sb(dentry->d_sb);
-	buf->f_type = dentry->d_sb->s_magic;
-	buf->f_bsize = dentry->d_sb->s_blocksize;
+	struct super_block *sb = dentry->d_sb;
+	struct minix_sb_info *sbi = minix_sb(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+	buf->f_type = sb->s_magic;
+	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = (sbi->s_nzones - sbi->s_firstdatazone) << sbi->s_log_zone_size;
 	buf->f_bfree = minix_count_free_blocks(sbi);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = sbi->s_ninodes;
 	buf->f_ffree = minix_count_free_inodes(sbi);
 	buf->f_namelen = sbi->s_namelen;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

