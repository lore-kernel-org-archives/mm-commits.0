From: akpm@osdl.org
Subject: - kvm-dont-touch-the-virtual-apic-vt-registers-on-32-bit.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:05:00 -0800
Message-ID: <200612140605.kBE650fc001825@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51792 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbWLNGF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:05:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@mr511.de, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Don't touch the virtual apic vt registers on 32-bit
has been removed from the -mm tree.  Its filename was
     kvm-dont-touch-the-virtual-apic-vt-registers-on-32-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Don't touch the virtual apic vt registers on 32-bit
From: Michael Riepe <michael@mr511.de>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-dont-touch-the-virtual-apic-vt-registers-on-32-bit drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-dont-touch-the-virtual-apic-vt-registers-on-32-bit
+++ a/drivers/kvm/vmx.c
@@ -1175,8 +1175,10 @@ static int vmx_vcpu_setup(struct kvm_vcp
                                VM_ENTRY_CONTROLS, 0);
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
+#ifdef CONFIG_X86_64
 	vmcs_writel(VIRTUAL_APIC_PAGE_ADDR, 0);
 	vmcs_writel(TPR_THRESHOLD, 0);
+#endif
 
 	vmcs_writel(CR0_GUEST_HOST_MASK, KVM_GUEST_CR0_MASK);
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
_

Patches currently in -mm which might be from michael@mr511.de are


