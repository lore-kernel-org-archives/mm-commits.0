From: akpm@osdl.org
Subject: - kvm-fix-vmx-hardware_enable-on-macbooks.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:05:12 -0800
Message-ID: <200612140605.kBE65CtU001830@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51788 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbWLNGFZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix vmx hardware_enable() on macbooks
has been removed from the -mm tree.  Its filename was
     kvm-fix-vmx-hardware_enable-on-macbooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Fix vmx hardware_enable() on macbooks
From: Avi Kivity <avi@qumranet.com>

It seems macbooks set bit 2 but not bit 0, which is an "enabled but vmxon will
fault" setting.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Tested-by: Alex Larsson (sometimes testing helps)
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/vmx.c~kvm-fix-vmx-hardware_enable-on-macbooks drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-vmx-hardware_enable-on-macbooks
+++ a/drivers/kvm/vmx.c
@@ -534,7 +534,7 @@ static __init void hardware_enable(void 
 	u64 old;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & 5) == 0)
+	if ((old & 5) != 5)
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
 	write_cr4(read_cr4() | CR4_VMXE); /* FIXME: not cpu hotplug safe */
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

