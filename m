From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-copying-user-pages-must-schedule-on-collapse.patch removed from -mm
 tree
Date: Tue, 16 May 2017 10:50:20 -0700
Message-ID: <20170516175020.2Dx9j_bLz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752745AbdEPRuV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm, thp: copying user pages must schedule on collapse
has been removed from the -mm tree.  Its filename was
     mm-thp-copying-user-pages-must-schedule-on-collapse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: copying user pages must schedule on collapse

We have encountered need_resched warnings in __collapse_huge_page_copy()
while doing {clear,copy}_user_highpage() over HPAGE_PMD_NR source pages.

mm->mmap_sem is held for write, but the iteration is well bounded.

Reschedule as needed.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1705101426380.109808@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-copying-user-pages-must-schedule-on-collapse mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-copying-user-pages-must-schedule-on-collapse
+++ a/mm/khugepaged.c
@@ -612,7 +612,8 @@ static void __collapse_huge_page_copy(pt
 				      spinlock_t *ptl)
 {
 	pte_t *_pte;
-	for (_pte = pte; _pte < pte+HPAGE_PMD_NR; _pte++) {
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+				_pte++, page++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		struct page *src_page;
 
@@ -651,9 +652,7 @@ static void __collapse_huge_page_copy(pt
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
