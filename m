From: akpm@linux-foundation.org
Subject: [merged] fs-jfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:13 -0800
Message-ID: <200902021937.n12JbDD2013930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZBBTrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:47:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs/jfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-jfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/jfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make jfs return f_fsid info for statfs(2).  By Andreas' suggestion, this
patch populates a persistent f_fsid between boots/mounts with help of
on-disk uuid record.

Signed-off-by: Coly Li <coly.li@suse.de>
Acked-by: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/jfs/super.c~fs-jfs-return-f_fsid-for-statfs2 fs/jfs/super.c
--- a/fs/jfs/super.c~fs-jfs-return-f_fsid-for-statfs2
+++ a/fs/jfs/super.c
@@ -143,8 +143,10 @@ static void jfs_destroy_inode(struct ino
 
 static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct jfs_sb_info *sbi = JFS_SBI(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	s64 maxinodes;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 	struct inomap *imap = JFS_IP(sbi->ipimap)->i_imap;
 
 	jfs_info("In jfs_statfs");
@@ -168,6 +170,8 @@ static int jfs_statfs(struct dentry *den
 	buf->f_files = maxinodes;
 	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
 				    atomic_read(&imap->im_numfree));
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	buf->f_namelen = JFS_NAME_MAX;
 	return 0;
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

