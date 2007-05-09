From: akpm@linux-foundation.org
Subject: - frv-replace-pgd-management-via-slabs-through-quicklists.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:22 -0700
Message-ID: <200705092148.l49LmMGA002583@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759170AbXEIVsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Replace pgd management via slabs through quicklists
has been removed from the -mm tree.  Its filename was
     frv-replace-pgd-management-via-slabs-through-quicklists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: Replace pgd management via slabs through quicklists
From: Christoph Lameter <clameter@sgi.com>

This is done in order to be able to run SLUB which expects no modifications
to its page structs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig          |    6 +++---
 arch/frv/kernel/process.c |    4 ++++
 arch/frv/mm/pgalloc.c     |   22 +++++++++++-----------
 include/asm-frv/tlb.h     |    4 ++++
 4 files changed, 22 insertions(+), 14 deletions(-)

diff -puN arch/frv/Kconfig~frv-replace-pgd-management-via-slabs-through-quicklists arch/frv/Kconfig
--- a/arch/frv/Kconfig~frv-replace-pgd-management-via-slabs-through-quicklists
+++ a/arch/frv/Kconfig
@@ -45,15 +45,15 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config ARCH_HAS_ILOG2_U32
+config QUICKLIST
 	bool
 	default y
 
-config ARCH_HAS_ILOG2_U64
+config ARCH_HAS_ILOG2_U32
 	bool
 	default y
 
-config ARCH_USES_SLAB_PAGE_STRUCT
+config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
diff -puN arch/frv/kernel/process.c~frv-replace-pgd-management-via-slabs-through-quicklists arch/frv/kernel/process.c
--- a/arch/frv/kernel/process.c~frv-replace-pgd-management-via-slabs-through-quicklists
+++ a/arch/frv/kernel/process.c
@@ -25,12 +25,14 @@
 #include <linux/elf.h>
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
+#include <linux/pagemap.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
+#include <asm/tlb.h>
 #include <asm/gdb-stub.h>
 #include <asm/mb-regs.h>
 
@@ -88,6 +90,8 @@ void cpu_idle(void)
 		while (!need_resched()) {
 			irq_stat[cpu].idle_timestamp = jiffies;
 
+			check_pgt_cache();
+
 			if (!frv_dma_inprogress && idle)
 				idle();
 		}
diff -puN arch/frv/mm/pgalloc.c~frv-replace-pgd-management-via-slabs-through-quicklists arch/frv/mm/pgalloc.c
--- a/arch/frv/mm/pgalloc.c~frv-replace-pgd-management-via-slabs-through-quicklists
+++ a/arch/frv/mm/pgalloc.c
@@ -13,12 +13,12 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/quicklist.h>
 #include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((aligned(PAGE_SIZE)));
-struct kmem_cache *pgd_cache;
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
@@ -100,7 +100,7 @@ static inline void pgd_list_del(pgd_t *p
 		set_page_private(next, (unsigned long) pprev);
 }
 
-void pgd_ctor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
 
@@ -120,7 +120,7 @@ void pgd_ctor(void *pgd, struct kmem_cac
 }
 
 /* never called when PTRS_PER_PMD > 1 */
-void pgd_dtor(void *pgd, struct kmem_cache *cache, unsigned long unused)
+void pgd_dtor(void *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
@@ -133,7 +133,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 
-	pgd = kmem_cache_alloc(pgd_cache, GFP_KERNEL);
+	pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
 	if (!pgd)
 		return pgd;
 
@@ -143,15 +143,15 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 void pgd_free(pgd_t *pgd)
 {
 	/* in the non-PAE case, clear_page_tables() clears user pgd entries */
-	kmem_cache_free(pgd_cache, pgd);
+ 	quicklist_free(0, pgd_dtor, pgd);
 }
 
 void __init pgtable_cache_init(void)
 {
-	pgd_cache = kmem_cache_create("pgd",
-				      PTRS_PER_PGD * sizeof(pgd_t),
-				      PTRS_PER_PGD * sizeof(pgd_t),
-				      SLAB_PANIC,
-				      pgd_ctor,
-				      pgd_dtor);
 }
+
+void check_pgt_cache(void)
+{
+	quicklist_trim(0, pgd_dtor, 25, 16);
+}
+
diff -puN include/asm-frv/tlb.h~frv-replace-pgd-management-via-slabs-through-quicklists include/asm-frv/tlb.h
--- a/include/asm-frv/tlb.h~frv-replace-pgd-management-via-slabs-through-quicklists
+++ a/include/asm-frv/tlb.h
@@ -3,7 +3,11 @@
 
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_MMU
+extern void check_pgt_cache(void);
+#else
 #define check_pgt_cache() do {} while(0)
+#endif
 
 /*
  * we don't need any special per-pte or per-vma handling...
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
