Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B4E23815F
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007650; cv=none; b=gTwZkRZXdkOpIcVY+5xujk1MtDDu96A2GDBAyua+eCuejQsqY6NQ0M+fEhePCKixPBSiNmEVZHtP+3TY8qK+PwIIM3t4Jem9YsZ9HQr8Sj9vfToUgbETS3yh+6dQjcD/aqbm2pTtAMjNUtyefR0+DlP+i70BhS2VCi/we4oqxW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007650; c=relaxed/simple;
	bh=qk5kJVv7ahNC2t0sWDN/tj63xme5F9afEc+T1uHP1ls=;
	h=Date:To:From:Subject:Message-Id; b=piJFAdzlXw84IqQ7bkIJBV0EE/btepUSnomwBFkWNqQ9zrobWa213wGaempaorOcoQP2rtcsXimwWrfckowbkc18XpEQbu9Ybmr8nJABcXvarPJn69G7BbED9XF/b3k9/kKN3dLaDFu4NtVRijuZKkAlWMEY0NvARzPNNAhxCiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0275TgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0275TgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1735CC4CEED;
	Wed,  4 Jun 2025 03:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749007649;
	bh=qk5kJVv7ahNC2t0sWDN/tj63xme5F9afEc+T1uHP1ls=;
	h=Date:To:From:Subject:From;
	b=b0275TgSmdi5hsF2ujGMyQbzB2lPo26QM42wnbZ/LpB9ZSj9mPFxEVW+OiQN16xGL
	 fG+Hx+aljkuM5m4dG7lvCAbo014ul/KnBu0jNIycHrudl6FpQimDMv0nfoLB+3mLCb
	 ++wPXeuJyKwbLNDjxfYEeNpsstL5vXnkZDVvGUjQ=
Date: Tue, 03 Jun 2025 20:27:28 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch added to mm-new branch
Message-Id: <20250604032729.1735CC4CEED@smtp.kernel.org>
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
Date: Wed, 4 Jun 2025 13:21:45 +1000

The PFN_MAP flag is no longer used for anything, so remove it.  The
PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been used so also
remove them.  The last user of PFN_SPECIAL was removed by 653d7825c149
("dcssblk: mark DAX broken, remove FS_DAX_LIMITED support").

Link: https://lkml.kernel.org/r/20250604032145.463934-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pfn_t.h             |   31 ++--------------------------
 mm/memory.c                       |    2 -
 tools/testing/nvdimm/test/iomap.c |    4 ---
 3 files changed, 3 insertions(+), 34 deletions(-)

--- a/include/linux/pfn_t.h~mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last
+++ a/include/linux/pfn_t.h
@@ -5,26 +5,13 @@
 
 /*
  * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
- * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
- * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
  * PFN_DEV - pfn is not covered by system memmap by default
- * PFN_MAP - pfn has a dynamic page mapping established by a device driver
- * PFN_SPECIAL - for CONFIG_FS_DAX_LIMITED builds to allow XIP, but not
- *		 get_user_pages
  */
 #define PFN_FLAGS_MASK (((u64) (~PAGE_MASK)) << (BITS_PER_LONG_LONG - PAGE_SHIFT))
-#define PFN_SG_CHAIN (1ULL << (BITS_PER_LONG_LONG - 1))
-#define PFN_SG_LAST (1ULL << (BITS_PER_LONG_LONG - 2))
 #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
-#define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
-#define PFN_SPECIAL (1ULL << (BITS_PER_LONG_LONG - 5))
 
 #define PFN_FLAGS_TRACE \
-	{ PFN_SPECIAL,	"SPECIAL" }, \
-	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
-	{ PFN_SG_LAST,	"SG_LAST" }, \
-	{ PFN_DEV,	"DEV" }, \
-	{ PFN_MAP,	"MAP" }
+	{ PFN_DEV,	"DEV" }
 
 static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
 {
@@ -46,7 +33,7 @@ static inline pfn_t phys_to_pfn_t(phys_a
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
-	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
+	return (pfn.val & PFN_DEV) == 0;
 }
 
 static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
@@ -100,7 +87,7 @@ static inline pud_t pfn_t_pud(pfn_t pfn,
 #ifdef CONFIG_ARCH_HAS_PTE_DEVMAP
 static inline bool pfn_t_devmap(pfn_t pfn)
 {
-	const u64 flags = PFN_DEV|PFN_MAP;
+	const u64 flags = PFN_DEV;
 
 	return (pfn.val & flags) == flags;
 }
@@ -116,16 +103,4 @@ pmd_t pmd_mkdevmap(pmd_t pmd);
 pud_t pud_mkdevmap(pud_t pud);
 #endif
 #endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
-
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
@@ -2599,8 +2599,6 @@ static bool vm_mixed_ok(struct vm_area_s
 		return true;
 	if (pfn_t_devmap(pfn))
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

maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch
mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch

