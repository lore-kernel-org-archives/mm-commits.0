Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229B4C8F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 00:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750118462; cv=none; b=rCpLjxofK59DldFckPyPBFheRV2/lY4X3esrS9KcT5W303/4m0nZIH+2Nojq1d4fZsQUDRn4/aNop04+vVHUuaUaFKuh1xsYxchXchYekC0yF5G7b0WabtneTVRvx4gpTinLdGtVsDKzX3NkMb0tNWpEI4Q1VeUrk3pu+eHr87A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750118462; c=relaxed/simple;
	bh=Ebc2gv/rwDYgqaPWBnJqPYI3xaRTf4eXLIzRFe3as1c=;
	h=Date:To:From:Subject:Message-Id; b=XPVcbvOujD6IH2eJszyHXDfBAUOhUwf0DrmAXKy7mk2O1LUFKYyXM6jtB7LdDkKPmiBgzE23EHo69DNr6REojoyYOHIKnjRKgIE+kwDRrXrhTS9rJTxivCTR9GCt+VUYMCStr8J2yY5EpG95zB3ZbyrLQZbcWSXFisXQBCT/U8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CI0XrOHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CI0XrOHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE24C4CEEA;
	Tue, 17 Jun 2025 00:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750118461;
	bh=Ebc2gv/rwDYgqaPWBnJqPYI3xaRTf4eXLIzRFe3as1c=;
	h=Date:To:From:Subject:From;
	b=CI0XrOHD+yNk7OhYx/Gl4wZ+fO/2dHz3ERyMO05/Sn0c1PSTgDBIiA1gG2SYlmAxT
	 cBWtvOme4yu7+TxKJNKpObIbUAz74cugGb7JVKY1ztAqWfhTJheqWWPsrOnHfA4h6+
	 8Nux7mxl5RDi/6hB2yxDu15XPQne/7OD7zFQc+lw=
Date: Mon, 16 Jun 2025 17:01:01 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch added to mm-new branch
Message-Id: <20250617000101.BBE24C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: remove pXd_devmap usage from insert_pXd_pfn()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch

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
Subject: mm/huge_memory: remove pXd_devmap usage from insert_pXd_pfn()
Date: Mon, 16 Jun 2025 21:58:08 +1000

Nothing uses PFN_DEV anymore so no need to create devmap pXd's when
mapping a PFN.  Instead special mappings will be created which ensures
vm_normal_page_pXd() will not return pages which don't have an associated
page.  This could change behaviour slightly on architectures where
pXd_devmap() does not imply pXd_special() as the normal page checks would
have fallen through to checking VM_PFNMAP/MIXEDMAP instead, which in
theory at least could have returned a page.

However vm_normal_page_pXd() should never have been returning pages for
pXd_devmap() entries anyway, so anything relying on that would have been a
bug.

Link: https://lkml.kernel.org/r/67bc382c49ed8b165cfbd927886372272c35f508.1750075065.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>

Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn
+++ a/mm/huge_memory.c
@@ -1415,11 +1415,7 @@ static int insert_pmd(struct vm_area_str
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
 	} else {
 		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
-
-		if (pfn_t_devmap(fop.pfn))
-			entry = pmd_mkdevmap(entry);
-		else
-			entry = pmd_mkspecial(entry);
+		entry = pmd_mkspecial(entry);
 	}
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
@@ -1565,11 +1561,7 @@ static void insert_pud(struct vm_area_st
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
 	} else {
 		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));
-
-		if (pfn_t_devmap(fop.pfn))
-			entry = pud_mkdevmap(entry);
-		else
-			entry = pud_mkspecial(entry);
+		entry = pud_mkspecial(entry);
 	}
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
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

