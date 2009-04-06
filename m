From: akpm@linux-foundation.org
Subject: [merged] fs-qnx4-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:34 -0700
Message-ID: <200904061938.n36JcYen013404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZDFUB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, al@alarsen.net, mm-commits@vger.kernel.org


The patch titled
     fs/qnx4: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-qnx4-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/qnx4: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make qnx4 file system return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/qnx4/inode.c~fs-qnx4-return-f_fsid-for-statfs2 fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~fs-qnx4-return-f_fsid-for-statfs2
+++ a/fs/qnx4/inode.c
@@ -282,6 +282,7 @@ unsigned long qnx4_block_map( struct ino
 static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	lock_kernel();
 
@@ -291,6 +292,8 @@ static int qnx4_statfs(struct dentry *de
 	buf->f_bfree   = qnx4_count_free_blocks(sb);
 	buf->f_bavail  = buf->f_bfree;
 	buf->f_namelen = QNX4_NAME_MAX;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	unlock_kernel();
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

