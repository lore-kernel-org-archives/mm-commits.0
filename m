From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:55 -0700
Message-ID: <5535511f.wqS9cxSXNtuijL6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbDTTMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: put out gfp mask manipulation from nilfs_set_inode_flags()
has been removed from the -mm tree.  Its filename was
     nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: put out gfp mask manipulation from nilfs_set_inode_flags()

nilfs_set_inode_flags() function adjusts gfp-mask of inode->i_mapping as
well as i_flags, however, this coupling of operations is not appropriate.

For instance, nilfs_ioctl_setflags(), one of three callers of
nilfs_set_inode_flags(), doesn't need to reinitialize the gfp-mask at all.
 In addition, nilfs_new_inode(), another caller of
nilfs_set_inode_flags(), doesn't either because it has already initialized
the gfp-mask.

Only __nilfs_read_inode(), the remaining caller, needs it.  So, this moves
the gfp mask manipulation to __nilfs_read_inode() from
nilfs_set_inode_flags().

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/inode.c~nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags
+++ a/fs/nilfs2/inode.c
@@ -456,8 +456,6 @@ void nilfs_set_inode_flags(struct inode
 		inode->i_flags |= S_NOATIME;
 	if (flags & FS_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
-	mapping_set_gfp_mask(inode->i_mapping,
-			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 }
 
 int nilfs_read_inode_common(struct inode *inode,
@@ -542,6 +540,8 @@ static int __nilfs_read_inode(struct sup
 	brelse(bh);
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	nilfs_set_inode_flags(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 	return 0;
 
  failed_unmap:
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

