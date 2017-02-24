From: akpm@linux-foundation.org
Subject: [patch 049/124] mm: convert try_to_unmap_one() to use
 page_vma_mapped_walk()
Date: Fri, 24 Feb 2017 14:58:01 -0800
Message-ID: <58b0ba79.rZRjh911srdo3wUe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdBXW6C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: convert try_to_unmap_one() to use page_vma_mapped_walk()

For consistency, it worth converting all page_check_address() to
page_vma_mapped_walk(), so we could drop the former.

It also makes freeze_page() as we walk though rmap only once.

Link: http://lkml.kernel.org/r/20170129173858.45174-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 --
 mm/rmap.c        |  260 +++++++++++++++++++++++----------------------
 2 files changed, 137 insertions(+), 139 deletions(-)

diff -puN mm/huge_memory.c~mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk mm/huge_memory.c
--- a/mm/huge_memory.c~mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk
+++ a/mm/huge_memory.c
@@ -2106,24 +2106,16 @@ void vma_adjust_trans_huge(struct vm_are
 static void freeze_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
-		TTU_RMAP_LOCKED;
-	int i, ret;
+		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
+	int ret;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
 		ttu_flags |= TTU_MIGRATION;
 
-	/* We only need TTU_SPLIT_HUGE_PMD once */
-	ret = try_to_unmap(page, ttu_flags | TTU_SPLIT_HUGE_PMD);
-	for (i = 1; !ret && i < HPAGE_PMD_NR; i++) {
-		/* Cut short if the page is unmapped */
-		if (page_count(page) == 1)
-			return;
-
-		ret = try_to_unmap(page + i, ttu_flags);
-	}
-	VM_BUG_ON_PAGE(ret, page + i - 1);
+	ret = try_to_unmap(page, ttu_flags);
+	VM_BUG_ON_PAGE(ret, page);
 }
 
 static void unfreeze_page(struct page *page)
diff -puN mm/rmap.c~mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk mm/rmap.c
--- a/mm/rmap.c~mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk
+++ a/mm/rmap.c
@@ -607,8 +607,7 @@ void try_to_unmap_flush_dirty(void)
 		try_to_unmap_flush();
 }
 
-static void set_tlb_ubc_flush_pending(struct mm_struct *mm,
-		struct page *page, bool writable)
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm, bool writable)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
 
@@ -643,8 +642,7 @@ static bool should_defer_flush(struct mm
 	return should_defer;
 }
 #else
-static void set_tlb_ubc_flush_pending(struct mm_struct *mm,
-		struct page *page, bool writable)
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm, bool writable)
 {
 }
 
@@ -1459,155 +1457,163 @@ static int try_to_unmap_one(struct page
 		     unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pte_t *pte;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = address,
+	};
 	pte_t pteval;
-	spinlock_t *ptl;
+	struct page *subpage;
 	int ret = SWAP_AGAIN;
 	struct rmap_private *rp = arg;
 	enum ttu_flags flags = rp->flags;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
-		goto out;
+		return SWAP_AGAIN;
 
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
 				flags & TTU_MIGRATION, page);
-		/* check if we have anything to do after split */
-		if (page_mapcount(page) == 0)
-			goto out;
 	}
 
-	pte = page_check_address(page, mm, address, &ptl,
-				 PageTransCompound(page));
-	if (!pte)
-		goto out;
+	while (page_vma_mapped_walk(&pvmw)) {
+		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
+		address = pvmw.address;
 
-	/*
-	 * If the page is mlock()d, we cannot swap it out.
-	 * If it's recently referenced (perhaps page_referenced
-	 * skipped over this mm) then we should reactivate it.
-	 */
-	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			/* PTE-mapped THP are never mlocked */
-			if (!PageTransCompound(page)) {
-				/*
-				 * Holding pte lock, we do *not* need
-				 * mmap_sem here
-				 */
-				mlock_vma_page(page);
-			}
-			ret = SWAP_MLOCK;
-			goto out_unmap;
-		}
-		if (flags & TTU_MUNLOCK)
-			goto out_unmap;
-	}
-	if (!(flags & TTU_IGNORE_ACCESS)) {
-		if (ptep_clear_flush_young_notify(vma, address, pte)) {
-			ret = SWAP_FAIL;
-			goto out_unmap;
-		}
-  	}
+		/* Unexpected PMD-mapped THP? */
+		VM_BUG_ON_PAGE(!pvmw.pte, page);
 
-	/* Nuke the page table entry. */
-	flush_cache_page(vma, address, page_to_pfn(page));
-	if (should_defer_flush(mm, flags)) {
 		/*
-		 * We clear the PTE but do not flush so potentially a remote
-		 * CPU could still be writing to the page. If the entry was
-		 * previously clean then the architecture must guarantee that
-		 * a clear->dirty transition on a cached TLB entry is written
-		 * through and traps if the PTE is unmapped.
+		 * If the page is mlock()d, we cannot swap it out.
+		 * If it's recently referenced (perhaps page_referenced
+		 * skipped over this mm) then we should reactivate it.
 		 */
-		pteval = ptep_get_and_clear(mm, address, pte);
-
-		set_tlb_ubc_flush_pending(mm, page, pte_dirty(pteval));
-	} else {
-		pteval = ptep_clear_flush(vma, address, pte);
-	}
+		if (!(flags & TTU_IGNORE_MLOCK)) {
+			if (vma->vm_flags & VM_LOCKED) {
+				/* PTE-mapped THP are never mlocked */
+				if (!PageTransCompound(page)) {
+					/*
+					 * Holding pte lock, we do *not* need
+					 * mmap_sem here
+					 */
+					mlock_vma_page(page);
+				}
+				ret = SWAP_MLOCK;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
+			if (flags & TTU_MUNLOCK)
+				continue;
+		}
 
-	/* Move the dirty bit to the physical page now the pte is gone. */
-	if (pte_dirty(pteval))
-		set_page_dirty(page);
+		if (!(flags & TTU_IGNORE_ACCESS)) {
+			if (ptep_clear_flush_young_notify(vma, address,
+						pvmw.pte)) {
+				ret = SWAP_FAIL;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
+		}
 
-	/* Update high watermark before we lower rss */
-	update_hiwater_rss(mm);
+		/* Nuke the page table entry. */
+		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
+		if (should_defer_flush(mm, flags)) {
+			/*
+			 * We clear the PTE but do not flush so potentially
+			 * a remote CPU could still be writing to the page.
+			 * If the entry was previously clean then the
+			 * architecture must guarantee that a clear->dirty
+			 * transition on a cached TLB entry is written through
+			 * and traps if the PTE is unmapped.
+			 */
+			pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (PageHuge(page)) {
-			hugetlb_count_sub(1 << compound_order(page), mm);
+			set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
 		} else {
-			dec_mm_counter(mm, mm_counter(page));
+			pteval = ptep_clear_flush(vma, address, pvmw.pte);
 		}
-		set_pte_at(mm, address, pte,
-			   swp_entry_to_pte(make_hwpoison_entry(page)));
-	} else if (pte_unused(pteval)) {
-		/*
-		 * The guest indicated that the page content is of no
-		 * interest anymore. Simply discard the pte, vmscan
-		 * will take care of the rest.
-		 */
-		dec_mm_counter(mm, mm_counter(page));
-	} else if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION)) {
-		swp_entry_t entry;
-		pte_t swp_pte;
-		/*
-		 * Store the pfn of the page in a special migration
-		 * pte. do_swap_page() will wait until the migration
-		 * pte is removed and then restart fault handling.
-		 */
-		entry = make_migration_entry(page, pte_write(pteval));
-		swp_pte = swp_entry_to_pte(entry);
-		if (pte_soft_dirty(pteval))
-			swp_pte = pte_swp_mksoft_dirty(swp_pte);
-		set_pte_at(mm, address, pte, swp_pte);
-	} else if (PageAnon(page)) {
-		swp_entry_t entry = { .val = page_private(page) };
-		pte_t swp_pte;
-		/*
-		 * Store the swap location in the pte.
-		 * See handle_pte_fault() ...
-		 */
-		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 
-		if (!PageDirty(page) && (flags & TTU_LZFREE)) {
-			/* It's a freeable page by MADV_FREE */
-			dec_mm_counter(mm, MM_ANONPAGES);
-			rp->lazyfreed++;
-			goto discard;
-		}
+		/* Move the dirty bit to the page. Now the pte is gone. */
+		if (pte_dirty(pteval))
+			set_page_dirty(page);
+
+		/* Update high watermark before we lower rss */
+		update_hiwater_rss(mm);
+
+		if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
+			if (PageHuge(page)) {
+				int nr = 1 << compound_order(page);
+				hugetlb_count_sub(nr, mm);
+			} else {
+				dec_mm_counter(mm, mm_counter(page));
+			}
 
-		if (swap_duplicate(entry) < 0) {
-			set_pte_at(mm, address, pte, pteval);
-			ret = SWAP_FAIL;
-			goto out_unmap;
-		}
-		if (list_empty(&mm->mmlist)) {
-			spin_lock(&mmlist_lock);
-			if (list_empty(&mm->mmlist))
-				list_add(&mm->mmlist, &init_mm.mmlist);
-			spin_unlock(&mmlist_lock);
-		}
-		dec_mm_counter(mm, MM_ANONPAGES);
-		inc_mm_counter(mm, MM_SWAPENTS);
-		swp_pte = swp_entry_to_pte(entry);
-		if (pte_soft_dirty(pteval))
-			swp_pte = pte_swp_mksoft_dirty(swp_pte);
-		set_pte_at(mm, address, pte, swp_pte);
-	} else
-		dec_mm_counter(mm, mm_counter_file(page));
+			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
+			set_pte_at(mm, address, pvmw.pte, pteval);
+		} else if (pte_unused(pteval)) {
+			/*
+			 * The guest indicated that the page content is of no
+			 * interest anymore. Simply discard the pte, vmscan
+			 * will take care of the rest.
+			 */
+			dec_mm_counter(mm, mm_counter(page));
+		} else if (IS_ENABLED(CONFIG_MIGRATION) &&
+				(flags & TTU_MIGRATION)) {
+			swp_entry_t entry;
+			pte_t swp_pte;
+			/*
+			 * Store the pfn of the page in a special migration
+			 * pte. do_swap_page() will wait until the migration
+			 * pte is removed and then restart fault handling.
+			 */
+			entry = make_migration_entry(subpage,
+					pte_write(pteval));
+			swp_pte = swp_entry_to_pte(entry);
+			if (pte_soft_dirty(pteval))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
+		} else if (PageAnon(page)) {
+			swp_entry_t entry = { .val = page_private(subpage) };
+			pte_t swp_pte;
+			/*
+			 * Store the swap location in the pte.
+			 * See handle_pte_fault() ...
+			 */
+			VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+
+			if (!PageDirty(page) && (flags & TTU_LZFREE)) {
+				/* It's a freeable page by MADV_FREE */
+				dec_mm_counter(mm, MM_ANONPAGES);
+				rp->lazyfreed++;
+				goto discard;
+			}
 
+			if (swap_duplicate(entry) < 0) {
+				set_pte_at(mm, address, pvmw.pte, pteval);
+				ret = SWAP_FAIL;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
+			if (list_empty(&mm->mmlist)) {
+				spin_lock(&mmlist_lock);
+				if (list_empty(&mm->mmlist))
+					list_add(&mm->mmlist, &init_mm.mmlist);
+				spin_unlock(&mmlist_lock);
+			}
+			dec_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter(mm, MM_SWAPENTS);
+			swp_pte = swp_entry_to_pte(entry);
+			if (pte_soft_dirty(pteval))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
+		} else
+			dec_mm_counter(mm, mm_counter_file(page));
 discard:
-	page_remove_rmap(page, PageHuge(page));
-	put_page(page);
