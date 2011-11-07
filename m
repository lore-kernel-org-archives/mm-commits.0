From: akpm@linux-foundation.org
Subject: [merged] s390-gup_huge_pmd-support-thp-tail-recounting.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:19 -0800
Message-ID: <201111072025.pA7KPJps011151@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1KGUZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, david@gibson.dropbear.id.au, heiko.carstens@de.ibm.com, hughd@google.com, jweiner@redhat.co


The patch titled
     Subject: s390: gup_huge_pmd() support THP tail recounting
has been removed from the -mm tree.  Its filename was
     s390-gup_huge_pmd-support-thp-tail-recounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: s390: gup_huge_pmd() support THP tail recounting

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
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gup.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN arch/s390/mm/gup.c~s390-gup_huge_pmd-support-thp-tail-recounting arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~s390-gup_huge_pmd-support-thp-tail-recounting
+++ a/arch/s390/mm/gup.c
@@ -48,11 +48,22 @@ static inline int gup_pte_range(pmd_t *p
 	return 1;
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
 static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long mask, result;
-	struct page *head, *page;
+	struct page *head, *page, *tail;
 	int refs;
 
 	result = write ? 0 : _SEGMENT_ENTRY_RO;
@@ -64,6 +75,7 @@ static inline int gup_huge_pmd(pmd_t *pm
 	refs = 0;
 	head = pmd_page(pmd);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -81,6 +93,16 @@ static inline int gup_huge_pmd(pmd_t *pm
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

