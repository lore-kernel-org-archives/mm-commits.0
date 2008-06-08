From: akpm@linux-foundation.org
Subject: + powerpc-define-support-for-16g-hugepages.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:15:00 -0700
Message-ID: <200806081915.m58JF0Tx016353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541AbYFHTPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, kniht@linux.vnet.ibm.com


The patch titled
     powerpc: define support for 16G hugepages
has been added to the -mm tree.  Its filename is
     powerpc-define-support-for-16g-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: define support for 16G hugepages
From: Nick Piggin <npiggin@suse.de>

The huge page size is defined for 16G pages.  If a hugepagesz of 16G is
specified at boot-time then it becomes the huge page size instead of the
default 16M.

The change in pgtable-64K.h is to the macro pte_iterate_hashed_subpages to
make the increment to va (the 1 being shifted) be a long so that it is not
shifted to 0.  Otherwise it would create an infinite loop when the shift
value is for a 16G page (when base page size is 64K).

Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c     |   62 +++++++++++++++++++---------
 include/asm-powerpc/pgtable-64k.h |    2 
 2 files changed, 45 insertions(+), 19 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-define-support-for-16g-hugepages arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-define-support-for-16g-hugepages
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -24,8 +24,9 @@
 #include <asm/cputable.h>
 #include <asm/spu.h>
 
-#define HPAGE_SHIFT_64K	16
-#define HPAGE_SHIFT_16M	24
+#define PAGE_SHIFT_64K	16
+#define PAGE_SHIFT_16M	24
+#define PAGE_SHIFT_16G	34
 
 #define NUM_LOW_AREAS	(0x100000000UL >> SID_SHIFT)
 #define NUM_HIGH_AREAS	(PGTABLE_RANGE >> HTLB_AREA_SHIFT)
@@ -95,7 +96,7 @@ static int __hugepte_alloc(struct mm_str
 static inline
 pmd_t *hpmd_offset(pud_t *pud, unsigned long addr)
 {
-	if (HPAGE_SHIFT == HPAGE_SHIFT_64K)
+	if (HPAGE_SHIFT == PAGE_SHIFT_64K)
 		return pmd_offset(pud, addr);
 	else
 		return (pmd_t *) pud;
@@ -103,7 +104,7 @@ pmd_t *hpmd_offset(pud_t *pud, unsigned 
 static inline
 pmd_t *hpmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long addr)
 {
-	if (HPAGE_SHIFT == HPAGE_SHIFT_64K)
+	if (HPAGE_SHIFT == PAGE_SHIFT_64K)
 		return pmd_alloc(mm, pud, addr);
 	else
 		return (pmd_t *) pud;
@@ -260,7 +261,7 @@ static void hugetlb_free_pud_range(struc
 			continue;
 		hugetlb_free_pmd_range(tlb, pud, addr, next, floor, ceiling);
 #else
-		if (HPAGE_SHIFT == HPAGE_SHIFT_64K) {
+		if (HPAGE_SHIFT == PAGE_SHIFT_64K) {
 			if (pud_none_or_clear_bad(pud))
 				continue;
 			hugetlb_free_pmd_range(tlb, pud, addr, next, floor, ceiling);
@@ -591,20 +592,40 @@ void set_huge_psize(int psize)
 {
 	/* Check that it is a page size supported by the hardware and
 	 * that it fits within pagetable limits. */
-	if (mmu_psize_defs[psize].shift && mmu_psize_defs[psize].shift < SID_SHIFT &&
+	if (mmu_psize_defs[psize].shift &&
+		mmu_psize_defs[psize].shift < SID_SHIFT_1T &&
 		(mmu_psize_defs[psize].shift > MIN_HUGEPTE_SHIFT ||
-			mmu_psize_defs[psize].shift == HPAGE_SHIFT_64K)) {
+		 mmu_psize_defs[psize].shift == PAGE_SHIFT_64K ||
+		 mmu_psize_defs[psize].shift == PAGE_SHIFT_16G)) {
+		/* Return if huge page size is the same as the
+		 * base page size. */
+		if (mmu_psize_defs[psize].shift == PAGE_SHIFT)
+			return;
+
 		HPAGE_SHIFT = mmu_psize_defs[psize].shift;
 		mmu_huge_psize = psize;
-#ifdef CONFIG_PPC_64K_PAGES
-		hugepte_shift = (PMD_SHIFT-HPAGE_SHIFT);
-#else
-		if (HPAGE_SHIFT == HPAGE_SHIFT_64K)
-			hugepte_shift = (PMD_SHIFT-HPAGE_SHIFT);
-		else
-			hugepte_shift = (PUD_SHIFT-HPAGE_SHIFT);
-#endif
 
+		switch (HPAGE_SHIFT) {
+		case PAGE_SHIFT_64K:
+		    /* We only allow 64k hpages with 4k base page,
+		     * which was checked above, and always put them
+		     * at the PMD */
+		    hugepte_shift = PMD_SHIFT;
+		    break;
+		case PAGE_SHIFT_16M:
+		    /* 16M pages can be at two different levels
+		     * of pagestables based on base page size */
+		    if (PAGE_SHIFT == PAGE_SHIFT_64K)
+			    hugepte_shift = PMD_SHIFT;
+		    else /* 4k base page */
+			    hugepte_shift = PUD_SHIFT;
+		    break;
+		case PAGE_SHIFT_16G:
+		    /* 16G pages are always at PGD level */
+		    hugepte_shift = PGDIR_SHIFT;
+		    break;
+		}
+		hugepte_shift -= HPAGE_SHIFT;
 	} else
 		HPAGE_SHIFT = 0;
 }
@@ -620,17 +641,22 @@ static int __init hugepage_setup_sz(char
 	shift = __ffs(size);
 	switch (shift) {
 #ifndef CONFIG_PPC_64K_PAGES
-	case HPAGE_SHIFT_64K:
+	case PAGE_SHIFT_64K:
 		mmu_psize = MMU_PAGE_64K;
 		break;
 #endif
-	case HPAGE_SHIFT_16M:
+	case PAGE_SHIFT_16M:
 		mmu_psize = MMU_PAGE_16M;
 		break;
+	case PAGE_SHIFT_16G:
+		mmu_psize = MMU_PAGE_16G;
+		break;
 	}
 
-	if (mmu_psize >=0 && mmu_psize_defs[mmu_psize].shift)
+	if (mmu_psize >= 0 && mmu_psize_defs[mmu_psize].shift) {
 		set_huge_psize(mmu_psize);
+		hugetlb_add_hstate(shift - PAGE_SHIFT);
+	}
 	else
 		printk(KERN_WARNING "Invalid huge page size specified(%llu)\n", size);
 
diff -puN include/asm-powerpc/pgtable-64k.h~powerpc-define-support-for-16g-hugepages include/asm-powerpc/pgtable-64k.h
--- a/include/asm-powerpc/pgtable-64k.h~powerpc-define-support-for-16g-hugepages
+++ a/include/asm-powerpc/pgtable-64k.h
@@ -125,7 +125,7 @@ static inline struct subpage_prot_table 
                 unsigned __split = (psize == MMU_PAGE_4K ||                 \
 				    psize == MMU_PAGE_64K_AP);              \
                 shift = mmu_psize_defs[psize].shift;                        \
-	        for (index = 0; va < __end; index++, va += (1 << shift)) {  \
+		for (index = 0; va < __end; index++, va += (1L << shift)) { \
 		        if (!__split || __rpte_sub_valid(rpte, index)) do { \
 
 #define pte_iterate_hashed_end() } while(0); } } while(0)
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

