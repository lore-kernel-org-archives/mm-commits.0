Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3638F83
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712343111; cv=none; b=K3VxGwF0Gbyfvn9t4kk15vPmLauehpCa58qvAv2LU8uG4RNpDXOxEL2lodKk24pnV2SH3YkcivF+3VtI/8KctP79WO1Q9EMwj7g6tIDcvmMq2wc7fFADcgvtqu6d1BihhWba505++pz1kHZII+XY/YVitpEywX6NZYYL3pXydQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712343111; c=relaxed/simple;
	bh=JNB1YGZeMXMSKI1kwLtKyOihJ9F3IL3msXQIH3HtjWk=;
	h=Date:To:From:Subject:Message-Id; b=CvAgfc+miF1gp5mflp2wuCu2HOEfZ1F785c8t6mfOJJwiKivmjTKfMqNaYNyqJ5H6wIWGvbqOBrQQLjic7vnPndAI2o6nExYPV+MiQpGqIs7ikqXV4WpufRAZvv02a7jvilQFavde5kRaY9yuh734Gb7iUeBdutOzUGs+dqGl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=We3UGNoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="We3UGNoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F492C433F1;
	Fri,  5 Apr 2024 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712343110;
	bh=JNB1YGZeMXMSKI1kwLtKyOihJ9F3IL3msXQIH3HtjWk=;
	h=Date:To:From:Subject:From;
	b=We3UGNoWONs25D47JIkby9aayqVVs/ZWLsFOuClQaIQ7np0SJbuwc4xInxNaApvWE
	 dNvxJUjcNw9UKqEwm4HQ50Fldw/I3zSWNxuPY7mOoOV/Qc4P8MUCVyPZGbhpF/dnms
	 mRn7R2SgbmFwtXnH6/ZfnmoRIgSFoj9/i4kkz6WE=
Date: Fri, 05 Apr 2024 11:51:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-combine-free_the_page-and-free_unref_page.patch added to mm-unstable branch
Message-Id: <20240405185150.7F492C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: combine free_the_page() and free_unref_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-combine-free_the_page-and-free_unref_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-combine-free_the_page-and-free_unref_page.patch

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
Subject: mm: combine free_the_page() and free_unref_page()
Date: Fri, 5 Apr 2024 16:32:24 +0100

The pcp_allowed_order() check in free_the_page() was only being skipped by
__folio_put_small() which is about to be rearranged.

Link: https://lkml.kernel.org/r/20240405153228.2563754-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/mm/page_alloc.c~mm-combine-free_the_page-and-free_unref_page
+++ a/mm/page_alloc.c
@@ -541,14 +541,6 @@ static inline bool pcp_allowed_order(uns
 	return false;
 }
 
-static inline void free_the_page(struct page *page, unsigned int order)
-{
-	if (pcp_allowed_order(order))		/* Via pcp? */
-		free_unref_page(page, order);
-	else
-		__free_pages_ok(page, order, FPI_NONE);
-}
-
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
  *
@@ -584,7 +576,7 @@ void destroy_large_folio(struct folio *f
 		folio_undo_large_rmappable(folio);
 
 	mem_cgroup_uncharge(folio);
-	free_the_page(&folio->page, folio_order(folio));
+	free_unref_page(&folio->page, folio_order(folio));
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
@@ -2578,6 +2570,11 @@ void free_unref_page(struct page *page,
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
+	if (!pcp_allowed_order(order)) {
+		__free_pages_ok(page, order, FPI_NONE);
+		return;
+	}
+
 	if (!free_pages_prepare(page, order))
 		return;
 
@@ -4760,11 +4757,11 @@ void __free_pages(struct page *page, uns
 	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
-		free_the_page(page, order);
+		free_unref_page(page, order);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
 		while (order-- > 0)
-			free_the_page(page + (1 << order), order);
+			free_unref_page(page + (1 << order), order);
 	}
 }
 EXPORT_SYMBOL(__free_pages);
@@ -4826,7 +4823,7 @@ void __page_frag_cache_drain(struct page
 	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
 
 	if (page_ref_sub_and_test(page, count))
-		free_the_page(page, compound_order(page));
+		free_unref_page(page, compound_order(page));
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
@@ -4867,7 +4864,7 @@ refill:
 			goto refill;
 
 		if (unlikely(nc->pfmemalloc)) {
-			free_the_page(page, compound_order(page));
+			free_unref_page(page, compound_order(page));
 			goto refill;
 		}
 
@@ -4911,7 +4908,7 @@ void page_frag_free(void *addr)
 	struct page *page = virt_to_head_page(addr);
 
 	if (unlikely(put_page_testzero(page)))
-		free_the_page(page, compound_order(page));
+		free_unref_page(page, compound_order(page));
 }
 EXPORT_SYMBOL(page_frag_free);
 
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

