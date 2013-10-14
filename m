From: akpm@linux-foundation.org
Subject: + xtensa-use-buddy-allocator-for-pte-table.patch added to -mm
 tree
Date: Mon, 14 Oct 2013 15:50:02 -0700
Message-ID: <525c751a.yVvEsVTn48+hyKaZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab3JNWuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 18:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jcmvbkbc@gmail.com, chris@zankel.net, kirill.shutemov@linux.intel.com

Subject: + xtensa-use-buddy-allocator-for-pte-table.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,chris@zankel.net,jcmvbkbc@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 15:50:02 -0700


The patch titled
     Subject: Re: xtensa: use buddy allocator for PTE table
has been added to the -mm tree.  Its filename is
     xtensa-use-buddy-allocator-for-pte-table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-use-buddy-allocator-for-pte-table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-use-buddy-allocator-for-pte-table.patch

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
Subject: Re: xtensa: use buddy allocator for PTE table

At the moment xtensa uses slab allocator for PTE table.  It doesn't work
with enabled split page table lock: slab uses page->slab_cache and
page->first_page for its pages.  These fields share stroage with
page->ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/pgalloc.h |   20 ++++++++++++--------
 arch/xtensa/include/asm/pgtable.h |    3 +--
 arch/xtensa/mm/mmu.c              |   20 --------------------
 3 files changed, 13 insertions(+), 30 deletions(-)

diff -puN arch/xtensa/include/asm/pgalloc.h~xtensa-use-buddy-allocator-for-pte-table arch/xtensa/include/asm/pgalloc.h
--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-use-buddy-allocator-for-pte-table
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -38,14 +38,18 @@ static inline void pgd_free(struct mm_st
 	free_page((unsigned long)pgd);
 }
 
-/* Use a slab cache for the pte pages (see also sparc64 implementation) */
-
-extern struct kmem_cache *pgtable_cache;
-
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					 unsigned long address)
 {
-	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL|__GFP_REPEAT);
+	pte_t *ptep;
+	int i;
+
+	ptep = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	if (!ptep)
+		return NULL;
+	for (i = 0; i < 1024; i++)
+		pte_clear(NULL, 0, ptep + i);
+	return ptep;
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
@@ -59,7 +63,7 @@ static inline pgtable_t pte_alloc_one(st
 		return NULL;
 	page = virt_to_page(pte);
 	if (!pgtable_page_ctor(page)) {
-		kmem_cache_free(pgtable_cache, pte);
+		__free_page(page);
 		return NULL;
 	}
 	return page;
@@ -67,13 +71,13 @@ static inline pgtable_t pte_alloc_one(st
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	kmem_cache_free(pgtable_cache, pte);
+	free_page((unsigned long)pte);
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 {
 	pgtable_page_dtor(pte);
-	kmem_cache_free(pgtable_cache, page_address(pte));
+	__free_page(pte);
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
diff -puN arch/xtensa/include/asm/pgtable.h~xtensa-use-buddy-allocator-for-pte-table arch/xtensa/include/asm/pgtable.h
--- a/arch/xtensa/include/asm/pgtable.h~xtensa-use-buddy-allocator-for-pte-table
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -220,12 +220,11 @@ extern unsigned long empty_zero_page[102
 #ifdef CONFIG_MMU
 extern pgd_t swapper_pg_dir[PAGE_SIZE/sizeof(pgd_t)];
 extern void paging_init(void);
-extern void pgtable_cache_init(void);
 #else
 # define swapper_pg_dir NULL
 static inline void paging_init(void) { }
-static inline void pgtable_cache_init(void) { }
 #endif
+static inline void pgtable_cache_init(void) { }
 
 /*
  * The pmd contains the kernel virtual address of the pte page.
diff -puN arch/xtensa/mm/mmu.c~xtensa-use-buddy-allocator-for-pte-table arch/xtensa/mm/mmu.c
--- a/arch/xtensa/mm/mmu.c~xtensa-use-buddy-allocator-for-pte-table
+++ a/arch/xtensa/mm/mmu.c
@@ -50,23 +50,3 @@ void __init init_mmu(void)
 	 */
 	set_ptevaddr_register(PGTABLE_START);
 }
-
-struct kmem_cache *pgtable_cache __read_mostly;
-
-static void pgd_ctor(void *addr)
-{
-	pte_t *ptep = (pte_t *)addr;
-	int i;
-
-	for (i = 0; i < 1024; i++, ptep++)
-		pte_clear(NULL, 0, ptep);
-
-}
-
-void __init pgtable_cache_init(void)
-{
-	pgtable_cache = kmem_cache_create("pgd",
-			PAGE_SIZE, PAGE_SIZE,
-			SLAB_HWCACHE_ALIGN,
-			pgd_ctor);
-}
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
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
cris-fix-potential-null-pointer-dereference.patch
m32r-fix-potential-null-pointer-dereference.patch
xtensa-fix-potential-null-pointer-dereference.patch
mm-allow-pgtable_page_ctor-to-fail.patch
microblaze-add-missing-pgtable_page_ctor-dtor-calls.patch
mn10300-add-missing-pgtable_page_ctor-dtor-calls.patch
openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch
alpha-handle-pgtable_page_ctor-fail.patch
arc-handle-pgtable_page_ctor-fail.patch
arm-handle-pgtable_page_ctor-fail.patch
arm64-handle-pgtable_page_ctor-fail.patch
avr32-handle-pgtable_page_ctor-fail.patch
cris-handle-pgtable_page_ctor-fail.patch
frv-handle-pgtable_page_ctor-fail.patch
hexagon-handle-pgtable_page_ctor-fail.patch
ia64-handle-pgtable_page_ctor-fail.patch
m32r-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail.patch
metag-handle-pgtable_page_ctor-fail.patch
mips-handle-pgtable_page_ctor-fail.patch
parisc-handle-pgtable_page_ctor-fail.patch
powerpc-handle-pgtable_page_ctor-fail.patch
s390-handle-pgtable_page_ctor-fail.patch
score-handle-pgtable_page_ctor-fail.patch
sh-handle-pgtable_page_ctor-fail.patch
sparc-handle-pgtable_page_ctor-fail.patch
tile-handle-pgtable_page_ctor-fail.patch
um-handle-pgtable_page_ctor-fail.patch
unicore32-handle-pgtable_page_ctor-fail.patch
x86-handle-pgtable_page_ctor-fail.patch
xtensa-handle-pgtable_page_ctor-fail.patch
iommu-arm-smmu-handle-pgtable_page_ctor-fail.patch
xtensa-use-buddy-allocator-for-pte-table.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

