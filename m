From: akpm@linux-foundation.org
Subject: + mm-convert-the-rest-to-new-page-table-lock-api.patch added to
 -mm tree
Date: Mon, 07 Oct 2013 16:12:31 -0700
Message-ID: <52533fdf.CAYxtui414qj6OUl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3JGXMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-convert-the-rest-to-new-page-table-lock-api.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:12:31 -0700


The patch titled
     Subject: mm: convert the rest to new page table lock api
has been added to the -mm tree.  Its filename is
     mm-convert-the-rest-to-new-page-table-lock-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-the-rest-to-new-page-table-lock-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-the-rest-to-new-page-table-lock-api.patch

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
Subject: mm: convert the rest to new page table lock api

Only trivial cases left. Let's convert them altogether.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c     |  108 ++++++++++++++++++++++-------------------
 mm/memory.c          |   17 +++---
 mm/migrate.c         |    7 +-
 mm/mprotect.c        |    4 -
 mm/pgtable-generic.c |    4 -
 5 files changed, 77 insertions(+), 63 deletions(-)

diff -puN mm/huge_memory.c~mm-convert-the-rest-to-new-page-table-lock-api mm/huge_memory.c
--- a/mm/huge_memory.c~mm-convert-the-rest-to-new-page-table-lock-api
+++ a/mm/huge_memory.c
@@ -710,6 +710,7 @@ static int __do_huge_pmd_anonymous_page(
 					struct page *page)
 {
 	pgtable_t pgtable;
+	spinlock_t *ptl;
 
 	VM_BUG_ON(!PageCompound(page));
 	pgtable = pte_alloc_one(mm, haddr);
@@ -724,9 +725,9 @@ static int __do_huge_pmd_anonymous_page(
 	 */
 	__SetPageUptodate(page);
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_none(*pmd))) {
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 		mem_cgroup_uncharge_page(page);
 		put_page(page);
 		pte_free(mm, pgtable);
@@ -739,7 +740,7 @@ static int __do_huge_pmd_anonymous_page(
 		set_pmd_at(mm, haddr, pmd, entry);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		atomic_long_inc(&mm->nr_ptes);
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 	}
 
 	return 0;
@@ -759,6 +760,7 @@ static inline struct page *alloc_hugepag
 			       HPAGE_PMD_ORDER, vma, haddr, nd);
 }
 
+/* Caller must hold page table lock. */
 static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
@@ -790,6 +792,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		return VM_FAULT_OOM;
 	if (!(flags & FAULT_FLAG_WRITE) &&
 			transparent_hugepage_use_zero_page()) {
+		spinlock_t *ptl;
 		pgtable_t pgtable;
 		struct page *zero_page;
 		bool set;
@@ -802,10 +805,10 @@ int do_huge_pmd_anonymous_page(struct mm
 			count_vm_event(THP_FAULT_FALLBACK);
 			return VM_FAULT_FALLBACK;
 		}
-		spin_lock(&mm->page_table_lock);
+		ptl = pmd_lock(mm, pmd);
 		set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
 				zero_page);
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 		if (!set) {
 			pte_free(mm, pgtable);
 			put_huge_zero_page();
@@ -838,6 +841,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *vma)
 {
+	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
 	pmd_t pmd;
 	pgtable_t pgtable;
@@ -848,8 +852,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 	if (unlikely(!pgtable))
 		goto out;
 
-	spin_lock(&dst_mm->page_table_lock);
-	spin_lock_nested(&src_mm->page_table_lock, SINGLE_DEPTH_NESTING);
+	dst_ptl = pmd_lock(dst_mm, dst_pmd);
+	src_ptl = pmd_lockptr(src_mm, src_pmd);
+	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	ret = -EAGAIN;
 	pmd = *src_pmd;
@@ -858,7 +863,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 	/*
-	 * mm->page_table_lock is enough to be sure that huge zero pmd is not
+	 * When page table lock is held, the huge zero pmd should not be
 	 * under splitting since we don't split the page itself, only pmd to
 	 * a page table.
 	 */
@@ -879,8 +884,8 @@ int copy_huge_pmd(struct mm_struct *dst_
 	}
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
-		spin_unlock(&src_mm->page_table_lock);
-		spin_unlock(&dst_mm->page_table_lock);
+		spin_unlock(src_ptl);
+		spin_unlock(dst_ptl);
 		pte_free(dst_mm, pgtable);
 
 		wait_split_huge_page(vma->anon_vma, src_pmd); /* src_vma */
@@ -900,8 +905,8 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	ret = 0;
 out_unlock:
-	spin_unlock(&src_mm->page_table_lock);
-	spin_unlock(&dst_mm->page_table_lock);
+	spin_unlock(src_ptl);
+	spin_unlock(dst_ptl);
 out:
 	return ret;
 }
@@ -912,10 +917,11 @@ void huge_pmd_set_accessed(struct mm_str
 			   pmd_t *pmd, pmd_t orig_pmd,
 			   int dirty)
 {
+	spinlock_t *ptl;
 	pmd_t entry;
 	unsigned long haddr;
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto unlock;
 
@@ -925,13 +931,14 @@ void huge_pmd_set_accessed(struct mm_str
 		update_mmu_cache_pmd(vma, address, pmd);
 
 unlock:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 }
 
 static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long address,
 		pmd_t *pmd, pmd_t orig_pmd, unsigned long haddr)
 {
+	spinlock_t *ptl;
 	pgtable_t pgtable;
 	pmd_t _pmd;
 	struct page *page;
@@ -958,7 +965,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto out_free_page;
 
@@ -985,7 +992,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	}
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	put_huge_zero_page();
 	inc_mm_counter(mm, MM_ANONPAGES);
 
@@ -995,7 +1002,7 @@ static int do_huge_pmd_wp_zero_page_fall
 out:
 	return ret;
 out_free_page:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	mem_cgroup_uncharge_page(page);
 	put_page(page);
@@ -1009,6 +1016,7 @@ static int do_huge_pmd_wp_page_fallback(
 					struct page *page,
 					unsigned long haddr)
 {
+	spinlock_t *ptl;
 	pgtable_t pgtable;
 	pmd_t _pmd;
 	int ret = 0, i;
@@ -1055,7 +1063,7 @@ static int do_huge_pmd_wp_page_fallback(
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto out_free_pages;
 	VM_BUG_ON(!PageHead(page));
@@ -1081,7 +1089,7 @@ static int do_huge_pmd_wp_page_fallback(
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	page_remove_rmap(page);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
@@ -1092,7 +1100,7 @@ out:
 	return ret;
 
 out_free_pages:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	mem_cgroup_uncharge_start();
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
@@ -1107,17 +1115,19 @@ out_free_pages:
 int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmd, pmd_t orig_pmd)
 {
+	spinlock_t *ptl;
 	int ret = 0;
 	struct page *page = NULL, *new_page;
 	unsigned long haddr;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
+	ptl = pmd_lockptr(mm, pmd);
 	VM_BUG_ON(!vma->anon_vma);
 	haddr = address & HPAGE_PMD_MASK;
 	if (is_huge_zero_pmd(orig_pmd))
 		goto alloc;
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto out_unlock;
 
@@ -1133,7 +1143,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		goto out_unlock;
 	}
 	get_page(page);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
@@ -1180,11 +1190,11 @@ alloc:
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	if (page)
 		put_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 		mem_cgroup_uncharge_page(new_page);
 		put_page(new_page);
 		goto out_mn;
@@ -1206,13 +1216,13 @@ alloc:
 		}
 		ret |= VM_FAULT_WRITE;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 out_mn:
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 out:
 	return ret;
 out_unlock:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	return ret;
 }
 
@@ -1224,7 +1234,7 @@ struct page *follow_trans_huge_pmd(struc
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
 
-	assert_spin_locked(&mm->page_table_lock);
+	assert_spin_locked(pmd_lockptr(mm, pmd));
 
 	if (flags & FOLL_WRITE && !pmd_write(*pmd))
 		goto out;
@@ -1271,13 +1281,14 @@ out:
 int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp)
 {
+	spinlock_t *ptl;
 	struct page *page;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	int target_nid;
 	int current_nid = -1;
 	bool migrated;
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmdp);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 
@@ -1295,17 +1306,17 @@ int do_huge_pmd_numa_page(struct mm_stru
 	}
 
 	/* Acquire the page lock to serialise THP migrations */
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	lock_page(page);
 
 	/* Confirm the PTE did not while locked */
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		unlock_page(page);
 		put_page(page);
 		goto out_unlock;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 
 	/* Migrate the THP to the requested node */
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
@@ -1317,7 +1328,7 @@ int do_huge_pmd_numa_page(struct mm_stru
 	return 0;
 
 check_same:
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 clear_pmdnuma:
@@ -1326,7 +1337,7 @@ clear_pmdnuma:
 	VM_BUG_ON(pmd_numa(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
 out_unlock:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	if (current_nid != -1)
 		task_numa_fault(current_nid, HPAGE_PMD_NR, false);
 	return 0;
@@ -2312,7 +2323,7 @@ static void collapse_huge_page(struct mm
 	pte_t *pte;
 	pgtable_t pgtable;
 	struct page *new_page;
-	spinlock_t *ptl;
+	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated;
 	unsigned long hstart, hend;
 	unsigned long mmun_start;	/* For mmu_notifiers */
@@ -2355,12 +2366,12 @@ static void collapse_huge_page(struct mm
 	anon_vma_lock_write(vma->anon_vma);
 
 	pte = pte_offset_map(pmd, address);
-	ptl = pte_lockptr(mm, pmd);
+	pte_ptl = pte_lockptr(mm, pmd);
 
 	mmun_start = address;
 	mmun_end   = address + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-	spin_lock(&mm->page_table_lock); /* probably unnecessary */
+	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
 	 * After this gup_fast can't run anymore. This also removes
 	 * any huge TLB entry from the CPU so we won't allow
@@ -2368,16 +2379,16 @@ static void collapse_huge_page(struct mm
 	 * to avoid the risk of CPU bugs in that area.
 	 */
 	_pmd = pmdp_clear_flush(vma, address, pmd);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
-	spin_lock(ptl);
+	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
-	spin_unlock(ptl);
+	spin_unlock(pte_ptl);
 
 	if (unlikely(!isolated)) {
 		pte_unmap(pte);
-		spin_lock(&mm->page_table_lock);
+		spin_lock(pmd_ptl);
 		BUG_ON(!pmd_none(*pmd));
 		/*
 		 * We can only use set_pmd_at when establishing
@@ -2385,7 +2396,7 @@ static void collapse_huge_page(struct mm
 		 * points to regular pagetables. Use pmd_populate for that
 		 */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(pmd_ptl);
 		anon_vma_unlock_write(vma->anon_vma);
 		goto out;
 	}
@@ -2396,7 +2407,7 @@ static void collapse_huge_page(struct mm
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
-	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
+	__collapse_huge_page_copy(pte, new_page, vma, address, pte_ptl);
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
@@ -2411,13 +2422,13 @@ static void collapse_huge_page(struct mm
 	 */
 	smp_wmb();
 
-	spin_lock(&mm->page_table_lock);
+	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(pmd_ptl);
 
 	*hpage = NULL;
 
@@ -2746,6 +2757,7 @@ static void __split_huge_zero_page_pmd(s
 void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
 		pmd_t *pmd)
 {
+	spinlock_t *ptl;
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
@@ -2757,22 +2769,22 @@ void __split_huge_page_pmd(struct vm_are
 	mmun_start = haddr;
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 		return;
 	}
 	if (is_huge_zero_pmd(*pmd)) {
 		__split_huge_zero_page_pmd(vma, haddr, pmd);
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 		return;
 	}
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!page_count(page));
 	get_page(page);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	split_huge_page(page);
diff -puN mm/memory.c~mm-convert-the-rest-to-new-page-table-lock-api mm/memory.c
--- a/mm/memory.c~mm-convert-the-rest-to-new-page-table-lock-api
+++ a/mm/memory.c
@@ -550,6 +550,7 @@ void free_pgtables(struct mmu_gather *tl
 int __pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t *pmd, unsigned long address)
 {
+	spinlock_t *ptl;
 	pgtable_t new = pte_alloc_one(mm, address);
 	int wait_split_huge_page;
 	if (!new)
@@ -570,7 +571,7 @@ int __pte_alloc(struct mm_struct *mm, st
 	 */
 	smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	wait_split_huge_page = 0;
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
 		atomic_long_inc(&mm->nr_ptes);
@@ -578,7 +579,7 @@ int __pte_alloc(struct mm_struct *mm, st
 		new = NULL;
 	} else if (unlikely(pmd_trans_splitting(*pmd)))
 		wait_split_huge_page = 1;
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	if (new)
 		pte_free(mm, new);
 	if (wait_split_huge_page)
@@ -1514,20 +1515,20 @@ struct page *follow_page_mask(struct vm_
 			split_huge_page_pmd(vma, address, pmd);
 			goto split_fallthrough;
 		}
-		spin_lock(&mm->page_table_lock);
+		ptl = pmd_lock(mm, pmd);
 		if (likely(pmd_trans_huge(*pmd))) {
 			if (unlikely(pmd_trans_splitting(*pmd))) {
-				spin_unlock(&mm->page_table_lock);
+				spin_unlock(ptl);
 				wait_split_huge_page(vma->anon_vma, pmd);
 			} else {
 				page = follow_trans_huge_pmd(vma, address,
 							     pmd, flags);
-				spin_unlock(&mm->page_table_lock);
+				spin_unlock(ptl);
 				*page_mask = HPAGE_PMD_NR - 1;
 				goto out;
 			}
 		} else
-			spin_unlock(&mm->page_table_lock);
+			spin_unlock(ptl);
 		/* fall through */
 	}
 split_fallthrough:
@@ -3600,13 +3601,13 @@ static int do_pmd_numa_page(struct mm_st
 	bool numa = false;
 	int local_nid = numa_node_id();
 
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmdp);
 	pmd = *pmdp;
 	if (pmd_numa(pmd)) {
 		set_pmd_at(mm, _addr, pmdp, pmd_mknonnuma(pmd));
 		numa = true;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 
 	if (!numa)
 		return 0;
diff -puN mm/migrate.c~mm-convert-the-rest-to-new-page-table-lock-api mm/migrate.c
--- a/mm/migrate.c~mm-convert-the-rest-to-new-page-table-lock-api
+++ a/mm/migrate.c
@@ -1654,6 +1654,7 @@ int migrate_misplaced_transhuge_page(str
 				unsigned long address,
 				struct page *page, int node)
 {
+	spinlock_t *ptl;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated = 0;
@@ -1700,9 +1701,9 @@ int migrate_misplaced_transhuge_page(str
 	WARN_ON(PageLRU(new_page));
 
 	/* Recheck the target PMD */
-	spin_lock(&mm->page_table_lock);
+	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, entry))) {
-		spin_unlock(&mm->page_table_lock);
+		spin_unlock(ptl);
 
 		/* Reverse changes made by migrate_page_copy() */
 		if (TestClearPageActive(new_page))
@@ -1747,7 +1748,7 @@ int migrate_misplaced_transhuge_page(str
 	 * before it's fully transferred to the new page.
 	 */
 	mem_cgroup_end_migration(memcg, page, new_page, true);
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 
 	unlock_page(new_page);
 	unlock_page(page);
diff -puN mm/mprotect.c~mm-convert-the-rest-to-new-page-table-lock-api mm/mprotect.c
--- a/mm/mprotect.c~mm-convert-the-rest-to-new-page-table-lock-api
+++ a/mm/mprotect.c
@@ -116,9 +116,9 @@ static unsigned long change_pte_range(st
 static inline void change_pmd_protnuma(struct mm_struct *mm, unsigned long addr,
 				       pmd_t *pmd)
 {
-	spin_lock(&mm->page_table_lock);
+	spinlock_t *ptl = pmd_lock(mm, pmd);
 	set_pmd_at(mm, addr & PMD_MASK, pmd, pmd_mknuma(*pmd));
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 }
 #else
 static inline void change_pmd_protnuma(struct mm_struct *mm, unsigned long addr,
diff -puN mm/pgtable-generic.c~mm-convert-the-rest-to-new-page-table-lock-api mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-convert-the-rest-to-new-page-table-lock-api
+++ a/mm/pgtable-generic.c
@@ -151,7 +151,7 @@ void pmdp_splitting_flush(struct vm_area
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				pgtable_t pgtable)
 {
-	assert_spin_locked(&mm->page_table_lock);
+	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
 	if (!pmd_huge_pte(mm, pmdp))
@@ -170,7 +170,7 @@ pgtable_t pgtable_trans_huge_withdraw(st
 {
 	pgtable_t pgtable;
 
-	assert_spin_locked(&mm->page_table_lock);
+	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
 	pgtable = pmd_huge_pte(mm, pmdp);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

