From: akpm@linux-foundation.org
Subject: - kvm-mmu-fix-rare-oops-on-guest-context-switch.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:46 -0700
Message-ID: <200709160926.l8G9QkmB009205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbXIPJiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Fix rare oops on guest context switch
has been removed from the -mm tree.  Its filename was
     kvm-mmu-fix-rare-oops-on-guest-context-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Fix rare oops on guest context switch
From: Avi Kivity <avi@qumranet.com>

A guest context switch to an uncached cr3 can require allocation of
shadow pages, but we only recycle shadow pages in kvm_mmu_page_fault().

Move shadow page recycling to mmu_topup_memory_caches(), which is called
from both the page fault handler and from guest cr3 reload.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h |   10 +++++++---
 drivers/kvm/mmu.c |    5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-mmu-fix-rare-oops-on-guest-context-switch drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-fix-rare-oops-on-guest-context-switch
+++ a/drivers/kvm/kvm.h
@@ -619,7 +619,7 @@ unsigned long segment_base(u16 selector)
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *old, const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
-void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
+void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 
@@ -628,11 +628,15 @@ int kvm_hypercall(struct kvm_vcpu *vcpu,
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
 {
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-		kvm_mmu_free_some_pages(vcpu);
 	return vcpu->mmu.page_fault(vcpu, gva, error_code);
 }
 
+static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
+		__kvm_mmu_free_some_pages(vcpu);
+}
+
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
 	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
diff -puN drivers/kvm/mmu.c~kvm-mmu-fix-rare-oops-on-guest-context-switch drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-fix-rare-oops-on-guest-context-switch
+++ a/drivers/kvm/mmu.c
@@ -273,12 +273,14 @@ static int mmu_topup_memory_caches(struc
 	int r;
 
 	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
+	kvm_mmu_free_some_pages(vcpu);
 	if (r < 0) {
 		spin_unlock(&vcpu->kvm->lock);
 		kvm_arch_ops->vcpu_put(vcpu);
 		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
 		kvm_arch_ops->vcpu_load(vcpu);
 		spin_lock(&vcpu->kvm->lock);
+		kvm_mmu_free_some_pages(vcpu);
 	}
 	return r;
 }
@@ -1208,7 +1210,7 @@ int kvm_mmu_unprotect_page_virt(struct k
 	return kvm_mmu_unprotect_page(vcpu, gpa >> PAGE_SHIFT);
 }
 
-void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
+void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
 	while (vcpu->kvm->n_free_mmu_pages < KVM_REFILL_PAGES) {
 		struct kvm_mmu_page *page;
@@ -1218,7 +1220,6 @@ void kvm_mmu_free_some_pages(struct kvm_
 		kvm_mmu_zap_page(vcpu->kvm, page);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_free_some_pages);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
git-kvm.patch
time-simplify-smp_call_function_single-call-sequence.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
