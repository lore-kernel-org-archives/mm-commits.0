From: akpm@osdl.org
Subject: - kvm-mmu-report-nx-faults-to-the-guest.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:04 -0800
Message-ID: <200701270131.l0R1V4qG031810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXA0BbL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Report nx faults to the guest
has been removed from the -mm tree.  Its filename was
     kvm-mmu-report-nx-faults-to-the-guest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Report nx faults to the guest
From: Avi Kivity <avi@qumranet.com>

Rith the recent guest page fault change, we perform access checks on our own
instead of relying on the cpu.  This means we have to perform the nx checks as
well.

Software like the google toolbar on windows appears to rely on this somehow.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c         |    6 ++++++
 drivers/kvm/paging_tmpl.h |   15 ++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-report-nx-faults-to-the-guest drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-report-nx-faults-to-the-guest
+++ a/drivers/kvm/mmu.c
@@ -143,6 +143,7 @@ static int dbg = 1;
 #define PFERR_PRESENT_MASK (1U << 0)
 #define PFERR_WRITE_MASK (1U << 1)
 #define PFERR_USER_MASK (1U << 2)
+#define PFERR_FETCH_MASK (1U << 4)
 
 #define PT64_ROOT_LEVEL 4
 #define PT32_ROOT_LEVEL 2
@@ -168,6 +169,11 @@ static int is_cpuid_PSE36(void)
 	return 1;
 }
 
+static int is_nx(struct kvm_vcpu *vcpu)
+{
+	return vcpu->shadow_efer & EFER_NX;
+}
+
 static int is_present_pte(unsigned long pte)
 {
 	return pte & PT_PRESENT_MASK;
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-report-nx-faults-to-the-guest drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-report-nx-faults-to-the-guest
+++ a/drivers/kvm/paging_tmpl.h
@@ -71,7 +71,7 @@ struct guest_walker {
  */
 static int FNAME(walk_addr)(struct guest_walker *walker,
 			    struct kvm_vcpu *vcpu, gva_t addr,
-			    int write_fault, int user_fault)
+			    int write_fault, int user_fault, int fetch_fault)
 {
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
@@ -123,6 +123,11 @@ static int FNAME(walk_addr)(struct guest
 		if (user_fault && !(*ptep & PT_USER_MASK))
 			goto access_error;
 
+#if PTTYPE == 64
+		if (fetch_fault && is_nx(vcpu) && (*ptep & PT64_NX_MASK))
+			goto access_error;
+#endif
+
 		if (!(*ptep & PT_ACCESSED_MASK))
 			*ptep |= PT_ACCESSED_MASK; 	/* avoid rmw */
 
@@ -169,6 +174,8 @@ err:
 		walker->error_code |= PFERR_WRITE_MASK;
 	if (user_fault)
 		walker->error_code |= PFERR_USER_MASK;
+	if (fetch_fault)
+		walker->error_code |= PFERR_FETCH_MASK;
 	return 0;
 }
 
@@ -372,6 +379,7 @@ static int FNAME(page_fault)(struct kvm_
 {
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
+	int fetch_fault = error_code & PFERR_FETCH_MASK;
 	struct guest_walker walker;
 	u64 *shadow_pte;
 	int fixed;
@@ -388,7 +396,8 @@ static int FNAME(page_fault)(struct kvm_
 	/*
 	 * Look up the shadow pte for the faulting address.
 	 */
-	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault);
+	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault,
+			     fetch_fault);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
@@ -437,7 +446,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kv
 	pt_element_t guest_pte;
 	gpa_t gpa;
 
-	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0);
+	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
 	guest_pte = *walker.ptep;
 	FNAME(release_walker)(&walker);
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
