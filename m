From: akpm@linux-foundation.org
Subject: + kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:35 -0800
Message-ID: <200702212049.l1LKnZXP025460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44127 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161344AbXBUUtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.rechberger@amd.com, avi@qumranet.com, joerg.roedel@amd.com


The patch titled
     KVM: vmx: hack set_cr0_no_modeswitch() to actually do modeswitch
has been added to the -mm tree.  Its filename is
     kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: vmx: hack set_cr0_no_modeswitch() to actually do modeswitch
From: Markus Rechberger <markus.rechberger@amd.com>

The whole thing is rotten, but this allows vmx to boot with the guest reboot
fix.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do
+++ a/drivers/kvm/vmx.c
@@ -791,6 +791,9 @@ static void vmx_set_cr0(struct kvm_vcpu 
  */
 static void vmx_set_cr0_no_modeswitch(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
+	if (!vcpu->rmode.active && !(cr0 & CR0_PE_MASK))
+		enter_rmode(vcpu);
+
 	vcpu->rmode.active = ((cr0 & CR0_PE_MASK) == 0);
 	update_exception_bitmap(vcpu);
 	vmcs_writel(CR0_READ_SHADOW, cr0);
_

Patches currently in -mm which might be from markus.rechberger@amd.com are

kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-page_private-set_page_private-apis.patch
