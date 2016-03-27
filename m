From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch removed from -mm tree
Date: Sat, 26 Mar 2016 20:30:45 -0700
Message-ID: <56f753e5.AsBsXGl+YE989Gqp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0Daq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()

Should call ocfs2_free_alloc_context() to free meta_ac & data_ac before
calling ocfs2_run_deallocs().  Because ocfs2_run_deallocs() will acquire
the system inode's i_mutex hold by meta_ac.  So try to release the lock
before ocfs2_run_deallocs().

Fixes: af1310367f41 ("ocfs2: fix sparse file & data ordering issue in direct io.")
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Acked-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-a-deadlock-issue-in-ocfs2_dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2341,6 +2341,10 @@ static void ocfs2_dio_end_io_write(struc
 
 	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
 				    &data_ac, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
 
 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
 
@@ -2380,14 +2384,14 @@ unlock:
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	ocfs2_run_deallocs(osb, &dealloc);
-	if (locked)
-		mutex_unlock(&inode->i_mutex);
-	ocfs2_dio_free_write_ctx(inode, dwc);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
+	ocfs2_run_deallocs(osb, &dealloc);
+	if (locked)
+		mutex_unlock(&inode->i_mutex);
+	ocfs2_dio_free_write_ctx(inode, dwc);
 }
 
 /*
_

Patches currently in -mm which might be from ryan.ding@oracle.com are


