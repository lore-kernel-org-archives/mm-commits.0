From: akpm@linux-foundation.org
Subject: + jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction.patch added to -mm tree
Date: Thu, 29 May 2008 13:12:27 -0700
Message-ID: <200805292012.m4TKCRps020034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYE2UNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 16:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, pbadari@us.ibm.com


The patch titled
     jbd2: fix race between jbd2_journal_try_to_free_buffers() and jbd2 commit transaction
has been added to the -mm tree.  Its filename is
     jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: fix race between jbd2_journal_try_to_free_buffers() and jbd2 commit transaction
From: Mingming Cao <cmm@us.ibm.com>

journal_try_to_free_buffers() could race with jbd commit transaction when
the later is holding the buffer reference while waiting for the data
buffer to flush to disk.  If the caller of journal_try_to_free_buffers()
request tries hard to release the buffers, it will treat the failure as
error and return back to the caller.  We have seen the directo IO failed
due to this race.  Some of the caller of releasepage() also expecting the
buffer to be dropped when passed with GFP_KERNEL mask to the
releasepage()->journal_try_to_free_buffers().

With this patch, if the caller is passing the GFP_KERNEL to indicating
this call could wait, in case of try_to_free_buffers() failed, let's
waiting for journal_commit_transaction() to finish commit the current
committing transaction , then try to free those buffers again with journal
locked.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/transaction.c |   61 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 3 deletions(-)

diff -puN fs/jbd2/transaction.c~jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction
+++ a/fs/jbd2/transaction.c
@@ -1656,12 +1656,43 @@ out:
 	return;
 }
 
+/*
+ * jbd2_journal_try_to_free_buffers() could race with
+ * jbd2_journal_commit_transaction(). The later might still hold the
+ * reference count to the buffers when inspecting them on
+ * t_syncdata_list or t_locked_list.
+ *
+ * jbd2_journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * try to free that buffer.
+ *
+ * Called with journal->j_state_lock hold.
+ */
+static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
+{
+	transaction_t *transaction = NULL;
+	tid_t tid;
+
+	spin_lock(&journal->j_state_lock);
+	transaction = journal->j_committing_transaction;
+
+	if (!transaction) {
+		spin_unlock(&journal->j_state_lock);
+		return;
+	}
+
+	tid = transaction->t_tid;
+	spin_unlock(&journal->j_state_lock);
+	jbd2_log_wait_commit(journal, tid);
+}
 
 /**
  * int jbd2_journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: we use the mask to detect how hard should we try to release
+ * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
+ * release the buffers.
  *
  *
  * For all the buffers on this page,
@@ -1690,9 +1721,11 @@ out:
  * journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
+ *
+ * Return 0 on failure, 1 on success
  */
 int jbd2_journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t unused_gfp_mask)
+				struct page *page, gfp_t gfp_mask)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1708,7 +1741,8 @@ int jbd2_journal_try_to_free_buffers(jou
 		/*
 		 * We take our own ref against the journal_head here to avoid
 		 * having to add tons of locking around each instance of
-		 * jbd2_journal_remove_journal_head() and jbd2_journal_put_journal_head().
+		 * jbd2_journal_remove_journal_head() and
+		 * jbd2_journal_put_journal_head().
 		 */
 		jh = jbd2_journal_grab_journal_head(bh);
 		if (!jh)
@@ -1721,7 +1755,28 @@ int jbd2_journal_try_to_free_buffers(jou
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+	/*
+	 * There are a number of places where jbd2_journal_try_to_free_buffers()
+	 * could race with jbd2_journal_commit_transaction(), the later still
+	 * holds the reference to the buffers to free while processing them.
+	 * try_to_free_buffers() failed to free those buffers. Some of the
+	 * caller of releasepage() request page buffers to be dropped, otherwise
+	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
+	 *
+	 * So, if the caller of try_to_release_page() wants the synchronous
+	 * behaviour(i.e make sure buffers are dropped upon return),
+	 * let's wait for the current transaction to finish flush of
+	 * dirty data buffers, then try to free those buffers again,
+	 * with the journal locked.
+	 */
+	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
+		jbd2_journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+	}
+
 busy:
 	return ret;
 }
_

Patches currently in -mm which might be from cmm@us.ibm.com are

linux-next.patch
ext2-remove-double-definitions-of-xattr-macros.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-remove-double-definitions-of-xattr-macros.patch
reiserfs-remove-double-definitions-of-xattr-macros.patch
ext4-improve-some-code-in-rb-tree-part-of-dirc.patch
ext4-error-processing-and-coding-enhancement-for-mballoc.patch
ext4-fix-error-processing-in-mb_free_blocks.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction.patch

