From: akpm@linux-foundation.org
Subject: [merged] fs-isofs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:28 -0700
Message-ID: <200904061938.n36JcSet013393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZDFUAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     fs/isofs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-isofs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/isofs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make isofs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/isofs/inode.c~fs-isofs-return-f_fsid-for-statfs2 fs/isofs/inode.c
--- a/fs/isofs/inode.c~fs-isofs-return-f_fsid-for-statfs2
+++ a/fs/isofs/inode.c
@@ -923,6 +923,7 @@ out_freesbi:
 static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type = ISOFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -932,6 +933,8 @@ static int isofs_statfs (struct dentry *
 	buf->f_bavail = 0;
 	buf->f_files = ISOFS_SB(sb)->s_ninodes;
 	buf->f_ffree = 0;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = NAME_MAX;
 	return 0;
 }
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

