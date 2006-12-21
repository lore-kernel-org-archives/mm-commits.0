From: akpm@osdl.org
Subject: + kvm-handle-p5-mce-msrs.patch added to -mm tree
Date: Thu, 21 Dec 2006 02:00:05 -0800
Message-ID: <200612211000.kBLA05PP023510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965189AbWLUKAL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 05:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@mr511.de, avi@qumranet.com


The patch titled
     KVM: Handle p5 mce msrs
has been added to the -mm tree.  Its filename is
     kvm-handle-p5-mce-msrs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Handle p5 mce msrs
From: Michael Riepe <michael@mr511.de>

This allows plan9 to get a little further booting.

Signed-off-by: Michael Riepe <michael@mr511.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    2 ++
 drivers/kvm/vmx.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/kvm/svm.c~kvm-handle-p5-mce-msrs drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-handle-p5-mce-msrs
+++ a/drivers/kvm/svm.c
@@ -1073,6 +1073,8 @@ static int emulate_on_interception(struc
 static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 {
 	switch (ecx) {
+	case MSR_IA32_P5_MC_ADDR:
+	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MC0_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MCG_CAP:
diff -puN drivers/kvm/vmx.c~kvm-handle-p5-mce-msrs drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-handle-p5-mce-msrs
+++ a/drivers/kvm/vmx.c
@@ -359,6 +359,8 @@ static int vmx_get_msr(struct kvm_vcpu *
 	case MSR_IA32_SYSENTER_ESP:
 		data = vmcs_read32(GUEST_SYSENTER_ESP);
 		break;
+	case MSR_IA32_P5_MC_ADDR:
+	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MC0_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MCG_CAP:
_

Patches currently in -mm which might be from michael@mr511.de are

kvm-do-not-export-unsupported-msrs-to-userspace.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
kvm-force-real-mode-cs-limit-to-64k.patch
kvm-handle-p5-mce-msrs.patch

