From: akpm@linux-foundation.org
Subject: + thp-clean-up-__collapse_huge_page_isolate-v2.patch added to -mm tree
Date: Tue, 23 Oct 2012 13:57:07 -0700
Message-ID: <20121023205707.AE2FA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40964 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739Ab2JWU5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:57:09 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so538488vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:57:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com


The patch titled
     Subject: thp-clean-up-__collapse_huge_page_isolate v2
has been added to the -mm tree.  Its filename is
     thp-clean-up-__collapse_huge_page_isolate-v2.patch

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
@@ -1858,7 +1858,7 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page;
 	pte_t *_pte;
-	int referenced = 0, isolated = 1, none = 0;
+	int referenced = 0, none = 0;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
@@ -1907,12 +1907,11 @@ static int __collapse_huge_page_isolate(
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

mm-page_allocc-alloc_contig_range-return-early-for-err-path.patch
linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
thp-introduce-hugepage_get_pmd.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch

