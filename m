From: akpm@linux-foundation.org
Subject: - kvm-fix-gva_to_gpa.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:43 -0800
Message-ID: <200702122248.l1CMmhlc014045@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45562 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030359AbXBLWsv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:48:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: Fix gva_to_gpa()
has been removed from the -mm tree.  Its filename was
     kvm-fix-gva_to_gpa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: Fix gva_to_gpa()
From: Avi Kivity <avi@qumranet.com>

gva_to_gpa() needs to be updated to the new walk_addr() calling convention,
otherwise it may oops under some circumstances.

Use the opportunity to remove all the code duplication in gva_to_gpa(), which
essentially repeats the calculations in walk_addr().

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/paging_tmpl.h |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

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
