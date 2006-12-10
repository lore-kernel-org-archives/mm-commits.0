From: akpm@osdl.org
Subject: - kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:07 -0800
Message-ID: <200612100755.kBA7t7AS017845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760562AbWLJHzJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: add an arch accessor for cs d/b and l bits
has been removed from the -mm tree.  Its filename was
     kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: add an arch accessor for cs d/b and l bits
From: Avi Kivity <avi@qumranet.com>

These are used for detecting the current processor mode.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   15 ++++++++-------
 drivers/kvm/vmx.c      |    9 +++++++++
 3 files changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits
+++ a/drivers/kvm/kvm.h
@@ -269,6 +269,7 @@ struct kvm_arch_ops {
 			    struct kvm_segment *var, int seg);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
+	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
diff -puN drivers/kvm/kvm_main.c~kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits
+++ a/drivers/kvm/kvm_main.c
@@ -502,15 +502,16 @@ void set_cr0(struct kvm_vcpu *vcpu, unsi
 	if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK)) {
 #ifdef __x86_64__
 		if ((vcpu->shadow_efer & EFER_LME)) {
-			u32 guest_cs_ar;
+			int cs_db, cs_l;
+
 			if (!is_pae(vcpu)) {
 				printk(KERN_DEBUG "set_cr0: #GP, start paging "
 				       "in long mode while PAE is disabled\n");
 				inject_gp(vcpu);
 				return;
 			}
-			guest_cs_ar = vmcs_read32(GUEST_CS_AR_BYTES);
-			if (guest_cs_ar & SEGMENT_AR_L_MASK) {
+			kvm_arch_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+			if (cs_l) {
 				printk(KERN_DEBUG "set_cr0: #GP, start paging "
 				       "in long mode while CS.L == 1\n");
 				inject_gp(vcpu);
@@ -1095,18 +1096,18 @@ int emulate_instruction(struct kvm_vcpu 
 {
 	struct x86_emulate_ctxt emulate_ctxt;
 	int r;
-	u32 cs_ar;
+	int cs_db, cs_l;
 
 	kvm_arch_ops->cache_regs(vcpu);
 
-	cs_ar = vmcs_read32(GUEST_CS_AR_BYTES);
+	kvm_arch_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 
 	emulate_ctxt.vcpu = vcpu;
 	emulate_ctxt.eflags = kvm_arch_ops->get_rflags(vcpu);
 	emulate_ctxt.cr2 = cr2;
 	emulate_ctxt.mode = (emulate_ctxt.eflags & X86_EFLAGS_VM)
-		? X86EMUL_MODE_REAL : (cs_ar & AR_L_MASK)
-		? X86EMUL_MODE_PROT64 :	(cs_ar & AR_DB_MASK)
+		? X86EMUL_MODE_REAL : cs_l
+		? X86EMUL_MODE_PROT64 :	cs_db
 		? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
 
 	if (emulate_ctxt.mode == X86EMUL_MODE_PROT64) {
diff -puN drivers/kvm/vmx.c~kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits
+++ a/drivers/kvm/vmx.c
@@ -700,6 +700,14 @@ static void vmx_set_segment(struct kvm_v
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
+static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	u32 ar = vmcs_read32(GUEST_CS_AR_BYTES);
+
+	*db = (ar >> 14) & 1;
+	*l = (ar >> 13) & 1;
+}
+
 static void vmx_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
 	dt->limit = vmcs_read32(GUEST_IDTR_LIMIT);
@@ -1732,6 +1740,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
+	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch
kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch
kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch
kvm-make-vcpu-creation-and-destruction-arch-operations.patch
kvm-move-vmcs-static-variables-to-vmxc.patch
kvm-make-is_long_mode-an-arch-operation.patch
kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch
kvm-remove-guest_cpl.patch
kvm-move-vmcs-accessors-to-vmxc.patch
kvm-move-vmx-helper-inlines-to-vmxc.patch
kvm-remove-vmx-includes-from-arch-independent-code.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

