From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-return-f_fsid-for-statfs2.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:43 -0700
Message-ID: <200904061938.n36Jch6D013475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZDFUBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     fs/ufs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-ufs-return-f_fsid-for-statfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ufs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make ufs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ufs/super.c~fs-ufs-return-f_fsid-for-statfs2 fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-return-f_fsid-for-statfs2
+++ a/fs/ufs/super.c
@@ -1268,6 +1268,7 @@ static int ufs_statfs(struct dentry *den
 	struct ufs_super_block_first *usb1;
 	struct ufs_super_block_second *usb2;
 	struct ufs_super_block_third *usb3;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
 	lock_kernel();
 
@@ -1290,6 +1291,8 @@ static int ufs_statfs(struct dentry *den
 		? (buf->f_bfree - (((long)buf->f_blocks / 100) * uspi->s_minfree)) : 0;
 	buf->f_files = uspi->s_ncg * uspi->s_ipg;
 	buf->f_namelen = UFS_MAXNAMLEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 	unlock_kernel();
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

