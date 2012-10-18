From: akpm@linux-foundation.org
Subject: + thp-clean-up-__collapse_huge_page_isolate.patch added to -mm tree
Date: Thu, 18 Oct 2012 13:10:09 -0700
Message-ID: <20121018201010.234095C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:42611 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab2JRUKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 16:10:12 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so553392wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 13:10:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com


The patch titled
     Subject: thp: clean up __collapse_huge_page_isolate
has been added to the -mm tree.  Its filename is
     thp-clean-up-__collapse_huge_page_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp: clean up __collapse_huge_page_isolate

There are duplicated places using release_pte_pages().
And release_all_pte_pages() can be removed.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff -puN mm/huge_memory.c~thp-clean-up-__collapse_huge_page_isolate mm/huge_memory.c
--- a/mm/huge_memory.c~thp-clean-up-__collapse_huge_page_isolate
+++ a/mm/huge_memory.c
@@ -1767,64 +1767,49 @@ static void release_pte_pages(pte_t *pte
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
+	int referenced = 0, isolated = 1, none = 0;
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
@@ -1837,11 +1822,11 @@ static int __collapse_huge_page_isolate(
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
-	if (unlikely(!referenced))
-		release_all_pte_pages(pte);
-	else
-		isolated = 1;
+	if (unlikely(!referenced)) {
 out:
+		release_pte_pages(pte, _pte);
+		isolated = 0;
+	}
 	return isolated;
 }
 
_

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch

