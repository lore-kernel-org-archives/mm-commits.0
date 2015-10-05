From: akpm@linux-foundation.org
Subject: +
 ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 14:00:56 -0700
Message-ID: <5612e508.BdCcRm58fMO3J5uz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbbJEVA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: solve a problem of crossing the boundary in updating backups
has been added to the -mm tree.  Its filename is
     ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Joseph Qi <joseph.qi@huawei.com>
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
@@ -187,7 +187,7 @@ static int update_backups(struct inode *
 	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
 		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
 		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
-		if (cluster > clusters)
+		if (cluster >= clusters)
 			break;
 
 		ret = ocfs2_read_blocks_sync(osb, blkno, 1, &backup);
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-fill-in-the-unused-portion-of-the-block-with-zeros-by-dio_zero_block.patch
ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch
ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

