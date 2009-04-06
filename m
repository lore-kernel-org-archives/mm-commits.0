From: akpm@linux-foundation.org
Subject: [merged] fs-cramfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:16 -0700
Message-ID: <200904061938.n36JcG78013319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbZDFURU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/cramfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-cramfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/cramfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make cramfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/cramfs/inode.c~fs-cramfs-return-f_fsid-for-statfs2 fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-return-f_fsid-for-statfs2
+++ a/fs/cramfs/inode.c
@@ -318,6 +318,7 @@ out:
 static int cramfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type = CRAMFS_MAGIC;
 	buf->f_bsize = PAGE_CACHE_SIZE;
@@ -326,6 +327,8 @@ static int cramfs_statfs(struct dentry *
 	buf->f_bavail = 0;
 	buf->f_files = CRAMFS_SB(sb)->files;
 	buf->f_ffree = 0;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = CRAMFS_MAXPATHLEN;
 	return 0;
 }
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

