Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F144A482EB
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 02:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757124603; cv=none; b=AB6d0WlaaVaM2PDMvZJz+iMvvqTz1Aq1Ls7KEOYJfh0doO7zic9RDEi5XmVSaVo2IoLTFng2q8CWvJS9I/qKIkp8PAM4mZ1axBPRwbHYdh1qXw95YNJS6bbrjgnYqimRpNZZBLZtsOAbPN8XggORePt36tjaTiBpja9x/mKNTvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757124603; c=relaxed/simple;
	bh=jr6doM9/dhU187xx1xO92Sas6PHpRsQKYM8QrsHuKt4=;
	h=Date:To:From:Subject:Message-Id; b=Z2FGf3isfmYYnYQB74Jmln3AFHtjgBN4jhmz9rEzAwJL1fLJ5gnGTcaHs8gV1YzXWkLoStgEApqoHNWrnHadCkvliHrpWwJlsd6E0IsI0E5qlWjZsxs4kc0A/39p96J34uhSmW5pTfeFTQPB6aJXqYKGaE4YPQXAa3OQyyYeEBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y2/TDMjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y2/TDMjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF99C4CEF1;
	Sat,  6 Sep 2025 02:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757124602;
	bh=jr6doM9/dhU187xx1xO92Sas6PHpRsQKYM8QrsHuKt4=;
	h=Date:To:From:Subject:From;
	b=y2/TDMjsa0QWPcKBb+gMkGrcj61VSoWv5oYtw9LGGRg1W+asDYJ3w6WHK3Hy6Yp1P
	 3E3G5gbCq/9YFzCU/tedSo+lcC1PfIl+8swsCqtf4iq97cJS6211AwHtsajG11O10y
	 R3RsX7hdv5Kpjs7UgR3C3C31N6msgAzitoWNe70I=
Date: Fri, 05 Sep 2025 19:10:01 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,ebiggers@kernel.org,axboe@kernel.dk,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-record_subpages-fix.patch added to mm-unstable branch
Message-Id: <20250906021002.6BF99C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: mm/gup: remove record_subpages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-record_subpages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-record_subpages-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2975,6 +2975,7 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
@@ -3018,6 +3019,7 @@ static int gup_fast_pud_leaf(pud_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
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
mm-gup-remove-record_subpages-fix.patch
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
selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch
selftests-mm-split_huge_page_test-cleanups-for-split_pte_mapped_thp-test.patch

