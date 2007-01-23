From: akpm@osdl.org
Subject: + kvm-emulate-ia32_misc_enable-msr.patch added to -mm tree
Date: Tue, 23 Jan 2007 10:57:03 -0800
Message-ID: <200701231857.l0NIv3Qt027771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965408AbXAWS5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 13:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Emulate IA32_MISC_ENABLE msr
has been added to the -mm tree.  Its filename is
     kvm-emulate-ia32_misc_enable-msr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-add-vm-exit-profiling-fix.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
kvm-svm-fix-svm-idt-confusion.patch
kvm-emulate-ia32_misc_enable-msr.patch
kvm-mmu-perform-access-checks-in-walk_addr.patch
kvm-mmu-report-nx-faults-to-the-guest.patch
kvm-svm-propagate-cpu-shutdown-events-to-userspace.patch
