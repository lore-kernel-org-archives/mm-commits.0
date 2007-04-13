From: akpm@linux-foundation.org
Subject: - paravirt_ops-revert-map_pt_hook.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:31 -0700
Message-ID: <200704132330.l3DNUVrB012744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161232AbXDMXae (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: revert map_pt_hook.
has been removed from the -mm tree.  Its filename was
     paravirt_ops-revert-map_pt_hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: revert map_pt_hook.
From: Jeremy Fitzhardinge <jeremy@goop.org>

Back out the map_pt_hook to clear the way for kmap_atomic_pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    2 --
 arch/i386/kernel/vmi.c      |    2 ++
 include/asm-i386/paravirt.h |    7 -------
 include/asm-i386/pgtable.h  |   23 ++++-------------------
 4 files changed, 6 insertions(+), 28 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-revert-map_pt_hook arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-revert-map_pt_hook
+++ a/arch/i386/kernel/paravirt.c
@@ -302,8 +302,6 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
 
-	.map_pt_hook = paravirt_nop,
-
 	.alloc_pt = paravirt_nop,
 	.alloc_pd = paravirt_nop,
 	.alloc_pd_clone = paravirt_nop,
diff -puN arch/i386/kernel/vmi.c~paravirt_ops-revert-map_pt_hook arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt_ops-revert-map_pt_hook
+++ a/arch/i386/kernel/vmi.c
@@ -827,8 +827,10 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.release_pt = vmi_release_pt;
 		paravirt_ops.release_pd = vmi_release_pd;
 	}
+#if 0
 	para_wrap(map_pt_hook, vmi_map_pt_hook, set_linear_mapping,
 		  SetLinearMapping);
+#endif
 
 	/*
 	 * These MUST always be patched.  Don't support indirect jumps
diff -puN include/asm-i386/paravirt.h~paravirt_ops-revert-map_pt_hook include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-revert-map_pt_hook
+++ a/include/asm-i386/paravirt.h
@@ -169,8 +169,6 @@ struct paravirt_ops
 	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
 				 unsigned long va);
 
-	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
-
 	/* Hooks for allocating/releasing pagetable pages */
 	void (*alloc_pt)(u32 pfn);
 	void (*alloc_pd)(u32 pfn);
@@ -732,11 +730,6 @@ static inline void flush_tlb_others(cpum
 	PVOP_VCALL3(flush_tlb_others, &cpumask, mm, va);
 }
 
-static inline void paravirt_map_pt_hook(int type, pte_t *va, u32 pfn)
-{
-	PVOP_VCALL3(map_pt_hook, type, va, pfn);
-}
-
 static inline void paravirt_alloc_pt(unsigned pfn)
 {
 	PVOP_VCALL1(alloc_pt, pfn);
diff -puN include/asm-i386/pgtable.h~paravirt_ops-revert-map_pt_hook include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~paravirt_ops-revert-map_pt_hook
+++ a/include/asm-i386/pgtable.h
@@ -267,7 +267,6 @@ extern void vmalloc_sync_all(void);
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
-#define paravirt_map_pt_hook(slot, va, pfn)	do { } while (0)
 
 #define raw_ptep_get_and_clear(xp)     native_ptep_get_and_clear(xp)
 #endif
@@ -476,24 +475,10 @@ extern pte_t *lookup_address(unsigned lo
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address)				\
-({								\
-	pte_t *__ptep;						\
-	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
-	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE0);\
-	paravirt_map_pt_hook(KM_PTE0,__ptep, pfn);		\
-	__ptep = __ptep + pte_index(address);			\
-	__ptep;							\
-})
-#define pte_offset_map_nested(dir, address)			\
-({								\
-	pte_t *__ptep;						\
-	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
-	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE1);\
-	paravirt_map_pt_hook(KM_PTE1,__ptep, pfn);		\
-	__ptep = __ptep + pte_index(address);			\
-	__ptep;							\
-})
+#define pte_offset_map(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+#define pte_offset_map_nested(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
