From: akpm@linux-foundation.org
Subject: [folded-merged] thp-clean-up-__collapse_huge_page_isolate-v2.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:38:17 -0800
Message-ID: <20121211233819.6283C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40382 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2LKXiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:38:20 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so5827yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:38:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-clean-up-__collapse_huge_page_isolate v2
has been removed from the -mm tree.  Its filename was
     thp-clean-up-__collapse_huge_page_isolate-v2.patch

This patch was dropped because it was folded into thp-clean-up-__collapse_huge_page_isolate.patch

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: thp-clean-up-__collapse_huge_page_isolate v2

mv label out of condition.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~thp-clean-up-__collapse_huge_page_isolate-v2 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-clean-up-__collapse_huge_page_isolate-v2
+++ a/mm/huge_memory.c
@@ -1871,7 +1871,7 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page;
 	pte_t *_pte;
-	int referenced = 0, isolated = 1, none = 0;
+	int referenced = 0, none = 0;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
@@ -1920,12 +1920,11 @@ static int __collapse_huge_page_isolate(
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
-	if (unlikely(!referenced)) {
+	if (likely(referenced))
+		return 1;
 out:
-		release_pte_pages(pte, _pte);
-		isolated = 0;
-	}
-	return isolated;
+	release_pte_pages(pte, _pte);
+	return 0;
 }
 
 static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
_

Patches currently in -mm which might be from lliubbo@gmail.com are

thp-clean-up-__collapse_huge_page_isolate.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch

