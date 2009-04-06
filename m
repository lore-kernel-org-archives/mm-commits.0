From: akpm@linux-foundation.org
Subject: [merged] fs-hpfs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:26 -0700
Message-ID: <200904061938.n36JcQZd013388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbZDFUCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org


The patch titled
     fs/hpfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-hpfs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/hpfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make hpfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hpfs/super.c~fs-hpfs-return-f_fsid-for-statfs2 fs/hpfs/super.c
--- a/fs/hpfs/super.c~fs-hpfs-return-f_fsid-for-statfs2
+++ a/fs/hpfs/super.c
@@ -136,6 +136,7 @@ static int hpfs_statfs(struct dentry *de
 {
 	struct super_block *s = dentry->d_sb;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
 	lock_kernel();
 
 	/*if (sbi->sb_n_free == -1) {*/
@@ -149,6 +150,8 @@ static int hpfs_statfs(struct dentry *de
 	buf->f_bavail = sbi->sb_n_free;
 	buf->f_files = sbi->sb_dirband_size / 4;
 	buf->f_ffree = sbi->sb_n_free_dnodes;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = 254;
 
 	unlock_kernel();
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

