Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793768284;
	b=SGzkcxFh7gRHirxh8QHCj8idMDpWWMM42yA3Xpok0ZWP/Og3L2Sz4zQxefl6nJSpX+a7
	 Io79GkaZJQtvwKPDlWCrNyebJ71CATFU2eMGIz35bNQMToPkWbZDUsh8jEbuB+sK87JfV
	 64je8m5vumAdr0jAwqT9a0XuJR5CE9n0SfPOJt7ILD5peMCLrf/J8shGf3GpGIeSm9eDt
	 VrUTuF2JpAJNvCV8geHeR8iXGIGMQbjiqsDKNnVmyA2u7rpqg7jZY2yOn6USoaaSvvBnh
	 iq8ERqA1Em5gUjb4oGhapSKAgelR6BIYXFkNm8W8eSVCDS9iYDPME1q0SU8Hpo4aRcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793768284;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+m6f89Gyk9rODUfCWmzimL1bnQ6ZChXXxmvlRV/1eOc=;
	b=wnV9ZKwdQoyXucWVJk/j2sIjd01oz//MTCuDRx/6YRCSx11C765tEtpYhuPNX2799RNZ
	 /yEz9uVAemXnLSB49rvEu4iSnud4Bvay5MIIVH/AjY5sCl8H3Jn/VopBe84nzZJ433ZLc
	 9rvxRGrKgNHgm5XXxshCrkuAS/EfDYw/DqVPXzDvjoLSjFM7pbnsXwaVdpMgHG5TuZXh0
	 7SW2/pj64G5Dc79GhWUjxLWuzax/vfjH59sPCf7Rr1+mIsqHfW+wrpMeFrLkW7fwvyKL6
	 82R/Gr9Z57v1TSHwldN0eQ1TZmKbbMLNc5pjtpI52tCH60XeL2lPVaSJGgHWcaFqIVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2JRMDVNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF73606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 04:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2JRMDVNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960441F000C1;
	Wed,  4 Nov 2026 04:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793768283;
	bh=+m6f89Gyk9rODUfCWmzimL1bnQ6ZChXXxmvlRV/1eOc=;
	h=Date:To:From:Subject;
	b=2JRMDVNajRhgRgDxmIgvj28hnVRA3VcaOHFJUApR2VUq6c0hN3n44GHHYz/8+YbN0
	 m5GtVJgqb+36YCJlNgB/4IoO0kuN7pNjpvRQgn2cNew1PaZcmV8LIoh0k5KazzrHn5
	 4lTp1RHD9dWEiNVSv5FjOdl0ofMJcZ+rJYc1YuJI=
Date: Tue, 03 Nov 2026 20:58:03 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,
	osalvador@suse.de,lance.yang@linux.dev,jthoughton@google.com,
	david@kernel.org,chenhuacai@kernel.org,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch added to mm-new branch
Message-Id: <20261104045803.960441F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
Date: Wed, 04 Nov 2026 10:35:08 +0800

Like optimization, vmemmap restoration operates on one folio at a time,
but the current interface exposes a raw address range and requires the
HugeTLB caller to prepare part of the operation.  This splits the common
mechanism across layers and obscures its natural unit of work.

Make the folio the unit of vmemmap restoration and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller and gives both directions of HVO
consistent folio-level interfaces.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented
+++ a/mm/hugetlb_vmemmap.c
@@ -363,28 +363,29 @@ static int vmemmap_optimize_folio(const
 }
 
 /**
- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
- *			 to the page which is from the @vmemmap_pages
- *			 respectively.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_restore_folio - restore the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be restored.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries are restored from the shared
+ * tail page back to distinct backing pages allocated for @folio, while
+ * non-optimizable entries remain unchanged.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long flags)
+static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
-	int nid = page_to_nid((struct page *)start);
+	int nid = folio_nid(folio);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
+	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
@@ -402,7 +403,6 @@ static int __hugetlb_vmemmap_restore_fol
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -410,18 +410,7 @@ static int __hugetlb_vmemmap_restore_fol
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
-
-	/*
-	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
-	 * When a HugeTLB page is freed to the buddy allocator, previously
-	 * discarded vmemmap pages must be allocated and remapping.
-	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_restore_folio(folio, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch

