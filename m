From: akpm@linux-foundation.org
Subject: - kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:45 -0800
Message-ID: <200702122248.l1CMmjTM014049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030368AbXBLWtA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: vmx: handle triple faults by returning EXIT_REASON_SHUTDOWN to userspace
has been removed from the -mm tree.  Its filename was
     kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: vmx: handle triple faults by returning EXIT_REASON_SHUTDOWN to userspace
From: Avi Kivity <avi@qumranet.com>

Just like svm.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c |    6 ++++++
 drivers/kvm/vmx.h |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace
+++ a/drivers/kvm/vmx.c
@@ -1375,6 +1375,11 @@ static int handle_external_interrupt(str
 	return 1;
 }
 
+static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+	return 0;
+}
 
 static int get_io_count(struct kvm_vcpu *vcpu, u64 *count)
 {
@@ -1635,6 +1640,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 				      struct kvm_run *kvm_run) = {
 	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      = handle_external_interrupt,
+	[EXIT_REASON_TRIPLE_FAULT]            = handle_triple_fault,
 	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
 	[EXIT_REASON_CR_ACCESS]               = handle_cr,
 	[EXIT_REASON_DR_ACCESS]               = handle_dr,
diff -puN drivers/kvm/vmx.h~kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace drivers/kvm/vmx.h
--- a/drivers/kvm/vmx.h~kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace
+++ a/drivers/kvm/vmx.h
@@ -180,6 +180,7 @@ enum vmcs_field {
 
 #define EXIT_REASON_EXCEPTION_NMI       0
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
+#define EXIT_REASON_TRIPLE_FAULT        2
 
 #define EXIT_REASON_PENDING_INTERRUPT   7
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
