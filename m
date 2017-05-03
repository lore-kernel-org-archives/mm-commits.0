From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 03 May 2017 14:34:33 -0700
Message-ID: <590a4ce9./WPuZR14BtK48JcO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVef (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-move-madv_free-pages-into-lru_inactive_file-list.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes

WARNING: line over 80 characters
#127: FILE: mm/swap.c:571:
+		del_page_from_lru_list(page, lruvec, LRU_INACTIVE_ANON + active);

WARNING: please, no spaces at the start of a line
#177: FILE: mm/swap.c:654:
+ {$

total: 0 errors, 2 warnings, 133 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-move-madv_free-pages-into-lru_inactive_file-list.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes mm/swap.c
--- a/mm/swap.c~mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes
+++ a/mm/swap.c
@@ -578,7 +578,8 @@ static void lru_lazyfree_fn(struct page
 	    !PageUnevictable(page)) {
 		bool active = PageActive(page);
 
-		del_page_from_lru_list(page, lruvec, LRU_INACTIVE_ANON + active);
+		del_page_from_lru_list(page, lruvec,
+				       LRU_INACTIVE_ANON + active);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		/*
@@ -661,7 +662,7 @@ void deactivate_file_page(struct page *p
  * This is done to accelerate the reclaim of @page.
  */
 void mark_page_lazyfree(struct page *page)
- {
+{
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageUnevictable(page)) {
 		struct pagevec *pvec = &get_cpu_var(lru_lazyfree_pvecs);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-move-madv_free-pages-into-lru_inactive_file-list.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

