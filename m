Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0471428E0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291654; cv=none; b=CqmRwzd4An0UynEeWTtptFcbDgZgv7ZxpsDBiiYRione1uPnbauO2zXhdW3Ggx2Cj3L8fHn/UKjWE+KWUSCq371SueKxtYif1/hD0/5bN68R+d3UZXCjUX+5BHK6/PX0AgG5/4YjIXYeFbY0gMvv5rSUpBfKBAtPuO0+p/p2N3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291654; c=relaxed/simple;
	bh=EHFr4n4+9zTK5rHYHy4RYLUQdGkX9xpip9t02Poc3yk=;
	h=Date:To:From:Subject:Message-Id; b=q739hSKS+/b+W3U1PVSOJAbp/bR/vC3Teh4Dx18JdaoTYd/BkwH8hChUW+HPgN/PkB0jKGB5yLzVndlEL7GLgYgIwzIQwcPwVqcyYujBtvv9FqsTpiMVAI8A6xmJTD5YYBv5q3zAX+H5K+JatCIRkXD73CB3B6P+kK6qydrKvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XcoB/kTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XcoB/kTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91CDC32782;
	Tue, 25 Jun 2024 05:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291654;
	bh=EHFr4n4+9zTK5rHYHy4RYLUQdGkX9xpip9t02Poc3yk=;
	h=Date:To:From:Subject:From;
	b=XcoB/kTfTOaxXAq2u4i0WTRlZZVwVbjmB9FTa80p+RVBE/JgcabXFnajGOek05RFA
	 6QaetPOE2yVP8lLYnTV6ChoG80oRLH4tXavjY5vxnwRdfcxTfYDfDwSBBfOFVGoxSF
	 A963jqRyYgyUWJQIhRghjy160l+tI09nOxC6Nh38=
Date: Mon, 24 Jun 2024 22:00:53 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.com,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch removed from -mm tree
Message-Id: <20240625050053.E91CDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: account non-present entries as "maybe shared, but no idea how often"
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Oscar Salvador <osalvador@suse.com>
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

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

