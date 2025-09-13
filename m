Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3183C2BD5B4
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801559; cv=none; b=XDW/c6vVGjQrOPUtOYfftaiqfP99/LdtQoGnRauW9q2gSk+BBPmwGel/QkiT9XPBl/KibaCJARqOkgvsRDN8B4AVKrGizUrgWS1/PQ9g31Yz/Ia44D7jAbV/9FmLsKfO5E7V/K0nnlVyMdFBDwKu9UNZTjJYGxP35nFNYINhSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801559; c=relaxed/simple;
	bh=HHcxV7rlLWvctvPIWJchR6QX45LJLTm3r11antC/dcI=;
	h=Date:To:From:Subject:Message-Id; b=NnKM5zL0ocZNtkDMjkJsghlcr/daROkmmU+rzl9q0jEH55fNJP5ifdvJtBFmbIrXkYFfE3UCwqOiAPRJiWP5zjroWsZWGzI971n9rCfjsx8YfONbQHhQwNgXf4wMLsgO8wpCoqhO9RtsGDTzmX7p9OYnuLLbcFcGoaeQcubc/9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WlpvZ/IM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WlpvZ/IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A831EC4CEEB;
	Sat, 13 Sep 2025 22:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801558;
	bh=HHcxV7rlLWvctvPIWJchR6QX45LJLTm3r11antC/dcI=;
	h=Date:To:From:Subject:From;
	b=WlpvZ/IMgIl3ugnJsJHVixbZllrcUVHsCCWPyUQAsgrb1F8LDe3uCfyC4Er1f9TJc
	 4WnBxu5Wtjbhptzk2NwT0vvmbL/ZweusyMlN5YfKTYZ06fIjEJ7t1g0EcwhYDXS/b7
	 RmYMMNr2erUxsRRk1/M/dca3ES6HXgZOUDyvkesQ=
Date: Sat, 13 Sep 2025 15:12:38 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch removed from -mm tree
Message-Id: <20250913221238.A831EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch

This patch was dropped because it was folded into mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix
Date: Mon, 25 Aug 2025 14:25:59 +0200

Let's just drop the warning, it's highly unlikely that we ever run into
this, and if so, there is serious stuff going wrong elsewhere.

Link: https://lkml.kernel.org/r/923b279c-de33-44dd-a923-2959afad8626@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pgtable.h~mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix
+++ a/include/linux/pgtable.h
@@ -1997,7 +1997,6 @@ static inline const char *pgtable_level_
 	case PGTABLE_LEVEL_PGD:
 		return "pgd";
 	default:
-		VM_WARN_ON_ONCE(1);
 		return "unknown";
 	}
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
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
mm-gup-remove-record_subpages-fix.patch
io_uring-zcrx-remove-nth_page-usage-within-folio.patch
mips-mm-convert-__flush_dcache_pages-to-__flush_dcache_folio_pages.patch
mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch
mm-cma-refuse-handing-out-non-contiguous-page-ranges-fix.patch
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
selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch
selftests-mm-split_huge_page_test-cleanups-for-split_pte_mapped_thp-test.patch
mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch
selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch

