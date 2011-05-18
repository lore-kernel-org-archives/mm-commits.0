From: akpm@linux-foundation.org
Subject: [to-be-updated] xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch removed from -mm tree
Date: Wed, 18 May 2011 14:37:50 -0700
Message-ID: <201105182137.p4ILbopW025471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1ERVhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     xen/mmu: use apply_to_page_range_batch() in xen_remap_domain_mfn_range()
has been removed from the -mm tree.  Its filename was
     xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen/mmu: use apply_to_page_range_batch() in xen_remap_domain_mfn_range()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/x86/xen/mmu.c~xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range
+++ a/arch/x86/xen/mmu.c
@@ -2365,14 +2365,19 @@ struct remap_data {
 	struct mmu_update *mmu_update;
 };
 
-static int remap_area_mfn_pte_fn(pte_t *ptep, unsigned long addr, void *data)
+static int remap_area_mfn_pte_fn(pte_t *ptep, unsigned count,
+				 unsigned long addr, void *data)
 {
 	struct remap_data *rmd = data;
-	pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
 
-	rmd->mmu_update->ptr = arbitrary_virt_to_machine(ptep).maddr;
-	rmd->mmu_update->val = pte_val_ma(pte);
-	rmd->mmu_update++;
+	while (count--) {
+		pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
+
+		rmd->mmu_update->ptr = arbitrary_virt_to_machine(ptep).maddr;
+		rmd->mmu_update->val = pte_val_ma(pte);
+		rmd->mmu_update++;
+		ptep++;
+	}
 
 	return 0;
 }
@@ -2401,8 +2406,8 @@ int xen_remap_domain_mfn_range(struct vm
 		range = (unsigned long)batch << PAGE_SHIFT;
 
 		rmd.mmu_update = mmu_update;
-		err = apply_to_page_range(vma->vm_mm, addr, range,
-					  remap_area_mfn_pte_fn, &rmd);
+		err = apply_to_page_range_batch(vma->vm_mm, addr, range,
+						remap_area_mfn_pte_fn, &rmd);
 		if (err)
 			goto out;
 
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

linux-next.patch
xen-grant-table-use-apply_to_page_range_batch.patch

