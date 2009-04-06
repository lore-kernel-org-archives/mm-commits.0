From: akpm@linux-foundation.org
Subject: [merged] fs-hfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:22 -0700
Message-ID: <200904061938.n36JcMWl013332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249AbZDFTlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/hfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-hfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

