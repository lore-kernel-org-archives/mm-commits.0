From: akpm@linux-foundation.org
Subject: +
 mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 16:33:42 -0800
Message-ID: <58b616e6.miAjvDL21avbEjIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdCAA46 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch

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
@@ -568,7 +568,8 @@ static void lru_lazyfree_fn(struct page
 	    !PageUnevictable(page)) {
 		bool active = PageActive(page);
 
-		del_page_from_lru_list(page, lruvec, LRU_INACTIVE_ANON + active);
+		del_page_from_lru_list(page, lruvec,
+				       LRU_INACTIVE_ANON + active);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		/*
@@ -651,7 +652,7 @@ void deactivate_file_page(struct page *p
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

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

