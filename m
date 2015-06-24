From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:43:12 -0700
Message-ID: <558b4090.mMcf9faB5PeepGws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbFXXnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not BUG if jbd2_journal_dirty_metadata fails
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch

This patch was dropped because it was folded into ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: do not BUG if jbd2_journal_dirty_metadata fails

As Junxiao suggested, we also set filesystem read-only here.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.c~ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3 fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3
+++ a/fs/ocfs2/journal.c
@@ -779,12 +779,14 @@ void ocfs2_journal_dirty(handle_t *handl
 		mlog_errno(status);
 		if (!is_handle_aborted(handle)) {
 			journal_t *journal = handle->h_transaction->t_journal;
+			struct super_block *sb = bh->b_bdev->bd_super;
 
 			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
-					"Aborting transaction and journal.");
+					"Aborting transaction and journal.\n");
 			handle->h_err = status;
 			jbd2_journal_abort_handle(handle);
 			jbd2_journal_abort(journal, status);
+			ocfs2_abort(sb, "Journal already aborted.\n");
 		}
 	}
 }
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch
ocfs2-mark-local-functions-as-static.patch

