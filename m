From: akpm@linux-foundation.org
Subject: + hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 12:52:40 -0700
Message-ID: <538cd608.HlpFM0RSAQmbyH+1%akpm__26448.8170542338$1401738773$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaFBTwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 15:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, stable@vger.kernel.org, schwidefsky@de.ibm.com, rmk@arm.linux.org.uk, ralf@linux-mips.org, mpe@ellerman.id.au, james.hogan@imgtec.com, hughd@google.com, davem@davemloft.net, benh@kernel.crashing.org, n-horiguchi@ah.jp.nec.com

Subject: + hugetlb-restrict-hugepage_migration_support-to-x86_64.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,benh@kernel.crashing.org,davem@davemloft.net,hughd@google.com,james.hogan@imgtec.com,mpe@ellerman.id.au,ralf@linux-mips.org,rmk@arm.linux.org.uk,schwidefsky@de.ibm.com,stable@vger.kernel.org,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 12:52:40 -0700


The patch titled
     Subject: hugetlb: restrict hugepage_migration_support() to x86_64
has been added to the -mm tree.  Its filename is
     hugetlb-restrict-hugepage_migration_support-to-x86_64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-restrict-hugepage_migration_support-to-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlb: restrict hugepage_migration_support() to x86_64

Currently hugepage migration is available for all archs which support
pmd-level hugepage, but testing is done only for x86_64 and there're bugs
for other archs.  So to avoid breaking such archs, this patch limits the
availability strictly to x86_64 until developers of other archs get
interested in enabling this feature.

Simply disabling hugepage migration on non-x86_64 archs is not enough to
fix the reported problem where sys_move_pages() hits the BUG_ON() in
follow_page(FOLL_GET), so let's fix this by checking if hugepage migration
is supported in vma_migratable().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/hugetlbpage.c     |    5 -----
 arch/arm64/mm/hugetlbpage.c   |    5 -----
 arch/ia64/mm/hugetlbpage.c    |    5 -----
 arch/metag/mm/hugetlbpage.c   |    5 -----
 arch/mips/mm/hugetlbpage.c    |    5 -----
 arch/powerpc/mm/hugetlbpage.c |   10 ----------
 arch/s390/mm/hugetlbpage.c    |    5 -----
 arch/sh/mm/hugetlbpage.c      |    5 -----
 arch/sparc/mm/hugetlbpage.c   |    5 -----
 arch/tile/mm/hugetlbpage.c    |    5 -----
 arch/x86/Kconfig              |    4 ++++
 arch/x86/mm/hugetlbpage.c     |   10 ----------
 include/linux/hugetlb.h       |   13 +++++--------
 include/linux/mempolicy.h     |    6 ++++++
 mm/Kconfig                    |    3 +++
 15 files changed, 18 insertions(+), 73 deletions(-)

diff -puN arch/arm/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/arm/mm/hugetlbpage.c
--- a/arch/arm/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/arm/mm/hugetlbpage.c
@@ -56,8 +56,3 @@ int pmd_huge(pmd_t pmd)
 {
 	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
 }
-
-int pmd_huge_support(void)
-{
-	return 1;
-}
diff -puN arch/arm64/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -58,11 +58,6 @@ int pud_huge(pud_t pud)
 #endif
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
diff -puN arch/ia64/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -114,11 +114,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 0;
-}
-
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd, int write)
 {
diff -puN arch/metag/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/metag/mm/hugetlbpage.c
@@ -110,11 +110,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/mips/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/mips/mm/hugetlbpage.c
--- a/arch/mips/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/mips/mm/hugetlbpage.c
@@ -84,11 +84,6 @@ int pud_huge(pud_t pud)
 	return (pud_val(pud) & _PAGE_HUGE) != 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
diff -puN arch/powerpc/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -86,11 +86,6 @@ int pgd_huge(pgd_t pgd)
 	 */
 	return ((pgd_val(pgd) & 0x3) != 0x0);
 }
-
-int pmd_huge_support(void)
-{
-	return 1;
-}
 #else
 int pmd_huge(pmd_t pmd)
 {
@@ -106,11 +101,6 @@ int pgd_huge(pgd_t pgd)
 {
 	return 0;
 }
-
-int pmd_huge_support(void)
-{
-	return 0;
-}
 #endif
 
 pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
diff -puN arch/s390/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/s390/mm/hugetlbpage.c
@@ -220,11 +220,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmdp, int write)
 {
diff -puN arch/sh/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/sh/mm/hugetlbpage.c
@@ -83,11 +83,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 0;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/sparc/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -231,11 +231,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int pmd_huge_support(void)
-{
-	return 0;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/tile/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/tile/mm/hugetlbpage.c
@@ -166,11 +166,6 @@ int pud_huge(pud_t pud)
 	return !!(pud_val(pud) & _PAGE_HUGE_PAGE);
 }
 
-int pmd_huge_support(void)
-{
-	return 1;
-}
-
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/x86/Kconfig~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/x86/Kconfig
--- a/arch/x86/Kconfig~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/x86/Kconfig
@@ -1871,6 +1871,10 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	def_bool y
 	depends on X86_64 || X86_PAE
 
+config ARCH_ENABLE_HUGEPAGE_MIGRATION
+	def_bool y
+	depends on X86_64 && HUGETLB_PAGE && MIGRATION
+
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64 arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/arch/x86/mm/hugetlbpage.c
@@ -58,11 +58,6 @@ follow_huge_pmd(struct mm_struct *mm, un
 {
 	return NULL;
 }
-
-int pmd_huge_support(void)
-{
-	return 0;
-}
 #else
 
 struct page *
@@ -80,11 +75,6 @@ int pud_huge(pud_t pud)
 {
 	return !!(pud_val(pud) & _PAGE_PSE);
 }
-
-int pmd_huge_support(void)
-{
-	return 1;
-}
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN include/linux/hugetlb.h~hugetlb-restrict-hugepage_migration_support-to-x86_64 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/include/linux/hugetlb.h
@@ -392,15 +392,13 @@ static inline pgoff_t basepage_index(str
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
-int pmd_huge_support(void);
-/*
- * Currently hugepage migration is enabled only for pmd-based hugepage.
- * This function will be updated when hugepage migration is more widely
- * supported.
- */
 static inline int hugepage_migration_support(struct hstate *h)
 {
-	return pmd_huge_support() && (huge_page_shift(h) == PMD_SHIFT);
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	return huge_page_shift(h) == PMD_SHIFT;
+#else
+	return 0;
+#endif
 }
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
@@ -450,7 +448,6 @@ static inline pgoff_t basepage_index(str
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
-#define pmd_huge_support()	0
 #define hugepage_migration_support(h)	0
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
diff -puN include/linux/mempolicy.h~hugetlb-restrict-hugepage_migration_support-to-x86_64 include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/include/linux/mempolicy.h
@@ -175,6 +175,12 @@ static inline int vma_migratable(struct
 {
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return 0;
+
+#ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	if (vma->vm_flags & VM_HUGETLB)
+		return 0;
+#endif
+
 	/*
 	 * Migration allocates pages in the highest zone. If we cannot
 	 * do so then migration (at least from node to node) is not
diff -puN mm/Kconfig~hugetlb-restrict-hugepage_migration_support-to-x86_64 mm/Kconfig
--- a/mm/Kconfig~hugetlb-restrict-hugepage_migration_support-to-x86_64
+++ a/mm/Kconfig
@@ -264,6 +264,9 @@ config MIGRATION
 	  pages as migration can relocate pages to satisfy a huge page
 	  allocation instead of reclaiming.
 
+config ARCH_ENABLE_HUGEPAGE_MIGRATION
+	boolean
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch
hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
mm-memory-failurec-move-comment.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
hwpoison-remove-unused-global-variable-in-do_machine_check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

