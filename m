From: akpm@linux-foundation.org
Subject: - mmap-handle-mlocked-pages-during-map-remap-unmap.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:10 -0700
Message-ID: <200810202033.m9KKXAgr010566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbYJTUkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kamewzawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mmap: handle mlocked pages during map, remap, unmap
has been removed from the -mm tree.  Its filename was
     mmap-handle-mlocked-pages-during-map-remap-unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: handle mlocked pages during map, remap, unmap
From: Rik van Riel <riel@redhat.com>

Originally by Nick Piggin <npiggin@suse.de>

Remove mlocked pages from the LRU using "unevictable infrastructure"
during mmap(), munmap(), mremap() and truncate().  Try to move back to
normal LRU lists on munmap() when last mlocked mapping removed.  Remove
PageMlocked() status when page truncated from file.

[akpm@linux-foundation.org: cleanup]
[kamezawa.hiroyu@jp.fujitsu.com: fix double unlock_page()]
[kosaki.motohiro@jp.fujitsu.com: split LRU: munlock rework]
[lee.schermerhorn@hp.com: mlock: fix __mlock_vma_pages_range comment block]
[akpm@linux-foundation.org: remove bogus kerneldoc token]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamewzawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c   |   27 ++++-
 mm/internal.h |    9 +
 mm/mlock.c    |  221 +++++++++++++++++++-----------------------------
 mm/mmap.c     |   71 +++++++++++----
 mm/mremap.c   |    8 +
 mm/truncate.c |    4 
 6 files changed, 180 insertions(+), 160 deletions(-)

diff -puN mm/fremap.c~mmap-handle-mlocked-pages-during-map-remap-unmap mm/fremap.c
--- a/mm/fremap.c~mmap-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/fremap.c
@@ -21,6 +21,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 static void zap_pte(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, pte_t *ptep)
 {
@@ -215,15 +217,31 @@ asmlinkage long sys_remap_file_pages(uns
 		spin_unlock(&mapping->i_mmap_lock);
 	}
 
+	if (vma->vm_flags & VM_LOCKED) {
+		/*
+		 * drop PG_Mlocked flag for over-mapped range
+		 */
+		unsigned int saved_flags = vma->vm_flags;
+		munlock_vma_pages_range(vma, start, start + size);
+		vma->vm_flags = saved_flags;
+	}
+
 	mmu_notifier_invalidate_range_start(mm, start, start + size);
 	err = populate_range(mm, vma, start, size, pgoff);
 	mmu_notifier_invalidate_range_end(mm, start, start + size);
 	if (!err && !(flags & MAP_NONBLOCK)) {
-		if (unlikely(has_write_lock)) {
-			downgrade_write(&mm->mmap_sem);
-			has_write_lock = 0;
+		if (vma->vm_flags & VM_LOCKED) {
+			/*
+			 * might be mapping previously unmapped range of file
+			 */
+			mlock_vma_pages_range(vma, start, start + size);
+		} else {
+			if (unlikely(has_write_lock)) {
+				downgrade_write(&mm->mmap_sem);
+				has_write_lock = 0;
+			}
+			make_pages_present(start, start+size);
 		}
-		make_pages_present(start, start+size);
 	}
 
 	/*
@@ -240,4 +258,3 @@ out:
 
 	return err;
 }
-
diff -puN mm/internal.h~mmap-handle-mlocked-pages-during-map-remap-unmap mm/internal.h
--- a/mm/internal.h~mmap-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/internal.h
@@ -61,9 +61,14 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
-extern int mlock_vma_pages_range(struct vm_area_struct *vma,
+extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
-extern void munlock_vma_pages_all(struct vm_area_struct *vma);
+extern void munlock_vma_pages_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end);
+static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
+{
+	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
+}
 
 #ifdef CONFIG_UNEVICTABLE_LRU
 /*
diff -puN mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap mm/mlock.c
--- a/mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/mlock.c
@@ -112,26 +112,49 @@ static void munlock_vma_page(struct page
 	}
 }
 
-/*
- * mlock a range of pages in the vma.
+/**
+ * __mlock_vma_pages_range() -  mlock/munlock a range of pages in the vma.
+ * @vma:   target vma
+ * @start: start address
+ * @end:   end address
+ * @mlock: 0 indicate munlock, otherwise mlock.
+ *
+ * If @mlock == 0, unlock an mlocked range;
+ * else mlock the range of pages.  This takes care of making the pages present ,
+ * too.
  *
- * This takes care of making the pages present too.
+ * return 0 on success, negative error code on error.
  *
- * vma->vm_mm->mmap_sem must be held for write.
+ * vma->vm_mm->mmap_sem must be held for at least read.
  */
-static int __mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
+static long __mlock_vma_pages_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   int mlock)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
 	struct page *pages[16]; /* 16 gives a reasonable batch */
-	int write = !!(vma->vm_flags & VM_WRITE);
 	int nr_pages = (end - start) / PAGE_SIZE;
 	int ret;
+	int gup_flags = 0;
 
-	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);
-	VM_BUG_ON(start < vma->vm_start || end > vma->vm_end);
-	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(end   & ~PAGE_MASK);
+	VM_BUG_ON(start < vma->vm_start);
+	VM_BUG_ON(end   > vma->vm_end);
+	VM_BUG_ON((!rwsem_is_locked(&mm->mmap_sem)) &&
+		  (atomic_read(&mm->mm_users) != 0));
+
+	/*
+	 * mlock:   don't page populate if page has PROT_NONE permission.
+	 * munlock: the pages always do munlock althrough
+	 *          its has PROT_NONE permission.
+	 */
+	if (!mlock)
+		gup_flags |= GUP_FLAGS_IGNORE_VMA_PERMISSIONS;
+
+	if (vma->vm_flags & VM_WRITE)
+		gup_flags |= GUP_FLAGS_WRITE;
 
 	lru_add_drain_all();	/* push cached pages to LRU */
 
@@ -146,9 +169,9 @@ static int __mlock_vma_pages_range(struc
 		 * disable migration of this page.  However, page may
 		 * still be truncated out from under us.
 		 */
-		ret = get_user_pages(current, mm, addr,
+		ret = __get_user_pages(current, mm, addr,
 				min_t(int, nr_pages, ARRAY_SIZE(pages)),
-				write, 0, pages, NULL);
+				gup_flags, pages, NULL);
 		/*
 		 * This can happen for, e.g., VM_NONLINEAR regions before
 		 * a page has been allocated and mapped at a given offset,
@@ -178,8 +201,12 @@ static int __mlock_vma_pages_range(struc
 			 * by the elevated reference, we need only check for
 			 * page truncation (file-cache only).
 			 */
-			if (page->mapping)
-				mlock_vma_page(page);
+			if (page->mapping) {
+				if (mlock)
+					mlock_vma_page(page);
+				else
+					munlock_vma_page(page);
+			}
 			unlock_page(page);
 			put_page(page);		/* ref from get_user_pages() */
 
@@ -197,125 +224,38 @@ static int __mlock_vma_pages_range(struc
 	return 0;	/* count entire vma as locked_vm */
 }
 
-/*
- * private structure for munlock page table walk
- */
-struct munlock_page_walk {
-	struct vm_area_struct *vma;
-	pmd_t                 *pmd; /* for migration_entry_wait() */
-};
-
-/*
- * munlock normal pages for present ptes
- */
-static int __munlock_pte_handler(pte_t *ptep, unsigned long addr,
-				   unsigned long end, struct mm_walk *walk)
-{
-	struct munlock_page_walk *mpw = walk->private;
-	swp_entry_t entry;
-	struct page *page;
-	pte_t pte;
-
-retry:
-	pte = *ptep;
-	/*
-	 * If it's a swap pte, we might be racing with page migration.
-	 */
-	if (unlikely(!pte_present(pte))) {
-		if (!is_swap_pte(pte))
-			goto out;
-		entry = pte_to_swp_entry(pte);
-		if (is_migration_entry(entry)) {
-			migration_entry_wait(mpw->vma->vm_mm, mpw->pmd, addr);
-			goto retry;
-		}
-		goto out;
-	}
-
-	page = vm_normal_page(mpw->vma, addr, pte);
-	if (!page)
-		goto out;
-
-	lock_page(page);
-	if (!page->mapping) {
-		unlock_page(page);
-		goto retry;
-	}
-	munlock_vma_page(page);
-	unlock_page(page);
-
-out:
-	return 0;
-}
-
-/*
- * Save pmd for pte handler for waiting on migration entries
- */
-static int __munlock_pmd_handler(pmd_t *pmd, unsigned long addr,
-				 unsigned long end, struct mm_walk *walk)
-{
-	struct munlock_page_walk *mpw = walk->private;
-
-	mpw->pmd = pmd;
-	return 0;
-}
-
-
-/*
- * munlock a range of pages in the vma using standard page table walk.
- *
- * vma->vm_mm->mmap_sem must be held for write.
- */
-static void __munlock_vma_pages_range(struct vm_area_struct *vma,
-			      unsigned long start, unsigned long end)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct munlock_page_walk mpw = {
-		.vma = vma,
-	};
-	struct mm_walk munlock_page_walk = {
-		.pmd_entry = __munlock_pmd_handler,
-		.pte_entry = __munlock_pte_handler,
-		.private = &mpw,
-		.mm = mm,
-	};
-
-	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);
-	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
-	VM_BUG_ON(start < vma->vm_start);
-	VM_BUG_ON(end > vma->vm_end);
-
-	lru_add_drain_all();	/* push cached pages to LRU */
-	walk_page_range(start, end, &munlock_page_walk);
-	lru_add_drain_all();	/* to update stats */
-}
-
 #else /* CONFIG_UNEVICTABLE_LRU */
 
 /*
  * Just make pages present if VM_LOCKED.  No-op if unlocking.
  */
-static int __mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
+static long __mlock_vma_pages_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   int mlock)
 {
-	if (vma->vm_flags & VM_LOCKED)
+	if (mlock && (vma->vm_flags & VM_LOCKED))
 		make_pages_present(start, end);
 	return 0;
 }
-
-/*
- * munlock a range of pages in the vma -- no-op.
- */
-static void __munlock_vma_pages_range(struct vm_area_struct *vma,
-			      unsigned long start, unsigned long end)
-{
-}
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
-/*
- * mlock all pages in this vma range.  For mmap()/mremap()/...
+/**
+ * mlock_vma_pages_range() - mlock pages in specified vma range.
+ * @vma - the vma containing the specfied address range
+ * @start - starting address in @vma to mlock
+ * @end   - end address [+1] in @vma to mlock
+ *
+ * For mmap()/mremap()/expansion of mlocked vma.
+ *
+ * return 0 on success for "normal" vmas.
+ *
+ * return number of pages [> 0] to be removed from locked_vm on success
+ * of "special" vmas.
+ *
+ * return negative error if vma spanning @start-@range disappears while
+ * mmap semaphore is dropped.  Unlikely?
  */
-int mlock_vma_pages_range(struct vm_area_struct *vma,
+long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -331,8 +271,10 @@ int mlock_vma_pages_range(struct vm_area
 	if (!((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
+		long error;
 		downgrade_write(&mm->mmap_sem);
-		nr_pages = __mlock_vma_pages_range(vma, start, end);
+
+		error = __mlock_vma_pages_range(vma, start, end, 1);
 
 		up_read(&mm->mmap_sem);
 		/* vma can change or disappear */
@@ -340,8 +282,9 @@ int mlock_vma_pages_range(struct vm_area
 		vma = find_vma(mm, start);
 		/* non-NULL vma must contain @start, but need to check @end */
 		if (!vma ||  end > vma->vm_end)
-			return -EAGAIN;
-		return nr_pages;
+			return -ENOMEM;
+
+		return 0;	/* hide other errors from mmap(), et al */
 	}
 
 	/*
@@ -356,17 +299,33 @@ int mlock_vma_pages_range(struct vm_area
 
 no_mlock:
 	vma->vm_flags &= ~VM_LOCKED;	/* and don't come back! */
-	return nr_pages;		/* pages NOT mlocked */
+	return nr_pages;		/* error or pages NOT mlocked */
 }
 
 
 /*
- * munlock all pages in vma.   For munmap() and exit().
+ * munlock_vma_pages_range() - munlock all pages in the vma range.'
+ * @vma - vma containing range to be munlock()ed.
+ * @start - start address in @vma of the range
+ * @end - end of range in @vma.
+ *
+ *  For mremap(), munmap() and exit().
+ *
+ * Called with @vma VM_LOCKED.
+ *
+ * Returns with VM_LOCKED cleared.  Callers must be prepared to
+ * deal with this.
+ *
+ * We don't save and restore VM_LOCKED here because pages are
+ * still on lru.  In unmap path, pages might be scanned by reclaim
+ * and re-mlocked by try_to_{munlock|unmap} before we unmap and
+ * free them.  This will result in freeing mlocked pages.
  */
-void munlock_vma_pages_all(struct vm_area_struct *vma)
+void munlock_vma_pages_range(struct vm_area_struct *vma,
+			   unsigned long start, unsigned long end)
 {
 	vma->vm_flags &= ~VM_LOCKED;
-	__munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
+	__mlock_vma_pages_range(vma, start, end, 0);
 }
 
 /*
@@ -443,7 +402,7 @@ success:
 		 */
 		downgrade_write(&mm->mmap_sem);
 
-		ret = __mlock_vma_pages_range(vma, start, end);
+		ret = __mlock_vma_pages_range(vma, start, end, 1);
 		if (ret > 0) {
 			mm->locked_vm -= ret;
 			ret = 0;
@@ -460,7 +419,7 @@ success:
 		*prev = find_vma(mm, start);
 		/* non-NULL *prev must contain @start, but need to check @end */
 		if (!(*prev) || end > (*prev)->vm_end)
-			ret = -EAGAIN;
+			ret = -ENOMEM;
 	} else {
 		/*
 		 * TODO:  for unlocking, pages will already be resident, so
@@ -469,7 +428,7 @@ success:
 		 * while.  Should we downgrade the semaphore for both lock
 		 * AND unlock ?
 		 */
-		__munlock_vma_pages_range(vma, start, end);
+		__mlock_vma_pages_range(vma, start, end, 0);
 	}
 
 out:
diff -puN mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap mm/mmap.c
--- a/mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/mmap.c
@@ -970,6 +970,7 @@ unsigned long do_mmap_pgoff(struct file 
 			return -EPERM;
 		vm_flags |= VM_LOCKED;
 	}
+
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
@@ -1137,10 +1138,12 @@ munmap_back:
 	 * The VM_SHARED test is necessary because shmem_zero_setup
 	 * will create the file object for a shared anonymous map below.
 	 */
-	if (!file && !(vm_flags & VM_SHARED) &&
-	    vma_merge(mm, prev, addr, addr + len, vm_flags,
-					NULL, NULL, pgoff, NULL))
-		goto out;
+	if (!file && !(vm_flags & VM_SHARED)) {
+		vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
+					NULL, NULL, pgoff, NULL);
+		if (vma)
+			goto out;
+	}
 
 	/*
 	 * Determine the object being mapped and call the appropriate
@@ -1222,10 +1225,14 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += len >> PAGE_SHIFT;
-		make_pages_present(addr, addr + len);
-	}
-	if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
+		/*
+		 * makes pages present; downgrades, drops, reacquires mmap_sem
+		 */
+		long nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
+		if (nr_pages < 0)
+			return nr_pages;	/* vma gone! */
+		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
+	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 	return addr;
 
@@ -1698,8 +1705,10 @@ find_extend_vma(struct mm_struct *mm, un
 		return vma;
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
-	if (prev->vm_flags & VM_LOCKED)
-		make_pages_present(addr, prev->vm_end);
+	if (prev->vm_flags & VM_LOCKED) {
+		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
+			return NULL;	/* vma gone! */
+	}
 	return prev;
 }
 #else
@@ -1725,8 +1734,10 @@ find_extend_vma(struct mm_struct * mm, u
 	start = vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
-	if (vma->vm_flags & VM_LOCKED)
-		make_pages_present(addr, start);
+	if (vma->vm_flags & VM_LOCKED) {
+		if (mlock_vma_pages_range(vma, addr, start) < 0)
+			return NULL;	/* vma gone! */
+	}
 	return vma;
 }
 #endif
@@ -1745,8 +1756,6 @@ static void remove_vma_list(struct mm_st
 		long nrpages = vma_pages(vma);
 
 		mm->total_vm -= nrpages;
-		if (vma->vm_flags & VM_LOCKED)
-			mm->locked_vm -= nrpages;
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
 		vma = remove_vma(vma);
 	} while (vma);
@@ -1912,6 +1921,20 @@ int do_munmap(struct mm_struct *mm, unsi
 	vma = prev? prev->vm_next: mm->mmap;
 
 	/*
+	 * unlock any mlock()ed ranges before detaching vmas
+	 */
+	if (mm->locked_vm) {
+		struct vm_area_struct *tmp = vma;
+		while (tmp && tmp->vm_start < end) {
+			if (tmp->vm_flags & VM_LOCKED) {
+				mm->locked_vm -= vma_pages(tmp);
+				munlock_vma_pages_all(tmp);
+			}
+			tmp = tmp->vm_next;
+		}
+	}
+
+	/*
 	 * Remove the vma's, and unmap the actual pages
 	 */
 	detach_vmas_to_be_unmapped(mm, vma, prev, end);
@@ -2023,8 +2046,9 @@ unsigned long do_brk(unsigned long addr,
 		return -ENOMEM;
 
 	/* Can we just expand an old private anonymous mapping? */
-	if (vma_merge(mm, prev, addr, addr + len, flags,
-					NULL, NULL, pgoff, NULL))
+	vma = vma_merge(mm, prev, addr, addr + len, flags,
+					NULL, NULL, pgoff, NULL);
+	if (vma)
 		goto out;
 
 	/*
@@ -2046,8 +2070,8 @@ unsigned long do_brk(unsigned long addr,
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
-		mm->locked_vm += len >> PAGE_SHIFT;
-		make_pages_present(addr, addr + len);
+		if (!mlock_vma_pages_range(vma, addr, addr + len))
+			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 	return addr;
 }
@@ -2058,7 +2082,7 @@ EXPORT_SYMBOL(do_brk);
 void exit_mmap(struct mm_struct *mm)
 {
 	struct mmu_gather *tlb;
-	struct vm_area_struct *vma = mm->mmap;
+	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
@@ -2066,6 +2090,15 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
+	if (mm->locked_vm) {
+		vma = mm->mmap;
+		while (vma) {
+			if (vma->vm_flags & VM_LOCKED)
+				munlock_vma_pages_all(vma);
+			vma = vma->vm_next;
+		}
+	}
+	vma = mm->mmap;
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
diff -puN mm/mremap.c~mmap-handle-mlocked-pages-during-map-remap-unmap mm/mremap.c
--- a/mm/mremap.c~mmap-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/mremap.c
@@ -24,6 +24,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
@@ -238,8 +240,8 @@ static unsigned long move_vma(struct vm_
 	if (vm_flags & VM_LOCKED) {
 		mm->locked_vm += new_len >> PAGE_SHIFT;
 		if (new_len > old_len)
-			make_pages_present(new_addr + old_len,
-					   new_addr + new_len);
+			mlock_vma_pages_range(new_vma, new_addr + old_len,
+						       new_addr + new_len);
 	}
 
 	return new_addr;
@@ -379,7 +381,7 @@ unsigned long do_mremap(unsigned long ad
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
-				make_pages_present(addr + old_len,
+				mlock_vma_pages_range(vma, addr + old_len,
 						   addr + new_len);
 			}
 			ret = addr;
diff -puN mm/truncate.c~mmap-handle-mlocked-pages-during-map-remap-unmap mm/truncate.c
--- a/mm/truncate.c~mmap-handle-mlocked-pages-during-map-remap-unmap
+++ a/mm/truncate.c
@@ -18,6 +18,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
 				   do_invalidatepage */
+#include "internal.h"
 
 
 /**
@@ -103,6 +104,7 @@ truncate_complete_page(struct address_sp
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
+	clear_page_mlock(page);
 	remove_from_page_cache(page);
 	ClearPageMappedToDisk(page);
 	page_cache_release(page);	/* pagecache ref */
@@ -127,6 +129,7 @@ invalidate_complete_page(struct address_
 	if (PagePrivate(page) && !try_to_release_page(page, 0))
 		return 0;
 
+	clear_page_mlock(page);
 	ret = remove_mapping(mapping, page);
 
 	return ret;
@@ -352,6 +355,7 @@ invalidate_complete_page2(struct address
 	if (PageDirty(page))
 		goto failed;
 
+	clear_page_mlock(page);
 	BUG_ON(PagePrivate(page));
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch

