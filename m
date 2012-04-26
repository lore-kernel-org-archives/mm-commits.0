From: akpm@linux-foundation.org
Subject: + mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch added to -mm tree
Date: Thu, 26 Apr 2012 16:11:01 -0700
Message-ID: <20120426231102.91D13A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49788 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZXLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 19:11:05 -0400
Received: by eaaq10 with SMTP id q10so4513eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 16:11:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, kamezawa.hiroyu@jp.fujtisu.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: rename is_mlocked_vma() to mlocked_vma_newpage()
has been added to the -mm tree.  Its filename is
     mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: mm: rename is_mlocked_vma() to mlocked_vma_newpage()

Andrew pointed out that the is_mlocked_vma() is misnamed.  A function with
name like that would expect bool return and no side-effects.

Since it is called on the fault path for new page, rename it in this
patch.

Signed-off-by: Ying Han <yinghan@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 +++--
 mm/vmscan.c   |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage mm/internal.h
--- a/mm/internal.h~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage
+++ a/mm/internal.h
@@ -164,7 +164,8 @@ static inline void munlock_vma_pages_all
  * to determine if it's being mapped into a LOCKED vma.
  * If so, mark page as mlocked.
  */
-static inline int is_mlocked_vma(struct vm_area_struct *vma, struct page *page)
+static inline int mlock_vma_newpage(struct vm_area_struct *vma,
+				    struct page *page)
 {
 	VM_BUG_ON(PageLRU(page));
 
@@ -222,7 +223,7 @@ extern unsigned long vma_address(struct 
 				 struct vm_area_struct *vma);
 #endif
 #else /* !CONFIG_MMU */
-static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
+static inline int mlock_vma_newpage(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
 }
diff -puN mm/vmscan.c~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage mm/vmscan.c
--- a/mm/vmscan.c~mm-rename-is_mlocked_vma-to-mlocked_vma_newpage
+++ a/mm/vmscan.c
@@ -3321,7 +3321,7 @@ int page_evictable(struct page *page, st
 	if (mapping_unevictable(page_mapping(page)))
 		return 0;
 
-	if (PageMlocked(page) || (vma && is_mlocked_vma(vma, page)))
+	if (PageMlocked(page) || (vma && mlock_vma_newpage(vma, page)))
 		return 0;
 
 	return 1;
_
Subject: Subject: mm: rename is_mlocked_vma() to mlocked_vma_newpage()

Patches currently in -mm which might be from yinghan@google.com are

mm-fix-up-the-vmscan-stat-in-vmstat.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch

