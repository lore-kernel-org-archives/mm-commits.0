From: akpm@linux-foundation.org
Subject: - jbd-fix-race-between-free-buffer-and-commit-trasanction.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:31 -0700
Message-ID: <200807252256.m6PMuVi3003098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYGYXCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, jack@suse.cz, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jbd: fix race between free buffer and commit transaction
has been removed from the -mm tree.  Its filename was
     jbd-fix-race-between-free-buffer-and-commit-trasanction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix race between free buffer and commit transaction
From: Mingming Cao <cmm@us.ibm.com>

journal_try_to_free_buffers() could race with jbd commit transaction when
the later is holding the buffer reference while waiting for the data
buffer to flush to disk.  If the caller of journal_try_to_free_buffers()
request tries hard to release the buffers, it will treat the failure as
error and return back to the caller.  We have seen the directo IO failed
due to this race.  Some of the caller of releasepage() also expecting the
buffer to be dropped when passed with GFP_KERNEL mask to the
releasepage()->journal_try_to_free_buffers().

With this patch, if the caller is passing the __GFP_WAIT and __GFP_FS to
indicating this call could wait, in case of try_to_free_buffers() failed,
let's waiting for journal_commit_transaction() to finish commit the
current committing transaction, then try to free those buffers again.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |   57 +++++++++++++++++++++++++++++++++++++++--
 mm/filemap.c         |    3 --
 2 files changed, 56 insertions(+), 4 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-fix-race-between-free-buffer-and-commit-trasanction fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-fix-race-between-free-buffer-and-commit-trasanction
+++ a/fs/jbd/transaction.c
@@ -1648,12 +1648,42 @@ out:
 	return;
 }
 
+/*
+ * journal_try_to_free_buffers() could race with journal_commit_transaction()
+ * The latter might still hold the a count on buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
+ *
+ * journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * tryinf to free that buffer.
+ *
+ * Called with journal->j_state_lock held.
+ */
+static void journal_wait_for_transaction_sync_data(journal_t *journal)
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
+	log_wait_commit(journal, tid);
+}
 
 /**
  * int journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: we use the mask to detect how hard should we try to release
+ * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
+ * release the buffers.
  *
  *
  * For all the buffers on this page,
@@ -1682,9 +1712,11 @@ out:
  * journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
+ *
+ * Return 0 on failure, 1 on success
  */
 int journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t unused_gfp_mask)
+				struct page *page, gfp_t gfp_mask)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1713,7 +1745,28 @@ int journal_try_to_free_buffers(journal_
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+	/*
+	 * There are a number of places where journal_try_to_free_buffers()
+	 * could race with journal_commit_transaction(), the later still
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
+		journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+	}
+
 busy:
 	return ret;
 }
diff -puN mm/filemap.c~jbd-fix-race-between-free-buffer-and-commit-trasanction mm/filemap.c
--- a/mm/filemap.c~jbd-fix-race-between-free-buffer-and-commit-trasanction
+++ a/mm/filemap.c
@@ -2563,9 +2563,8 @@ EXPORT_SYMBOL(generic_file_aio_write);
  * Otherwise return zero.
  *
  * The @gfp_mask argument specifies whether I/O may be performed to release
- * this page (__GFP_IO), and whether the call may block (__GFP_WAIT).
+ * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
  *
- * NOTE: @gfp_mask may go away, and this function may become non-blocking.
  */
 int try_to_release_page(struct page *page, gfp_t gfp_mask)
 {
_

Patches currently in -mm which might be from cmm@us.ibm.com are

origin.patch

