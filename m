From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 55/67] asm-generic/tlb: rename
 HAVE_MMU_GATHER_NO_GATHER
Date: Mon, 03 Feb 2020 17:37:08 -0800
Message-ID: <20200204013708.EcwITKu3s%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBhJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:09 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org, torvalds@linux-foundation.org

From: Peter Zijlstra <peterz@infradead.org>
Subject: asm-generic/tlb: rename HAVE_MMU_GATHER_NO_GATHER

Towards a more consistent naming scheme.

Link: http://lkml.kernel.org/r/20200116064531.483522-9-aneesh.kumar@linux.ibm.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig              |    2 +-
 arch/s390/Kconfig         |    2 +-
 include/asm-generic/tlb.h |   14 ++++++++++++--
 mm/mmu_gather.c           |   10 +++++-----
 4 files changed, 19 insertions(+), 9 deletions(-)

--- a/arch/Kconfig~asm-generic-tlb-rename-have_mmu_gather_no_gather
+++ a/arch/Kconfig
@@ -402,7 +402,7 @@ config MMU_GATHER_PAGE_SIZE
 config MMU_GATHER_NO_RANGE
 	bool
 
-config HAVE_MMU_GATHER_NO_GATHER
+config MMU_GATHER_NO_GATHER
 	bool
 
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/s390/Kconfig~asm-generic-tlb-rename-have_mmu_gather_no_gather
+++ a/arch/s390/Kconfig
@@ -163,7 +163,7 @@ config S390
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MEMBLOCK_PHYS_MAP
-	select HAVE_MMU_GATHER_NO_GATHER
+	select MMU_GATHER_NO_GATHER
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NOP_MCOUNT
 	select HAVE_OPROFILE
--- a/include/asm-generic/tlb.h~asm-generic-tlb-rename-have_mmu_gather_no_gather
+++ a/include/asm-generic/tlb.h
@@ -143,6 +143,16 @@
  *  MMU_GATHER_NO_RANGE
  *
  *  Use this if your architecture lacks an efficient flush_tlb_range().
+ *
+ *  MMU_GATHER_NO_GATHER
+ *
+ *  If the option is set the mmu_gather will not track individual pages for
+ *  delayed page free anymore. A platform that enables the option needs to
+ *  provide its own implementation of the __tlb_remove_page_size() function to
+ *  free pages.
+ *
+ *  This is useful if your architecture already flushes TLB entries in the
+ *  various ptep_get_and_clear() functions.
  */
 
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
@@ -202,7 +212,7 @@ extern void tlb_remove_table(struct mmu_
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
-#ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
+#ifndef CONFIG_MMU_GATHER_NO_GATHER
 /*
  * If we can't allocate a page to make a big batch of page pointers
  * to work on, then just handle a few from the on-stack structure.
@@ -277,7 +287,7 @@ struct mmu_gather {
 
 	unsigned int		batch_count;
 
-#ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
+#ifndef CONFIG_MMU_GATHER_NO_GATHER
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
 	struct page		*__pages[MMU_GATHER_BUNDLE];
--- a/mm/mmu_gather.c~asm-generic-tlb-rename-have_mmu_gather_no_gather
+++ a/mm/mmu_gather.c
@@ -11,7 +11,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
-#ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
+#ifndef CONFIG_MMU_GATHER_NO_GATHER
 
 static bool tlb_next_batch(struct mmu_gather *tlb)
 {
@@ -89,7 +89,7 @@ bool __tlb_remove_page_size(struct mmu_g
 	return false;
 }
 
-#endif /* HAVE_MMU_GATHER_NO_GATHER */
+#endif /* MMU_GATHER_NO_GATHER */
 
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 
@@ -180,7 +180,7 @@ static void tlb_flush_mmu_free(struct mm
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
-#ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
+#ifndef CONFIG_MMU_GATHER_NO_GATHER
 	tlb_batch_pages_flush(tlb);
 #endif
 }
@@ -211,7 +211,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 	/* Is it from 0 to ~0? */
 	tlb->fullmm     = !(start | (end+1));
 
-#ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
+#ifndef CONFIG_MMU_GATHER_NO_GATHER
 	tlb->need_flush_all = 0;
 	tlb->local.next = NULL;
 	tlb->local.nr   = 0;
@@ -271,7 +271,7 @@ void tlb_finish_mmu(struct mmu_gather *t
 
 	tlb_flush_mmu(tlb);
 
-#ifndef CONFIG_HAVE_MMU_GATHER_NO_GATHER
+#ifndef CONFIG_MMU_GATHER_NO_GATHER
 	tlb_batch_list_free(tlb);
 #endif
 	dec_tlb_flush_pending(tlb->mm);
_
