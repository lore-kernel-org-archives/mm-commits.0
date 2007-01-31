From: akpm@osdl.org
Subject: + kvm-fix-gva_to_gpa.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:39 -0800
Message-ID: <200701310036.l0V0adTU002551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbXAaAgn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: Fix gva_to_gpa()
has been added to the -mm tree.  Its filename is
     kvm-fix-gva_to_gpa.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: Fix gva_to_gpa()
From: Avi Kivity <avi@qumranet.com>

gva_to_gpa() needs to be updated to the new walk_addr() calling convention,
otherwise it may oops under some circumstances.

Use the opportunity to remove all the code duplication in gva_to_gpa(), which
essentially repeats the calculations in walk_addr().

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-fix-gva_to_gpa drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-fix-gva_to_gpa
+++ a/drivers/kvm/paging_tmpl.h
@@ -443,31 +443,17 @@ static int FNAME(page_fault)(struct kvm_
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 {
 	struct guest_walker walker;
-	pt_element_t guest_pte;
-	gpa_t gpa;
+	gpa_t gpa = UNMAPPED_GVA;
+	int r;
 
-	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
-	guest_pte = *walker.ptep;
-	FNAME(release_walker)(&walker);
-
-	if (!is_present_pte(guest_pte))
-		return UNMAPPED_GVA;
-
-	if (walker.level == PT_DIRECTORY_LEVEL) {
-		ASSERT((guest_pte & PT_PAGE_SIZE_MASK));
-		ASSERT(PTTYPE == 64 || is_pse(vcpu));
+	r = FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
 
-		gpa = (guest_pte & PT_DIR_BASE_ADDR_MASK) | (vaddr &
-			(PT_LEVEL_MASK(PT_PAGE_TABLE_LEVEL) | ~PAGE_MASK));
-
-		if (PTTYPE == 32 && is_cpuid_PSE36())
-			gpa |= (guest_pte & PT32_DIR_PSE36_MASK) <<
-					(32 - PT32_DIR_PSE36_SHIFT);
-	} else {
-		gpa = (guest_pte & PT_BASE_ADDR_MASK);
-		gpa |= (vaddr & ~PAGE_MASK);
+	if (r) {
+		gpa = (gpa_t)walker.gfn << PAGE_SHIFT;
+		gpa |= vaddr & ~PAGE_MASK;
 	}
 
+	FNAME(release_walker)(&walker);
 	return gpa;
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
