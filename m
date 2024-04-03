Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017718AF9
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712180323; cv=none; b=ahTaaatDKid86JOWWq2g6ctETM/LAEEcSUlM9eTO+OOmM81pMtSdSG2wl0UazeQA+IilRE0RpuTDjo+OAI32FNTcnCCzfhhqTQNoXxmSvG9mA4Oki7OS73Lxm4HHiwwy0jAhOxsVTmIZiL06i/0yquV9SBmqN6YxiFLNxqERd6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712180323; c=relaxed/simple;
	bh=XD3lO3UezjRQyKynVJC/KPhSahHrlC899wgHJeKL3jY=;
	h=Date:To:From:Subject:Message-Id; b=aQ0tMoqTyKZUgJfESaXjy9YhOU9/AB1UqOGkBIWv/W+w+dXBeQDSkLvz1nCo0B/8weWry0ZDwskUr4n3l2fFPTXM3Fu3ML0OEijtGhHRoPerCsO0M5gIXvZtm4JcOm9gUBci2yYMZs2iVKKR5Pauq0LTKe0+bE/o+ie7yDXqDx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dj8PmSE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dj8PmSE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D41DC433C7;
	Wed,  3 Apr 2024 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712180323;
	bh=XD3lO3UezjRQyKynVJC/KPhSahHrlC899wgHJeKL3jY=;
	h=Date:To:From:Subject:From;
	b=dj8PmSE6HDkGgBCV2Ai6MaYol2YpEJP3lOJ3AU1rvgXkWjUP3xVX3t0rSwu1PiCS0
	 i7fkZTYY0jKghbiVmO4HYRSWZliZTCWF0tuAIDZ6v5yVpZ24tO9a5D97zrfflF3gim
	 Q3cWCAdY8q4m52eXFWj3xNjJgVIOkJsKV96YMNKs=
Date: Wed, 03 Apr 2024 14:38:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-struct-page-from-get_shadow_from_swap_cache.patch added to mm-unstable branch
Message-Id: <20240403213843.0D41DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove struct page from get_shadow_from_swap_cache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-struct-page-from-get_shadow_from_swap_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-struct-page-from-get_shadow_from_swap_cache.patch

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
Subject: mm: remove struct page from get_shadow_from_swap_cache
Date: Tue, 2 Apr 2024 21:16:57 +0100

We don't actually use any parts of struct page; all we do is check the
value of the pointer.  So give the pointer the appropriate name & type.

Link: https://lkml.kernel.org/r/20240402201659.918308-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swap_state.c~mm-remove-struct-page-from-get_shadow_from_swap_cache
+++ a/mm/swap_state.c
@@ -73,11 +73,11 @@ void *get_shadow_from_swap_cache(swp_ent
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
-	struct page *page;
+	void *shadow;
 
-	page = xa_load(&address_space->i_pages, idx);
-	if (xa_is_value(page))
-		return page;
+	shadow = xa_load(&address_space->i_pages, idx);
+	if (xa_is_value(shadow))
+		return shadow;
 	return NULL;
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

