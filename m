Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7D94C8F
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 00:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750118492; cv=none; b=R2ZUoq7aB/cnl/7DPOOlhnHt60UmGfGc8ZBU1FJ1WM5x069CFUZuhqCNusuYRydXrZk0cZovPE2xBo4CMvkiSMZ+oMJw2N0DPwWacF7G0c7p/TGmOFqum9ub+Z9sOliXcxqljmpiJm/euToQWnUU4T2cYbLMKWdGYhWLDaprRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750118492; c=relaxed/simple;
	bh=Tlp9TkGJb7suTNXPWuOC+t0DKBzUVNWqqRt3S2SRwpY=;
	h=Date:To:From:Subject:Message-Id; b=ZIfsaCqcilOVAjcZBP3SLmNl6KkM2wZh79sIWUj7657l6vrTj5KNutyqZDGP5bLGa0mUsS0vjDNfViR0C/DKvwc8bR6gq1DOzPHik/kmTe43n6+u+RI/7APkUWWrEBo9QxB8CV9rCrfAHMQzT5JcQD8v7a38g3cxe333qEv4BVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GL8QXgDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GL8QXgDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76327C4CEEA;
	Tue, 17 Jun 2025 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750118492;
	bh=Tlp9TkGJb7suTNXPWuOC+t0DKBzUVNWqqRt3S2SRwpY=;
	h=Date:To:From:Subject:From;
	b=GL8QXgDpkolzH92aP8pUTEROXVwT4Gi+w0ajFl6WmysykMLPpaRqNcJ/+VpjTYXKi
	 83UQe9/jZSU8Mx6ONXbbXD/7dQR30lx+ELf1VDzjjwUluzVVztwIf8gXQ4wQL/uFzK
	 LR4dFoRSwI3LUmbzzEFMLq15a8VoqxNWFw+eGJVQ=
Date: Mon, 16 Jun 2025 17:01:31 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch added to mm-new branch
Message-Id: <20250617000132.76327C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch

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
Subject: mm: remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST
Date: Mon, 16 Jun 2025 21:58:14 +1000

The PFN_MAP flag is no longer used for anything, so remove it.  The
PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been used so also
remove them.  The last user of PFN_SPECIAL was removed by 653d7825c149
("dcssblk: mark DAX broken, remove FS_DAX_LIMITED support").

Link: https://lkml.kernel.org/r/3a43a99bb4b34567bed3bfe60c9ae3533aac100d.1750075065.git-series.apopple@nvidia.com
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
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

 include/linux/pfn_t.h             |   27 ++-------------------------
 mm/memory.c                       |    2 --
 tools/testing/nvdimm/test/iomap.c |    4 ----
 3 files changed, 2 insertions(+), 31 deletions(-)

--- a/include/linux/pfn_t.h~mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last
+++ a/include/linux/pfn_t.h
@@ -5,23 +5,11 @@
 
 /*
  * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
- * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
- * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
- * PFN_MAP - pfn has a dynamic page mapping established by a device driver
- * PFN_SPECIAL - for CONFIG_FS_DAX_LIMITED builds to allow XIP, but not
- *		 get_user_pages
  */
 #define PFN_FLAGS_MASK (((u64) (~PAGE_MASK)) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
-#define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
-#define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
-#define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
-#define PFN_SPECIAL (1ULL << (BITS_PER_LONG_LONG - 5))
 
 #define PFN_FLAGS_TRACE \
-	{ PFN_SPECIAL,	"SPECIAL" }, \
-	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
-	{ PFN_SG_LAST,	"SG_LAST" }, \
-	{ PFN_MAP,	"MAP" }
+	{ }
 
 static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
 {
@@ -43,7 +31,7 @@ static inline pfn_t phys_to_pfn_t(phys_a
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
-	return (pfn.val & PFN_MAP) == PFN_MAP;
+	return true;
 }
 
 static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
@@ -94,15 +82,4 @@ static inline pud_t pfn_t_pud(pfn_t pfn,
 #endif
 #endif
 
-#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
-static inline bool pfn_t_special(pfn_t pfn)
-{
-	return (pfn.val & PFN_SPECIAL) == PFN_SPECIAL;
-}
-#else
-static inline bool pfn_t_special(pfn_t pfn)
-{
-	return false;
-}
-#endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 #endif /* _LINUX_PFN_T_H_ */
--- a/mm/memory.c~mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last
+++ a/mm/memory.c
@@ -2581,8 +2581,6 @@ static bool vm_mixed_ok(struct vm_area_s
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
 		return true;
-	if (pfn_t_special(pfn))
-		return true;
 	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
 		return true;
 	return false;
--- a/tools/testing/nvdimm/test/iomap.c~mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last
+++ a/tools/testing/nvdimm/test/iomap.c
@@ -137,10 +137,6 @@ EXPORT_SYMBOL_GPL(__wrap_devm_memremap_p
 
 pfn_t __wrap_phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
 {
-	struct nfit_test_resource *nfit_res = get_nfit_res(addr);
-
-	if (nfit_res)
-		flags &= ~PFN_MAP;
         return phys_to_pfn_t(addr, flags);
 }
 EXPORT_SYMBOL(__wrap_phys_to_pfn_t);
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

