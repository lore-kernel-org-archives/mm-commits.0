From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch removed from -mm tree
Date: Wed, 31 Jan 2018 15:46:40 -0800
Message-ID: <5a725560.s2snNUJ1TMLMMTSY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbeAaXql (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:46:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, john@nixnuts.net, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch

This patch was dropped because it was folded into ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix

brelse(NULL) is legal

Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Lightsey <john@nixnuts.net>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix
+++ a/fs/ocfs2/alloc.c
@@ -6757,10 +6757,8 @@ static int ocfs2_reuse_blk_from_dealloc(
 
 bail:
 	if (unlikely(status < 0)) {
-		for (i = 0; i < blk_wanted; i++) {
-			if (new_eb_bh[i])
-				brelse(new_eb_bh[i]);
-		}
+		for (i = 0; i < blk_wanted; i++)
+			brelse(new_eb_bh[i]);
 	}
 
 	return status;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

