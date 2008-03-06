From: akpm@linux-foundation.org
Subject: + jbd-replace-potentially-false-assertion-with-if-block.patch added to -mm tree
Date: Wed, 05 Mar 2008 20:31:53 -0800
Message-ID: <200803060431.m264Vr15008686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbYCFEb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 23:31:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: duaneg@dghda.com


The patch titled
     jbd: replace potentially false assertion with if block
has been added to the -mm tree.  Its filename is
     jbd-replace-potentially-false-assertion-with-if-block.patch

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

jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch

