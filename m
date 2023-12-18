Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883015BF90
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OPSUCeCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3798C433C8;
	Mon, 18 Dec 2023 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920193;
	bh=iY1GMGEEoxgK7INYnw1F/7WvyNJOKi7uMOo3QQCHiLk=;
	h=Date:To:From:Subject:From;
	b=OPSUCeCW3KBP0BkA0vsEPi/mVNJFC5A3hk76PfWc6BT0nA0+g8gpgJVXwmEe+XXYH
	 VWHNAuArJbwk0Vxxn1dEcfe7jWQMXPBqNOpO3FhyAnU6/WuISw9Su8HsynS0NzXhGK
	 Fa3mttXg4+QNP7DmJsJfx+LQOj6PXhVYVLT7G/30=
Date: Mon, 18 Dec 2023 09:23:12 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-batch-clear-pte-ranges-during-zap_pte_range.patch added to mm-unstable branch
Message-Id: <20231218172312.E3798C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: batch-clear PTE ranges during zap_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-batch-clear-pte-ranges-during-zap_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-batch-clear-pte-ranges-during-zap_pte_range.patch

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
Subject: mm: batch-clear PTE ranges during zap_pte_range()
Date: Mon, 18 Dec 2023 10:50:47 +0000

Convert zap_pte_range() to copy a batch of ptes in one go.  A given batch
is determined by the architecture (see pte_batch_remaining()), and maps a
physically contiguous block of memory, all belonging to the same folio.  A
pte batch is cleared using the new helper, clear_ptes().

The primary motivation for this change is to reduce the number of tlb
maintenance operations that the arm64 backend has to perform during exit
and other syscalls that cause zap_pte_range() (e.g.  munmap,
madvise(DONTNEED), etc.), as it is about to add transparent support for
the "contiguous bit" in its ptes.  By clearing ptes using the new
clear_ptes() API, the backend doesn't have to perform an expensive unfold
operation when a PTE being cleared is part of a contpte block.  Instead it
can just clear the whole block immediately.

This code is very performance sensitive, and a significant amount of
effort has been put into not regressing performance for the order-0 folio
case.  By default, pte_batch_remaining() always returns 1, which enables
the compiler to simplify the extra loops that are added for batching and
produce code that is equivalent (and equally performant) as the previous
implementation.

This change addresses the core-mm refactoring only, and introduces
clear_ptes() with a default implementation that calls
ptep_get_and_clear_full() for each pte in the range.  Note that this API
returns the pte at the beginning of the batch, but with the dirty and
young bits set if ANY of the ptes in the cleared batch had those bits set;
this information is applied to the folio by the core-mm.  Given the batch
is guaranteed to cover only a single folio, collapsing this state does not
lose any useful information.

A separate change will implement clear_ptes() in the arm64 backend to
realize the performance improvement as part of the work to enable contpte
mappings.

The following microbenchmark results demonstate that there is no
madvise(dontneed) performance regression (and actually an improvement in
some cases) after this patch.  madvise(dontneed) is called for each page
of a 1G populated mapping and the total time is measured.  100 iterations
per run, 8 runs performed on both Apple M2 (VM) and Ampere Altra (bare
metal).  Tests performed for case where 1G memory is comprised of order-0
folios and case where comprised of pte-mapped order-9 folios.  Negative is
faster, positive is slower, compared to baseline upon which the series is
based:

| Apple M2 VM   | order-0 (pte-map) | order-9 (pte-map) |
| dontneed      |-------------------|-------------------|
| microbench    |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|
| baseline      |    0.0% |    7.5% |    0.0% |    7.9% |
| after-change  |   -9.6% |    3.1% |   -4.9% |    8.1% |

| Ampere Altra  | order-0 (pte-map) | order-9 (pte-map) |
| dontneed      |-------------------|-------------------|
| microbench    |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|
| baseline      |    0.0% |    0.1% |    0.0% |    0.0% |
| after-change  |   -0.2% |    0.1% |   -0.1% |    0.0% |

The following microbenchmark results demonstate that there is no munmap
performance regression (and actually an improvement in some cases) after
this patch.  munmap is called for a 1G populated mapping and the time to
execute the function is measured.  100 iterations per run, 8 runs
performed on both Apple M2 (VM) and Ampere Altra (bare metal).  Tests
performed for case where 1G memory is comprised of order-0 folios and case
where comprised of pte-mapped order-9 folios.  Negative is faster,
positive is slower, compared to baseline upon which the series is based:

| Apple M2 VM   | order-0 (pte-map) | order-9 (pte-map) |
| munmap        |-------------------|-------------------|
| microbench    |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|
| baseline      |    0.0% |    3.8% |    0.0% |    6.4% |
| after-change  |   -1.9% |    0.2% |   -4.7% |    0.8% |

| Ampere Altra  | order-0 (pte-map) | order-9 (pte-map) |
| munmap        |-------------------|-------------------|
| microbench    |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|
| baseline      |    0.0% |    0.9% |    0.0% |    0.1% |
| after-change  |   -0.2% |    0.6% |   -3.2% |    0.2% |

Link: https://lkml.kernel.org/r/20231218105100.172635-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
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

 include/asm-generic/tlb.h |   11 ++++++
 include/linux/pgtable.h   |   43 ++++++++++++++++++++++++
 mm/memory.c               |   64 +++++++++++++++++++++++++-----------
 mm/mmu_gather.c           |   15 ++++++++
 4 files changed, 115 insertions(+), 18 deletions(-)

--- a/include/asm-generic/tlb.h~mm-batch-clear-pte-ranges-during-zap_pte_range
+++ a/include/asm-generic/tlb.h
@@ -75,6 +75,10 @@
  *    boolean indicating if the queue is (now) full and a call to
  *    tlb_flush_mmu() is required.
  *
+ *    tlb_reserve_space() attempts to preallocate space for nr pages and returns
+ *    the minimum garanteed number of pages that can be queued without overflow,
+ *    which may be more or less than requested.
+ *
  *    tlb_remove_page() and tlb_remove_page_size() imply the call to
  *    tlb_flush_mmu() when required and has no return value.
  *
@@ -263,6 +267,7 @@ struct mmu_gather_batch {
 extern bool __tlb_remove_page_size(struct mmu_gather *tlb,
 				   struct encoded_page *page,
 				   int page_size);
+extern unsigned int tlb_reserve_space(struct mmu_gather *tlb, unsigned int nr);
 
 #ifdef CONFIG_SMP
 /*
@@ -273,6 +278,12 @@ extern bool __tlb_remove_page_size(struc
 extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
 #endif
 
+#else
+static inline unsigned int tlb_reserve_space(struct mmu_gather *tlb,
+					     unsigned int nr)
+{
+	return 1;
+}
 #endif
 
 /*
--- a/include/linux/pgtable.h~mm-batch-clear-pte-ranges-during-zap_pte_range
+++ a/include/linux/pgtable.h
@@ -601,6 +601,49 @@ static inline pte_t ptep_get_and_clear_f
 }
 #endif
 
+#ifndef clear_ptes
+struct mm_struct;
+/**
+ * clear_ptes - Clear a consecutive range of ptes and return the previous value.
+ * @mm: Address space that the ptes map.
+ * @address: Address corresponding to the first pte to clear.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of ptes to clear.
+ * @full: True if systematically clearing all ptes for the address space.
+ *
+ * A batched version of ptep_get_and_clear_full(), which returns the old pte
+ * value for the first pte in the range, but with young and/or dirty set if any
+ * of the ptes in the range were young or dirty.
+ *
+ * May be overridden by the architecture, else implemented as a loop over
+ * ptep_get_and_clear_full().
+ *
+ * Context: The caller holds the page table lock. The PTEs are all in the same
+ * PMD.
+ */
+static inline pte_t clear_ptes(struct mm_struct *mm,
+				unsigned long address, pte_t *ptep,
+				unsigned int nr, int full)
+{
+	unsigned int i;
+	pte_t pte;
+	pte_t orig_pte = ptep_get_and_clear_full(mm, address, ptep, full);
+
+	for (i = 1; i < nr; i++) {
+		address += PAGE_SIZE;
+		ptep++;
+		pte = ptep_get_and_clear_full(mm, address, ptep, full);
+
+		if (pte_dirty(pte))
+			orig_pte = pte_mkdirty(orig_pte);
+
+		if (pte_young(pte))
+			orig_pte = pte_mkyoung(orig_pte);
+	}
+
+	return orig_pte;
+}
+#endif
 
 /*
  * If two threads concurrently fault at the same page, the thread that
--- a/mm/memory.c~mm-batch-clear-pte-ranges-during-zap_pte_range
+++ a/mm/memory.c
@@ -1447,6 +1447,7 @@ static unsigned long zap_pte_range(struc
 	pte_t *start_pte;
 	pte_t *pte;
 	swp_entry_t entry;
+	int nr;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	init_rss_vec(rss);
@@ -1459,6 +1460,9 @@ static unsigned long zap_pte_range(struc
 	do {
 		pte_t ptent = ptep_get(pte);
 		struct page *page;
+		int i;
+
+		nr = 1;
 
 		if (pte_none(ptent))
 			continue;
@@ -1467,43 +1471,67 @@ static unsigned long zap_pte_range(struc
 			break;
 
 		if (pte_present(ptent)) {
-			unsigned int delay_rmap;
+			unsigned int delay_rmap = 0;
+			struct folio *folio;
+			bool full = false;
+
+			/*
+			 * tlb_gather always has at least one slot so avoid call
+			 * to tlb_reserve_space() when pte_batch_remaining() is
+			 * a compile-time constant 1 (default).
+			 */
+			nr = pte_batch_remaining(ptent, addr, end);
+			if (unlikely(nr > 1))
+				nr = min_t(int, nr, tlb_reserve_space(tlb, nr));
 
 			page = vm_normal_page(vma, addr, ptent);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
-			ptent = ptep_get_and_clear_full(mm, addr, pte,
-							tlb->fullmm);
+			ptent = clear_ptes(mm, addr, pte, nr, tlb->fullmm);
 			arch_check_zapped_pte(vma, ptent);
-			tlb_remove_tlb_entry(tlb, pte, addr);
-			zap_install_uffd_wp_if_needed(vma, addr, pte, details,
-						      ptent);
+
+			for (i = 0; i < nr; i++) {
+				unsigned long subaddr = addr + PAGE_SIZE * i;
+
+				tlb_remove_tlb_entry(tlb, &pte[i], subaddr);
+				zap_install_uffd_wp_if_needed(vma, subaddr,
+						&pte[i], details, ptent);
+			}
 			if (unlikely(!page)) {
 				ksm_might_unmap_zero_page(mm, ptent);
 				continue;
 			}
 
-			delay_rmap = 0;
-			if (!PageAnon(page)) {
+			folio = page_folio(page);
+			if (!folio_test_anon(folio)) {
 				if (pte_dirty(ptent)) {
-					set_page_dirty(page);
+					folio_mark_dirty(folio);
 					if (tlb_delay_rmap(tlb)) {
 						delay_rmap = 1;
 						force_flush = 1;
 					}
 				}
 				if (pte_young(ptent) && likely(vma_has_recency(vma)))
-					mark_page_accessed(page);
+					folio_mark_accessed(folio);
 			}
-			rss[mm_counter(page)]--;
-			if (!delay_rmap) {
-				page_remove_rmap(page, vma, false);
-				if (unlikely(page_mapcount(page) < 0))
-					print_bad_pte(vma, addr, ptent, page);
+			rss[mm_counter(page)] -= nr;
+			for (i = 0; i < nr; i++, page++) {
+				if (!delay_rmap) {
+					page_remove_rmap(page, vma, false);
+					if (unlikely(page_mapcount(page) < 0))
+						print_bad_pte(vma, addr, ptent, page);
+				}
+
+				/*
+				 * nr calculated based on available space, so
+				 * can only be full on final iteration.
+				 */
+				VM_WARN_ON(full);
+				full = __tlb_remove_page(tlb, page, delay_rmap);
 			}
-			if (unlikely(__tlb_remove_page(tlb, page, delay_rmap))) {
+			if (unlikely(full)) {
 				force_flush = 1;
-				addr += PAGE_SIZE;
+				addr += PAGE_SIZE * nr;
 				break;
 			}
 			continue;
@@ -1557,7 +1585,7 @@ static unsigned long zap_pte_range(struc
 		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 		zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
 	add_mm_rss_vec(mm, rss);
 	arch_leave_lazy_mmu_mode();
--- a/mm/mmu_gather.c~mm-batch-clear-pte-ranges-during-zap_pte_range
+++ a/mm/mmu_gather.c
@@ -47,6 +47,21 @@ static bool tlb_next_batch(struct mmu_ga
 	return true;
 }
 
+unsigned int tlb_reserve_space(struct mmu_gather *tlb, unsigned int nr)
+{
+	struct mmu_gather_batch *batch = tlb->active;
+	unsigned int nr_alloc = batch->max - batch->nr;
+
+	while (nr_alloc < nr) {
+		if (!tlb_next_batch(tlb))
+			break;
+		nr_alloc += tlb->active->max;
+	}
+
+	tlb->active = batch;
+	return nr_alloc;
+}
+
 #ifdef CONFIG_SMP
 static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_struct *vma)
 {
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

