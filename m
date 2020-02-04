From: akpm@linux-foundation.org
Subject: [merged] asm-generic-tlb-rename-have_rcu_table_free.patch
 removed from -mm tree
Date: Tue, 04 Feb 2020 10:42:11 -0800
Message-ID: <20200204184211.e969seBVM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbgBDSmO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org


The patch titled
     Subject: asm-generic/tlb: rename HAVE_RCU_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     asm-generic-tlb-rename-have_rcu_table_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: asm-generic/tlb: rename HAVE_RCU_TABLE_FREE

Towards a more consistent naming scheme.

[akpm@linux-foundation.org: fix sparc64 Kconfig]
Link: http://lkml.kernel.org/r/20200116064531.483522-7-aneesh.kumar@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                    |    2 +-
 arch/arm/Kconfig                |    2 +-
 arch/arm/include/asm/tlb.h      |    2 +-
 arch/arm64/Kconfig              |    2 +-
 arch/powerpc/Kconfig            |    2 +-
 arch/s390/Kconfig               |    2 +-
 arch/sparc/Kconfig              |    2 +-
 arch/sparc/include/asm/tlb_64.h |    2 +-
 arch/x86/Kconfig                |    2 +-
 arch/x86/include/asm/tlb.h      |    4 ++--
 include/asm-generic/tlb.h       |   10 +++++-----
 mm/gup.c                        |    2 +-
 mm/mmu_gather.c                 |    8 ++++----
 13 files changed, 21 insertions(+), 21 deletions(-)

--- a/arch/arm64/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/arm64/Kconfig
@@ -165,7 +165,7 @@ config ARM64
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_FUTEX_CMPXCHG if FUTEX
-	select HAVE_RCU_TABLE_FREE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select HAVE_RSEQ
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
--- a/arch/arm/include/asm/tlb.h~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/arm/include/asm/tlb.h
@@ -37,7 +37,7 @@ static inline void __tlb_remove_table(vo
 
 #include <asm-generic/tlb.h>
 
-#ifndef CONFIG_HAVE_RCU_TABLE_FREE
+#ifndef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 #define tlb_remove_table(tlb, entry) tlb_remove_page(tlb, entry)
 #endif
 
--- a/arch/arm/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/arm/Kconfig
@@ -102,7 +102,7 @@ config ARM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE if SMP && ARM_LPAE
+	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
 	select HAVE_STACKPROTECTOR
--- a/arch/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/Kconfig
@@ -393,7 +393,7 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_ARCH_JUMP_LABEL_RELATIVE
 	bool
 
-config HAVE_RCU_TABLE_FREE
+config MMU_GATHER_RCU_TABLE_FREE
 	bool
 
 config HAVE_MMU_GATHER_PAGE_SIZE
--- a/arch/powerpc/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/powerpc/Kconfig
@@ -222,7 +222,7 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select HAVE_MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
--- a/arch/s390/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/s390/Kconfig
@@ -169,7 +169,7 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_PCI
 	select HAVE_PERF_EVENTS
-	select HAVE_RCU_TABLE_FREE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE
 	select HAVE_RSEQ
--- a/arch/sparc/include/asm/tlb_64.h~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/sparc/include/asm/tlb_64.h
@@ -33,7 +33,7 @@ void flush_tlb_pending(void);
  * and therefore we don't need a TLBI when freeing page-table pages.
  */
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 #define tlb_needs_table_invalidate()	(false)
 #endif
 
--- a/arch/sparc/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/sparc/Kconfig
@@ -64,7 +64,7 @@ config SPARC64
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
-	select HAVE_RCU_TABLE_FREE if SMP
+	select MMU_GATHER_RCU_TABLE_FREE if SMP
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
--- a/arch/x86/include/asm/tlb.h~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/x86/include/asm/tlb.h
@@ -29,8 +29,8 @@ static inline void tlb_flush(struct mmu_
  * shootdown, enablement code for several hypervisors overrides
  * .flush_tlb_others hook in pv_mmu_ops and implements it by issuing
  * a hypercall. To keep software pagetable walkers safe in this case we
- * switch to RCU based table free (HAVE_RCU_TABLE_FREE). See the comment
- * below 'ifdef CONFIG_HAVE_RCU_TABLE_FREE' in include/asm-generic/tlb.h
+ * switch to RCU based table free (MMU_GATHER_RCU_TABLE_FREE). See the comment
+ * below 'ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE' in include/asm-generic/tlb.h
  * for more details.
  */
 static inline void __tlb_remove_table(void *table)
--- a/arch/x86/Kconfig~asm-generic-tlb-rename-have_rcu_table_free
+++ a/arch/x86/Kconfig
@@ -203,7 +203,7 @@ config X86
 	select HAVE_PCI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-	select HAVE_RCU_TABLE_FREE		if PARAVIRT
+	select MMU_GATHER_RCU_TABLE_FREE		if PARAVIRT
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if X86_64 && (UNWINDER_FRAME_POINTER || UNWINDER_ORC) && STACK_VALIDATION
 	select HAVE_FUNCTION_ARG_ACCESS_API
--- a/include/asm-generic/tlb.h~asm-generic-tlb-rename-have_rcu_table_free
+++ a/include/asm-generic/tlb.h
@@ -126,7 +126,7 @@
  *  This ensures we call tlb_flush() every time tlb_change_page_size() actually
  *  changes the size and provides mmu_gather::page_size to tlb_flush().
  *
- *  HAVE_RCU_TABLE_FREE
+ *  MMU_GATHER_RCU_TABLE_FREE
  *
  *  This provides tlb_remove_table(), to be used instead of tlb_remove_page()
  *  for page directores (__p*_free_tlb()). This provides separate freeing of
@@ -142,7 +142,7 @@
  *  Use this if your architecture lacks an efficient flush_tlb_range().
  */
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 /*
  * Semi RCU freeing of the page directories.
  *
@@ -193,10 +193,10 @@ extern void tlb_remove_table(struct mmu_
 #else
 
 #ifdef tlb_needs_table_invalidate
-#error tlb_needs_table_invalidate() requires HAVE_RCU_TABLE_FREE
+#error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
 #endif
 
-#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+#endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
 #ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
@@ -235,7 +235,7 @@ extern bool __tlb_remove_page_size(struc
 struct mmu_gather {
 	struct mm_struct	*mm;
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	struct mmu_table_batch	*batch;
 #endif
 
--- a/mm/gup.c~asm-generic-tlb-rename-have_rcu_table_free
+++ a/mm/gup.c
@@ -1792,7 +1792,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * Before activating this code, please be aware that the following assumptions
  * are currently made:
  *
- *  *) Either HAVE_RCU_TABLE_FREE is enabled, and tlb_remove_table() is used to
+ *  *) Either MMU_GATHER_RCU_TABLE_FREE is enabled, and tlb_remove_table() is used to
  *  free pages containing page tables or TLB flushing requires IPI broadcast.
  *
  *  *) ptes can be read atomically by the architecture.
--- a/mm/mmu_gather.c~asm-generic-tlb-rename-have_rcu_table_free
+++ a/mm/mmu_gather.c
@@ -91,7 +91,7 @@ bool __tlb_remove_page_size(struct mmu_g
 
 #endif /* HAVE_MMU_GATHER_NO_GATHER */
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 
 /*
  * See the comment near struct mmu_table_batch.
@@ -173,11 +173,11 @@ void tlb_remove_table(struct mmu_gather
 		tlb_table_flush(tlb);
 }
 
-#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
+#endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 static void tlb_flush_mmu_free(struct mmu_gather *tlb)
 {
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
 #ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
@@ -220,7 +220,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 	tlb->batch_count = 0;
 #endif
 
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	tlb->batch = NULL;
 #endif
 #ifdef CONFIG_HAVE_MMU_GATHER_PAGE_SIZE
_

Patches currently in -mm which might be from peterz@infradead.org are
