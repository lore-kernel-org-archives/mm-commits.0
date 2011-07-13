From: akpm@linux-foundation.org
Subject: + sparc64-use-rcu-page-table-freeing.patch added to -mm tree
Date: Wed, 13 Jul 2011 15:33:58 -0700
Message-ID: <201107132233.p6DMXwi1007431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab1GMWeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 18:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl


The patch titled
     sparc64: use RCU page table freeing
has been added to the -mm tree.  Its filename is
     sparc64-use-rcu-page-table-freeing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -53,6 +53,7 @@ config SPARC64
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select IRQ_PREFLOW_FASTEOI
+	select HAVE_RCU_TABLE_FREE if SMP
 
 config ARCH_DEFCONFIG
 	string
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

linux-next.patch
maintainers-orphan-framerelay-dlci.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
sparc64-kill-page-table-quicklists.patch
sparc64-use-rcu-page-table-freeing.patch
sparc64-add-support-for-_page_special.patch
sparc64-implement-get_user_pages_fast.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-pm-move-pm-notifiers-into-suspendh-update.patch
notifiers-vt-move-vt-notifiers-into-vth.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch

