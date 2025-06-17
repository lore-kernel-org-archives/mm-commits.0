Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFD4C8F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 00:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750118454; cv=none; b=R8FUF4CIe1mGTwNay+HFvF3YeTYpiihsbAuQqI2sQRuuBNAGT4XYi0LvhYU/Aj+BArht2CFG6jPhvnS1KVFxIouCMtamtHEidJWGLY2YayK++EnFVlnhCX09e5YGM0/ydfUCmRcEZMHXimY68ptmNdcjA71N+mAXkSRiRjqNnpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750118454; c=relaxed/simple;
	bh=2h4JpRhkPziBfR5xGX/Fd83lF0HjulJESY76waspGvM=;
	h=Date:To:From:Subject:Message-Id; b=uVMfiNUlMZcUDtyI/nQGC+Vgab7lYIp5SJqMxXvRBBmjYFwiRvEZE9NrTRds4OpIR5ZpHjU1Vb9enspkc1nLMPDebKNH7eKl7IV6y2lCGB/Xxi0W9elosRcATUiopPlu1jResWZsBf9wT9Jew4TPK3E4/ANiJWELTzKIwBISO9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLFO6sll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLFO6sll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6994AC4CEEA;
	Tue, 17 Jun 2025 00:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750118454;
	bh=2h4JpRhkPziBfR5xGX/Fd83lF0HjulJESY76waspGvM=;
	h=Date:To:From:Subject:From;
	b=MLFO6sllF2AnyMLkwK3rzYBFUh+2pvuV2+0JXHQ52AHT/tsTvRbpFqI0gNK0uG3+S
	 +2qQCxvLVXANhGiA/3c6nzW+zWsK8Uamu3aJXb5g9bozYV5ZyLj87kciBwsbv4zduX
	 IJDg/7A/hJhQGtu+O0CX2lWDkcss53C0fA5G+KNs=
Date: Mon, 16 Jun 2025 17:00:53 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-remaining-uses-of-pfn_dev.patch added to mm-new branch
Message-Id: <20250617000054.6994AC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove remaining uses of PFN_DEV
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-remaining-uses-of-pfn_dev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-remaining-uses-of-pfn_dev.patch

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
Subject: mm: remove remaining uses of PFN_DEV
Date: Mon, 16 Jun 2025 21:58:06 +1000

PFN_DEV was used by callers of dax_direct_access() to figure out if the
returned PFN is associated with a page using pfn_t_has_page() or not. 
However all DAX PFNs now require an assoicated ZONE_DEVICE page so can
assume a page exists.

Other users of PFN_DEV were setting it before calling vmf_insert_mixed(). 
This is unnecessary as it is no longer checked, instead relying on
pfn_valid() to determine if there is an associated page or not.

Link: https://lkml.kernel.org/r/059a2e87240d7bb00016155ef5426c08977759e0.1750075065.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
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

 drivers/gpu/drm/gma500/fbdev.c     |    2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c |    5 ++---
 drivers/s390/block/dcssblk.c       |    3 +--
 drivers/vfio/pci/vfio_pci_core.c   |    6 ++----
 fs/cramfs/inode.c                  |    2 +-
 include/linux/pfn_t.h              |    7 ++-----
 mm/memory.c                        |    2 +-
 7 files changed, 10 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/gma500/fbdev.c~mm-remove-remaining-uses-of-pfn_dev
+++ a/drivers/gpu/drm/gma500/fbdev.c
@@ -33,7 +33,7 @@ static vm_fault_t psb_fbdev_vm_fault(str
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	for (i = 0; i < page_num; ++i) {
-		err = vmf_insert_mixed(vma, address, __pfn_to_pfn_t(pfn, PFN_DEV));
+		err = vmf_insert_mixed(vma, address, __pfn_to_pfn_t(pfn, 0));
 		if (unlikely(err & VM_FAULT_ERROR))
 			break;
 		address += PAGE_SIZE;
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~mm-remove-remaining-uses-of-pfn_dev
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -371,8 +371,7 @@ static vm_fault_t omap_gem_fault_1d(stru
 	VERB("Inserting %p pfn %lx, pa %lx", (void *)vmf->address,
 			pfn, pfn << PAGE_SHIFT);
 
-	return vmf_insert_mixed(vma, vmf->address,
-			__pfn_to_pfn_t(pfn, PFN_DEV));
+	return vmf_insert_mixed(vma, vmf->address, __pfn_to_pfn_t(pfn, 0));
 }
 
 /* Special handling for the case of faulting in 2d tiled buffers */
@@ -468,7 +467,7 @@ static vm_fault_t omap_gem_fault_2d(stru
 
 	for (i = n; i > 0; i--) {
 		ret = vmf_insert_mixed(vma,
-			vaddr, __pfn_to_pfn_t(pfn, PFN_DEV));
+			vaddr, __pfn_to_pfn_t(pfn, 0));
 		if (ret & VM_FAULT_ERROR)
 			break;
 		pfn += priv->usergart[fmt].stride_pfn;
--- a/drivers/s390/block/dcssblk.c~mm-remove-remaining-uses-of-pfn_dev
+++ a/drivers/s390/block/dcssblk.c
@@ -923,8 +923,7 @@ __dcssblk_direct_access(struct dcssblk_d
 	if (kaddr)
 		*kaddr = __va(dev_info->start + offset);
 	if (pfn)
-		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
-				      PFN_DEV);
+		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), 0);
 
 	return (dev_sz - offset) / PAGE_SIZE;
 }
--- a/drivers/vfio/pci/vfio_pci_core.c~mm-remove-remaining-uses-of-pfn_dev
+++ a/drivers/vfio/pci/vfio_pci_core.c
@@ -1669,14 +1669,12 @@ static vm_fault_t vfio_pci_mmap_huge_fau
 		break;
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	case PMD_ORDER:
-		ret = vmf_insert_pfn_pmd(vmf,
-					 __pfn_to_pfn_t(pfn, PFN_DEV), false);
+		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn, 0), false);
 		break;
 #endif
 #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
 	case PUD_ORDER:
-		ret = vmf_insert_pfn_pud(vmf,
-					 __pfn_to_pfn_t(pfn, PFN_DEV), false);
+		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn, 0), false);
 		break;
 #endif
 	default:
--- a/fs/cramfs/inode.c~mm-remove-remaining-uses-of-pfn_dev
+++ a/fs/cramfs/inode.c
@@ -412,7 +412,7 @@ static int cramfs_physmem_mmap(struct fi
 		for (i = 0; i < pages && !ret; i++) {
 			vm_fault_t vmf;
 			unsigned long off = i * PAGE_SIZE;
-			pfn_t pfn = phys_to_pfn_t(address + off, PFN_DEV);
+			pfn_t pfn = phys_to_pfn_t(address + off, 0);
 			vmf = vmf_insert_mixed(vma, vma->vm_start + off, pfn);
 			if (vmf & VM_FAULT_ERROR)
 				ret = vm_fault_to_errno(vmf, 0);
--- a/include/linux/pfn_t.h~mm-remove-remaining-uses-of-pfn_dev
+++ a/include/linux/pfn_t.h
@@ -7,7 +7,6 @@
  * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
  * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
  * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
- * PFN_DEV - pfn is not covered by system memmap by default
  * PFN_MAP - pfn has a dynamic page mapping established by a device driver
  * PFN_SPECIAL - for CONFIG_FS_DAX_LIMITED builds to allow XIP, but not
  *		 get_user_pages
@@ -15,7 +14,6 @@
 #define PFN_FLAGS_MASK (((u64) (~PAGE_MASK)) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
 #define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
 #define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
-#define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
 #define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
 #define PFN_SPECIAL (1ULL << (BITS_PER_LONG_LONG - 5))
 
@@ -23,7 +21,6 @@
 	{ PFN_SPECIAL,	"SPECIAL" }, \
 	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
 	{ PFN_SG_LAST,	"SG_LAST" }, \
-	{ PFN_DEV,	"DEV" }, \
 	{ PFN_MAP,	"MAP" }
 
 static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
@@ -46,7 +43,7 @@ static inline pfn_t phys_to_pfn_t(phys_a
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
-	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
+	return (pfn.val & PFN_MAP) == PFN_MAP;
 }
 
 static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
@@ -100,7 +97,7 @@ static inline pud_t pfn_t_pud(pfn_t pfn,
 #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
 static inline bool pfn_t_devmap(pfn_t pfn)
 {
-	const u64 flags = PFN_DEV|PFN_MAP;
+	const u64 flags = PFN_MAP;
 
 	return (pfn.val & flags) == flags;
 }
--- a/mm/memory.c~mm-remove-remaining-uses-of-pfn_dev
+++ a/mm/memory.c
@@ -2544,7 +2544,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot,
+	return insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, 0), pgprot,
 			false);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
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

