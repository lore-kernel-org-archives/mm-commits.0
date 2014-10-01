From: akpm@linux-foundation.org
Subject: + arm-mm-enable-have_rcu_table_free-logic.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:23:24 -0700
Message-ID: <542c70cc.YywTanmipdcfZCNP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaJAVXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:23:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@linaro.org, aarcange@redhat.com, catalin.marinas@arm.com, christoffer.dall@linaro.org, dann.frazier@canonical.com, hughd@google.com, mark.rutland@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: enable HAVE_RCU_TABLE_FREE logic
has been added to the -mm tree.  Its filename is
     arm-mm-enable-have_rcu_table_free-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-enable-have_rcu_table_free-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-enable-have_rcu_table_free-logic.patch

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
Subject: arm: mm: enable HAVE_RCU_TABLE_FREE logic

In order to implement fast_get_user_pages we need to ensure that the page
table walker is protected from page table pages being freed from under it.

This patch enables HAVE_RCU_TABLE_FREE, any page table pages belonging to
address spaces with multiple users will be call_rcu_sched freed.  Meaning
that disabling interrupts will block the free and protect the fast gup
page walker.

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

 arch/arm/Kconfig           |    1 
 arch/arm/include/asm/tlb.h |   38 +++++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff -puN arch/arm/Kconfig~arm-mm-enable-have_rcu_table_free-logic arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-mm-enable-have_rcu_table_free-logic
+++ a/arch/arm/Kconfig
@@ -61,6 +61,7 @@ config ARM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_RCU_TABLE_FREE if (SMP && ARM_LPAE)
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
diff -puN arch/arm/include/asm/tlb.h~arm-mm-enable-have_rcu_table_free-logic arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~arm-mm-enable-have_rcu_table_free-logic
+++ a/arch/arm/include/asm/tlb.h
@@ -35,12 +35,39 @@
 
 #define MMU_GATHER_BUNDLE	8
 
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+static inline void __tlb_remove_table(void *_table)
+{
+	free_page_and_swap_cache((struct page *)_table);
+}
+
+struct mmu_table_batch {
+	struct rcu_head		rcu;
+	unsigned int		nr;
+	void			*tables[0];
+};
+
+#define MAX_TABLE_BATCH		\
+	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
+
+extern void tlb_table_flush(struct mmu_gather *tlb);
+extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
+
+#define tlb_remove_entry(tlb, entry)	tlb_remove_table(tlb, entry)
+#else
+#define tlb_remove_entry(tlb, entry)	tlb_remove_page(tlb, entry)
+#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+
 /*
  * TLB handling.  This allows us to remove pages from the page
  * tables, and efficiently handle the TLB issues.
  */
 struct mmu_gather {
 	struct mm_struct	*mm;
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	struct mmu_table_batch	*batch;
+	unsigned int		need_flush;
+#endif
 	unsigned int		fullmm;
 	struct vm_area_struct	*vma;
 	unsigned long		start, end;
@@ -101,6 +128,9 @@ static inline void __tlb_alloc_page(stru
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 {
 	tlb_flush(tlb);
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb_table_flush(tlb);
+#endif
 }
 
 static inline void tlb_flush_mmu_free(struct mmu_gather *tlb)
@@ -129,6 +159,10 @@ tlb_gather_mmu(struct mmu_gather *tlb, s
 	tlb->pages = tlb->local;
 	tlb->nr = 0;
 	__tlb_alloc_page(tlb);
+
+#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+	tlb->batch = NULL;
+#endif
 }
 
 static inline void
@@ -205,7 +239,7 @@ static inline void __pte_free_tlb(struct
 	tlb_add_flush(tlb, addr + SZ_1M);
 #endif
 
-	tlb_remove_page(tlb, pte);
+	tlb_remove_entry(tlb, pte);
 }
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
@@ -213,7 +247,7 @@ static inline void __pmd_free_tlb(struct
 {
 #ifdef CONFIG_ARM_LPAE
 	tlb_add_flush(tlb, addr);
-	tlb_remove_page(tlb, virt_to_page(pmdp));
+	tlb_remove_entry(tlb, virt_to_page(pmdp));
 #endif
 }
 
_

Patches currently in -mm which might be from steve.capper@linaro.org are

mm-introduce-a-general-rcu-get_user_pages_fast.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm-mm-introduce-special-ptes-for-lpae.patch
arm-mm-enable-have_rcu_table_free-logic.patch
arm-mm-enable-rcu-fast_gup.patch
arm64-mm-enable-have_rcu_table_free-logic.patch
arm64-mm-enable-rcu-fast_gup.patch

