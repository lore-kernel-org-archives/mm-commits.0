From: akpm@linux-foundation.org
Subject: [merged] mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:31 -0700
Message-ID: <20120531191431.7202CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62879 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab2EaTOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:32 -0400
Received: by ggeh3 with SMTP id h3so135414gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, kamezawa.hiroyu@jp.fujtisu.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename is_mlocked_vma() to mlocked_vma_newpage()
has been removed from the -mm tree.  Its filename was
     mm-rename-is_mlocked_vma-to-mlocked_vma_newpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
[akpm@linux-foundation.org: s/mlock_vma_newpage/mlock_vma_newpage/, per Minchan]
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
+static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
+				    struct page *page)
 {
 	VM_BUG_ON(PageLRU(page));
 
@@ -222,7 +223,7 @@ extern unsigned long vma_address(struct 
 				 struct vm_area_struct *vma);
 #endif
 #else /* !CONFIG_MMU */
-static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
+static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
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
+	if (PageMlocked(page) || (vma && mlocked_vma_newpage(vma, page)))
 		return 0;
 
 	return 1;
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

