From: akpm@linux-foundation.org
Subject: [merged] thp-implement-refcounting-for-huge-zero-page.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:36 -0800
Message-ID: <20121214232737.5029A200086@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:57717 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2LNX1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:41 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so209635lbc.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, lliubbo@gmail.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: implement refcounting for huge zero page
has been removed from the -mm tree.  Its filename was
     thp-implement-refcounting-for-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: implement refcounting for huge zero page

H.  Peter Anvin doesn't like huge zero page which sticks in memory forever
after the first allocation.  Here's implementation of lockless refcounting
for huge zero page.

We have two basic primitives: {get,put}_huge_zero_page(). They
manipulate reference counter.

If counter is 0, get_huge_zero_page() allocates a new huge page and takes
two references: one for caller and one for shrinker.  We free the page
only in shrinker callback if counter is 1 (only shrinker has the
reference).

put_huge_zero_page() only decrements counter.  Counter is never zero in
put_huge_zero_page() since shrinker holds on reference.

Freeing huge zero page in shrinker callback helps to avoid frequent
allocate-free.

Refcounting has cost.  On 4 socket machine I observe ~1% slowdown on
parallel (40 processes) read page faulting comparing to lazy huge page
allocation.  I think it's pretty reasonable for synthetic benchmark.

[lliubbo@gmail.com: fix mismerge]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  113 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 88 insertions(+), 25 deletions(-)

diff -puN mm/huge_memory.c~thp-implement-refcounting-for-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-implement-refcounting-for-huge-zero-page
+++ a/mm/huge_memory.c
@@ -12,12 +12,14 @@
 #include <linux/mmu_notifier.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
+#include <linux/shrinker.h>
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
+
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -47,7 +49,6 @@ static unsigned int khugepaged_scan_slee
 /* during fragmentation poll the hugepage allocator once every minute */
 static unsigned int khugepaged_alloc_sleep_millisecs __read_mostly = 60000;
 static struct task_struct *khugepaged_thread __read_mostly;
-static unsigned long huge_zero_pfn __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 static DEFINE_SPINLOCK(khugepaged_mm_lock);
 static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
@@ -160,31 +161,74 @@ static int start_khugepaged(void)
 	return err;
 }
 
-static int init_huge_zero_pfn(void)
+static atomic_t huge_zero_refcount;
+static unsigned long huge_zero_pfn __read_mostly;
+
+static inline bool is_huge_zero_pfn(unsigned long pfn)
 {
-	struct page *hpage;
-	unsigned long pfn;
+	unsigned long zero_pfn = ACCESS_ONCE(huge_zero_pfn);
+	return zero_pfn && pfn == zero_pfn;
+}
 
-	hpage = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+static inline bool is_huge_zero_pmd(pmd_t pmd)
+{
+	return is_huge_zero_pfn(pmd_pfn(pmd));
+}
+
+static unsigned long get_huge_zero_page(void)
+{
+	struct page *zero_page;
+retry:
+	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
+		return ACCESS_ONCE(huge_zero_pfn);
+
+	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
-	if (!hpage)
-		return -ENOMEM;
-	pfn = page_to_pfn(hpage);
-	if (cmpxchg(&huge_zero_pfn, 0, pfn))
-		__free_page(hpage);
-	return 0;
+	if (!zero_page)
+		return 0;
+	preempt_disable();
+	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
+		preempt_enable();
+		__free_page(zero_page);
+		goto retry;
+	}
+
+	/* We take additional reference here. It will be put back by shrinker */
+	atomic_set(&huge_zero_refcount, 2);
+	preempt_enable();
+	return ACCESS_ONCE(huge_zero_pfn);
 }
 
-static inline bool is_huge_zero_pfn(unsigned long pfn)
+static void put_huge_zero_page(void)
 {
-	return huge_zero_pfn && pfn == huge_zero_pfn;
+	/*
+	 * Counter should never go to zero here. Only shrinker can put
+	 * last reference.
+	 */
+	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
-static inline bool is_huge_zero_pmd(pmd_t pmd)
+static int shrink_huge_zero_page(struct shrinker *shrink,
+		struct shrink_control *sc)
 {
-	return is_huge_zero_pfn(pmd_pfn(pmd));
+	if (!sc->nr_to_scan)
+		/* we can free zero page only if last reference remains */
+		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+
+	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
+		unsigned long zero_pfn = xchg(&huge_zero_pfn, 0);
+		BUG_ON(zero_pfn == 0);
+		__free_page(__pfn_to_page(zero_pfn));
+	}
+
+	return 0;
 }
 
+static struct shrinker huge_zero_page_shrinker = {
+	.shrink = shrink_huge_zero_page,
+	.seeks = DEFAULT_SEEKS,
+};
+
 #ifdef CONFIG_SYSFS
 
 static ssize_t double_flag_show(struct kobject *kobj,
@@ -576,6 +620,8 @@ static int __init hugepage_init(void)
 		goto out;
 	}
 
+	register_shrinker(&huge_zero_page_shrinker);
+
 	/*
 	 * By default disable transparent hugepages on smaller systems,
 	 * where the extra memory used could hurt more than TLB overhead
@@ -705,10 +751,11 @@ static inline struct page *alloc_hugepag
 #endif
 
 static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd)
+		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
+		unsigned long zero_pfn)
 {
 	pmd_t entry;
-	entry = pfn_pmd(huge_zero_pfn, vma->vm_page_prot);
+	entry = pfn_pmd(zero_pfn, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
@@ -731,15 +778,19 @@ int do_huge_pmd_anonymous_page(struct mm
 			return VM_FAULT_OOM;
 		if (!(flags & FAULT_FLAG_WRITE)) {
 			pgtable_t pgtable;
-			if (unlikely(!huge_zero_pfn && init_huge_zero_pfn())) {
-				count_vm_event(THP_FAULT_FALLBACK);
-				goto out;
-			}
+			unsigned long zero_pfn;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				return VM_FAULT_OOM;
+			zero_pfn = get_huge_zero_page();
+			if (unlikely(!zero_pfn)) {
+				pte_free(mm, pgtable);
+				count_vm_event(THP_FAULT_FALLBACK);
+				goto out;
+			}
 			spin_lock(&mm->page_table_lock);
-			set_huge_zero_page(pgtable, mm, vma, haddr, pmd);
+			set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
+					zero_pfn);
 			spin_unlock(&mm->page_table_lock);
 			return 0;
 		}
@@ -813,7 +864,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * a page table.
 	 */
 	if (is_huge_zero_pmd(pmd)) {
-		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
+		unsigned long zero_pfn;
+		/*
+		 * get_huge_zero_page() will never allocate a new page here,
+		 * since we already have a zero page to copy. It just takes a
+		 * reference.
+		 */
+		zero_pfn = get_huge_zero_page();
+		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
+				zero_pfn);
 		ret = 0;
 		goto out_unlock;
 	}
@@ -923,6 +982,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
+	put_huge_zero_page();
 	inc_mm_counter(mm, MM_ANONPAGES);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
@@ -1123,9 +1183,10 @@ alloc:
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		update_mmu_cache_pmd(vma, address, pmd);
-		if (is_huge_zero_pmd(orig_pmd))
+		if (is_huge_zero_pmd(orig_pmd)) {
 			add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		else {
+			put_huge_zero_page();
+		} else {
 			VM_BUG_ON(!PageHead(page));
 			page_remove_rmap(page);
 			put_page(page);
@@ -1202,6 +1263,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (is_huge_zero_pmd(orig_pmd)) {
 			tlb->mm->nr_ptes--;
 			spin_unlock(&tlb->mm->page_table_lock);
+			put_huge_zero_page();
 		} else {
 			page = pmd_page(orig_pmd);
 			page_remove_rmap(page);
@@ -2511,6 +2573,7 @@ static void __split_huge_zero_page_pmd(s
 	}
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
+	put_huge_zero_page();
 }
 
 void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

