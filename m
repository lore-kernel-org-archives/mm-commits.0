From: akpm@linux-foundation.org
Subject: + mm-thp-copying-user-pages-must-schedule-on-collapse.patch added to -mm tree
Date: Wed, 10 May 2017 14:42:46 -0700
Message-ID: <59138956.VoZ7sr/O9qh37QgA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38050 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752943AbdEJVmr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 17:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: copying user pages must schedule on collapse
has been added to the -mm tree.  Its filename is
     mm-thp-copying-user-pages-must-schedule-on-collapse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-copying-user-pages-must-schedule-on-collapse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-copying-user-pages-must-schedule-on-collapse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: copying user pages must schedule on collapse

We have encountered need_resched warnings in __collapse_huge_page_copy()
while doing {clear,copy}_user_highpage() over HPAGE_PMD_NR source pages.

mm->mmap_sem is held for write, but the iteration is well bounded.

Reschedule as needed.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1705101426380.109808@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
