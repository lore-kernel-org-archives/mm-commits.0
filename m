From: akpm@osdl.org
Subject: - kvm-disallow-the-kvm-amd-module-on-intel-hardware.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:04:50 -0800
Message-ID: <200612140604.kBE64oGI001820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbWLNGFD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Disallow the kvm-amd module on intel hardware, and vice versa
has been removed from the -mm tree.  Its filename was
     kvm-disallow-the-kvm-amd-module-on-intel-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Disallow the kvm-amd module on intel hardware, and vice versa
From: Avi Kivity <avi@qumranet.com>

They're not on speaking terms.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    5 ++---
 drivers/kvm/vmx.c |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-disallow-the-kvm-amd-module-on-intel-hardware drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-disallow-the-kvm-amd-module-on-intel-hardware
+++ a/drivers/kvm/svm.c
@@ -377,6 +377,7 @@ static __init int svm_hardware_setup(voi
 	void *msrpm_va;
 	int r;
 
+	kvm_emulator_want_group7_invlpg();
 
 	iopm_pages = alloc_pages(GFP_KERNEL, IOPM_ALLOC_ORDER);
 
@@ -1628,9 +1629,7 @@ static struct kvm_arch_ops svm_arch_ops 
 
 static int __init svm_init(void)
 {
-	kvm_emulator_want_group7_invlpg();
-	kvm_init_arch(&svm_arch_ops, THIS_MODULE);
-	return 0;
+	return kvm_init_arch(&svm_arch_ops, THIS_MODULE);
 }
 
 static void __exit svm_exit(void)
diff -puN drivers/kvm/vmx.c~kvm-disallow-the-kvm-amd-module-on-intel-hardware drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-disallow-the-kvm-amd-module-on-intel-hardware
+++ a/drivers/kvm/vmx.c
@@ -2000,8 +2000,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 
 static int __init vmx_init(void)
 {
-	kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
-	return 0;
+	return kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
 }
 
 static void __exit vmx_exit(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

