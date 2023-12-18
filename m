Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0C71DA2F
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="emEu83ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B546C433C8;
	Mon, 18 Dec 2023 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920188;
	bh=AKIiBY1oOTWK1m/JIr3LZJhT+niKg+WTd6tM6svvgd8=;
	h=Date:To:From:Subject:From;
	b=emEu83garuYE7nuVh2QvnGmef4Nv0jet2QpvmEXBnkN3m7mYl8CET/oVMkYG0uER+
	 XVDjtE7YKvv9AmobnbBTQ2e0vN//Spm3k4ikmxAZvuBR0zV7m6d6/ZzqMvF8l8eoIn
	 pUyALQ8sSBaxcV7yDxDjbYdVqL4txO5Gv7/A4r6c=
Date: Mon, 18 Dec 2023 09:23:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-batch-collapse-pmd-with-set_ptes.patch added to mm-unstable branch
Message-Id: <20231218172308.0B546C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: batch-collapse PMD with set_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-batch-collapse-pmd-with-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-batch-collapse-pmd-with-set_ptes.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: batch-collapse PMD with set_ptes()
Date: Mon, 18 Dec 2023 10:50:45 +0000

Patch series "Transparent Contiguous PTEs for User Mappings", v4.

This is a series to opportunistically and transparently use contpte
mappings (set the contiguous bit in ptes) for user memory when those
mappings meet the requirements.  It is part of a wider effort to improve
performance by allocating and mapping variable-sized blocks of memory
(folios).  One aim is for the 4K kernel to approach the performance of the
16K kernel, but without breaking compatibility and without the associated
increase in memory.  Another aim is to benefit the 16K and 64K kernels by
enabling 2M THP, since this is the contpte size for those kernels.  We
have good performance data that demonstrates both aims are being met (see
below).

Of course this is only one half of the change.  We require the mapped
physical memory to be the correct size and alignment for this to actually
be useful (i.e.  64K for 4K pages, or 2M for 16K/64K pages).  Fortunately
folios are solving this problem for us.  Filesystems that support it (XFS,
AFS, EROFS, tmpfs, ...) will allocate large folios up to the PMD size
today, and more filesystems are coming.  And the other half of my work, to
enable "multi-size THP" (large folios) for anonymous memory, makes contpte
sized folios prevalent for anonymous memory too [4].

Note that the first 3 patchs are for core-mm and provides the refactoring
to make some crucial optimizations possible - which are then implemented
in patches 15 and 16.  The remaining patches are arm64-specific.


Testing
=======

I've tested this series together with multi-size THP [4] on both Ampere Altra
(bare metal) and Apple M2 (VM):
  - mm selftests (inc new tests written for multi-size THP); no regressions
  - Speedometer Java script benchmark in Chromium web browser; no issues
  - Kernel compilation; no issues
  - Various tests under high memory pressure with swap enabled; no issues


Performance
===========

High Level Use Cases
~~~~~~~~~~~~~~~~~~~~

First some high level use cases (kernel compilation and speedometer JavaScript
benchmarks). These are running on Ampere Altra (I've seen similar improvements
on Android/Pixel 6).

baseline:                  mm-unstable (inc mTHP but switched off)
mTHP:                      enable 16K, 32K, 64K mTHP sizes "always"
mTHP + contpte:            + this series
mTHP + contpte + exefolio: + poc patch to always read executable memory from
                           file into 64K folio to enable contpte-mapping the
			   text

Kernel Compilation with -j8 (negative is faster):

| kernel                    | real-time | kern-time | user-time |
|---------------------------|-----------|-----------|-----------|
| baseline                  |      0.0% |      0.0% |      0.0% |
| mTHP                      |     -4.6% |    -38.0% |     -0.4% |
| mTHP + contpte            |     -5.4% |    -37.7% |     -1.3% |
| mTHP + contpte + exefolio |     -7.4% |    -39.5% |     -3.5% |

Kernel Compilation with -j80 (negative is faster):

| kernel                    | real-time | kern-time | user-time |
|---------------------------|-----------|-----------|-----------|
| baseline                  |      0.0% |      0.0% |      0.0% |
| mTHP                      |     -4.9% |    -36.1% |     -0.2% |
| mTHP + contpte            |     -5.8% |    -36.0% |     -1.2% |
| mTHP + contpte + exefolio |     -6.8% |    -37.0% |     -3.1% |

Speedometer (positive is faster):

| kernel                    | runs_per_min |
|:--------------------------|--------------|
| baseline                  |         0.0% |
| mTHP                      |         1.5% |
| mTHP + contpte            |         3.7% |
| mTHP + contpte + exefolio |         4.9% |

Micro Benchmarks
~~~~~~~~~~~~~~~~

Additionally for this version, I've done a significant amount of
microbenchmarking (and fixes!) to ensure the performance of fork(),
madvise(DONTNEED) and munmap() do not regress. Thanks to David for sharing his
benchmarks.

baseline:                  mm-unstable (inc mTHP but switched off)
contpte-dis:               + this series with ARM64_CONTPTE disabled at
                           compile-time (to show impact of the core-mm changes)
contpte-ena:               + ARM64_CONTPTE enabled at compile-time (to show
                           impact of arm64-specific changes)

I'm showing the collated results summary here. See individual patch commit logs
for commentary:

| Apple M2 VM   |       fork        |      dontneed     |       munmap      |
| order-0       |-------------------|-------------------|-------------------|
| (pte-map)     |    mean |   stdev |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|---------|---------|
| baseline      |    0.0% |    1.1% |    0.0% |    7.5% |    0.0% |    3.8% |
| contpte-dis   |   -1.0% |    2.0% |   -9.6% |    3.1% |   -1.9% |    0.2% |
| contpte-ena   |    2.6% |    1.7% |  -10.2% |    1.6% |    1.9% |    0.7% |

| Apple M2 VM   |       fork        |      dontneed     |       munmap      |
| order-9       |-------------------|-------------------|-------------------|
| (pte-map)     |    mean |   stdev |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|---------|---------|
| baseline      |    0.0% |    1.2% |    0.0% |    7.9% |    0.0% |    6.4% |
| contpte-dis   |   -0.1% |    1.1% |   -4.9% |    8.1% |   -4.7% |    0.8% |
| contpte-ena   |  -25.4% |    1.9% |   -9.9% |    0.9% |   -6.0% |    1.4% |

| Ampere Altra  |       fork        |      dontneed     |       munmap      |
| order-0       |-------------------|-------------------|-------------------|
| (pte-map)     |    mean |   stdev |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|---------|---------|
| baseline      |    0.0% |    1.0% |    0.0% |    0.1% |    0.0% |    0.9% |
| contpte-dis   |   -0.1% |    1.2% |   -0.2% |    0.1% |   -0.2% |    0.6% |
| contpte-ena   |    1.8% |    0.7% |    1.3% |    0.0% |    2.0% |    0.4% |

| Ampere Altra  |       fork        |      dontneed     |       munmap      |
| order-9       |-------------------|-------------------|-------------------|
| (pte-map)     |    mean |   stdev |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|---------|---------|
| baseline      |    0.0% |    0.1% |    0.0% |    0.0% |    0.0% |    0.1% |
| contpte-dis   |   -0.1% |    0.1% |   -0.1% |    0.0% |   -3.2% |    0.2% |
| contpte-ena   |   -6.7% |    0.1% |   14.1% |    0.0% |   -0.6% |    0.2% |

Misc
~~~~

John Hubbard at Nvidia has indicated dramatic 10x performance improvements for
some workloads at [5], when using 64K base page kernel.

[1] https://lore.kernel.org/linux-arm-kernel/20230622144210.2623299-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20231115163018.1303287-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/linux-arm-kernel/20231204105440.61448-1-ryan.roberts@arm.com/
[4] https://lore.kernel.org/linux-arm-kernel/20231204102027.57185-1-ryan.roberts@arm.com/
[5] https://lore.kernel.org/linux-mm/c507308d-bdd4-5f9e-d4ff-e96e4520be85@nvidia.com/


This patch (of 16)L

Refactor __split_huge_pmd_locked() so that a present PMD can be collapsed
to PTEs in a single batch using set_ptes().  It also provides a future
opportunity to batch-add the folio to the rmap using David's new batched
rmap APIs.

This should improve performance a little bit, but the real motivation is
to remove the need for the arm64 backend to have to fold the contpte
entries.  Instead, since the ptes are set as a batch, the contpte blocks
can be initially set up pre-folded (once the arm64 contpte support is
added in the next few patches).  This leads to noticeable performance
improvement during split.

Link: https://lkml.kernel.org/r/20231218105100.172635-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20231218105100.172635-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   59 +++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~mm-thp-batch-collapse-pmd-with-set_ptes
+++ a/mm/huge_memory.c
@@ -2535,15 +2535,16 @@ static void __split_huge_pmd_locked(stru
 
 	pte = pte_offset_map(&_pmd, haddr);
 	VM_BUG_ON(!pte);
-	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-		pte_t entry;
-		/*
-		 * Note that NUMA hinting access restrictions are not
-		 * transferred to avoid any possibility of altering
-		 * permissions across VMAs.
-		 */
-		if (freeze || pmd_migration) {
+
+	/*
+	 * Note that NUMA hinting access restrictions are not transferred to
+	 * avoid any possibility of altering permissions across VMAs.
+	 */
+	if (freeze || pmd_migration) {
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			pte_t entry;
 			swp_entry_t swp_entry;
+
 			if (write)
 				swp_entry = make_writable_migration_entry(
 							page_to_pfn(page + i));
@@ -2562,28 +2563,36 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_swp_mkuffd_wp(entry);
-		} else {
-			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
-			if (write)
-				entry = pte_mkwrite(entry, vma);
+
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
+		}
+	} else {
+		pte_t entry;
+
+		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		if (write)
+			entry = pte_mkwrite(entry, vma);
+		if (!young)
+			entry = pte_mkold(entry);
+		/* NOTE: this may set soft-dirty too on some archs */
+		if (dirty)
+			entry = pte_mkdirty(entry);
+		if (soft_dirty)
+			entry = pte_mksoft_dirty(entry);
+		if (uffd_wp)
+			entry = pte_mkuffd_wp(entry);
+
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			if (anon_exclusive)
 				SetPageAnonExclusive(page + i);
-			if (!young)
-				entry = pte_mkold(entry);
-			/* NOTE: this may set soft-dirty too on some archs */
-			if (dirty)
-				entry = pte_mkdirty(entry);
-			if (soft_dirty)
-				entry = pte_mksoft_dirty(entry);
-			if (uffd_wp)
-				entry = pte_mkuffd_wp(entry);
 			page_add_anon_rmap(page + i, vma, addr, RMAP_NONE);
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 		}
-		VM_BUG_ON(!pte_none(ptep_get(pte)));
-		set_pte_at(mm, addr, pte, entry);
-		pte++;
+
+		set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
 	}
-	pte_unmap(pte - 1);
+	pte_unmap(pte);
 
 	if (!pmd_migration)
 		page_remove_rmap(page, vma, true);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-batch-copy-pte-ranges-during-fork.patch
mm-batch-clear-pte-ranges-during-zap_pte_range.patch
arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
arm64-mm-set_ptes-set_pte_at-new-layer-to-manage-contig-bit.patch
arm64-mm-pte_clear-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_get_and_clear-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_clear_flush_young-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_set_wrprotect-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_set_access_flags-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_get-new-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-helpers-to-optimize-fork.patch
arm64-mm-implement-clear_ptes-to-optimize-exit-munmap-dontneed.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

