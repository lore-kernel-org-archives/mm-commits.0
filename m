From: akpm@linux-foundation.org
Subject: [patch 066/127] thp: reduce usage of huge zero page's atomic
 counter
Date: Fri, 07 Oct 2016 17:00:08 -0700
Message-ID: <57f83708.UIQsswwm629/WzyY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756956AbcJHAAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aaron.lu@intel.com, aarcange@redhat.com, dave.hansen@intel.com, ebru.akagunduz@gmail.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, sergey.senozhatsky@gmail.com, tim.c.chen@linux.intel.com, vbabka@suse.cz, ying.huang@intel.com

From: Aaron Lu <aaron.lu@intel.com>
Subject: thp: reduce usage of huge zero page's atomic counter

The global zero page is used to satisfy an anonymous read fault.  If
THP(Transparent HugePage) is enabled then the global huge zero page is
used.  The global huge zero page uses an atomic counter for reference
counting and is allocated/freed dynamically according to its counter
value.

CPU time spent on that counter will greatly increase if there are a lot of
processes doing anonymous read faults.  This patch proposes a way to
reduce the access to the global counter so that the CPU load can be
reduced accordingly.

To do this, a new flag of the mm_struct is introduced:
MMF_USED_HUGE_ZERO_PAGE.  With this flag, the process only need to touch
the global counter in two cases:

1 The first time it uses the global huge zero page;
2 The time when mm_user of its mm_struct reaches zero.

Note that right now, the huge zero page is eligible to be freed as soon as
its last use goes away.  With this patch, the page will not be eligible to
be freed until the exit of the last process from which it was ever used.

And with the use of mm_user, the kthread is not eligible to use huge zero
page either.  Since no kthread is using huge zero page today, there is no
difference after applying this patch.  But if that is not desired, I can
change it to when mm_count reaches zero.

Case used for test on Haswell EP:
usemem -n 72 --readonly -j 0x200000 100G
Which spawns 72 processes and each will mmap 100G anonymous space and
then do read only access to that space sequentially with a step of 2MB.

CPU cycles from perf report for base commit:
    54.03%  usemem   [kernel.kallsyms]   [k] get_huge_zero_page
CPU cycles from perf report for this commit:
     0.11%  usemem   [kernel.kallsyms]   [k] mm_get_huge_zero_page

Performance(throughput) of the workload for base commit: 1784430792
Performance(throughput) of the workload for this commit: 4726928591
164% increase.

Runtime of the workload for base commit: 707592 us
Runtime of the workload for this commit: 303970 us
50% drop.

Link: http://lkml.kernel.org/r/fe51a88f-446a-4622-1363-ad1282d71385@intel.com
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                |    2 +-
 include/linux/huge_mm.h |    8 ++++----
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    1 +
 mm/huge_memory.c        |   36 +++++++++++++++++++++++++-----------
 mm/swap.c               |    4 +---
 mm/swap_state.c         |    4 +---
 7 files changed, 34 insertions(+), 22 deletions(-)

diff -puN fs/dax.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter fs/dax.c
--- a/fs/dax.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/fs/dax.c
@@ -1036,7 +1036,7 @@ int dax_pmd_fault(struct vm_area_struct
 	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
-		struct page *zero_page = get_huge_zero_page();
+		struct page *zero_page = mm_get_huge_zero_page(vma->vm_mm);
 
 		if (unlikely(!zero_page)) {
 			dax_pmd_dbg(&bh, address, "no zero page");
diff -puN include/linux/huge_mm.h~thp-reduce-usage-of-huge-zero-pages-atomic-counter include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/include/linux/huge_mm.h
@@ -156,8 +156,8 @@ static inline bool is_huge_zero_pmd(pmd_
 	return is_huge_zero_page(pmd_page(pmd));
 }
 
-struct page *get_huge_zero_page(void);
-void put_huge_zero_page(void);
+struct page *mm_get_huge_zero_page(struct mm_struct *mm);
+void mm_put_huge_zero_page(struct mm_struct *mm);
 
 #define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
 
@@ -220,9 +220,9 @@ static inline bool is_huge_zero_page(str
 	return false;
 }
 
-static inline void put_huge_zero_page(void)
+static inline void mm_put_huge_zero_page(struct mm_struct *mm)
 {
-	BUILD_BUG();
+	return;
 }
 
 static inline struct page *follow_devmap_pmd(struct vm_area_struct *vma,
diff -puN include/linux/sched.h~thp-reduce-usage-of-huge-zero-pages-atomic-counter include/linux/sched.h
--- a/include/linux/sched.h~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/include/linux/sched.h
@@ -526,6 +526,7 @@ static inline int get_dumpable(struct mm
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
+#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN kernel/fork.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter kernel/fork.c
--- a/kernel/fork.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/kernel/fork.c
@@ -854,6 +854,7 @@ static inline void __mmput(struct mm_str
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
 	exit_mmap(mm);
+	mm_put_huge_zero_page(mm);
 	set_mm_exe_file(mm, NULL);
 	if (!list_empty(&mm->mmlist)) {
 		spin_lock(&mmlist_lock);
diff -puN mm/huge_memory.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/mm/huge_memory.c
@@ -59,7 +59,7 @@ static struct shrinker deferred_split_sh
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 
-struct page *get_huge_zero_page(void)
+static struct page *get_huge_zero_page(void)
 {
 	struct page *zero_page;
 retry:
@@ -86,7 +86,7 @@ retry:
 	return READ_ONCE(huge_zero_page);
 }
 
-void put_huge_zero_page(void)
+static void put_huge_zero_page(void)
 {
 	/*
 	 * Counter should never go to zero here. Only shrinker can put
@@ -95,6 +95,26 @@ void put_huge_zero_page(void)
 	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
+struct page *mm_get_huge_zero_page(struct mm_struct *mm)
+{
+	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
+		return READ_ONCE(huge_zero_page);
+
+	if (!get_huge_zero_page())
+		return NULL;
+
+	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
+		put_huge_zero_page();
+
+	return READ_ONCE(huge_zero_page);
+}
+
+void mm_put_huge_zero_page(struct mm_struct *mm)
+{
+	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
+		put_huge_zero_page();
+}
+
 static unsigned long shrink_huge_zero_page_count(struct shrinker *shrink,
 					struct shrink_control *sc)
 {
@@ -644,7 +664,7 @@ int do_huge_pmd_anonymous_page(struct fa
 		pgtable = pte_alloc_one(vma->vm_mm, haddr);
 		if (unlikely(!pgtable))
 			return VM_FAULT_OOM;
-		zero_page = get_huge_zero_page();
+		zero_page = mm_get_huge_zero_page(vma->vm_mm);
 		if (unlikely(!zero_page)) {
 			pte_free(vma->vm_mm, pgtable);
 			count_vm_event(THP_FAULT_FALLBACK);
@@ -666,10 +686,8 @@ int do_huge_pmd_anonymous_page(struct fa
 			}
 		} else
 			spin_unlock(fe->ptl);
-		if (!set) {
+		if (!set)
 			pte_free(vma->vm_mm, pgtable);
-			put_huge_zero_page();
-		}
 		return ret;
 	}
 	gfp = alloc_hugepage_direct_gfpmask(vma);
@@ -823,7 +841,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		zero_page = get_huge_zero_page();
+		zero_page = mm_get_huge_zero_page(dst_mm);
 		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
 				zero_page);
 		ret = 0;
@@ -1081,7 +1099,6 @@ alloc:
 		update_mmu_cache_pmd(vma, fe->address, fe->pmd);
 		if (!page) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-			put_huge_zero_page();
 		} else {
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 			page_remove_rmap(page, true);
@@ -1542,7 +1559,6 @@ static void __split_huge_zero_page_pmd(s
 	}
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-	put_huge_zero_page();
 }
 
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
@@ -1565,8 +1581,6 @@ static void __split_huge_pmd_locked(stru
 
 	if (!vma_is_anonymous(vma)) {
 		_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
-		if (is_huge_zero_pmd(_pmd))
-			put_huge_zero_page();
 		if (vma_is_dax(vma))
 			return;
 		page = pmd_page(_pmd);
diff -puN mm/swap.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter mm/swap.c
--- a/mm/swap.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/mm/swap.c
@@ -748,10 +748,8 @@ void release_pages(struct page **pages,
 			locked_pgdat = NULL;
 		}
 
-		if (is_huge_zero_page(page)) {
-			put_huge_zero_page();
+		if (is_huge_zero_page(page))
 			continue;
-		}
 
 		page = compound_head(page);
 		if (!put_page_testzero(page))
diff -puN mm/swap_state.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter mm/swap_state.c
--- a/mm/swap_state.c~thp-reduce-usage-of-huge-zero-pages-atomic-counter
+++ a/mm/swap_state.c
@@ -254,9 +254,7 @@ static inline void free_swap_cache(struc
 void free_page_and_swap_cache(struct page *page)
 {
 	free_swap_cache(page);
-	if (is_huge_zero_page(page))
-		put_huge_zero_page();
-	else
+	if (!is_huge_zero_page(page))
 		put_page(page);
 }
 
_
