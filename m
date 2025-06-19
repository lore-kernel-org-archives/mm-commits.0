Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5DC2045B1
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374150; cv=none; b=FK2kQ8qCkBv50w4MbobQH6YgSI1I8B3ELMOVMA73K9osljxS4YIzb8uaFnJF47KKlXsWKIXQeZY0JBGV9hm/wgNQPMl3jpAi56+J36QaFgaz6nGU8k0Guudg9Jur+Ne8iF7incA0zS8HU5sbNl7No073pRX3WymM/lX2fqnYhyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374150; c=relaxed/simple;
	bh=mhdeJUNziDU3FPCmTVtUUifVVpeXAPitVHdAGzSUlvk=;
	h=Date:To:From:Subject:Message-Id; b=eU9/QFKgd1Y4AeK8MlAC8BwWgaGfGibIVi13QKH6eK2qE/HFss/4f7/Tf0m+XWs2mTsJabTK1BWbgkbM6RLlBMs/x6rG0WsiRk2zw38svdX3w0xheAJ+//YXmGtntD7/R9u+8yERneKL+P7U7+ti2ZebtDKpl6AiGAougw2BVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RL1Ki9ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RL1Ki9ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30117C4CEEA;
	Thu, 19 Jun 2025 23:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374149;
	bh=mhdeJUNziDU3FPCmTVtUUifVVpeXAPitVHdAGzSUlvk=;
	h=Date:To:From:Subject:From;
	b=RL1Ki9ngRIZra/yXK17He3SC3orjZ1VatgpggWwU+i9Z8dMSxdpcrPoO8leaxO/qz
	 znZpPrC3Q/H1+dq32Y2uN/B+1CCqa4fiDkHqGoBvdnrMmyeW/Ml4p42njJq+FeSMis
	 IXM+1BnM6p8CAMer8d+3dTrXcLmGCN3DxMzdN8Os=
Date: Thu, 19 Jun 2025 16:02:28 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-redundant-pmd_devmap-check.patch added to mm-new branch
Message-Id: <20250619230229.30117C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove redundant pmd_devmap() check
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-redundant-pmd_devmap-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-redundant-pmd_devmap-check.patch

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
Subject: mm/khugepaged: remove redundant pmd_devmap() check
Date: Thu, 19 Jun 2025 18:58:00 +1000

The pmd_devmap() check in check_pmd_state() is redundant because the only
user of pmd_devmap were device dax and fs dax.  However all callers of
check_pmd_state() first call thp_vma_allowable_order() to check if the vma
should be scanned.  Except when called from a page fault this always
returns 0 for dax vma's, hence we would never expect to see a pmd_devmap
entry.

Link: https://lkml.kernel.org/r/a68175fd3a37e9b72cc82c1d63fd8b69691a85b5.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-pmd_devmap-check
+++ a/mm/khugepaged.c
@@ -945,8 +945,6 @@ static inline int check_pmd_state(pmd_t
 		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
-	if (pmd_devmap(pmde))
-		return SCAN_PMD_NULL;
 	if (pmd_bad(pmde))
 		return SCAN_PMD_NULL;
 	return SCAN_SUCCEED;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-convert-pxd_devmap-checks-to-vma_is_dax.patch
mm-filter-zone-device-pages-returned-from-folio_walk_start.patch
mm-remove-remaining-uses-of-pfn_dev.patch
mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special.patch
mm-gup-remove-pxx_devmap-usage-from-get_user_pages.patch
mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch
mm-remove-redundant-pxd_devmap-calls.patch
mm-khugepaged-remove-redundant-pmd_devmap-check.patch
powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch
fs-dax-remove-fs_dax_limited-config-option.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
mm-remove-pfn_dev-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch
mm-remove-callers-of-pfn_t-functionality.patch
mm-memremap-remove-unused-devmap_managed_key.patch

