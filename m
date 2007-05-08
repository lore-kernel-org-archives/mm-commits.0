From: akpm@linux-foundation.org
Subject: + frv-replace-pgd-management-via-slabs-through-quicklists.patch added to -mm tree
Date: Tue, 08 May 2007 16:04:18 -0700
Message-ID: <200705082304.l48N4Ipq004257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968588AbXEHXEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:04:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, dhowells@redhat.com


The patch titled
     FRV: Replace pgd management via slabs through quicklists
has been added to the -mm tree.  Its filename is
     frv-replace-pgd-management-via-slabs-through-quicklists.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
frv-replace-pgd-management-via-slabs-through-quicklists.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
