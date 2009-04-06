From: akpm@linux-foundation.org
Subject: [merged] fs-sysv-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:41 -0700
Message-ID: <200904061938.n36JcftH013472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbZDFUAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs/sysv: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-sysv-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/sysv: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make sysv file system return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/sysv/inode.c~fs-sysv-return-f_fsid-for-statfs2 fs/sysv/inode.c
--- a/fs/sysv/inode.c~fs-sysv-return-f_fsid-for-statfs2
+++ a/fs/sysv/inode.c
@@ -90,6 +90,7 @@ static int sysv_statfs(struct dentry *de
 {
 	struct super_block *sb = dentry->d_sb;
 	struct sysv_sb_info *sbi = SYSV_SB(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type = sb->s_magic;
 	buf->f_bsize = sb->s_blocksize;
@@ -98,6 +99,8 @@ static int sysv_statfs(struct dentry *de
 	buf->f_files = sbi->s_ninodes;
 	buf->f_ffree = sysv_count_free_inodes(sb);
 	buf->f_namelen = SYSV_NAMELEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

