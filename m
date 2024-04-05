Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B3938F83
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712343112; cv=none; b=iLTj4o/JU0gvCkLHWUkSV0z9QtmrRTWYUNaL5TefQI9vbtU1jvQObEb8D/cJEAh5IecF6sWRRjJ+gMymiS5KEM4NtrLa1ijUtWo7rQrECghRcljN23rgF4u3wbjdtxrXmT8GDOsrgq8R1fPcmHeyXFqu4OmlWbkibp/20PkXhcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712343112; c=relaxed/simple;
	bh=Do+R1yBOK5EYGltxnBrYiK230zGGFogA5LJKleHP9uE=;
	h=Date:To:From:Subject:Message-Id; b=Y9afwgiTjhDpjIED88HcCXeqrccZhLepMT5tC14mt3zbNHweBdNs2JcmHAnOumLOci56a83DIhwOjW6smqat7aKPm74HTgJLRJlxS2q0DpSxiWmzOxcwIwPDEy4LeIhC+x8NAa6tVVJx2uR/N38899ljDQYKqtpJU53fgNU4zUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A6JH41Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A6JH41Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB0FC433C7;
	Fri,  5 Apr 2024 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712343112;
	bh=Do+R1yBOK5EYGltxnBrYiK230zGGFogA5LJKleHP9uE=;
	h=Date:To:From:Subject:From;
	b=A6JH41Drlkini+N2Tj4Xl0N+Iptv923h9JzeIFnrOOrDS85c5iVPfmeq8BHNUVini
	 Gz451uBz8lhPYTXzKuaUhcgvo1FHgh3eaZYzW4r4JiuUfZEjmPdytnmWSxE4KP7Soe
	 R8l7E3owY6VrY/gKZFqFk5Hsg9Iy6DLTvk7axaVg=
Date: Fri, 05 Apr 2024 11:51:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-inline-destroy_large_folio-into-__folio_put_large.patch added to mm-unstable branch
Message-Id: <20240405185152.4FB0FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: inline destroy_large_folio() into __folio_put_large()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-inline-destroy_large_folio-into-__folio_put_large.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-inline-destroy_large_folio-into-__folio_put_large.patch

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
Subject: mm: inline destroy_large_folio() into __folio_put_large()
Date: Fri, 5 Apr 2024 16:32:25 +0100

destroy_large_folio() has only one caller, move its contents there.

Link: https://lkml.kernel.org/r/20240405153228.2563754-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/page_alloc.c    |   14 --------------
 mm/swap.c          |   13 ++++++++++---
 3 files changed, 10 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-inline-destroy_large_folio-into-__folio_put_large
+++ a/include/linux/mm.h
@@ -1318,8 +1318,6 @@ void folio_copy(struct folio *dst, struc
 
 unsigned long nr_free_buffer_pages(void);
 
-void destroy_large_folio(struct folio *folio);
-
 /* Returns the number of bytes in this potentially compound page. */
 static inline unsigned long page_size(struct page *page)
 {
--- a/mm/page_alloc.c~mm-inline-destroy_large_folio-into-__folio_put_large
+++ a/mm/page_alloc.c
@@ -565,20 +565,6 @@ void prep_compound_page(struct page *pag
 	prep_compound_head(page, order);
 }
 
-void destroy_large_folio(struct folio *folio)
-{
-	if (folio_test_hugetlb(folio)) {
-		free_huge_folio(folio);
-		return;
-	}
-
-	if (folio_test_large_rmappable(folio))
-		folio_undo_large_rmappable(folio);
-
-	mem_cgroup_uncharge(folio);
-	free_unref_page(&folio->page, folio_order(folio));
-}
-
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
--- a/mm/swap.c~mm-inline-destroy_large_folio-into-__folio_put_large
+++ a/mm/swap.c
@@ -127,9 +127,16 @@ static void __folio_put_large(struct fol
 	 * (it's never listed to any LRU lists) and no memcg routines should
 	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
 	 */
-	if (!folio_test_hugetlb(folio))
-		page_cache_release(folio);
-	destroy_large_folio(folio);
+	if (folio_test_hugetlb(folio)) {
+		free_huge_folio(folio);
+		return;
+	}
+
+	page_cache_release(folio);
+	if (folio_test_large_rmappable(folio))
+		folio_undo_large_rmappable(folio);
+	mem_cgroup_uncharge(folio);
+	free_unref_page(&folio->page, folio_order(folio));
 }
 
 void __folio_put(struct folio *folio)
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

