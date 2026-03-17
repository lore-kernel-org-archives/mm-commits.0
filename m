Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0172D0C72
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770581; cv=none; b=arsgKkNFdo4yT3Xjkr+m7NHmCiTxQ8HzCZ3KagSApmanzcW2zhfAWoNzlDS/qRpZVejQc66vJ9x7PtJG2WwOuPnAZOeWR5Q5jBtJhPOWanI74XRGCOK0ZtgpkBRhp9s2AmbWLg51h+vDdHiOIo6PyESM9GU3dW0xv8MxkBT2KoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770581; c=relaxed/simple;
	bh=baVwIhMmJ7QphuNDUqOsTpZHFYejqi7RIbBCj60uy3M=;
	h=Date:To:From:Subject:Message-Id; b=MyFL2ZYpOFnOU7Py7wNWUQU71du6qfXmA8fE1sodoPV6fTbYuJt3PH9uIivmc0ySck+WyVr/93DObty5Y/DTmPdUoXOb6q8aqRzLfDYnORctPDna4Uxrtp8R6vx8icIN38IBa8Sbz3IbD801bTBtvEKLw9IgEtTT1apnTWrktrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yokZlOHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yokZlOHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7508C4CEF7;
	Tue, 17 Mar 2026 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773770580;
	bh=baVwIhMmJ7QphuNDUqOsTpZHFYejqi7RIbBCj60uy3M=;
	h=Date:To:From:Subject:From;
	b=yokZlOHkdnwql+GkHbiKM58ETRoNvzJICuCOBNJ1ciFcG4ORZXf3w2HaP0YINTDW6
	 9wVAhhh0OSvdDV7oABtmzsU4JlSMva0Cb5fmW43ZEPgtGqEfRYuPZHsyO2OGEe5FoD
	 yBw15B0o1D4nQrzaXYzaJsnfwwjcxPu2QK77Tt4E=
Date: Tue, 17 Mar 2026 11:03:00 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-missing-kunmap_local-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260317180300.A7508C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zswap-add-missing-kunmap_local-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-add-missing-kunmap_local-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-missing-kunmap_local-fix.patch

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm-zswap-add-missing-kunmap_local-fix
Date: Tue, 17 Mar 2026 12:29:55 +0000

add flush_dcache_folio() after the kunmap_local() call

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

Link: https://lkml.kernel.org/r/13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local
Link: https://docs.kernel.org/core-api/cachetlb.html [0]
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-add-missing-kunmap_local-fix
+++ a/mm/zswap.c
@@ -950,6 +950,7 @@ static bool zswap_decompress(struct zswa
 		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
 		kunmap_local(dst);
+		flush_dcache_folio(folio);
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-zswap-add-missing-kunmap_local.patch
mm-zswap-add-missing-kunmap_local-fix.patch
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
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-correctly-drop-reference-count-on-mapping-failure.patch
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

