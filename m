Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C4E2F0670
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757547437; cv=none; b=PGbVZSlumzV7G4Z6zHMEW6nQ3mNUbc8Nl70pGMg9rf3YRPzTxey+/EMAJdtpWbsr6x6M7hd5IegWRiuiwAEQ+eLmo8VRzIiHdP1Zfh52Exds3yoj+OogoT9QRWrMnLDgqpCYGRrL6kuvk6/ZxvUHA/1ZmZhfmxADYx2C8+Z2d0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757547437; c=relaxed/simple;
	bh=9RkIZBoI7jhoiKwChJFJ0HjPG1tuW0u4l4bvOC8TQ6c=;
	h=Date:To:From:Subject:Message-Id; b=sv/H2qMFWYceymKzOFuanqg3bdVJ+ysQLSWvRz8dLp5JPqaxHQ/8+4vW6YtLWQ/Ka34obA8tl6s53lKL+2WPy49/X9JXicKkP17t++ffg9LPhT837Kg1p/doq4AIDFgPEaZvHHZLOYhiURyKK1WT91Sh7Z1795YL5HCMpJwje5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VdzAwNuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VdzAwNuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF7FC4CEEB;
	Wed, 10 Sep 2025 23:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757547437;
	bh=9RkIZBoI7jhoiKwChJFJ0HjPG1tuW0u4l4bvOC8TQ6c=;
	h=Date:To:From:Subject:From;
	b=VdzAwNuMSt6fv2n3uC0d2rw1VugcAXFsrrhZgdv+daoiBBSYcLv0ddP07CdcKrMtH
	 KNyKPvQkXwoxHLbBcR488Zc0iPhLZ52eQAmQX4SuVCiDlcScktAErY4ENEo+wLeNTX
	 4jLG+G/Xi1sBvYRU4zLqI/3ywkQkcvezK2RUE7ns=
Date: Wed, 10 Sep 2025 16:37:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch added to mm-new branch
Message-Id: <20250910233717.3EF7FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: gup_tests: option to GUP all pages in a single call
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call.patch

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
Subject: selftests/mm: gup_tests: option to GUP all pages in a single call
Date: Wed, 10 Sep 2025 11:30:51 +0200

We recently missed detecting an issue during early testing because the
default (!all) tests would not trigger it and even when running "all"
tests it only would happen sometimes because of races.

So let's allow for an easy way to specify "GUP all pages in a single
call", extend the test matrix and extend our default (!all) tests.

By GUP'ing all pages in a single call, with the default size of 128MiB
we'll cover multiple leaf page tables / PMDs on architectures with sane
THP sizes.

Link: https://lkml.kernel.org/r/20250910093051.1693097-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_test.c     |    2 ++
 tools/testing/selftests/mm/run_vmtests.sh |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/gup_test.c~selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call
+++ a/tools/testing/selftests/mm/gup_test.c
@@ -139,6 +139,8 @@ int main(int argc, char **argv)
 			break;
 		case 'n':
 			nr_pages = atoi(optarg);
+			if (nr_pages < 0)
+				nr_pages = size / psize();
 			break;
 		case 't':
 			thp = 1;
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-gup_tests-option-to-gup-all-pages-in-a-single-call
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -138,7 +138,7 @@ run_gup_matrix() {
                     # -n: How many pages to fetch together?  512 is special
                     # because it's default thp size (or 2M on x86), 123 to
                     # just test partial gup when hit a huge in whatever form
-                    for num in "-n 1" "-n 512" "-n 123"; do
+                    for num in "-n 1" "-n 512" "-n 123" "-n -1"; do
                         CATEGORY="gup_test" run_test ./gup_test \
                                 $huge $test_cmd $write $share $num
                     done
@@ -314,9 +314,11 @@ if $RUN_ALL; then
     run_gup_matrix
 else
     # get_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -u
+    CATEGORY="gup_test" run_test ./gup_test -u -n 1
+    CATEGORY="gup_test" run_test ./gup_test -u -n -1
     # pin_user_pages_fast() benchmark
-    CATEGORY="gup_test" run_test ./gup_test -a
+    CATEGORY="gup_test" run_test ./gup_test -a -n 1
+    CATEGORY="gup_test" run_test ./gup_test -a -n -1
 fi
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
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

