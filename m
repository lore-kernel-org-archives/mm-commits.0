Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1784C8F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 00:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750118479; cv=none; b=beOwCQDX2OCdo01dgwrUjs+aB//ssKSKQvgTPwli4VlGJBfaeMroyoghZz/S7Qt6Al1QG/v/Sxg0sI2Ffrk9o5m/tNawyy5/MQ1Tj3447PaB5fDG7Z5veGs151AdaTqqif4qcjZTNnSmzToYqOxjNU7SMaRuIA4FL2sMB8YLLHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750118479; c=relaxed/simple;
	bh=pnFeFeKAPFsYV53Ec90yfzMCjVygYCQP1XK2UsgrLIQ=;
	h=Date:To:From:Subject:Message-Id; b=mdVh018ZVHmjM8fjC5QIg3/MsUzqhcXqwnAgTiUl3xiWmUdO2Kq1SJBCaF8MCyu+Nwabg2B0H7f+C3zKgSk7Mivb2VyborToy5WaZRFwyxn+gr5WmDD7FUOQhEvg7mWXgUjwLtgYjtktYAhAwVBSFewVAnEgDALYBcVbelt5B7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrVoqLnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrVoqLnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4760C4CEEA;
	Tue, 17 Jun 2025 00:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750118477;
	bh=pnFeFeKAPFsYV53Ec90yfzMCjVygYCQP1XK2UsgrLIQ=;
	h=Date:To:From:Subject:From;
	b=lrVoqLnKXU1prjfbYhbJGNkRMAbe+NcGah75UkzyVmJXjkWLy2zvs59QaR8R/wiEP
	 JDrmeVwd+rwJ72/847QLAB/9Ks7YAYEphDrxO61VIAg+Scl8rByGB6ZdBSSRMsDm1r
	 abUQKvXqJBja6OawgEnPF3ZZYI/zocH8leH+CcPo=
Date: Mon, 16 Jun 2025 17:01:17 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-remove-fs_dax_limited-config-option.patch added to mm-new branch
Message-Id: <20250617000117.A4760C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: remove FS_DAX_LIMITED config option
has been added to the -mm mm-new branch.  Its filename is
     fs-dax-remove-fs_dax_limited-config-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-remove-fs_dax_limited-config-option.patch

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
Subject: fs/dax: remove FS_DAX_LIMITED config option
Date: Mon, 16 Jun 2025 21:58:12 +1000

The dcssblk driver was the last user of FS_DAX_LIMITED.  That was marked
broken by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
support") to allow removal of PFN_SPECIAL.  However the FS_DAX_LIMITED
config option itself was not removed, so do that now.

Link: https://lkml.kernel.org/r/bbade6a3154d14d958f5f9cf65fd6424897ec9c2.1750075065.git-series.apopple@nvidia.com
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

 fs/Kconfig    |    9 +--------
 fs/dax.c      |   12 ------------
 mm/memremap.c |    4 ----
 3 files changed, 1 insertion(+), 24 deletions(-)

--- a/fs/dax.c~fs-dax-remove-fs_dax_limited-config-option
+++ a/fs/dax.c
@@ -449,9 +449,6 @@ static void dax_associate_entry(void *en
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
-
 	index = linear_page_index(vma, address & ~(size - 1));
 	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
 		if (folio->mapping)
@@ -474,9 +471,6 @@ static void dax_disassociate_entry(void
 {
 	struct folio *folio = dax_to_folio(entry);
 
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
-
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
@@ -768,12 +762,6 @@ struct page *dax_layout_busy_page_range(
 	pgoff_t end_idx;
 	XA_STATE(xas, &mapping->i_pages, start_idx);
 
-	/*
-	 * In the 'limited' case get_user_pages() for dax is disabled.
-	 */
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return NULL;
-
 	if (!dax_mapping(mapping))
 		return NULL;
 
--- a/fs/Kconfig~fs-dax-remove-fs_dax_limited-config-option
+++ a/fs/Kconfig
@@ -59,7 +59,7 @@ endif # BLOCK
 config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
-	depends on ZONE_DEVICE || FS_DAX_LIMITED
+	depends on ZONE_DEVICE
 	select FS_IOMAP
 	select DAX
 	help
@@ -95,13 +95,6 @@ config FS_DAX_PMD
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
 
-# Selected by DAX drivers that do not expect filesystem DAX to support
-# get_user_pages() of DAX mappings. I.e. "limited" indicates no support
-# for fork() of processes with MAP_SHARED mappings or support for
-# direct-I/O to a DAX mapping.
-config FS_DAX_LIMITED
-	bool
-
 # Posix ACL utility routines
 #
 # Note: Posix ACLs can be implemented without these helpers.  Never use
--- a/mm/memremap.c~fs-dax-remove-fs_dax_limited-config-option
+++ a/mm/memremap.c
@@ -332,10 +332,6 @@ void *memremap_pages(struct dev_pagemap
 		}
 		break;
 	case MEMORY_DEVICE_FS_DAX:
-		if (IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
-			WARN(1, "File system DAX not supported\n");
-			return ERR_PTR(-EINVAL);
-		}
 		params.pgprot = pgprot_decrypted(params.pgprot);
 		break;
 	case MEMORY_DEVICE_GENERIC:
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

