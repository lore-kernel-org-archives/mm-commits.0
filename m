From: akpm@osdl.org
Subject: - kvm-simplify-test-for-interrupt-window.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:27 -0800
Message-ID: <200701070800.l0780RfE013192@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbXAGIA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dor.laor@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Simplify test for interrupt window
has been removed from the -mm tree.  Its filename was
     kvm-simplify-test-for-interrupt-window.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Simplify test for interrupt window
From: Dor Laor <dor.laor@qumranet.com>

No need to test for rflags.if as both VT and SVM specs assure us that on exit
caused from interrupt window opening, 'if' is set.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    3 +--
 drivers/kvm/vmx.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-simplify-test-for-interrupt-window drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-simplify-test-for-interrupt-window
+++ a/drivers/kvm/svm.c
@@ -1206,8 +1206,7 @@ static int interrupt_window_interception
 	 * possible
 	 */
 	if (kvm_run->request_interrupt_window &&
-	    !vcpu->irq_summary &&
-	    (vcpu->svm->vmcb->save.rflags & X86_EFLAGS_IF)) {
+	    !vcpu->irq_summary) {
 		++kvm_stat.irq_window_exits;
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		return 0;
diff -puN drivers/kvm/vmx.c~kvm-simplify-test-for-interrupt-window drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-simplify-test-for-interrupt-window
+++ a/drivers/kvm/vmx.c
@@ -1604,8 +1604,7 @@ static int handle_interrupt_window(struc
 	 * possible
 	 */
 	if (kvm_run->request_interrupt_window &&
-	    !vcpu->irq_summary &&
-	    (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF)) {
+	    !vcpu->irq_summary) {
 		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
 		++kvm_stat.irq_window_exits;
 		return 0;
_

Patches currently in -mm which might be from dor.laor@qumranet.com are
