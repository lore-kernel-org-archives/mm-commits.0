From: akpm@linux-foundation.org
Subject: [merged] ocfs2-clean-dead-code-in-suballocc.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:29:19 -0800
Message-ID: <20180201192919.89aRiObI6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbeBAT3V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean dead code in suballoc.c
has been removed from the -mm tree.  Its filename was
     ocfs2-clean-dead-code-in-suballocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: clean dead code in suballoc.c

Stack variable fe is no longer used, so trim it to save some CPU cycles
and stack space.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F1F5A8DD@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-clean-dead-code-in-suballocc fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-clean-dead-code-in-suballocc
+++ a/fs/ocfs2/suballoc.c
@@ -2563,16 +2563,16 @@ static int _ocfs2_free_clusters(handle_t
 	int status;
 	u16 bg_start_bit;
 	u64 bg_blkno;
-	struct ocfs2_dinode *fe;
 
 	/* You can't ever have a contiguous set of clusters
 	 * bigger than a block group bitmap so we never have to worry
 	 * about looping on them.
 	 * This is expensive. We can safely remove once this stuff has
 	 * gotten tested really well. */
-	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb, ocfs2_blocks_to_clusters(bitmap_inode->i_sb, start_blk)));
+	BUG_ON(start_blk != ocfs2_clusters_to_blocks(bitmap_inode->i_sb,
+				ocfs2_blocks_to_clusters(bitmap_inode->i_sb,
+							 start_blk)));
 
-	fe = (struct ocfs2_dinode *) bitmap_bh->b_data;
 
 	ocfs2_block_to_cluster_group(bitmap_inode, start_blk, &bg_blkno,
 				     &bg_start_bit);
_

Patches currently in -mm which might be from ge.changwei@h3c.com are


