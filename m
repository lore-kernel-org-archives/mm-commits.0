From: akpm@linux-foundation.org
Subject: + fs-reiserfs-return-f_fsid-for-statfs2.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:00:25 -0800
Message-ID: <200901270800.n0R80Ppf032664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbZA0IGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:06:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de


The patch titled
     fs/reiserfs: return f_fsid for statfs(2)
has been added to the -mm tree.  Its filename is
     fs-reiserfs-return-f_fsid-for-statfs2.patch

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
Subject: fs/reiserfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make reiserfs3 return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2 fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2
+++ a/fs/reiserfs/super.c
@@ -1881,7 +1881,9 @@ error:
 
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct reiserfs_super_block *rs = SB_DISK_SUPER_BLOCK(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_namelen = (REISERFS_MAX_NAME(s->s_blocksize));
 	buf->f_bfree = sb_free_blocks(rs);
@@ -1890,6 +1892,9 @@ static int reiserfs_statfs(struct dentry
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

