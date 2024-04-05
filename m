Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DB7172798
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712343117; cv=none; b=IZzido5AiO+3ROXEVIgKWleBaVY9Gx+QPJEnpIuhQKnmgIy+T1JUIMAXzrkuxWahpm5umB1VNh27YWZBKNO0zZU6vhno2DvFxzSm3SLADEi6uiWsVN/ziklvfQYNnEWdUUZjRX4FviLjR92D/ekdnQbtrxBmJCwKC86H4eelvG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712343117; c=relaxed/simple;
	bh=JdKRM+0KBjLXJVbXXCCnNAS9kEu0oto1G7tQkYjBScU=;
	h=Date:To:From:Subject:Message-Id; b=hej6+9EZIkSrNbl/lozNn7eGBOpnCAU/EbALDuyuYzOvOe7Jtwx6KZdpzsB8GDTQ3Cdi6WwC3NbXXe6+sro9lZ6g+5CsC9eOAzXytSK6Sxala1Yr/UQkna9TFQlt5Y9VWEBZg9GUyt/CMlIsZaGbrMQui4uO4RWiYgoelBGDTps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L6doJxz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L6doJxz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D9C433C7;
	Fri,  5 Apr 2024 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712343116;
	bh=JdKRM+0KBjLXJVbXXCCnNAS9kEu0oto1G7tQkYjBScU=;
	h=Date:To:From:Subject:From;
	b=L6doJxz0DinmS5wsUtgAgSMmyppJt934zDvEzGEikUjCaV8zDOHIAoAaH898+jJJ3
	 INh/dXdiFWMBf4HNAbRioHmDmPm82jLn/QkVkYyc3BDKH8X62bkYhdT/pB2uZSaOe8
	 0Hntzv3w1fyiSQ4GD7Gavq9ppZrJR0JU+Ub4KVWs=
Date: Fri, 05 Apr 2024 11:51:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_zone_device_page-to-free_zone_device_folio.patch added to mm-unstable branch
Message-Id: <20240405185156.9F4D9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert free_zone_device_page to free_zone_device_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-free_zone_device_page-to-free_zone_device_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_zone_device_page-to-free_zone_device_folio.patch

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
Subject: mm: convert free_zone_device_page to free_zone_device_folio
Date: Fri, 5 Apr 2024 16:32:27 +0100

Both callers already have a folio; pass it in and save a few calls to
compound_head().

Link: https://lkml.kernel.org/r/20240405153228.2563754-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/memremap.c |   30 ++++++++++++++++--------------
 mm/swap.c     |    4 ++--
 3 files changed, 19 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-convert-free_zone_device_page-to-free_zone_device_folio
+++ a/mm/internal.h
@@ -1149,7 +1149,7 @@ void __vunmap_range_noflush(unsigned lon
 int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int page_nid, int *flags);
 
-void free_zone_device_page(struct page *page);
+void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_page(struct page *page);
 
 /*
--- a/mm/memremap.c~mm-convert-free_zone_device_page-to-free_zone_device_folio
+++ a/mm/memremap.c
@@ -456,21 +456,23 @@ struct dev_pagemap *get_dev_pagemap(unsi
 }
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
-void free_zone_device_page(struct page *page)
+void free_zone_device_folio(struct folio *folio)
 {
-	if (WARN_ON_ONCE(!page->pgmap->ops || !page->pgmap->ops->page_free))
+	if (WARN_ON_ONCE(!folio->page.pgmap->ops ||
+			!folio->page.pgmap->ops->page_free))
 		return;
 
-	mem_cgroup_uncharge(page_folio(page));
+	mem_cgroup_uncharge(folio);
 
 	/*
 	 * Note: we don't expect anonymous compound pages yet. Once supported
 	 * and we could PTE-map them similar to THP, we'd have to clear
 	 * PG_anon_exclusive on all tail pages.
 	 */
-	VM_BUG_ON_PAGE(PageAnon(page) && PageCompound(page), page);
-	if (PageAnon(page))
-		__ClearPageAnonExclusive(page);
+	if (folio_test_anon(folio)) {
+		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
+		__ClearPageAnonExclusive(folio_page(folio, 0));
+	}
 
 	/*
 	 * When a device managed page is freed, the folio->mapping field
@@ -481,20 +483,20 @@ void free_zone_device_page(struct page *
 	 *
 	 * For other types of ZONE_DEVICE pages, migration is either
 	 * handled differently or not done at all, so there is no need
-	 * to clear page->mapping.
+	 * to clear folio->mapping.
 	 */
-	page->mapping = NULL;
-	page->pgmap->ops->page_free(page);
+	folio->mapping = NULL;
+	folio->page.pgmap->ops->page_free(folio_page(folio, 0));
 
-	if (page->pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    page->pgmap->type != MEMORY_DEVICE_COHERENT)
+	if (folio->page.pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    folio->page.pgmap->type != MEMORY_DEVICE_COHERENT)
 		/*
-		 * Reset the page count to 1 to prepare for handing out the page
+		 * Reset the refcount to 1 to prepare for handing out the page
 		 * again.
 		 */
-		set_page_count(page, 1);
+		folio_set_count(folio, 1);
 	else
-		put_dev_pagemap(page->pgmap);
+		put_dev_pagemap(folio->page.pgmap);
 }
 
 void zone_device_page_init(struct page *page)
--- a/mm/swap.c~mm-convert-free_zone_device_page-to-free_zone_device_folio
+++ a/mm/swap.c
@@ -115,7 +115,7 @@ static void page_cache_release(struct fo
 void __folio_put(struct folio *folio)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
-		free_zone_device_page(&folio->page);
+		free_zone_device_folio(folio);
 		return;
 	} else if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
@@ -984,7 +984,7 @@ void folios_put_refs(struct folio_batch
 			if (put_devmap_managed_page_refs(&folio->page, nr_refs))
 				continue;
 			if (folio_ref_sub_and_test(folio, nr_refs))
-				free_zone_device_page(&folio->page);
+				free_zone_device_folio(folio);
 			continue;
 		}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch

