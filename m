Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925D2FD1A5
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 19:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576939; cv=none; b=jbqJ4Je4uG1dD3KyfAtK9wDuW7vJCXpPO2oObaN3HDiiIHEsWUUV+wxQkPrmC8sxdohYrenA2vj6NgYy14AKmmPlSidUXciq9klOcmuC7RJqTYcPVQiRXzfMfdweSa+IWSw21NCzkQIqTQAjZugV9O4mGe8aUYTrZhkm7/9lgNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576939; c=relaxed/simple;
	bh=V5WvqNR3IBfTp5ldELD2/L+6asjLG+kkT0zXvl6G9gA=;
	h=Date:To:From:Subject:Message-Id; b=oGVNnuDzpEiOwuOG1UlAcBXckblfi28GiP1Mnyv6lBXZQUHvcj1EX81WqbBvV87xVaaItEmJQcbhDUeR1hLi3QFetH1BBxJFC/IvCCXoIl9JfsjHxv0MOq7fh8BcZO3jiL21vREinmNwxctn4BYLngTV8rmlQh8vc7IJBhtIVKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eq1LXhLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eq1LXhLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D8A1F000E9;
	Mon, 20 Jul 2026 19:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784576936;
	bh=PbWh/T3BaTs1j9lv6mDIp3ZtSLwvtXlastXx+T5P9jI=;
	h=Date:To:From:Subject;
	b=Eq1LXhLg0Xg/q6DWy9LKSklIbFdJuyU1f8GAp40GG7D1aZdd6fqYxt/sSOkgHkNAC
	 /lpWZ3fHx8FO2Wr9dzgUhI3l2SqGlqoC8ajaugflFqXQxq0C8Ds07ykBh/MRco3VO/
	 XSXIgLfWbb8Kl8aDmtbhi11RLNm0faZMIaFaq/Qg=
Date: Mon, 20 Jul 2026 12:48:56 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch added to mm-new branch
Message-Id: <20260720194856.D3D8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
Date: Mon, 20 Jul 2026 15:38:35 +0100

Currently, anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
mappings are indexed by their page offset within the file in which they
were originally mapped.

This differs from anonymous folios belonging to pure anon mappings which
are indexed by their virtual page offset (the address at which they'd
belong in the VMA when first faulted).

This change fixes this inconsistency, always indexing anonymous folios by
their virtual page offset regardless of the VMA to which they belong.

We have laid the foundations for making this change to the point where we
need only 'switch it on', and this patch switches it on by:

* Using linear_virt_page_index() in __folio_set_anon() to assign the
  folio's index to the anonymous linear index rather than the file-backed
  one.

* Otherwise using linear_virt_page_index() in all instances where
  anonymous folios are being referenced or manipulated.

* Replacing vma_address() with vma_filebacked_address() or
  vma_anon_address() as appropriate.

* Updating the rmap lock logic in copy_vma() to also account for virtual
  page offsets.

* Updating the merging logic to check that virtual page offsets are
  aligned as well as filebacked ones for anonymous or MAP_PRIVATE
  file-backed VMAs.

* Updating linear_folio_page_index() to invoke linear_virt_page_index()
  if the folio is anonymous.

* Correcting folio_within_range() to use virtual page offset for anonymous
  folios.

This will have no impact on merging of anonymous VMAs or shared
file-backed VMAs, whose page offset and anonymous page offset will be
identical.

However, MAP_PRIVATE file-backed mappings must now be aligned on virtual
page offset as well.

In most instances this should have no impact on merging of file-backed
mappings, which are usually not merged all that often, let alone
MAP_PRIVATE mapped ones, and rarely remapped and faulted before being
moved back in place (the case in which a merge may now fail).

One subtle impact of this change is in NUMA interleaving - since commit
88c91dc58582 ("mempolicy: migration attempt to match interleave nodes"),
migration heuristically tries to maintain interleaving behaviour matching
the policy using folio indices.

When doing migration of CoW'd MAP_PRIVATE-file backed ranges, the 'base'
upon which the interleaving behaviour is performed will vary for these
ranges.  However the commit notes that ranges spanning multiple VMAs will
already cause varying bases, and that this is an acceptable approximation.

It is very unlikely real world use-cases will be impacted by this
(MAP_PRIVATE file-backed mappings are already an edge case), and all that
will happen is that such ranges will cause interleaving to be rotated over
the CoW'd range, with little to no impact.

This commit lays the foundations for future scalable CoW work which needs
to track some remaps, meaning that most remap tracking can be avoided, and
in nearly all cases the anonymous page offset will be able to be used to
quickly find the VMA in an mm.

Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-9-2d549757a76f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 ++++++++-
 mm/internal.h           |   28 +++++++++-------------------
 mm/interval_tree.c      |    4 ++--
 mm/ksm.c                |    7 ++++---
 mm/page_vma_mapped.c    |    2 +-
 mm/rmap.c               |   12 ++++++------
 mm/vma.c                |   14 ++++++++++++--
 7 files changed, 42 insertions(+), 34 deletions(-)

--- a/include/linux/pagemap.h~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/include/linux/pagemap.h
@@ -1150,7 +1150,11 @@ static inline pgoff_t linear_virt_page_i
  * @vma: The VMA in which @address resides.
  * @address: The address whose absolute page offset is required.
  *
- * For compatibility, currently identical to linear_page_index().
+ * Determines whether to obtain the virtual linear page index based on whether
+ * @folio is anonymous or not.
+ *
+ * See the descriptions of linear_virt_page_index() and linear_page_index() for
+ * details of each.
  *
  * Returns: The absolute page offset of @address within @vma.
  */
@@ -1158,6 +1162,9 @@ static inline pgoff_t linear_folio_page_
 					      const struct vm_area_struct *vma,
 					      const unsigned long address)
 {
+	if (folio_test_anon(folio))
+		return linear_virt_page_index(vma, address);
+
 	return linear_page_index(vma, address);
 }
 
--- a/mm/internal.h~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/mm/internal.h
@@ -933,7 +933,8 @@ folio_within_range(struct folio *folio,
 		return false;
 
 	pgoff_folio = folio_pgoff(folio);
-	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_vma_start = folio_test_anon(folio) ?
+		vma_start_virt_pgoff(vma) : vma_start_pgoff(vma);
 
 	if (start < vma->vm_start)
 		start = vma->vm_start;
@@ -1044,23 +1045,8 @@ static inline unsigned long vma_fileback
 }
 
 /**
- * vma_address - Find the virtual address a page range is mapped at.
- * @vma: The vma which maps this object.
- * @pgoff: The page offset within its object.
- * @nr_pages: The number of pages to consider.
- *
- * If any page in this range is mapped by this VMA, return the first address
- * where any of these pages appear.  Otherwise, return -EFAULT.
- */
-static inline unsigned long vma_address(const struct vm_area_struct *vma,
-		pgoff_t pgoff, unsigned long nr_pages)
-{
-	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
-}
-
-/**
- * vma_anon_address - Find the address an anonymous folio with index @pgoff_virt
- * is mapped at.
+ * vma_anon_address - Find the virtual address an anonymous page range is mapped
+ * at.
  * @vma: The vma which maps this object.
  * @pgoff_virt: The virtual page index belonging to the folio.
  * @nr_pages: The number of pages to consider.
@@ -1094,7 +1080,11 @@ static inline unsigned long vma_address_
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff_vma_start = vma_start_pgoff(vma);
+	if (pvmw->is_anon_walk)
+		pgoff_vma_start = vma_start_virt_pgoff(vma);
+	else
+		pgoff_vma_start = vma_start_pgoff(vma);
+
 	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
 		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
--- a/mm/interval_tree.c~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/mm/interval_tree.c
@@ -83,12 +83,12 @@ mapping_rmap_tree_iter_next(struct vm_ar
 
 static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
-	return vma_start_pgoff(avc->vma);
+	return vma_start_virt_pgoff(avc->vma);
 }
 
 static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
-	return vma_last_pgoff(avc->vma);
+	return vma_last_virt_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
--- a/mm/ksm.c~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/mm/ksm.c
@@ -1625,7 +1625,8 @@ static int try_to_merge_with_ksm_page(st
 	 * stable_tree, break_cow() will clean it up.
 	 */
 	rmap_item->anon_vma = vma->anon_vma;
-	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
+	/* The VMA is always anon/MAP_PRIVATE-file backed so use anon index. */
+	rmap_item->linear_page_index = linear_virt_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -3152,7 +3153,7 @@ struct folio *ksm_might_need_to_copy(str
 			return folio;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return folio;		/* no need to copy it */
-	} else if (folio->index == linear_page_index(vma, addr) &&
+	} else if (folio->index == linear_virt_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
 		return folio;		/* still no need to copy it */
 	}
@@ -3222,7 +3223,7 @@ again:
 		/*
 		 * Currently, KSM folios are always small folios, so it's
 		 * sufficient to search for a single page. We can simply use
-		 * the linear_page_index of the original de-duplicate
+		 * the linear_virt_page_index of the original de-duplicate
 		 * anonymous page that we remembered in the rmap_item while
 		 * de-duplicating. Note that mremap() always de-duplicates KSM
 		 * folios: so if there was mremap() in our parent or our child,
--- a/mm/page_vma_mapped.c~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/mm/page_vma_mapped.c
@@ -365,7 +365,7 @@ unsigned long page_mapped_in_vma(const s
 	};
 
 	if (folio_test_anon(folio))
-		pvmw.address = vma_address(vma, pgoff, 1);
+		pvmw.address = vma_anon_address(vma, pgoff, 1);
 	else
 		pvmw.address = vma_filebacked_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
--- a/mm/rmap.c~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/mm/rmap.c
@@ -866,7 +866,7 @@ unsigned long page_address_in_vma(const
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
 		/* KSM folios don't reach here because of the !anon_vma check */
-		return vma_address(vma, page_pgoff(folio, page), 1);
+		return vma_anon_address(vma, page_pgoff(folio, page), 1);
 	} else if (!vma->vm_file) {
 		return -EFAULT;
 	} else if (vma->vm_file->f_mapping != folio->mapping) {
@@ -1485,7 +1485,7 @@ static void __folio_set_anon(struct foli
 	 */
 	anon_vma = (void *) anon_vma + FOLIO_MAPPING_ANON;
 	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
-	folio->index = linear_page_index(vma, address);
+	folio->index = linear_virt_page_index(vma, address);
 }
 
 /**
@@ -1512,8 +1512,8 @@ static void __page_check_anon_rmap(const
 	 */
 	VM_BUG_ON_FOLIO(folio_anon_vma(folio)->root != vma->anon_vma->root,
 			folio);
-	VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address),
-		       page);
+	VM_BUG_ON_PAGE(page_pgoff(folio, page) !=
+		       linear_virt_page_index(vma, address), page);
 }
 
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
@@ -3040,10 +3040,10 @@ static void rmap_walk_anon(struct folio
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
 	anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(vma, pgoff_start,
+		const unsigned long address = vma_anon_address(vma, pgoff_start,
 				folio_nr_pages(folio));
 
-		VM_BUG_ON_VMA(address == -EFAULT, vma);
+		VM_WARN_ON_ONCE_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
--- a/mm/vma.c~mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios
+++ a/mm/vma.c
@@ -233,6 +233,8 @@ static bool can_vma_merge_before(struct
 		return false;
 	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
 		return false;
+	if (vmg_end_anon_pgoff(vmg) != vma_start_anon_pgoff(vmg->next))
+		return false;
 	return true;
 }
 
@@ -253,6 +255,8 @@ static bool can_vma_merge_after(struct v
 		return false;
 	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
 		return false;
+	if (vma_end_anon_pgoff(vmg->prev) != vmg_start_anon_pgoff(vmg))
+		return false;
 	return true;
 }
 
@@ -1988,7 +1992,8 @@ struct vm_area_struct *copy_vma(struct v
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
-			(vma_start_pgoff(new_vma) <= vma_start_pgoff(vma));
+			(vma_start_pgoff(new_vma) <= vma_start_pgoff(vma)) ||
+			(vma_start_anon_pgoff(new_vma) <= vma_start_anon_pgoff(vma));
 	} else {
 		new_vma = vm_area_dup(vma);
 		if (!new_vma)
@@ -2059,7 +2064,12 @@ static int anon_vma_compatible(struct vm
 	if (!vma_flags_empty(&diff))
 		return false;
 	/* Page offset must align. */
-	return vma_end_pgoff(a) == vma_start_pgoff(b);
+	if (vma_end_pgoff(a) != vma_start_pgoff(b))
+		return false;
+	/* Anon page offset must align. */
+	if (vma_end_anon_pgoff(a) != vma_start_anon_pgoff(b))
+		return false;
+	return true;
 }
 
 /*
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

