From: akpm@linux-foundation.org
Subject: + mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch added to -mm tree
Date: Thu, 06 Sep 2012 13:08:45 -0700
Message-ID: <20120906200846.843C11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44081 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab2IFUIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 16:08:48 -0400
Received: by ghbz15 with SMTP id z15so233638ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 13:08:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sagig@mellanox.com, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, haggaie@mellanox.com, hughd@google.com, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm: move all mmu notifier invocations to be done outside the PT lock
has been added to the -mm tree.  Its filename is
     mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sagi Grimberg <sagig@mellanox.com>
Subject: mm: move all mmu notifier invocations to be done outside the PT lock

In order to allow sleeping during mmu notifier calls, we need to avoid
invoking them under the page table spinlock.  This patch solves the
problem by calling invalidate_page notification after releasing the lock
(but before freeing the page itself), or by wrapping the page invalidation
with calls to invalidate_range_begin and invalidate_range_end.

To prevent accidental changes to the invalidate_range_end arguments after
the call to invalidate_range_begin, the patch introduces a convention of
saving the arguments in consistently named locals:

	unsigned long mmun_start;	/* For mmu_notifiers */
	unsigned long mmun_end;	/* For mmu_notifiers */

	...

	mmun_start = ...
	mmun_end = ...
	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);

	...

	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);

The patch changes code to use this convention for all calls to
mmu_notifier_invalidate_range_start/end, except those where the calls are
close enough so that anyone who glances at the code can see the values
aren't changing.

This patchset is a preliminary step towards on-demand paging design to be
added to the RDMA stack.

Why do we want on-demand paging for Infiniband?

  Applications register memory with an RDMA adapter using system calls,
  and subsequently post IO operations that refer to the corresponding
  virtual addresses directly to HW.  Until now, this was achieved by
  pinning the memory during the registration calls.  The goal of on demand
  paging is to avoid pinning the pages of registered memory regions (MRs).
   This will allow users the same flexibility they get when swapping any
  other part of their processes address spaces.  Instead of requiring the
  entire MR to fit in physical memory, we can allow the MR to be larger,
  and only fit the current working set in physical memory.

Why should anyone care?  What problems are users currently experiencing?

  This can make programming with RDMA much simpler.  Today, developers
  that are working with more data than their RAM can hold need either to
  deregister and reregister memory regions throughout their process's
  life, or keep a single memory region and copy the data to it.  On demand
  paging will allow these developers to register a single MR at the
  beginning of their process's life, and let the operating system manage
  which pages needs to be fetched at a given time.  In the future, we
  might be able to provide a single memory access key for each process
  that would provide the entire process's address as one large memory
  region, and the developers wouldn't need to register memory regions at
  all.

Is there any prospect that any other subsystems will utilise these
infrastructural changes?  If so, which and how, etc?

  As for other subsystems, I understand that XPMEM wanted to sleep in
  MMU notifiers, as Christoph Lameter wrote at
  http://lkml.indiana.edu/hypermail/linux/kernel/0802.1/0460.html and
  perhaps Andrea knows about other use cases.

  Scheduling in mmu notifications is required since we need to sync the
  hardware with the secondary page tables change.  A TLB flush of an IO
  device is inherently slower than a CPU TLB flush, so our design works by
  sending the invalidation request to the device, and waiting for an
  interrupt before exiting the mmu notifier handler.

Avi said:

  kvm may be a buyer.  kvm::mmu_lock, which serializes guest page
  faults, also protects long operations such as destroying large ranges. 
  It would be good to convert it into a spinlock, but as it is used inside
  mmu notifiers, this cannot be done.

  (there are alternatives, such as keeping the spinlock and using a
  generation counter to do the teardown in O(1), which is what the "may"
  is doing up there).

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Haggai Eran <haggaie@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Liran Liss <liranl@mellanox.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   47 ---------------------------------
 mm/filemap_xip.c             |    4 ++
 mm/huge_memory.c             |   42 +++++++++++++++++++++++++----
 mm/hugetlb.c                 |   21 +++++++++-----
 mm/memory.c                  |   24 +++++++++++-----
 mm/mremap.c                  |    8 ++++-
 mm/rmap.c                    |   18 ++++++++++--
 7 files changed, 90 insertions(+), 74 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/include/linux/mmu_notifier.h
@@ -246,50 +246,6 @@ static inline void mmu_notifier_mm_destr
 		__mmu_notifier_mm_destroy(mm);
 }
 
-/*
- * These two macros will sometime replace ptep_clear_flush.
- * ptep_clear_flush is implemented as macro itself, so this also is
- * implemented as a macro until ptep_clear_flush will converted to an
- * inline function, to diminish the risk of compilation failure. The
- * invalidate_page method over time can be moved outside the PT lock
- * and these two macros can be later removed.
- */
-#define ptep_clear_flush_notify(__vma, __address, __ptep)		\
-({									\
-	pte_t __pte;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	__pte = ptep_clear_flush(___vma, ___address, __ptep);		\
-	mmu_notifier_invalidate_page(___vma->vm_mm, ___address);	\
-	__pte;								\
-})
-
-#define pmdp_clear_flush_notify(__vma, __address, __pmdp)		\
-({									\
-	pmd_t __pmd;							\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	VM_BUG_ON(__address & ~HPAGE_PMD_MASK);				\
-	mmu_notifier_invalidate_range_start(___vma->vm_mm, ___address,	\
-					    (__address)+HPAGE_PMD_SIZE);\
-	__pmd = pmdp_clear_flush(___vma, ___address, __pmdp);		\
-	mmu_notifier_invalidate_range_end(___vma->vm_mm, ___address,	\
-					  (__address)+HPAGE_PMD_SIZE);	\
-	__pmd;								\
-})
-
-#define pmdp_splitting_flush_notify(__vma, __address, __pmdp)		\
-({									\
-	struct vm_area_struct *___vma = __vma;				\
-	unsigned long ___address = __address;				\
-	VM_BUG_ON(__address & ~HPAGE_PMD_MASK);				\
-	mmu_notifier_invalidate_range_start(___vma->vm_mm, ___address,	\
-					    (__address)+HPAGE_PMD_SIZE);\
-	pmdp_splitting_flush(___vma, ___address, __pmdp);		\
-	mmu_notifier_invalidate_range_end(___vma->vm_mm, ___address,	\
-					  (__address)+HPAGE_PMD_SIZE);	\
-})
-
 #define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
 ({									\
 	int __young;							\
@@ -380,9 +336,6 @@ static inline void mmu_notifier_mm_destr
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
-#define ptep_clear_flush_notify ptep_clear_flush
-#define pmdp_clear_flush_notify pmdp_clear_flush
-#define pmdp_splitting_flush_notify pmdp_splitting_flush
 #define set_pte_at_notify set_pte_at
 
 #endif /* CONFIG_MMU_NOTIFIER */
diff -puN mm/filemap_xip.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/mm/filemap_xip.c
@@ -192,11 +192,13 @@ retry:
 		if (pte) {
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
-			pteval = ptep_clear_flush_notify(vma, address, pte);
+			pteval = ptep_clear_flush(vma, address, pte);
 			page_remove_rmap(page);
 			dec_mm_counter(mm, MM_FILEPAGES);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
+			/* must invalidate_page _before_ freeing the page */
+			mmu_notifier_invalidate_page(mm, address);
 			page_cache_release(page);
 		}
 	}
diff -puN mm/huge_memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock mm/huge_memory.c
--- a/mm/huge_memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/mm/huge_memory.c
@@ -787,6 +787,8 @@ static int do_huge_pmd_wp_page_fallback(
 	pmd_t _pmd;
 	int ret = 0, i;
 	struct page **pages;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	pages = kmalloc(sizeof(struct page *) * HPAGE_PMD_NR,
 			GFP_KERNEL);
@@ -823,12 +825,16 @@ static int do_huge_pmd_wp_page_fallback(
 		cond_resched();
 	}
 
+	mmun_start = haddr;
+	mmun_end   = haddr + HPAGE_PMD_SIZE;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto out_free_pages;
 	VM_BUG_ON(!PageHead(page));
 
-	pmdp_clear_flush_notify(vma, haddr, pmd);
+	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
 	pgtable = pgtable_withdraw(mm);
@@ -851,6 +857,8 @@ static int do_huge_pmd_wp_page_fallback(
 	page_remove_rmap(page);
 	spin_unlock(&mm->page_table_lock);
 
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+
 	ret |= VM_FAULT_WRITE;
 	put_page(page);
 
@@ -859,6 +867,7 @@ out:
 
 out_free_pages:
 	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	mem_cgroup_uncharge_start();
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		mem_cgroup_uncharge_page(pages[i]);
@@ -875,6 +884,8 @@ int do_huge_pmd_wp_page(struct mm_struct
 	int ret = 0;
 	struct page *page, *new_page;
 	unsigned long haddr;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	VM_BUG_ON(!vma->anon_vma);
 	spin_lock(&mm->page_table_lock);
@@ -925,20 +936,24 @@ int do_huge_pmd_wp_page(struct mm_struct
 	copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
 
+	mmun_start = haddr;
+	mmun_end   = haddr + HPAGE_PMD_SIZE;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	spin_lock(&mm->page_table_lock);
 	put_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
 		spin_unlock(&mm->page_table_lock);
 		mem_cgroup_uncharge_page(new_page);
 		put_page(new_page);
-		goto out;
+		goto out_mn;
 	} else {
 		pmd_t entry;
 		VM_BUG_ON(!PageHead(page));
 		entry = mk_pmd(new_page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		entry = pmd_mkhuge(entry);
-		pmdp_clear_flush_notify(vma, haddr, pmd);
+		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		update_mmu_cache(vma, address, entry);
@@ -946,10 +961,14 @@ int do_huge_pmd_wp_page(struct mm_struct
 		put_page(page);
 		ret |= VM_FAULT_WRITE;
 	}
-out_unlock:
 	spin_unlock(&mm->page_table_lock);
+out_mn:
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 out:
 	return ret;
+out_unlock:
+	spin_unlock(&mm->page_table_lock);
+	return ret;
 }
 
 struct page *follow_trans_huge_pmd(struct mm_struct *mm,
@@ -1162,7 +1181,11 @@ static int __split_huge_page_splitting(s
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	int ret = 0;
+	/* For mmu_notifiers */
+	const unsigned long mmun_start = address;
+	const unsigned long mmun_end   = address + HPAGE_PMD_SIZE;
 
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG);
@@ -1174,10 +1197,11 @@ static int __split_huge_page_splitting(s
 		 * and it won't wait on the anon_vma->root->mutex to
 		 * serialize against split_huge_page*.
 		 */
-		pmdp_splitting_flush_notify(vma, address, pmd);
+		pmdp_splitting_flush(vma, address, pmd);
 		ret = 1;
 	}
 	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	return ret;
 }
@@ -1901,6 +1925,8 @@ static void collapse_huge_page(struct mm
 	spinlock_t *ptl;
 	int isolated;
 	unsigned long hstart, hend;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1955,6 +1981,9 @@ static void collapse_huge_page(struct mm
 	pte = pte_offset_map(pmd, address);
 	ptl = pte_lockptr(mm, pmd);
 
+	mmun_start = address;
+	mmun_end   = address + HPAGE_PMD_SIZE;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock); /* probably unnecessary */
 	/*
 	 * After this gup_fast can't run anymore. This also removes
@@ -1962,8 +1991,9 @@ static void collapse_huge_page(struct mm
 	 * huge and small TLB entries for the same virtual address
 	 * to avoid the risk of CPU bugs in that area.
 	 */
-	_pmd = pmdp_clear_flush_notify(vma, address, pmd);
+	_pmd = pmdp_clear_flush(vma, address, pmd);
 	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
 	spin_lock(ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
diff -puN mm/hugetlb.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock mm/hugetlb.c
--- a/mm/hugetlb.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/mm/hugetlb.c
@@ -2356,13 +2356,15 @@ void __unmap_hugepage_range(struct mmu_g
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
+	const unsigned long mmun_start = start;	/* For mmu_notifiers */
+	const unsigned long mmun_end   = end;	/* For mmu_notifiers */
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
 	tlb_start_vma(tlb, vma);
-	mmu_notifier_invalidate_range_start(mm, start, end);
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 again:
 	spin_lock(&mm->page_table_lock);
 	for (address = start; address < end; address += sz) {
@@ -2426,7 +2428,7 @@ again:
 		if (address < end && !ref_page)
 			goto again;
 	}
-	mmu_notifier_invalidate_range_end(mm, start, end);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	tlb_end_vma(tlb, vma);
 }
 
@@ -2525,6 +2527,8 @@ static int hugetlb_cow(struct mm_struct 
 	struct page *old_page, *new_page;
 	int avoidcopy;
 	int outside_reserve = 0;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	old_page = pte_page(pte);
 
@@ -2611,6 +2615,9 @@ retry_avoidcopy:
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
 
+	mmun_start = address & huge_page_mask(h);
+	mmun_end   = (address & huge_page_mask(h)) + huge_page_size(h);
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	/*
 	 * Retake the page_table_lock to check for racing updates
 	 * before the page tables are altered
@@ -2619,9 +2626,6 @@ retry_avoidcopy:
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW */
-		mmu_notifier_invalidate_range_start(mm,
-			address & huge_page_mask(h),
-			(address & huge_page_mask(h)) + huge_page_size(h));
 		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
@@ -2629,10 +2633,11 @@ retry_avoidcopy:
 		hugepage_add_new_anon_rmap(new_page, vma, address);
 		/* Make the old page be freed below */
 		new_page = old_page;
-		mmu_notifier_invalidate_range_end(mm,
-			address & huge_page_mask(h),
-			(address & huge_page_mask(h)) + huge_page_size(h));
 	}
+	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	/* Caller expects lock to be held */
+	spin_lock(&mm->page_table_lock);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
 	return 0;
diff -puN mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock mm/memory.c
--- a/mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/mm/memory.c
@@ -1039,6 +1039,8 @@ int copy_page_range(struct mm_struct *ds
 	unsigned long next;
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 	int ret;
 
 	/*
@@ -1072,8 +1074,12 @@ int copy_page_range(struct mm_struct *ds
 	 * parent mm. And a permission downgrade will only happen if
 	 * is_cow_mapping() returns true.
 	 */
-	if (is_cow_mapping(vma->vm_flags))
-		mmu_notifier_invalidate_range_start(src_mm, addr, end);
+	if (is_cow_mapping(vma->vm_flags)) {
+		mmun_start = addr;
+		mmun_end   = end;
+		mmu_notifier_invalidate_range_start(src_mm, mmun_start,
+						    mmun_end);
+	}
 
 	ret = 0;
 	dst_pgd = pgd_offset(dst_mm, addr);
@@ -1090,8 +1096,8 @@ int copy_page_range(struct mm_struct *ds
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
 	if (is_cow_mapping(vma->vm_flags))
-		mmu_notifier_invalidate_range_end(src_mm,
-						  vma->vm_start, end);
+		mmu_notifier_invalidate_range_end(src_mm, mmun_start,
+						  mmun_end);
 	return ret;
 }
 
@@ -2516,7 +2522,7 @@ static int do_wp_page(struct mm_struct *
 		spinlock_t *ptl, pte_t orig_pte)
 	__releases(ptl)
 {
-	struct page *old_page, *new_page;
+	struct page *old_page, *new_page = NULL;
 	pte_t entry;
 	int ret = 0;
 	int page_mkwrite = 0;
@@ -2760,10 +2766,14 @@ gotten:
 	} else
 		mem_cgroup_uncharge_page(new_page);
 
-	if (new_page)
-		page_cache_release(new_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
+	if (new_page) {
+		if (new_page == old_page)
+			/* cow happened, notify before releasing old_page */
+			mmu_notifier_invalidate_page(mm, address);
+		page_cache_release(new_page);
+	}
 	if (old_page) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
diff -puN mm/mremap.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock mm/mremap.c
--- a/mm/mremap.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/mm/mremap.c
@@ -127,11 +127,15 @@ unsigned long move_page_tables(struct vm
 	unsigned long extent, next, old_end;
 	pmd_t *old_pmd, *new_pmd;
 	bool need_flush = false;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
-	mmu_notifier_invalidate_range_start(vma->vm_mm, old_addr, old_end);
+	mmun_start = old_addr;
+	mmun_end   = old_end;
+	mmu_notifier_invalidate_range_start(vma->vm_mm, mmun_start, mmun_end);
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
@@ -175,7 +179,7 @@ unsigned long move_page_tables(struct vm
 	if (likely(need_flush))
 		flush_tlb_range(vma, old_end-len, old_addr);
 
-	mmu_notifier_invalidate_range_end(vma->vm_mm, old_end-len, old_end);
+	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start, mmun_end);
 
 	return len + old_addr - old_end;	/* how much done */
 }
diff -puN mm/rmap.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock mm/rmap.c
--- a/mm/rmap.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock
+++ a/mm/rmap.c
@@ -928,7 +928,7 @@ static int page_mkclean_one(struct page 
 		pte_t entry;
 
 		flush_cache_page(vma, address, pte_pfn(*pte));
-		entry = ptep_clear_flush_notify(vma, address, pte);
+		entry = ptep_clear_flush(vma, address, pte);
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
 		set_pte_at(mm, address, pte, entry);
@@ -936,6 +936,9 @@ static int page_mkclean_one(struct page 
 	}
 
 	pte_unmap_unlock(pte, ptl);
+
+	if (ret)
+		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
 }
@@ -1254,7 +1257,7 @@ int try_to_unmap_one(struct page *page, 
 
 	/* Nuke the page table entry. */
 	flush_cache_page(vma, address, page_to_pfn(page));
-	pteval = ptep_clear_flush_notify(vma, address, pte);
+	pteval = ptep_clear_flush(vma, address, pte);
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
 	if (pte_dirty(pteval))
@@ -1316,6 +1319,8 @@ int try_to_unmap_one(struct page *page, 
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
+	if (ret != SWAP_FAIL)
+		mmu_notifier_invalidate_page(mm, address);
 out:
 	return ret;
 
@@ -1380,6 +1385,8 @@ static int try_to_unmap_cluster(unsigned
 	spinlock_t *ptl;
 	struct page *page;
 	unsigned long address;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 	unsigned long end;
 	int ret = SWAP_AGAIN;
 	int locked_vma = 0;
@@ -1403,6 +1410,10 @@ static int try_to_unmap_cluster(unsigned
 	if (!pmd_present(*pmd))
 		return ret;
 
+	mmun_start = address;
+	mmun_end   = end;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	/*
 	 * If we can acquire the mmap_sem for read, and vma is VM_LOCKED,
 	 * keep the sem while scanning the cluster for mlocking pages.
@@ -1436,7 +1447,7 @@ static int try_to_unmap_cluster(unsigned
 
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pte));
-		pteval = ptep_clear_flush_notify(vma, address, pte);
+		pteval = ptep_clear_flush(vma, address, pte);
 
 		/* If nonlinear, store the file page offset in the pte. */
 		if (page->index != linear_page_index(vma, address))
@@ -1452,6 +1463,7 @@ static int try_to_unmap_cluster(unsigned
 		(*mapcount)--;
 	}
 	pte_unmap_unlock(pte - 1, ptl);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	if (locked_vma)
 		up_read(&vma->vm_mm->mmap_sem);
 	return ret;
_

Patches currently in -mm which might be from sagig@mellanox.com are

mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch

