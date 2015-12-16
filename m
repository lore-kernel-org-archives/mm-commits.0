From: akpm@linux-foundation.org
Subject: + kvm-rename-pfn_t-to-kvm_pfn_t.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:47 -0800
Message-ID: <5670ad6f.lRBJUwSMYgIrG1dw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbbLPAQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, christoffer.dall@linaro.org, pbonzini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: rename pfn_t to kvm_pfn_t
has been added to the -mm tree.  Its filename is
     kvm-rename-pfn_t-to-kvm_pfn_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kvm-rename-pfn_t-to-kvm_pfn_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kvm-rename-pfn_t-to-kvm_pfn_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: kvm: rename pfn_t to kvm_pfn_t

The core has developed a need for a "pfn_t" type [1].  Move the existing
pfn_t in KVM to kvm_pfn_t [2].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-September/002199.html
[2]: https://lists.01.org/pipermail/linux-nvdimm/2015-September/002218.html

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/kvm_mmu.h        |    5 +-
 arch/arm/kvm/mmu.c                    |   10 ++---
 arch/arm64/include/asm/kvm_mmu.h      |    3 +
 arch/mips/include/asm/kvm_host.h      |    6 +--
 arch/mips/kvm/emulate.c               |    2 -
 arch/mips/kvm/tlb.c                   |   14 +++----
 arch/powerpc/include/asm/kvm_book3s.h |    4 +-
 arch/powerpc/include/asm/kvm_ppc.h    |    2 -
 arch/powerpc/kvm/book3s.c             |    6 +--
 arch/powerpc/kvm/book3s_32_mmu_host.c |    2 -
 arch/powerpc/kvm/book3s_64_mmu_host.c |    2 -
 arch/powerpc/kvm/e500.h               |    2 -
 arch/powerpc/kvm/e500_mmu_host.c      |    8 ++--
 arch/powerpc/kvm/trace_pr.h           |    2 -
 arch/x86/kvm/iommu.c                  |   11 +++--
 arch/x86/kvm/mmu.c                    |   37 +++++++++---------
 arch/x86/kvm/mmu_audit.c              |    2 -
 arch/x86/kvm/paging_tmpl.h            |    6 +--
 arch/x86/kvm/vmx.c                    |    2 -
 arch/x86/kvm/x86.c                    |    2 -
 include/linux/kvm_host.h              |   39 ++++++++++---------
 include/linux/kvm_types.h             |    2 -
 virt/kvm/kvm_main.c                   |   47 ++++++++++++------------
 23 files changed, 111 insertions(+), 105 deletions(-)

diff -puN arch/arm/include/asm/kvm_mmu.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/arm/include/asm/kvm_mmu.h
--- a/arch/arm/include/asm/kvm_mmu.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/arm/include/asm/kvm_mmu.h
@@ -182,7 +182,8 @@ static inline bool vcpu_has_cache_enable
 	return (vcpu->arch.cp15[c1_SCTLR] & 0b101) == 0b101;
 }
 
-static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
+static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
+					       kvm_pfn_t pfn,
 					       unsigned long size,
 					       bool ipa_uncached)
 {
@@ -246,7 +247,7 @@ static inline void __kvm_flush_dcache_pt
 static inline void __kvm_flush_dcache_pmd(pmd_t pmd)
 {
 	unsigned long size = PMD_SIZE;
-	pfn_t pfn = pmd_pfn(pmd);
+	kvm_pfn_t pfn = pmd_pfn(pmd);
 
 	while (size) {
 		void *va = kmap_atomic_pfn(pfn);
diff -puN arch/arm/kvm/mmu.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/arm/kvm/mmu.c
--- a/arch/arm/kvm/mmu.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/arm/kvm/mmu.c
@@ -992,9 +992,9 @@ out:
 	return ret;
 }
 
-static bool transparent_hugepage_adjust(pfn_t *pfnp, phys_addr_t *ipap)
+static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 {
-	pfn_t pfn = *pfnp;
+	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
 
 	if (PageTransCompound(pfn_to_page(pfn))) {
@@ -1201,7 +1201,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_ma
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
+static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
 				      unsigned long size, bool uncached)
 {
 	__coherent_cache_guest_page(vcpu, pfn, size, uncached);
@@ -1218,7 +1218,7 @@ static int user_mem_abort(struct kvm_vcp
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	pgprot_t mem_type = PAGE_S2;
 	bool fault_ipa_uncached;
 	bool logging_active = memslot_is_logging(memslot);
@@ -1346,7 +1346,7 @@ static void handle_access_fault(struct k
 {
 	pmd_t *pmd;
 	pte_t *pte;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	bool pfn_valid = false;
 
 	trace_kvm_access_fault(fault_ipa);
diff -puN arch/arm64/include/asm/kvm_mmu.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/arm64/include/asm/kvm_mmu.h
--- a/arch/arm64/include/asm/kvm_mmu.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/arm64/include/asm/kvm_mmu.h
@@ -230,7 +230,8 @@ static inline bool vcpu_has_cache_enable
 	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
+static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
+					       kvm_pfn_t pfn,
 					       unsigned long size,
 					       bool ipa_uncached)
 {
diff -puN arch/mips/include/asm/kvm_host.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/mips/include/asm/kvm_host.h
--- a/arch/mips/include/asm/kvm_host.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/mips/include/asm/kvm_host.h
@@ -101,9 +101,9 @@
 #define CAUSEF_DC			(_ULCAST_(1) << 27)
 
 extern atomic_t kvm_mips_instance;
-extern pfn_t(*kvm_mips_gfn_to_pfn) (struct kvm *kvm, gfn_t gfn);
-extern void (*kvm_mips_release_pfn_clean) (pfn_t pfn);
-extern bool(*kvm_mips_is_error_pfn) (pfn_t pfn);
+extern kvm_pfn_t (*kvm_mips_gfn_to_pfn)(struct kvm *kvm, gfn_t gfn);
+extern void (*kvm_mips_release_pfn_clean)(kvm_pfn_t pfn);
+extern bool (*kvm_mips_is_error_pfn)(kvm_pfn_t pfn);
 
 struct kvm_vm_stat {
 	u32 remote_tlb_flush;
diff -puN arch/mips/kvm/emulate.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/mips/kvm/emulate.c
--- a/arch/mips/kvm/emulate.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/mips/kvm/emulate.c
@@ -1525,7 +1525,7 @@ int kvm_mips_sync_icache(unsigned long v
 	struct kvm *kvm = vcpu->kvm;
 	unsigned long pa;
 	gfn_t gfn;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	gfn = va >> PAGE_SHIFT;
 
diff -puN arch/mips/kvm/tlb.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/mips/kvm/tlb.c
--- a/arch/mips/kvm/tlb.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/mips/kvm/tlb.c
@@ -38,13 +38,13 @@ atomic_t kvm_mips_instance;
 EXPORT_SYMBOL(kvm_mips_instance);
 
 /* These function pointers are initialized once the KVM module is loaded */
-pfn_t (*kvm_mips_gfn_to_pfn)(struct kvm *kvm, gfn_t gfn);
+kvm_pfn_t (*kvm_mips_gfn_to_pfn)(struct kvm *kvm, gfn_t gfn);
 EXPORT_SYMBOL(kvm_mips_gfn_to_pfn);
 
-void (*kvm_mips_release_pfn_clean)(pfn_t pfn);
+void (*kvm_mips_release_pfn_clean)(kvm_pfn_t pfn);
 EXPORT_SYMBOL(kvm_mips_release_pfn_clean);
 
-bool (*kvm_mips_is_error_pfn)(pfn_t pfn);
+bool (*kvm_mips_is_error_pfn)(kvm_pfn_t pfn);
 EXPORT_SYMBOL(kvm_mips_is_error_pfn);
 
 uint32_t kvm_mips_get_kernel_asid(struct kvm_vcpu *vcpu)
@@ -144,7 +144,7 @@ EXPORT_SYMBOL(kvm_mips_dump_guest_tlbs);
 static int kvm_mips_map_page(struct kvm *kvm, gfn_t gfn)
 {
 	int srcu_idx, err = 0;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	if (kvm->arch.guest_pmap[gfn] != KVM_INVALID_PAGE)
 		return 0;
@@ -262,7 +262,7 @@ int kvm_mips_handle_kseg0_tlb_fault(unsi
 				    struct kvm_vcpu *vcpu)
 {
 	gfn_t gfn;
-	pfn_t pfn0, pfn1;
+	kvm_pfn_t pfn0, pfn1;
 	unsigned long vaddr = 0;
 	unsigned long entryhi = 0, entrylo0 = 0, entrylo1 = 0;
 	int even;
@@ -313,7 +313,7 @@ EXPORT_SYMBOL(kvm_mips_handle_kseg0_tlb_
 int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
 	struct kvm_vcpu *vcpu)
 {
-	pfn_t pfn0, pfn1;
+	kvm_pfn_t pfn0, pfn1;
 	unsigned long flags, old_entryhi = 0, vaddr = 0;
 	unsigned long entrylo0 = 0, entrylo1 = 0;
 
@@ -360,7 +360,7 @@ int kvm_mips_handle_mapped_seg_tlb_fault
 {
 	unsigned long entryhi = 0, entrylo0 = 0, entrylo1 = 0;
 	struct kvm *kvm = vcpu->kvm;
-	pfn_t pfn0, pfn1;
+	kvm_pfn_t pfn0, pfn1;
 
 	if ((tlb->tlb_hi & VPN2_MASK) == 0) {
 		pfn0 = 0;
diff -puN arch/powerpc/include/asm/kvm_book3s.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/include/asm/kvm_book3s.h
--- a/arch/powerpc/include/asm/kvm_book3s.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/include/asm/kvm_book3s.h
@@ -154,8 +154,8 @@ extern void kvmppc_set_bat(struct kvm_vc
 			   bool upper, u32 val);
 extern void kvmppc_giveup_ext(struct kvm_vcpu *vcpu, ulong msr);
 extern int kvmppc_emulate_paired_single(struct kvm_run *run, struct kvm_vcpu *vcpu);
-extern pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa, bool writing,
-			bool *writable);
+extern kvm_pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa,
+			bool writing, bool *writable);
 extern void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 			unsigned long *rmap, long pte_index, int realmode);
 extern void kvmppc_update_rmap_change(unsigned long *rmap, unsigned long psize);
diff -puN arch/powerpc/include/asm/kvm_ppc.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/include/asm/kvm_ppc.h
--- a/arch/powerpc/include/asm/kvm_ppc.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/include/asm/kvm_ppc.h
@@ -515,7 +515,7 @@ void kvmppc_claim_lpid(long lpid);
 void kvmppc_free_lpid(long lpid);
 void kvmppc_init_lpid(unsigned long nr_lpids);
 
-static inline void kvmppc_mmu_flush_icache(pfn_t pfn)
+static inline void kvmppc_mmu_flush_icache(kvm_pfn_t pfn)
 {
 	struct page *page;
 	/*
diff -puN arch/powerpc/kvm/book3s.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/kvm/book3s.c
--- a/arch/powerpc/kvm/book3s.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/kvm/book3s.c
@@ -366,7 +366,7 @@ int kvmppc_core_prepare_to_enter(struct
 }
 EXPORT_SYMBOL_GPL(kvmppc_core_prepare_to_enter);
 
-pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa, bool writing,
+kvm_pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa, bool writing,
 			bool *writable)
 {
 	ulong mp_pa = vcpu->arch.magic_page_pa & KVM_PAM;
@@ -379,9 +379,9 @@ pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu
 	gpa &= ~0xFFFULL;
 	if (unlikely(mp_pa) && unlikely((gpa & KVM_PAM) == mp_pa)) {
 		ulong shared_page = ((ulong)vcpu->arch.shared) & PAGE_MASK;
-		pfn_t pfn;
+		kvm_pfn_t pfn;
 
-		pfn = (pfn_t)virt_to_phys((void*)shared_page) >> PAGE_SHIFT;
+		pfn = (kvm_pfn_t)virt_to_phys((void*)shared_page) >> PAGE_SHIFT;
 		get_page(pfn_to_page(pfn));
 		if (writable)
 			*writable = true;
diff -puN arch/powerpc/kvm/book3s_32_mmu_host.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/kvm/book3s_32_mmu_host.c
--- a/arch/powerpc/kvm/book3s_32_mmu_host.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/kvm/book3s_32_mmu_host.c
@@ -142,7 +142,7 @@ extern char etext[];
 int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 			bool iswrite)
 {
-	pfn_t hpaddr;
+	kvm_pfn_t hpaddr;
 	u64 vpn;
 	u64 vsid;
 	struct kvmppc_sid_map *map;
diff -puN arch/powerpc/kvm/book3s_64_mmu_host.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/kvm/book3s_64_mmu_host.c
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -83,7 +83,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu
 			bool iswrite)
 {
 	unsigned long vpn;
-	pfn_t hpaddr;
+	kvm_pfn_t hpaddr;
 	ulong hash, hpteg;
 	u64 vsid;
 	int ret;
diff -puN arch/powerpc/kvm/e500.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/kvm/e500.h
--- a/arch/powerpc/kvm/e500.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/kvm/e500.h
@@ -41,7 +41,7 @@ enum vcpu_ftr {
 #define E500_TLB_MAS2_ATTR	(0x7f)
 
 struct tlbe_ref {
-	pfn_t pfn;		/* valid only for TLB0, except briefly */
+	kvm_pfn_t pfn;		/* valid only for TLB0, except briefly */
 	unsigned int flags;	/* E500_TLB_* */
 };
 
diff -puN arch/powerpc/kvm/e500_mmu_host.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/kvm/e500_mmu_host.c
--- a/arch/powerpc/kvm/e500_mmu_host.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/kvm/e500_mmu_host.c
@@ -163,9 +163,9 @@ void kvmppc_map_magic(struct kvm_vcpu *v
 	struct kvm_book3e_206_tlb_entry magic;
 	ulong shared_page = ((ulong)vcpu->arch.shared) & PAGE_MASK;
 	unsigned int stid;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
-	pfn = (pfn_t)virt_to_phys((void *)shared_page) >> PAGE_SHIFT;
+	pfn = (kvm_pfn_t)virt_to_phys((void *)shared_page) >> PAGE_SHIFT;
 	get_page(pfn_to_page(pfn));
 
 	preempt_disable();
@@ -246,7 +246,7 @@ static inline int tlbe_is_writable(struc
 
 static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 					 struct kvm_book3e_206_tlb_entry *gtlbe,
-					 pfn_t pfn, unsigned int wimg)
+					 kvm_pfn_t pfn, unsigned int wimg)
 {
 	ref->pfn = pfn;
 	ref->flags = E500_TLB_VALID;
@@ -309,7 +309,7 @@ static void kvmppc_e500_setup_stlbe(
 	int tsize, struct tlbe_ref *ref, u64 gvaddr,
 	struct kvm_book3e_206_tlb_entry *stlbe)
 {
-	pfn_t pfn = ref->pfn;
+	kvm_pfn_t pfn = ref->pfn;
 	u32 pr = vcpu->arch.shared->msr & MSR_PR;
 
 	BUG_ON(!(ref->flags & E500_TLB_VALID));
diff -puN arch/powerpc/kvm/trace_pr.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/powerpc/kvm/trace_pr.h
--- a/arch/powerpc/kvm/trace_pr.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/powerpc/kvm/trace_pr.h
@@ -30,7 +30,7 @@ TRACE_EVENT(kvm_book3s_reenter,
 #ifdef CONFIG_PPC_BOOK3S_64
 
 TRACE_EVENT(kvm_book3s_64_mmu_map,
-	TP_PROTO(int rflags, ulong hpteg, ulong va, pfn_t hpaddr,
+	TP_PROTO(int rflags, ulong hpteg, ulong va, kvm_pfn_t hpaddr,
 		 struct kvmppc_pte *orig_pte),
 	TP_ARGS(rflags, hpteg, va, hpaddr, orig_pte),
 
diff -puN arch/x86/kvm/iommu.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/x86/kvm/iommu.c
--- a/arch/x86/kvm/iommu.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/x86/kvm/iommu.c
@@ -43,11 +43,11 @@ static int kvm_iommu_unmap_memslots(stru
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
-static pfn_t kvm_pin_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+static kvm_pfn_t kvm_pin_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 			   unsigned long npages)
 {
 	gfn_t end_gfn;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	pfn     = gfn_to_pfn_memslot(slot, gfn);
 	end_gfn = gfn + npages;
@@ -62,7 +62,8 @@ static pfn_t kvm_pin_pages(struct kvm_me
 	return pfn;
 }
 
-static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npages)
+static void kvm_unpin_pages(struct kvm *kvm, kvm_pfn_t pfn,
+		unsigned long npages)
 {
 	unsigned long i;
 
@@ -73,7 +74,7 @@ static void kvm_unpin_pages(struct kvm *
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	gfn_t gfn, end_gfn;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	int r = 0;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int flags;
@@ -275,7 +276,7 @@ static void kvm_iommu_put_pages(struct k
 {
 	struct iommu_domain *domain;
 	gfn_t end_gfn, gfn;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	u64 phys;
 
 	domain  = kvm->arch.iommu_domain;
diff -puN arch/x86/kvm/mmu.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/x86/kvm/mmu.c
@@ -259,7 +259,7 @@ static unsigned get_mmio_spte_access(u64
 }
 
 static bool set_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
-			  pfn_t pfn, unsigned access)
+			  kvm_pfn_t pfn, unsigned access)
 {
 	if (unlikely(is_noslot_pfn(pfn))) {
 		mark_mmio_spte(vcpu, sptep, gfn, access);
@@ -325,7 +325,7 @@ static int is_last_spte(u64 pte, int lev
 	return 0;
 }
 
-static pfn_t spte_to_pfn(u64 pte)
+static kvm_pfn_t spte_to_pfn(u64 pte)
 {
 	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
@@ -587,7 +587,7 @@ static bool mmu_spte_update(u64 *sptep,
  */
 static int mmu_spte_clear_track_bits(u64 *sptep)
 {
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
@@ -1389,7 +1389,7 @@ static int kvm_set_pte_rmapp(struct kvm
 	int need_flush = 0;
 	u64 new_spte;
 	pte_t *ptep = (pte_t *)data;
-	pfn_t new_pfn;
+	kvm_pfn_t new_pfn;
 
 	WARN_ON(pte_huge(*ptep));
 	new_pfn = pte_pfn(*ptep);
@@ -2476,7 +2476,7 @@ static int mmu_need_write_protect(struct
 	return 0;
 }
 
-static bool kvm_is_mmio_pfn(pfn_t pfn)
+static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn));
@@ -2486,7 +2486,7 @@ static bool kvm_is_mmio_pfn(pfn_t pfn)
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int level,
-		    gfn_t gfn, pfn_t pfn, bool speculative,
+		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
 		    bool can_unsync, bool host_writable)
 {
 	u64 spte;
@@ -2566,7 +2566,7 @@ done:
 
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pte_access, int write_fault, int *emulate,
-			 int level, gfn_t gfn, pfn_t pfn, bool speculative,
+			 int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
 	int was_rmapped = 0;
@@ -2626,7 +2626,7 @@ static void mmu_set_spte(struct kvm_vcpu
 	kvm_release_pfn_clean(pfn);
 }
 
-static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
+static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
@@ -2709,7 +2709,7 @@ static void direct_pte_prefetch(struct k
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int map_writable, int level, gfn_t gfn, pfn_t pfn,
+			int map_writable, int level, gfn_t gfn, kvm_pfn_t pfn,
 			bool prefault)
 {
 	struct kvm_shadow_walk_iterator iterator;
@@ -2759,7 +2759,7 @@ static void kvm_send_hwpoison_signal(uns
 	send_sig_info(SIGBUS, &info, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
+static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
@@ -2779,9 +2779,10 @@ static int kvm_handle_bad_page(struct kv
 }
 
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
-					gfn_t *gfnp, pfn_t *pfnp, int *levelp)
+					gfn_t *gfnp, kvm_pfn_t *pfnp,
+					int *levelp)
 {
-	pfn_t pfn = *pfnp;
+	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *gfnp;
 	int level = *levelp;
 
@@ -2820,7 +2821,7 @@ static void transparent_hugepage_adjust(
 }
 
 static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-				pfn_t pfn, unsigned access, int *ret_val)
+				kvm_pfn_t pfn, unsigned access, int *ret_val)
 {
 	bool ret = true;
 
@@ -2974,7 +2975,7 @@ exit:
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
+			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable);
 static void make_mmu_pages_available(struct kvm_vcpu *vcpu);
 
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
@@ -2983,7 +2984,7 @@ static int nonpaging_map(struct kvm_vcpu
 	int r;
 	int level;
 	bool force_pt_level = false;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	unsigned long mmu_seq;
 	bool map_writable, write = error_code & PFERR_WRITE_MASK;
 
@@ -3443,7 +3444,7 @@ static bool can_do_async_pf(struct kvm_v
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gva_t gva, pfn_t *pfn, bool write, bool *writable)
+			 gva_t gva, kvm_pfn_t *pfn, bool write, bool *writable)
 {
 	struct kvm_memory_slot *slot;
 	bool async;
@@ -3481,7 +3482,7 @@ check_hugepage_cache_consistency(struct
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 			  bool prefault)
 {
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	int r;
 	int level;
 	bool force_pt_level;
@@ -4632,7 +4633,7 @@ static bool kvm_mmu_zap_collapsible_spte
 	u64 *sptep;
 	struct rmap_iterator iter;
 	int need_tlb_flush = 0;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	struct kvm_mmu_page *sp;
 
 restart:
diff -puN arch/x86/kvm/mmu_audit.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/x86/kvm/mmu_audit.c
--- a/arch/x86/kvm/mmu_audit.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/x86/kvm/mmu_audit.c
@@ -97,7 +97,7 @@ static void audit_mappings(struct kvm_vc
 {
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	hpa_t hpa;
 
 	sp = page_header(__pa(sptep));
diff -puN arch/x86/kvm/paging_tmpl.h~kvm-rename-pfn_t-to-kvm_pfn_t arch/x86/kvm/paging_tmpl.h
--- a/arch/x86/kvm/paging_tmpl.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/x86/kvm/paging_tmpl.h
@@ -456,7 +456,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vc
 {
 	unsigned pte_access;
 	gfn_t gfn;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -551,7 +551,7 @@ static void FNAME(pte_prefetch)(struct k
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int write_fault, int hlevel,
-			 pfn_t pfn, bool map_writable, bool prefault)
+			 kvm_pfn_t pfn, bool map_writable, bool prefault)
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
@@ -696,7 +696,7 @@ static int FNAME(page_fault)(struct kvm_
 	int user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
 	int r;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 	int level = PT_PAGE_TABLE_LEVEL;
 	bool force_pt_level = false;
 	unsigned long mmu_seq;
diff -puN arch/x86/kvm/vmx.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/x86/kvm/vmx.c
@@ -4186,7 +4186,7 @@ out:
 static int init_rmode_identity_map(struct kvm *kvm)
 {
 	int i, idx, r = 0;
-	pfn_t identity_map_pfn;
+	kvm_pfn_t identity_map_pfn;
 	u32 tmp;
 
 	if (!enable_ept)
diff -puN arch/x86/kvm/x86.c~kvm-rename-pfn_t-to-kvm_pfn_t arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/arch/x86/kvm/x86.c
@@ -5101,7 +5101,7 @@ static bool reexecute_instruction(struct
 				  int emulation_type)
 {
 	gpa_t gpa = cr2;
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	if (emulation_type & EMULTYPE_NO_REEXECUTE)
 		return false;
diff -puN include/linux/kvm_host.h~kvm-rename-pfn_t-to-kvm_pfn_t include/linux/kvm_host.h
--- a/include/linux/kvm_host.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/include/linux/kvm_host.h
@@ -66,7 +66,7 @@
  * error pfns indicate that the gfn is in slot but faild to
  * translate it to pfn on host.
  */
-static inline bool is_error_pfn(pfn_t pfn)
+static inline bool is_error_pfn(kvm_pfn_t pfn)
 {
 	return !!(pfn & KVM_PFN_ERR_MASK);
 }
@@ -76,13 +76,13 @@ static inline bool is_error_pfn(pfn_t pf
  * translated to pfn - it is not in slot or failed to
  * translate it to pfn.
  */
-static inline bool is_error_noslot_pfn(pfn_t pfn)
+static inline bool is_error_noslot_pfn(kvm_pfn_t pfn)
 {
 	return !!(pfn & KVM_PFN_ERR_NOSLOT_MASK);
 }
 
 /* noslot pfn indicates that the gfn is not in slot. */
-static inline bool is_noslot_pfn(pfn_t pfn)
+static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 {
 	return pfn == KVM_PFN_NOSLOT;
 }
@@ -602,19 +602,20 @@ void kvm_release_page_clean(struct page
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
-pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
-pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
+kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
+kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
+kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
-pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
-pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
-pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn, bool atomic,
-			   bool *async, bool write_fault, bool *writable);
-
-void kvm_release_pfn_clean(pfn_t pfn);
-void kvm_set_pfn_dirty(pfn_t pfn);
-void kvm_set_pfn_accessed(pfn_t pfn);
-void kvm_get_pfn(pfn_t pfn);
+kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
+kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
+kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
+			       bool atomic, bool *async, bool write_fault,
+			       bool *writable);
+
+void kvm_release_pfn_clean(kvm_pfn_t pfn);
+void kvm_set_pfn_dirty(kvm_pfn_t pfn);
+void kvm_set_pfn_accessed(kvm_pfn_t pfn);
+void kvm_get_pfn(kvm_pfn_t pfn);
 
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
@@ -640,8 +641,8 @@ void mark_page_dirty(struct kvm *kvm, gf
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
-pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
-pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
+kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
@@ -824,7 +825,7 @@ void kvm_arch_sync_events(struct kvm *kv
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
-bool kvm_is_reserved_pfn(pfn_t pfn);
+bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
@@ -978,7 +979,7 @@ static inline gfn_t gpa_to_gfn(gpa_t gpa
 	return (gfn_t)(gpa >> PAGE_SHIFT);
 }
 
-static inline hpa_t pfn_to_hpa(pfn_t pfn)
+static inline hpa_t pfn_to_hpa(kvm_pfn_t pfn)
 {
 	return (hpa_t)pfn << PAGE_SHIFT;
 }
diff -puN include/linux/kvm_types.h~kvm-rename-pfn_t-to-kvm_pfn_t include/linux/kvm_types.h
--- a/include/linux/kvm_types.h~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/include/linux/kvm_types.h
@@ -53,7 +53,7 @@ typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef u64            hfn_t;
 
-typedef hfn_t pfn_t;
+typedef hfn_t kvm_pfn_t;
 
 struct gfn_to_hva_cache {
 	u64 generation;
diff -puN virt/kvm/kvm_main.c~kvm-rename-pfn_t-to-kvm_pfn_t virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-rename-pfn_t-to-kvm_pfn_t
+++ a/virt/kvm/kvm_main.c
@@ -111,7 +111,7 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void kvm_release_pfn_dirty(pfn_t pfn);
+static void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 
 __visible bool kvm_rebooting;
@@ -119,7 +119,7 @@ EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static bool largepages_enabled = true;
 
-bool kvm_is_reserved_pfn(pfn_t pfn)
+bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return PageReserved(pfn_to_page(pfn));
@@ -1299,7 +1299,7 @@ static inline int check_user_page_hwpois
  * true indicates success, otherwise false is returned.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
-			    bool write_fault, bool *writable, pfn_t *pfn)
+			    bool write_fault, bool *writable, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
 	int npages;
@@ -1332,7 +1332,7 @@ static bool hva_to_pfn_fast(unsigned lon
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool *writable, pfn_t *pfn)
+			   bool *writable, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
 	int npages = 0;
@@ -1396,11 +1396,11 @@ static bool vma_is_valid(struct vm_area_
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 			bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
-	pfn_t pfn = 0;
+	kvm_pfn_t pfn = 0;
 	int npages;
 
 	/* we can do it either atomically or asynchronously, not both */
@@ -1441,8 +1441,9 @@ exit:
 	return pfn;
 }
 
-pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn, bool atomic,
-			   bool *async, bool write_fault, bool *writable)
+kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
+			       bool atomic, bool *async, bool write_fault,
+			       bool *writable)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -1463,7 +1464,7 @@ pfn_t __gfn_to_pfn_memslot(struct kvm_me
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
-pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
+kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
@@ -1471,37 +1472,37 @@ pfn_t gfn_to_pfn_prot(struct kvm *kvm, g
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
-pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
+kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
-pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
+kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
+kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot_atomic(gfn_to_memslot(kvm, gfn), gfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
 
-pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
+kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
 
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
-pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
+kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
 }
@@ -1524,7 +1525,7 @@ int gfn_to_page_many_atomic(struct kvm_m
 }
 EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
 
-static struct page *kvm_pfn_to_page(pfn_t pfn)
+static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
 {
 	if (is_error_noslot_pfn(pfn))
 		return KVM_ERR_PTR_BAD_PAGE;
@@ -1539,7 +1540,7 @@ static struct page *kvm_pfn_to_page(pfn_
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	pfn = gfn_to_pfn(kvm, gfn);
 
@@ -1549,7 +1550,7 @@ EXPORT_SYMBOL_GPL(gfn_to_page);
 
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
-	pfn_t pfn;
+	kvm_pfn_t pfn;
 
 	pfn = kvm_vcpu_gfn_to_pfn(vcpu, gfn);
 
@@ -1565,7 +1566,7 @@ void kvm_release_page_clean(struct page
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
-void kvm_release_pfn_clean(pfn_t pfn)
+void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
 		put_page(pfn_to_page(pfn));
@@ -1580,13 +1581,13 @@ void kvm_release_page_dirty(struct page
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
 
-static void kvm_release_pfn_dirty(pfn_t pfn)
+static void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 {
 	kvm_set_pfn_dirty(pfn);
 	kvm_release_pfn_clean(pfn);
 }
 
-void kvm_set_pfn_dirty(pfn_t pfn)
+void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
 	if (!kvm_is_reserved_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
@@ -1597,14 +1598,14 @@ void kvm_set_pfn_dirty(pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
-void kvm_set_pfn_accessed(pfn_t pfn)
+void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
 	if (!kvm_is_reserved_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
-void kvm_get_pfn(pfn_t pfn)
+void kvm_get_pfn(kvm_pfn_t pfn)
 {
 	if (!kvm_is_reserved_pfn(pfn))
 		get_page(pfn_to_page(pfn));
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

