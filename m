Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8813327F724
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801440; cv=none; b=mFJccs2X3z9SCgrTZhqeKWokyNOCDtIE4B7hDJRFufMmQ4DS3EDi6d1vJwvd7TBNPCLwdMXtxVlSKi1Dx7tEFYfSmPE3liHIQ7BROQHHwGd9AMKV+08f05s6L7mbn2jXpTUvbxsPuzSeq+vY5AAqEeYAFDAZ9OoeZF/NjJg+jTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801440; c=relaxed/simple;
	bh=f9BO+d5ZCeSLi9feo/KVX4Mt4j+4XYBHTF+MJ7ZzqaE=;
	h=Date:To:From:Subject:Message-Id; b=XKR7ROeY44RYj9ehSHovVsXsnAHeihUGJca4wzfxAivtAE+4rMELubdaqgxYj39S9QpP5arvMPc5zzm5DEGnz2x0uSAJB4vcrXejrwtTgeGDSrnF47OAsciq/flLFQJudn507TQxWwym2JkpxAiixtwsehkjEwcANrRXRBupRmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0xjxPX+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0xjxPX+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E415C4CEEB;
	Sat, 13 Sep 2025 22:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801440;
	bh=f9BO+d5ZCeSLi9feo/KVX4Mt4j+4XYBHTF+MJ7ZzqaE=;
	h=Date:To:From:Subject:From;
	b=0xjxPX+Sa1Rk8FWrFSPfgZhAuco1HUtG+OxrV3Jm8t5ku4MpFSGrZuwK5DrsgGF0S
	 NePIDn+kHA0lZDIfzhjOf+IolTmmdpOQmCRJ7mQfFaCpkdbRVgdenjQZc2Jf0AkMus
	 CGurMWOE6maqAmucqiwAxbIT6J2AXENUvBLScfig=
Date: Sat, 13 Sep 2025 15:10:39 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-remove-migratepage_unmap-fix.patch removed from -mm tree
Message-Id: <20250913221040.4E415C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm/migrate: remove MIGRATEPAGE_UNMAP
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-migratepage_unmap-fix.patch

This patch was dropped because it was folded into mm-migrate-remove-migratepage_unmap.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/migrate: remove MIGRATEPAGE_UNMAP
Date: Mon, 18 Aug 2025 13:26:05 +0200

no need to pass "reason" to migrate_folio_unmap(), per Lance

Link: https://lkml.kernel.org/r/3bb725f8-28d7-4aa2-b75f-af40d5cab280@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-migratepage_unmap-fix
+++ a/mm/migrate.c
@@ -1189,7 +1189,7 @@ static void migrate_folio_done(struct fo
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		enum migrate_reason reason, struct list_head *ret)
+		struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1876,8 +1876,7 @@ static int migrate_pages_batch(struct li
 			}
 
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, reason,
-					ret_folios);
+					private, folio, &dst, mode, ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,
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

