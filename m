From: akpm@linux-foundation.org
Subject: + freevxfs-possible-null-pointer-dereference-fix.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:32:47 -0800
Message-ID: <200702251232.l1PCWn7c029355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964861AbXBYMds (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:33:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org, hch@lst.de


The patch titled
     freevxfs: possible null pointer dereference fix
has been added to the -mm tree.  Its filename is
     freevxfs-possible-null-pointer-dereference-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

freevxfs-possible-null-pointer-dereference-fix.patch
