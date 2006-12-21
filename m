From: akpm@osdl.org
Subject: + kvm-force-real-mode-cs-limit-to-64k.patch added to -mm tree
Date: Thu, 21 Dec 2006 02:00:04 -0800
Message-ID: <200612211000.kBLA044W023507@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965191AbWLUKAJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 05:00:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@mr511.de, avi@qumranet.com


The patch titled
     KVM: Force real-mode cs limit to 64K
has been added to the -mm tree.  Its filename is
     kvm-force-real-mode-cs-limit-to-64k.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-do-not-export-unsupported-msrs-to-userspace.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
kvm-force-real-mode-cs-limit-to-64k.patch
kvm-handle-p5-mce-msrs.patch

