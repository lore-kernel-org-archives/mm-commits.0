From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 54/67] asm-generic/tlb: rename
 HAVE_MMU_GATHER_PAGE_SIZE
Date: Mon, 03 Feb 2020 17:37:05 -0800
Message-ID: <20200204013705.UaiGOUynG%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgBDBhG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:06 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org, torvalds@linux-foundation.org

From: Peter Zijlstra <peterz@infradead.org>
Subject: asm-generic/tlb: rename HAVE_MMU_GATHER_PAGE_SIZE

Towards a more consistent naming scheme.

Link: http://lkml.kernel.org/r/20200116064531.483522-8-aneesh.kumar@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig              |    2 +-
 arch/powerpc/Kconfig      |    2 +-
 include/asm-generic/tlb.h |    9 ++++++---
 mm/mmu_gather.c           |    4 ++--
 4 files changed, 10 insertions(+), 7 deletions(-)

--- a/arch/Kconfig~asm-generic-tlb-rename-have_mmu_gather_page_size
+++ a/arch/Kconfig
@@ -396,7 +396,7 @@ config HAVE_ARCH_JUMP_LABEL_RELATIVE
 config MMU_GATHER_RCU_TABLE_FREE
 	bool
 
-config HAVE_MMU_GATHER_PAGE_SIZE
+config MMU_GATHER_PAGE_SIZE
 	bool
 
 config MMU_GATHER_NO_RANGE
--- a/arch/powerpc/Kconfig~asm-generic-tlb-rename-have_mmu_gather_page_size
+++ a/arch/powerpc/Kconfig
@@ -223,7 +223,7 @@ config PPC
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select MMU_GATHER_RCU_TABLE_FREE
-	select HAVE_MMU_GATHER_PAGE_SIZE
+	select MMU_GATHER_PAGE_SIZE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
 	select HAVE_SYSCALL_TRACEPOINTS
--- a/include/asm-generic/tlb.h~asm-generic-tlb-rename-have_mmu_gather_page_size
+++ a/include/asm-generic/tlb.h
@@ -121,11 +121,14 @@
  *
  * Additionally there are a few opt-in features:
  *
- *  HAVE_MMU_GATHER_PAGE_SIZE
+ *  MMU_GATHER_PAGE_SIZE
  *
  *  This ensures we call tlb_flush() every time tlb_change_page_size() actually
  *  changes the size and provides mmu_gather::page_size to tlb_flush().
  *
+ *  This might be useful if your architecture has size specific TLB
+ *  invalidation instructions.
+ *
  *  MMU_GATHER_RCU_TABLE_FREE
  *
  *  This provides tlb_remove_table(), to be used instead of tlb_remove_page()
@@ -279,7 +282,7 @@ struct mmu_gather {
 	struct mmu_gather_batch	local;
 	struct page		*__pages[MMU_GATHER_BUNDLE];
 
-#ifdef CONFIG_HAVE_MMU_GATHER_PAGE_SIZE
+#ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	unsigned int page_size;
 #endif
 #endif
@@ -435,7 +438,7 @@ static inline void tlb_remove_page(struc
 static inline void tlb_change_page_size(struct mmu_gather *tlb,
 						     unsigned int page_size)
 {
-#ifdef CONFIG_HAVE_MMU_GATHER_PAGE_SIZE
+#ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	if (tlb->page_size && tlb->page_size != page_size) {
 		if (!tlb->fullmm && !tlb->need_flush_all)
 			tlb_flush_mmu(tlb);
--- a/mm/mmu_gather.c~asm-generic-tlb-rename-have_mmu_gather_page_size
+++ a/mm/mmu_gather.c
@@ -69,7 +69,7 @@ bool __tlb_remove_page_size(struct mmu_g
 
 	VM_BUG_ON(!tlb->end);
 
-#ifdef CONFIG_HAVE_MMU_GATHER_PAGE_SIZE
+#ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	VM_WARN_ON(tlb->page_size != page_size);
 #endif
 
@@ -223,7 +223,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	tlb->batch = NULL;
 #endif
-#ifdef CONFIG_HAVE_MMU_GATHER_PAGE_SIZE
+#ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	tlb->page_size = 0;
 #endif
 
_
