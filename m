From: akpm@linux-foundation.org
Subject: + fs-hfs-return-f_fsid-for-statfs2.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:00:12 -0800
Message-ID: <200901270800.n0R80CuU032349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbZA0IBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:01:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coly.li@suse.de, zippel@linux-m68k.org


The patch titled
     fs/hfs: return f_fsid for statfs(2)
has been added to the -mm tree.  Its filename is
     fs-hfs-return-f_fsid-for-statfs2.patch

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
Subject: fs/hfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make hfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hfs/super.c~fs-hfs-return-f_fsid-for-statfs2 fs/hfs/super.c
--- a/fs/hfs/super.c~fs-hfs-return-f_fsid-for-statfs2
+++ a/fs/hfs/super.c
@@ -82,6 +82,7 @@ static void hfs_put_super(struct super_b
 static int hfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type = HFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -90,6 +91,8 @@ static int hfs_statfs(struct dentry *den
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = HFS_SB(sb)->fs_ablocks;
 	buf->f_ffree = HFS_SB(sb)->free_ablocks;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = HFS_NAMELEN;
 
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

