From: akpm@osdl.org
Subject: - kvm-dont-set-guest-cr3-from-vmx_vcpu_setup.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:19 -0800
Message-ID: <200701070800.l0780JCQ013178@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXAGIAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Don't set guest cr3 from vmx_vcpu_setup()
has been removed from the -mm tree.  Its filename was
     kvm-dont-set-guest-cr3-from-vmx_vcpu_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Don't set guest cr3 from vmx_vcpu_setup()
From: Avi Kivity <avi@qumranet.com>

It overwrites the right cr3 set from mmu setup.  Happens only with the test
harness.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-dont-set-guest-cr3-from-vmx_vcpu_setup drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-dont-set-guest-cr3-from-vmx_vcpu_setup
+++ a/drivers/kvm/vmx.c
@@ -1027,8 +1027,6 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	vmcs_writel(GUEST_RIP, 0xfff0);
 	vmcs_writel(GUEST_RSP, 0);
 
-	vmcs_writel(GUEST_CR3, 0);
-
 	//todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0
 	vmcs_writel(GUEST_DR7, 0x400);
 
_

Patches currently in -mm which might be from avi@qumranet.com are
