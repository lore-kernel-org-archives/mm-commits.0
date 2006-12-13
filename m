From: akpm@osdl.org
Subject: + kvm-amd-svm-save-and-restore-the-floating-point-unit.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:13:02 -0800
Message-ID: <200612132213.kBDMD2VJ022044@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48742 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbWLMWNT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: AMD SVM: Save and restore the floating point unit 	state
has been added to the -mm tree.  Its filename is
     kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: AMD SVM: Save and restore the floating point unit 	state
From: Avi Kivity <avi@qumranet.com>

Fixes sf bug 1614113 (segfaults in nbench).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN drivers/kvm/svm.c~kvm-amd-svm-save-and-restore-the-floating-point-unit drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-amd-svm-save-and-restore-the-floating-point-unit
+++ a/drivers/kvm/svm.c
@@ -575,6 +575,8 @@ static int svm_create_vcpu(struct kvm_vc
 	memset(vcpu->svm->db_regs, 0, sizeof(vcpu->svm->db_regs));
 	init_vmcb(vcpu->svm->vmcb);
 
+	fx_init(vcpu);
+
 	return 0;
 
 out2:
@@ -1387,6 +1389,10 @@ again:
 		save_db_regs(vcpu->svm->host_db_regs);
 		load_db_regs(vcpu->svm->db_regs);
 	}
+
+	fx_save(vcpu->host_fx_image);
+	fx_restore(vcpu->guest_fx_image);
+
 	asm volatile (
 #ifdef CONFIG_X86_64
 		"push %%rbx; push %%rcx; push %%rdx;"
@@ -1496,6 +1502,9 @@ again:
 #endif
 		: "cc", "memory" );
 
+	fx_save(vcpu->guest_fx_image);
+	fx_restore(vcpu->host_fx_image);
+
 	if ((vcpu->svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(vcpu->svm->host_db_regs);
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch
kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch
kvm-move-find_vmx_entry-to-vmxc.patch
kvm-remove-extranous-put_cpu-from-vcpu_put.patch
kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch
kvm-add-maintainers-entry.patch
kvm-disallow-the-kvm-amd-module-on-intel-hardware.patch
kvm-dont-touch-the-virtual-apic-vt-registers-on-32-bit.patch
kvm-fix-vmx-hardware_enable-on-macbooks.patch
kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

