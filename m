From: akpm@linux-foundation.org
Subject: [merged] sparc64-use-rcu-page-table-freeing.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:11 -0700
Message-ID: <201107260752.p6Q7qEVM003103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab1GZHwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     sparc64: use RCU page table freeing
has been removed from the -mm tree.  Its filename was
     sparc64-use-rcu-page-table-freeing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: use RCU page table freeing
From: David S. Miller <davem@davemloft.net>

Make use of the generic RCU page table freeing on Sparc64, doing so allows
for race-free software page-table walkers like gup_fast().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig                  |    1 
 arch/sparc/include/asm/pgalloc_64.h |   48 ++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff -puN arch/sparc/Kconfig~sparc64-use-rcu-page-table-freeing arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~sparc64-use-rcu-page-table-freeing
+++ a/arch/sparc/Kconfig
@@ -41,6 +41,7 @@ config SPARC64
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
+	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_MEMBLOCK
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
diff -puN arch/sparc/include/asm/pgalloc_64.h~sparc64-use-rcu-page-table-freeing arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~sparc64-use-rcu-page-table-freeing
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -76,7 +76,51 @@ static inline void pte_free(struct mm_st
 
 #define check_pgt_cache()	do { } while (0)
 
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+static inline void pgtable_free(void *table, bool is_page)
+{
+	if (is_page)
+		free_page((unsigned long)table);
+	else
+		kmem_cache_free(pgtable_cache, table);
+}
+
+#ifdef CONFIG_SMP
+
+struct mmu_gather;
+extern void tlb_remove_table(struct mmu_gather *, void *);
+
+static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
+{
+	unsigned long pgf = (unsigned long)table;
+	if (is_page)
+		pgf |= 0x1UL;
+	tlb_remove_table(tlb, (void *)pgf);
+}
+
+static inline void __tlb_remove_table(void *_table)
+{
+	void *table = (void *)((unsigned long)_table & ~0x1UL);
+	bool is_page = false;
+
+	if ((unsigned long)_table & 0x1UL)
+		is_page = true;
+	pgtable_free(table, is_page);
+}
+#else /* CONFIG_SMP */
+static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
+{
+	pgtable_free(table, is_page);
+}
+#endif /* !CONFIG_SMP */
+
+static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *ptepage,
+				  unsigned long address)
+{
+	pgtable_page_dtor(ptepage);
+	pgtable_free_tlb(tlb, page_address(ptepage), true);
+}
+
+#define __pmd_free_tlb(tlb, pmd, addr)		      \
+	pgtable_free_tlb(tlb, pmd, false)
 
 #endif /* _SPARC64_PGALLOC_H */
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch

