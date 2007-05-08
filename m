From: akpm@linux-foundation.org
Subject: - quicklist-support-for-sparc64.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:08 -0700
Message-ID: <200705080003.l48038B5008921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967335AbXEHADn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, ak@suse.de, clameter@sgi.com, tony.luck@intel.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Quicklist support for sparc64
has been removed from the -mm tree.  Its filename was
     quicklist-support-for-sparc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Quicklist support for sparc64
From: David Miller <davem@davemloft.net>

I ported this to sparc64 as per the patch below, tested on UP SunBlade1500 and
24 cpu Niagara T1000.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/Kconfig          |    4 ++++
 arch/sparc64/mm/init.c        |   24 ------------------------
 arch/sparc64/mm/tsb.c         |    2 +-
 include/asm-sparc64/pgalloc.h |   26 ++++++++++++++------------
 4 files changed, 19 insertions(+), 37 deletions(-)

diff -puN arch/sparc64/Kconfig~quicklist-support-for-sparc64 arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~quicklist-support-for-sparc64
+++ a/arch/sparc64/Kconfig
@@ -34,6 +34,10 @@ config MMU
 	bool
 	default y
 
+config QUICKLIST
+	bool
+	default y
+
 config STACKTRACE_SUPPORT
 	bool
 	default y
diff -puN arch/sparc64/mm/init.c~quicklist-support-for-sparc64 arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~quicklist-support-for-sparc64
+++ a/arch/sparc64/mm/init.c
@@ -164,30 +164,6 @@ unsigned long sparc64_kern_sec_context _
 
 int bigkernel = 0;
 
-struct kmem_cache *pgtable_cache __read_mostly;
-
-static void zero_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
-{
-	clear_page(addr);
-}
-
-extern void tsb_cache_init(void);
-
-void pgtable_cache_init(void)
-{
-	pgtable_cache = kmem_cache_create("pgtable_cache",
-					  PAGE_SIZE, PAGE_SIZE,
-					  SLAB_HWCACHE_ALIGN |
-					  SLAB_MUST_HWCACHE_ALIGN,
-					  zero_ctor,
-					  NULL);
-	if (!pgtable_cache) {
-		prom_printf("Could not create pgtable_cache\n");
-		prom_halt();
-	}
-	tsb_cache_init();
-}
-
 #ifdef CONFIG_DEBUG_DCFLUSH
 atomic_t dcpage_flushes = ATOMIC_INIT(0);
 #ifdef CONFIG_SMP
diff -puN arch/sparc64/mm/tsb.c~quicklist-support-for-sparc64 arch/sparc64/mm/tsb.c
--- a/arch/sparc64/mm/tsb.c~quicklist-support-for-sparc64
+++ a/arch/sparc64/mm/tsb.c
@@ -252,7 +252,7 @@ static const char *tsb_cache_names[8] = 
 	"tsb_1MB",
 };
 
-void __init tsb_cache_init(void)
+void __init pgtable_cache_init(void)
 {
 	unsigned long i;
 
diff -puN include/asm-sparc64/pgalloc.h~quicklist-support-for-sparc64 include/asm-sparc64/pgalloc.h
--- a/include/asm-sparc64/pgalloc.h~quicklist-support-for-sparc64
+++ a/include/asm-sparc64/pgalloc.h
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/quicklist.h>
 
 #include <asm/spitfire.h>
 #include <asm/cpudata.h>
@@ -13,52 +14,50 @@
 #include <asm/page.h>
 
 /* Page table allocation/freeing. */
-extern struct kmem_cache *pgtable_cache;
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pgd_free(pgd_t *pgd)
 {
-	kmem_cache_free(pgtable_cache, pgd);
+	quicklist_free(0, NULL, pgd);
 }
 
 #define pud_populate(MM, PUD, PMD)	pud_set(PUD, PMD)
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(pgtable_cache,
-				GFP_KERNEL|__GFP_REPEAT);
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline void pmd_free(pmd_t *pmd)
 {
-	kmem_cache_free(pgtable_cache, pmd);
+	quicklist_free(0, NULL, pmd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return kmem_cache_alloc(pgtable_cache,
-				GFP_KERNEL|__GFP_REPEAT);
+	return quicklist_alloc(0, GFP_KERNEL, NULL);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
 					 unsigned long address)
 {
-	return virt_to_page(pte_alloc_one_kernel(mm, address));
+	void *pg = quicklist_alloc(0, GFP_KERNEL, NULL);
+	return pg ? virt_to_page(pg) : NULL;
 }
 		
 static inline void pte_free_kernel(pte_t *pte)
 {
-	kmem_cache_free(pgtable_cache, pte);
+	quicklist_free(0, NULL, pte);
 }
 
 static inline void pte_free(struct page *ptepage)
 {
-	pte_free_kernel(page_address(ptepage));
+	quicklist_free_page(0, NULL, ptepage);
 }
 
 
@@ -66,6 +65,9 @@ static inline void pte_free(struct page 
 #define pmd_populate(MM,PMD,PTE_PAGE)		\
 	pmd_populate_kernel(MM,PMD,page_address(PTE_PAGE))
 
-#define check_pgt_cache()	do { } while (0)
+static inline void check_pgt_cache(void)
+{
+	quicklist_trim(0, NULL, 25, 16);
+}
 
 #endif /* _SPARC64_PGALLOC_H */
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
networking-fix-sending-netlink-message-when-replace-route.patch
remove-pci_dac_dma_-apis.patch
increase-slab-redzone-to-64bits.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
simplify-the-stacktrace-code.patch
merge-compat_ioctlh-into-compat_ioctlc.patch
consolidate-asm-consth-to-linux-consth.patch
consolidate-asm-consth-to-linux-consth-fix.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
