From: akpm@linux-foundation.org
Subject: + paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch added to -mm tree
Date: Fri, 06 Apr 2007 16:26:49 -0700
Message-ID: <200704062326.l36NQnu4022544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38382 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbXDFX0x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 19:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, zach@vmware.com


The patch titled
     paravirt_ops: add kmap_atomic_pte for mapping highpte pages
has been added to the -mm tree.  Its filename is
     paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt_ops: add kmap_atomic_pte for mapping highpte pages
From: Jeremy Fitzhardinge <jeremy@goop.org>

Xen and VMI both have special requirements when mapping a highmem pte page
into the kernel address space.  These can be dealt with by adding a new
kmap_atomic_pte() function for mapping highptes, and hooking it into the
paravirt_ops infrastructure.

Xen specifically wants to map the pte page RO, so this patch exposes a helper
function, kmap_atomic_prot, which maps the page with the specified page
protections.

This also adds a kmap_flush_unused() function to clear out the cached kmap
mappings.  Xen needs this to clear out any potential stray RW mappings of
pages which will become part of a pagetable.

[ Zach - vmi.c will need some attention after this patch.  It wasn't
  immediately obvious to me what needs to be done. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    7 +++++++
 arch/i386/mm/highmem.c      |    9 +++++++--
 include/asm-i386/highmem.h  |   11 +++++++++++
 include/asm-i386/paravirt.h |   11 +++++++++++
 include/asm-i386/pgtable.h  |    4 ++--
 include/linux/highmem.h     |    6 ++++++
 mm/highmem.c                |    9 +++++++++
 7 files changed, 53 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/arch/i386/kernel/paravirt.c
@@ -20,6 +20,7 @@
 #include <linux/efi.h>
 #include <linux/bcd.h>
 #include <linux/start_kernel.h>
+#include <linux/highmem.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
@@ -316,6 +317,12 @@ struct paravirt_ops paravirt_ops = {
 
 	.ptep_get_and_clear = native_ptep_get_and_clear,
 
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = native_kmap_atomic_pte,
+#else
+	.kmap_atomic_pte = paravirt_nop,
+#endif
+
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
diff -puN arch/i386/mm/highmem.c~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages arch/i386/mm/highmem.c
--- a/arch/i386/mm/highmem.c~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/arch/i386/mm/highmem.c
@@ -26,7 +26,7 @@ void kunmap(struct page *page)
  * However when holding an atomic kmap is is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
-void *kmap_atomic(struct page *page, enum km_type type)
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -41,11 +41,16 @@ void *kmap_atomic(struct page *page, enu
 		return page_address(page);
 
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte-idx, mk_pte(page, prot));
 
 	return (void*) vaddr;
 }
 
+void *kmap_atomic(struct page *page, enum km_type type)
+{
+	return kmap_atomic_prot(page, type, kmap_prot);
+}
+
 void kunmap_atomic(void *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
diff -puN include/asm-i386/highmem.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages include/asm-i386/highmem.h
--- a/include/asm-i386/highmem.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/include/asm-i386/highmem.h
@@ -24,6 +24,7 @@
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
 
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
@@ -67,11 +68,21 @@ extern void FASTCALL(kunmap_high(struct 
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
 void kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 struct page *kmap_atomic_to_page(void *ptr);
 
+static inline void *native_kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	return kmap_atomic(page, type);
+}
+
+#ifndef CONFIG_PARAVIRT
+#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
+#endif
+
 #define flush_cache_kmaps()	do { } while (0)
 
 #endif /* __KERNEL__ */
diff -puN include/asm-i386/paravirt.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/include/asm-i386/paravirt.h
@@ -16,7 +16,9 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
+#include <asm/kmap_types.h>
 
+struct page;
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -187,6 +189,8 @@ struct paravirt_ops
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
+	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
  	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
@@ -884,6 +888,13 @@ static inline void paravirt_release_pd(u
 	PVOP_VCALL1(release_pd, pfn);
 }
 
+static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
+{
+	unsigned long ret;
+	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
+	return (void *)ret;
+}
+
 static inline void pte_update(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
diff -puN include/asm-i386/pgtable.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/include/asm-i386/pgtable.h
@@ -481,9 +481,9 @@ extern pte_t *lookup_address(unsigned lo
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
 #define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else
diff -puN include/linux/highmem.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages include/linux/highmem.h
--- a/include/linux/highmem.h~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/include/linux/highmem.h
@@ -27,6 +27,8 @@ static inline void flush_kernel_dcache_p
 unsigned int nr_free_highpages(void);
 extern unsigned long totalhigh_pages;
 
+void kmap_flush_unused(void);
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
@@ -44,9 +46,13 @@ static inline void *kmap(struct page *pa
 
 #define kmap_atomic(page, idx) \
 	({ pagefault_disable(); page_address(page); })
+#define kmap_atomic_prot(page, idx, prot)	kmap_atomic(page, idx)
+
 #define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
+
+#define kmap_flush_unused()	do {} while(0)
 #endif
 
 #endif /* CONFIG_HIGHMEM */
diff -puN mm/highmem.c~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages mm/highmem.c
--- a/mm/highmem.c~paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages
+++ a/mm/highmem.c
@@ -99,6 +99,15 @@ static void flush_all_zero_pkmaps(void)
 	flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 }
 
+/* Flush all unused kmap mappings in order to remove stray
+   mappings. */
+void kmap_flush_unused(void)
+{
+	spin_lock(&kmap_lock);
+	flush_all_zero_pkmaps();
+	spin_unlock(&kmap_lock);
+}
+
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
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
