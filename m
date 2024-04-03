Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB231E4A6
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712183679; cv=none; b=ZkEYSjJVgysYgM+J0F57Krz7EALG1oXi0jod9N/dISkXbL3aTCCtPO/ccugiBijWSOy6E1+FSZieDJhWxnWk3OqCAXexn4yzFkGpAiVChaVnMJsqjg2ThP8J54x23jLZS/X18hxNrrvqQXY19tgp7YcSP4656d9danfHDwUFK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712183679; c=relaxed/simple;
	bh=xIzbWm6MmKq9RBZb6NEmJGc8myNVxE8HBbLoA5y49uY=;
	h=Date:To:From:Subject:Message-Id; b=aERRu1RLe28uMcy1XSv4w68vNFwrST1unWCP0Fi1LS7TgbW90DQcwOl4pTmpiqJPEzDzkpVFaLxyVUU8Eof+/MKMBzzWn8TaiTDER4NTSCUPeF7ZfMrlU+CSmqhryWOTZVtfZBFOYPVj4sVQev3H2waohrxrTN9yjcw6xLk1TKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RiblLNAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RiblLNAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9BBC433F1;
	Wed,  3 Apr 2024 22:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712183678;
	bh=xIzbWm6MmKq9RBZb6NEmJGc8myNVxE8HBbLoA5y49uY=;
	h=Date:To:From:Subject:From;
	b=RiblLNANUH7UZAWUeQ+JgK/BUKAYP3Yv4gjurFV+d1h7MwZ3q4c4qnvitDUY1a271
	 KQ5AvN9vS02eW6L1osmFvHMvLBurA0hK8NisbJ9Yt1d8aOv+iFZezg50GNLcxwA0Ts
	 mf3Lyjk0CHQmjszjCMYxHKgwpT4+rPXFtaf1GIRU=
Date: Wed, 03 Apr 2024 15:34:37 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-consistently-name-gup-fast-functions.patch added to mm-unstable branch
Message-Id: <20240403223438.AF9BBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: consistently name GUP-fast functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-consistently-name-gup-fast-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-consistently-name-gup-fast-functions.patch

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
Subject: mm/gup: consistently name GUP-fast functions
Date: Tue, 2 Apr 2024 14:55:14 +0200

Patch series "mm/gup: consistently call it GUP-fast".

Some cleanups around function names, comments and the config option of
"GUP-fast" -- GUP without "lock" safety belts on.

With this cleanup it's easy to judge which functions are GUP-fast
specific.  We now consistently call it "GUP-fast", avoiding mixing it with
"fast GUP", "lockless", or simply "gup" (which I always considered
confusing in the ode).

So the magic now happens in functions that contain "gup_fast", whereby
gup_fast() is the entry point into that magic.  Comments consistently
reference either "GUP-fast" or "gup_fast()".


This patch (of 3):

Let's consistently call the "fast-only" part of GUP "GUP-fast" and rename
all relevant internal functions to start with "gup_fast", to make it
clearer that this is not ordinary GUP.  The current mixture of "lockless",
"gup" and "gup_fast" is confusing.

Further, avoid the term "huge" when talking about a "leaf" -- for example,
we nowadays check pmd_leaf() because pmd_huge() is gone.  For the
"hugepd"/"hugepte" stuff, it's part of the name ("is_hugepd"), so that
stays.

What remains is the "external" interface:
* get_user_pages_fast_only()
* get_user_pages_fast()
* pin_user_pages_fast()

The high-level internal functions for GUP-fast (+slow fallback) are now:
* internal_get_user_pages_fast() -> gup_fast_fallback()
* lockless_pages_from_mm() -> gup_fast()

The basic GUP-fast walker functions:
* gup_pgd_range() -> gup_fast_pgd_range()
* gup_p4d_range() -> gup_fast_p4d_range()
* gup_pud_range() -> gup_fast_pud_range()
* gup_pmd_range() -> gup_fast_pmd_range()
* gup_pte_range() -> gup_fast_pte_range()
* gup_huge_pgd()  -> gup_fast_pgd_leaf()
* gup_huge_pud()  -> gup_fast_pud_leaf()
* gup_huge_pmd()  -> gup_fast_pmd_leaf()

The weird hugepd stuff:
* gup_huge_pd() -> gup_fast_hugepd()
* gup_hugepte() -> gup_fast_hugepte()

The weird devmap stuff:
* __gup_device_huge_pud() -> gup_fast_devmap_pud_leaf()
* __gup_device_huge_pmd   -> gup_fast_devmap_pmd_leaf()
* __gup_device_huge()     -> gup_fast_devmap_leaf()
* undo_dev_pagemap()      -> gup_fast_undo_dev_pagemap()

Helper functions:
* unpin_user_pages_lockless() -> gup_fast_unpin_user_pages()
* gup_fast_folio_allowed() is already properly named
* gup_fast_permitted() is already properly named

With "gup_fast()", we now even have a function that is referred to in
comment in mm/mmu_gather.c.

Link: https://lkml.kernel.org/r/20240402125516.223131-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240402125516.223131-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  205 ++++++++++++++++++++++++++---------------------------
 1 file changed, 103 insertions(+), 102 deletions(-)

--- a/mm/gup.c~mm-gup-consistently-name-gup-fast-functions
+++ a/mm/gup.c
@@ -440,7 +440,7 @@ void unpin_user_page_range_dirty_lock(st
 }
 EXPORT_SYMBOL(unpin_user_page_range_dirty_lock);
 
-static void unpin_user_pages_lockless(struct page **pages, unsigned long npages)
+static void gup_fast_unpin_user_pages(struct page **pages, unsigned long npages)
 {
 	unsigned long i;
 	struct folio *folio;
@@ -525,9 +525,9 @@ static unsigned long hugepte_addr_end(un
 	return (__boundary - 1 < end - 1) ? __boundary : end;
 }
 
-static int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
-		       unsigned long end, unsigned int flags,
-		       struct page **pages, int *nr)
+static int gup_fast_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	unsigned long pte_end;
 	struct page *page;
@@ -577,7 +577,7 @@ static int gup_hugepte(pte_t *ptep, unsi
  * of the other folios. See writable_file_mapping_allowed() and
  * gup_fast_folio_allowed() for more information.
  */
-static int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
+static int gup_fast_hugepd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
 		struct page **pages, int *nr)
 {
@@ -588,7 +588,7 @@ static int gup_huge_pd(hugepd_t hugepd,
 	ptep = hugepte_offset(hugepd, addr, pdshift);
 	do {
 		next = hugepte_addr_end(addr, end, sz);
-		if (!gup_hugepte(ptep, sz, addr, end, flags, pages, nr))
+		if (!gup_fast_hugepte(ptep, sz, addr, end, flags, pages, nr))
 			return 0;
 	} while (ptep++, addr = next, addr != end);
 
@@ -613,8 +613,8 @@ static struct page *follow_hugepd(struct
 	h = hstate_vma(vma);
 	ptep = hugepte_offset(hugepd, addr, pdshift);
 	ptl = huge_pte_lock(h, vma->vm_mm, ptep);
-	ret = gup_huge_pd(hugepd, addr, pdshift, addr + PAGE_SIZE,
-			  flags, &page, &nr);
+	ret = gup_fast_hugepd(hugepd, addr, pdshift, addr + PAGE_SIZE,
+			      flags, &page, &nr);
 	spin_unlock(ptl);
 
 	if (ret) {
@@ -626,7 +626,7 @@ static struct page *follow_hugepd(struct
 	return NULL;
 }
 #else /* CONFIG_ARCH_HAS_HUGEPD */
-static inline int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
+static inline int gup_fast_hugepd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
 		struct page **pages, int *nr)
 {
@@ -2750,7 +2750,7 @@ long get_user_pages_unlocked(unsigned lo
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
 /*
- * Fast GUP
+ * GUP-fast
  *
  * get_user_pages_fast attempts to pin user pages by walking the page
  * tables directly and avoids taking locks. Thus the walker needs to be
@@ -2764,7 +2764,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  *
  * Another way to achieve this is to batch up page table containing pages
  * belonging to more than one mm_user, then rcu_sched a callback to free those
- * pages. Disabling interrupts will allow the fast_gup walker to both block
+ * pages. Disabling interrupts will allow the gup_fast() walker to both block
  * the rcu_sched callback, and an IPI that we broadcast for splitting THPs
  * (which is a relatively rare event). The code below adopts this strategy.
  *
@@ -2873,9 +2873,8 @@ static bool gup_fast_folio_allowed(struc
 	return !reject_file_backed || shmem_mapping(mapping);
 }
 
-static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
-					    unsigned int flags,
-					    struct page **pages)
+static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
+		unsigned int flags, struct page **pages)
 {
 	while ((*nr) - nr_start) {
 		struct page *page = pages[--(*nr)];
@@ -2890,27 +2889,27 @@ static void __maybe_unused undo_dev_page
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 /*
- * Fast-gup relies on pte change detection to avoid concurrent pgtable
+ * GUP-fast relies on pte change detection to avoid concurrent pgtable
  * operations.
  *
- * To pin the page, fast-gup needs to do below in order:
+ * To pin the page, GUP-fast needs to do below in order:
  * (1) pin the page (by prefetching pte), then (2) check pte not changed.
  *
  * For the rest of pgtable operations where pgtable updates can be racy
- * with fast-gup, we need to do (1) clear pte, then (2) check whether page
+ * with GUP-fast, we need to do (1) clear pte, then (2) check whether page
  * is pinned.
  *
  * Above will work for all pte-level operations, including THP split.
  *
- * For THP collapse, it's a bit more complicated because fast-gup may be
+ * For THP collapse, it's a bit more complicated because GUP-fast may be
  * walking a pgtable page that is being freed (pte is still valid but pmd
  * can be cleared already).  To avoid race in such condition, we need to
  * also check pmd here to make sure pmd doesn't change (corresponds to
  * pmdp_collapse_flush() in the THP collapse code path).
  */
-static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-			 unsigned long end, unsigned int flags,
-			 struct page **pages, int *nr)
+static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	struct dev_pagemap *pgmap = NULL;
 	int nr_start = *nr, ret = 0;
@@ -2943,7 +2942,7 @@ static int gup_pte_range(pmd_t pmd, pmd_
 
 			pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
-				undo_dev_pagemap(nr, nr_start, flags, pages);
+				gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 				goto pte_unmap;
 			}
 		} else if (pte_special(pte))
@@ -3007,20 +3006,19 @@ pte_unmap:
  *
  * For a futex to be placed on a THP tail page, get_futex_key requires a
  * get_user_pages_fast_only implementation that can pin pages. Thus it's still
- * useful to have gup_huge_pmd even if we can't operate on ptes.
+ * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
  */
-static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-			 unsigned long end, unsigned int flags,
-			 struct page **pages, int *nr)
+static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	return 0;
 }
 #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 
 #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static int __gup_device_huge(unsigned long pfn, unsigned long addr,
-			     unsigned long end, unsigned int flags,
-			     struct page **pages, int *nr)
+static int gup_fast_devmap_leaf(unsigned long pfn, unsigned long addr,
+	unsigned long end, unsigned int flags, struct page **pages, int *nr)
 {
 	int nr_start = *nr;
 	struct dev_pagemap *pgmap = NULL;
@@ -3030,19 +3028,19 @@ static int __gup_device_huge(unsigned lo
 
 		pgmap = get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
-			undo_dev_pagemap(nr, nr_start, flags, pages);
+			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 			break;
 		}
 
 		if (!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-			undo_dev_pagemap(nr, nr_start, flags, pages);
+			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 			break;
 		}
 
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		if (unlikely(try_grab_page(page, flags))) {
-			undo_dev_pagemap(nr, nr_start, flags, pages);
+			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 			break;
 		}
 		(*nr)++;
@@ -3053,62 +3051,62 @@ static int __gup_device_huge(unsigned lo
 	return addr == end;
 }
 
-static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-				 unsigned long end, unsigned int flags,
-				 struct page **pages, int *nr)
+static int gup_fast_devmap_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	unsigned long fault_pfn;
 	int nr_start = *nr;
 
 	fault_pfn = pmd_pfn(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
+	if (!gup_fast_devmap_leaf(fault_pfn, addr, end, flags, pages, nr))
 		return 0;
 
 	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
-		undo_dev_pagemap(nr, nr_start, flags, pages);
+		gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
 }
 
-static int __gup_device_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
-				 unsigned long end, unsigned int flags,
-				 struct page **pages, int *nr)
+static int gup_fast_devmap_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	unsigned long fault_pfn;
 	int nr_start = *nr;
 
 	fault_pfn = pud_pfn(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
+	if (!gup_fast_devmap_leaf(fault_pfn, addr, end, flags, pages, nr))
 		return 0;
 
 	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
-		undo_dev_pagemap(nr, nr_start, flags, pages);
+		gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
 }
 #else
-static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-				 unsigned long end, unsigned int flags,
-				 struct page **pages, int *nr)
+static int gup_fast_devmap_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	BUILD_BUG();
 	return 0;
 }
 
-static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
-				 unsigned long end, unsigned int flags,
-				 struct page **pages, int *nr)
+static int gup_fast_devmap_pud_leaf(pud_t pud, pud_t *pudp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	BUILD_BUG();
 	return 0;
 }
 #endif
 
-static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-			unsigned long end, unsigned int flags,
-			struct page **pages, int *nr)
+static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	struct page *page;
 	struct folio *folio;
@@ -3120,8 +3118,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	if (pmd_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-		return __gup_device_huge_pmd(orig, pmdp, addr, end, flags,
-					     pages, nr);
+		return gup_fast_devmap_pmd_leaf(orig, pmdp, addr, end, flags,
+					        pages, nr);
 	}
 
 	page = pmd_page(orig);
@@ -3150,9 +3148,9 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	return 1;
 }
 
-static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
-			unsigned long end, unsigned int flags,
-			struct page **pages, int *nr)
+static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	struct page *page;
 	struct folio *folio;
@@ -3164,8 +3162,8 @@ static int gup_huge_pud(pud_t orig, pud_
 	if (pud_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-		return __gup_device_huge_pud(orig, pudp, addr, end, flags,
-					     pages, nr);
+		return gup_fast_devmap_pud_leaf(orig, pudp, addr, end, flags,
+					        pages, nr);
 	}
 
 	page = pud_page(orig);
@@ -3195,9 +3193,9 @@ static int gup_huge_pud(pud_t orig, pud_
 	return 1;
 }
 
-static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
-			unsigned long end, unsigned int flags,
-			struct page **pages, int *nr)
+static int gup_fast_pgd_leaf(pgd_t orig, pgd_t *pgdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	int refs;
 	struct page *page;
@@ -3235,8 +3233,9 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	return 1;
 }
 
-static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages, int *nr)
+static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp;
@@ -3250,11 +3249,11 @@ static int gup_pmd_range(pud_t *pudp, pu
 			return 0;
 
 		if (unlikely(pmd_leaf(pmd))) {
-			/* See gup_pte_range() */
+			/* See gup_fast_pte_range() */
 			if (pmd_protnone(pmd))
 				return 0;
 
-			if (!gup_huge_pmd(pmd, pmdp, addr, next, flags,
+			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
 				pages, nr))
 				return 0;
 
@@ -3263,18 +3262,20 @@ static int gup_pmd_range(pud_t *pudp, pu
 			 * architecture have different format for hugetlbfs
 			 * pmd format and THP pmd format
 			 */
-			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
-					 PMD_SHIFT, next, flags, pages, nr))
+			if (!gup_fast_hugepd(__hugepd(pmd_val(pmd)), addr,
+					     PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, pmdp, addr, next, flags, pages, nr))
+		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
+					       pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
 	return 1;
 }
 
-static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
@@ -3287,22 +3288,24 @@ static int gup_pud_range(p4d_t *p4dp, p4
 		if (unlikely(!pud_present(pud)))
 			return 0;
 		if (unlikely(pud_leaf(pud))) {
-			if (!gup_huge_pud(pud, pudp, addr, next, flags,
-					  pages, nr))
+			if (!gup_fast_pud_leaf(pud, pudp, addr, next, flags,
+					       pages, nr))
 				return 0;
 		} else if (unlikely(is_hugepd(__hugepd(pud_val(pud))))) {
-			if (!gup_huge_pd(__hugepd(pud_val(pud)), addr,
-					 PUD_SHIFT, next, flags, pages, nr))
+			if (!gup_fast_hugepd(__hugepd(pud_val(pud)), addr,
+					     PUD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pmd_range(pudp, pud, addr, next, flags, pages, nr))
+		} else if (!gup_fast_pmd_range(pudp, pud, addr, next, flags,
+					       pages, nr))
 			return 0;
 	} while (pudp++, addr = next, addr != end);
 
 	return 1;
 }
 
-static int gup_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages,
+		int *nr)
 {
 	unsigned long next;
 	p4d_t *p4dp;
@@ -3316,17 +3319,18 @@ static int gup_p4d_range(pgd_t *pgdp, pg
 			return 0;
 		BUILD_BUG_ON(p4d_leaf(p4d));
 		if (unlikely(is_hugepd(__hugepd(p4d_val(p4d))))) {
-			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
-					 P4D_SHIFT, next, flags, pages, nr))
+			if (!gup_fast_hugepd(__hugepd(p4d_val(p4d)), addr,
+					     P4D_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pud_range(p4dp, p4d, addr, next, flags, pages, nr))
+		} else if (!gup_fast_pud_range(p4dp, p4d, addr, next, flags,
+					       pages, nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
 	return 1;
 }
 
-static void gup_pgd_range(unsigned long addr, unsigned long end,
+static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
@@ -3340,19 +3344,20 @@ static void gup_pgd_range(unsigned long
 		if (pgd_none(pgd))
 			return;
 		if (unlikely(pgd_leaf(pgd))) {
-			if (!gup_huge_pgd(pgd, pgdp, addr, next, flags,
-					  pages, nr))
+			if (!gup_fast_pgd_leaf(pgd, pgdp, addr, next, flags,
+					       pages, nr))
 				return;
 		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
-			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
-					 PGDIR_SHIFT, next, flags, pages, nr))
+			if (!gup_fast_hugepd(__hugepd(pgd_val(pgd)), addr,
+					      PGDIR_SHIFT, next, flags, pages, nr))
 				return;
-		} else if (!gup_p4d_range(pgdp, pgd, addr, next, flags, pages, nr))
+		} else if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags,
+					       pages, nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }
 #else
-static inline void gup_pgd_range(unsigned long addr, unsigned long end,
+static inline void gup_fast_pgd_range(unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages, int *nr)
 {
 }
@@ -3369,10 +3374,8 @@ static bool gup_fast_permitted(unsigned
 }
 #endif
 
-static unsigned long lockless_pages_from_mm(unsigned long start,
-					    unsigned long end,
-					    unsigned int gup_flags,
-					    struct page **pages)
+static unsigned long gup_fast(unsigned long start, unsigned long end,
+		unsigned int gup_flags, struct page **pages)
 {
 	unsigned long flags;
 	int nr_pinned = 0;
@@ -3400,16 +3403,16 @@ static unsigned long lockless_pages_from
 	 * that come from THPs splitting.
 	 */
 	local_irq_save(flags);
-	gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
+	gup_fast_pgd_range(start, end, gup_flags, pages, &nr_pinned);
 	local_irq_restore(flags);
 
 	/*
 	 * When pinning pages for DMA there could be a concurrent write protect
-	 * from fork() via copy_page_range(), in this case always fail fast GUP.
+	 * from fork() via copy_page_range(), in this case always fail GUP-fast.
 	 */
 	if (gup_flags & FOLL_PIN) {
 		if (read_seqcount_retry(&current->mm->write_protect_seq, seq)) {
-			unpin_user_pages_lockless(pages, nr_pinned);
+			gup_fast_unpin_user_pages(pages, nr_pinned);
 			return 0;
 		} else {
 			sanity_check_pinned_pages(pages, nr_pinned);
@@ -3418,10 +3421,8 @@ static unsigned long lockless_pages_from
 	return nr_pinned;
 }
 
-static int internal_get_user_pages_fast(unsigned long start,
-					unsigned long nr_pages,
-					unsigned int gup_flags,
-					struct page **pages)
+static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages)
 {
 	unsigned long len, end;
 	unsigned long nr_pinned;
@@ -3449,7 +3450,7 @@ static int internal_get_user_pages_fast(
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
-	nr_pinned = lockless_pages_from_mm(start, end, gup_flags, pages);
+	nr_pinned = gup_fast(start, end, gup_flags, pages);
 	if (nr_pinned == nr_pages || gup_flags & FOLL_FAST_ONLY)
 		return nr_pinned;
 
@@ -3503,7 +3504,7 @@ int get_user_pages_fast_only(unsigned lo
 			       FOLL_GET | FOLL_FAST_ONLY))
 		return -EINVAL;
 
-	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+	return gup_fast_fallback(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast_only);
 
@@ -3534,7 +3535,7 @@ int get_user_pages_fast(unsigned long st
 	 */
 	if (!is_valid_gup_args(pages, NULL, &gup_flags, FOLL_GET))
 		return -EINVAL;
-	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+	return gup_fast_fallback(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
@@ -3562,7 +3563,7 @@ int pin_user_pages_fast(unsigned long st
 {
 	if (!is_valid_gup_args(pages, NULL, &gup_flags, FOLL_PIN))
 		return -EINVAL;
-	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+	return gup_fast_fallback(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
x86-mm-pat-fix-vm_pat-handling-in-cow-mappings.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

