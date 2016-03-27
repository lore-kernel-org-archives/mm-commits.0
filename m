From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch
 removed from -mm tree
Date: Sat, 26 Mar 2016 20:30:57 -0700
Message-ID: <56f753f1.P+DHYbxhqST6nkGz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0Da6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: solve a problem of crossing the boundary in updating backups
has been removed from the -mm tree.  Its filename was
     ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: solve a problem of crossing the boundary in updating backups

In update_backups() there exists a problem of crossing the boundary
as follows:

we assume that lun will be resized to 1TB(cluster_size is 32kb),
it will include 0~33554431 cluster, in update_backups func,
it will backup super block in location of 1TB which is the 33554432th
cluster, so the phenomenon of crossing the boundary happens.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/resize.c~ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups
+++ a/fs/ocfs2/resize.c
@@ -196,7 +196,7 @@ static int update_backups(struct inode *
 	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
 		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
 		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
-		if (cluster > clusters)
+		if (cluster >= clusters)
 			break;
 
 		ret = ocfs2_read_blocks_sync(osb, blkno, 1, &backup);
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are


