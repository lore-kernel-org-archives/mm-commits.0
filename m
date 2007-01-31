From: akpm@osdl.org
Subject: + kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:43 -0800
Message-ID: <200701310036.l0V0ahNm002557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXAaAgq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: Fix mmu going crazy of guest sets cr0.wp == 0
has been added to the -mm tree.  Its filename is
     kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: Fix mmu going crazy of guest sets cr0.wp == 0
From: Avi Kivity <avi@qumranet.com>

The kvm mmu relies on cr0.wp being set even if the guest does not set it.  The
vmx code correctly forces cr0.wp at all times, the svm code does not, so it
can't boot solaris without this patch.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0 drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0
+++ a/drivers/kvm/svm.c
@@ -723,7 +723,7 @@ static void svm_set_cr0(struct kvm_vcpu 
 	}
 #endif
 	vcpu->svm->cr0 = cr0;
-	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK;
+	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK | CR0_WP_MASK;
 	vcpu->cr0 = cr0;
 }
 
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
