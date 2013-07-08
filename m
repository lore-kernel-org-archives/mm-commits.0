From: akpm@linux-foundation.org
Subject: [merged] ocfs2-xattr-remove-useless-free-space-checking.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:16 -0700
Message-ID: <51db11a4.3KJ309hJghB6gKUo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHTXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, junxiao.bi@oracle.com

Subject: [merged] ocfs2-xattr-remove-useless-free-space-checking.patch removed from -mm tree
To: junxiao.bi@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:16 -0700


The patch titled
     Subject: ocfs2: xattr: remove useless free space checking
has been removed from the -mm tree.  Its filename was
     ocfs2-xattr-remove-useless-free-space-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: xattr: remove useless free space checking

Free space checking will be done in ocfs2_xattr_ibody_init().  So remove
here.

[akpm@linux-foundation.org: remove unused local]
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-xattr-remove-useless-free-space-checking fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-xattr-remove-useless-free-space-checking
+++ a/fs/ocfs2/xattr.c
@@ -2751,7 +2751,6 @@ static int ocfs2_xattr_ibody_set(struct
 {
 	int ret;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	struct ocfs2_xa_loc loc;
 
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
@@ -2759,13 +2758,6 @@ static int ocfs2_xattr_ibody_set(struct
 
 	down_write(&oi->ip_alloc_sem);
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		if (!ocfs2_xattr_has_space_inline(inode, di)) {
-			ret = -ENOSPC;
-			goto out;
-		}
-	}
