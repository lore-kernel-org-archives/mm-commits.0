Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202863BD638
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896748; cv=none; b=kEATuA+m26FBHZx0RXM/vt3dJscj0UNrthco7b0mgMObLVXHHVa3fTUDJ61ylpbBjTzWMZA0d5P5/60Q1TrG7WYvY0+KX8sFxyeJw5ActuXT7ZlcwctWHBDjBIpKqk/6/Wpb3x3D+/FlUcSia0L6Oj8TzWFWvSRINDuXKSG+HF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896748; c=relaxed/simple;
	bh=pCYNqw++wSHyPu8sO1NkQdw/5Dkmf1WhavAnaobgaIk=;
	h=Date:To:From:Subject:Message-Id; b=HK/7yk7uUXEaWCmi81tBQVC1ZVJl6Jtr7ORz9HBMNE1pNIqCO6Y6AVjD2dg/uufl0feP0gqkyt7EpCE4SYE/Uqfd2oHfBJzsj7yZQXth4F2txP/DSAt8XeLHQfSgVtOqIqx7H3ept2mzGKhYtuakyEKbKDCi1eAZQWoNnJ5qgM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y4FzfMad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y4FzfMad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB241F00A3A;
	Wed,  5 Aug 2026 02:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896747;
	bh=30RK3m/Gbg6JDVbJ2JMxpvvpbsKJP6F9A0xcZY7vvqQ=;
	h=Date:To:From:Subject;
	b=y4FzfMadsREB/ZAcLaMVTsBUXYv9J6GPPfdwyGilqnTx2pBOvNL6krcVb2jTxq6WL
	 zbput1QSlmdNRqRHadCy1xGsLkIgodWP86sylFsXQEUf706bE4s2+CyC9B1LtK0//+
	 4owAXPzIvu+uE28fv2Tz8TQJv2PtWuK+W7A5xH2E=
Date: Tue, 04 Aug 2026 19:25:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-kdoc-comments-for-vma_start-last_pgoff.patch removed from -mm tree
Message-Id: <20260805022546.DDB241F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add kdoc comments for vma_start/last_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-add-kdoc-comments-for-vma_start-last_pgoff.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: add kdoc comments for vma_start/last_pgoff()
Date: Fri, 10 Jul 2026 21:16:43 +0100

Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
detail.

This is in order that we can differentiate this between functions that will
be added in a subsequent patch which provide a different page offset.

We go to lengths to describe the edge cases that can be run into here.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/include/linux/mm.h~mm-add-kdoc-comments-for-vma_start-last_pgoff
+++ a/include/linux/mm.h
@@ -4311,11 +4311,41 @@ static inline unsigned long vma_pages(co
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+/**
+ * vma_start_pgoff() - Get the page offset of the start of @vma
+ * @vma: The VMA whose page offset is required.
+ *
+ * If the VMA is file-backed, this is the page offset into the file.
+ *
+ * If @vma is anonymous, this is the virtual page offset of the start of the
+ * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
+ * page offset within the file.
+ *
+ * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
+ * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
+ * regions have their page offset set to the first PFN in the range.
+ *
+ * Returns: The page offset of the start of @vma.
+ */
 static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_last_pgoff() - Get the page offset of the last page in @vma
+ * @vma: The VMA whose last page offset is required.
+ *
+ * This returns the last page offset contained within @vma.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The last page offset of @vma.
+ */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
 	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

