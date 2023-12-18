Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7475BFAC
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mKod8CRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CA7C433C8;
	Mon, 18 Dec 2023 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920190;
	bh=yUH0+3p3KpcvYck6bdViLLzDVPgIFsVkOb1R7fxFofY=;
	h=Date:To:From:Subject:From;
	b=mKod8CRLkMoBDDqbvTWLxt8+UdaNb8dqujCtD8Zj77Qga/CBIZDGuesV6MEMw7iUi
	 Lr3YK+lGkuMs10xuHus0BLiVIYzPSqeDxXhGsiC72nRvl7+ydYU8wOWCNCyEvL4BP3
	 MvLvuusewn44dRtcWrfoIw6dmYBjXKVkjKzYGQLQ=
Date: Mon, 18 Dec 2023 09:23:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-batch-copy-pte-ranges-during-fork.patch added to mm-unstable branch
Message-Id: <20231218172310.47CA7C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: batch-copy PTE ranges during fork()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-batch-copy-pte-ranges-during-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-batch-copy-pte-ranges-during-fork.patch

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
Subject: mm: batch-copy PTE ranges during fork()
Date: Mon, 18 Dec 2023 10:50:46 +0000

Convert copy_pte_range() to copy a batch of ptes in one go.  A given batch
is determined by the architecture with the new helper,
pte_batch_remaining(), and maps a physically contiguous block of memory,
all belonging to the same folio.  A pte batch is then write-protected in
one go in the parent using the new helper, ptep_set_wrprotects() and is
set in one go in the child using the new helper, set_ptes_full().

The primary motivation for this change is to reduce the number of tlb
maintenance operations that the arm64 backend has to perform during fork,
as it is about to add transparent support for the "contiguous bit" in its
ptes.  By write-protecting the parent using the new ptep_set_wrprotects()
(note the 's' at the end) function, the backend can avoid having to unfold
contig ranges of PTEs, which is expensive, when all ptes in the range are
being write-protected.  Similarly, by using set_ptes_full() rather than
set_pte_at() to set up ptes in the child, the backend does not need to
fold a contiguous range once they are all populated - they can be
initially populated as a contiguous range in the first place.

This code is very performance sensitive, and a significant amount of
effort has been put into not regressing performance for the order-0 folio
case.  By default, pte_batch_remaining() is compile constant 1, which
enables the compiler to simplify the extra loops that are added for
batching and produce code that is equivalent (and equally performant) as
the previous implementation.

This change addresses the core-mm refactoring only and a separate change
will implement pte_batch_remaining(), ptep_set_wrprotects() and
set_ptes_full() in the arm64 backend to realize the performance
improvement as part of the work to enable contpte mappings.

To ensure the arm64 is performant once implemented, this change is very
careful to only call ptep_get() once per pte batch.

The following microbenchmark results demonstate that there is no
significant performance change after this patch.  Fork is called in a
tight loop in a process with 1G of populated memory and the time for the
function to execute is measured.  100 iterations per run, 8 runs performed
on both Apple M2 (VM) and Ampere Altra (bare metal).  Tests performed for
case where 1G memory is comprised of order-0 folios and case where
comprised of pte-mapped order-9 folios.  Negative is faster, positive is
slower, compared to baseline upon which the series is based:

| Apple M2 VM   | order-0 (pte-map) | order-9 (pte-map) |
| fork          |-------------------|-------------------|
| microbench    |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|
| baseline      |    0.0% |    1.1% |    0.0% |    1.2% |
| after-change  |   -1.0% |    2.0% |   -0.1% |    1.1% |

| Ampere Altra  | order-0 (pte-map) | order-9 (pte-map) |
| fork          |-------------------|-------------------|
| microbench    |    mean |   stdev |    mean |   stdev |
|---------------|---------|---------|---------|---------|
| baseline      |    0.0% |    1.0% |    0.0% |    0.1% |
| after-change  |   -0.1% |    1.2% |   -0.1% |    0.1% |

Link: https://lkml.kernel.org/r/20231218105100.172635-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
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

 include/linux/pgtable.h |   80 +++++++++++++++++++++++++++++++++
 mm/memory.c             |   92 ++++++++++++++++++++++++--------------
 2 files changed, 139 insertions(+), 33 deletions(-)

--- a/include/linux/pgtable.h~mm-batch-copy-pte-ranges-during-fork
+++ a/include/linux/pgtable.h
@@ -205,6 +205,27 @@ static inline int pmd_young(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
+#ifndef pte_batch_remaining
+/**
+ * pte_batch_remaining - Number of pages from addr to next batch boundary.
+ * @pte: Page table entry for the first page.
+ * @addr: Address of the first page.
+ * @end: Batch ceiling (e.g. end of vma).
+ *
+ * Some architectures (arm64) can efficiently modify a contiguous batch of ptes.
+ * In such cases, this function returns the remaining number of pages to the end
+ * of the current batch, as defined by addr. This can be useful when iterating
+ * over ptes.
+ *
+ * May be overridden by the architecture, else batch size is always 1.
+ */
+static inline unsigned int pte_batch_remaining(pte_t pte, unsigned long addr,
+						unsigned long end)
+{
+	return 1;
+}
+#endif
+
 #ifndef set_ptes
 
 #ifndef pte_next_pfn
@@ -246,6 +267,34 @@ static inline void set_ptes(struct mm_st
 #endif
 #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
 
+#ifndef set_ptes_full
+/**
+ * set_ptes_full - Map consecutive pages to a contiguous range of addresses.
+ * @mm: Address space to map the pages into.
+ * @addr: Address to map the first page at.
+ * @ptep: Page table pointer for the first entry.
+ * @pte: Page table entry for the first page.
+ * @nr: Number of pages to map.
+ * @full: True if systematically setting all ptes and their previous values
+ *        were known to be none (e.g. part of fork).
+ *
+ * Some architectures (arm64) can optimize the implementation if copying ptes
+ * batach-by-batch from the parent, where a batch is defined by
+ * pte_batch_remaining().
+ *
+ * May be overridden by the architecture, else full is ignored and call is
+ * forwarded to set_ptes().
+ *
+ * Context: The caller holds the page table lock.  The pages all belong to the
+ * same folio.  The PTEs are all in the same PMD.
+ */
+static inline void set_ptes_full(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned int nr, int full)
+{
+	set_ptes(mm, addr, ptep, pte, nr);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
@@ -622,6 +671,37 @@ static inline void ptep_set_wrprotect(st
 }
 #endif
 
+#ifndef ptep_set_wrprotects
+struct mm_struct;
+/**
+ * ptep_set_wrprotects - Write protect a consecutive set of pages.
+ * @mm: Address space that the pages are mapped into.
+ * @address: Address of first page to write protect.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of pages to write protect.
+ * @full: True if systematically wite protecting all ptes (e.g. part of fork).
+ *
+ * Some architectures (arm64) can optimize the implementation if
+ * write-protecting ptes batach-by-batch, where a batch is defined by
+ * pte_batch_remaining().
+ *
+ * May be overridden by the architecture, else implemented as a loop over
+ * ptep_set_wrprotect().
+ *
+ * Context: The caller holds the page table lock. The PTEs are all in the same
+ * PMD.
+ */
+static inline void ptep_set_wrprotects(struct mm_struct *mm,
+				unsigned long address, pte_t *ptep,
+				unsigned int nr, int full)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr; i++, address += PAGE_SIZE, ptep++)
+		ptep_set_wrprotect(mm, address, ptep);
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
--- a/mm/memory.c~mm-batch-copy-pte-ranges-during-fork
+++ a/mm/memory.c
@@ -929,42 +929,60 @@ copy_present_page(struct vm_area_struct
 }
 
 /*
- * Copy one pte.  Returns 0 if succeeded, or -EAGAIN if one preallocated page
- * is required to copy this pte.
+ * Copy set of contiguous ptes.  Returns number of ptes copied if succeeded
+ * (always gte 1), or -EAGAIN if one preallocated page is required to copy the
+ * first pte.
  */
 static inline int
-copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
-		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		 struct folio **prealloc)
+copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		  pte_t *dst_pte, pte_t *src_pte, pte_t pte,
+		  unsigned long addr, unsigned long end,
+		  int *rss, struct folio **prealloc)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	unsigned long vm_flags = src_vma->vm_flags;
-	pte_t pte = ptep_get(src_pte);
 	struct page *page;
 	struct folio *folio;
+	int nr, i, ret;
+
+	nr = pte_batch_remaining(pte, addr, end);
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (page)
+	if (page) {
 		folio = page_folio(page);
+		folio_ref_add(folio, nr);
+	}
 	if (page && folio_test_anon(folio)) {
-		/*
-		 * If this page may have been pinned by the parent process,
-		 * copy the page immediately for the child so that we'll always
-		 * guarantee the pinned page won't be randomly replaced in the
-		 * future.
-		 */
-		folio_get(folio);
-		if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
-			/* Page may be pinned, we have to copy. */
-			folio_put(folio);
-			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
-						 addr, rss, prealloc, page);
+		for (i = 0; i < nr; i++, page++) {
+			/*
+			 * If this page may have been pinned by the parent
+			 * process, copy the page immediately for the child so
+			 * that we'll always guarantee the pinned page won't be
+			 * randomly replaced in the future.
+			 */
+			if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
+				if (i != 0)
+					break;
+				/* Page may be pinned, we have to copy. */
+				folio_ref_sub(folio, nr);
+				ret = copy_present_page(dst_vma, src_vma,
+							dst_pte, src_pte, addr,
+							rss, prealloc, page);
+				return ret == 0 ? 1 : ret;
+			}
+			VM_BUG_ON(PageAnonExclusive(page));
 		}
-		rss[MM_ANONPAGES]++;
+
+		if (unlikely(i < nr)) {
+			folio_ref_sub(folio, nr - i);
+			nr = i;
+		}
+
+		rss[MM_ANONPAGES] += nr;
 	} else if (page) {
-		folio_get(folio);
-		page_dup_file_rmap(page, false);
-		rss[mm_counter_file(page)]++;
+		for (i = 0; i < nr; i++)
+			page_dup_file_rmap(page + i, false);
+		rss[mm_counter_file(page)] += nr;
 	}
 
 	/*
@@ -972,10 +990,9 @@ copy_present_pte(struct vm_area_struct *
 	 * in the parent and the child
 	 */
 	if (is_cow_mapping(vm_flags) && pte_write(pte)) {
-		ptep_set_wrprotect(src_mm, addr, src_pte);
+		ptep_set_wrprotects(src_mm, addr, src_pte, nr, true);
 		pte = pte_wrprotect(pte);
 	}
-	VM_BUG_ON(page && folio_test_anon(folio) && PageAnonExclusive(page));
 
 	/*
 	 * If it's a shared mapping, mark it clean in
@@ -988,8 +1005,8 @@ copy_present_pte(struct vm_area_struct *
 	if (!userfaultfd_wp(dst_vma))
 		pte = pte_clear_uffd_wp(pte);
 
-	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
-	return 0;
+	set_ptes_full(dst_vma->vm_mm, addr, dst_pte, pte, nr, true);
+	return nr;
 }
 
 static inline struct folio *folio_prealloc(struct mm_struct *src_mm,
@@ -1030,6 +1047,7 @@ copy_pte_range(struct vm_area_struct *ds
 	int rss[NR_MM_COUNTERS];
 	swp_entry_t entry = (swp_entry_t){0};
 	struct folio *prealloc = NULL;
+	int nr_ptes;
 
 again:
 	progress = 0;
@@ -1060,6 +1078,8 @@ again:
 	arch_enter_lazy_mmu_mode();
 
 	do {
+		nr_ptes = 1;
+
 		/*
 		 * We are holding two locks at this point - either of them
 		 * could generate latencies in another task on another CPU.
@@ -1095,16 +1115,21 @@ again:
 			 * the now present pte.
 			 */
 			WARN_ON_ONCE(ret != -ENOENT);
+			ret = 0;
 		}
-		/* copy_present_pte() will clear `*prealloc' if consumed */
-		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
-				       addr, rss, &prealloc);
+		/* copy_present_ptes() will clear `*prealloc' if consumed */
+		nr_ptes = copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte,
+					    ptent, addr, end, rss, &prealloc);
+
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
 		 */
-		if (unlikely(ret == -EAGAIN))
+		if (unlikely(nr_ptes == -EAGAIN)) {
+			ret = -EAGAIN;
 			break;
+		}
+
 		if (unlikely(prealloc)) {
 			/*
 			 * pre-alloc page cannot be reused by next time so as
@@ -1115,8 +1140,9 @@ again:
 			folio_put(prealloc);
 			prealloc = NULL;
 		}
-		progress += 8;
-	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
+		progress += 8 * nr_ptes;
+	} while (dst_pte += nr_ptes, src_pte += nr_ptes,
+		 addr += PAGE_SIZE * nr_ptes, addr != end);
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(orig_src_pte, src_ptl);
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

