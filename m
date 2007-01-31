From: akpm@osdl.org
Subject: + kvm-vmx-add-vcpu_clear.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:51:30 -0800
Message-ID: <200701310051.l0V0pUEe002970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbXAaAvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: VMX: add vcpu_clear()
has been added to the -mm tree.  Its filename is
     kvm-vmx-add-vcpu_clear.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: VMX: add vcpu_clear()
From: Avi Kivity <avi@qumranet.com>

Like the inline code it replaces, this function decaches the vmcs from the cpu
it last executed on.  in addition:

 - vcpu_clear() works if the last cpu is also the cpu we're running on
 - it is faster on larger smps by virtue of using smp_call_function_single()

Includes fix from Ingo Molnar.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-vmx-add-vcpu_clear drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-add-vcpu_clear
+++ a/drivers/kvm/vmx.c
@@ -125,6 +125,15 @@ static void __vcpu_clear(void *arg)
 		per_cpu(current_vmcs, cpu) = NULL;
 }
 
+static void vcpu_clear(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->cpu != raw_smp_processor_id() && vcpu->cpu != -1)
+		smp_call_function_single(vcpu->cpu, __vcpu_clear, vcpu, 0, 1);
+	else
+		__vcpu_clear(vcpu);
+	vcpu->launched = 0;
+}
+
 static unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value;
@@ -202,10 +211,8 @@ static struct kvm_vcpu *vmx_vcpu_load(st
 
 	cpu = get_cpu();
 
-	if (vcpu->cpu != cpu) {
-		smp_call_function(__vcpu_clear, vcpu, 0, 1);
-		vcpu->launched = 0;
-	}
+	if (vcpu->cpu != cpu)
+		vcpu_clear(vcpu);
 
 	if (per_cpu(current_vmcs, cpu) != vcpu->vmcs) {
 		u8 error;
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
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
kvm-vmx-add-vcpu_clear.patch
kvm-cpu-hotplug-support.patch
kvm-host-suspend-resume-support.patch
