From: akpm@linux-foundation.org
Subject: - jbd-replace-potentially-false-assertion-with-if-block.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:43:49 -0700
Message-ID: <200803101943.m2AJhoKx002202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbYCJTny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, mm-commits@vger.kernel.org


The patch titled
     jbd: replace potentially false assertion with if block
has been removed from the -mm tree.  Its filename was
     jbd-replace-potentially-false-assertion-with-if-block.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: replace potentially false assertion with if block
From: "Duane Griffin" <duaneg@dghda.com>

If an error occurs during jbd cache initialisation it is possible for the
journal_head_cache to be NULL when journal_destroy_journal_head_cache is
called. Replace the J_ASSERT with an if block to handle the situation
correctly.

Note that even with this fix things will break badly if ext3 is statically
compiled in and cache initialisation fails.

At the moment the cache destruction methods are inconsistent in whether they
set the cache pointers to NULL after destroying them.  To be precise,
journal_destroy_handle_cache doesn't, the others do.  I haven't changed that,
although I was sorely tempted.  I think it would be better to be consistent
and that NULLing the pointers is preferable.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/jbd/journal.c~jbd-replace-potentially-false-assertion-with-if-block fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-replace-potentially-false-assertion-with-if-block
+++ a/fs/jbd/journal.c
@@ -1635,9 +1635,10 @@ static int journal_init_journal_head_cac
 
 static void journal_destroy_journal_head_cache(void)
 {
-	J_ASSERT(journal_head_cache != NULL);
-	kmem_cache_destroy(journal_head_cache);
-	journal_head_cache = NULL;
+	if (journal_head_cache) {
+		kmem_cache_destroy(journal_head_cache);
+		journal_head_cache = NULL;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
jbd2-replace-potentially-false-assertion-with-if-block.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

