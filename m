From: akpm@osdl.org
Subject: - kvm-implement-a-few-system-configuration-msrs.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:25:14 -0800
Message-ID: <200701020725.l027PE80013019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXABHZQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Implement a few system configuration msrs
has been removed from the -mm tree.  Its filename was
     kvm-implement-a-few-system-configuration-msrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Implement a few system configuration msrs
From: Avi Kivity <avi@qumranet.com>

Resolves sourceforge bug 1622229 (guest crashes running benchmark software).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    3 +++
 drivers/kvm/vmx.c |    3 +++
 2 files changed, 6 insertions(+)

diff -puN drivers/kvm/svm.c~kvm-implement-a-few-system-configuration-msrs drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-implement-a-few-system-configuration-msrs
+++ a/drivers/kvm/svm.c
@@ -1068,6 +1068,9 @@ static int emulate_on_interception(struc
 static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 {
 	switch (ecx) {
+	case 0xc0010010: /* SYSCFG */
+	case 0xc0010015: /* HWCR */
+	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MC0_CTL:
diff -puN drivers/kvm/vmx.c~kvm-implement-a-few-system-configuration-msrs drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-implement-a-few-system-configuration-msrs
+++ a/drivers/kvm/vmx.c
@@ -359,6 +359,9 @@ static int vmx_get_msr(struct kvm_vcpu *
 	case MSR_IA32_SYSENTER_ESP:
 		data = vmcs_read32(GUEST_SYSENTER_ESP);
 		break;
+	case 0xc0010010: /* SYSCFG */
+	case 0xc0010015: /* HWCR */
+	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MC0_CTL:
_

Patches currently in -mm which might be from avi@qumranet.com are
