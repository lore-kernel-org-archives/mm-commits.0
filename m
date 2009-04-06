From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:24 -0700
Message-ID: <200904061938.n36JcOff013335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886AbZDFTlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/hfsplus: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/hfsplus: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make hfsplus return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hfsplus/super.c~fs-hfsplus-return-f_fsid-for-statfs2 fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~fs-hfsplus-return-f_fsid-for-statfs2
+++ a/fs/hfsplus/super.c
@@ -223,6 +223,7 @@ static void hfsplus_put_super(struct sup
 static int hfsplus_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	buf->f_type = HFSPLUS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -231,6 +232,8 @@ static int hfsplus_statfs(struct dentry 
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = 0xFFFFFFFF;
 	buf->f_ffree = 0xFFFFFFFF - HFSPLUS_SB(sb).next_cnid;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = HFSPLUS_MAX_STRLEN;
 
 	return 0;
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

