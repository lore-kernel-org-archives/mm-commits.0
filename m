From: akpm@linux-foundation.org
Subject: [merged] fs-squashfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:39 -0700
Message-ID: <200904061938.n36Jcdnv013462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbZDFUDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     fs/squashfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-squashfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/squashfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make squashfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/squashfs/super.c~fs-squashfs-return-f_fsid-for-statfs2 fs/squashfs/super.c
--- a/fs/squashfs/super.c~fs-squashfs-return-f_fsid-for-statfs2
+++ a/fs/squashfs/super.c
@@ -301,6 +301,7 @@ failure:
 static int squashfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct squashfs_sb_info *msblk = dentry->d_sb->s_fs_info;
+	u64 id = huge_encode_dev(dentry->d_sb->s_bdev->bd_dev);
 
 	TRACE("Entered squashfs_statfs\n");
 
@@ -311,6 +312,8 @@ static int squashfs_statfs(struct dentry
 	buf->f_files = msblk->inodes;
 	buf->f_ffree = 0;
 	buf->f_namelen = SQUASHFS_NAME_LEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	return 0;
 }
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

