From: akpm@linux-foundation.org
Subject: [merged] fs-befs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:14 -0700
Message-ID: <200904061938.n36JcE4A013266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbZDFTkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, rathamahata@php4.ru, mm-commits@vger.kernel.org


The patch titled
     fs/befs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-befs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/befs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make befs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Sergey S. Kostyliov <rathamahata@php4.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/befs/linuxvfs.c~fs-befs-return-f_fsid-for-statfs2 fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-return-f_fsid-for-statfs2
+++ a/fs/befs/linuxvfs.c
@@ -900,6 +900,7 @@ static int
 befs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	befs_debug(sb, "---> befs_statfs()");
 
@@ -910,6 +911,8 @@ befs_statfs(struct dentry *dentry, struc
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = 0;	/* UNKNOWN */
 	buf->f_ffree = 0;	/* UNKNOWN */
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = BEFS_NAME_LEN;
 
 	befs_debug(sb, "<--- befs_statfs()");
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

