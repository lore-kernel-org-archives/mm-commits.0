From: akpm@linux-foundation.org
Subject: +
 jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch added to -mm tree
Date: Mon, 06 Mar 2017 13:26:28 -0800
Message-ID: <58bdd404.IYL53rBd66EU5A3E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932368AbdCFVfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix
has been added to the -mm tree.  Its filename is
     jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

