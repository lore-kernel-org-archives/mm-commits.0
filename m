From: akpm@osdl.org
Subject: - kvm-mmu-support-emulated-writes-into-ram.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:24 -0800
Message-ID: <200701070759.l077xOdj013051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXAGH73 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Support emulated writes into RAM
has been removed from the -mm tree.  Its filename was
     kvm-mmu-support-emulated-writes-into-ram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
