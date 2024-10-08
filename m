Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC81EC4
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 01:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352563; cv=none; b=iMpXLfrO/fSCLej0Z6AUEC1Z3ffPeAv7YCwQqcPmLOVHGP2/7mV7C2kkYFVqOJrwjjPkAMJWcOAiUaRkNRleTPOM4Nc5mPsFfTbk0h9lwYX/Kr/eJzPjR7E31JloGkQUHG2M4V0B5ee8YwN3Jw26aFPzPw7pAj/IpxWnbJgSp3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352563; c=relaxed/simple;
	bh=UfH1g6Oyffv4GYj1UL10c7tKG985T24/S2Jsl1wKCGs=;
	h=Date:To:From:Subject:Message-Id; b=T7IJp6Z10Ry/ZLe2zW1NVK8iKBoUkLrywEBPaTZeF70zsOk6Mfh6AjtSBJhd8/kOzHRgBnuOO0sm41OUaa1IIx2unv9sgsVRQxVibdOdfgJ+Ck+PEl0dhVfZMcPqqsBRZ87QoTp9tUuvCUR+5+jKBMyrLgw1HnaMUL5/RGMv+KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VldDUYuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VldDUYuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9904C4CEC6;
	Tue,  8 Oct 2024 01:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728352562;
	bh=UfH1g6Oyffv4GYj1UL10c7tKG985T24/S2Jsl1wKCGs=;
	h=Date:To:From:Subject:From;
	b=VldDUYuE0bi/gHDbmobkj5OWTQzGMNpkJjxmIqb8Ump3EJh6zL8WhkKBpYUU89Gaw
	 rPt5KAJz/KGyIpA5XPNgcMKxz4AYM15h1RfRPXI1M64+1FtHpZCINx9ZMPZIImiKv1
	 3Yucj0OZbdtxl1oQ6iACGcm0uervGXQilB20TB1g=
Date: Mon, 07 Oct 2024 18:56:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-renovate-page_address_in_vma.patch added to mm-unstable branch
Message-Id: <20241008015602.A9904C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: renovate page_address_in_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-renovate-page_address_in_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-renovate-page_address_in_vma.patch

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
@@ -796,7 +796,7 @@ static inline bool free_area_empty(struc
 }
 
 /* mm/util.c */
-struct anon_vma *folio_anon_vma(struct folio *folio);
+struct anon_vma *folio_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MMU
 void unmap_mapping_folio(struct folio *folio);
@@ -914,7 +914,7 @@ extern pmd_t maybe_pmd_mkwrite(pmd_t pmd
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
@@ -768,14 +768,27 @@ static bool should_defer_flush(struct mm
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
@@ -791,7 +804,7 @@ unsigned long page_address_in_vma(struct
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

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-add-pageanonnotksm-fix.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch

