From: akpm@linux-foundation.org
Subject: + mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch added
 to -mm tree
Date: Mon, 07 Oct 2013 16:10:19 -0700
Message-ID: <52533f5b.Q1XoRrXfusv71DV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3JGXKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:10:18 -0700


The patch titled
     Subject: mm, hugetlb: convert hugetlbfs to use split pmd lock
has been added to the -mm tree.  Its filename is
     mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch

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
Subject: mm, hugetlb: convert hugetlbfs to use split pmd lock

Hugetlb supports multiple page sizes. We use split lock only for PMD
level, but not for PUD.

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

 fs/proc/meminfo.c       |    2 
 include/linux/hugetlb.h |   25 ++++++++
 include/linux/swapops.h |    7 +-
 mm/hugetlb.c            |  108 ++++++++++++++++++++++----------------
 mm/mempolicy.c          |    5 +
 mm/migrate.c            |    7 +-
 mm/rmap.c               |    2 
 7 files changed, 103 insertions(+), 53 deletions(-)

diff -puN fs/proc/meminfo.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/fs/proc/meminfo.c
@@ -1,8 +1,8 @@
 #include <linux/fs.h>
-#include <linux/hugetlb.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmzone.h>
 #include <linux/proc_fs.h>
diff -puN include/linux/hugetlb.h~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/include/linux/hugetlb.h
@@ -392,6 +392,15 @@ static inline int hugepage_migration_sup
 	return pmd_huge_support() && (huge_page_shift(h) == PMD_SHIFT);
 }
 
+static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
+               struct mm_struct *mm, pte_t *pte)
+{
+       if (huge_page_size(h) == PMD_SIZE)
+               return pmd_lockptr(mm, (pmd_t *) pte);
+       VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);
+       return &mm->page_table_lock;
+}
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
@@ -401,6 +410,7 @@ struct hstate {};
 #define hstate_sizelog(s) NULL
 #define hstate_vma(v) NULL
 #define hstate_inode(i) NULL
+#define page_hstate(page) NULL
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
 #define vma_kernel_pagesize(v) PAGE_SIZE
@@ -421,6 +431,21 @@ static inline pgoff_t basepage_index(str
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
 #define pmd_huge_support()	0
 #define hugepage_migration_support(h)	0
+
+static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
+               struct mm_struct *mm, pte_t *pte)
+{
+       return &mm->page_table_lock;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
+static inline spinlock_t *huge_pte_lock(struct hstate *h,
+               struct mm_struct *mm, pte_t *pte)
+{
+       spinlock_t *ptl;
+       ptl = huge_pte_lockptr(h, mm, pte);
+       spin_lock(ptl);
+       return ptl;
+}
+
 #endif /* _LINUX_HUGETLB_H */
diff -puN include/linux/swapops.h~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock include/linux/swapops.h
--- a/include/linux/swapops.h~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/include/linux/swapops.h
@@ -139,7 +139,8 @@ static inline void make_migration_entry_
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-extern void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte);
+extern void migration_entry_wait_huge(struct vm_area_struct *vma,
+		struct mm_struct *mm, pte_t *pte);
 #else
 
 #define make_migration_entry(page, write) swp_entry(0, 0)
@@ -151,8 +152,8 @@ static inline int is_migration_entry(swp
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
-static inline void migration_entry_wait_huge(struct mm_struct *mm,
-					pte_t *pte) { }
+static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
+		struct mm_struct *mm, pte_t *pte) { }
 static inline int is_write_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff -puN mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/mm/hugetlb.c
@@ -2362,6 +2362,7 @@ int copy_hugetlb_page_range(struct mm_st
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
+		spinlock_t *src_ptl, *dst_ptl;
 		src_pte = huge_pte_offset(src, addr);
 		if (!src_pte)
 			continue;
@@ -2373,8 +2374,9 @@ int copy_hugetlb_page_range(struct mm_st
 		if (dst_pte == src_pte)
 			continue;
 
-		spin_lock(&dst->page_table_lock);
-		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
+		dst_ptl = huge_pte_lock(h, dst, dst_pte);
+		src_ptl = huge_pte_lockptr(h, src, src_pte);
+		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		if (!huge_pte_none(huge_ptep_get(src_pte))) {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
@@ -2384,8 +2386,8 @@ int copy_hugetlb_page_range(struct mm_st
 			page_dup_rmap(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		}
-		spin_unlock(&src->page_table_lock);
-		spin_unlock(&dst->page_table_lock);
+		spin_unlock(src_ptl);
+		spin_unlock(dst_ptl);
 	}
 	return 0;
 
@@ -2428,6 +2430,7 @@ void __unmap_hugepage_range(struct mmu_g
 	unsigned long address;
 	pte_t *ptep;
 	pte_t pte;
+	spinlock_t *ptl;
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
@@ -2441,25 +2444,25 @@ void __unmap_hugepage_range(struct mmu_g
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 again:
-	spin_lock(&mm->page_table_lock);
 	for (address = start; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
 
+		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, &address, ptep))
-			continue;
+			goto unlock;
 
 		pte = huge_ptep_get(ptep);
 		if (huge_pte_none(pte))
-			continue;
+			goto unlock;
 
 		/*
 		 * HWPoisoned hugepage is already unmapped and dropped reference
 		 */
 		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
 			huge_pte_clear(mm, address, ptep);
-			continue;
+			goto unlock;
 		}
 
 		page = pte_page(pte);
@@ -2470,7 +2473,7 @@ again:
 		 */
 		if (ref_page) {
 			if (page != ref_page)
-				continue;
+				goto unlock;
 
 			/*
 			 * Mark the VMA as having unmapped its page so that
@@ -2487,13 +2490,18 @@ again:
 
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
-		if (force_flush)
+		if (force_flush) {
+			spin_unlock(ptl);
 			break;
+		}
 		/* Bail out after unmapping reference page if supplied */
-		if (ref_page)
+		if (ref_page) {
+			spin_unlock(ptl);
 			break;
+		}
+unlock:
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	/*
 	 * mmu_gather ran out of room to batch pages, we break out of
 	 * the PTE lock to avoid doing the potential expensive TLB invalidate
@@ -2599,7 +2607,7 @@ static int unmap_ref_private(struct mm_s
  */
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pte_t pte,
-			struct page *pagecache_page)
+			struct page *pagecache_page, spinlock_t *ptl)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
@@ -2633,8 +2641,8 @@ retry_avoidcopy:
 
 	page_cache_get(old_page);
 
-	/* Drop page_table_lock as buddy allocator may be called */
-	spin_unlock(&mm->page_table_lock);
+	/* Drop page table lock as buddy allocator may be called */
+	spin_unlock(ptl);
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
@@ -2652,12 +2660,12 @@ retry_avoidcopy:
 			BUG_ON(huge_pte_none(pte));
 			if (unmap_ref_private(mm, vma, old_page, address)) {
 				BUG_ON(huge_pte_none(pte));
-				spin_lock(&mm->page_table_lock);
+				spin_lock(ptl);
 				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 				if (likely(pte_same(huge_ptep_get(ptep), pte)))
 					goto retry_avoidcopy;
 				/*
-				 * race occurs while re-acquiring page_table_lock, and
+				 * race occurs while re-acquiring page table lock, and
 				 * our job is done.
 				 */
 				return 0;
@@ -2666,7 +2674,7 @@ retry_avoidcopy:
 		}
 
 		/* Caller expects lock to be held */
-		spin_lock(&mm->page_table_lock);
+		spin_lock(ptl);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
 		else
@@ -2681,7 +2689,7 @@ retry_avoidcopy:
 		page_cache_release(new_page);
 		page_cache_release(old_page);
 		/* Caller expects lock to be held */
-		spin_lock(&mm->page_table_lock);
+		spin_lock(ptl);
 		return VM_FAULT_OOM;
 	}
 
@@ -2693,10 +2701,10 @@ retry_avoidcopy:
 	mmun_end = mmun_start + huge_page_size(h);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	/*
-	 * Retake the page_table_lock to check for racing updates
+	 * Retake the page table lock to check for racing updates
 	 * before the page tables are altered
 	 */
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		ClearPagePrivate(new_page);
@@ -2710,13 +2718,13 @@ retry_avoidcopy:
 		/* Make the old page be freed below */
 		new_page = old_page;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
 
 	/* Caller expects lock to be held */
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	return 0;
 }
 
@@ -2764,6 +2772,7 @@ static int hugetlb_no_page(struct mm_str
 	struct page *page;
 	struct address_space *mapping;
 	pte_t new_pte;
+	spinlock_t *ptl;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -2850,7 +2859,8 @@ retry:
 			goto backout_unlocked;
 		}
 
-	spin_lock(&mm->page_table_lock);
+	ptl = huge_pte_lockptr(h, mm, ptep);
+	spin_lock(ptl);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
 	if (idx >= size)
 		goto backout;
@@ -2871,16 +2881,16 @@ retry:
 
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, page);
+		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, page, ptl);
 	}
 
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	unlock_page(page);
 out:
 	return ret;
 
 backout:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 backout_unlocked:
 	unlock_page(page);
 	put_page(page);
@@ -2892,6 +2902,7 @@ int hugetlb_fault(struct mm_struct *mm,
 {
 	pte_t *ptep;
 	pte_t entry;
+	spinlock_t *ptl;
 	int ret;
 	struct page *page = NULL;
 	struct page *pagecache_page = NULL;
@@ -2904,7 +2915,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(mm, ptep);
+			migration_entry_wait_huge(vma, mm, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
@@ -2960,17 +2971,18 @@ int hugetlb_fault(struct mm_struct *mm,
 	if (page != pagecache_page)
 		lock_page(page);
 
-	spin_lock(&mm->page_table_lock);
+	ptl = huge_pte_lockptr(h, mm, ptep);
+	spin_lock(ptl);
 	/* Check for a racing update before calling hugetlb_cow */
 	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
-		goto out_page_table_lock;
+		goto out_ptl;
 
 
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
-							pagecache_page);
-			goto out_page_table_lock;
+					pagecache_page, ptl);
+			goto out_ptl;
 		}
 		entry = huge_pte_mkdirty(entry);
 	}
@@ -2979,8 +2991,8 @@ int hugetlb_fault(struct mm_struct *mm,
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, address, ptep);
 
-out_page_table_lock:
-	spin_unlock(&mm->page_table_lock);
+out_ptl:
+	spin_unlock(ptl);
 
 	if (pagecache_page) {
 		unlock_page(pagecache_page);
@@ -3006,9 +3018,9 @@ long follow_hugetlb_page(struct mm_struc
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
 
-	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
+		spinlock_t *ptl = NULL;
 		int absent;
 		struct page *page;
 
@@ -3016,8 +3028,12 @@ long follow_hugetlb_page(struct mm_struc
 		 * Some archs (sparc64, sh*) have multiple pte_ts to
 		 * each hugepage.  We have to make sure we get the
 		 * first, for the page indexing below to work.
+		 *
+		 * Note that page table lock is not held when pte is null.
 		 */
 		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
+		if (pte)
+			ptl = huge_pte_lock(h, mm, pte);
 		absent = !pte || huge_pte_none(huge_ptep_get(pte));
 
 		/*
@@ -3029,6 +3045,8 @@ long follow_hugetlb_page(struct mm_struc
 		 */
 		if (absent && (flags & FOLL_DUMP) &&
 		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
+			if (pte)
+				spin_unlock(ptl);
 			remainder = 0;
 			break;
 		}
@@ -3048,10 +3066,10 @@ long follow_hugetlb_page(struct mm_struc
 		      !huge_pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
-			spin_unlock(&mm->page_table_lock);
+			if (pte)
+				spin_unlock(ptl);
 			ret = hugetlb_fault(mm, vma, vaddr,
 				(flags & FOLL_WRITE) ? FAULT_FLAG_WRITE : 0);
-			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
 
@@ -3082,8 +3100,8 @@ same_page:
 			 */
 			goto same_page;
 		}
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	*nr_pages = remainder;
 	*position = vaddr;
 
@@ -3104,13 +3122,15 @@ unsigned long hugetlb_change_protection(
 	flush_cache_range(vma, address, end);
 
 	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
-	spin_lock(&mm->page_table_lock);
 	for (; address < end; address += huge_page_size(h)) {
+		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
+		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, &address, ptep)) {
 			pages++;
+			spin_unlock(ptl);
 			continue;
 		}
 		if (!huge_pte_none(huge_ptep_get(ptep))) {
@@ -3120,8 +3140,8 @@ unsigned long hugetlb_change_protection(
 			set_huge_pte_at(mm, address, ptep, pte);
 			pages++;
 		}
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	/*
 	 * Must flush TLB before releasing i_mmap_mutex: x86's huge_pmd_unshare
 	 * may have cleared our pud entry and done put_page on the page table:
@@ -3284,6 +3304,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	unsigned long saddr;
 	pte_t *spte = NULL;
 	pte_t *pte;
+	spinlock_t *ptl;
 
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
@@ -3306,13 +3327,14 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!spte)
 		goto out;
 
-	spin_lock(&mm->page_table_lock);
+	ptl = huge_pte_lockptr(hstate_vma(vma), mm, spte);
+	spin_lock(ptl);
 	if (pud_none(*pud))
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
 	else
 		put_page(virt_to_page(spte));
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
 	mutex_unlock(&mapping->i_mmap_mutex);
@@ -3326,7 +3348,7 @@ out:
  * indicated by page_count > 1, unmap is achieved by clearing pud and
  * decrementing the ref count. If count == 1, the pte page is not shared.
  *
- * called with vma->vm_mm->page_table_lock held.
+ * called with page table lock held.
  *
  * returns: 1 successfully unmapped a shared pte page
  *	    0 the underlying pte page is not shared, or it is the last user
diff -puN mm/mempolicy.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock mm/mempolicy.c
--- a/mm/mempolicy.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/mm/mempolicy.c
@@ -525,8 +525,9 @@ static void queue_pages_hugetlb_pmd_rang
 #ifdef CONFIG_HUGETLB_PAGE
 	int nid;
 	struct page *page;
+	spinlock_t *ptl;
 
-	spin_lock(&vma->vm_mm->page_table_lock);
+	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
 	page = pte_page(huge_ptep_get((pte_t *)pmd));
 	nid = page_to_nid(page);
 	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
@@ -536,7 +537,7 @@ static void queue_pages_hugetlb_pmd_rang
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
 		isolate_huge_page(page, private);
 unlock:
-	spin_unlock(&vma->vm_mm->page_table_lock);
+	spin_unlock(ptl);
 #else
 	BUG();
 #endif
diff -puN mm/migrate.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock mm/migrate.c
--- a/mm/migrate.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/mm/migrate.c
@@ -130,7 +130,7 @@ static int remove_migration_pte(struct p
 		ptep = huge_pte_offset(mm, addr);
 		if (!ptep)
 			goto out;
-		ptl = &mm->page_table_lock;
+		ptl = huge_pte_lockptr(hstate_vma(vma), mm, ptep);
 	} else {
 		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
@@ -247,9 +247,10 @@ void migration_entry_wait(struct mm_stru
 	__migration_entry_wait(mm, ptep, ptl);
 }
 
-void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte)
+void migration_entry_wait_huge(struct vm_area_struct *vma,
+		struct mm_struct *mm, pte_t *pte)
 {
-	spinlock_t *ptl = &(mm)->page_table_lock;
+	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), mm, pte);
 	__migration_entry_wait(mm, pte, ptl);
 }
 
diff -puN mm/rmap.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock mm/rmap.c
--- a/mm/rmap.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock
+++ a/mm/rmap.c
@@ -601,7 +601,7 @@ pte_t *__page_check_address(struct page
 
 	if (unlikely(PageHuge(page))) {
 		pte = huge_pte_offset(mm, address);
-		ptl = &mm->page_table_lock;
+		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
 		goto check;
 	}
 
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
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

