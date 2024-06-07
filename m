Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ED215380A
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717793962; cv=none; b=QrAt3sG4WzrFGzQCDd5t2Geecpl6VKyOxnrceNo7atXqAYg/ldl7j2OEhMHQcYmj+bDGqc6q6L1YPoshlpZodQXWhFoVZen1a7J7pQX+hI4nKegVgNqMiqy14lOcUrgyvCQ9ZFI/2eHpMRQ0USeWVVf3K+DvjSuaSnMVU+O7B/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717793962; c=relaxed/simple;
	bh=HeqxFY4NwO1rTVY43EFxbZlzSmx8XYm0udKUiMFk1Tk=;
	h=Date:To:From:Subject:Message-Id; b=I8SQ7b+pRkjOzAMMioo6wpEcucFkbNeiltBkGnA22gg66vsj73zG6ETshJOofZr/R2ftyy2TkhVn8NFvbVJdJfgcXRp8JWm7E9pROGq3wBH7bl8dw2GSQ1XREAGkGr0uS2aB1268MHoRi757VNT+iZhWAOYVlidW/ZqEdtC4ll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sbe7+JoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sbe7+JoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EFEC2BBFC;
	Fri,  7 Jun 2024 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717793962;
	bh=HeqxFY4NwO1rTVY43EFxbZlzSmx8XYm0udKUiMFk1Tk=;
	h=Date:To:From:Subject:From;
	b=sbe7+JoNuHqxE3wjue5g+ozJfXY2+XQD64aEaTC887f6jOEWqogUvEM3fS95Z5I35
	 +LWTHzB29hQ8DBEUs4O9M9ikVS8NUQs/cyFFTNuCE0+jEZcHGgC/YLkJZkJcLdjg/1
	 WWUzNO7hYqPBEBVGfgSfFDAOLBL+TFUznnnMVLkg=
Date: Fri, 07 Jun 2024 13:59:21 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch added to mm-unstable branch
Message-Id: <20240607205921.E1EFEC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: account non-present entries as "maybe shared, but no idea how often"
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch

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
Subject: fs/proc/task_mmu: account non-present entries as "maybe shared, but no idea how often"
Date: Fri, 7 Jun 2024 14:23:55 +0200

We currently rely on mapcount information for pages referenced by
non-present entries to calculate the USS (shared vs.  private) and the
PSS.

However, relying on mapcounts for non-present entries doesn't make any
sense.  We have to treat such entries as "maybe shared, but no idea how
often", implying that they will *not* get accounted towards the USS, and
will get fully accounted to the PSS (no idea how often shared).

There is one exception: device exclusive entries essentially behave like
present entries (e.g., mapcount incremented).

In smaps_pmd_entry(), use is_pfn_swap_entry() instead of
is_migration_entry(), which should not make a real difference but makes
the code look more similar to the PTE variant.

While at it, adjust the comments in smaps_account().

Link: https://lkml.kernel.org/r/20240607122357.115423-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   53 +++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often
+++ a/fs/proc/task_mmu.c
@@ -442,7 +442,7 @@ static void smaps_page_accumulate(struct
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
-		bool migration)
+		bool present)
 {
 	struct folio *folio = page_folio(page);
 	int i, nr = compound ? compound_nr(page) : 1;
@@ -471,22 +471,27 @@ static void smaps_account(struct mem_siz
 	 * Then accumulate quantities that may depend on sharing, or that may
 	 * differ page-by-page.
 	 *
-	 * refcount == 1 guarantees the page is mapped exactly once.
-	 * If any subpage of the compound page mapped with PTE it would elevate
-	 * the refcount.
+	 * refcount == 1 for present entries guarantees that the folio is mapped
+	 * exactly once. For large folios this implies that exactly one
+	 * PTE/PMD/... maps (a part of) this folio.
 	 *
-	 * The page_mapcount() is called to get a snapshot of the mapcount.
-	 * Without holding the page lock this snapshot can be slightly wrong as
-	 * we cannot always read the mapcount atomically.  It is not safe to
-	 * call page_mapcount() even with PTL held if the page is not mapped,
-	 * especially for migration entries.  Treat regular migration entries
-	 * as mapcount == 1.
+	 * Treat all non-present entries (where relying on the mapcount and
+	 * refcount doesn't make sense) as "maybe shared, but not sure how
+	 * often". We treat device private entries as being fake-present.
+	 *
+	 * Note that it would not be safe to read the mapcount especially for
+	 * pages referenced by migration entries, even with the PTL held.
 	 */
-	if ((folio_ref_count(folio) == 1) || migration) {
+	if (folio_ref_count(folio) == 1 || !present) {
 		smaps_page_accumulate(mss, folio, size, size << PSS_SHIFT,
-				dirty, locked, true);
+				      dirty, locked, present);
 		return;
 	}
+	/*
+	 * The page_mapcount() is called to get a snapshot of the mapcount.
+	 * Without holding the folio lock this snapshot can be slightly wrong as
+	 * we cannot always read the mapcount atomically.
+	 */
 	for (i = 0; i < nr; i++, page++) {
 		int mapcount = page_mapcount(page);
 		unsigned long pss = PAGE_SIZE << PSS_SHIFT;
@@ -531,13 +536,14 @@ static void smaps_pte_entry(pte_t *pte,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool migration = false, young = false, dirty = false;
+	bool present = false, young = false, dirty = false;
 	pte_t ptent = ptep_get(pte);
 
 	if (pte_present(ptent)) {
 		page = vm_normal_page(vma, addr, ptent);
 		young = pte_young(ptent);
 		dirty = pte_dirty(ptent);
+		present = true;
 	} else if (is_swap_pte(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
@@ -555,8 +561,8 @@ static void smaps_pte_entry(pte_t *pte,
 				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
 			}
 		} else if (is_pfn_swap_entry(swpent)) {
-			if (is_migration_entry(swpent))
-				migration = true;
+			if (is_device_private_entry(swpent))
+				present = true;
 			page = pfn_swap_entry_to_page(swpent);
 		}
 	} else {
@@ -567,7 +573,7 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, young, dirty, locked, migration);
+	smaps_account(mss, page, false, young, dirty, locked, present);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -578,18 +584,17 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool present = false;
 	struct folio *folio;
-	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		page = vm_normal_page_pmd(vma, addr, *pmd);
+		present = true;
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
-		if (is_migration_entry(entry)) {
-			migration = true;
+		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
-		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
@@ -604,7 +609,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 		mss->file_thp += HPAGE_PMD_SIZE;
 
 	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
-		      locked, migration);
+		      locked, present);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -732,17 +737,21 @@ static int smaps_hugetlb_range(pte_t *pt
 	struct vm_area_struct *vma = walk->vma;
 	pte_t ptent = huge_ptep_get(pte);
 	struct folio *folio = NULL;
+	bool present = false;
 
 	if (pte_present(ptent)) {
 		folio = page_folio(pte_page(ptent));
+		present = true;
 	} else if (is_swap_pte(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
 		if (is_pfn_swap_entry(swpent))
 			folio = pfn_swap_entry_folio(swpent);
 	}
+
 	if (folio) {
-		if (folio_likely_mapped_shared(folio) ||
+		/* We treat non-present entries as "maybe shared". */
+		if (!present || folio_likely_mapped_shared(folio) ||
 		    hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

