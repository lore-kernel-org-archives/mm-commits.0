From: akpm@osdl.org
Subject: + kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:49 -0800
Message-ID: <200701310036.l0V0ancs002566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbXAaAgx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: VMX: Reload ds and es even in 64-bit mode
has been added to the -mm tree.  Its filename is
     kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: VMX: Reload ds and es even in 64-bit mode
From: Avi Kivity <avi@qumranet.com>

Or 32-bit userspace will get confused.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-vmx-reload-ds-and-es-even-in-64-bit-mode drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-reload-ds-and-es-even-in-64-bit-mode
+++ a/drivers/kvm/vmx.c
@@ -1863,9 +1863,7 @@ again:
 	fx_restore(vcpu->host_fx_image);
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
-#ifndef CONFIG_X86_64
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
-#endif
 
 	kvm_run->exit_type = 0;
 	if (fail) {
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
