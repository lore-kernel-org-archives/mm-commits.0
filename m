From: akpm@linux-foundation.org
Subject: + thp-implement-refcounting-for-huge-zero-page.patch added to -mm tree
Date: Wed, 14 Nov 2012 13:34:33 -0800
Message-ID: <20121114213434.48BCD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37957 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423472Ab2KNVef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 16:34:35 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so96660yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 13:34:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp: implement refcounting for huge zero page
has been added to the -mm tree.  Its filename is
     thp-implement-refcounting-for-huge-zero-page.patch

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

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  112 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 88 insertions(+), 24 deletions(-)

diff -puN mm/huge_memory.c~thp-implement-refcounting-for-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-implement-refcounting-for-huge-zero-page
+++ a/mm/huge_memory.c
@@ -12,6 +12,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
+#include <linux/shrinker.h>
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
@@ -19,6 +20,7 @@
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/migrate.h>
+
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -48,7 +50,6 @@ static unsigned int khugepaged_scan_slee
 /* during fragmentation poll the hugepage allocator once every minute */
 static unsigned int khugepaged_alloc_sleep_millisecs __read_mostly = 60000;
 static struct task_struct *khugepaged_thread __read_mostly;
-static unsigned long huge_zero_pfn __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 static DEFINE_SPINLOCK(khugepaged_mm_lock);
 static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
@@ -161,31 +162,74 @@ static int start_khugepaged(void)
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
@@ -577,6 +621,8 @@ static int __init hugepage_init(void)
 		goto out;
 	}
 
+	register_shrinker(&huge_zero_page_shrinker);
+
 	/*
 	 * By default disable transparent hugepages on smaller systems,
 	 * where the extra memory used could hurt more than TLB overhead
@@ -706,10 +752,11 @@ static inline struct page *alloc_hugepag
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
@@ -732,15 +779,19 @@ int do_huge_pmd_anonymous_page(struct mm
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
 				goto out;
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
@@ -956,7 +1007,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
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
@@ -1085,6 +1144,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
+	put_huge_zero_page();
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
@@ -1285,8 +1345,10 @@ alloc:
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		update_mmu_cache_pmd(vma, address, pmd);
-		if (is_huge_zero_pmd(orig_pmd))
+		if (is_huge_zero_pmd(orig_pmd)) {
 			add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+			put_huge_zero_page();
+		}
 		if (page) {
 			VM_BUG_ON(!PageHead(page));
 			page_remove_rmap(page);
@@ -1364,6 +1426,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (is_huge_zero_pmd(orig_pmd)) {
 			tlb->mm->nr_ptes--;
 			spin_unlock(&tlb->mm->page_table_lock);
+			put_huge_zero_page();
 		} else {
 			page = pmd_page(orig_pmd);
 			page_remove_rmap(page);
@@ -2669,6 +2732,7 @@ static void __split_huge_zero_page_pmd(s
 	}
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(vma->vm_mm, pmd, pgtable);
+	put_huge_zero_page();
 }
 
 void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch

