From: akpm@osdl.org
Subject: - kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:52 -0800
Message-ID: <200612100752.kBA7qqmT017687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760429AbWLJHwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yaniv@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Handle rdmsr(MSR_EFER)
has been removed from the -mm tree.  Its filename was
     kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Handle rdmsr(MSR_EFER)
From: Yaniv Kamay <yaniv@qumranet.com>

Allow guests to read the EFER msr.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-less-common-exit-handlers-handle-rdmsrmsr_efer drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-less-common-exit-handlers-handle-rdmsrmsr_efer
+++ a/drivers/kvm/kvm_main.c
@@ -2286,6 +2286,9 @@ static int handle_rdmsr(struct kvm_vcpu 
 	case MSR_GS_BASE:
 		data = vmcs_readl(GUEST_GS_BASE);
 		break;
+	case MSR_EFER:
+		data = vcpu->shadow_efer;
+		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		data = vmcs_read32(GUEST_SYSENTER_CS);
_

Patches currently in -mm which might be from yaniv@qumranet.com are

kvm-userspace-interface.patch
kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch
kvm-mmu.patch
kvm-x86-emulator.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch

