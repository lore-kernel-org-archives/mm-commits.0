Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC748219498
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019118; cv=none; b=ltuqZgJX/UZJ6FhaFt0uilgN9cqHbnLvNQwd8yb7KhTNFgSIWk19e2Hc2WeoKshvPEbNbnXH1KjUCMWJVqN0GoYzja1mrM6gUksEzODeGpBllRN33mAsY5Z6c0F60Z6eU07+lQusjwPkWF5JJ7QqWVcOmv5/5PF2tLLbeIwq/uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019118; c=relaxed/simple;
	bh=+LztTZo14zjLqlzepX/rV7ohGdH2x+CYmd9K39uBjCE=;
	h=Date:To:From:Subject:Message-Id; b=QQgDmO71vSJFaMIi4FQw9jN5Vrp7FaGx4/47Zt6BZiOgm6nZ0gWrdlpM8n5TXV45QA1PhPsp/40yWOU1709RjwzNFnte+F4bCzhO1AIeJGT/fB5jizPlLFB0Rp5rWyct7XXgU/1qtGojjYNvE2lsSBypRnYgFdc/5sJ4U/+Sc7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iQRPud+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iQRPud+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1B3C4CECE;
	Thu,  7 Nov 2024 22:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019118;
	bh=+LztTZo14zjLqlzepX/rV7ohGdH2x+CYmd9K39uBjCE=;
	h=Date:To:From:Subject:From;
	b=iQRPud+VONb7V41CUCpojD55QlxaI4vJCAM56CpxM/0x2rlWiJ8LP+ZrHAy0fJv4I
	 RK7CG2GtcYnaO0ROT6ANditzocY5mf5tN0GUbdUE6VuPyyxqE8zfzqFuYRMbwDfCfr
	 yVtkGEWnTLz0/Vj+UTUlS6ME8aXwgicbyB09H/Vg=
Date: Thu, 07 Nov 2024 14:38:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-renovate-page_address_in_vma.patch removed from -mm tree
Message-Id: <20241107223838.3A1B3C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: renovate page_address_in_vma()
has been removed from the -mm tree.  Its filename was
     mm-renovate-page_address_in_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: renovate page_address_in_vma()
Date: Sat, 5 Oct 2024 21:01:14 +0100

This function doesn't modify any of its arguments, so if we make a few
other functions take const pointers, we can make page_address_in_vma()
take const pointers too.  All of its callers have the containing folio
already, so pass that in as an argument instead of recalculating it.  Also
add kernel-doc

Link: https://lkml.kernel.org/r/20241005200121.3231142-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 ++-----
 mm/internal.h        |    4 ++--
 mm/ksm.c             |    7 +++----
 mm/memory-failure.c  |    2 +-
 mm/mempolicy.c       |    2 +-
 mm/rmap.c            |   27 ++++++++++++++++++++-------
 mm/util.c            |    2 +-
 7 files changed, 30 insertions(+), 21 deletions(-)

--- a/include/linux/rmap.h~mm-renovate-page_address_in_vma
+++ a/include/linux/rmap.h
@@ -728,11 +728,8 @@ page_vma_mapped_walk_restart(struct page
 }
 
 bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw);
-
-/*
- * Used by swapoff to help locate where page is expected in vma.
- */
-unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
+unsigned long page_address_in_vma(const struct folio *folio,
+		const struct page *, const struct vm_area_struct *);
 
 /*
  * Cleans the PTEs of shared mappings.
--- a/mm/internal.h~mm-renovate-page_address_in_vma
+++ a/mm/internal.h
@@ -841,7 +841,7 @@ static inline bool free_area_empty(struc
 }
 
 /* mm/util.c */
-struct anon_vma *folio_anon_vma(struct folio *folio);
+struct anon_vma *folio_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MMU
 void unmap_mapping_folio(struct folio *folio);
@@ -959,7 +959,7 @@ extern pmd_t maybe_pmd_mkwrite(pmd_t pmd
  * If any page in this range is mapped by this VMA, return the first address
  * where any of these pages appear.  Otherwise, return -EFAULT.
  */
-static inline unsigned long vma_address(struct vm_area_struct *vma,
+static inline unsigned long vma_address(const struct vm_area_struct *vma,
 		pgoff_t pgoff, unsigned long nr_pages)
 {
 	unsigned long address;
--- a/mm/ksm.c~mm-renovate-page_address_in_vma
+++ a/mm/ksm.c
@@ -1256,7 +1256,7 @@ static int write_protect_page(struct vm_
 	if (WARN_ON_ONCE(folio_test_large(folio)))
 		return err;
 
-	pvmw.address = page_address_in_vma(&folio->page, vma);
+	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
 	if (pvmw.address == -EFAULT)
 		goto out;
 
@@ -1340,7 +1340,7 @@ static int replace_page(struct vm_area_s
 {
 	struct folio *kfolio = page_folio(kpage);
 	struct mm_struct *mm = vma->vm_mm;
-	struct folio *folio;
+	struct folio *folio = page_folio(page);
 	pmd_t *pmd;
 	pmd_t pmde;
 	pte_t *ptep;
@@ -1350,7 +1350,7 @@ static int replace_page(struct vm_area_s
 	int err = -EFAULT;
 	struct mmu_notifier_range range;
 
-	addr = page_address_in_vma(page, vma);
+	addr = page_address_in_vma(folio, page, vma);
 	if (addr == -EFAULT)
 		goto out;
 
@@ -1416,7 +1416,6 @@ static int replace_page(struct vm_area_s
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at(mm, addr, ptep, newpte);
 
-	folio = page_folio(page);
 	folio_remove_rmap_pte(folio, page, vma);
 	if (!folio_mapped(folio))
 		folio_free_swap(folio);
--- a/mm/memory-failure.c~mm-renovate-page_address_in_vma
+++ a/mm/memory-failure.c
@@ -671,7 +671,7 @@ static void collect_procs_file(struct fo
 			 */
 			if (vma->vm_mm != t->mm)
 				continue;
-			addr = page_address_in_vma(page, vma);
+			addr = page_address_in_vma(folio, page, vma);
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
--- a/mm/mempolicy.c~mm-renovate-page_address_in_vma
+++ a/mm/mempolicy.c
@@ -1367,7 +1367,7 @@ static long do_mbind(unsigned long start
 			if (!list_entry_is_head(folio, &pagelist, lru)) {
 				vma_iter_init(&vmi, mm, start);
 				for_each_vma_range(vmi, vma, end) {
-					addr = page_address_in_vma(
+					addr = page_address_in_vma(folio,
 						folio_page(folio, 0), vma);
 					if (addr != -EFAULT)
 						break;
--- a/mm/rmap.c~mm-renovate-page_address_in_vma
+++ a/mm/rmap.c
@@ -767,14 +767,27 @@ static bool should_defer_flush(struct mm
 }
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
 
-/*
- * At what user virtual address is page expected in vma?
- * Caller should check the page is actually part of the vma.
+/**
+ * page_address_in_vma - The virtual address of a page in this VMA.
+ * @folio: The folio containing the page.
+ * @page: The page within the folio.
+ * @vma: The VMA we need to know the address in.
+ *
+ * Calculates the user virtual address of this page in the specified VMA.
+ * It is the caller's responsibililty to check the page is actually
+ * within the VMA.  There may not currently be a PTE pointing at this
+ * page, but if a page fault occurs at this address, this is the page
+ * which will be accessed.
+ *
+ * Context: Caller should hold a reference to the folio.  Caller should
+ * hold a lock (eg the i_mmap_lock or the mmap_lock) which keeps the
+ * VMA from being altered.
+ *
+ * Return: The virtual address corresponding to this page in the VMA.
  */
-unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
+unsigned long page_address_in_vma(const struct folio *folio,
+		const struct page *page, const struct vm_area_struct *vma)
 {
-	struct folio *folio = page_folio(page);
-
 	if (folio_test_anon(folio)) {
 		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
 		/*
@@ -790,7 +803,7 @@ unsigned long page_address_in_vma(struct
 		return -EFAULT;
 	}
 
-	/* The !page__anon_vma above handles KSM folios */
+	/* KSM folios don't reach here because of the !page__anon_vma check */
 	return vma_address(vma, page_pgoff(folio, page), 1);
 }
 
--- a/mm/util.c~mm-renovate-page_address_in_vma
+++ a/mm/util.c
@@ -820,7 +820,7 @@ void *vcalloc_noprof(size_t n, size_t si
 }
 EXPORT_SYMBOL(vcalloc_noprof);
 
-struct anon_vma *folio_anon_vma(struct folio *folio)
+struct anon_vma *folio_anon_vma(const struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
 
_

Patches currently in -mm which might be from willy@infradead.org are


