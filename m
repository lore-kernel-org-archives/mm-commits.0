From: akpm@linux-foundation.org
Subject: - jbd-ordered-data-integrity-fix.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:00 -0700
Message-ID: <200810202036.m9KKa04S011263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147AbYJTUql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     jbd: ordered data integrity fix
has been removed from the -mm tree.  Its filename was
     jbd-ordered-data-integrity-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: ordered data integrity fix
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

In ordered mode, if a file data buffer being dirtied exists in the
committing transaction, we write the buffer to the disk, move it from the
committing transaction to the running transaction, then dirty it.  But we
don't have to remove the buffer from the committing transaction when the
buffer couldn't be written out, otherwise it would miss the error and the
committing transaction would not abort.

This patch adds an error check before removing the buffer from the
committing transaction.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-ordered-data-integrity-fix fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-ordered-data-integrity-fix
+++ a/fs/jbd/transaction.c
@@ -954,9 +954,10 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int ret = 0;
 
 	if (is_handle_aborted(handle))
-		return 0;
+		return ret;
 
 	jh = journal_add_journal_head(bh);
 	JBUFFER_TRACE(jh, "entry");
@@ -1067,7 +1068,16 @@ int journal_dirty_data(handle_t *handle,
 				   time if it is redirtied */
 			}
 
-			/* journal_clean_data_list() may have got there first */
+			/*
+			 * We cannot remove the buffer with io error from the
+			 * committing transaction, because otherwise it would
+			 * miss the error and the commit would not abort.
+			 */
+			if (unlikely(!buffer_uptodate(bh))) {
+				ret = -EIO;
+				goto no_journal;
+			}
+
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
 				__journal_temp_unlink_buffer(jh);
@@ -1108,7 +1118,7 @@ no_journal:
 	}
 	JBUFFER_TRACE(jh, "exit");
 	journal_put_journal_head(jh);
-	return 0;
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

