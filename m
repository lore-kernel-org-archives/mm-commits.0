From: akpm@linux-foundation.org
Subject: - vmi-kmap_atomic_pte-fix.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:58 -0700
Message-ID: <200704252039.l3PKdwns012361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993151AbXDYUkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Vmi kmap_atomic_pte fix
has been removed from the -mm tree.  Its filename was
     vmi-kmap_atomic_pte-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Vmi kmap_atomic_pte fix
From: Zachary Amsden <zach@vmware.com>

Implement vmi_kmap_atomic_pte in terms of the backend set_linear_mapping
operation.  The conversion is rather straighforward; call kmap_atomic and then
inform the hypervisor of the page mapping.

The _flush_tlb damage is due to macros being pulled in from highmem.h.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/vmi.c~vmi-kmap_atomic_pte-fix arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-kmap_atomic_pte-fix
+++ a/arch/i386/kernel/vmi.c
@@ -26,6 +26,7 @@
 #include <linux/cpu.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/vmi.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
@@ -65,8 +66,8 @@ static struct {
 	void (*release_page)(u32, u32);
 	void (*set_pte)(pte_t, pte_t *, unsigned);
 	void (*update_pte)(pte_t *, unsigned);
-	void (*set_linear_mapping)(int, u32, u32, u32);
-	void (*flush_tlb)(int);
+	void (*set_linear_mapping)(int, void *, u32, u32);
+	void (*_flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
   	void (*set_lazy_mode)(int mode);
@@ -221,12 +222,12 @@ static void vmi_load_esp0(struct tss_str
 
 static void vmi_flush_tlb_user(void)
 {
-	vmi_ops.flush_tlb(VMI_FLUSH_TLB);
+	vmi_ops._flush_tlb(VMI_FLUSH_TLB);
 }
 
 static void vmi_flush_tlb_kernel(void)
 {
-	vmi_ops.flush_tlb(VMI_FLUSH_TLB | VMI_FLUSH_GLOBAL);
+	vmi_ops._flush_tlb(VMI_FLUSH_TLB | VMI_FLUSH_GLOBAL);
 }
 
 /* Stub to do nothing at all; used for delays and unimplemented calls */
@@ -349,8 +350,11 @@ static void vmi_check_page_type(u32 pfn,
 #define vmi_check_page_type(p,t) do { } while (0)
 #endif
 
-static void vmi_map_pt_hook(int type, pte_t *va, u32 pfn)
+#ifdef CONFIG_HIGHPTE
+static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 {
+	void *va = kmap_atomic(page, type);
+
 	/*
 	 * Internally, the VMI ROM must map virtual addresses to physical
 	 * addresses for processing MMU updates.  By the time MMU updates
@@ -364,8 +368,11 @@ static void vmi_map_pt_hook(int type, pt
 	 *  args:                 SLOT                 VA    COUNT PFN
 	 */
 	BUG_ON(type != KM_PTE0 && type != KM_PTE1);
-	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, (u32)va, 1, pfn);
+	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, va, 1, page_to_pfn(page));
+
+	return va;
 }
+#endif
 
 static void vmi_allocate_pt(u32 pfn)
 {
@@ -664,7 +671,7 @@ void vmi_bringup(void)
 {
  	/* We must establish the lowmem mapping for MMU ops to work */
 	if (vmi_ops.set_linear_mapping)
-		vmi_ops.set_linear_mapping(0, __PAGE_OFFSET, max_low_pfn, 0);
+		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, max_low_pfn, 0);
 }
 
 /*
@@ -804,8 +811,8 @@ static inline int __init activate_vmi(vo
 	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
-	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
-	para_wrap(flush_tlb_kernel, vmi_flush_tlb_kernel, flush_tlb, FlushTLB);
+	para_wrap(flush_tlb_user, vmi_flush_tlb_user, _flush_tlb, FlushTLB);
+	para_wrap(flush_tlb_kernel, vmi_flush_tlb_kernel, _flush_tlb, FlushTLB);
 	para_fill(flush_tlb_single, InvalPage);
 
 	/*
@@ -851,9 +858,12 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.release_pt = vmi_release_pt;
 		paravirt_ops.release_pd = vmi_release_pd;
 	}
-#if 0
-	para_wrap(map_pt_hook, vmi_map_pt_hook, set_linear_mapping,
-		  SetLinearMapping);
+
+	/* Set linear is needed in all cases */
+	vmi_ops.set_linear_mapping = vmi_get_function(VMI_CALL_SetLinearMapping);
+#ifdef CONFIG_HIGHPTE
+	if (vmi_ops.set_linear_mapping)
+		paravirt_ops.kmap_atomic_pte = vmi_kmap_atomic_pte;
 #endif
 
 	/*
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
