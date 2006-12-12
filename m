From: akpm@osdl.org
Subject: + kvm-disallow-the-kvm-amd-module-on-intel-hardware.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:22:23 -0800
Message-ID: <200612122122.kBCLMNpB016130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43102 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbWLLVWa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:22:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Disallow the kvm-amd module on intel hardware, and vice versa
has been added to the -mm tree.  Its filename is
     kvm-disallow-the-kvm-amd-module-on-intel-hardware.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

