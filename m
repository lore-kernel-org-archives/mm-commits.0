From: akpm@linux-foundation.org
Subject: [merged] fs-romfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:47 -0700
Message-ID: <200904071907.n37J7lLV011478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623AbZDGTJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/romfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-romfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/romfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make romfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/romfs/super.c~fs-romfs-return-f_fsid-for-statfs2 fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-return-f_fsid-for-statfs2
+++ a/fs/romfs/super.c
@@ -408,12 +408,17 @@ static void romfs_destroy_inode(struct i
  */
 static int romfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
+	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
+
 	buf->f_type = ROMFS_MAGIC;
 	buf->f_namelen = ROMFS_MAXFN;
 	buf->f_bsize = ROMBSIZE;
 	buf->f_bfree = buf->f_bavail = buf->f_ffree;
 	buf->f_blocks =
 		(romfs_maxsize(dentry->d_sb) + ROMBSIZE - 1) >> ROMBSBITS;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch

