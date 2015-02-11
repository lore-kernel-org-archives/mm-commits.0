From: akpm@linux-foundation.org
Subject: [merged] sparc-drop-pte_file-related-helpers.patch removed from
 -mm tree
Date: Wed, 11 Feb 2015 12:22:51 -0800
Message-ID: <54dbba1b.2noggV3NHRRdMw01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbBKUWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: drop pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     sparc-drop-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sparc: drop pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |   24 ---------------
 arch/sparc/include/asm/pgtable_64.h |   40 --------------------------
 arch/sparc/include/asm/pgtsrmmu.h   |   14 +++------
 3 files changed, 5 insertions(+), 73 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_32.h~sparc-drop-pte_file-related-helpers arch/sparc/include/asm/pgtable_32.h
--- a/arch/sparc/include/asm/pgtable_32.h~sparc-drop-pte_file-related-helpers
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -221,14 +221,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & SRMMU_REF;
 }
 
-/*
- * The following only work if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & SRMMU_FILE;
-}
-
 static inline int pte_special(pte_t pte)
 {
 	return 0;
@@ -375,22 +367,6 @@ static inline swp_entry_t __swp_entry(un
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* file-offset-in-pte helpers */
-static inline unsigned long pte_to_pgoff(pte_t pte)
-{
-	return pte_val(pte) >> SRMMU_PTE_FILE_SHIFT;
-}
-
-static inline pte_t pgoff_to_pte(unsigned long pgoff)
-{
-	return __pte((pgoff << SRMMU_PTE_FILE_SHIFT) | SRMMU_FILE);
-}
-
-/*
- * This is made a constant because mm/fremap.c required a constant.
- */
-#define PTE_FILE_MAX_BITS 24
-
 static inline unsigned long
 __get_phys (unsigned long addr)
 {
diff -puN arch/sparc/include/asm/pgtable_64.h~sparc-drop-pte_file-related-helpers arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc-drop-pte_file-related-helpers
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -137,7 +137,6 @@ bool kern_addr_valid(unsigned long addr)
 #define _PAGE_SOFT_4U	  _AC(0x0000000000001F80,UL) /* Software bits:       */
 #define _PAGE_EXEC_4U	  _AC(0x0000000000001000,UL) /* Executable SW bit    */
 #define _PAGE_MODIFIED_4U _AC(0x0000000000000800,UL) /* Modified (dirty)     */
-#define _PAGE_FILE_4U	  _AC(0x0000000000000800,UL) /* Pagecache page       */
 #define _PAGE_ACCESSED_4U _AC(0x0000000000000400,UL) /* Accessed (ref'd)     */
 #define _PAGE_READ_4U	  _AC(0x0000000000000200,UL) /* Readable SW Bit      */
 #define _PAGE_WRITE_4U	  _AC(0x0000000000000100,UL) /* Writable SW Bit      */
@@ -167,7 +166,6 @@ bool kern_addr_valid(unsigned long addr)
 #define _PAGE_EXEC_4V	  _AC(0x0000000000000080,UL) /* Executable Page      */
 #define _PAGE_W_4V	  _AC(0x0000000000000040,UL) /* Writable             */
 #define _PAGE_SOFT_4V	  _AC(0x0000000000000030,UL) /* Software bits        */
-#define _PAGE_FILE_4V	  _AC(0x0000000000000020,UL) /* Pagecache page       */
 #define _PAGE_PRESENT_4V  _AC(0x0000000000000010,UL) /* Present              */
 #define _PAGE_RESV_4V	  _AC(0x0000000000000008,UL) /* Reserved             */
 #define _PAGE_SZ16GB_4V	  _AC(0x0000000000000007,UL) /* 16GB Page            */
@@ -332,22 +330,6 @@ static inline pmd_t pmd_modify(pmd_t pmd
 }
 #endif
 
-static inline pte_t pgoff_to_pte(unsigned long off)
-{
-	off <<= PAGE_SHIFT;
-
-	__asm__ __volatile__(
-	"\n661:	or		%0, %2, %0\n"
-	"	.section	.sun4v_1insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	or		%0, %3, %0\n"
-	"	.previous\n"
-	: "=r" (off)
-	: "0" (off), "i" (_PAGE_FILE_4U), "i" (_PAGE_FILE_4V));
-
-	return __pte(off);
-}
-
 static inline pgprot_t pgprot_noncached(pgprot_t prot)
 {
 	unsigned long val = pgprot_val(prot);
@@ -609,22 +591,6 @@ static inline unsigned long pte_exec(pte
 	return (pte_val(pte) & mask);
 }
 
-static inline unsigned long pte_file(pte_t pte)
-{
-	unsigned long val = pte_val(pte);
-
-	__asm__ __volatile__(
-	"\n661:	and		%0, %2, %0\n"
-	"	.section	.sun4v_1insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	and		%0, %3, %0\n"
-	"	.previous\n"
-	: "=r" (val)
-	: "0" (val), "i" (_PAGE_FILE_4U), "i" (_PAGE_FILE_4V));
-
-	return val;
-}
-
 static inline unsigned long pte_present(pte_t pte)
 {
 	unsigned long val = pte_val(pte);
@@ -971,12 +937,6 @@ pgtable_t pgtable_trans_huge_withdraw(st
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* File offset in PTE support. */
-unsigned long pte_file(pte_t);
-#define pte_to_pgoff(pte)	(pte_val(pte) >> PAGE_SHIFT)
-pte_t pgoff_to_pte(unsigned long);
-#define PTE_FILE_MAX_BITS	(64UL - PAGE_SHIFT - 1UL)
-
 int page_in_phys_avail(unsigned long paddr);
 
 /*
diff -puN arch/sparc/include/asm/pgtsrmmu.h~sparc-drop-pte_file-related-helpers arch/sparc/include/asm/pgtsrmmu.h
--- a/arch/sparc/include/asm/pgtsrmmu.h~sparc-drop-pte_file-related-helpers
+++ a/arch/sparc/include/asm/pgtsrmmu.h
@@ -80,10 +80,6 @@
 #define SRMMU_PRIV         0x1c
 #define SRMMU_PRIV_RDONLY  0x18
 
-#define SRMMU_FILE         0x40	/* Implemented in software */
-
-#define SRMMU_PTE_FILE_SHIFT     8	/* == 32-PTE_FILE_MAX_BITS */
-
 #define SRMMU_CHG_MASK    (0xffffff00 | SRMMU_REF | SRMMU_DIRTY)
 
 /* SRMMU swap entry encoding
@@ -94,13 +90,13 @@
  * oooooooooooooooooootttttRRRRRRRR
  * fedcba9876543210fedcba9876543210
  *
- * The bottom 8 bits are reserved for protection and status bits, especially
- * FILE and PRESENT.
+ * The bottom 7 bits are reserved for protection and status bits, especially
+ * PRESENT.
  */
 #define SRMMU_SWP_TYPE_MASK	0x1f
-#define SRMMU_SWP_TYPE_SHIFT	SRMMU_PTE_FILE_SHIFT
-#define SRMMU_SWP_OFF_MASK	0x7ffff
-#define SRMMU_SWP_OFF_SHIFT	(SRMMU_PTE_FILE_SHIFT + 5)
+#define SRMMU_SWP_TYPE_SHIFT	7
+#define SRMMU_SWP_OFF_MASK	0xfffff
+#define SRMMU_SWP_OFF_SHIFT	(SRMMU_SWP_TYPE_SHIFT + 5)
 
 /* Some day I will implement true fine grained access bits for
  * user pages because the SRMMU gives us the capabilities to
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
sparc32-fix-broken-set_pte.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
microblaze-define-__pagetable_pmd_folded.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-account-pmd-page-tables-to-the-process-fix.patch
mm-account-pmd-page-tables-to-the-process-fix-2.patch
mm-account-pmd-page-tables-to-the-process-fix-3.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

