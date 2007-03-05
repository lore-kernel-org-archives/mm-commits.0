From: akpm@linux-foundation.org
Subject: - vmi-fix-highpte.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:55:17 -0800
Message-ID: <200703052355.l25NtH9V005176@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXCEXzT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     vmi: fix highpte
has been removed from the -mm tree.  Its filename was
     vmi-fix-highpte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmi: fix highpte
From: Zachary Amsden <zach@vmware.com>

Provide a PT map hook for HIGHPTE kernels to designate where they are mapping
page tables.  This information is required so the physical address of PTE
updates can be determined; otherwise, the mm layer would have to carry the
physical address all the way to each PTE modification callsite, which is even
more hideous that the macros required to provide the proper hooks.

So lets not mess up arch neutral code to achieve this, but keep the horror in
an #ifdef HIGHPTE in include/asm-i386/pgtable.h.  I had to use macros here
because some types are not yet defined in all the include paths for this
header.

This patch is absolutely required for HIGHPTE kernels to operate properly with
VMI.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    2 ++
 arch/i386/kernel/vmi.c      |   19 +++++++++++++++++++
 include/asm-i386/paravirt.h |    4 ++++
 include/asm-i386/pgtable.h  |   23 +++++++++++++++++++----
 4 files changed, 44 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~vmi-fix-highpte arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~vmi-fix-highpte
+++ a/arch/i386/kernel/paravirt.c
@@ -553,6 +553,8 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
 
+	.map_pt_hook = (void *)native_nop,
+
 	.alloc_pt = (void *)native_nop,
 	.alloc_pd = (void *)native_nop,
 	.alloc_pd_clone = (void *)native_nop,
diff -puN arch/i386/kernel/vmi.c~vmi-fix-highpte arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-fix-highpte
+++ a/arch/i386/kernel/vmi.c
@@ -370,6 +370,24 @@ static void vmi_check_page_type(u32 pfn,
 #define vmi_check_page_type(p,t) do { } while (0)
 #endif
 
+static void vmi_map_pt_hook(int type, pte_t *va, u32 pfn)
+{
+	/*
+	 * Internally, the VMI ROM must map virtual addresses to physical
+	 * addresses for processing MMU updates.  By the time MMU updates
+	 * are issued, this information is typically already lost.
+	 * Fortunately, the VMI provides a cache of mapping slots for active
+	 * page tables.
+	 *
+	 * We use slot zero for the linear mapping of physical memory, and
+	 * in HIGHPTE kernels, slot 1 and 2 for KM_PTE0 and KM_PTE1.
+	 *
+	 *  args:                 SLOT                 VA    COUNT PFN
+	 */
+	BUG_ON(type != KM_PTE0 && type != KM_PTE1);
+	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, (u32)va, 1, pfn);
+}
+
 static void vmi_allocate_pt(u32 pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
@@ -813,6 +831,7 @@ static inline int __init activate_vmi(vo
 	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
 	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
 
+	paravirt_ops.map_pt_hook = vmi_map_pt_hook;
 	paravirt_ops.alloc_pt = vmi_allocate_pt;
 	paravirt_ops.alloc_pd = vmi_allocate_pd;
 	paravirt_ops.alloc_pd_clone = vmi_allocate_pd_clone;
diff -puN include/asm-i386/paravirt.h~vmi-fix-highpte include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~vmi-fix-highpte
+++ a/include/asm-i386/paravirt.h
@@ -131,6 +131,8 @@ struct paravirt_ops
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(u32 addr);
 
+	void (fastcall *map_pt_hook)(int type, pte_t *va, u32 pfn);
+
 	void (*alloc_pt)(u32 pfn);
 	void (*alloc_pd)(u32 pfn);
 	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
@@ -354,6 +356,8 @@ static inline void startup_ipi_hook(int 
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
 #define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
 
+#define paravirt_map_pt_hook(type, va, pfn) paravirt_ops.map_pt_hook(type, va, pfn)
+
 #define paravirt_alloc_pt(pfn) paravirt_ops.alloc_pt(pfn)
 #define paravirt_release_pt(pfn) paravirt_ops.release_pt(pfn)
 
diff -puN include/asm-i386/pgtable.h~vmi-fix-highpte include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~vmi-fix-highpte
+++ a/include/asm-i386/pgtable.h
@@ -263,6 +263,7 @@ static inline pte_t pte_mkhuge(pte_t pte
  */
 #define pte_update(mm, addr, ptep)		do { } while (0)
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
+#define paravirt_map_pt_hook(slot, va, pfn)	do { } while (0)
 #endif
 
 /*
@@ -469,10 +470,24 @@ extern pte_t *lookup_address(unsigned lo
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
-#define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+#define pte_offset_map(dir, address)				\
+({								\
+	pte_t *__ptep;						\
+	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
+	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE0);\
+	paravirt_map_pt_hook(KM_PTE0,__ptep, pfn);		\
+	__ptep = __ptep + pte_index(address);			\
+	__ptep;							\
+})
+#define pte_offset_map_nested(dir, address)			\
+({								\
+	pte_t *__ptep;						\
+	unsigned pfn = pmd_val(*(dir)) >> PAGE_SHIFT;	   	\
+	__ptep = (pte_t *)kmap_atomic(pfn_to_page(pfn),KM_PTE1);\
+	paravirt_map_pt_hook(KM_PTE1,__ptep, pfn);		\
+	__ptep = __ptep + pte_index(address);			\
+	__ptep;							\
+})
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
make-struct-vmi_ops-static.patch
