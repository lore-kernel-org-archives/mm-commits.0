Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DE03BE14A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896637; cv=none; b=lcMyMuk2PyCpgQFtYptHNxQGOToRJINbZGthzAMV5I8dg+o7iwKJVECaUyKYQgeonQjTOh27gfrEEY06MtSAYCd6fzNpWqACDx6mewd7przFTShOTQMxPEYV9XhJNX6c/BV989nbvdZKyL505b4HjX/zTduBOd+XEfH0hXkl9WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896637; c=relaxed/simple;
	bh=J2Y1ubYdabhWEk4Vuk0BoKVvol1CVgxdjvPcPgqyBQ4=;
	h=Date:To:From:Subject:Message-Id; b=XRqqw9QqlqCysbjkeuEGvcKXeszJ7XHwJXYu5zp0XcTiDuNghwCTGl1lTFrnFKkZE2hBd1nYXkD2eTc/9gGpgsDFHmgGgxSDZeEGa+BixxnA5DiLoUEFRNi5y+QD7bq9n7mxf/TdGgH+7G1biKRVdv5Bg5CC7c0+FTs90bX+gok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y4DHbvoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y4DHbvoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF881F000E9;
	Wed,  5 Aug 2026 02:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896635;
	bh=wv4y8CCQezgqpnXYlmWmluLXiEP3GSVLKdsakizLDTI=;
	h=Date:To:From:Subject;
	b=y4DHbvoPTaMydUhsyn5UxdEeAvi44SydGhA1o9aXiSZ8m67hCjD51yllUhZ+fjgb5
	 x44hyKeLfx2cVfhq7yLGgPDt1wpMHtOAG5IX5489Ed1GhxQ4zjZY4SwO8V21P6RzN8
	 9by+A7WavWuo5V6NSU2JA9YDuVX9qsjPPaOHnbK4=
Date: Tue, 04 Aug 2026 19:23:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,pbonzini@redhat.com,ljs@kernel.org,liam@infradead.org,jthoughton@google.com,david@kernel.org,corbet@lwn.net,aarcange@redhat.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch removed from -mm tree
Message-Id: <20260805022355.8BF881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
has been removed from the -mm tree.  Its filename was
     mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/pagemap: add PAGE_IS_ACCESSED for RWP tracking
Date: Wed, 8 Jul 2026 12:14:12 +0100

PAGEMAP_SCAN already reports PAGE_IS_WRITTEN from the inverted uffd PTE
bit, targeting the UFFDIO_WRITEPROTECT workflow.  UFFDIO_RWPROTECT reuses
the same PTE bit as a marker for read-write protection, but "has been
written" and "has been accessed" are distinct semantic signals — they
happen to share one PTE bit today only because the two implementations
share infrastructure.

Give RWP its own pagemap category so the UAPI does not conflate them:

  PAGE_IS_WRITTEN   reported on VM_UFFD_WP VMAs,  !pte_uffd(pte)
  PAGE_IS_ACCESSED  reported on VM_UFFD_RWP VMAs, !pte_uffd(pte)

Both still read the same PTE bit today, but each is scoped to the VMA
whose registered mode makes the bit meaningful.  If a future
implementation moves RWP to a separate PTE bit, only PAGE_IS_ACCESSED
switches over.

This is a UAPI narrowing.  Outside VM_UFFD_WP VMAs the uffd bit is always
clear, so PAGEMAP_SCAN used to flag PAGE_IS_WRITTEN on every present PTE
there — a meaningless duplicate of PAGE_IS_PRESENT.  Now PAGE_IS_WRITTEN
fires only inside VM_UFFD_WP VMAs.

pagemap_hugetlb_category() now takes the vma like its PTE/PMD peers.

Link: https://lore.kernel.org/20260708111417.173443-12-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |   13 ++-
 fs/proc/task_mmu.c                       |   81 ++++++++++++++-------
 include/uapi/linux/fs.h                  |    1 
 tools/include/uapi/linux/fs.h            |    1 
 4 files changed, 67 insertions(+), 29 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~mm-pagemap-add-page_is_accessed-for-rwp-tracking
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -19,8 +19,11 @@ There are four components to pagemap:
     * Bit  55    pte is soft-dirty (see
       Documentation/admin-guide/mm/soft-dirty.rst)
     * Bit  56    page exclusively mapped (since 4.2)
-    * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
-      Documentation/admin-guide/mm/userfaultfd.rst)
+    * Bit  57    pte is tracked by userfaultfd (since 5.13) — in a
+      ``VM_UFFD_WP`` VMA this indicates a write-protected PTE; in a
+      ``VM_UFFD_RWP`` VMA it indicates an RWP-protected PTE. WP and
+      RWP are mutually exclusive per VMA, so the meaning is
+      unambiguous. See Documentation/admin-guide/mm/userfaultfd.rst.
     * Bit  58    pte is a guard region (since 6.15) (see madvise (2) man page)
     * Bits 59-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
@@ -244,7 +247,8 @@ in this IOCTL:
 Following flags about pages are currently supported:
 
 - ``PAGE_IS_WPALLOWED`` - Page has async-write-protection enabled
-- ``PAGE_IS_WRITTEN`` - Page has been written to from the time it was write protected
+- ``PAGE_IS_WRITTEN`` - Page in a ``UFFDIO_REGISTER_MODE_WP`` VMA has been
+  written to since it was write-protected. Only reported inside such VMAs.
 - ``PAGE_IS_FILE`` - Page is file backed
 - ``PAGE_IS_PRESENT`` - Page is present in the memory
 - ``PAGE_IS_SWAPPED`` - Page is in swapped
@@ -252,6 +256,9 @@ Following flags about pages are currentl
 - ``PAGE_IS_HUGE`` - Page is PMD-mapped THP or Hugetlb backed
 - ``PAGE_IS_SOFT_DIRTY`` - Page is soft-dirty
 - ``PAGE_IS_GUARD`` - Page is a part of a guard region
+- ``PAGE_IS_ACCESSED`` - Page in a ``UFFDIO_REGISTER_MODE_RWP`` VMA has been
+  accessed since RWP was applied. Only reported inside such VMAs. See
+  Documentation/admin-guide/mm/userfaultfd.rst for the RWP workflow.
 
 The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
 
--- a/fs/proc/task_mmu.c~mm-pagemap-add-page_is_accessed-for-rwp-tracking
+++ a/fs/proc/task_mmu.c
@@ -2284,7 +2284,7 @@ static const struct mm_walk_ops pagemap_
  * Bits 5-54  swap offset if swapped
  * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
  * Bit  56    page exclusively mapped
- * Bit  57    pte is uffd-wp write-protected
+ * Bit  57    pte is tracked by userfaultfd (uffd-wp or RWP)
  * Bit  58    pte is a guard region
  * Bits 59-60 zero
  * Bit  61    page is file-page or shared-anon
@@ -2419,7 +2419,7 @@ static int pagemap_release(struct inode
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
 				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
-				 PAGE_IS_GUARD)
+				 PAGE_IS_GUARD | PAGE_IS_ACCESSED)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -2438,15 +2438,17 @@ static unsigned long pagemap_page_catego
 
 	if (pte_none(pte)) {
 		/*
-		 * An unpopulated pte carries no uffd-wp marker, i.e. it is not
-		 * write-protected, the same condition under which the present
-		 * and swap cases below report PAGE_IS_WRITTEN. Report it here
-		 * too so this generic path agrees with the PAGE_IS_WRITTEN fast
-		 * path in pagemap_scan_pmd_entry(), which reports pte_none as
-		 * written and, under PM_SCAN_WP_MATCHING, arms a marker. The
-		 * fast path applies no VMA test, so neither does this.
+		 * An unpopulated pte carries no uffd bit, i.e. it is not
+		 * write-protected. The PAGE_IS_WRITTEN fast path in
+		 * pagemap_scan_pmd_entry() is now gated on a VM_UFFD_WP VMA;
+		 * gate the pte_none report here the same way so the two paths
+		 * still agree. RWP has no such fast path and an unpopulated
+		 * page is not part of the RWP working set, so it is reported as
+		 * neither.
 		 */
-		return PAGE_IS_WRITTEN;
+		if (userfaultfd_wp(vma))
+			return PAGE_IS_WRITTEN;
+		return 0;
 	}
 
 	if (pte_present(pte)) {
@@ -2454,8 +2456,12 @@ static unsigned long pagemap_page_catego
 
 		categories = PAGE_IS_PRESENT;
 
-		if (!pte_uffd(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pte_uffd(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			page = vm_normal_page(vma, addr, pte);
@@ -2472,8 +2478,12 @@ static unsigned long pagemap_page_catego
 
 		categories = PAGE_IS_SWAPPED;
 
-		if (!pte_swp_uffd_any(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pte_swp_uffd_any(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 
 		entry = softleaf_from_pte(pte);
 		if (softleaf_is_guard_marker(entry))
@@ -2522,8 +2532,12 @@ static unsigned long pagemap_thp_categor
 		struct page *page;
 
 		categories |= PAGE_IS_PRESENT;
-		if (!pmd_uffd(pmd))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pmd_uffd(pmd)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			page = vm_normal_page_pmd(vma, addr, pmd);
@@ -2537,8 +2551,12 @@ static unsigned long pagemap_thp_categor
 			categories |= PAGE_IS_SOFT_DIRTY;
 	} else {
 		categories |= PAGE_IS_SWAPPED;
-		if (!pmd_swp_uffd(pmd))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pmd_swp_uffd(pmd)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 		if (pmd_swp_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;
 
@@ -2571,7 +2589,8 @@ static void make_uffd_wp_pmd(struct vm_a
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HUGETLB_PAGE
-static unsigned long pagemap_hugetlb_category(pte_t pte)
+static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
+					      pte_t pte)
 {
 	unsigned long categories = PAGE_IS_HUGE;
 
@@ -2586,8 +2605,12 @@ static unsigned long pagemap_hugetlb_cat
 	if (pte_present(pte)) {
 		categories |= PAGE_IS_PRESENT;
 
-		if (!huge_pte_uffd(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!huge_pte_uffd(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 		if (!PageAnon(pte_page(pte)))
 			categories |= PAGE_IS_FILE;
 		if (is_zero_pfn(pte_pfn(pte)))
@@ -2597,8 +2620,12 @@ static unsigned long pagemap_hugetlb_cat
 	} else {
 		categories |= PAGE_IS_SWAPPED;
 
-		if (!pte_swp_uffd_any(pte))
-			categories |= PAGE_IS_WRITTEN;
+		if (!pte_swp_uffd_any(pte)) {
+			if (userfaultfd_wp(vma))
+				categories |= PAGE_IS_WRITTEN;
+			if (userfaultfd_rwp(vma))
+				categories |= PAGE_IS_ACCESSED;
+		}
 		if (pte_swp_soft_dirty(pte))
 			categories |= PAGE_IS_SOFT_DIRTY;
 	}
@@ -2874,7 +2901,8 @@ static int pagemap_scan_pmd_entry(pmd_t
 		goto flush_and_return;
 	}
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	if (userfaultfd_wp(vma) && !p->arg.category_anyof_mask &&
+	    !p->arg.category_inverted &&
 	    p->arg.category_mask == PAGE_IS_WRITTEN &&
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
@@ -2949,7 +2977,8 @@ static int pagemap_scan_hugetlb_entry(pt
 		/* Go the short route when not write-protecting pages. */
 
 		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+		categories = p->cur_vma_category |
+			     pagemap_hugetlb_category(vma, pte);
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
 			return 0;
@@ -2961,7 +2990,7 @@ static int pagemap_scan_hugetlb_entry(pt
 	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, ptep);
 
 	pte = huge_ptep_get(walk->mm, start, ptep);
-	categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+	categories = p->cur_vma_category | pagemap_hugetlb_category(vma, pte);
 
 	if (!pagemap_scan_is_interesting_page(categories, p))
 		goto out_unlock;
--- a/include/uapi/linux/fs.h~mm-pagemap-add-page_is_accessed-for-rwp-tracking
+++ a/include/uapi/linux/fs.h
@@ -471,6 +471,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
 #define PAGE_IS_GUARD		(1 << 8)
+#define PAGE_IS_ACCESSED	(1 << 9)
 
 /*
  * struct page_region - Page region with flags
--- a/tools/include/uapi/linux/fs.h~mm-pagemap-add-page_is_accessed-for-rwp-tracking
+++ a/tools/include/uapi/linux/fs.h
@@ -364,6 +364,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
 #define PAGE_IS_GUARD		(1 << 8)
+#define PAGE_IS_ACCESSED	(1 << 9)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from kas@kernel.org are

selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch
mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch

