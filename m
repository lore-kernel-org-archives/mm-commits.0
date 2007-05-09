From: akpm@linux-foundation.org
Subject: - freevxfs-possible-null-pointer-dereference-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:54 -0700
Message-ID: <200705090244.l492isPW008650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967626AbXEICpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     freevxfs: possible null pointer dereference fix
has been removed from the -mm tree.  Its filename was
     freevxfs-possible-null-pointer-dereference-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freevxfs: possible null pointer dereference fix
From: Dmitriy Monakhov <dmonakhov@sw.ru>

sb_read may return NULL, so let's explicitly check it.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_bmap.c  |    2 +-
 fs/freevxfs/vxfs_inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/freevxfs/vxfs_bmap.c~freevxfs-possible-null-pointer-dereference-fix fs/freevxfs/vxfs_bmap.c
--- a/fs/freevxfs/vxfs_bmap.c~freevxfs-possible-null-pointer-dereference-fix
+++ a/fs/freevxfs/vxfs_bmap.c
@@ -137,7 +137,7 @@ vxfs_bmap_indir(struct inode *ip, long i
 
 		bp = sb_bread(ip->i_sb,
 				indir + (i / VXFS_TYPED_PER_BLOCK(ip->i_sb)));
-		if (!buffer_mapped(bp))
+		if (!bp || !buffer_mapped(bp))
 			return 0;
 
 		typ = ((struct vxfs_typed *)bp->b_data) +
diff -puN fs/freevxfs/vxfs_inode.c~freevxfs-possible-null-pointer-dereference-fix fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~freevxfs-possible-null-pointer-dereference-fix
+++ a/fs/freevxfs/vxfs_inode.c
@@ -99,7 +99,7 @@ vxfs_blkiget(struct super_block *sbp, u_
 	offset = ((ino % (sbp->s_blocksize / VXFS_ISIZE)) * VXFS_ISIZE);
 	bp = sb_bread(sbp, block);
 
-	if (buffer_mapped(bp)) {
+	if (bp && buffer_mapped(bp)) {
 		struct vxfs_inode_info	*vip;
 		struct vxfs_dinode	*dip;
 
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
