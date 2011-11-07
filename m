From: akpm@linux-foundation.org
Subject: [merged] thp-share-get_huge_page_tail.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:25:37 -0800
Message-ID: <201111072025.pA7KPbEO027463@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1KGUZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:25:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, david@gibson.dropbear.id.au, heiko.carstens@de.ibm.com, hughd@google.com, jweiner@redhat.co


The patch titled
     Subject: thp: share get_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     thp-share-get_huge_page_tail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp: share get_huge_page_tail()

This avoids duplicating the function in every arch gup_fast.

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

 arch/powerpc/mm/hugetlbpage.c |   11 -----------
 arch/s390/mm/gup.c            |   11 -----------
 arch/sparc/mm/gup.c           |   11 -----------
 arch/x86/mm/gup.c             |   11 -----------
 include/linux/mm.h            |   11 +++++++++++
 5 files changed, 11 insertions(+), 44 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~thp-share-get_huge_page_tail arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~thp-share-get_huge_page_tail
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -385,17 +385,6 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
-
 static noinline int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
 		       unsigned long end, int write, struct page **pages, int *nr)
 {
diff -puN arch/s390/mm/gup.c~thp-share-get_huge_page_tail arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~thp-share-get_huge_page_tail
+++ a/arch/s390/mm/gup.c
@@ -48,17 +48,6 @@ static inline int gup_pte_range(pmd_t *p
 	return 1;
 }
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
-
 static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
diff -puN arch/sparc/mm/gup.c~thp-share-get_huge_page_tail arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~thp-share-get_huge_page_tail
+++ a/arch/sparc/mm/gup.c
@@ -12,17 +12,6 @@
 #include <linux/rwsem.h>
 #include <asm/pgtable.h>
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
-
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
diff -puN arch/x86/mm/gup.c~thp-share-get_huge_page_tail arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~thp-share-get_huge_page_tail
+++ a/arch/x86/mm/gup.c
@@ -108,17 +108,6 @@ static inline void get_head_page_multipl
 	SetPageReferenced(page);
 }
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
-
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
diff -puN include/linux/mm.h~thp-share-get_huge_page_tail include/linux/mm.h
--- a/include/linux/mm.h~thp-share-get_huge_page_tail
+++ a/include/linux/mm.h
@@ -376,6 +376,17 @@ static inline int page_count(struct page
 	return atomic_read(&compound_head(page)->_count);
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
 extern bool __get_page_tail(struct page *page);
 
 static inline void get_page(struct page *page)
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

