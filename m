From: akpm@linux-foundation.org
Subject: + thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch added to -mm tree
Date: Wed, 17 Apr 2013 13:00:23 -0700
Message-ID: <20130417200023.8A8CA5AB49F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:46279 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965607Ab3DQUAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 16:00:25 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so202642ggc.4
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 13:00:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, minchan@kernel.org


The patch titled
     Subject: thp: fix huge zero page logic for page with pfn == 0
has been added to the -mm tree.  Its filename is
     thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix huge zero page logic for page with pfn == 0

Current implementation of huge zero page uses pfn value 0 to indicate that
the page hasn't allocated yet.  It assumes that buddy page allocator can't
return page with pfn == 0.

Let's rework the code to store 'struct page *' of huge zero page, not its
pfn.  This way we can avoid the weak assumption.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0
+++ a/mm/huge_memory.c
@@ -163,25 +163,24 @@ static int start_khugepaged(void)
 }
 
 static atomic_t huge_zero_refcount;
-static unsigned long huge_zero_pfn __read_mostly;
+static struct page *huge_zero_page __read_mostly;
 
-static inline bool is_huge_zero_pfn(unsigned long pfn)
+static inline bool is_huge_zero_page(struct page *page)
 {
-	unsigned long zero_pfn = ACCESS_ONCE(huge_zero_pfn);
-	return zero_pfn && pfn == zero_pfn;
+	return ACCESS_ONCE(huge_zero_page) == page;
 }
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return is_huge_zero_pfn(pmd_pfn(pmd));
+	return is_huge_zero_page(pmd_page(pmd));
 }
 
-static unsigned long get_huge_zero_page(void)
+static struct page *get_huge_zero_page(void)
 {
 	struct page *zero_page;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return ACCESS_ONCE(huge_zero_pfn);
+		return ACCESS_ONCE(huge_zero_page);
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
@@ -191,7 +190,7 @@ retry:
 	}
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
-	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
+	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
 		preempt_enable();
 		__free_page(zero_page);
 		goto retry;
@@ -200,7 +199,7 @@ retry:
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
 	preempt_enable();
-	return ACCESS_ONCE(huge_zero_pfn);
+	return ACCESS_ONCE(huge_zero_page);
 }
 
 static void put_huge_zero_page(void)
@@ -220,9 +219,9 @@ static int shrink_huge_zero_page(struct
 		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
 
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		unsigned long zero_pfn = xchg(&huge_zero_pfn, 0);
-		BUG_ON(zero_pfn == 0);
-		__free_page(__pfn_to_page(zero_pfn));
+		struct page *zero_page = xchg(&huge_zero_page, NULL);
+		BUG_ON(zero_page == NULL);
+		__free_page(zero_page);
 	}
 
 	return 0;
@@ -764,12 +763,12 @@ static inline struct page *alloc_hugepag
 
 static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
-		unsigned long zero_pfn)
+		struct page *zero_page)
 {
 	pmd_t entry;
 	if (!pmd_none(*pmd))
 		return false;
-	entry = pfn_pmd(zero_pfn, vma->vm_page_prot);
+	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
@@ -794,20 +793,20 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (!(flags & FAULT_FLAG_WRITE) &&
 				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
-			unsigned long zero_pfn;
+			struct page *zero_page;
 			bool set;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				return VM_FAULT_OOM;
-			zero_pfn = get_huge_zero_page();
-			if (unlikely(!zero_pfn)) {
+			zero_page = get_huge_zero_page();
+			if (unlikely(!zero_page)) {
 				pte_free(mm, pgtable);
 				count_vm_event(THP_FAULT_FALLBACK);
 				goto out;
 			}
 			spin_lock(&mm->page_table_lock);
 			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
-					zero_pfn);
+					zero_page);
 			spin_unlock(&mm->page_table_lock);
 			if (!set) {
 				pte_free(mm, pgtable);
@@ -886,16 +885,16 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * a page table.
 	 */
 	if (is_huge_zero_pmd(pmd)) {
-		unsigned long zero_pfn;
+		struct page *zero_page;
 		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		zero_pfn = get_huge_zero_page();
+		zero_page = get_huge_zero_page();
 		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
-				zero_pfn);
+				zero_page);
 		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
@@ -1812,7 +1811,7 @@ int split_huge_page_to_list(struct page
 	struct anon_vma *anon_vma;
 	int ret = 1;
 
-	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
+	BUG_ON(is_huge_zero_page(page));
 	BUG_ON(!PageAnon(page));
 
 	/*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch

