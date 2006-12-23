From: akpm@osdl.org
Subject: - kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:11 -0800
Message-ID: <200612230753.kBN7rBfB010099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbWLWHxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: AMD SVM: handle MSR_STAR in 32-bit mode
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: AMD SVM: handle MSR_STAR in 32-bit mode
From: Avi Kivity <avi@qumranet.com>

This is necessary for linux guests.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-amd-svm-handle-msr_star-in-32-bit-mode drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-amd-svm-handle-msr_star-in-32-bit-mode
+++ a/drivers/kvm/svm.c
@@ -402,11 +402,11 @@ static __init int svm_hardware_setup(voi
 	set_msr_interception(msrpm_va, MSR_GS_BASE, 1, 1);
 	set_msr_interception(msrpm_va, MSR_FS_BASE, 1, 1);
 	set_msr_interception(msrpm_va, MSR_KERNEL_GS_BASE, 1, 1);
-	set_msr_interception(msrpm_va, MSR_STAR, 1, 1);
 	set_msr_interception(msrpm_va, MSR_LSTAR, 1, 1);
 	set_msr_interception(msrpm_va, MSR_CSTAR, 1, 1);
 	set_msr_interception(msrpm_va, MSR_SYSCALL_MASK, 1, 1);
 #endif
+	set_msr_interception(msrpm_va, MSR_K6_STAR, 1, 1);
 	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_CS, 1, 1);
 	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_ESP, 1, 1);
 	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_EIP, 1, 1);
@@ -1098,10 +1098,10 @@ static int svm_get_msr(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		*data = vcpu->apic_base;
 		break;
-#ifdef CONFIG_X86_64
-	case MSR_STAR:
+	case MSR_K6_STAR:
 		*data = vcpu->svm->vmcb->save.star;
 		break;
+#ifdef CONFIG_X86_64
 	case MSR_LSTAR:
 		*data = vcpu->svm->vmcb->save.lstar;
 		break;
@@ -1173,10 +1173,10 @@ static int svm_set_msr(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		vcpu->apic_base = data;
 		break;
-#ifdef CONFIG_X86_64_
-	case MSR_STAR:
+	case MSR_K6_STAR:
 		vcpu->svm->vmcb->save.star = data;
 		break;
+#ifdef CONFIG_X86_64_
 	case MSR_LSTAR:
 		vcpu->svm->vmcb->save.lstar = data;
 		break;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch

