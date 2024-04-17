Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85143D966
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713386867; cv=none; b=ftsaY9IbJoAJTqL0VXGN9RYuyt6QDyN8ihh+dBCnqpSqW8Gh8YrBNvSwM+vUjXVWhWWy5SJ8fx2R65sUnw0bhrH1+3cgjKpccAPeyOfawm8wDAOtJZsw5OFEBwCnR0UHd/mTxZkdvhoBNf6lYFar5qpcOd3TA929Uanw7jqNn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713386867; c=relaxed/simple;
	bh=d3K6C5qgUjmgAQhz7RU8z4PVvs8o/7j1jNG5xCObL08=;
	h=Date:To:From:Subject:Message-Id; b=Tp6gTbrzRUiLGk0GheaH4FUgzv/m+NKfp9z7416UHoQZSdMH+128bgQWUau94s+zA46Gn/l32jgn/RFtKCqTG9EpAvpHw4e68HvrGz19iSA1dihiLBg6+n4GqBF6wkoeYgrejh2geBnM/r3fG6l6781g6PWQgyBkm+LITEPSZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vCEYV9/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vCEYV9/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC66C072AA;
	Wed, 17 Apr 2024 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713386867;
	bh=d3K6C5qgUjmgAQhz7RU8z4PVvs8o/7j1jNG5xCObL08=;
	h=Date:To:From:Subject:From;
	b=vCEYV9/2LVQ3yhePEIr+c2s8uL+bXtfNWkP7ibpvKyivPdt3/C2YGkWUWWtFnVwgJ
	 iyN4vqldgv3/N8pa/rbokzQL9OnotsYvxh+Ppa3/e9TIjCkBzeQ54PRsJg+QP7j80/
	 TchJ2wuqHWeFNp3d47bUhlFW+bnd546oLlWZmE2c=
Date: Wed, 17 Apr 2024 13:47:46 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch added to mm-unstable branch
Message-Id: <20240417204747.3BC66C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: convert smaps_hugetlb_range() to work on folios
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: convert smaps_hugetlb_range() to work on folios
Date: Wed, 17 Apr 2024 11:23:13 +0200

Let's get rid of another page_mapcount() check and simply use
folio_likely_mapped_shared(), which is precise for hugetlb folios.

While at it, use huge_ptep_get() + pte_page() instead of ptep_get() +
vm_normal_page(), just like we do in pagemap_hugetlb_range().

No functional change intended.

Link: https://lkml.kernel.org/r/20240417092313.753919-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios
+++ a/fs/proc/task_mmu.c
@@ -730,19 +730,20 @@ static int smaps_hugetlb_range(pte_t *pt
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	struct page *page = NULL;
-	pte_t ptent = ptep_get(pte);
+	pte_t ptent = huge_ptep_get(pte);
+	struct folio *folio = NULL;
 
 	if (pte_present(ptent)) {
-		page = vm_normal_page(vma, addr, ptent);
+		folio = page_folio(pte_page(ptent));
 	} else if (is_swap_pte(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
 		if (is_pfn_swap_entry(swpent))
-			page = pfn_swap_entry_to_page(swpent);
+			folio = pfn_swap_entry_folio(swpent);
 	}
-	if (page) {
-		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
+	if (folio) {
+		if (folio_likely_mapped_shared(folio) ||
+		    hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch
drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

