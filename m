From: akpm@linux-foundation.org
Subject: + mm-dont-split-thp-page-when-syscall-is-called.patch added to
 -mm tree
Date: Wed, 02 Dec 2015 15:29:01 -0800
Message-ID: <565f7ebd.T+5KKrJeqmpsN9tu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbbLBX3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 18:29:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, danielmicay@gmail.com, darrick.wong@oracle.com, davem@davemloft.net, deller@gmx.de, fengguang.wu@intel.com, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, hughd@google.com, ink@jurassic.park.msu.ru, jcmvbkbc@gmail.com, je@fb.com, jejb@parisc-linux.org, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, luto@amacapital.net, mattst88@gmail.com, mgorman@suse.de, mhocko@suse.com, mika.penttila@nextfour.com, mtk.manpages@gmail.com, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, roland@kernel.org, rth@twiddle.net, shli@kernel.org, will.deacon@arm.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: don't split THP page when MADV_FREE syscall is called
has been added to the -mm tree.  Its filename is
     mm-dont-split-thp-page-when-syscall-is-called.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-split-thp-page-when-syscall-is-called.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-split-thp-page-when-syscall-is-called.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/huge_memory.c: don't split THP page when MADV_FREE syscall is called

We don't need to split THP page when MADV_FREE syscall is called if
[start, len] is aligned with THP size.  The split could be done when VM
decide to free it in reclaim path if memory pressure is heavy.  With that,
we could avoid unnecessary THP split.

For the feature, this patch changes pte dirtness marking logic of THP. 
Now, it marks every ptes of pages dirty unconditionally in splitting,
which makes MADV_FREE void.  So, instead, this patch propagates pmd
dirtiness to all pages via PG_dirty and restores pte dirtiness from
PG_dirty.  With this, if pmd is clean(ie, MADV_FREEed) when split
happens(e,g, shrink_page_list), all of pages are clean too so we could
discard them.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Shaohua Li" <shli@kernel.org>
Cc: <yalin.wang2010@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jason Evans <je@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Shaohua Li <shli@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +
 mm/huge_memory.c        |   87 +++++++++++++++++++++++++++++++++++---
 mm/madvise.c            |    8 +++
 3 files changed, 92 insertions(+), 6 deletions(-)

diff -puN include/linux/huge_mm.h~mm-dont-split-thp-page-when-syscall-is-called include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dont-split-thp-page-when-syscall-is-called
+++ a/include/linux/huge_mm.h
@@ -19,6 +19,9 @@ extern struct page *follow_trans_huge_pm
 					  unsigned long addr,
 					  pmd_t *pmd,
 					  unsigned int flags);
+extern int madvise_free_huge_pmd(struct mmu_gather *tlb,
+			struct vm_area_struct *vma,
+			pmd_t *pmd, unsigned long addr, unsigned long next);
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd, unsigned long addr);
diff -puN mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/huge_memory.c
@@ -1530,6 +1530,77 @@ out:
 	return 0;
 }
 
+int madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		pmd_t *pmd, unsigned long addr, unsigned long next)
+
+{
+	spinlock_t *ptl;
+	pmd_t orig_pmd;
+	struct page *page;
+	struct mm_struct *mm = tlb->mm;
+	int ret = 0;
+
+	if (!pmd_trans_huge_lock(pmd, vma, &ptl))
+		goto out;
+
+	orig_pmd = *pmd;
+	if (is_huge_zero_pmd(orig_pmd)) {
+		ret = 1;
+		goto out;
+	}
+
+	page = pmd_page(orig_pmd);
+	/*
+	 * If other processes are mapping this page, we couldn't discard
+	 * the page unless they all do MADV_FREE so let's skip the page.
+	 */
+	if (page_mapcount(page) != 1)
+		goto out;
+
+	if (!trylock_page(page))
+		goto out;
+
+	/*
+	 * If user want to discard part-pages of THP, split it so MADV_FREE
+	 * will deactivate only them.
+	 */
+	if (next - addr != HPAGE_PMD_SIZE) {
+		get_page(page);
+		spin_unlock(ptl);
+		if (split_huge_page(page)) {
+			put_page(page);
+			unlock_page(page);
+			goto out_unlocked;
+		}
+		put_page(page);
+		unlock_page(page);
+		ret = 1;
+		goto out_unlocked;
+	}
+
+	if (PageDirty(page))
+		ClearPageDirty(page);
+	unlock_page(page);
+
+	if (PageActive(page))
+		deactivate_page(page);
+
+	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
+		orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
+			tlb->fullmm);
+		orig_pmd = pmd_mkold(orig_pmd);
+		orig_pmd = pmd_mkclean(orig_pmd);
+
+		set_pmd_at(mm, addr, pmd, orig_pmd);
+		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+	}
+	ret = 1;
+out:
+	spin_unlock(ptl);
+out_unlocked:
+	return ret;
+}
+
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
@@ -2784,7 +2855,7 @@ static void __split_huge_pmd_locked(stru
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t _pmd;
-	bool young, write;
+	bool young, write, dirty;
 	int i;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
@@ -2808,6 +2879,7 @@ static void __split_huge_pmd_locked(stru
 	atomic_add(HPAGE_PMD_NR - 1, &page->_count);
 	write = pmd_write(*pmd);
 	young = pmd_young(*pmd);
+	dirty = pmd_dirty(*pmd);
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -2825,12 +2897,14 @@ static void __split_huge_pmd_locked(stru
 			entry = swp_entry_to_pte(swp_entry);
 		} else {
 			entry = mk_pte(page + i, vma->vm_page_prot);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+			entry = maybe_mkwrite(entry, vma);
 			if (!write)
 				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
 		}
+		if (dirty)
+			SetPageDirty(page + i);
 		pte = pte_offset_map(&_pmd, haddr);
 		BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
@@ -3028,6 +3102,8 @@ static void freeze_page_vma(struct vm_ar
 			continue;
 		flush_cache_page(vma, address, page_to_pfn(page));
 		entry = ptep_clear_flush(vma, address, pte + i);
+		if (pte_dirty(entry))
+			SetPageDirty(page);
 		swp_entry = make_migration_entry(page, pte_write(entry));
 		swp_pte = swp_entry_to_pte(swp_entry);
 		if (pte_soft_dirty(entry))
@@ -3086,7 +3162,8 @@ static void unfreeze_page_vma(struct vm_
 		page_add_anon_rmap(page, vma, address, false);
 
 		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
-		entry = pte_mkdirty(entry);
+		if (PageDirty(page))
+			entry = pte_mkdirty(entry);
 		if (is_write_migration_entry(swp_entry))
 			entry = maybe_mkwrite(entry, vma);
 
@@ -3147,8 +3224,8 @@ static int __split_huge_page_tail(struct
 			 (1L << PG_uptodate) |
 			 (1L << PG_active) |
 			 (1L << PG_locked) |
-			 (1L << PG_unevictable)));
-	page_tail->flags |= (1L << PG_dirty);
+			 (1L << PG_unevictable) |
+			 (1L << PG_dirty)));
 
 	/*
 	 * After clearing PageTail the gup refcount can be released.
diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called
+++ a/mm/madvise.c
@@ -271,8 +271,13 @@ static int madvise_free_pte_range(pmd_t
 	pte_t *orig_pte, *pte, ptent;
 	struct page *page;
 	int nr_swap = 0;
+	unsigned long next;
+
+	next = pmd_addr_end(addr, end);
+	if (pmd_trans_huge(*pmd))
+		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
+			goto next;
 
-	split_huge_pmd(vma, pmd, addr);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
@@ -383,6 +388,7 @@ out:
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(orig_pte, ptl);
 	cond_resched();
+next:
 	return 0;
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-pass-gfp-from-zcomp-frontend-to-backend.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-define-madv_free-for-some-arches.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazily-freed-pages-to-inactive-list.patch
mm-mark-stable-page-dirty-in-ksm.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_mkclean-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch

