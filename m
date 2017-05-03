From: akpm@linux-foundation.org
Subject: [folded-merged]
 jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:37:30 -0700
Message-ID: <590a4d9a.yI66DfdLbCgYuBoI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVhb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix
has been removed from the -mm tree.  Its filename was
     jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch

This patch was dropped because it was folded into jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix

tweak comments

Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/transaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/jbd2/transaction.c~jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix
+++ a/fs/jbd2/transaction.c
@@ -390,8 +390,8 @@ repeat:
 	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
 	/*
-	 * Make sure that no allocations done while the transaction is
-	 * open is going to recurse back to the fs layer.
+	 * Ensure that no allocations done while the transaction is open are
+	 * going to recurse back to the fs layer.
 	 */
 	handle->saved_alloc_context = memalloc_nofs_save();
 	return 0;
@@ -1768,8 +1768,8 @@ int jbd2_journal_stop(handle_t *handle)
 		jbd2_journal_free_reserved(handle->h_rsv_handle);
 free_and_exit:
 	/*
-	 * scope of th GFP_NOFS context is over here and so we can
-	 * restore the original alloc context.
+	 * Scope of the GFP_NOFS context is over here and so we can restore the
+	 * original alloc context.
 	 */
 	memalloc_nofs_restore(handle->saved_alloc_context);
 	jbd2_free_handle(handle);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

