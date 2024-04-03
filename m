Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEDF155381
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171699; cv=none; b=D0DjrGHxsDbHUR7aK+VC7ZycVTwT/urzpXoF5Gxe1GdUNGy+8T2ysnmbRVqmvyOFOMysDUUodlskbNCzWg4GeUmE0vRbMwd5gL5XvAVZVphR34Y/YgeVCI8DM13x9bpr7hvzLwAlNMA4Oa9pNK7o1UU4dy0Vx6ByJlFfNrPOmfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171699; c=relaxed/simple;
	bh=VmGEBygNrtyfrZQ2YGrVwqpj7w7z+U4NuqoDXs5sEdA=;
	h=Date:To:From:Subject:Message-Id; b=DfqPB6psmOGhC/0+mGsyLz7kh1EVeW7WjMy8g9bH24eoWstJ5za3HnHOc3YOhFWLJ7BYb57XiwuilM8HyjUXxBz4SBdsGY9rrpofESjG+orJibUzyV1Kd66FjjndRZSH0wcqcLZAE4y/CXlwVgb6M3QNJOkLKoExt+30i2FPQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gy9paCDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gy9paCDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D22FC433F1;
	Wed,  3 Apr 2024 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171699;
	bh=VmGEBygNrtyfrZQ2YGrVwqpj7w7z+U4NuqoDXs5sEdA=;
	h=Date:To:From:Subject:From;
	b=gy9paCDx9CrJyfMsXWFSeaGl6GA+a9VO1D9Q0kk5AlycG6OuhNvnZGINLO/OrWln0
	 +HyIRHxlxD6hyePtph5+CE8htfVMFnszWIm2aJXWknS14mZKSTFkMsNXgXucoIkEF3
	 r6T1AR0WiXZag1wT9PhDaEi9eXofzH4rxEcCWkws=
Date: Wed, 03 Apr 2024 12:14:58 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-convert-gather_stats-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240403191459.9D22FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: convert gather_stats to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     proc-convert-gather_stats-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-convert-gather_stats-to-use-a-folio.patch

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
Subject: proc: convert gather_stats to use a folio
Date: Wed, 3 Apr 2024 18:14:52 +0100

Patch series "Use folio APIs in procfs".

We're down to very few users of the PageFoo macros, with proc being a
major user.

After this patchset and another patchset I have for khugepaged, we can get
rid of PageActive, PageReadahead and PageSwapBacked.  This patchset has
the usual advantages in its own right of removing hidden calls to
compound_head().  We have the page table lock, so the mapcount & refcount
are stable and there can't be any races with folios suddenly becoming tail
pages.


This patch (of 4):

Replaces six calls to compound_head() with one.  Shrinks the function from
5054 bytes to 1756 bytes in an allmodconfig build.

Link: https://lkml.kernel.org/r/20240403171456.1445117-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240403171456.1445117-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-gather_stats-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -2549,28 +2549,29 @@ struct numa_maps_private {
 static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty,
 			unsigned long nr_pages)
 {
+	struct folio *folio = page_folio(page);
 	int count = page_mapcount(page);
 
 	md->pages += nr_pages;
-	if (pte_dirty || PageDirty(page))
+	if (pte_dirty || folio_test_dirty(folio))
 		md->dirty += nr_pages;
 
-	if (PageSwapCache(page))
+	if (folio_test_swapcache(folio))
 		md->swapcache += nr_pages;
 
-	if (PageActive(page) || PageUnevictable(page))
+	if (folio_test_active(folio) || folio_test_unevictable(folio))
 		md->active += nr_pages;
 
-	if (PageWriteback(page))
+	if (folio_test_writeback(folio))
 		md->writeback += nr_pages;
 
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		md->anon += nr_pages;
 
 	if (count > md->mapcount_max)
 		md->mapcount_max = count;
 
-	md->node[page_to_nid(page)] += nr_pages;
+	md->node[folio_nid(folio)] += nr_pages;
 }
 
 static struct page *can_gather_numa_stats(pte_t pte, struct vm_area_struct *vma,
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

