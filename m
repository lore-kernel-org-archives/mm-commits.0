From: akpm@linux-foundation.org
Subject: + arm64-mm-enable-rcu-fast_gup.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:23:27 -0700
Message-ID: <542c70cf.Rh4VBdVC8rs6J2U4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaJAVX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@linaro.org, aarcange@redhat.com, catalin.marinas@arm.com, christoffer.dall@linaro.org, dann.frazier@canonical.com, hughd@google.com, mark.rutland@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: enable RCU fast_gup
has been added to the -mm tree.  Its filename is
     arm64-mm-enable-rcu-fast_gup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-enable-rcu-fast_gup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-enable-rcu-fast_gup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Capper <steve.capper@linaro.org>
Subject: arm64: mm: enable RCU fast_gup

Activate the RCU fast_gup for ARM64.  We also need to force THP splits to
broadcast an IPI s.t.  we block in the fast_gup page walker.  As THP
splits are comparatively rare, this should not lead to a noticeable
performance degradation.

Some pre-requisite functions pud_write and pud_page are also added.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    3 +++
 arch/arm64/include/asm/pgtable.h |   21 ++++++++++++++++++++-
 arch/arm64/mm/flush.c            |   15 +++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff -puN arch/arm64/Kconfig~arm64-mm-enable-rcu-fast_gup arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-enable-rcu-fast_gup
+++ a/arch/arm64/Kconfig
@@ -109,6 +109,9 @@ config GENERIC_CALIBRATE_DELAY
 config ZONE_DMA
 	def_bool y
 
+config HAVE_GENERIC_RCU_GUP
+	def_bool y
+
 config ARCH_DMA_ADDR_T_64BIT
 	def_bool y
 
diff -puN arch/arm64/include/asm/pgtable.h~arm64-mm-enable-rcu-fast_gup arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-enable-rcu-fast_gup
+++ a/arch/arm64/include/asm/pgtable.h
@@ -239,6 +239,16 @@ static inline void set_pte_at(struct mm_
 
 #define __HAVE_ARCH_PTE_SPECIAL
 
+static inline pte_t pud_pte(pud_t pud)
+{
+	return __pte(pud_val(pud));
+}
+
+static inline pmd_t pud_pmd(pud_t pud)
+{
+	return __pmd(pud_val(pud));
+}
+
 static inline pte_t pmd_pte(pmd_t pmd)
 {
 	return __pte(pmd_val(pmd));
@@ -256,7 +266,13 @@ static inline pmd_t pte_pmd(pte_t pte)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT))
 #define pmd_trans_splitting(pmd)	pte_special(pmd_pte(pmd))
-#endif
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+struct vm_area_struct;
+void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp);
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
@@ -277,6 +293,7 @@ static inline pmd_t pte_pmd(pte_t pte)
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
 #define pmd_page(pmd)           pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
+#define pud_write(pud)		pte_write(pud_pte(pud))
 #define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
 
 #define set_pmd_at(mm, addr, pmdp, pmd)	set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd))
@@ -376,6 +393,8 @@ static inline pmd_t *pmd_offset(pud_t *p
 	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
 }
 
+#define pud_page(pud)           pmd_page(pud_pmd(pud))
+
 #endif	/* CONFIG_ARM64_PGTABLE_LEVELS > 2 */
 
 #if CONFIG_ARM64_PGTABLE_LEVELS > 3
diff -puN arch/arm64/mm/flush.c~arm64-mm-enable-rcu-fast_gup arch/arm64/mm/flush.c
--- a/arch/arm64/mm/flush.c~arm64-mm-enable-rcu-fast_gup
+++ a/arch/arm64/mm/flush.c
@@ -104,3 +104,18 @@ EXPORT_SYMBOL(flush_dcache_page);
  */
 EXPORT_SYMBOL(flush_cache_all);
 EXPORT_SYMBOL(flush_icache_range);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp)
+{
+	pmd_t pmd = pmd_mksplitting(*pmdp);
+	VM_BUG_ON(address & ~PMD_MASK);
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
+
+	/* dummy IPI to serialise against fast_gup */
+	kick_all_cpus_sync();
+}
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from steve.capper@linaro.org are

mm-introduce-a-general-rcu-get_user_pages_fast.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm-mm-introduce-special-ptes-for-lpae.patch
arm-mm-enable-have_rcu_table_free-logic.patch
arm-mm-enable-rcu-fast_gup.patch
arm64-mm-enable-have_rcu_table_free-logic.patch
arm64-mm-enable-rcu-fast_gup.patch

