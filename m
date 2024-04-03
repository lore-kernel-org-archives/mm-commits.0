Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F771552E2
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171701; cv=none; b=GsB/Ri5IARtpyb32FQQT1oqgp6igSv2KpeWyz1SNeM75/ggEdLPcU0KNW/AsD/D4/bKXE6JNJwTDjkOgizH52kgLpQNCGYAAFklcE2k2ZzlwQeau2obNstFUyvGpF4syPoRbVFuk8G8y/xtbXB/reGV/WjDczyWfMbQvT9lqeEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171701; c=relaxed/simple;
	bh=hMszRNv6uC8QIdup0Bj7X3cO59lvAYV9mXqIViwHqIw=;
	h=Date:To:From:Subject:Message-Id; b=RrmFTOeuY+et0t3ZzNsZKABR/Dciw/u+ht2l1DWuwcy1owsoZnvvzZE/0ozm2M3QwdJZV4joC05cE3UMmulqpwOLkrb/Bbq7uUS+EOxSLGfCciNffvdew4jWK47gf69tU7uhbRwEIpBtSrzr1Nzp34PrcnwSz4y6GIuS9l0ch2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdwbEyp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdwbEyp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1743FC433F1;
	Wed,  3 Apr 2024 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171701;
	bh=hMszRNv6uC8QIdup0Bj7X3cO59lvAYV9mXqIViwHqIw=;
	h=Date:To:From:Subject:From;
	b=ZdwbEyp2SgesK+miWOkqI9ahNJjF2cbzAyKrVPsktcBgewoW39DbqwhjtjZJz7E5Y
	 klB+MygrsSoRP2KpiGhgh9EpfMV63578N6a1/W7j/zLcDnWXQwpI5hB8I6N8VkR0Aq
	 hII8HzwSS7tVCxttYYnarR86wweGdETetyQiq8sw=
Date: Wed, 03 Apr 2024 12:15:00 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-convert-smaps_page_accumulate-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240403191501.1743FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: convert smaps_page_accumulate to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     proc-convert-smaps_page_accumulate-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-convert-smaps_page_accumulate-to-use-a-folio.patch

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
Subject: proc: convert smaps_page_accumulate to use a folio
Date: Wed, 3 Apr 2024 18:14:53 +0100

Replaces three calls to compound_head() with one.  Shrinks the function
from 2614 bytes to 1112 bytes in an allmodconfig build.

Link: https://lkml.kernel.org/r/20240403171456.1445117-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-smaps_page_accumulate-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -414,11 +414,12 @@ static void smaps_page_accumulate(struct
 		struct page *page, unsigned long size, unsigned long pss,
 		bool dirty, bool locked, bool private)
 {
+	struct folio *folio = page_folio(page);
 	mss->pss += pss;
 
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		mss->pss_anon += pss;
-	else if (PageSwapBacked(page))
+	else if (folio_test_swapbacked(folio))
 		mss->pss_shmem += pss;
 	else
 		mss->pss_file += pss;
@@ -426,7 +427,7 @@ static void smaps_page_accumulate(struct
 	if (locked)
 		mss->pss_locked += pss;
 
-	if (dirty || PageDirty(page)) {
+	if (dirty || folio_test_dirty(folio)) {
 		mss->pss_dirty += pss;
 		if (private)
 			mss->private_dirty += size;
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

