Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E611C4167D
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386569AbiBHWZt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387077AbiBHVxv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:53:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360CEC0612BC
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:53:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD7E3615FB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BC7C004E1;
        Tue,  8 Feb 2022 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644357229;
        bh=E9OUReggFpn4Yex7myIMbspgKe69JNegfU/cWvmMPog=;
        h=Date:To:From:Subject:From;
        b=cc1cYS1pZNnxp8y1+QXv7rGrFalniRA99bjmMF6MViVzB5/aKaUXaD85KgzRNYATg
         nRhFECXZ/j5Ojc+Xoqd3CA3lKgj4fEKuIA5VwJviMs3EOBbFsdlTzyiS/xTUjbKPie
         1T+jQYP3wiDFPH58SBnZ91C+21YjXku9LeTPgfC4=
Date:   Tue, 08 Feb 2022 13:53:48 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch added to -mm tree
Message-Id: <20220208215348.F3BC7C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: rmap call mlock_vma_page() munlock_vma_page()
has been added to the -mm tree.  Its filename is
     mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: rmap call mlock_vma_page() munlock_vma_page()

Add vma argument to mlock_vma_page() and munlock_vma_page(), make them
inline functions which check (vma->vm_flags & VM_LOCKED) before calling
mlock_page() and munlock_page() in mm/mlock.c.

Add bool compound to mlock_vma_page() and munlock_vma_page(): this is
because we have understandable difficulty in accounting pte maps of THPs,
and if passed a PageHead page, mlock_page() and munlock_page() cannot tell
whether it's a pmd map to be counted or a pte map to be ignored.

Add vma arg to page_add_file_rmap() and page_remove_rmap(), like the
others, and use that to call mlock_vma_page() at the end of the page adds,
and munlock_vma_page() at the end of page_remove_rmap() (end or beginning?
unimportant, but end was easier for assertions in testing).

No page lock is required (although almost all adds happen to hold it):
delete the "Serialize with page migration" BUG_ON(!PageLocked(page))s. 
Certainly page lock did serialize with page migration, but I'm having
difficulty explaining why that was ever important.

Mlock accounting on THPs has been hard to define, differed between anon
and file, involved PageDoubleMap in some places and not others, required
clear_page_mlock() at some points.  Keep it simple now: just count the
pmds and ignore the ptes, there is no reason for ptes to undo pmd mlocks.

page_add_new_anon_rmap() callers unchanged: they have long been calling
lru_cache_add_inactive_or_unevictable(), which does its own VM_LOCKED
handling (it also checks for not VM_SPECIAL: I think that's overcautious,
and inconsistent with other checks, that mmap_region() already prevents
VM_LOCKED on VM_SPECIAL; but haven't quite convinced myself to change it).

Link: https://lkml.kernel.org/r/9f9ca113-ffb9-498e-4bd6-6bfeaaa10b7@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h    |   17 ++++++-----
 kernel/events/uprobes.c |    7 +---
 mm/huge_memory.c        |   17 +++++------
 mm/hugetlb.c            |    4 +-
 mm/internal.h           |   36 +++++++++++++++++++++---
 mm/khugepaged.c         |    4 +-
 mm/ksm.c                |   12 --------
 mm/memory.c             |   45 ++++++++++--------------------
 mm/migrate.c            |    9 +-----
 mm/mlock.c              |   21 ++++----------
 mm/rmap.c               |   56 +++++++++++++++++---------------------
 mm/userfaultfd.c        |   14 +++++----
 12 files changed, 113 insertions(+), 129 deletions(-)

--- a/include/linux/rmap.h~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/include/linux/rmap.h
@@ -167,18 +167,19 @@ struct anon_vma *page_get_anon_vma(struc
  */
 void page_move_anon_rmap(struct page *, struct vm_area_struct *);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long, bool);
+		unsigned long address, bool compound);
 void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
-			   unsigned long, int);
+		unsigned long address, int flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long, bool);
-void page_add_file_rmap(struct page *, bool);
-void page_remove_rmap(struct page *, bool);
-
+		unsigned long address, bool compound);
+void page_add_file_rmap(struct page *, struct vm_area_struct *,
+		bool compound);
+void page_remove_rmap(struct page *, struct vm_area_struct *,
+		bool compound);
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
-			    unsigned long);
+		unsigned long address);
 void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
-				unsigned long);
+		unsigned long address);
 
 static inline void page_dup_rmap(struct page *page, bool compound)
 {
--- a/kernel/events/uprobes.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/kernel/events/uprobes.c
@@ -173,7 +173,7 @@ static int __replace_page(struct vm_area
 			return err;
 	}
 
-	/* For try_to_free_swap() and munlock_vma_page() below */
+	/* For try_to_free_swap() below */
 	lock_page(old_page);
 
 	mmu_notifier_invalidate_range_start(&range);
@@ -201,13 +201,10 @@ static int __replace_page(struct vm_area
 		set_pte_at_notify(mm, addr, pvmw.pte,
 				  mk_pte(new_page, vma->vm_page_prot));
 
-	page_remove_rmap(old_page, false);
+	page_remove_rmap(old_page, vma, false);
 	if (!page_mapped(old_page))
 		try_to_free_swap(old_page);
 	page_vma_mapped_walk_done(&pvmw);
-
-	if ((vma->vm_flags & VM_LOCKED) && !PageCompound(old_page))
-		munlock_vma_page(old_page);
 	put_page(old_page);
 
 	err = 0;
--- a/mm/huge_memory.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/huge_memory.c
@@ -1586,7 +1586,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 		if (pmd_present(orig_pmd)) {
 			page = pmd_page(orig_pmd);
-			page_remove_rmap(page, true);
+			page_remove_rmap(page, vma, true);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
@@ -1982,7 +1982,7 @@ static void __split_huge_pmd_locked(stru
 				set_page_dirty(page);
 			if (!PageReferenced(page) && pmd_young(old_pmd))
 				SetPageReferenced(page);
-			page_remove_rmap(page, true);
+			page_remove_rmap(page, vma, true);
 			put_page(page);
 		}
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
@@ -2116,6 +2116,9 @@ static void __split_huge_pmd_locked(stru
 			}
 		}
 		unlock_page_memcg(page);
+
+		/* Above is effectively page_remove_rmap(page, vma, true) */
+		munlock_vma_page(page, vma, true);
 	}
 
 	smp_wmb(); /* make pte visible before pmd */
@@ -2123,7 +2126,7 @@ static void __split_huge_pmd_locked(stru
 
 	if (freeze) {
 		for (i = 0; i < HPAGE_PMD_NR; i++) {
-			page_remove_rmap(page + i, false);
+			page_remove_rmap(page + i, vma, false);
 			put_page(page + i);
 		}
 	}
@@ -2155,8 +2158,6 @@ void __split_huge_pmd(struct vm_area_str
 	if (pmd_trans_huge(*pmd)) {
 		if (!page)
 			page = pmd_page(*pmd);
-		if (PageMlocked(page))
-			clear_page_mlock(page);
 	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
 		goto out;
 	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
@@ -3080,7 +3081,7 @@ void set_pmd_migration_entry(struct page
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
-	page_remove_rmap(page, true);
+	page_remove_rmap(page, vma, true);
 	put_page(page);
 	trace_set_migration_pmd(address, pmd_val(pmdswp));
 }
@@ -3110,10 +3111,8 @@ void remove_migration_pmd(struct page_vm
 	if (PageAnon(new))
 		page_add_anon_rmap(new, vma, mmun_start, true);
 	else
-		page_add_file_rmap(new, true);
+		page_add_file_rmap(new, vma, true);
 	set_pmd_at(mm, mmun_start, pvmw->pmd, pmde);
-	if ((vma->vm_flags & VM_LOCKED) && !PageDoubleMap(new))
-		mlock_vma_page(new);
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
--- a/mm/hugetlb.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/hugetlb.c
@@ -5013,7 +5013,7 @@ static void __unmap_hugepage_range(struc
 			set_page_dirty(page);
 
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
-		page_remove_rmap(page, true);
+		page_remove_rmap(page, vma, true);
 
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
@@ -5258,7 +5258,7 @@ retry_avoidcopy:
 		/* Break COW */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
-		page_remove_rmap(old_page, true);
+		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_page, vma, haddr);
 		set_huge_pte_at(mm, haddr, ptep,
 				make_huge_pte(vma, new_page, 1));
--- a/mm/internal.h~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/internal.h
@@ -395,12 +395,35 @@ extern long faultin_vma_page_range(struc
 				   bool write, int *locked);
 extern int mlock_future_check(struct mm_struct *mm, unsigned long flags,
 			      unsigned long len);
-
 /*
- * must be called with vma's mmap_lock held for read or write, and page locked.
+ * mlock_vma_page() and munlock_vma_page():
+ * should be called with vma's mmap_lock held for read or write,
+ * under page table lock for the pte/pmd being added or removed.
+ *
+ * mlock is usually called at the end of page_add_*_rmap(),
+ * munlock at the end of page_remove_rmap(); but new anon
+ * pages are managed in lru_cache_add_inactive_or_unevictable().
+ *
+ * @compound is used to include pmd mappings of THPs, but filter out
+ * pte mappings of THPs, which cannot be consistently counted: a pte
+ * mapping of the THP head cannot be distinguished by the page alone.
  */
-extern void mlock_vma_page(struct page *page);
-extern void munlock_vma_page(struct page *page);
+void mlock_page(struct page *page);
+static inline void mlock_vma_page(struct page *page,
+			struct vm_area_struct *vma, bool compound)
+{
+	if (unlikely(vma->vm_flags & VM_LOCKED) &&
+	    (compound || !PageTransCompound(page)))
+		mlock_page(page);
+}
+void munlock_page(struct page *page);
+static inline void munlock_vma_page(struct page *page,
+			struct vm_area_struct *vma, bool compound)
+{
+	if (unlikely(vma->vm_flags & VM_LOCKED) &&
+	    (compound || !PageTransCompound(page)))
+		munlock_page(page);
+}
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
@@ -487,7 +510,10 @@ static inline struct file *maybe_unlock_
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
 static inline void clear_page_mlock(struct page *page) { }
-static inline void mlock_vma_page(struct page *page) { }
+static inline void mlock_vma_page(struct page *page,
+			struct vm_area_struct *vma, bool compound) { }
+static inline void munlock_vma_page(struct page *page,
+			struct vm_area_struct *vma, bool compound) { }
 static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
 }
--- a/mm/khugepaged.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/khugepaged.c
@@ -763,7 +763,7 @@ static void __collapse_huge_page_copy(pt
 			 */
 			spin_lock(ptl);
 			ptep_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page, false);
+			page_remove_rmap(src_page, vma, false);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
@@ -1502,7 +1502,7 @@ void collapse_pte_mapped_thp(struct mm_s
 		if (pte_none(*pte))
 			continue;
 		page = vm_normal_page(vma, addr, *pte);
-		page_remove_rmap(page, false);
+		page_remove_rmap(page, vma, false);
 	}
 
 	pte_unmap_unlock(start_pte, ptl);
--- a/mm/ksm.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/ksm.c
@@ -1177,7 +1177,7 @@ static int replace_page(struct vm_area_s
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, newpte);
 
-	page_remove_rmap(page, false);
+	page_remove_rmap(page, vma, false);
 	if (!page_mapped(page))
 		try_to_free_swap(page);
 	put_page(page);
@@ -1252,16 +1252,6 @@ static int try_to_merge_one_page(struct
 			err = replace_page(vma, page, kpage, orig_pte);
 	}
 
-	if ((vma->vm_flags & VM_LOCKED) && kpage && !err) {
-		munlock_vma_page(page);
-		if (!PageMlocked(kpage)) {
-			unlock_page(page);
-			lock_page(kpage);
-			mlock_vma_page(kpage);
-			page = kpage;		/* for final unlock */
-		}
-	}
-
 out_unlock:
 	unlock_page(page);
 out:
--- a/mm/memory.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/memory.c
@@ -735,9 +735,6 @@ static void restore_exclusive_pte(struct
 
 	set_pte_at(vma->vm_mm, address, ptep, pte);
 
-	if (vma->vm_flags & VM_LOCKED)
-		mlock_vma_page(page);
-
 	/*
 	 * No need to invalidate - it was non-present before. However
 	 * secondary CPUs may have mappings that need invalidating.
@@ -1377,7 +1374,7 @@ again:
 					mark_page_accessed(page);
 			}
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, false);
+			page_remove_rmap(page, vma, false);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(__tlb_remove_page(tlb, page))) {
@@ -1397,10 +1394,8 @@ again:
 				continue;
 			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
-
 			if (is_device_private_entry(entry))
-				page_remove_rmap(page, false);
-
+				page_remove_rmap(page, vma, false);
 			put_page(page);
 			continue;
 		}
@@ -1753,16 +1748,16 @@ static int validate_page_before_insert(s
 	return 0;
 }
 
-static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
+static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
 	if (!pte_none(*pte))
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter_fast(mm, mm_counter_file(page));
-	page_add_file_rmap(page, false);
-	set_pte_at(mm, addr, pte, mk_pte(page, prot));
+	inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
+	page_add_file_rmap(page, vma, false);
+	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
 	return 0;
 }
 
@@ -1776,7 +1771,6 @@ static int insert_page_into_pte_locked(s
 static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 			struct page *page, pgprot_t prot)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	int retval;
 	pte_t *pte;
 	spinlock_t *ptl;
@@ -1785,17 +1779,17 @@ static int insert_page(struct vm_area_st
 	if (retval)
 		goto out;
 	retval = -ENOMEM;
-	pte = get_locked_pte(mm, addr, &ptl);
+	pte = get_locked_pte(vma->vm_mm, addr, &ptl);
 	if (!pte)
 		goto out;
-	retval = insert_page_into_pte_locked(mm, pte, addr, page, prot);
+	retval = insert_page_into_pte_locked(vma, pte, addr, page, prot);
 	pte_unmap_unlock(pte, ptl);
 out:
 	return retval;
 }
 
 #ifdef pte_index
-static int insert_page_in_batch_locked(struct mm_struct *mm, pte_t *pte,
+static int insert_page_in_batch_locked(struct vm_area_struct *vma, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
 	int err;
@@ -1805,7 +1799,7 @@ static int insert_page_in_batch_locked(s
 	err = validate_page_before_insert(page);
 	if (err)
 		return err;
-	return insert_page_into_pte_locked(mm, pte, addr, page, prot);
+	return insert_page_into_pte_locked(vma, pte, addr, page, prot);
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
@@ -1842,7 +1836,7 @@ more:
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
-			int err = insert_page_in_batch_locked(mm, pte,
+			int err = insert_page_in_batch_locked(vma, pte,
 				addr, pages[curr_page_idx], prot);
 			if (unlikely(err)) {
 				pte_unmap_unlock(start_pte, pte_lock);
@@ -3098,7 +3092,7 @@ static vm_fault_t wp_page_copy(struct vm
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page, false);
+			page_remove_rmap(old_page, vma, false);
 		}
 
 		/* Free the old page.. */
@@ -3118,16 +3112,6 @@ static vm_fault_t wp_page_copy(struct vm
 	 */
 	mmu_notifier_invalidate_range_only_end(&range);
 	if (old_page) {
-		/*
-		 * Don't let another task, with possibly unlocked vma,
-		 * keep the mlocked page.
-		 */
-		if (page_copied && (vma->vm_flags & VM_LOCKED)) {
-			lock_page(old_page);	/* LRU manipulation */
-			if (PageMlocked(old_page))
-				munlock_vma_page(old_page);
-			unlock_page(old_page);
-		}
 		if (page_copied)
 			free_swap_cache(old_page);
 		put_page(old_page);
@@ -4002,7 +3986,8 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
 	add_mm_counter(vma->vm_mm, mm_counter_file(page), HPAGE_PMD_NR);
-	page_add_file_rmap(page, true);
+	page_add_file_rmap(page, vma, true);
+
 	/*
 	 * deposit and withdraw with pmd lock held
 	 */
@@ -4051,7 +4036,7 @@ void do_set_pte(struct vm_fault *vmf, st
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
-		page_add_file_rmap(page, false);
+		page_add_file_rmap(page, vma, false);
 	}
 	set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
 }
--- a/mm/migrate.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/migrate.c
@@ -248,14 +248,9 @@ static bool remove_migration_pte(struct
 			if (PageAnon(new))
 				page_add_anon_rmap(new, vma, pvmw.address, false);
 			else
-				page_add_file_rmap(new, false);
+				page_add_file_rmap(new, vma, false);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
-		if (vma->vm_flags & VM_LOCKED && !PageTransCompound(new))
-			mlock_vma_page(new);
-
-		if (PageTransHuge(page) && PageMlocked(page))
-			clear_page_mlock(page);
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
@@ -2361,7 +2356,7 @@ again:
 			 * drop page refcount. Page won't be freed, as we took
 			 * a reference just above.
 			 */
-			page_remove_rmap(page, false);
+			page_remove_rmap(page, vma, false);
 			put_page(page);
 
 			if (pte_present(pte))
--- a/mm/mlock.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/mlock.c
@@ -78,17 +78,13 @@ void clear_page_mlock(struct page *page)
 	}
 }
 
-/*
- * Mark page as mlocked if not already.
- * If page on LRU, isolate and putback to move to unevictable list.
+/**
+ * mlock_page - mlock a page
+ * @page - page to be mlocked, either a normal page or a THP head.
  */
-void mlock_vma_page(struct page *page)
+void mlock_page(struct page *page)
 {
-	/* Serialize with page migration */
-	BUG_ON(!PageLocked(page));
-
 	VM_BUG_ON_PAGE(PageTail(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
 
 	if (!TestSetPageMlocked(page)) {
 		int nr_pages = thp_nr_pages(page);
@@ -101,14 +97,11 @@ void mlock_vma_page(struct page *page)
 }
 
 /**
- * munlock_vma_page - munlock a vma page
- * @page: page to be unlocked, either a normal page or THP page head
+ * munlock_page - munlock a page
+ * @page: page to be munlocked, either a normal page or a THP head.
  */
-void munlock_vma_page(struct page *page)
+void munlock_page(struct page *page)
 {
-	/* Serialize with page migration */
-	BUG_ON(!PageLocked(page));
-
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	if (TestClearPageMlocked(page)) {
--- a/mm/rmap.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/rmap.c
@@ -1183,17 +1183,17 @@ void do_page_add_anon_rmap(struct page *
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	}
 
-	if (unlikely(PageKsm(page))) {
+	if (unlikely(PageKsm(page)))
 		unlock_page_memcg(page);
-		return;
-	}
 
 	/* address might be in next vma when migration races vma_adjust */
-	if (first)
+	else if (first)
 		__page_set_anon_rmap(page, vma, address,
 				flags & RMAP_EXCLUSIVE);
 	else
 		__page_check_anon_rmap(page, vma, address);
+
+	mlock_vma_page(page, vma, compound);
 }
 
 /**
@@ -1234,12 +1234,14 @@ void page_add_new_anon_rmap(struct page
 
 /**
  * page_add_file_rmap - add pte mapping to a file page
- * @page: the page to add the mapping to
- * @compound: charge the page as compound or small page
+ * @page:	the page to add the mapping to
+ * @vma:	the vm area in which the mapping is added
+ * @compound:	charge the page as compound or small page
  *
  * The caller needs to hold the pte lock.
  */
-void page_add_file_rmap(struct page *page, bool compound)
+void page_add_file_rmap(struct page *page,
+	struct vm_area_struct *vma, bool compound)
 {
 	int i, nr = 1;
 
@@ -1262,13 +1264,8 @@ void page_add_file_rmap(struct page *pag
 						nr_pages);
 	} else {
 		if (PageTransCompound(page) && page_mapping(page)) {
-			struct page *head = compound_head(page);
-
 			VM_WARN_ON_ONCE(!PageLocked(page));
-
-			SetPageDoubleMap(head);
-			if (PageMlocked(page))
-				clear_page_mlock(head);
+			SetPageDoubleMap(compound_head(page));
 		}
 		if (!atomic_inc_and_test(&page->_mapcount))
 			goto out;
@@ -1276,6 +1273,8 @@ void page_add_file_rmap(struct page *pag
 	__mod_lruvec_page_state(page, NR_FILE_MAPPED, nr);
 out:
 	unlock_page_memcg(page);
+
+	mlock_vma_page(page, vma, compound);
 }
 
 static void page_remove_file_rmap(struct page *page, bool compound)
@@ -1370,11 +1369,13 @@ static void page_remove_anon_compound_rm
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
+ * @vma:	the vm area from which the mapping is removed
  * @compound:	uncharge the page as compound or small page
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page, bool compound)
+void page_remove_rmap(struct page *page,
+	struct vm_area_struct *vma, bool compound)
 {
 	lock_page_memcg(page);
 
@@ -1416,6 +1417,8 @@ void page_remove_rmap(struct page *page,
 	 */
 out:
 	unlock_page_memcg(page);
+
+	munlock_vma_page(page, vma, compound);
 }
 
 /*
@@ -1471,28 +1474,21 @@ static bool try_to_unmap_one(struct page
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		/* Unexpected PMD-mapped THP? */
+		VM_BUG_ON_PAGE(!pvmw.pte, page);
+
 		/*
-		 * If the page is mlock()d, we cannot swap it out.
+		 * If the page is in an mlock()d vma, we must not swap it out.
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
-			/*
-			 * PTE-mapped THP are never marked as mlocked: so do
-			 * not set it on a DoubleMap THP, nor on an Anon THP
-			 * (which may still be PTE-mapped after DoubleMap was
-			 * cleared).  But stop unmapping even in those cases.
-			 */
-			if (!PageTransCompound(page) || (PageHead(page) &&
-			     !PageDoubleMap(page) && !PageAnon(page)))
-				mlock_vma_page(page);
+			/* Restore the mlock which got missed */
+			mlock_vma_page(page, vma, false);
 			page_vma_mapped_walk_done(&pvmw);
 			ret = false;
 			break;
 		}
 
-		/* Unexpected PMD-mapped THP? */
-		VM_BUG_ON_PAGE(!pvmw.pte, page);
-
 		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
 		address = pvmw.address;
 
@@ -1693,7 +1689,7 @@ discard:
 		 *
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
-		page_remove_rmap(subpage, PageHuge(page));
+		page_remove_rmap(subpage, vma, PageHuge(page));
 		put_page(page);
 	}
 
@@ -1971,7 +1967,7 @@ static bool try_to_migrate_one(struct pa
 		 *
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
-		page_remove_rmap(subpage, PageHuge(page));
+		page_remove_rmap(subpage, vma, PageHuge(page));
 		put_page(page);
 	}
 
@@ -2107,7 +2103,7 @@ static bool page_make_device_exclusive_o
 		 * There is a reference on the page for the swap entry which has
 		 * been removed, so shouldn't take another.
 		 */
-		page_remove_rmap(subpage, false);
+		page_remove_rmap(subpage, vma, false);
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
--- a/mm/userfaultfd.c~mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page
+++ a/mm/userfaultfd.c
@@ -95,10 +95,15 @@ int mfill_atomic_install_pte(struct mm_s
 	if (!pte_none(*dst_pte))
 		goto out_unlock;
 
-	if (page_in_cache)
-		page_add_file_rmap(page, false);
-	else
+	if (page_in_cache) {
+		/* Usually, cache pages are already added to LRU */
+		if (newly_allocated)
+			lru_cache_add(page);
+		page_add_file_rmap(page, dst_vma, false);
+	} else {
 		page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
+		lru_cache_add_inactive_or_unevictable(page, dst_vma);
+	}
 
 	/*
 	 * Must happen after rmap, as mm_counter() checks mapping (via
@@ -106,9 +111,6 @@ int mfill_atomic_install_pte(struct mm_s
 	 */
 	inc_mm_counter(dst_mm, mm_counter(page));
 
-	if (newly_allocated)
-		lru_cache_add_inactive_or_unevictable(page, dst_vma);
-
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
 	/* No need to invalidate - it was non-present before */
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

