From: akpm@osdl.org
Subject: + kvm-mmu-support-emulated-writes-into-ram.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:52 -0800
Message-ID: <200701041911.l04JBqQx028318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965087AbXADTME (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Support emulated writes into RAM
has been added to the -mm tree.  Its filename is
     kvm-mmu-support-emulated-writes-into-ram.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Support emulated writes into RAM
From: Avi Kivity <avi@qumranet.com>

As the mmu write protects guest page table, we emulate those writes.  Since
they are not mmio, there is no need to go to userspace to perform them.

So, perform the writes in the kernel if possible, and notify the mmu about
them so it can take the approriate action.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   24 ++++++++++++++++++++++++
 drivers/kvm/mmu.c      |    9 +++++++++
 3 files changed, 36 insertions(+)

diff -puN drivers/kvm/kvm.h~kvm-mmu-support-emulated-writes-into-ram drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-support-emulated-writes-into-ram
+++ a/drivers/kvm/kvm.h
@@ -448,6 +448,9 @@ int kvm_write_guest(struct kvm_vcpu *vcp
 
 unsigned long segment_base(u16 selector);
 
+void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
+void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
+
 static inline struct page *_gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
diff -puN drivers/kvm/kvm_main.c~kvm-mmu-support-emulated-writes-into-ram drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-support-emulated-writes-into-ram
+++ a/drivers/kvm/kvm_main.c
@@ -877,6 +877,27 @@ static int emulator_read_emulated(unsign
 	}
 }
 
+static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       unsigned long val, int bytes)
+{
+	struct kvm_memory_slot *m;
+	struct page *page;
+	void *virt;
+
+	if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
+		return 0;
+	m = gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT);
+	if (!m)
+		return 0;
+	page = gfn_to_page(m, gpa >> PAGE_SHIFT);
+	kvm_mmu_pre_write(vcpu, gpa, bytes);
+	virt = kmap_atomic(page, KM_USER0);
+	memcpy(virt + offset_in_page(gpa), &val, bytes);
+	kunmap_atomic(virt, KM_USER0);
+	kvm_mmu_post_write(vcpu, gpa, bytes);
+	return 1;
+}
+
 static int emulator_write_emulated(unsigned long addr,
 				   unsigned long val,
 				   unsigned int bytes,
@@ -888,6 +909,9 @@ static int emulator_write_emulated(unsig
 	if (gpa == UNMAPPED_GVA)
 		return X86EMUL_PROPAGATE_FAULT;
 
+	if (emulator_write_phys(vcpu, gpa, val, bytes))
+		return X86EMUL_CONTINUE;
+
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
 	vcpu->mmio_size = bytes;
diff -puN drivers/kvm/mmu.c~kvm-mmu-support-emulated-writes-into-ram drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-support-emulated-writes-into-ram
+++ a/drivers/kvm/mmu.c
@@ -956,6 +956,15 @@ int kvm_mmu_reset_context(struct kvm_vcp
 	return init_kvm_mmu(vcpu);
 }
 
+void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
+{
+	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+}
+
+void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
+{
+}
+
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	while (!list_empty(&vcpu->free_pages)) {
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
