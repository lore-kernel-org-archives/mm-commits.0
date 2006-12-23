From: akpm@osdl.org
Subject: - kvm-handle-p5-mce-msrs.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:22 -0800
Message-ID: <200612230753.kBN7rMRB010116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbWLWHx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@mr511.de, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Handle p5 mce msrs
has been removed from the -mm tree.  Its filename was
     kvm-handle-p5-mce-msrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

