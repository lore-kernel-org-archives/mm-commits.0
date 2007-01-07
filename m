From: akpm@osdl.org
Subject: - kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:59:54 -0800
Message-ID: <200701070759.l077xsAc013104@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbXAGH76 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Treat user-mode faults as a hint that a page is no longer a page table
has been removed from the -mm tree.  Its filename was
     kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Treat user-mode faults as a hint that a page is no longer a page table
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/paging_tmpl.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table
+++ a/drivers/kvm/paging_tmpl.h
@@ -271,6 +271,7 @@ static int FNAME(fix_write_pf)(struct kv
 	pt_element_t *guest_ent;
 	int writable_shadow;
 	gfn_t gfn;
+	struct kvm_mmu_page *page;
 
 	if (is_writeble_pte(*shadow_ent))
 		return 0;
@@ -303,7 +304,17 @@ static int FNAME(fix_write_pf)(struct kv
 	}
 
 	gfn = walker->gfn;
-	if (kvm_mmu_lookup_page(vcpu, gfn)) {
+
+	if (user) {
+		/*
+		 * Usermode page faults won't be for page table updates.
+		 */
+		while ((page = kvm_mmu_lookup_page(vcpu, gfn)) != NULL) {
+			pgprintk("%s: zap %lx %x\n",
+				 __FUNCTION__, gfn, page->role.word);
+			kvm_mmu_zap_page(vcpu, page);
+		}
+	} else if (kvm_mmu_lookup_page(vcpu, gfn)) {
 		pgprintk("%s: found shadow page for %lx, marking ro\n",
 			 __FUNCTION__, gfn);
 		*write_pt = 1;
_

Patches currently in -mm which might be from avi@qumranet.com are
