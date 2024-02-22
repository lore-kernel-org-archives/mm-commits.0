Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1EC1C17
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560178; cv=none; b=ckNDa3p2mcF++wfX6EyNNGF2xCUR7ZSZA3KGRW0gb48u8daJMSzreDLcdQwHbT5ORT3skSUoD4+tT1Cl5njSWCk9qnCYxtZnNZRz58PMQkQudcaPAGXyT1WXI+KHfCuxlrGlR/cvz0Ek0pceuqGEy5QG8j1h7g0FI+s4/+MqCsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560178; c=relaxed/simple;
	bh=6YB2Hi/dAN1XVbzvyYTUPmPr0NaDi3YWApJ+oYc4Wsg=;
	h=Date:To:From:Subject:Message-Id; b=NqjbIywj8XLbcIuyHq5VgRZsyejWSqxTi1yhgI3uSiB/Bag0DBVHWcsNPvPi6jZFQzOTTpiy4sy8ISaIb4l4JHYvQP5nCnafDt16rOv6o9AJM1aRY/72UxcJNylfHXvqps6ksKIUsyK1Q9Gutvv6Lv+UNm2PSsmmgu341X8J4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yToFDAZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yToFDAZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A3AC433F1;
	Thu, 22 Feb 2024 00:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560177;
	bh=6YB2Hi/dAN1XVbzvyYTUPmPr0NaDi3YWApJ+oYc4Wsg=;
	h=Date:To:From:Subject:From;
	b=yToFDAZWgmP6Qr9fxxAGhRWIdb9daVZ0nNIQF7kJQPD4SFmccwgJzM5urrARW34gS
	 ufsygnTwpGdGnZsscGm/2jYUBxc/wyLoltJ8KDbI0jShNz8Ii1k0cqhpvjpcgpc1X6
	 2/vgFMFOCGtMoZMowQtCyJOksh5cxg0obD5z4A6I=
Date: Wed, 21 Feb 2024 16:02:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-optimize-fork-with-pte-mapped-thp.patch removed from -mm tree
Message-Id: <20240222000257.B5A3AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: optimize fork() with PTE-mapped THP
has been removed from the -mm tree.  Its filename was
     mm-memory-optimize-fork-with-pte-mapped-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: optimize fork() with PTE-mapped THP
Date: Mon, 29 Jan 2024 13:46:47 +0100

Let's implement PTE batching when consecutive (present) PTEs map
consecutive pages of the same large folio, and all other PTE bits besides
the PFNs are equal.

We will optimize folio_pte_batch() separately, to ignore selected PTE
bits.  This patch is based on work by Ryan Roberts.

Use __always_inline for __copy_present_ptes() and keep the handling for
single PTEs completely separate from the multi-PTE case: we really want
the compiler to optimize for the single-PTE case with small folios, to not
degrade performance.

Note that PTE batching will never exceed a single page table and will
always stay within VMA boundaries.

Further, processing PTE-mapped THP that maybe pinned and have
PageAnonExclusive set on at least one subpage should work as expected, but
there is room for improvement: We will repeatedly (1) detect a PTE batch
(2) detect that we have to copy a page (3) fall back and allocate a single
page to copy a single page.  For now we won't care as pinned pages are a
corner case, and we should rather look into maintaining only a single
PageAnonExclusive bit for large folios.

Link: https://lkml.kernel.org/r/20240129124649.189745-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   31 ++++++++++
 mm/memory.c             |  112 +++++++++++++++++++++++++++++++-------
 2 files changed, 124 insertions(+), 19 deletions(-)

--- a/include/linux/pgtable.h~mm-memory-optimize-fork-with-pte-mapped-thp
+++ a/include/linux/pgtable.h
@@ -650,6 +650,37 @@ static inline void ptep_set_wrprotect(st
 }
 #endif
 
+#ifndef wrprotect_ptes
+/**
+ * wrprotect_ptes - Write-protect PTEs that map consecutive pages of the same
+ *		    folio.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to write-protect.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_set_wrprotect().
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, unsigned int nr)
+{
+	for (;;) {
+		ptep_set_wrprotect(mm, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
--- a/mm/memory.c~mm-memory-optimize-fork-with-pte-mapped-thp
+++ a/mm/memory.c
@@ -930,15 +930,15 @@ copy_present_page(struct vm_area_struct
 	return 0;
 }
 
-static inline void __copy_present_pte(struct vm_area_struct *dst_vma,
+static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, pte_t *dst_pte, pte_t *src_pte,
-		pte_t pte, unsigned long addr)
+		pte_t pte, unsigned long addr, int nr)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
 
 	/* If it's a COW mapping, write protect it both processes. */
 	if (is_cow_mapping(src_vma->vm_flags) && pte_write(pte)) {
-		ptep_set_wrprotect(src_mm, addr, src_pte);
+		wrprotect_ptes(src_mm, addr, src_pte, nr);
 		pte = pte_wrprotect(pte);
 	}
 
@@ -950,26 +950,93 @@ static inline void __copy_present_pte(st
 	if (!userfaultfd_wp(dst_vma))
 		pte = pte_clear_uffd_wp(pte);
 
-	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
+	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
 /*
- * Copy one pte.  Returns 0 if succeeded, or -EAGAIN if one preallocated page
- * is required to copy this pte.
+ * Detect a PTE batch: consecutive (present) PTEs that map consecutive
+ * pages of the same folio.
+ *
+ * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN.
+ */
+static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
+		pte_t *start_ptep, pte_t pte, int max_nr)
+{
+	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
+	const pte_t *end_ptep = start_ptep + max_nr;
+	pte_t expected_pte = pte_next_pfn(pte);
+	pte_t *ptep = start_ptep + 1;
+
+	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
+
+	while (ptep != end_ptep) {
+		pte = ptep_get(ptep);
+
+		if (!pte_same(pte, expected_pte))
+			break;
+
+		/*
+		 * Stop immediately once we reached the end of the folio. In
+		 * corner cases the next PFN might fall into a different
+		 * folio.
+		 */
+		if (pte_pfn(pte) == folio_end_pfn)
+			break;
+
+		expected_pte = pte_next_pfn(expected_pte);
+		ptep++;
+	}
+
+	return ptep - start_ptep;
+}
+
+/*
+ * Copy one present PTE, trying to batch-process subsequent PTEs that map
+ * consecutive pages of the same folio by copying them as well.
+ *
+ * Returns -EAGAIN if one preallocated page is required to copy the next PTE.
+ * Otherwise, returns the number of copied PTEs (at least 1).
  */
 static inline int
-copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		 pte_t *dst_pte, pte_t *src_pte, pte_t pte, unsigned long addr,
-		 int *rss, struct folio **prealloc)
+		 int max_nr, int *rss, struct folio **prealloc)
 {
 	struct page *page;
 	struct folio *folio;
+	int err, nr;
 
 	page = vm_normal_page(src_vma, addr, pte);
 	if (unlikely(!page))
 		goto copy_pte;
 
 	folio = page_folio(page);
+
+	/*
+	 * If we likely have to copy, just don't bother with batching. Make
+	 * sure that the common "small folio" case is as fast as possible
+	 * by keeping the batching logic separate.
+	 */
+	if (unlikely(!*prealloc && folio_test_large(folio) && max_nr != 1)) {
+		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr);
+		folio_ref_add(folio, nr);
+		if (folio_test_anon(folio)) {
+			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
+								  nr, src_vma))) {
+				folio_ref_sub(folio, nr);
+				return -EAGAIN;
+			}
+			rss[MM_ANONPAGES] += nr;
+			VM_WARN_ON_FOLIO(PageAnonExclusive(page), folio);
+		} else {
+			folio_dup_file_rmap_ptes(folio, page, nr);
+			rss[mm_counter_file(folio)] += nr;
+		}
+		__copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte, pte,
+				    addr, nr);
+		return nr;
+	}
+
 	folio_get(folio);
 	if (folio_test_anon(folio)) {
 		/*
@@ -981,8 +1048,9 @@ copy_present_pte(struct vm_area_struct *
 		if (unlikely(folio_try_dup_anon_rmap_pte(folio, page, src_vma))) {
 			/* Page may be pinned, we have to copy. */
 			folio_put(folio);
-			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
-						 addr, rss, prealloc, page);
+			err = copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
+						addr, rss, prealloc, page);
+			return err ? err : 1;
 		}
 		rss[MM_ANONPAGES]++;
 		VM_WARN_ON_FOLIO(PageAnonExclusive(page), folio);
@@ -992,8 +1060,8 @@ copy_present_pte(struct vm_area_struct *
 	}
 
 copy_pte:
-	__copy_present_pte(dst_vma, src_vma, dst_pte, src_pte, pte, addr);
-	return 0;
+	__copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte, pte, addr, 1);
+	return 1;
 }
 
 static inline struct folio *folio_prealloc(struct mm_struct *src_mm,
@@ -1030,10 +1098,11 @@ copy_pte_range(struct vm_area_struct *ds
 	pte_t *src_pte, *dst_pte;
 	pte_t ptent;
 	spinlock_t *src_ptl, *dst_ptl;
-	int progress, ret = 0;
+	int progress, max_nr, ret = 0;
 	int rss[NR_MM_COUNTERS];
 	swp_entry_t entry = (swp_entry_t){0};
 	struct folio *prealloc = NULL;
+	int nr;
 
 again:
 	progress = 0;
@@ -1064,6 +1133,8 @@ again:
 	arch_enter_lazy_mmu_mode();
 
 	do {
+		nr = 1;
+
 		/*
 		 * We are holding two locks at this point - either of them
 		 * could generate latencies in another task on another CPU.
@@ -1102,9 +1173,10 @@ again:
 			 */
 			WARN_ON_ONCE(ret != -ENOENT);
 		}
-		/* copy_present_pte() will clear `*prealloc' if consumed */
-		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
-				       ptent, addr, rss, &prealloc);
+		/* copy_present_ptes() will clear `*prealloc' if consumed */
+		max_nr = (end - addr) / PAGE_SIZE;
+		ret = copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte,
+					ptent, addr, max_nr, rss, &prealloc);
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
@@ -1121,8 +1193,10 @@ again:
 			folio_put(prealloc);
 			prealloc = NULL;
 		}
-		progress += 8;
-	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
+		nr = ret;
+		progress += 8 * nr;
+	} while (dst_pte += nr, src_pte += nr, addr += PAGE_SIZE * nr,
+		 addr != end);
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(orig_src_pte, src_ptl);
@@ -1143,7 +1217,7 @@ again:
 		prealloc = folio_prealloc(src_mm, src_vma, addr, false);
 		if (!prealloc)
 			return -ENOMEM;
-	} else if (ret) {
+	} else if (ret < 0) {
 		VM_WARN_ON_ONCE(1);
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch
mm-memory-handle-page-case-in-zap_present_pte-separately.patch
mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch
mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch
mm-mmu_gather-pass-delay_rmap-instead-of-encoded-page-to-__tlb_remove_page_size.patch
mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch
mm-mmu_gather-add-tlb_remove_tlb_entries.patch
mm-mmu_gather-add-__tlb_remove_folio_pages.patch
mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch
mm-memory-optimize-unmap-zap-with-pte-mapped-thp.patch

