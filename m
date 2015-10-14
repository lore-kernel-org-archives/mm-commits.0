From: akpm@linux-foundation.org
Subject: +
 mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch added to
 -mm tree
Date: Wed, 14 Oct 2015 14:13:19 -0700
Message-ID: <561ec56f.A4bPGpoWxmLzynBm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbJNVNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mips, thp: remove infrastructure for handling splitting PMDs
has been added to the -mm tree.  Its filename is
     mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch

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
Subject: mips, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

pmdp_splitting_flush() is not needed too: on splitting PMD we will do
pmdp_clear_flush() + set_pte_at(). pmdp_clear_flush() will do IPI as
needed for fast_gup.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable-bits.h |   10 ++++------
 arch/mips/include/asm/pgtable.h      |   18 ------------------
 arch/mips/mm/gup.c                   |   13 +------------
 arch/mips/mm/pgtable-64.c            |   14 --------------
 arch/mips/mm/tlbex.c                 |    1 -
 5 files changed, 5 insertions(+), 51 deletions(-)

diff -puN arch/mips/include/asm/pgtable-bits.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/include/asm/pgtable-bits.h
--- a/arch/mips/include/asm/pgtable-bits.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/include/asm/pgtable-bits.h
@@ -131,14 +131,12 @@
 /* Huge TLB page */
 #define _PAGE_HUGE_SHIFT	(_PAGE_MODIFIED_SHIFT + 1)
 #define _PAGE_HUGE		(1 << _PAGE_HUGE_SHIFT)
-#define _PAGE_SPLITTING_SHIFT	(_PAGE_HUGE_SHIFT + 1)
-#define _PAGE_SPLITTING		(1 << _PAGE_SPLITTING_SHIFT)
 #endif	/* CONFIG_64BIT && CONFIG_MIPS_HUGE_TLB_SUPPORT */
 
 #if defined(CONFIG_CPU_MIPSR2) || defined(CONFIG_CPU_MIPSR6)
 /* XI - page cannot be executed */
-#ifdef _PAGE_SPLITTING_SHIFT
-#define _PAGE_NO_EXEC_SHIFT	(_PAGE_SPLITTING_SHIFT + 1)
+#ifdef _PAGE_HUGE_SHIFT
+#define _PAGE_NO_EXEC_SHIFT	(_PAGE_HUGE_SHIFT + 1)
 #else
 #define _PAGE_NO_EXEC_SHIFT	(_PAGE_MODIFIED_SHIFT + 1)
 #endif
@@ -153,8 +151,8 @@
 
 #if defined(_PAGE_NO_READ_SHIFT)
 #define _PAGE_GLOBAL_SHIFT	(_PAGE_NO_READ_SHIFT + 1)
-#elif defined(_PAGE_SPLITTING_SHIFT)
-#define _PAGE_GLOBAL_SHIFT	(_PAGE_SPLITTING_SHIFT + 1)
+#elif defined(_PAGE_HUGE_SHIFT)
+#define _PAGE_GLOBAL_SHIFT	(_PAGE_HUGE_SHIFT + 1)
 #else
 #define _PAGE_GLOBAL_SHIFT	(_PAGE_MODIFIED_SHIFT + 1)
 #endif
diff -puN arch/mips/include/asm/pgtable.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/include/asm/pgtable.h
@@ -482,27 +482,9 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd
 	return pmd;
 }
 
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return !!(pmd_val(pmd) & _PAGE_SPLITTING);
-}
-
-static inline pmd_t pmd_mksplitting(pmd_t pmd)
-{
-	pmd_val(pmd) |= _PAGE_SPLITTING;
-
-	return pmd;
-}
-
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t pmd);
 
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-/* Extern to avoid header file madness */
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-					unsigned long address,
-					pmd_t *pmdp);
-
 #define __HAVE_ARCH_PMD_WRITE
 static inline int pmd_write(pmd_t pmd)
 {
diff -puN arch/mips/mm/gup.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/mm/gup.c
--- a/arch/mips/mm/gup.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/mm/gup.c
@@ -107,18 +107,7 @@ static int gup_pmd_range(pud_t pud, unsi
 		pmd_t pmd = *pmdp;
 
 		next = pmd_addr_end(addr, end);
-		/*
-		 * The pmd_trans_splitting() check below explains why
-		 * pmdp_splitting_flush has to flush the tlb, to stop
-		 * this gup-fast code from running while we set the
-		 * splitting bit in the pmd. Returning zero will take
-		 * the slow path that will call wait_split_huge_page()
-		 * if the pmd is still in splitting state. gup-fast
-		 * can't because it has irq disabled and
-		 * wait_split_huge_page() would never return as the
-		 * tlb flush IPI wouldn't run.
-		 */
-		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
+		if (pmd_none(pmd))
 			return 0;
 		if (unlikely(pmd_huge(pmd))) {
 			if (!gup_huge_pmd(pmd, addr, next, write, pages,nr))
diff -puN arch/mips/mm/pgtable-64.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/mm/pgtable-64.c
--- a/arch/mips/mm/pgtable-64.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/mm/pgtable-64.c
@@ -62,20 +62,6 @@ void pmd_init(unsigned long addr, unsign
 }
 #endif
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
-void pmdp_splitting_flush(struct vm_area_struct *vma,
-			 unsigned long address,
-			 pmd_t *pmdp)
-{
-	if (!pmd_trans_splitting(*pmdp)) {
-		pmd_t pmd = pmd_mksplitting(*pmdp);
-		set_pmd_at(vma->vm_mm, address, pmdp, pmd);
-	}
-}
-
-#endif
-
 pmd_t mk_pmd(struct page *page, pgprot_t prot)
 {
 	pmd_t pmd;
diff -puN arch/mips/mm/tlbex.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/mm/tlbex.c
@@ -240,7 +240,6 @@ static void output_pgtable_bits_defines(
 	pr_define("_PAGE_MODIFIED_SHIFT %d\n", _PAGE_MODIFIED_SHIFT);
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	pr_define("_PAGE_HUGE_SHIFT %d\n", _PAGE_HUGE_SHIFT);
-	pr_define("_PAGE_SPLITTING_SHIFT %d\n", _PAGE_SPLITTING_SHIFT);
 #endif
 #ifdef CONFIG_CPU_MIPSR2
 	if (cpu_has_rixi) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-support-madvisemadv_free-fix-3.patch

