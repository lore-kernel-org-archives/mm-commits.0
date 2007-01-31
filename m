From: akpm@osdl.org
Subject: + kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:45 -0800
Message-ID: <200701310036.l0V0ajL8002560@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXAaAgt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: SVM: Hack initial cpu csbase to be consistent with intel
has been added to the -mm tree.  Its filename is
     kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: SVM: Hack initial cpu csbase to be consistent with intel
From: Avi Kivity <avi@qumranet.com>

This allows us to run the mmu testsuite on amd.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel
+++ a/drivers/kvm/svm.c
@@ -528,7 +528,13 @@ static void init_vmcb(struct vmcb *vmcb)
 	save->cs.attrib = SVM_SELECTOR_READ_MASK | SVM_SELECTOR_P_MASK |
 		SVM_SELECTOR_S_MASK | SVM_SELECTOR_CODE_MASK;
 	save->cs.limit = 0xffff;
-	save->cs.base = 0xffff0000;
+	/*
+	 * cs.base should really be 0xffff0000, but vmx can't handle that, so
+	 * be consistent with it.
+	 *
+	 * Replace when we have real mode working for vmx.
+	 */
+	save->cs.base = 0xf0000;
 
 	save->gdtr.limit = 0xffff;
 	save->idtr.limit = 0xffff;
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
