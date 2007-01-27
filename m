From: akpm@osdl.org
Subject: - kvm-emulate-ia32_misc_enable-msr.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:00 -0800
Message-ID: <200701270131.l0R1V0F3031804@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbXA0BbL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Emulate IA32_MISC_ENABLE msr
has been removed from the -mm tree.  Its filename was
     kvm-emulate-ia32_misc_enable-msr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Emulate IA32_MISC_ENABLE msr
From: Avi Kivity <avi@qumranet.com>

This allows netbsd 3.1 i386 to get further along installing.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm.h~kvm-emulate-ia32_misc_enable-msr drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-emulate-ia32_misc_enable-msr
+++ a/drivers/kvm/kvm.h
@@ -242,6 +242,7 @@ struct kvm_vcpu {
 	u64 pdptrs[4]; /* pae */
 	u64 shadow_efer;
 	u64 apic_base;
+	u64 ia32_misc_enable_msr;
 	int nmsrs;
 	struct vmx_msr_entry *guest_msrs;
 	struct vmx_msr_entry *host_msrs;
diff -puN drivers/kvm/kvm_main.c~kvm-emulate-ia32_misc_enable-msr drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-emulate-ia32_misc_enable-msr
+++ a/drivers/kvm/kvm_main.c
@@ -1226,6 +1226,9 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		data = vcpu->apic_base;
 		break;
+	case MSR_IA32_MISC_ENABLE:
+		data = vcpu->ia32_misc_enable_msr;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_EFER:
 		data = vcpu->shadow_efer;
@@ -1297,6 +1300,9 @@ int kvm_set_msr_common(struct kvm_vcpu *
 	case MSR_IA32_APICBASE:
 		vcpu->apic_base = data;
 		break;
+	case MSR_IA32_MISC_ENABLE:
+		vcpu->ia32_misc_enable_msr = data;
+		break;
 	default:
 		printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr);
 		return 1;
@@ -1600,6 +1606,10 @@ static u32 msrs_to_save[] = {
 
 static unsigned num_msrs_to_save;
 
+static u32 emulated_msrs[] = {
+	MSR_IA32_MISC_ENABLE,
+};
+
 static __init void kvm_init_msr_list(void)
 {
 	u32 dummy[2];
@@ -1925,7 +1935,7 @@ static long kvm_dev_ioctl(struct file *f
 		if (copy_from_user(&msr_list, user_msr_list, sizeof msr_list))
 			goto out;
 		n = msr_list.nmsrs;
-		msr_list.nmsrs = num_msrs_to_save;
+		msr_list.nmsrs = num_msrs_to_save + ARRAY_SIZE(emulated_msrs);
 		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
 			goto out;
 		r = -E2BIG;
@@ -1935,6 +1945,11 @@ static long kvm_dev_ioctl(struct file *f
 		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
 				 num_msrs_to_save * sizeof(u32)))
 			goto out;
+		if (copy_to_user(user_msr_list->indices
+				 + num_msrs_to_save * sizeof(u32),
+				 &emulated_msrs,
+				 ARRAY_SIZE(emulated_msrs) * sizeof(u32)))
+			goto out;
 		r = 0;
 		break;
 	}
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
