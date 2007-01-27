From: akpm@osdl.org
Subject: - kvm-mmu-perform-access-checks-in-walk_addr.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:02 -0800
Message-ID: <200701270131.l0R1V2CZ031807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbXA0BbL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Perform access checks in walk_addr()
has been removed from the -mm tree.  Its filename was
     kvm-mmu-perform-access-checks-in-walk_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Perform access checks in walk_addr()
From: Avi Kivity <avi@qumranet.com>

Check pte permission bits in walk_addr(), instead of scattering the checks all
over the code.  This has the following benefits:

1. We no longer set the accessed bit for accessed which fail permission checks.
2. Setting the accessed bit is simplified.
3. Under some circumstances, we used to pretend a page fault was fixed when
   it would actually fail the access checks.  This caused an unnecessary
   vmexit.
4. The error code for guest page faults is now correct.

The fix helps netbsd further along booting, and allows kvm to pass the new mmu
testsuite.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c         |   10 -----
 drivers/kvm/paging_tmpl.h |   68 ++++++++++++++++++++----------------
 2 files changed, 38 insertions(+), 40 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-perform-access-checks-in-walk_addr drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-perform-access-checks-in-walk_addr
+++ a/drivers/kvm/mmu.c
@@ -992,16 +992,6 @@ static inline int fix_read_pf(u64 *shado
 	return 0;
 }
 
-static int may_access(u64 pte, int write, int user)
-{
-
-	if (user && !(pte & PT_USER_MASK))
-		return 0;
-	if (write && !(pte & PT_WRITABLE_MASK))
-		return 0;
-	return 1;
-}
-
 static void paging_free(struct kvm_vcpu *vcpu)
 {
 	nonpaging_free(vcpu);
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-perform-access-checks-in-walk_addr drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-perform-access-checks-in-walk_addr
+++ a/drivers/kvm/paging_tmpl.h
@@ -63,13 +63,15 @@ struct guest_walker {
 	pt_element_t *ptep;
 	pt_element_t inherited_ar;
 	gfn_t gfn;
+	u32 error_code;
 };
 
 /*
  * Fetch a guest pte for a guest virtual address
  */
-static void FNAME(walk_addr)(struct guest_walker *walker,
-			     struct kvm_vcpu *vcpu, gva_t addr)
+static int FNAME(walk_addr)(struct guest_walker *walker,
+			    struct kvm_vcpu *vcpu, gva_t addr,
+			    int write_fault, int user_fault)
 {
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
@@ -86,7 +88,7 @@ static void FNAME(walk_addr)(struct gues
 		walker->ptep = &vcpu->pdptrs[(addr >> 30) & 3];
 		root = *walker->ptep;
 		if (!(root & PT_PRESENT_MASK))
-			return;
+			goto not_present;
 		--walker->level;
 	}
 #endif
@@ -111,11 +113,18 @@ static void FNAME(walk_addr)(struct gues
 		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
 		       ((unsigned long)ptep & PAGE_MASK));
 
-		if (is_present_pte(*ptep) && !(*ptep &  PT_ACCESSED_MASK))
-			*ptep |= PT_ACCESSED_MASK;
-
 		if (!is_present_pte(*ptep))
-			break;
+			goto not_present;
+
+		if (write_fault && !is_writeble_pte(*ptep))
+			if (user_fault || is_write_protection(vcpu))
+				goto access_error;
+
+		if (user_fault && !(*ptep & PT_USER_MASK))
+			goto access_error;
+
+		if (!(*ptep & PT_ACCESSED_MASK))
+			*ptep |= PT_ACCESSED_MASK; 	/* avoid rmw */
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
@@ -146,6 +155,21 @@ static void FNAME(walk_addr)(struct gues
 	}
 	walker->ptep = ptep;
 	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)*ptep);
+	return 1;
+
+not_present:
+	walker->error_code = 0;
+	goto err;
+
+access_error:
+	walker->error_code = PFERR_PRESENT_MASK;
+
+err:
+	if (write_fault)
+		walker->error_code |= PFERR_WRITE_MASK;
+	if (user_fault)
+		walker->error_code |= PFERR_USER_MASK;
+	return 0;
 }
 
 static void FNAME(release_walker)(struct guest_walker *walker)
@@ -347,7 +371,6 @@ static int FNAME(page_fault)(struct kvm_
 			       u32 error_code)
 {
 	int write_fault = error_code & PFERR_WRITE_MASK;
-	int pte_present = error_code & PFERR_PRESENT_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
 	u64 *shadow_pte;
@@ -365,19 +388,19 @@ static int FNAME(page_fault)(struct kvm_
 	/*
 	 * Look up the shadow pte for the faulting address.
 	 */
-	FNAME(walk_addr)(&walker, vcpu, addr);
-	shadow_pte = FNAME(fetch)(vcpu, addr, &walker);
+	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
 	 */
-	if (!shadow_pte) {
-		pgprintk("%s: not mapped\n", __FUNCTION__);
-		inject_page_fault(vcpu, addr, error_code);
+	if (!r) {
+		pgprintk("%s: guest page fault\n", __FUNCTION__);
+		inject_page_fault(vcpu, addr, walker.error_code);
 		FNAME(release_walker)(&walker);
 		return 0;
 	}
 
+	shadow_pte = FNAME(fetch)(vcpu, addr, &walker);
 	pgprintk("%s: shadow pte %p %llx\n", __FUNCTION__,
 		 shadow_pte, *shadow_pte);
 
@@ -399,22 +422,7 @@ static int FNAME(page_fault)(struct kvm_
 	 * mmio: emulate if accessible, otherwise its a guest fault.
 	 */
 	if (is_io_pte(*shadow_pte)) {
-		if (may_access(*shadow_pte, write_fault, user_fault))
-			return 1;
-		pgprintk("%s: io work, no access\n", __FUNCTION__);
-		inject_page_fault(vcpu, addr,
-				  error_code | PFERR_PRESENT_MASK);
-		kvm_mmu_audit(vcpu, "post page fault (io)");
-		return 0;
-	}
-
-	/*
-	 * pte not present, guest page fault.
-	 */
-	if (pte_present && !fixed && !write_pt) {
-		inject_page_fault(vcpu, addr, error_code);
-		kvm_mmu_audit(vcpu, "post page fault (guest)");
-		return 0;
+		return 1;
 	}
 
 	++kvm_stat.pf_fixed;
@@ -429,7 +437,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kv
 	pt_element_t guest_pte;
 	gpa_t gpa;
 
-	FNAME(walk_addr)(&walker, vcpu, vaddr);
+	FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0);
 	guest_pte = *walker.ptep;
 	FNAME(release_walker)(&walker);
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
