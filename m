From: akpm@linux-foundation.org
Subject: +
 jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 06 Mar 2017 13:27:23 -0800
Message-ID: <58bdd43b.h15d0LKt2hxhG90q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932343AbdCFVfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:35:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch

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
Subject: jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes

WARNING: line over 80 characters
#42: FILE: fs/jbd2/journal.c:210:
+	 * Make sure that no allocations from this kernel thread will ever recurse

total: 0 errors, 1 warnings, 20 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes
+++ a/fs/jbd2/journal.c
@@ -207,9 +207,10 @@ static int kjournald2(void *arg)
 	wake_up(&journal->j_wait_done_commit);
 
 	/*
-	 * Make sure that no allocations from this kernel thread will ever recurse
-	 * to the fs layer because we are responsible for the transaction commit
-	 * and any fs involvement might get stuck waiting for the trasn. commit.
+	 * Make sure that no allocations from this kernel thread will ever
+	 * recurse to the fs layer because we are responsible for the
+	 * transaction commit and any fs involvement might get stuck waiting for
+	 * the trasn. commit.
 	 */
 	memalloc_nofs_save();
 
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
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

