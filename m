From: akpm@osdl.org
Subject: - kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:00 -0800
Message-ID: <200701070800.l07800gG013113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477AbXAGIAI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Detect oom conditions and propagate error to userspace
has been removed from the -mm tree.  Its filename was
     kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
