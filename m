Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519AF38F83
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712343115; cv=none; b=a33yMmB21bjIp/ijmR0rObRdH1WVNQ6RQYKJomY9WkcLE9BGIo4HHbTK4XBGTzYGU4yg/n/gSfCixIeMBSbKUiut4NvHPacM5jzVtQ0thON0zs0heUHo+kgeWKpJtdX++/z5QtbG/oeqZnZ9NWoX4oSdZntynriCk5gWQ9FLFGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712343115; c=relaxed/simple;
	bh=LywzFPhWFIhQ7AFyIkvH9uQgA9gjCkviqsMQXZZk0PE=;
	h=Date:To:From:Subject:Message-Id; b=G+9TJGulRBH6Pes4OnqvKzPpePyA8Pvk9zwfEJjgJyMvjuHadH/NjF/15p8uTnEjsb32ds/ViEcvAELcXPf00b0aLbIxY4jfNSCyt9ZXJozht2ivAdog4+bnGu+eBXkTIUlNjbGOJLGdxYxor5wKxxnJM8a78crh/75O4E4NB+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZFdFpNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZFdFpNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DAFC433F1;
	Fri,  5 Apr 2024 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712343114;
	bh=LywzFPhWFIhQ7AFyIkvH9uQgA9gjCkviqsMQXZZk0PE=;
	h=Date:To:From:Subject:From;
	b=vZFdFpNpXDM0JjyMzcFRpYyRLFZC3BQUiDe/OEd47mgQaZEJFlMq3labxbqc7G24B
	 85lr3I1SWD2t1GTN1FRBRlDEn466VWABH6f8XQkBf2II/Ht7mVDRkQk9f9AjWsEiST
	 HcEctrzo4P8+I2Ddr/9YFcfXaAvuvbAj9+w3MNgM=
Date: Fri, 05 Apr 2024 11:51:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch added to mm-unstable branch
Message-Id: <20240405185154.C9DAFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: combine __folio_put_small, __folio_put_large and __folio_put
has been added to the -mm mm-unstable branch.  Its filename is
     mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch

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
Subject: mm: combine __folio_put_small, __folio_put_large and __folio_put
Date: Fri, 5 Apr 2024 16:32:26 +0100

It's now obvious that __folio_put_small() and __folio_put_large() do
almost exactly the same thing.  Inline them both into __folio_put().

Link: https://lkml.kernel.org/r/20240405153228.2563754-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/mm/swap.c~mm-combine-__folio_put_small-__folio_put_large-and-__folio_put
+++ a/mm/swap.c
@@ -112,42 +112,22 @@ static void page_cache_release(struct fo
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
-static void __folio_put_small(struct folio *folio)
-{
-	page_cache_release(folio);
-	mem_cgroup_uncharge(folio);
-	free_unref_page(&folio->page, 0);
-}
-
-static void __folio_put_large(struct folio *folio)
+void __folio_put(struct folio *folio)
 {
-	/*
-	 * __page_cache_release() is supposed to be called for thp, not for
-	 * hugetlb. This is because hugetlb page does never have PageLRU set
-	 * (it's never listed to any LRU lists) and no memcg routines should
-	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
-	 */
-	if (folio_test_hugetlb(folio)) {
+	if (unlikely(folio_is_zone_device(folio))) {
+		free_zone_device_page(&folio->page);
+		return;
+	} else if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
 	}
 
 	page_cache_release(folio);
-	if (folio_test_large_rmappable(folio))
+	if (folio_test_large(folio) && folio_test_large_rmappable(folio))
 		folio_undo_large_rmappable(folio);
 	mem_cgroup_uncharge(folio);
 	free_unref_page(&folio->page, folio_order(folio));
 }
-
-void __folio_put(struct folio *folio)
-{
-	if (unlikely(folio_is_zone_device(folio)))
-		free_zone_device_page(&folio->page);
-	else if (unlikely(folio_test_large(folio)))
-		__folio_put_large(folio);
-	else
-		__folio_put_small(folio);
-}
 EXPORT_SYMBOL(__folio_put);
 
 /**
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

