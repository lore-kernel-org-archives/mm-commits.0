From: akpm@linux-foundation.org
Subject: + ocfs2-clean-up-redundant-null-checks-before-kfree.patch added
 to -mm tree
Date: Fri, 04 Sep 2015 13:20:19 -0700
Message-ID: <55e9fd03.4fFCS7m4vUn6G4jH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361AbbIDUUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 16:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up redundant NULL checks before kfree
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-redundant-null-checks-before-kfree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-redundant-null-checks-before-kfree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-redundant-null-checks-before-kfree.patch

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
Subject: ocfs2: clean up redundant NULL checks before kfree

NULL check before kfree is redundant and so clean them up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c    |    2 +-
 fs/ocfs2/suballoc.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-clean-up-redundant-null-checks-before-kfree fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-clean-up-redundant-null-checks-before-kfree
+++ a/fs/ocfs2/alloc.c
@@ -6178,7 +6178,7 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);
 
-	if (status < 0 && (*tl_copy)) {
+	if (status < 0) {
 		kfree(*tl_copy);
 		*tl_copy = NULL;
 		mlog_errno(status);
diff -puN fs/ocfs2/suballoc.c~ocfs2-clean-up-redundant-null-checks-before-kfree fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-clean-up-redundant-null-checks-before-kfree
+++ a/fs/ocfs2/suballoc.c
@@ -149,10 +149,8 @@ void ocfs2_free_ac_resource(struct ocfs2
 	brelse(ac->ac_bh);
 	ac->ac_bh = NULL;
 	ac->ac_resv = NULL;
-	if (ac->ac_find_loc_priv) {
-		kfree(ac->ac_find_loc_priv);
-		ac->ac_find_loc_priv = NULL;
-	}
+	kfree(ac->ac_find_loc_priv);
+	ac->ac_find_loc_priv = NULL;
 }
 
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch
ocfs2-fix-bug-when-o2hb_register_callback-fails.patch
ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch
ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-clean-up-redundant-null-checks-before-kfree.patch

