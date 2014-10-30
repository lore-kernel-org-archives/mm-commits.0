From: akpm@linux-foundation.org
Subject: [merged] mm-free-compound-page-with-correct-order.patch removed
 from -mm tree
Date: Thu, 30 Oct 2014 13:27:20 -0700
Message-ID: <54529f28.704e5xisP3uA7G80%akpm__5591.8073667728$1414700855$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbaJ3U1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, lliubbo@gmail.com, mel@csn.ul.ie, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: free compound page with correct order
has been removed from the -mm tree.  Its filename was
     mm-free-compound-page-with-correct-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: free compound page with correct order

Compound page should be freed by put_page() or free_pages() with correct
order.  Not doing so will cause tail pages leaked.

The compound order can be obtained by compound_order() or use
HPAGE_PMD_ORDER in our case.  Some people would argue the latter is faster
but I prefer the former which is more general.

This bug was observed not just on our servers (the worst case we saw is
11G leaked on a 48G machine) but also on our workstations running
Ubuntu based distro.

$ cat /proc/vmstat  | grep thp_zero_page_alloc
thp_zero_page_alloc 55
thp_zero_page_alloc_failed 0

This means there is (thp_zero_page_alloc - 1) * (2M - 4K) memory leaked.

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

origin.patch
mm-verify-compound-order-when-freeing-a-page.patch

