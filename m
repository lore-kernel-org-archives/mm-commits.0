From: akpm@osdl.org
Subject: - kvm-force-real-mode-cs-limit-to-64k.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:20 -0800
Message-ID: <200612230753.kBN7rKvn010113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49591 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbWLWHx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@mr511.de, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Force real-mode cs limit to 64K
has been removed from the -mm tree.  Its filename was
     kvm-force-real-mode-cs-limit-to-64k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Force real-mode cs limit to 64K
From: Michael Riepe <michael@mr511.de>

This allows opensolaris to boot on kvm/intel.

Signed-off-by: Michael Riepe <michael@mr511.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/kvm/vmx.c~kvm-force-real-mode-cs-limit-to-64k drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-force-real-mode-cs-limit-to-64k
+++ a/drivers/kvm/vmx.c
@@ -726,6 +726,7 @@ static void enter_rmode(struct kvm_vcpu 
 	vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
 
 	vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
+	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
 	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
 
 	fix_rmode_seg(VCPU_SREG_ES, &vcpu->rmode.es);
_

Patches currently in -mm which might be from michael@mr511.de are

origin.patch

