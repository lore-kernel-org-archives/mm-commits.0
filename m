Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2CA28642C
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126349; cv=none; b=R/GQyE/ttMKo58zPmfkw6gXXPWUjkyb5ccfJ+kCB0pX4pt2XwAFMUmgNXqcpoWSFSJJcdCC2UKZYoQLsFETF+v+b7paqe9msfDxFsQU8q4JJpBbL4/zMXJ5WBVsl+l3PfeWcihMe7Asdn2eylW4aMxmdw4AKsUffK+6/sZgpFWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126349; c=relaxed/simple;
	bh=UpMl/NhNGUA/Z1qP1C0B+TiJ/JAy/TMOtF6F3Lg6c5w=;
	h=Date:To:From:Subject:Message-Id; b=PDu1IpQXeQ6rYGL3gFLf90bIdae4LGemVUeZGVW0IKYg5339iQbL9bRiuXgH/7PhweOwmtuMSBESTV0IZGGGdi8RafPyEfJUfIh8Fds9W4SSRdgxsqmlzmywdIKFsHGHFQid4z4Cyag44z2w12AP+w/KNT3stCX3AKwLD5eIrKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SaXPEtPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SaXPEtPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3CEC4CEE3;
	Thu, 10 Jul 2025 05:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126349;
	bh=UpMl/NhNGUA/Z1qP1C0B+TiJ/JAy/TMOtF6F3Lg6c5w=;
	h=Date:To:From:Subject:From;
	b=SaXPEtPSH5AVkWJJ7lGZtM6A3Nxxj05HzwtfGamtnihIQ+Ac+wxwFu3n6uFmQ5HXn
	 HynZskYXpNMLOdFpWLhGeLbcPznwNRhB1cV5KpDv4QO5MXXPJhW2M2PU2f0r81cCoC
	 Xq5TGcNRurxe+36/ABBIKsV/etn3YGAuxk4124bg=
Date: Wed, 09 Jul 2025 22:45:49 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-remove-fs_dax_limited-config-option.patch removed from -mm tree
Message-Id: <20250710054549.8F3CEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: remove FS_DAX_LIMITED config option
has been removed from the -mm tree.  Its filename was
     fs-dax-remove-fs_dax_limited-config-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: remove FS_DAX_LIMITED config option
Date: Thu, 19 Jun 2025 18:58:02 +1000

The dcssblk driver was the last user of FS_DAX_LIMITED.  That was marked
broken by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
support") to allow removal of PFN_SPECIAL.  However the FS_DAX_LIMITED
config option itself was not removed, so do that now.

Link: https://lkml.kernel.org/r/b47bf164b4a1013d736fa1a3d501bc8b8e71311f.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
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


