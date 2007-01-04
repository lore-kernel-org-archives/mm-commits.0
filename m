From: akpm@osdl.org
Subject: + kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:12:28 -0800
Message-ID: <200701041912.l04JCSZj028397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:45050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189AbXADTMh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Detect oom conditions and propagate error to userspace
has been added to the -mm tree.  Its filename is
     kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Detect oom conditions and propagate error to userspace
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c         |   32 +++++++++++++++++++++-----------
 drivers/kvm/paging_tmpl.h |    8 ++++++--
 drivers/kvm/svm.c         |   14 +++++++++++---
 drivers/kvm/vmx.c         |   15 ++++++++++++---
 4 files changed, 50 insertions(+), 19 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace
+++ a/drivers/kvm/mmu.c
@@ -166,19 +166,20 @@ static int is_rmap_pte(u64 pte)
 		== (PT_WRITABLE_MASK | PT_PRESENT_MASK);
 }
 
-static void mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				   size_t objsize, int min)
+static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+				  size_t objsize, int min)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
-		return;
+		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
 		obj = kzalloc(objsize, GFP_NOWAIT);
 		if (!obj)
-			BUG();
+			return -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
 	}
+	return 0;
 }
 
 static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
@@ -187,12 +188,18 @@ static void mmu_free_memory_cache(struct
 		kfree(mc->objects[--mc->nobjs]);
 }
 
-static void mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_topup_memory_cache(&vcpu->mmu_pte_chain_cache,
-			       sizeof(struct kvm_pte_chain), 4);
-	mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
-			       sizeof(struct kvm_rmap_desc), 1);
+	int r;
+
+	r = mmu_topup_memory_cache(&vcpu->mmu_pte_chain_cache,
+				   sizeof(struct kvm_pte_chain), 4);
+	if (r)
+		goto out;
+	r = mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
+				   sizeof(struct kvm_rmap_desc), 1);
+out:
+	return r;
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
@@ -824,8 +831,11 @@ static int nonpaging_page_fault(struct k
 {
 	gpa_t addr = gva;
 	hpa_t paddr;
+	int r;
 
-	mmu_topup_memory_caches(vcpu);
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
 
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->mmu.root_hpa));
@@ -1052,7 +1062,7 @@ int kvm_mmu_reset_context(struct kvm_vcp
 	r = init_kvm_mmu(vcpu);
 	if (r < 0)
 		goto out;
-	mmu_topup_memory_caches(vcpu);
+	r = mmu_topup_memory_caches(vcpu);
 out:
 	return r;
 }
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace
+++ a/drivers/kvm/paging_tmpl.h
@@ -339,7 +339,8 @@ static int FNAME(fix_write_pf)(struct kv
  *   - normal guest page fault due to the guest pte marked not present, not
  *     writable, or not executable
  *
- *  Returns: 1 if we need to emulate the instruction, 0 otherwise
+ *  Returns: 1 if we need to emulate the instruction, 0 otherwise, or
+ *           a negative value on error.
  */
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 			       u32 error_code)
@@ -351,10 +352,13 @@ static int FNAME(page_fault)(struct kvm_
 	u64 *shadow_pte;
 	int fixed;
 	int write_pt = 0;
+	int r;
 
 	pgprintk("%s: addr %lx err %x\n", __FUNCTION__, addr, error_code);
 
-	mmu_topup_memory_caches(vcpu);
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
 
 	/*
 	 * Look up the shadow pte for the faulting address.
diff -puN drivers/kvm/svm.c~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace
+++ a/drivers/kvm/svm.c
@@ -852,6 +852,7 @@ static int pf_interception(struct kvm_vc
 	u64 fault_address;
 	u32 error_code;
 	enum emulation_result er;
+	int r;
 
 	if (is_external_interrupt(exit_int_info))
 		push_irq(vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
@@ -860,7 +861,12 @@ static int pf_interception(struct kvm_vc
 
 	fault_address  = vcpu->svm->vmcb->control.exit_info_2;
 	error_code = vcpu->svm->vmcb->control.exit_info_1;
-	if (!kvm_mmu_page_fault(vcpu, fault_address, error_code)) {
+	r = kvm_mmu_page_fault(vcpu, fault_address, error_code);
+	if (r < 0) {
+		spin_unlock(&vcpu->kvm->lock);
+		return r;
+	}
+	if (!r) {
 		spin_unlock(&vcpu->kvm->lock);
 		return 1;
 	}
@@ -1398,6 +1404,7 @@ static int svm_vcpu_run(struct kvm_vcpu 
 	u16 fs_selector;
 	u16 gs_selector;
 	u16 ldt_selector;
+	int r;
 
 again:
 	do_interrupt_requests(vcpu, kvm_run);
@@ -1565,7 +1572,8 @@ again:
 		return 0;
 	}
 
-	if (handle_exit(vcpu, kvm_run)) {
+	r = handle_exit(vcpu, kvm_run);
+	if (r > 0) {
 		if (signal_pending(current)) {
 			++kvm_stat.signal_exits;
 			post_kvm_run_save(vcpu, kvm_run);
@@ -1581,7 +1589,7 @@ again:
 		goto again;
 	}
 	post_kvm_run_save(vcpu, kvm_run);
-	return 0;
+	return r;
 }
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu)
diff -puN drivers/kvm/vmx.c~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace
+++ a/drivers/kvm/vmx.c
@@ -1289,6 +1289,7 @@ static int handle_exception(struct kvm_v
 	unsigned long cr2, rip;
 	u32 vect_info;
 	enum emulation_result er;
+	int r;
 
 	vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
@@ -1317,7 +1318,12 @@ static int handle_exception(struct kvm_v
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 
 		spin_lock(&vcpu->kvm->lock);
-		if (!kvm_mmu_page_fault(vcpu, cr2, error_code)) {
+		r = kvm_mmu_page_fault(vcpu, cr2, error_code);
+		if (r < 0) {
+			spin_unlock(&vcpu->kvm->lock);
+			return r;
+		}
+		if (!r) {
 			spin_unlock(&vcpu->kvm->lock);
 			return 1;
 		}
@@ -1680,6 +1686,7 @@ static int vmx_vcpu_run(struct kvm_vcpu 
 	u8 fail;
 	u16 fs_sel, gs_sel, ldt_sel;
 	int fs_gs_ldt_reload_needed;
+	int r;
 
 again:
 	/*
@@ -1853,6 +1860,7 @@ again:
 	if (fail) {
 		kvm_run->exit_type = KVM_EXIT_TYPE_FAIL_ENTRY;
 		kvm_run->exit_reason = vmcs_read32(VM_INSTRUCTION_ERROR);
+		r = 0;
 	} else {
 		if (fs_gs_ldt_reload_needed) {
 			load_ldt(ldt_sel);
@@ -1872,7 +1880,8 @@ again:
 		}
 		vcpu->launched = 1;
 		kvm_run->exit_type = KVM_EXIT_TYPE_VM_EXIT;
-		if (kvm_handle_exit(kvm_run, vcpu)) {
+		r = kvm_handle_exit(kvm_run, vcpu);
+		if (r > 0) {
 			/* Give scheduler a change to reschedule. */
 			if (signal_pending(current)) {
 				++kvm_stat.signal_exits;
@@ -1892,7 +1901,7 @@ again:
 	}
 
 	post_kvm_run_save(vcpu, kvm_run);
-	return 0;
+	return r;
 }
 
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch
kvm-use-raw_smp_processor_id-instead-of-smp_processor_id-where-applicable.patch
kvm-recover-after-an-arch-module-load-failure.patch
kvm-improve-interrupt-response.patch
kvm-prevent-stale-bits-in-cr0-and-cr4.patch
kvm-mmu-implement-simple-reverse-mapping.patch
kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns.patch
kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does.patch
kvm-mmu-fold-fetch_guest-into-init_walker.patch
kvm-mu-special-treatment-for-shadow-pae-root-pages.patch
kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch
kvm-mmu-make-the-shadow-page-tables-also-special-case-pae.patch
kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer.patch
kvm-mmu-shadow-page-table-caching.patch
kvm-mmu-write-protect-guest-pages-when-a-shadow-is-created-for-them.patch
kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte.patch
kvm-mmu-support-emulated-writes-into-ram.patch
kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch
kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page.patch
kvm-mmu-implement-child-shadow-unlinking.patch
kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page.patch
kvm-mmu-oom-handling.patch
kvm-mmu-remove-invlpg-interception.patch
kvm-mmu-remove-release_pt_page_64.patch
kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables.patch
kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page.patch
kvm-mmu-ensure-freed-shadow-pages-are-clean.patch
kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info.patch
kvm-mmu-page-table-write-flood-protection.patch
kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch
kvm-mmu-fix-cmpxchg8b-emulation.patch
kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table.patch
kvm-mmu-free-pages-on-kvm-destruction.patch
kvm-mmu-replace-atomic-allocations-by-preallocated-objects.patch
kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch
kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch
kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left.patch
kvm-mmu-add-audit-code-to-check-mappings-etc-are-correct.patch
