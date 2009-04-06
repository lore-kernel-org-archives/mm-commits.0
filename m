From: akpm@linux-foundation.org
Subject: [merged] fs-affs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:12 -0700
Message-ID: <200904061938.n36JcCOg013263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461AbZDFTlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/affs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-affs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/affs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make affs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/affs/super.c~fs-affs-return-f_fsid-for-statfs2 fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-return-f_fsid-for-statfs2
+++ a/fs/affs/super.c
@@ -533,6 +533,7 @@ affs_statfs(struct dentry *dentry, struc
 {
 	struct super_block *sb = dentry->d_sb;
 	int		 free;
+	u64		 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	pr_debug("AFFS: statfs() partsize=%d, reserved=%d\n",AFFS_SB(sb)->s_partition_size,
 	     AFFS_SB(sb)->s_reserved);
@@ -543,6 +544,9 @@ affs_statfs(struct dentry *dentry, struc
 	buf->f_blocks  = AFFS_SB(sb)->s_partition_size - AFFS_SB(sb)->s_reserved;
 	buf->f_bfree   = free;
 	buf->f_bavail  = free;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+	buf->f_namelen = 30;
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

