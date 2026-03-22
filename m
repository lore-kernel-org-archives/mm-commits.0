Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EB81A6814
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 00:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774139855; cv=none; b=khdFfCT46GA5DFNw74oG1QYUDQe2FJk8Txi4zfEIjZqqqMWKTgmPWbPHHEgFQT4ZetFHAf869EqJB/gjrZeuMaeMc/oYpv4HYYyBWfVvdlSDREaAyH0whIuRgQYvqC6iveEHfz+iCd0mSuyeKouI16VM4pE6AjTjYClSjb7ICdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774139855; c=relaxed/simple;
	bh=0Y0Xs0i/ONftHEo4Z5FfecRWNLXTu+2kcwHT5cIghDU=;
	h=Date:To:From:Subject:Message-Id; b=MVNep3dVfw1QKyy8l/P93OQ5rHf0D58gJQr2CVREvYIlRszHr3j8wdNqyG8TAUzD7fXhmRR+FX9Q/J/BI7xDG+hyNV/L2BgNqiRM7bTHXUSfnFgR42pQOopvdp7Q7C5NgONuodDtFox8DVOjFEa1a1g8h31YruckJBAzph5Vpuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bcpdpz31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bcpdpz31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E04CC19421;
	Sun, 22 Mar 2026 00:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774139855;
	bh=0Y0Xs0i/ONftHEo4Z5FfecRWNLXTu+2kcwHT5cIghDU=;
	h=Date:To:From:Subject:From;
	b=Bcpdpz31sxElnLctsgyFkOAfFOw0Kriyt9bSrGjFGh9O3cY7vNRItN7iHjkZ3UbpW
	 tLeUtJbCgyXOKsVY6J3dBqVqBmGT2vJblmn6cVhvSTVhATS1gNRY6+By1RZVPjlJoG
	 3oBlCzDp+pAFRvlDmrVfq4U67yIAa4mRRBZsfQTE=
Date: Sat, 21 Mar 2026 17:37:34 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-add-missing-kunmap_local.patch removed from -mm tree
Message-Id: <20260322003735.1E04CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: add missing kunmap_local()
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-missing-kunmap_local.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/zswap: add missing kunmap_local()
Date: Mon, 16 Mar 2026 14:01:22 +0000

Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
data for uncompressed pages.

In doing so, it mapped kernel memory locally for 32-bit kernels using
kmap_local_folio(), however it never unmapped this memory.

This resulted in the linked syzbot report where a BUG_ON() is triggered
due to leaking the kmap slot.

This patch fixes the issue by explicitly unmapping the established kmap.


Also, add flush_dcache_folio() after the kunmap_local() call

I had assumed that a new folio here combined with the flush that is done at
the point of setting the PTE would suffice, but it doesn't seem that's
actually the case, as update_mmu_cache() will in many archtectures only
actually flush entries where a dcache flush was done on a range previously.

I had also wondered whether kunmap_local() might suffice, but it doesn't
seem to be the case.

Some arches do seem to actually dcache flush on unmap, parisc does it if
CONFIG_HIGHMEM is not set by setting ARCH_HAS_FLUSH_ON_KUNMAP and calling
kunmap_flush_on_unmap() from __kunmap_local(), otherwise non-CONFIG_HIGHMEM
callers do nothing here.

Otherwise arch_kmap_local_pre_unmap() is called which does:

* sparc - flush_cache_all()
* arm - if VIVT, __cpuc_flush_dcache_area()
* otherwise - nothing

Also arch_kmap_local_post_unmap() is called which does:

* arm - local_flush_tlb_kernel_page()
* csky - kmap_flush_tlb()
* microblaze, ppc - local_flush_tlb_page()
* mips - local_flush_tlb_one()
* sparc - flush_tlb_all() (again)
* x86 - arch_flush_lazy_mmu_mode()
* otherwise - nothing

But this is only if it's high memory, and doesn't cover all architectures,
so is presumably intended to handle other cache consistency concerns.

In any case, VIPT is problematic here whether low or high memory (in spite
of what the documentation claims, see [0] - 'the kernel did write to a page
that is in the page cache page and / or in high memory'), because dirty
cache lines may exist at the set indexed by the kernel direct mapping,
which won't exist in the set indexed by any subsequent userland mapping,
meaning userland might read stale data from L2 cache.

Even if the documentation is correct and low memory is fine not to be
flushed here, we can't be sure as to whether the memory is low or high
(kmap_local_folio() will be a no-op if low), and this call should be
harmless if it is low.

VIVT would require more work if the memory were shared and already mapped,
but this isn't the case here, and would anyway be handled by the dcache
flush call.

In any case, we definitely need this flush as far as I can tell.

And we should probably consider updating the documentation unless it turns
out there's somehow dcache synchronisation that happens for low
memory/64-bit kernels elsewhere?

[ljs@kernel.org: add flush_dcache_folio() after the kunmap_local() call]
  Link: https://lkml.kernel.org/r/13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local
Link: https://lkml.kernel.org/r/20260316140122.339697-1-ljs@kernel.org
Link: https://docs.kernel.org/core-api/cachetlb.html [0]
Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-add-missing-kunmap_local
+++ a/mm/zswap.c
@@ -942,9 +942,15 @@ static bool zswap_decompress(struct zswa
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
+		void *dst;
+
 		WARN_ON_ONCE(input->length != PAGE_SIZE);
-		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
+
+		dst = kmap_local_folio(folio, 0);
+		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
+		kunmap_local(dst);
+		flush_dcache_folio(folio);
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch
mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
tools-bitmap-add-missing-bitmap_copy-implementation.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-simplify-vma-flag-tests-of-excluded-flags.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-avoid-deadlock-when-holding-rmap-on-mmap_prepare-error.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch
mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch
mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-revert-mmap_prepare-change.patch
fs-afs-restore-mmap_prepare-implementation.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch
mm-huge_memory-simplify-vma_is_specal_huge.patch
mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch
mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch
mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch
mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch
mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch
mm-huge_memory-deduplicate-zap-deposited-table-call.patch
mm-huge_memory-remove-unnecessary-sanity-checks.patch
mm-huge_memory-use-mm-instead-of-tlb-mm.patch
mm-huge_memory-separate-out-the-folio-part-of-zap_huge_pmd.patch
mm-add-softleaf_is_valid_pmd_entry-pmd_to_softleaf_folio.patch
mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd.patch
mm-huge_memory-add-and-use-has_deposited_pgtable.patch

