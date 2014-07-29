From: akpm@linux-foundation.org
Subject: + ocfs2-fix-journal-commit-deadlock.patch added to -mm tree
Date: Tue, 29 Jul 2014 15:26:11 -0700
Message-ID: <53d81f83.YGwAi8TKSkUcFQGq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:47701 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaG2W0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 18:26:13 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so54100vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 15:26:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, wen.gang.wang@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix journal commit deadlock
has been added to the -mm tree.  Its filename is
     ocfs2-fix-journal-commit-deadlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-journal-commit-deadlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-journal-commit-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mark Fasheh <mfasheh@suse.com>
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
@@ -2040,11 +2044,19 @@ out_write_size:
 	ocfs2_journal_dirty(handle, wc->w_di_bh);
 
 out:
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

ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch
ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch
ocfs2-quorum-add-a-log-for-node-not-fenced.patch
ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch

