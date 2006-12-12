From: akpm@osdl.org
Subject: + kvm-fix-vmx-hardware_enable-on-macbooks-fix.patch added to -mm tree
Date: Tue, 12 Dec 2006 13:23:09 -0800
Message-ID: <200612122123.kBCLN9B9016152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43206 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbWLLVXL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 16:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Re-fix vmx hardware_enable() on macbooks
has been added to the -mm tree.  Its filename is
     kvm-fix-vmx-hardware_enable-on-macbooks-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Re-fix vmx hardware_enable() on macbooks
From: Avi Kivity <avi@qumranet.com>

This incremental patch fixes the macbook issue for real.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Tested-by: Alex Larsson (sometimes testing helps)
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/vmx.c~kvm-fix-vmx-hardware_enable-on-macbooks-fix drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-vmx-hardware_enable-on-macbooks-fix
+++ a/drivers/kvm/vmx.c
@@ -534,7 +534,7 @@ static __init void hardware_enable(void 
 	u64 old;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & 4) == 0)
+	if ((old & 5) != 5)
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
 	write_cr4(read_cr4() | CR4_VMXE); /* FIXME: not cpu hotplug safe */
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
kvm-fix-vmx-hardware_enable-on-macbooks-fix.patch

