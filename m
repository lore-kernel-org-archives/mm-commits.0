From: akpm@osdl.org
Subject: + kvm-rename-some-msrs.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:15:57 -0800
Message-ID: <200612282315.kBSNFvGr015863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbWL1XQC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:16:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aquynh@gmail.com, avi@qumranet.com


The patch titled
     KVM: Rename some msrs
has been added to the -mm tree.  Its filename is
     kvm-rename-some-msrs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Rename some msrs
From: Nguyen Anh Quynh <aquynh@gmail.com>

No need to append _MSR to msr names, a prefix should suffice.

Signed-off-by: Nguyen Anh Quynh <aquynh@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |   13 ++++++-------
 drivers/kvm/vmx.h |   10 +++++-----
 2 files changed, 11 insertions(+), 12 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-rename-some-msrs drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-rename-some-msrs
+++ a/drivers/kvm/vmx.c
@@ -26,7 +26,6 @@
 
 #include "segment_descriptor.h"
 
-#define MSR_IA32_FEATURE_CONTROL 		0x03a
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -519,11 +518,11 @@ static __init void setup_vmcs_descriptor
 {
 	u32 vmx_msr_low, vmx_msr_high;
 
-	rdmsr(MSR_IA32_VMX_BASIC_MSR, vmx_msr_low, vmx_msr_high);
+	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 	vmcs_descriptor.size = vmx_msr_high & 0x1fff;
 	vmcs_descriptor.order = get_order(vmcs_descriptor.size);
 	vmcs_descriptor.revision_id = vmx_msr_low;
-};
+}
 
 static struct vmcs *alloc_vmcs_cpu(int cpu)
 {
@@ -1039,12 +1038,12 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
 
 	/* Control */
-	vmcs_write32_fixedbits(MSR_IA32_VMX_PINBASED_CTLS_MSR,
+	vmcs_write32_fixedbits(MSR_IA32_VMX_PINBASED_CTLS,
 			       PIN_BASED_VM_EXEC_CONTROL,
 			       PIN_BASED_EXT_INTR_MASK   /* 20.6.1 */
 			       | PIN_BASED_NMI_EXITING   /* 20.6.1 */
 			);
-	vmcs_write32_fixedbits(MSR_IA32_VMX_PROCBASED_CTLS_MSR,
+	vmcs_write32_fixedbits(MSR_IA32_VMX_PROCBASED_CTLS,
 			       CPU_BASED_VM_EXEC_CONTROL,
 			       CPU_BASED_HLT_EXITING         /* 20.6.2 */
 			       | CPU_BASED_CR8_LOAD_EXITING    /* 20.6.2 */
@@ -1127,7 +1126,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 		    virt_to_phys(vcpu->guest_msrs + NR_BAD_MSRS));
 	vmcs_writel(VM_EXIT_MSR_LOAD_ADDR,
 		    virt_to_phys(vcpu->host_msrs + NR_BAD_MSRS));
-	vmcs_write32_fixedbits(MSR_IA32_VMX_EXIT_CTLS_MSR, VM_EXIT_CONTROLS,
+	vmcs_write32_fixedbits(MSR_IA32_VMX_EXIT_CTLS, VM_EXIT_CONTROLS,
 		     	       (HOST_IS_64 << 9));  /* 22.2,1, 20.7.1 */
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, nr_good_msrs); /* 22.2.2 */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, nr_good_msrs);  /* 22.2.2 */
@@ -1135,7 +1134,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 
 
 	/* 22.2.1, 20.8.1 */
-	vmcs_write32_fixedbits(MSR_IA32_VMX_ENTRY_CTLS_MSR,
+	vmcs_write32_fixedbits(MSR_IA32_VMX_ENTRY_CTLS,
                                VM_ENTRY_CONTROLS, 0);
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
diff -puN drivers/kvm/vmx.h~kvm-rename-some-msrs drivers/kvm/vmx.h
--- a/drivers/kvm/vmx.h~kvm-rename-some-msrs
+++ a/drivers/kvm/vmx.h
@@ -286,11 +286,11 @@ enum vmcs_field {
 
 #define CR4_VMXE 0x2000
 
-#define MSR_IA32_VMX_BASIC_MSR   		0x480
+#define MSR_IA32_VMX_BASIC   		0x480
 #define MSR_IA32_FEATURE_CONTROL 		0x03a
-#define MSR_IA32_VMX_PINBASED_CTLS_MSR		0x481
-#define MSR_IA32_VMX_PROCBASED_CTLS_MSR		0x482
-#define MSR_IA32_VMX_EXIT_CTLS_MSR		0x483
-#define MSR_IA32_VMX_ENTRY_CTLS_MSR		0x484
+#define MSR_IA32_VMX_PINBASED_CTLS		0x481
+#define MSR_IA32_VMX_PROCBASED_CTLS		0x482
+#define MSR_IA32_VMX_EXIT_CTLS		0x483
+#define MSR_IA32_VMX_ENTRY_CTLS		0x484
 
 #endif
_

Patches currently in -mm which might be from aquynh@gmail.com are

kvm-rename-some-msrs.patch

