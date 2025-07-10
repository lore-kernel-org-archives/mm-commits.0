Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD019285C84
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126338; cv=none; b=unkuQITk9Gj0zydIIemj/wbhCtyFxlNhdzTVXNCw1rffFhTt6n2Z6GZq9xA6d5Buo7G7wwv87vAMT97LERsO3LN4G+s3KhPffhBGpLYUTQ3JUJk1K+XqBFZXdDL/m23Znxwh4MN2WZZZpsYeuu1FVYb1O0sUNuAnl+s2whN134s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126338; c=relaxed/simple;
	bh=Z0ylqY0/DBnPB6rHQNkzJP8VFuYKPrh8orX72yJzcx4=;
	h=Date:To:From:Subject:Message-Id; b=aUPK8DkWZbJ1WdKlhsvU4xD+5+F1pbndhCJ+yvIjFliohATHD/TDB54N5HS0nfb3dgLMS9YiZgLr0+6psmfN1aekj7TnVn3oOFZCh21q/R0WLFmgjZ5WvRooRErurapa4+raIJ8BYepZCDZByjyu3RO8OiRLdJJHvYQW1xgTC/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMw9myOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMw9myOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBA1C4CEE3;
	Thu, 10 Jul 2025 05:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126338;
	bh=Z0ylqY0/DBnPB6rHQNkzJP8VFuYKPrh8orX72yJzcx4=;
	h=Date:To:From:Subject:From;
	b=hMw9myOcHvoimN2qn+E/ZWuFfHkgPR4WzXVU5e+fOWJx71wEv+NNj/wIFBMqFMLGp
	 eI9mEayWIlxIUXZL2GXxqqgi+ixH84ukf77m3O0Z+QDgbIKO1cMcBdFa5X1i6dMB5n
	 XVVbJc3NXjfmSVnfRRINJ9Jb4DbQUT3pNqYOmnhA=
Date: Wed, 09 Jul 2025 22:45:37 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special.patch removed from -mm tree
Message-Id: <20250710054538.5BBA1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert vmf_insert_mixed() from using pte_devmap to pte_special
has been removed from the -mm tree.  Its filename was
     mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: convert vmf_insert_mixed() from using pte_devmap to pte_special
Date: Thu, 19 Jun 2025 18:57:56 +1000

DAX no longer requires device PTEs as it always has a ZONE_DEVICE page
associated with the PTE that can be reference counted normally.  Other
users of pte_devmap are drivers that set PFN_DEV when calling
vmf_insert_mixed() which ensures vm_normal_page() returns NULL for these
entries.

There is no reason to distinguish these pte_devmap users so in order to
free up a PTE bit use pte_special instead for entries created with
vmf_insert_mixed().  This will ensure vm_normal_page() will continue to
return NULL for these pages.

Architectures that don't support pte_special also don't support pte_devmap
so those will continue to rely on pfn_valid() to determine if the page can
be mapped.

Link: https://lkml.kernel.org/r/93086bd446e7bf8e4c85345613ac18f706b01f60.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c    |    3 ---
 mm/memory.c |   20 ++------------------
 mm/vmscan.c |    2 +-
 3 files changed, 3 insertions(+), 22 deletions(-)

--- a/mm/hmm.c~mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special
+++ a/mm/hmm.c
@@ -302,13 +302,10 @@ static int hmm_vma_handle_pte(struct mm_
 		goto fault;
 
 	/*
-	 * Bypass devmap pte such as DAX page when all pfn requested
-	 * flags(pfn_req_flags) are fulfilled.
 	 * Since each architecture defines a struct page for the zero page, just
 	 * fall through and treat it like a normal page.
 	 */
 	if (!vm_normal_page(walk->vma, addr, pte) &&
-	    !pte_devmap(pte) &&
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			pte_unmap(ptep);
--- a/mm/memory.c~mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special
+++ a/mm/memory.c
@@ -598,16 +598,6 @@ struct page *vm_normal_page(struct vm_ar
 			return NULL;
 		if (is_zero_pfn(pfn))
 			return NULL;
-		if (pte_devmap(pte))
-		/*
-		 * NOTE: New users of ZONE_DEVICE will not set pte_devmap()
-		 * and will have refcounts incremented on their struct pages
-		 * when they are inserted into PTEs, thus they are safe to
-		 * return here. Legacy ZONE_DEVICE pages that set pte_devmap()
-		 * do not have refcounts. Example of legacy ZONE_DEVICE is
-		 * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
-		 */
-			return NULL;
 
 		print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
@@ -2483,10 +2473,7 @@ static vm_fault_t insert_pfn(struct vm_a
 	}
 
 	/* Ok, finally just insert the thing.. */
-	if (pfn_t_devmap(pfn))
-		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
-	else
-		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
+	entry = pte_mkspecial(pfn_t_pte(pfn, prot));
 
 	if (mkwrite) {
 		entry = pte_mkyoung(entry);
@@ -2597,8 +2584,6 @@ static bool vm_mixed_ok(struct vm_area_s
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
 		return true;
-	if (pfn_t_devmap(pfn))
-		return true;
 	if (pfn_t_special(pfn))
 		return true;
 	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
@@ -2630,8 +2615,7 @@ static vm_fault_t __vm_insert_mixed(stru
 	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
 	 * without pte special, it would there be refcounted as a normal page.
 	 */
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) &&
-	    !pfn_t_devmap(pfn) && pfn_t_valid(pfn)) {
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) && pfn_t_valid(pfn)) {
 		struct page *page;
 
 		/*
--- a/mm/vmscan.c~mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special
+++ a/mm/vmscan.c
@@ -3425,7 +3425,7 @@ static unsigned long get_pte_pfn(pte_t p
 	if (!pte_present(pte) || is_zero_pfn(pfn))
 		return -1;
 
-	if (WARN_ON_ONCE(pte_devmap(pte) || pte_special(pte)))
+	if (WARN_ON_ONCE(pte_special(pte)))
 		return -1;
 
 	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
_

Patches currently in -mm which might be from apopple@nvidia.com are


