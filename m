From: akpm@linux-foundation.org
Subject: + mm-free-compound-page-with-correct-order.patch added to -mm
 tree
Date: Wed, 15 Oct 2014 12:30:57 -0700
Message-ID: <543ecb71.WE1QFef4Td6GEuVa%akpm__19109.217139385$1413401473$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJOTa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 15:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, lliubbo@gmail.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free compound page with correct order
has been added to the -mm tree.  Its filename is
     mm-free-compound-page-with-correct-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free-compound-page-with-correct-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free-compound-page-with-correct-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: free compound page with correct order

Compound page should be freed by put_page() or free_pages() with correct
order.  Not doing so will cause tail pages leaked.

The compound order can be obtained by compound_order() or use
HPAGE_PMD_ORDER in our case.  Some people would argue the latter is faster
but I prefer the former which is more general.

Fixes: 97ae17497e99 ("thp: implement refcounting for huge zero page")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: <stable@vger.kernel.org>	[3.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-free-compound-page-with-correct-order mm/huge_memory.c
--- a/mm/huge_memory.c~mm-free-compound-page-with-correct-order
+++ a/mm/huge_memory.c
@@ -200,7 +200,7 @@ retry:
 	preempt_disable();
 	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
 		preempt_enable();
-		__free_page(zero_page);
+		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
 
@@ -232,7 +232,7 @@ static unsigned long shrink_huge_zero_pa
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
-		__free_page(zero_page);
+		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-free-compound-page-with-correct-order.patch
mm-verify-compound-order-when-freeing-a-page.patch

