From: akpm@linux-foundation.org
Subject: [merged] powerpc-gup_hugepte-support-thp-based-tail-recounting.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:08 -0800
Message-ID: <201111072025.pA7KP8bA026602@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1KGUZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.


The patch titled
     Subject: powerpc: gup_hugepte() support THP based tail recounting
has been removed from the -mm tree.  Its filename was
     powerpc-gup_hugepte-support-thp-based-tail-recounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: powerpc: gup_hugepte() support THP based tail recounting

Up to this point the code assumed old refcounting for hugepages (pre-thp).
This updates the code directly to the thp mapcount tail page refcounting.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-gup_hugepte-support-thp-based-tail-recounting arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-gup_hugepte-support-thp-based-tail-recounting
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -385,12 +385,23 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
+}
+
 static noinline int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
 		       unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	unsigned long pte_end;
-	struct page *head, *page;
+	struct page *head, *page, *tail;
 	pte_t pte;
 	int refs;
 
@@ -413,6 +424,7 @@ static noinline int gup_hugepte(pte_t *p
 	head = pte_page(pte);
 
 	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
+	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -431,6 +443,16 @@ static noinline int gup_hugepte(pte_t *p
 		*nr -= refs;
 		while (refs--)
 			put_page(head);
+	} else {
+		/*
+		 * Any tail page need their mapcount reference taken
+		 * before we return.
+		 */
+		while (refs--) {
+			if (PageTail(tail))
+				get_huge_page_tail(tail);
+			tail++;
+		}
 	}
 
 	return 1;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

