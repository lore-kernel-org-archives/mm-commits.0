From: akpm@linux-foundation.org
Subject: [merged] thp-clean-up-__collapse_huge_page_isolate.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:05 -0800
Message-ID: <20121212195705.C766482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:34225 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:07 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so115242qcq.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: clean up __collapse_huge_page_isolate
has been removed from the -mm tree.  Its filename was
     thp-clean-up-__collapse_huge_page_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp: clean up __collapse_huge_page_isolate

There are duplicated places using release_pte_pages().
And release_all_pte_pages() can be removed.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff -puN mm/huge_memory.c~thp-clean-up-__collapse_huge_page_isolate mm/huge_memory.c
--- a/mm/huge_memory.c~thp-clean-up-__collapse_huge_page_isolate
+++ a/mm/huge_memory.c
@@ -1701,64 +1701,49 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
-static void release_all_pte_pages(pte_t *pte)
-{
-	release_pte_pages(pte, pte + HPAGE_PMD_NR);
-}
-
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte)
 {
 	struct page *page;
 	pte_t *_pte;
-	int referenced = 0, isolated = 0, none = 0;
+	int referenced = 0, none = 0;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval)) {
 			if (++none <= khugepaged_max_ptes_none)
 				continue;
-			else {
-				release_pte_pages(pte, _pte);
+			else
 				goto out;
-			}
 		}
-		if (!pte_present(pteval) || !pte_write(pteval)) {
-			release_pte_pages(pte, _pte);
+		if (!pte_present(pteval) || !pte_write(pteval))
 			goto out;
-		}
 		page = vm_normal_page(vma, address, pteval);
-		if (unlikely(!page)) {
-			release_pte_pages(pte, _pte);
+		if (unlikely(!page))
 			goto out;
-		}
+
 		VM_BUG_ON(PageCompound(page));
 		BUG_ON(!PageAnon(page));
 		VM_BUG_ON(!PageSwapBacked(page));
 
 		/* cannot use mapcount: can't collapse if there's a gup pin */
-		if (page_count(page) != 1) {
-			release_pte_pages(pte, _pte);
+		if (page_count(page) != 1)
 			goto out;
-		}
 		/*
 		 * We can do it before isolate_lru_page because the
 		 * page can't be freed from under us. NOTE: PG_lock
 		 * is needed to serialize against split_huge_page
 		 * when invoked from the VM.
 		 */
-		if (!trylock_page(page)) {
-			release_pte_pages(pte, _pte);
+		if (!trylock_page(page))
 			goto out;
-		}
 		/*
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
 		 */
 		if (isolate_lru_page(page)) {
 			unlock_page(page);
-			release_pte_pages(pte, _pte);
 			goto out;
 		}
 		/* 0 stands for page_is_file_cache(page) == false */
@@ -1771,12 +1756,11 @@ static int __collapse_huge_page_isolate(
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
-	if (unlikely(!referenced))
-		release_all_pte_pages(pte);
-	else
-		isolated = 1;
+	if (likely(referenced))
+		return 1;
 out:
-	return isolated;
+	release_pte_pages(pte, _pte);
+	return 0;
 }
 
 static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
hotplug-update-nodemasks-management-fix.patch
linux-next.patch

