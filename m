Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98399154C05
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171704; cv=none; b=rMgwwZJu/uPO4XT1K3cTlAoLpS+S1NmO0C61+r9LY9DN1wblCJzmP3xec8eTDZNWnEx9jllPm0SrLSFxQkg5axIM6llnb5oceYlZfwgCBGKOSlx6kjX09/Nx+DNp8TiQxJML2tcbK2/q40k5cbZ7IngLbhCVz1QuSYCFHzQDZNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171704; c=relaxed/simple;
	bh=i96wsqwq/+DqpoF8ms7jLJf29/W1HVQVVwO0XAPU2bQ=;
	h=Date:To:From:Subject:Message-Id; b=enTYQKaUK2RIeNPZudSU7He5yKqYl2PRUIT2XJ1l0JGWIrMo0cllo68oXv4alzBR2C1/SDL8YondfJW90o02h1+MlpEzcmYkSXNnKEgcAl5fxhG1SiaxqU0g2MsUELg6Ru+EjSyRjkxtUrMVBdni7jQAV+FriXxKfvDCBqwUfGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JiFbucyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JiFbucyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27614C433C7;
	Wed,  3 Apr 2024 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171704;
	bh=i96wsqwq/+DqpoF8ms7jLJf29/W1HVQVVwO0XAPU2bQ=;
	h=Date:To:From:Subject:From;
	b=JiFbucyCBSpot9a8W3E/4cLQFMU7wOo4Bouh6iTjJQulbuGeI0NfbE59gU6Ju2HKA
	 gF8R/ihxZpGuDnH5bJaPxAztpf5wAaQl+fZrIOvexN/qOm4Rt8jz1mGJQCnrDaMR0b
	 a7CI3YvP8xBO1GxZAa4IavKVDSVLpIfhHuDhdS5I=
Date: Wed, 03 Apr 2024 12:15:03 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-convert-smaps_pmd_entry-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240403191504.27614C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: convert smaps_pmd_entry to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     proc-convert-smaps_pmd_entry-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-convert-smaps_pmd_entry-to-use-a-folio.patch

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
Subject: proc: convert smaps_pmd_entry to use a folio
Date: Wed, 3 Apr 2024 18:14:55 +0100

Replace two calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20240403171456.1445117-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-smaps_pmd_entry-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -578,6 +578,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	struct folio *folio;
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
@@ -592,11 +593,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-	if (PageAnon(page))
+	folio = page_folio(page);
+	if (folio_test_anon(folio))
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
-	else if (PageSwapBacked(page))
+	else if (folio_test_swapbacked(folio))
 		mss->shmem_thp += HPAGE_PMD_SIZE;
-	else if (is_zone_device_page(page))
+	else if (folio_is_zone_device(folio))
 		/* pass */;
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
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

