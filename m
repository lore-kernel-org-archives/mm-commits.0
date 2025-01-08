Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9117A1A238C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317587; cv=none; b=MD6LqVC2TxSOt+TrBkiwm4h+iqpC3J54go8cp3E8CLfLGM5+C5P0jO71iXTkbsVfxPQl+CawUjlzZ5j2i44CGAD0f+LwmKZ/090BrhesT3AXPGPEHtmYlex5D/PevR7Buq8TC96B65jPg4bhGaObIlEFP0ge5V5jSyPRgVL11oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317587; c=relaxed/simple;
	bh=ix1oq+En5T5kVRPnLtdGamy7ZIIVLXrOT1o2Hhu0x8c=;
	h=Date:To:From:Subject:Message-Id; b=BB4B3h2IZyWkCRsbNxGQCT4+dqhPOFbFLpTSpzLVTBkAqpas0REyG2Lynhw7tbHgOicTKhoK59wT3xdDVTCC+8YB9m9Z4ojm7jrY5hEZq5uxEP3CxOn5FM/SxgOUH1A4797lDElRljisdeZpPqpaKdmdcLv0I6i/BNTLSoEyQyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B6Xv8nk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B6Xv8nk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACC9C4CED0;
	Wed,  8 Jan 2025 06:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317586;
	bh=ix1oq+En5T5kVRPnLtdGamy7ZIIVLXrOT1o2Hhu0x8c=;
	h=Date:To:From:Subject:From;
	b=B6Xv8nk35Cs/kGlAKtyWFiIH86Ej8yvjBb5fB8U89lEclVfXboEJEVd6DOsTY7RB3
	 3SQNoIcBruNq1jH+0HNUJLXb4Gc2Etmat45mGhycThXq+zTL437EbFs84sUfdnDkwJ
	 IH45mhMqRziwjupCBVndL1Sq805GkdpDeNmIjfZU=
Date: Tue, 07 Jan 2025 22:26:25 -0800
To: mm-commits@vger.kernel.org,dan.j.williams@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch added to mm-unstable branch
Message-Id: <20250108062626.3ACC9C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
Date: Tue, 7 Jan 2025 14:42:18 +1100

dax_layout_busy_page_range() is used by file systems to scan the DAX
page-cache to unmap mapping pages from user-space and to determine if any
pages in the given range are busy, either due to ongoing DMA or other
get_user_pages() usage.

Currently it checks to see the file mapping is mapped into user-space with
mapping_mapped() and returns early if not, skipping the check for DMA busy
pages.  This is wrong as pages may still be undergoing DMA access even if
they have subsequently been unmapped from user-space.  Fix this by
dropping the check for mapping_mapped().

Link: https://lkml.kernel.org/r/db02794f12a4cc8c659a1123bdc90fcb4dcb1104.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c~fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range
+++ a/fs/dax.c
@@ -690,7 +690,7 @@ struct page *dax_layout_busy_page_range(
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return NULL;
 
-	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
+	if (!dax_mapping(mapping))
 		return NULL;
 
 	/* If end == LLONG_MAX, all pages from start to till end of file */
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

