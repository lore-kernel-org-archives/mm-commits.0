From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:36:39 -0700
Message-ID: <5591ac57.EMKJ6/a55Fd29WV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbF2Ugk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not BUG if jbd2_journal_dirty_metadata fails
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: do not BUG if jbd2_journal_dirty_metadata fails

jbd2_journal_dirty_metadata may fail.  Currently it cannot take care of
non zero return value and just BUG in ocfs2_journal_dirty.  This patch is
aborting the handle and journal instead of BUG.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.c~ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails
+++ a/fs/ocfs2/journal.c
@@ -775,7 +775,20 @@ void ocfs2_journal_dirty(handle_t *handl
 	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);
 
 	status = jbd2_journal_dirty_metadata(handle, bh);
-	BUG_ON(status);
+	if (status) {
+		mlog_errno(status);
+		if (!is_handle_aborted(handle)) {
+			journal_t *journal = handle->h_transaction->t_journal;
+			struct super_block *sb = bh->b_bdev->bd_super;
+
+			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
+					"Aborting transaction and journal.\n");
+			handle->h_err = status;
+			jbd2_journal_abort_handle(handle);
+			jbd2_journal_abort(journal, status);
+			ocfs2_abort(sb, "Journal already aborted.\n");
+		}
+	}
 }
 
 #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

