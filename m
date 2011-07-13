From: akpm@linux-foundation.org
Subject: + sparc64-kill-page-table-quicklists.patch added to -mm tree
Date: Wed, 13 Jul 2011 15:33:56 -0700
Message-ID: <201107132233.p6DMXuvk007427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab1GMWeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 18:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl


The patch titled
     sparc64: kill page table quicklists
has been added to the -mm tree.  Its filename is
     sparc64-kill-page-table-quicklists.patch

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
Subject: sparc64: kill page table quicklists
From: David S. Miller <davem@davemloft.net>

With the recent mmu_gather changes that included generic RCU freeing of
page-tables, it is now quite straight forward to implement gup_fast() on
sparc64.

This patch:

Remove the page table quicklists.  They are pointless and make it harder
to use RCU page table freeing and share code with other architectures.

BTW, this is the second time this has happened, see commit
3c936465249f863f322154ff1aaa628b84ee5750 ("[SPARC64]: Kill pgtable
quicklists and use SLAB.")

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig                  |    4 ---
 arch/sparc/include/asm/pgalloc_64.h |   32 ++++++++++++--------------
 arch/sparc/mm/tsb.c                 |   11 ++++++++
 3 files changed, 26 insertions(+), 21 deletions(-)

diff -puN arch/sparc/Kconfig~sparc64-kill-page-table-quicklists arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~sparc64-kill-page-table-quicklists
+++ a/arch/sparc/Kconfig
@@ -81,10 +81,6 @@ config IOMMU_HELPER
 	bool
 	default y if SPARC64
 
-config QUICKLIST
-	bool
-	default y if SPARC64
-
 config STACKTRACE_SUPPORT
 	bool
 	default y if SPARC64
diff -puN arch/sparc/include/asm/pgalloc_64.h~sparc64-kill-page-table-quicklists arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~sparc64-kill-page-table-quicklists
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -5,7 +5,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/quicklist.h>
 
 #include <asm/spitfire.h>
 #include <asm/cpudata.h>
@@ -14,69 +13,68 @@
 
 /* Page table allocation/freeing. */
 
+extern struct kmem_cache *pgtable_cache;
+
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	quicklist_free(0, NULL, pgd);
+	kmem_cache_free(pgtable_cache, pgd);
 }
 
 #define pud_populate(MM, PUD, PMD)	pud_set(PUD, PMD)
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return kmem_cache_alloc(pgtable_cache,
+				GFP_KERNEL|__GFP_REPEAT);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
-	quicklist_free(0, NULL, pmd);
+	kmem_cache_free(pgtable_cache, pmd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return quicklist_alloc(0, GFP_KERNEL, NULL);
+	return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
 					unsigned long address)
 {
 	struct page *page;
-	void *pg;
+	pte_t *pte;
 
-	pg = quicklist_alloc(0, GFP_KERNEL, NULL);
-	if (!pg)
+	pte = pte_alloc_one_kernel(mm, address);
+	if (!pte)
 		return NULL;
-	page = virt_to_page(pg);
+	page = virt_to_page(pte);
 	pgtable_page_ctor(page);
 	return page;
 }
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	quicklist_free(0, NULL, pte);
+	free_page((unsigned long)pte);
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t ptepage)
 {
 	pgtable_page_dtor(ptepage);
-	quicklist_free_page(0, NULL, ptepage);
+	__free_page(ptepage);
 }
 
-
 #define pmd_populate_kernel(MM, PMD, PTE)	pmd_set(PMD, PTE)
 #define pmd_populate(MM,PMD,PTE_PAGE)		\
 	pmd_populate_kernel(MM,PMD,page_address(PTE_PAGE))
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
-static inline void check_pgt_cache(void)
-{
-	quicklist_trim(0, NULL, 25, 16);
-}
+#define check_pgt_cache()	do { } while (0)
 
 #define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
 #define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
diff -puN arch/sparc/mm/tsb.c~sparc64-kill-page-table-quicklists arch/sparc/mm/tsb.c
--- a/arch/sparc/mm/tsb.c~sparc64-kill-page-table-quicklists
+++ a/arch/sparc/mm/tsb.c
@@ -236,6 +236,8 @@ static void setup_tsb_params(struct mm_s
 	}
 }
 
+struct kmem_cache *pgtable_cache __read_mostly;
+
 static struct kmem_cache *tsb_caches[8] __read_mostly;
 
 static const char *tsb_cache_names[8] = {
@@ -253,6 +255,15 @@ void __init pgtable_cache_init(void)
 {
 	unsigned long i;
 
+	pgtable_cache = kmem_cache_create("pgtable_cache",
+					  PAGE_SIZE, PAGE_SIZE,
+					  0,
+					  _clear_page);
+	if (!pgtable_cache) {
+		prom_printf("pgtable_cache_init(): Could not create!\n");
+		prom_halt();
+	}
+
 	for (i = 0; i < 8; i++) {
 		unsigned long size = 8192 << i;
 		const char *name = tsb_cache_names[i];
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

