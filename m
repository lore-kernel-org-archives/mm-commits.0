From: akpm@linux-foundation.org
Subject: + xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:55 -0800
Message-ID: <201101280017.p0S0Htc9008249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab1A1AVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:21:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     xen/mmu: use apply_to_page_range_batch() in xen_remap_domain_mfn_range()
has been added to the -mm tree.  Its filename is
     xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2292,14 +2292,19 @@ struct remap_data {
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
@@ -2328,8 +2333,8 @@ int xen_remap_domain_mfn_range(struct vm
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
mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch
mm-add-apply_to_page_range_batch.patch
ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch
vmalloc-use-plain-pte_clear-for-unmaps.patch
vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch
vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch
vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch

