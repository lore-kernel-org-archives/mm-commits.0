From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
 added to -mm tree
Date: Tue, 28 Apr 2015 16:37:00 -0700
Message-ID: <5540199c.ySp+UpePg5qrsNLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031135AbbD1XhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 19:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not BUG if jbd2_journal_dirty_metadata fails
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch

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

jbd2_journal_dirty_metadata may fail.  Currently it cannot take care of
non zero return value and just BUG in ocfs2_journal_dirty.  This patch is
aborting the handle instead of BUG.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.c~ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails
+++ a/fs/ocfs2/journal.c
@@ -775,7 +775,15 @@ void ocfs2_journal_dirty(handle_t *handl
 	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);
 
 	status = jbd2_journal_dirty_metadata(handle, bh);
-	BUG_ON(status);
+	if (status) {
+		mlog_errno(status);
+		if (!is_handle_aborted(handle)) {
+			handle->h_err = status;
+			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
+					"Aborting transaction.");
+			jbd2_journal_abort_handle(handle);
+		}
+	}
 }
 
 #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

