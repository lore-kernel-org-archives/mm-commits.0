From: akpm@linux-foundation.org
Subject: [merged] fs-udf-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:17 -0800
Message-ID: <200902021937.n12JbH7d013944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZBBTqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fs/udf: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-udf-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/udf: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make udf return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/udf/super.c~fs-udf-return-f_fsid-for-statfs2 fs/udf/super.c
--- a/fs/udf/super.c~fs-udf-return-f_fsid-for-statfs2
+++ a/fs/udf/super.c
@@ -2127,6 +2127,7 @@ static int udf_statfs(struct dentry *den
 	struct super_block *sb = dentry->d_sb;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDescImpUse *lvidiu;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	if (sbi->s_lvid_bh != NULL)
 		lvidiu = udf_sb_lvidiu(sbi);
@@ -2142,8 +2143,9 @@ static int udf_statfs(struct dentry *den
 					  le32_to_cpu(lvidiu->numDirs)) : 0)
 			+ buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
-	/* __kernel_fsid_t f_fsid */
 	buf->f_namelen = UDF_NAME_LEN - 2;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	return 0;
 }
_

Patches currently in -mm which might be from coly.li@suse.de are

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

