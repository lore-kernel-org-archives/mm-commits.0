From: akpm@linux-foundation.org
Subject: + arm-mm-enable-rcu-fast_gup.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:23:25 -0700
Message-ID: <542c70cd.EtlqPVzhxiWjlcn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaJAVX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@linaro.org, aarcange@redhat.com, catalin.marinas@arm.com, christoffer.dall@linaro.org, dann.frazier@canonical.com, hughd@google.com, mark.rutland@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: enable RCU fast_gup
has been added to the -mm tree.  Its filename is
     arm-mm-enable-rcu-fast_gup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-enable-rcu-fast_gup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-enable-rcu-fast_gup.patch

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
Subject: arm: mm: enable RCU fast_gup

Activate the RCU fast_gup for ARM.  We also need to force THP splits to
broadcast an IPI s.t.  we block in the fast_gup page walker.  As THP
splits are comparatively rare, this should not lead to a noticeable
performance degradation.

Some pre-requisite functions pud_write and pud_page are also added.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dann Frazier <dann.frazier@canonical.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                      |    4 ++++
 arch/arm/include/asm/pgtable-3level.h |    8 ++++++++
 arch/arm/mm/flush.c                   |   15 +++++++++++++++
 3 files changed, 27 insertions(+)

diff -puN arch/arm/Kconfig~arm-mm-enable-rcu-fast_gup arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-mm-enable-rcu-fast_gup
+++ a/arch/arm/Kconfig
@@ -1646,6 +1646,10 @@ config ARCH_SELECT_MEMORY_MODEL
 config HAVE_ARCH_PFN_VALID
 	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
 
+config HAVE_GENERIC_RCU_GUP
+	def_bool y
+	depends on ARM_LPAE
+
 config HIGHMEM
 	bool "High Memory Support"
 	depends on MMU
diff -puN arch/arm/include/asm/pgtable-3level.h~arm-mm-enable-rcu-fast_gup arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-mm-enable-rcu-fast_gup
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -224,6 +224,8 @@ static inline pte_t pte_mkspecial(pte_t
 #define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		(pmd_isclear((pmd), L_PMD_SECT_RDONLY))
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
+#define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
+#define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
@@ -231,6 +233,12 @@ static inline pte_t pte_mkspecial(pte_t
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
 #define pmd_trans_splitting(pmd) (pmd_isset((pmd), L_PMD_SECT_SPLITTING))
+
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp);
+#endif
 #endif
 
 #define PMD_BIT_FUNC(fn,op) \
diff -puN arch/arm/mm/flush.c~arm-mm-enable-rcu-fast_gup arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c~arm-mm-enable-rcu-fast_gup
+++ a/arch/arm/mm/flush.c
@@ -400,3 +400,18 @@ void __flush_anon_page(struct vm_area_st
 	 */
 	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
 }
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

