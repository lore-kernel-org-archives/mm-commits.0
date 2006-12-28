From: akpm@osdl.org
Subject: + kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:15:45 -0800
Message-ID: <200612282315.kBSNFjAQ015841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbWL1XPx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Use boot_cpu_data instead of current_cpu_data
has been added to the -mm tree.  Its filename is
     kvm-use-boot_cpu_data-instead-of-current_cpu_data.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Use boot_cpu_data instead of current_cpu_data
From: Avi Kivity <avi@qumranet.com>

current_cpu_data invokes smp_processor_id(), which is inadvisable when
preemption is enabled.  Switch to boot_cpu_data instead.

Resolves sourceforge bug 1621401.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-use-boot_cpu_data-instead-of-current_cpu_data drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-use-boot_cpu_data-instead-of-current_cpu_data
+++ a/drivers/kvm/svm.c
@@ -246,7 +246,7 @@ static int has_svm(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 
-	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD) {
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
 		printk(KERN_INFO "has_svm: not amd\n");
 		return 0;
 	}
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

