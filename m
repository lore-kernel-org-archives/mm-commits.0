From: akpm@linux-foundation.org
Subject: + jbd-clean-up-journal_try_to_free_buffers.patch added to -mm tree
Date: Tue, 09 Jun 2009 13:18:45 -0700
Message-ID: <200906092018.n59KIkIe024353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbZFIUTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 16:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hifumi.hisashi@oss.ntt.co.jp, cmm@us.ibm.com, jack@suse.cz, tytso@mit.edu


The patch titled
     jbd: clean up journal_try_to_free_buffers()
has been added to the -mm tree.  Its filename is
     jbd-clean-up-journal_try_to_free_buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: clean up journal_try_to_free_buffers()
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

I delete the following patch
"commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
Author: Mingming Cao <cmm@us.ibm.com>
Date:   Fri Jul 25 01:46:22 2008 -0700

    jbd: fix race between free buffer and commit transaction


This patch is no longer needed because if race between freeing buffer and
committing transaction functionality occurs and dio gets error, currently
dio falls back to buffered IO by the following patch.

	commit 6ccfa806a9cfbbf1cd43d5b6aa47ef2c0eb518fd
	Author: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
	Date:   Tue Sep 2 14:35:40 2008 -0700

   	VFS: fix dio write returning EIO when try_to_release_page fails

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |   48 -----------------------------------------
 1 file changed, 48 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-clean-up-journal_try_to_free_buffers fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-clean-up-journal_try_to_free_buffers
+++ a/fs/jbd/transaction.c
@@ -1686,35 +1686,6 @@ out:
 	return;
 }
 
-/*
- * journal_try_to_free_buffers() could race with journal_commit_transaction()
- * The latter might still hold the a count on buffers when inspecting
- * them on t_syncdata_list or t_locked_list.
- *
- * journal_try_to_free_buffers() will call this function to
- * wait for the current transaction to finish syncing data buffers, before
- * tryinf to free that buffer.
- *
- * Called with journal->j_state_lock held.
- */
-static void journal_wait_for_transaction_sync_data(journal_t *journal)
-{
-	transaction_t *transaction = NULL;
-	tid_t tid;
-
-	spin_lock(&journal->j_state_lock);
-	transaction = journal->j_committing_transaction;
-
-	if (!transaction) {
-		spin_unlock(&journal->j_state_lock);
-		return;
-	}
-
-	tid = transaction->t_tid;
-	spin_unlock(&journal->j_state_lock);
-	log_wait_commit(journal, tid);
-}
-
 /**
  * int journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
@@ -1786,25 +1757,6 @@ int journal_try_to_free_buffers(journal_
 
 	ret = try_to_free_buffers(page);
 
-	/*
-	 * There are a number of places where journal_try_to_free_buffers()
-	 * could race with journal_commit_transaction(), the later still
-	 * holds the reference to the buffers to free while processing them.
-	 * try_to_free_buffers() failed to free those buffers. Some of the
-	 * caller of releasepage() request page buffers to be dropped, otherwise
-	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
-	 *
-	 * So, if the caller of try_to_release_page() wants the synchronous
-	 * behaviour(i.e make sure buffers are dropped upon return),
-	 * let's wait for the current transaction to finish flush of
-	 * dirty data buffers, then try to free those buffers again,
-	 * with the journal locked.
-	 */
-	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
-		journal_wait_for_transaction_sync_data(journal);
-		ret = try_to_free_buffers(page);
-	}
