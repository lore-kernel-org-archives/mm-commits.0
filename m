From: akpm@linux-foundation.org
Subject: +
 nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch added to -mm tree
Date: Wed, 08 Apr 2015 16:09:41 -0700
Message-ID: <5525b535.o99NSzgj1cNCisBb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbbDHXJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 19:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: put out gfp mask manipulation from nilfs_set_inode_flags()
has been added to the -mm tree.  Its filename is
     nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
nilfs2-use-bgl_lock_ptr.patch
nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch
nilfs2-add-bmap-function-to-seek-a-valid-key.patch
nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch
nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch
nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch
nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch
nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch

