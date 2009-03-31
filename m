From: akpm@linux-foundation.org
Subject: [failures] fs-reiserfs-return-f_fsid-for-statfs2-v2.patch removed from -mm tree
Date: Tue, 31 Mar 2009 16:45:50 -0700
Message-ID: <200903312345.n2VNjoNc013322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbZCaXrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/reiserfs: return f_fsid for statfs(2), v2
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-return-f_fsid-for-statfs2-v2.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/reiserfs: return f_fsid for statfs(2), v2
From: Coly Li <coly.li@suse.de>

This patch makes reiserfs3 return f_fsid info for statfs(2).  By Andreas'
suggestion, this patch populates a persistent f_fsid between boots/mounts
with help of on-disk uuid record.

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2-v2 fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2-v2
+++ a/fs/reiserfs/super.c
@@ -27,6 +27,7 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/crc32.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -1883,9 +1884,7 @@ error:
 
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct super_block *sb = dentry->d_sb;
-	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(sb);
-	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(dentry->d_sb);
 
 	buf->f_namelen = (REISERFS_MAX_NAME(s->s_blocksize));
 	buf->f_bfree = sb_free_blocks(rs);
@@ -1894,8 +1893,9 @@ static int reiserfs_statfs(struct dentry
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	/* changed to accommodate gcc folks. */
 	buf->f_type = REISERFS_SUPER_MAGIC;
-	buf->f_fsid.val[0] = (u32)id;
-	buf->f_fsid.val[1] = (u32)(id >> 32);
+	buf->f_fsid.val[0] = (u32)crc32_le(0, rs->s_uuid, sizeof(rs->s_uuid)/2);
+	buf->f_fsid.val[1] = (u32)crc32_le(0, rs->s_uuid + sizeof(rs->s_uuid)/2,
+				sizeof(rs->s_uuid)/2);
 
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
fs-reiserfs-return-f_fsid-for-statfs2.patch
fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
fs-romfs-return-f_fsid-for-statfs2.patch
fs-squashfs-return-f_fsid-for-statfs2.patch
fs-sysv-return-f_fsid-for-statfs2.patch
fs-ufs-return-f_fsid-for-statfs2.patch

