From: akpm@linux-foundation.org
Subject: [folded-merged]
 jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 03 May 2017 14:37:53 -0700
Message-ID: <590a4db1.MMTltz8Xav+fzVxJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVhy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:37:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch

This patch was dropped because it was folded into jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch

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

jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

