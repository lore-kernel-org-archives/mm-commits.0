From: akpm@osdl.org
Subject: + kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:41 -0800
Message-ID: <200701310036.l0V0afVQ002554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXAaAgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: vmx: handle triple faults by returning EXIT_REASON_SHUTDOWN to userspace
has been added to the -mm tree.  Its filename is
     kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: vmx: handle triple faults by returning EXIT_REASON_SHUTDOWN to userspace
From: Avi Kivity <avi@qumranet.com>

Just like svm.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    6 ++++++
 drivers/kvm/vmx.h |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace
+++ a/drivers/kvm/vmx.c
@@ -1373,6 +1373,11 @@ static int handle_external_interrupt(str
 	return 1;
 }
 
+static int handle_triple_fault(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+	return 0;
+}
 
 static int get_io_count(struct kvm_vcpu *vcpu, u64 *count)
 {
@@ -1633,6 +1638,7 @@ static int (*kvm_vmx_exit_handlers[])(st
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
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
kvm-optimize-inline-assembly.patch
kvm-fix-asm-constraint-for-lldt-instruction.patch
kvm-fix-gva_to_gpa.patch
kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch
kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch
kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch
kvm-two-way-apic-tpr-synchronization.patch
kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch
kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch
kvm-fix-vcpu-freeing-bug.patch
