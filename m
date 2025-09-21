Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B401A9FB9
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 19:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758484376; cv=none; b=YMFfauVmSBUEl5Ed2oWtPUEULei/4WuNWW4DWiSSzzZFO90D0ZoHdJDAlWdonWc5vpJz5RuxfH0eH999FoKoo404PuO4JBysFjUxWv8oWHjjUbrsYQnynb9tkY9FJ4I95IcLgoeKOHHP3y0yfjR3H0PlpIeZWhoM0yeQJ9rxGEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758484376; c=relaxed/simple;
	bh=jV897/fMZgZIFTKSbNkSBMW5ufawTDDhB4wBQwc6aUs=;
	h=Date:To:From:Subject:Message-Id; b=BGHlcs34uIVihEyBkO2lhAzfhgYkJJXfTVj9XXDSW449xnQlkZphuA0hadiUYfRY4vnLIKfN7Faw4GLP8paqafz6STyAnlwIHWhhO0QEcsMFl616D5pAGMq23kpsHJVJseQVO3Ynsi4lzoBIVSyZX3fVPu7l6Q71a+0yGzxg4e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Zcx2U/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Zcx2U/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0A6C4CEE7;
	Sun, 21 Sep 2025 19:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758484375;
	bh=jV897/fMZgZIFTKSbNkSBMW5ufawTDDhB4wBQwc6aUs=;
	h=Date:To:From:Subject:From;
	b=0Zcx2U/W5+NUJJN77nfCVOPVuyDWosF2VoI4TlVaJLVNaXQon7r1TF6WbUuK74xIC
	 Qb64znHYTreNceCXv3NBQLCszR4e1WgmAyHNxGxBpJV2U6HRs4jjX0ddHM7022HKWR
	 ozq0Y8JnfLqKXk7fINqVy8N5eOWn2SuyAp9PHO1s=
Date: Sun, 21 Sep 2025 12:52:55 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,ebiggers@kernel.org,axboe@kernel.dk,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-remove-record_subpages-fix.patch removed from -mm tree
Message-Id: <20250921195255.9D0A6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm/gup: remove record_subpages()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-record_subpages-fix.patch

This patch was dropped because it was folded into mm-gup-remove-record_subpages.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/gup: remove record_subpages()
Date: Fri, 5 Sep 2025 08:38:43 +0200

pages is not adjusted by the caller, but indexed by existing *nr.

Link: https://lkml.kernel.org/r/cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Tested-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Reported-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-remove-record_subpages-fix
+++ a/mm/gup.c
@@ -2979,6 +2979,7 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
@@ -3022,6 +3023,7 @@ static int gup_fast_pud_leaf(pud_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
_

Patches currently in -mm which might be from david@redhat.com are

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

