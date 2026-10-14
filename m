Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E348D883;
	Wed, 14 Oct 2026 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792013122; cv=none; b=YpirnAilVpv4p1947EHGPylFYZJTKp0+nhpDA8nHlm9l9wBurwGfMfveErNsCrNBlopL1KeahYEv2TdZLw/vZDse3zpS3yTmGVOGBVZSqQ+lCVCII+hvJ3cErzZImErzvL6G+cZA8LlUw11jAC9/8zayNb3R1LRuCKQsZhFTG7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792013122; c=relaxed/simple;
	bh=w2vmYveFHjsw514WzB3Eou3Ljpc+Dx93v5FEals2zZ0=;
	h=Date:To:From:Subject:Message-Id; b=QbYYqUpmUdIdDwUye+TBQ2EZJNLReEbFl0v7fLNZUehIymKdQmA5SAvzGnWEYjSMniPOsUHf4loe7fed8foM77MqHH4+opCGVIh3idEojxqBsiIKIwt0j2aEdBXjgGF4ICV1HMYy0/AGJPi/h6e+959aayv9K6O11yFwdpXc098=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XywtRkfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XywtRkfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2831F000C4;
	Wed, 14 Oct 2026 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792013120;
	bh=EUvzdqCvrgPlQWt1uiDhK0wow6BKN5aMeW7rcejgBxA=;
	h=Date:To:From:Subject;
	b=XywtRkfprwjQIlMB2DjG6b7x1aI2rAPRF2dxRYj7jwrMl6eWU804YPCaTUYTImdis
	 hoDq96ULWqns94Kfd7B7xe45Qlx+1uZbaH5VNMi8UPUvF3JdJ3djrLN2pmWSWaJ1yU
	 4I0S87ugbu0U4p9ZHvGt9p63xjvXj/kFqCQoBR4w=
Date: Wed, 14 Oct 2026 14:25:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kylebot@openai.com,kas@kernel.org,huang.ying.caritas@gmail.com,hanchuanhua@oppo.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch added to mm-hotfixes-unstable branch
Message-Id: <20261014212520.8C2831F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix address wraparound when scanning large folio PTEs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: fix address wraparound when scanning large folio PTEs
Date: Wed, 14 Oct 2026 20:34:28 +0200

numa_rebuild_large_mapping() and do_swap_page() can be tricked into
generating an address wraparound, crashing the kernel. All that's required
is to map a tail page of a large folio close enough to the start/end of
the address space to e.g., make

	unsigned long addr_start = addr - (nr << PAGE_SHIFT);

to wrap around.

Let's fix it by providing a better helper, folio_scan_range(), that
takes care of staying within VMA and page table boundaries while
handling possible wraparounds.

There are some nasty details, like not being able to use pmd_addr_end()
in this context. Add some helpful comments for these cases.

Link: https://lore.kernel.org/20261014-folio_pte_scan_range-v2-1-00cf9bbaa364@kernel.org
Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |   50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-fix-address-wraparound-when-scanning-large-folio-ptes
+++ a/mm/memory.c
@@ -4882,6 +4882,34 @@ static void check_swap_exclusive(struct
 }
 
 /*
+ * Get the address range in which a folio might be mapped, assuming its pages
+ * are mapped consecutively and the folio page at the given idx is mapped at
+ * the given address.
+ */
+static void folio_pte_range(const struct folio *folio,
+		const struct vm_area_struct *vma, unsigned long addr,
+		unsigned long idx, unsigned long *start, unsigned long *end)
+{
+	/* Stay within the page table and VMA boundaries. */
+	const unsigned long pmd_start = addr & PMD_MASK;
+	const unsigned long pmd_end = pmd_start + PMD_SIZE;
+	const unsigned long lower = max(pmd_start, vma->vm_start);
+	/*
+	 * We cannot use pmd_addr_end(), as it does not clamp reliably. To
+	 * avoid wraparounds, compute using the inclusive end.
+	 */
+	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
+	const unsigned long offset = idx << PAGE_SHIFT;
+
+	/*
+	 * Avoid start/end addresses wrapping by not adding/subtracting more
+	 * than the lower/upper limits would allow.
+	 */
+	*start = addr - min(addr - lower, offset);
+	*end = addr + min(upper - addr, folio_size(folio) - offset);
+}
+
+/*
  * We enter with either the VMA lock or the mmap_lock held (see
  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
@@ -5063,16 +5091,15 @@ vm_fault_t do_swap_page(struct vm_fault
 	address = vmf->address;
 	ptep = vmf->pte;
 	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
-		int nr = folio_nr_pages(folio);
-		unsigned long idx = folio_page_idx(folio, page);
-		unsigned long folio_start = address - idx * PAGE_SIZE;
-		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
+		const int nr = folio_nr_pages(folio);
+		const unsigned long idx = folio_page_idx(folio, page);
+		unsigned long folio_start, folio_end;
 		pte_t *folio_ptep;
 		pte_t folio_pte;
 
-		if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
-			goto check_folio;
-		if (unlikely(folio_end > pmd_addr_end(address, vma->vm_end)))
+		folio_pte_range(folio, vma, address, idx, &folio_start,
+				&folio_end);
+		if (unlikely((folio_end - folio_start) >> PAGE_SHIFT != nr))
 			goto check_folio;
 
 		folio_ptep = vmf->pte - idx;
@@ -6222,16 +6249,11 @@ static void numa_rebuild_large_mapping(s
 				       struct folio *folio, pte_t fault_pte,
 				       bool ignore_writable, bool pte_write_upgrade)
 {
-	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
+	const unsigned long idx = pte_pfn(fault_pte) - folio_pfn(folio);
 	unsigned long start, end, addr = vmf->address;
-	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
-	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
 	pte_t *start_ptep;
 
-	/* Stay within the VMA and within the page table. */
-	start = max3(addr_start, pt_start, vma->vm_start);
-	end = min3(addr_start + folio_size(folio), pt_start + PMD_SIZE,
-		   vma->vm_end);
+	folio_pte_range(folio, vma, addr, idx, &start, &end);
 	start_ptep = vmf->pte - ((addr - start) >> PAGE_SHIFT);
 
 	/* Restore all PTEs' mapping of the large folio */
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
arm64-mm-move-__check_safe_pte_update-fix.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
vmcoreinfo-export-section_has_mem_map.patch
mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch
mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings.patch

