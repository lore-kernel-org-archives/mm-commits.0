Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEC71367
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 00:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750118446; cv=none; b=UG7OjBnRHOiIpuPxN+lZLr2oauy+j1hXimWTzZS4vJM0ntoAE8wTUlFXrqyQ42mq4jMRwHOIvx2lfSX1Gwz5K34yB40nepBq6vY0jpCF+EOaTHct8/ulbCbAuMaA+YNhiaELh4B7SWamL+uiPeqEDFz9VvOuVeI1x8WsKcLnZ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750118446; c=relaxed/simple;
	bh=N6jkSE5sm5u85HJi/4ZTZA6YUZD9ntpTSROewEbeRI4=;
	h=Date:To:From:Subject:Message-Id; b=CDgRdKffCFgt2y6vv6y9DltXdSDZcLSNw3a4gljEWAKZvvFuRhovg0BYypdMLgqCIScovxS41WetGxtToeYV5alpY7QmUWZVXwT1dFy3MPcnX7nhZVApdGoddL/krOV5yq7x26cLzO7oCU4GVUSnCNRjPU5j3pQSthNTVZsjWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JHF+DoH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JHF+DoH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD113C4CEEF;
	Tue, 17 Jun 2025 00:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750118445;
	bh=N6jkSE5sm5u85HJi/4ZTZA6YUZD9ntpTSROewEbeRI4=;
	h=Date:To:From:Subject:From;
	b=JHF+DoH3APH2NYfXliYPDBOiDGWq9qTyxhdOrO/shRiaXY8V1w93RUoz6x6E2V4q2
	 dumUnBFQj2KeyYDe7TpMZmZcmLkA61eUriqyQHV5TfnAVCz+JOaVtmXIUaTk3L05WK
	 ukAqCILnftNg+eOLrd+6UlEoctrQh5HRn/QfmiAw=
Date: Mon, 16 Jun 2025 17:00:45 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-pxd_devmap-checks-to-vma_is_dax.patch added to mm-new branch
Message-Id: <20250617000045.CD113C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert pXd_devmap checks to vma_is_dax
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-pxd_devmap-checks-to-vma_is_dax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-pxd_devmap-checks-to-vma_is_dax.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: convert pXd_devmap checks to vma_is_dax
Date: Mon, 16 Jun 2025 21:58:03 +1000

All users of dax now require a ZONE_DEVICE page which is properly
refcounted.  This means there is no longer any need for the PFN_DEV,
PFN_MAP and PFN_SPECIAL flags.  Furthermore the PFN_SG_CHAIN and
PFN_SG_LAST flags never appear to have been used.  It is therefore
possible to remove the pfn_t type and replace any usage with raw pfns.

The remaining users of PFN_DEV have simply passed this to
vmf_insert_mixed() to create pte_devmap() mappings.  It is unclear why
this was the case but presumably to ensure vm_normal_page() does not
return these pages.  These users can be trivially converted to raw pfns
and creating a pXX_special() mapping to ensure vm_normal_page() still
doesn't return these pages.

Now that there are no users of PFN_DEV we can remove the devmap page table
bit and all associated functions and macros, freeing up a software page
table bit.


This patch (of 14):

Currently dax is the only user of pmd and pud mapped ZONE_DEVICE pages. 
Therefore page walkers that want to exclude DAX pages can check pmd_devmap
or pud_devmap.  However soon dax will no longer set PFN_DEV, meaning dax
pages are mapped as normal pages.

Ensure page walkers that currently use pXd_devmap to skip DAX pages
continue to do so by adding explicit checks of the VMA instead.

Link: https://lkml.kernel.org/r/361009510f346090fad328c53ec228d99bb955ee.1750075065.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 mm/hmm.c         |    2 +-
 mm/userfaultfd.c |    6 ------
 3 files changed, 2 insertions(+), 8 deletions(-)

--- a/fs/userfaultfd.c~mm-convert-pxd_devmap-checks-to-vma_is_dax
+++ a/fs/userfaultfd.c
@@ -304,7 +304,7 @@ again:
 		goto out;
 
 	ret = false;
-	if (!pmd_present(_pmd) || pmd_devmap(_pmd))
+	if (!pmd_present(_pmd) || vma_is_dax(vmf->vma))
 		goto out;
 
 	if (pmd_trans_huge(_pmd)) {
--- a/mm/hmm.c~mm-convert-pxd_devmap-checks-to-vma_is_dax
+++ a/mm/hmm.c
@@ -441,7 +441,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 		return hmm_vma_walk_hole(start, end, -1, walk);
 	}
 
-	if (pud_leaf(pud) && pud_devmap(pud)) {
+	if (pud_leaf(pud) && vma_is_dax(walk->vma)) {
 		unsigned long i, npages, pfn;
 		unsigned int required_fault;
 		unsigned long *hmm_pfns;
--- a/mm/userfaultfd.c~mm-convert-pxd_devmap-checks-to-vma_is_dax
+++ a/mm/userfaultfd.c
@@ -1818,12 +1818,6 @@ ssize_t move_pages(struct userfaultfd_ct
 
 		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
 		if (ptl) {
-			if (pmd_devmap(*src_pmd)) {
-				spin_unlock(ptl);
-				err = -ENOENT;
-				break;
-			}
-
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-convert-pxd_devmap-checks-to-vma_is_dax.patch
mm-filter-zone-device-pages-returned-from-folio_walk_start.patch
mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special.patch
mm-remove-remaining-uses-of-pfn_dev.patch
mm-gup-remove-pxx_devmap-usage-from-get_user_pages.patch
mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch
mm-remove-redundant-pxd_devmap-calls.patch
mm-khugepaged-remove-redundant-pmd_devmap-check.patch
powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch
fs-dax-remove-fs_dax_limited-config-option.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch
mm-remove-callers-of-pfn_t-functionality.patch
mm-memremap-remove-unused-devmap_managed_key.patch

