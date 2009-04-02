From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-reiserfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Thu, 02 Apr 2009 11:27:55 -0700
Message-ID: <200904021827.n32IRtJ2024209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbZDBS3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 14:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/reiserfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-return-f_fsid-for-statfs2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/reiserfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

This patch makes reiserfs3 return f_fsid info for statfs(2).  By Andreas'
suggestion, this patch populates a persistent f_fsid between boots/mounts
with help of on-disk uuid record.

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2 fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2
+++ a/fs/reiserfs/super.c
@@ -1883,7 +1883,9 @@ error:
 
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_namelen = (REISERFS_MAX_NAME(s->s_blocksize));
 	buf->f_bfree = sb_free_blocks(rs);
@@ -1892,6 +1894,9 @@ static int reiserfs_statfs(struct dentry
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	/* changed to accommodate gcc folks. */
 	buf->f_type = REISERFS_SUPER_MAGIC;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
linux-next.patch
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
fs-minix-return-f_fsid-for-statfs2.patch
fs-omfs-return-f_fsid-for-statfs2.patch
fs-qnx4-return-f_fsid-for-statfs2.patch
fs-reiserfs-return-f_fsid-for-statfs2-v3.patch
fs-reiserfs-return-f_fsid-for-statfs2.patch
fs-romfs-return-f_fsid-for-statfs2.patch
fs-squashfs-return-f_fsid-for-statfs2.patch
fs-sysv-return-f_fsid-for-statfs2.patch
fs-ufs-return-f_fsid-for-statfs2.patch

