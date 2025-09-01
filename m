Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D898D10FD
	for <mm-commits@vger.kernel.org>; Mon,  1 Sep 2025 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756752154; cv=none; b=MJY08EedP7uNB2e6y/X9Tmbozv3vKLaUY/DBbdqyPlaNRH01h8GyIn5GkH+iSlOgCV2NiRismRpFrvs99t/i0BAx+ux24x5m1Q6Uk/EmH/FZSJShcAIQ7wPDKe16cSyRC4KfsSbE3/D60bFLfKlaEazLOBkIEJtiYvWJ7eL7klo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756752154; c=relaxed/simple;
	bh=bVlCcOCsM+vEBrDn/xV7yh728caQ9mDX9AD3GXeYg84=;
	h=Date:To:From:Subject:Message-Id; b=NBnP2pCFXreT1B6s7YTjBrwndULkQJ2Iziub1WlTYFR69it+f0oFuROhE4OqaheKza+NfmbX6xWvE3GiYHq7Q/jbPtLxSli1O6uyH94KeCYMLvyNtscyNvB+6on4gl7amjm4H17yYVElKo6PQ1yoTtAYfa4DKgJf66oykO4vZrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zr/uAeF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zr/uAeF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660E3C4CEF0;
	Mon,  1 Sep 2025 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756752154;
	bh=bVlCcOCsM+vEBrDn/xV7yh728caQ9mDX9AD3GXeYg84=;
	h=Date:To:From:Subject:From;
	b=Zr/uAeF7vlyCPXXo8+wIMjGAJllp57z1r7Qzs0b4n31K1dOjxqLOfyzGlsixlHghd
	 RxOQe85LykG9380FiJJVWPC6WZ/7w2q6qDXrMtHSoCzQ2IKZ/mMo9UzjlGa72KvGKc
	 UBObZetqJJ3ziTaysxIvCehpXd+0aRF2cDgaMmQ0=
Date: Mon, 01 Sep 2025 11:42:33 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch added to mm-new branch
Message-Id: <20250901184234.660E3C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
Date: Mon, 1 Sep 2025 17:03:34 +0200

We can now safely iterate over all pages in a folio, so no need for the
pfn_to_page().

Also, as we already force the refcount in __init_single_page() to 1
through init_page_count(), we can just set the refcount to 0 and avoid
page_ref_freeze() + VM_BUG_ON.  Likely, in the future, we would just want
to tell __init_single_page() to which value to initialize the refcount.

Further, adjust the comments to highlight that we are dealing with an
open-coded prep_compound_page() variant, and add another comment
explaining why we really need the __init_single_page() only on the tail
pages.

Note that the current code was likely problematic, but we never ran into
it: prep_compound_tail() would have been called with an offset that might
exceed a memory section, and prep_compound_tail() would have simply added
that offset to the page pointer -- which would not have done the right
thing on sparsemem without vmemmap.

Link: https://lkml.kernel.org/r/20250901150359.867252-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap
+++ a/mm/hugetlb.c
@@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_ta
 {
 	enum zone_type zone = zone_idx(folio_zone(folio));
 	int nid = folio_nid(folio);
+	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	int ret;
-
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
 
+	/*
+	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
+	 * we must initialize them ourselves here.
+	 */
+	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
-		ret = page_ref_freeze(page, 1);
-		VM_BUG_ON(!ret);
+		set_page_count(page, 0);
 	}
 }
 
@@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vm
 {
 	int ret;
 
-	/* Prepare folio head */
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing/preparing+freezing them in the
+	 * same go.
+	 */
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	/* Initialize the necessary tail struct pages */
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
mm-migrate-remove-migratepage_unmap-fix.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch
mm-stop-making-sparsemem_vmemmap-user-selectable.patch
arm64-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
s390-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
x86-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch
wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch
mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof.patch
mm-memremap-reject-unreasonable-folio-compound-page-sizes-in-memremap_pages.patch
mm-hugetlb-check-for-unreasonable-folio-sizes-when-registering-hstate.patch
mm-mm_init-make-memmap_init_compound-look-more-like-prep_compound_page.patch
mm-sanity-check-maximum-folio-size-in-folio_set_order.patch
mm-limit-folio-compound-page-sizes-in-problematic-kernel-configs.patch
mm-simplify-folio_page-and-folio_page_idx.patch
mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch
mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation.patch
fs-hugetlbfs-remove-nth_page-usage-within-folio-in-adjust_range_hwpoison.patch
fs-hugetlbfs-cleanup-folio-in-adjust_range_hwpoison.patch
mm-pagewalk-drop-nth_page-usage-within-folio-in-folio_walk_start.patch
mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages.patch
mm-gup-remove-record_subpages.patch
io_uring-zcrx-remove-nth_page-usage-within-folio.patch
mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch
mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch
dma-remap-drop-nth_page-in-dma_common_contiguous_remap.patch
scatterlist-disallow-non-contigous-page-ranges-in-a-single-sg-entry.patch
ata-libata-sff-drop-nth_page-usage-within-sg-entry.patch
drm-i915-gem-drop-nth_page-usage-within-sg-entry.patch
mspro_block-drop-nth_page-usage-within-sg-entry.patch
memstick-drop-nth_page-usage-within-sg-entry.patch
mmc-drop-nth_page-usage-within-sg-entry.patch
scsi-scsi_lib-drop-nth_page-usage-within-sg-entry.patch
scsi-sg-drop-nth_page-usage-within-sg-entry.patch
vfio-pci-drop-nth_page-usage-within-sg-entry.patch
crypto-remove-nth_page-usage-within-sg-entry.patch
mm-gup-drop-nth_page-usage-in-unpin_user_page_range_dirty_lock.patch
kfence-drop-nth_page-usage.patch
block-update-comment-of-struct-bio_vec-regarding-nth_page.patch
mm-remove-nth_page.patch

