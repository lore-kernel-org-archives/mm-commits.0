Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972BADDAD
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374191; cv=none; b=AbdDuEGDrO+3yZuxzju6RXfn19Q/7tH15Cetp5t27qhTGI+Nz+htrWjwJn/Cd3GyWeGkC2TTVEX3L4sYFmnlElr7n1XIxG7FCWNhWn8iq+FL01r3BnAbe43VqSFztwfwA0kjNz14MCj+0w8ErC2wQkcAaZwHVI/XupJ8dxsV99Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374191; c=relaxed/simple;
	bh=cg5Yfb/LQ1I/SL3OzXukBcsIsnLk9nEApjYesq/kq/A=;
	h=Date:To:From:Subject:Message-Id; b=s7BqIjN6wXoZ+tGO5dAC6vaSH91/k2Ics7IdBOfyCQR5+iV6yG8+bdlQJN7PsaKw8YyfDQyStB5IOtlI9XC1UWp2kZXoOuN39fkWFlB3xhZ088EfH5admgvlXPVqYypqhuRCV2MvcS3Ao8RlHM38pUJLGv8MSBeaKNw3eQh/cjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m+9pa8Yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m+9pa8Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BAAC4CEEA;
	Thu, 19 Jun 2025 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374191;
	bh=cg5Yfb/LQ1I/SL3OzXukBcsIsnLk9nEApjYesq/kq/A=;
	h=Date:To:From:Subject:From;
	b=m+9pa8YigYkx1Xa5Db5kovTBquyelNAtz1BlcFq4SgM/7PqXrPn2YgZrdklJiODjh
	 AofuubKqbJ1/s8VZeJJIJ5S0IPBnJVONlhBSVvzs/SLPPUkxFF+eC31fxnUF+V6r/X
	 T6m+1kMewi0TqihJNIRRUcVPR75+rYnQgCscUq+Y=
Date: Thu, 19 Jun 2025 16:03:10 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-remove-unused-devmap_managed_key.patch added to mm-new branch
Message-Id: <20250619230311.61BAAC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memremap: remove unused devmap_managed_key
has been added to the -mm mm-new branch.  Its filename is
     mm-memremap-remove-unused-devmap_managed_key.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-remove-unused-devmap_managed_key.patch

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
Subject: mm/memremap: remove unused devmap_managed_key
Date: Thu, 19 Jun 2025 18:58:06 +1000

It's no longer used so remove it.

Link: https://lkml.kernel.org/r/11516e39f33f809292ffccab1d46062f9bc248b3.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

 mm/memremap.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/memremap.c~mm-memremap-remove-unused-devmap_managed_key
+++ a/mm/memremap.c
@@ -38,30 +38,6 @@ unsigned long memremap_compat_align(void
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
 
-#ifdef CONFIG_FS_DAX
-DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
-EXPORT_SYMBOL(devmap_managed_key);
-
-static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
-		static_branch_dec(&devmap_managed_key);
-}
-
-static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
-		static_branch_inc(&devmap_managed_key);
-}
-#else
-static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-}
-static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
-{
-}
-#endif /* CONFIG_FS_DAX */
-
 static void pgmap_array_delete(struct range *range)
 {
 	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end),
@@ -150,7 +126,6 @@ void memunmap_pages(struct dev_pagemap *
 	percpu_ref_exit(&pgmap->ref);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
-	devmap_managed_enable_put(pgmap);
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
 
@@ -349,8 +324,6 @@ void *memremap_pages(struct dev_pagemap
 	if (error)
 		return ERR_PTR(error);
 
-	devmap_managed_enable_get(pgmap);
-
 	/*
 	 * Clear the pgmap nr_range as it will be incremented for each
 	 * successfully processed range. This communicates how many
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

