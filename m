From: akpm@linux-foundation.org
Subject: [merged] fs-omfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:32 -0700
Message-ID: <200904061938.n36JcWQm013401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbZDFTle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     fs/omfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-omfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/omfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make omfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/omfs/inode.c~fs-omfs-return-f_fsid-for-statfs2 fs/omfs/inode.c
--- a/fs/omfs/inode.c~fs-omfs-return-f_fsid-for-statfs2
+++ a/fs/omfs/inode.c
@@ -262,14 +262,19 @@ static int omfs_statfs(struct dentry *de
 {
 	struct super_block *s = dentry->d_sb;
 	struct omfs_sb_info *sbi = OMFS_SB(s);
+	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
+
 	buf->f_type = OMFS_MAGIC;
 	buf->f_bsize = sbi->s_blocksize;
 	buf->f_blocks = sbi->s_num_blocks;
 	buf->f_files = sbi->s_num_blocks;
 	buf->f_namelen = OMFS_NAMELEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	buf->f_bfree = buf->f_bavail = buf->f_ffree =
 		omfs_count_free(s);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

