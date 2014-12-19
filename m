From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-journal-commit-deadlock.patch removed from -mm tree
Date: Fri, 19 Dec 2014 12:36:58 -0800
Message-ID: <54948c6a.WHYODHIuXqzcZ5Rt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaLSUg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 15:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, stable@vger.kernel.org, wen.gang.wang@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix journal commit deadlock
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-journal-commit-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix journal commit deadlock

For buffer write, page lock will be got in write_begin and released in
write_end, in ocfs2_write_end_nolock(), before it unlock the page in
ocfs2_free_write_ctxt(), it calls ocfs2_run_deallocs(), this will ask for
the read lock of journal->j_trans_barrier.  Holding page lock and ask for
journal->j_trans_barrier breaks the locking order.

This will cause a deadlock with journal commit threads, ocfs2cmt will get
write lock of journal->j_trans_barrier first, then it wakes up kjournald2
to do the commit work, at last it waits until done.  To commit journal,
kjournald2 needs flushing data first, it needs get the cache page lock.

Since some ocfs2 cluster locks are holding by write process, this
deadlock may hung the whole cluster.

unlock pages before ocfs2_run_deallocs() can fix the locking order, also
put unlock before ocfs2_commit_trans() to make page lock is unlocked
before j_trans_barrier to preserve unlocking order.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-journal-commit-deadlock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-journal-commit-deadlock
+++ a/fs/ocfs2/aops.c
@@ -894,7 +894,7 @@ void ocfs2_unlock_and_free_pages(struct
 	}
 }
 
-static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+static void ocfs2_unlock_pages(struct ocfs2_write_ctxt *wc)
 {
 	int i;
 
@@ -915,7 +915,11 @@ static void ocfs2_free_write_ctxt(struct
 		page_cache_release(wc->w_target_page);
 	}
 	ocfs2_unlock_and_free_pages(wc->w_pages, wc->w_num_pages);
+}
 
+static void ocfs2_free_write_ctxt(struct ocfs2_write_ctxt *wc)
+{
+	ocfs2_unlock_pages(wc);
 	brelse(wc->w_di_bh);
 	kfree(wc);
 }
@@ -2042,11 +2046,19 @@ out_write_size:
 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, wc->w_di_bh);
 
+	/* unlock pages before dealloc since it needs acquiring j_trans_barrier
+	 * lock, or it will cause a deadlock since journal commit threads holds
+	 * this lock and will ask for the page lock when flushing the data.
+	 * put it here to preserve the unlock order.
+	 */
+	ocfs2_unlock_pages(wc);
+
 	ocfs2_commit_trans(osb, handle);
 
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
 
-	ocfs2_free_write_ctxt(wc);
+	brelse(wc->w_di_bh);
+	kfree(wc);
 
 	return copied;
 }
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch

