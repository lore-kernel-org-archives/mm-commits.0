From: akpm@osdl.org
Subject: + kvm-implement-a-few-system-configuration-msrs.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:15:51 -0800
Message-ID: <200612282315.kBSNFpAj015854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbWL1XPz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Implement a few system configuration msrs
has been added to the -mm tree.  Its filename is
     kvm-implement-a-few-system-configuration-msrs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch
kvm-simplify-is_long_mode.patch
kvm-initialize-kvm_arch_ops-on-unload.patch
kvm-implement-a-few-system-configuration-msrs.patch
kvm-move-common-msr-handling-to-arch-independent-code.patch
kvm-more-msr-misery.patch
kvm-rename-some-msrs.patch
kvm-fix-oops-on-oom.patch
kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu.patch

