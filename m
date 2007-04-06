From: akpm@linux-foundation.org
Subject: + paravirt_ops-revert-map_pt_hook.patch added to -mm tree
Date: Fri, 06 Apr 2007 16:26:47 -0700
Message-ID: <200704062326.l36NQl3A022541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38375 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbXDFX0u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 19:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, zach@vmware.com


The patch titled
     paravirt_ops: revert map_pt_hook.
has been added to the -mm tree.  Its filename is
     paravirt_ops-revert-map_pt_hook.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -853,8 +853,10 @@ static inline int __init activate_vmi(vo
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
@@ -862,11 +860,6 @@ static inline void flush_tlb_others(cpum
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
@@ -272,7 +272,6 @@ static inline void vmalloc_sync_all(void
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
-#define paravirt_map_pt_hook(slot, va, pfn)	do { } while (0)
 
 #define raw_ptep_get_and_clear(xp)     native_ptep_get_and_clear(xp)
 #endif
@@ -481,24 +480,10 @@ extern pte_t *lookup_address(unsigned lo
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

paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
