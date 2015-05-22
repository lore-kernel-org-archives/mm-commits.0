From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch
 added to -mm tree
Date: Fri, 22 May 2015 12:33:59 -0700
Message-ID: <555f84a7.pvY/pu5LuJFa9Hyv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbbEVTeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not BUG if jbd2_journal_dirty_metadata fails
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch
ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

