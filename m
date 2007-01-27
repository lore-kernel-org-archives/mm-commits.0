From: akpm@osdl.org
Subject: - kvm-svm-propagate-cpu-shutdown-events-to-userspace.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:06 -0800
Message-ID: <200701270131.l0R1V6qe031813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbXA0BbZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: SVM: Propagate cpu shutdown events to userspace
has been removed from the -mm tree.  Its filename was
     kvm-svm-propagate-cpu-shutdown-events-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: SVM: Propagate cpu shutdown events to userspace
From: Joerg Roedel <joerg.roedel@amd.com>

This patch implements forwarding of SHUTDOWN intercepts from the guest on to
userspace on AMD SVM.  A SHUTDOWN event occurs when the guest produces a
triple fault (e.g.  on reboot).  This also fixes the bug that a guest reboot
actually causes a host reboot under some circumstances.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c   |   15 +++++++++++++++
 include/linux/kvm.h |    1 +
 2 files changed, 16 insertions(+)

diff -puN drivers/kvm/svm.c~kvm-svm-propagate-cpu-shutdown-events-to-userspace drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-svm-propagate-cpu-shutdown-events-to-userspace
+++ a/drivers/kvm/svm.c
@@ -502,6 +502,7 @@ static void init_vmcb(struct vmcb *vmcb)
 				(1ULL << INTERCEPT_IOIO_PROT) |
 				(1ULL << INTERCEPT_MSR_PROT) |
 				(1ULL << INTERCEPT_TASK_SWITCH) |
+				(1ULL << INTERCEPT_SHUTDOWN) |
 				(1ULL << INTERCEPT_VMRUN) |
 				(1ULL << INTERCEPT_VMMCALL) |
 				(1ULL << INTERCEPT_VMLOAD) |
@@ -892,6 +893,19 @@ static int pf_interception(struct kvm_vc
 	return 0;
 }
 
+static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	/*
+	 * VMCB is undefined after a SHUTDOWN intercept
+	 * so reinitialize it.
+	 */
+	memset(vcpu->svm->vmcb, 0, PAGE_SIZE);
+	init_vmcb(vcpu->svm->vmcb);
+
+	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+	return 0;
+}
+
 static int io_get_override(struct kvm_vcpu *vcpu,
 			  struct vmcb_seg **seg,
 			  int *addr_override)
@@ -1249,6 +1263,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_IOIO] 		  	= io_interception,
 	[SVM_EXIT_MSR]				= msr_interception,
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
+	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= invalid_op_interception,
 	[SVM_EXIT_VMMCALL]			= invalid_op_interception,
 	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
diff -puN include/linux/kvm.h~kvm-svm-propagate-cpu-shutdown-events-to-userspace include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-svm-propagate-cpu-shutdown-events-to-userspace
+++ a/include/linux/kvm.h
@@ -46,6 +46,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_HLT              = 5,
 	KVM_EXIT_MMIO             = 6,
 	KVM_EXIT_IRQ_WINDOW_OPEN  = 7,
+	KVM_EXIT_SHUTDOWN         = 8,
 };
 
 /* for KVM_RUN */
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
